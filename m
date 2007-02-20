Return-Path: <linux-kernel-owner+w=401wt.eu-S1030496AbXBTWR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030496AbXBTWR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 17:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030497AbXBTWR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 17:17:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030496AbXBTWR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 17:17:57 -0500
X-Originating-IP: [172.16.81.92]
From: "Chris Snook" <csnook@redhat.com>
To: "Chris Snook" <csnook@redhat.com>, linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, dhowells@redhat.com, jeffpc@josefsipek.net,
       csnook@redhat.com
In-Reply-To: <20070220.waF.48959600@egw.corp.redhat.com>
Subject: [PATCH 2/2] use use =?UTF-8?Q?SEEK=5FMAX=20to=20validate=20user=20lseek?=
 =?UTF-8?Q?=20arguments?=
Date: Tue, 20 Feb 2007 17:05:33 -0500
Message-ID: <20070220.399.99798900@egw.corp.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
X-Mailer: AngleMail for eGroupWare (http://www.egroupware.org) v 1.2.106
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Snook <csnook@redhat.com>

Add SEEK_MAX and use it to validate lseek arguments from userspace.

Signed-off-by: Chris Snook <csnook@redhat.com>
--
diff -urp b/fs/read_write.c c/fs/read_write.c
--- b/fs/read_write.c	2007-02-20 16:48:39.000000000 -0500
+++ c/fs/read_write.c	2007-02-20 16:55:46.000000000 -0500
@@ -139,7 +139,7 @@ asmlinkage off_t sys_lseek(unsigned int
 		goto bad;

 	retval = -EINVAL;
-	if (origin <= 2) {
+	if (origin <= SEEK_MAX) {
 		loff_t res = vfs_llseek(file, offset, origin);
 		retval = res;
 		if (res != (loff_t)retval)
@@ -166,7 +166,7 @@ asmlinkage long sys_llseek(unsigned int
 		goto bad;

 	retval = -EINVAL;
-	if (origin > 2)
+	if (origin > SEEK_MAX)
 		goto out_putf;

 	offset = vfs_llseek(file, ((loff_t) offset_high << 32) | offset_low,
diff -urp b/include/linux/fs.h c/include/linux/fs.h
--- b/include/linux/fs.h	2007-02-20 14:49:46.000000000 -0500
+++ c/include/linux/fs.h	2007-02-20 16:54:30.000000000 -0500
@@ -30,6 +30,7 @@
 #define SEEK_SET	0	/* seek relative to beginning of file */
 #define SEEK_CUR	1	/* seek relative to current file position */
 #define SEEK_END	2	/* seek relative to end of file */
+#define SEEK_MAX	SEEK_END

 /* And dynamically-tunable limits and defaults: */
 struct files_stat_struct {

