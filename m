Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbXKEQ63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbXKEQ63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 11:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbXKEQ6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 11:58:14 -0500
Received: from styx.suse.cz ([82.119.242.94]:38616 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754825AbXKEQ6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 11:58:12 -0500
Date: Mon, 5 Nov 2007 17:58:10 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org,
       LIOU Payphone <lioupayphone@gmail.com>, Andreas Schwab <schwab@suse.de>
Subject: Re: [PATCH] Forbid user to change file flags on quota files
Message-ID: <20071105165810.GF9561@duck.suse.cz>
References: <20071101155204.GB30523@duck.suse.cz> <Pine.LNX.4.64.0711021831340.26618@fbirervta.pbzchgretzou.qr> <20071105103230.GA9561@duck.suse.cz> <jefxzlas0q.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jefxzlas0q.fsf@sykes.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 05-11-07 11:47:01, Andreas Schwab wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> > On Fri 02-11-07 18:32:08, Jan Engelhardt wrote:
> >> 
> >> On Nov 1 2007 16:52, Jan Kara wrote:
> >> 
> >> >--- linux-2.6.24-rc1/fs/ext2/ioctl.c	2007-10-24 20:43:56.000000000 +0200
> >> >+++ linux-2.6.24-rc1-1-forbid_setflags/fs/ext2/ioctl.c	2007-11-01 16:01:26.000000000 +0100
> >> >@@ -47,6 +47,11 @@ int ext2_ioctl (struct inode * inode, st
> >> > 			flags &= ~EXT2_DIRSYNC_FL;
> >> > 
> >> > 		mutex_lock(&inode->i_mutex);
> >> >+		/* Is it quota file? Don't allow user mess with it */
> >> 
> >> "Do not allow user to mess with it".
> >   I think both "allow user mess" and "allow user to mess" are possible,
> 
> I think it's either "to allow doing sth" or "to allow to do sth", but
> "to allow do sth" looks definitely wrong to me.
  OK, you've convinced me :). Andrew, please fold this patch in the
previous one. Thanks.
								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

A grammar correction in a comment.

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-1-forbid_setflags/fs/ext2/ioctl.c linux-2.6.23-2-comment_fix/fs/ext2/ioctl.c
--- linux-2.6.23-1-forbid_setflags/fs/ext2/ioctl.c	2007-11-01 16:19:00.000000000 +0100
+++ linux-2.6.23-2-comment_fix/fs/ext2/ioctl.c	2007-11-05 17:53:53.000000000 +0100
@@ -46,7 +46,7 @@ int ext2_ioctl (struct inode * inode, st
 			flags &= ~EXT2_DIRSYNC_FL;
 
 		mutex_lock(&inode->i_mutex);
-		/* Is it quota file? Don't allow user mess with it */
+		/* Is it quota file? Do not allow user to mess with it */
 		if (IS_NOQUOTA(inode)) {
 			mutex_unlock(&inode->i_mutex);
 			return -EPERM;
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-1-forbid_setflags/fs/ext3/ioctl.c linux-2.6.23-2-comment_fix/fs/ext3/ioctl.c
--- linux-2.6.23-1-forbid_setflags/fs/ext3/ioctl.c	2007-11-01 16:19:00.000000000 +0100
+++ linux-2.6.23-2-comment_fix/fs/ext3/ioctl.c	2007-11-05 17:54:00.000000000 +0100
@@ -51,7 +51,7 @@ int ext3_ioctl (struct inode * inode, st
 			flags &= ~EXT3_DIRSYNC_FL;
 
 		mutex_lock(&inode->i_mutex);
-		/* Is it quota file? Don't allow user mess with it */
+		/* Is it quota file? Do not allow user to mess with it */
 		if (IS_NOQUOTA(inode)) {
 			mutex_unlock(&inode->i_mutex);
 			return -EPERM;
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-1-forbid_setflags/fs/ext4/ioctl.c linux-2.6.23-2-comment_fix/fs/ext4/ioctl.c
--- linux-2.6.23-1-forbid_setflags/fs/ext4/ioctl.c	2007-11-01 16:19:00.000000000 +0100
+++ linux-2.6.23-2-comment_fix/fs/ext4/ioctl.c	2007-11-05 17:54:07.000000000 +0100
@@ -51,7 +51,7 @@ int ext4_ioctl (struct inode * inode, st
 			flags &= ~EXT4_DIRSYNC_FL;
 
 		mutex_lock(&inode->i_mutex);
-		/* Is it quota file? Don't allow user mess with it */
+		/* Is it quota file? Do not allow user to mess with it */
 		if (IS_NOQUOTA(inode)) {
 			mutex_unlock(&inode->i_mutex);
 			return -EPERM;
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-1-forbid_setflags/fs/jfs/ioctl.c linux-2.6.23-2-comment_fix/fs/jfs/ioctl.c
--- linux-2.6.23-1-forbid_setflags/fs/jfs/ioctl.c	2007-11-01 16:19:00.000000000 +0100
+++ linux-2.6.23-2-comment_fix/fs/jfs/ioctl.c	2007-11-05 17:53:39.000000000 +0100
@@ -79,7 +79,7 @@ int jfs_ioctl(struct inode * inode, stru
 		if (!S_ISDIR(inode->i_mode))
 			flags &= ~JFS_DIRSYNC_FL;
 
-		/* Is it quota file? Don't allow user mess with it */
+		/* Is it quota file? Do not allow user to mess with it */
 		if (IS_NOQUOTA(inode))
 			return -EPERM;
 		jfs_get_inode_flags(jfs_inode);
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-1-forbid_setflags/fs/reiserfs/ioctl.c linux-2.6.23-2-comment_fix/fs/reiserfs/ioctl.c
--- linux-2.6.23-1-forbid_setflags/fs/reiserfs/ioctl.c	2007-11-01 16:19:00.000000000 +0100
+++ linux-2.6.23-2-comment_fix/fs/reiserfs/ioctl.c	2007-11-05 17:53:47.000000000 +0100
@@ -57,7 +57,7 @@ int reiserfs_ioctl(struct inode *inode, 
 			if (get_user(flags, (int __user *)arg))
 				return -EFAULT;
 
-			/* Is it quota file? Don't allow user mess with it. */
+			/* Is it quota file? Do not allow user to mess with it. */
 			if (IS_NOQUOTA(inode))
 				return -EPERM;
 			if (((flags ^ REISERFS_I(inode)->
