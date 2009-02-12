Return-Path: <linux-kernel-owner+w=401wt.eu-S1758275AbZBLKfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275AbZBLKfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 05:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755085AbZBLKfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 05:35:22 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:45634 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbZBLKfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 05:35:21 -0500
Subject: vfs: Improve readability off mount flag definitins by using offsets
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
Date: Thu, 12 Feb 2009 19:35:20 +0900
Message-Id: <1234434920.15433.2.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently mount flags are defined using both decimal values and offsets which
is kind of confusing. Define all flags using offsets for the sake of
readability.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.29-rc3-orig/include/linux/fs.h linux-2.6.29-rc3/include/linux/fs.h
--- linux-2.6.29-rc3-orig/include/linux/fs.h	2009-01-29 09:47:51.000000000 +0900
+++ linux-2.6.29-rc3/include/linux/fs.h	2009-01-29 10:01:58.000000000 +0900
@@ -111,22 +111,22 @@ struct inodes_stat_t {
 /*
  * These are the fs-independent mount-flags: up to 32 flags are supported
  */
-#define MS_RDONLY	 1	/* Mount read-only */
-#define MS_NOSUID	 2	/* Ignore suid and sgid bits */
-#define MS_NODEV	 4	/* Disallow access to device special files */
-#define MS_NOEXEC	 8	/* Disallow program execution */
-#define MS_SYNCHRONOUS	16	/* Writes are synced at once */
-#define MS_REMOUNT	32	/* Alter flags of a mounted FS */
-#define MS_MANDLOCK	64	/* Allow mandatory locks on an FS */
-#define MS_DIRSYNC	128	/* Directory modifications are synchronous */
-#define MS_NOATIME	1024	/* Do not update access times. */
-#define MS_NODIRATIME	2048	/* Do not update directory access times */
-#define MS_BIND		4096
-#define MS_MOVE		8192
-#define MS_REC		16384
-#define MS_VERBOSE	32768	/* War is peace. Verbosity is silence.
+#define MS_RDONLY	(1<<0)	/* Mount read-only */
+#define MS_NOSUID	(1<<1)	/* Ignore suid and sgid bits */
+#define MS_NODEV	(1<<2)	/* Disallow access to device special files */
+#define MS_NOEXEC	(1<<3)	/* Disallow program execution */
+#define MS_SYNCHRONOUS	(1<<4)	/* Writes are synced at once */
+#define MS_REMOUNT	(1<<5)	/* Alter flags of a mounted FS */
+#define MS_MANDLOCK	(1<<6)	/* Allow mandatory locks on an FS */
+#define MS_DIRSYNC	(1<<7)	/* Directory modifications are synchronous */
+#define MS_NOATIME	(1<<10)	/* Do not update access times. */
+#define MS_NODIRATIME	(1<<11)	/* Do not update directory access times */
+#define MS_BIND		(1<<12)
+#define MS_MOVE		(1<<13)
+#define MS_REC		(1<<14)
+#define MS_VERBOSE	(1<<15)	/* War is peace. Verbosity is silence.
 				   MS_VERBOSE is deprecated. */
-#define MS_SILENT	32768
+#define MS_SILENT	(1<<15)
 #define MS_POSIXACL	(1<<16)	/* VFS does not apply the umask */
 #define MS_UNBINDABLE	(1<<17)	/* change to unbindable */
 #define MS_PRIVATE	(1<<18)	/* change to private */


