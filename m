Return-Path: <linux-kernel-owner+w=401wt.eu-S1758381AbZBLKhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381AbZBLKhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 05:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757444AbZBLKhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 05:37:10 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:45805 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756844AbZBLKhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 05:37:08 -0500
Subject: util-linux: Add new mount options flushonfsync and noflushonfsync
	to mount
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
Date: Thu, 12 Feb 2009 19:37:06 +0900
Message-Id: <1234435026.15433.7.camel@sebastian.kern.oss.ntt.co.jp>
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

diff -urp mount-orig/mount.c mount/mount.c
--- mount-orig/mount.c	2009-01-29 15:50:50.000000000 +0900
+++ mount/mount.c	2009-01-29 14:56:19.000000000 +0900
@@ -185,6 +185,13 @@ static const struct opt_map opt_map[] = 
   { "norelatime", 0, 1, MS_RELATIME }, /* Update access time without regard
 					  to mtime/ctime */
 #endif
+#ifdef MS_FLUSHONFSYNC
+  { "flushonfsync", 0, 0, MS_FLUSHONFSYNC },	/* Force block device flush on
+						   fsync()/fdatasync() */
+  { "noflushonfsync", 0, 1, MS_FLUSHONFSYNC },	/* Do not force block device
+						   flush on
+						   fsync()/fdatasync() */
+#endif
   { "nofail",	0, 0, MS_COMMENT},	/* Do not fail if ENOENT on dev */
   { NULL,	0, 0, 0		}
 };
diff -urp mount-orig/mount_constants.h mount/mount_constants.h
--- mount-orig/mount_constants.h	2008-04-22 17:59:53.000000000 +0900
+++ mount/mount_constants.h	2009-01-29 13:40:42.000000000 +0900
@@ -56,6 +56,10 @@
 #ifndef MS_SHARED
 #define MS_SHARED	(1<<20)	/* 1048576 Shared*/
 #endif
+#ifndef MS_FLUSHONFSYNC
+#define MS_FLUSHONFSYNC	(1<<24) /* Force block device flush on
+				   fsync()/fdatasync() */
+#endif
 /*
  * Magic mount flag number. Had to be or-ed to the flag values.
  */


