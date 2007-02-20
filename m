Return-Path: <linux-kernel-owner+w=401wt.eu-S1030477AbXBTWC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030477AbXBTWC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 17:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030479AbXBTWC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 17:02:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030477AbXBTWC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 17:02:56 -0500
X-Originating-IP: [172.16.81.92]
From: "Chris Snook" <csnook@redhat.com>
To: "Chris Snook" <csnook@redhat.com>, linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, dhowells@redhat.com, jeffpc@josefsipek.net,
       csnook@redhat.com
In-Reply-To: <20070220.waF.48959600@egw.corp.redhat.com>
Subject: [PATCH 1/2] use symbolic constants in generic lseek code
Date: Tue, 20 Feb 2007 17:01:51 -0500
Message-ID: <20070220.j9k.46008500@egw.corp.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
X-Mailer: AngleMail for eGroupWare (http://www.egroupware.org) v 1.2.106
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Snook <csnook@redhat.com>

Convert magic numbers to SEEK_* values from fs.h

Signed-off-by: Chris Snook <csnook@redhat.com>
--
--- a/fs/read_write.c	2007-02-20 14:49:45.000000000 -0500
+++ b/fs/read_write.c	2007-02-20 16:48:39.000000000 -0500
@@ -37,10 +37,10 @@ loff_t generic_file_llseek(struct file *

 	mutex_lock(&inode->i_mutex);
 	switch (origin) {
-		case 2:
+		case SEEK_END:
 			offset += inode->i_size;
 			break;
-		case 1:
+		case SEEK_CUR:
 			offset += file->f_pos;
 	}
 	retval = -EINVAL;
@@ -63,10 +63,10 @@ loff_t remote_llseek(struct file *file,

 	lock_kernel();
 	switch (origin) {
-		case 2:
+		case SEEK_END:
 			offset += i_size_read(file->f_path.dentry->d_inode);
 			break;
-		case 1:
+		case SEEK_CUR:
 			offset += file->f_pos;
 	}
 	retval = -EINVAL;
@@ -94,10 +94,10 @@ loff_t default_llseek(struct file *file,

 	lock_kernel();
 	switch (origin) {
-		case 2:
+		case SEEK_END:
 			offset += i_size_read(file->f_path.dentry->d_inode);
 			break;
-		case 1:
+		case SEEK_CUR:
 			offset += file->f_pos;
 	}
 	retval = -EINVAL;

