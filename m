Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbXKEKck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbXKEKck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 05:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbXKEKcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 05:32:33 -0500
Received: from styx.suse.cz ([82.119.242.94]:51998 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753589AbXKEKcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 05:32:33 -0500
Date: Mon, 5 Nov 2007 11:32:30 +0100
From: Jan Kara <jack@suse.cz>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel@vger.kernel.org, LIOU Payphone <lioupayphone@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Forbid user to change file flags on quota files
Message-ID: <20071105103230.GA9561@duck.suse.cz>
References: <20071101155204.GB30523@duck.suse.cz> <Pine.LNX.4.64.0711021831340.26618@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711021831340.26618@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 02-11-07 18:32:08, Jan Engelhardt wrote:
> 
> On Nov 1 2007 16:52, Jan Kara wrote:
> 
> >--- linux-2.6.24-rc1/fs/ext2/ioctl.c	2007-10-24 20:43:56.000000000 +0200
> >+++ linux-2.6.24-rc1-1-forbid_setflags/fs/ext2/ioctl.c	2007-11-01 16:01:26.000000000 +0100
> >@@ -47,6 +47,11 @@ int ext2_ioctl (struct inode * inode, st
> > 			flags &= ~EXT2_DIRSYNC_FL;
> > 
> > 		mutex_lock(&inode->i_mutex);
> >+		/* Is it quota file? Don't allow user mess with it */
> 
> "Do not allow user to mess with it".
  I think both "allow user mess" and "allow user to mess" are possible, maybe
with a slightly different meanings. If you are confident that the first one
is not correct in this place, I can change it :)

> >--- linux-2.6.24-rc1/fs/ext3/ioctl.c	2007-10-11 12:01:23.000000000 +0200
> >--- linux-2.6.24-rc1/fs/ext4/ioctl.c	2007-10-11 12:01:23.000000000 +0200
> >--- linux-2.6.24-rc1/fs/jfs/ioctl.c	2007-10-11 12:01:23.000000000 +0200
> >--- linux-2.6.24-rc1/fs/reiserfs/ioctl.c	2007-10-24 20:43:58.000000000 +0200
> 
> And the other filesystems are all fine?
  I'm not sure what you mean... Forbidding IOC_SETFLAGS for them on quota
files is fine.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
