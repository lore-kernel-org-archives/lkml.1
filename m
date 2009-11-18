Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbZKRRON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbZKRRON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 12:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757916AbZKRROM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 12:14:12 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40388 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757923AbZKRROM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 12:14:12 -0500
Date: Wed, 18 Nov 2009 17:15:24 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Blunck <jblunck@suse.de>
Cc: linux-fsdevel@vger.kernel.org,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, Jan Blunck <jblunck@suse.de>,
       Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
       =?ISO-8859-14?B?RnLpZOlyaWM=?= Weisbecker <fweisbec@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/2] BKL: Remove BKL from default_llseek()
Message-ID: <20091118171524.4d2f8cec@lxorguk.ukuu.org.uk>
In-Reply-To: <1258560457-15129-1-git-send-email-jblunck@suse.de>
References: <1258560457-15129-1-git-send-email-jblunck@suse.de>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Using the BKL in llseek() does not protect the inode's i_size from
> modification since the i_size is protected by a seqlock nowadays. Since
> default_llseek() is already using the i_size_read() wrapper it is not the
> BKL which is serializing the access here.
> The access to file->f_pos is not protected by the BKL either since its
> access in vfs_write()/vfs_read() is not protected by any lock. If the BKL
> is not protecting anything here it can clearly get removed.

No. Your logic is flawed

The BKL is protected something here - it protects the change of offset
with respect to other BKL users within drivers. The question is what if
anything in any other driver code depends upon the BKL and uses it to
protect f_pos. Probably very little if anything but a grep for f_pos
through the drivers might not be a bad idea before assuming this. Very
few touch f_pos except in their own llseek method.

