Return-Path: <linux-kernel-owner+w=401wt.eu-S1759357AbXKBRcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357AbXKBRcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbXKBRcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:32:11 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:33348 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbXKBRcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:32:11 -0400
Date: Fri, 2 Nov 2007 18:32:08 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jan Kara <jack@suse.cz>
cc: linux-kernel@vger.kernel.org, LIOU Payphone <lioupayphone@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Forbid user to change file flags on quota files
In-Reply-To: <20071101155204.GB30523@duck.suse.cz>
Message-ID: <Pine.LNX.4.64.0711021831340.26618@fbirervta.pbzchgretzou.qr>
References: <20071101155204.GB30523@duck.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 1 2007 16:52, Jan Kara wrote:

>--- linux-2.6.24-rc1/fs/ext2/ioctl.c	2007-10-24 20:43:56.000000000 +0200
>+++ linux-2.6.24-rc1-1-forbid_setflags/fs/ext2/ioctl.c	2007-11-01 16:01:26.000000000 +0100
>@@ -47,6 +47,11 @@ int ext2_ioctl (struct inode * inode, st
> 			flags &= ~EXT2_DIRSYNC_FL;
> 
> 		mutex_lock(&inode->i_mutex);
>+		/* Is it quota file? Don't allow user mess with it */

"Do not allow user to mess with it".

>--- linux-2.6.24-rc1/fs/ext3/ioctl.c	2007-10-11 12:01:23.000000000 +0200
>--- linux-2.6.24-rc1/fs/ext4/ioctl.c	2007-10-11 12:01:23.000000000 +0200
>--- linux-2.6.24-rc1/fs/jfs/ioctl.c	2007-10-11 12:01:23.000000000 +0200
>--- linux-2.6.24-rc1/fs/reiserfs/ioctl.c	2007-10-24 20:43:58.000000000 +0200

And the other filesystems are all fine?
