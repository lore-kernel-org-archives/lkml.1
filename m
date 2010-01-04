Return-Path: <linux-kernel-owner+w=401wt.eu-S1753593Ab0ADQoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab0ADQoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 11:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446Ab0ADQom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 11:44:42 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48869 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753420Ab0ADQom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 11:44:42 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] sonypi: Kill off the BKL in the ioctl
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 04 Jan 2010 16:21:27 +0000
Message-ID: <20100104162107.16880.67633.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And another thats been ignored for several months

--

All the internal logic is protected properly by the existing mutex locking

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/sonypi.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
index 0798754..6a574bf 100644
--- a/drivers/char/sonypi.c
+++ b/drivers/char/sonypi.c
@@ -955,8 +955,8 @@ static unsigned int sonypi_misc_poll(struct file *file, poll_table *wait)
 	return 0;
 }
 
-static int sonypi_misc_ioctl(struct inode *ip, struct file *fp,
-			     unsigned int cmd, unsigned long arg)
+static long sonypi_misc_ioctl(struct file *fp,
+					unsigned int cmd, unsigned long arg)
 {
 	int ret = 0;
 	void __user *argp = (void __user *)arg;
@@ -1074,7 +1074,7 @@ static const struct file_operations sonypi_misc_fops = {
 	.open		= sonypi_misc_open,
 	.release	= sonypi_misc_release,
 	.fasync		= sonypi_misc_fasync,
-	.ioctl		= sonypi_misc_ioctl,
+	.unlocked_ioctl	= sonypi_misc_ioctl,
 };
 
 static struct miscdevice sonypi_misc_device = {

