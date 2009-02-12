Return-Path: <linux-kernel-owner+w=401wt.eu-S1758567AbZBLKgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567AbZBLKgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 05:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755564AbZBLKgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 05:36:13 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:45710 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976AbZBLKgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 05:36:12 -0500
Subject: vfs: Add MS_FLUSHONFSYNC mount flag
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Jan Kara <jack@suse.cz>
Cc: Theodore Tso <tytso@MIT.EDU>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, sandeen@redhat.com,
       fernando@kic.ac.jp
In-Reply-To: <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp>
References: <20090114165952.GH6222@mit.edu>
	 <1232021211.14626.19.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090115234544.GA7579@duck.suse.cz>
	 <1232109069.13775.35.camel@sebastian.kern.oss.ntt.co.jp>
	 <1232114101.13775.63.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090116163039.GE10617@duck.suse.cz>
	 <1232185639.4831.18.camel@sebastian.kern.oss.ntt.co.jp>
	 <1232186449.4831.29.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090119120349.GA10193@duck.suse.cz>
	 <1233135913.5399.57.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090128095518.GA16554@duck.suse.cz>
	 <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Thu, 12 Feb 2009 19:36:10 +0900
Message-Id: <1234434970.15433.4.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This mount flag will be used to determine whether the block device's write
cache should be flush or not on fsync()/fdatasync().

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.29-rc3-orig/fs/namespace.c linux-2.6.29-rc3/fs/namespace.c
--- linux-2.6.29-rc3-orig/fs/namespace.c	2009-01-29 09:47:51.000000000 +0900
+++ linux-2.6.29-rc3/fs/namespace.c	2009-01-29 18:40:04.000000000 +0900
@@ -1933,8 +1933,8 @@ long do_mount(char *dev_name, char *dir_
 	if (flags & MS_RDONLY)
 		mnt_flags |= MNT_READONLY;
 
-	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE |
-		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT);
+	flags &= ~(MS_NOSUID | MS_NODEV | MS_NOEXEC | MS_NOATIME |
+		   MS_NODIRATIME | MS_RELATIME | MS_ACTIVE | MS_KERNMOUNT);
 
 	/* ... and get the mountpoint */
 	retval = kern_path(dir_name, LOOKUP_FOLLOW, &path);
diff -urNp linux-2.6.29-rc3-orig/include/linux/fs.h linux-2.6.29-rc3/include/linux/fs.h
--- linux-2.6.29-rc3-orig/include/linux/fs.h	2009-01-29 10:04:18.000000000 +0900
+++ linux-2.6.29-rc3/include/linux/fs.h	2009-01-29 10:24:14.000000000 +0900
@@ -135,6 +135,8 @@ struct inodes_stat_t {
 #define MS_RELATIME	(1<<21)	/* Update atime relative to mtime/ctime. */
 #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
 #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
+#define MS_FLUSHONFSYNC (1<<24)	/* Force block device flush on
+				   fsync()/fdatasync() */
 #define MS_ACTIVE	(1<<30)
 #define MS_NOUSER	(1<<31)
 


