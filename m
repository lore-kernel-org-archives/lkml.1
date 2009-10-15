Return-Path: <linux-kernel-owner+w=401wt.eu-S1761541AbZJOKh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761541AbZJOKh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 06:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756937AbZJOKh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 06:37:57 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48805 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756908AbZJOKh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 06:37:56 -0400
X-Sasl-enc: odWVGrclBTWDtr+u2exPkWbrKuyvaLgdg5cmm2c/f5oH 1255603037
Date: Thu, 15 Oct 2009 18:37:09 +0800
From: Ian Kent <raven@themaw.net>
To: npiggin@suse.de
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 3/6] fs: dcache remove d_mounted
Message-ID: <20091015103707.GA23837@zeus.themaw.net>
References: <20091015044026.319860788@suse.de> <20091015050048.435915481@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091015050048.435915481@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 03:40:29PM +1100, npiggin@suse.de wrote:
> Rather than keep a d_mounted count in the dentry (which is only used to
> speculatively take a look in the mount hash table if it is non-zero), set a
> dentry flag instead. The flag can be cleared by checking the hash table to see
> if there are any mounts left. It is not time critical because it is performed
> at detach time.
> 
> This saves 4 bytes on 32-bit, nothing on 64-bit but it does provide a hole I
> might use later (and some configs have larger than 32-bit spinlocks which might
> make use of the hole).
> 
> Autofs4 conversion and changelog by Ian Kent <raven@themaw.net>:
> In autofs4, when expring direct (or offset) mounts we need to ensure that we
> block user path walks into the autofs mount, which is covered by another mount.
> To do this we clear the mounted status so that follows stop before walking into
> the mount and are essentially blocked until the expire is completed. The
> automount daemon still finds the correct dentry for the umount due to the
> follow mount logic in fs/autofs4/root.c:autofs4_follow_link(), which is set as
> an inode operation for direct and offset mounts only and is called following
> the lookup that stopped at the covered mount.
> 
> At the end of the expire the covering mount probably has gone away so the
> mounted status need not be restored. But we need to check this and only restore
> the mounted status if the expire failed.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>

For the autofs4 bits.

Acked-by: Ian Kent <raven@themaw.net>

