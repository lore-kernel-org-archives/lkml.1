Return-Path: <linux-kernel-owner+w=401wt.eu-S1756279AbZKRKle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbZKRKle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 05:41:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbZKRKld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 05:41:33 -0500
Received: from de01.mail.all-tld.net ([195.140.232.8]:56419 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbZKRKlc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 05:41:32 -0500
Date: Wed, 18 Nov 2009 11:41:21 +0100
From: Anders Larsen <al@alarsen.net>
Subject: Re: [PATCH 03/20] BKL: Explicitly add BKL around get_sb/fill_super
To: Jan Blunck <jblunck@suse.de>
Cc: linux-fsdevel@vger.kernel.org,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1258536293-7762-1-git-send-email-jblunck@suse.de>
	<1258536293-7762-4-git-send-email-jblunck@suse.de>
In-Reply-To: <1258536293-7762-4-git-send-email-jblunck@suse.de> (from
	jblunck@suse.de on Wed Nov 18 10:24:36 2009)
X-Mailer: Balsa 2.3.14
Message-Id: <1258540881l.14682l.0l@i-dmzi_al.realan.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-VirusScanner: Found to be clean
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-11-18 10:24:36, Jan Blunck wrote:
> This patch is a preparation necessary to remove the BKL from do_new_mount().
> It explicitly adds calls to lock_kernel()/unlock_kernel() around
> get_sb/fill_super operations for filesystems that still uses the BKL.
> 
> I've read through all the code formerly covered by the BKL inside
> do_kern_mount() and have satisfied myself that it doesn't need the BKL
> any more.
> 
> do_kern_mount() is already called without the BKL when mounting the rootfs
> and in nfsctl. do_kern_mount() calls vfs_kern_mount(), which is called
> from various places without BKL: simple_pin_fs(), nfs_do_clone_mount()
> through nfs_follow_mountpoint(), afs_mntpt_do_automount() through
> afs_mntpt_follow_link(). Both later functions are actually the filesystems
> follow_link inode operation. vfs_kern_mount() is calling the specified
> get_sb function and lets the filesystem do its job by calling the given
> fill_super function.
> 
> Therefore I think it is safe to push down the BKL from the VFS to the
> low-level filesystems get_sb/fill_super operation.
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> Cc: Matthew Wilcox <matthew@wil.cx>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Arnd Bergmann <arnd@arndb.de>

Wrt fs/qnx4:
Acked-by: Anders Larsen <al@alarsen.net>

