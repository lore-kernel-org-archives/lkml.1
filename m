Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021Ab0AHUkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab0AHUkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 15:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941Ab0AHUku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 15:40:50 -0500
Received: from [206.15.93.42] ([206.15.93.42]:31369 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753892Ab0AHUku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 15:40:50 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/char/cncs.c: remove unnecessary casts
Date: Fri, 8 Jan 2010 13:40:47 -0700
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001081340.47680.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/char/cncs.c: Remove unnecessary casts.

The struct file 'private_data' member is a void *, the casts are not needed.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/char/snsc.c b/drivers/char/snsc.c
index 32b74de..ae6aa91 100644
--- a/drivers/char/snsc.c
+++ b/drivers/char/snsc.c
@@ -129,7 +129,7 @@ scdrv_open(struct inode *inode, struct file *file)
 static int
 scdrv_release(struct inode *inode, struct file *file)
 {
-	struct subch_data_s *sd = (struct subch_data_s *) file->private_data;
+	struct subch_data_s *sd = file->private_data;
 	int rv;
 
 	/* free the interrupt */
@@ -161,7 +161,7 @@ scdrv_read(struct file *file, char __user *buf, size_t count, loff_t *f_pos)
 	int status;
 	int len;
 	unsigned long flags;
-	struct subch_data_s *sd = (struct subch_data_s *) file->private_data;
+	struct subch_data_s *sd = file->private_data;
 
 	/* try to get control of the read buffer */
 	if (down_trylock(&sd->sd_rbs)) {
@@ -253,7 +253,7 @@ scdrv_write(struct file *file, const char __user *buf,
 {
 	unsigned long flags;
 	int status;
-	struct subch_data_s *sd = (struct subch_data_s *) file->private_data;
+	struct subch_data_s *sd = file->private_data;
 
 	/* try to get control of the write buffer */
 	if (down_trylock(&sd->sd_wbs)) {
@@ -326,7 +326,7 @@ scdrv_poll(struct file *file, struct poll_table_struct *wait)
 {
 	unsigned int mask = 0;
 	int status = 0;
-	struct subch_data_s *sd = (struct subch_data_s *) file->private_data;
+	struct subch_data_s *sd = file->private_data;
 	unsigned long flags;
 
 	poll_wait(file, &sd->sd_rq, wait);
