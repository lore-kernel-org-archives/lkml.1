Return-Path: <linux-kernel-owner+w=401wt.eu-S933149AbYAaKkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149AbYAaKkI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 05:40:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933292AbYAaKjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 05:39:20 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:20179 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933289AbYAaKjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 05:39:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=J1MfIkUO/1eZYxtUryuq18qRYpzBdv5359lI0YhHU7tBxAm9+wKzZQnMSINnA2MEgdCYAKG53A+WRZ7trsfIjS64K5y2p5yseODhHenTfU4m5FozBMTag9zeu+3x1I4KORJKVSQcubTnEN4iuKF4DEl5GTbOqzc0lsFBVI256UM=
From: Denis Cheng <crquan@gmail.com>
To: Alexander Viro <viro@www.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fs/char_dev.c: chrdev_open marked static and removed from fs.h
Date: Thu, 31 Jan 2008 18:39:30 +0800
Message-Id: <1201775970-15553-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

there is an outdated comment in serial_core.c also fixed.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 drivers/serial/serial_core.c |    4 ++--
 fs/char_dev.c                |    2 +-
 include/linux/fs.h           |    1 -
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 3bb5d24..2f0b61c 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -1550,8 +1550,8 @@ static struct uart_state *uart_get(struct uart_driver *drv, int line)
 }
 
 /*
- * In 2.4.5, calls to uart_open are serialised by the BKL in
- *   linux/fs/devices.c:chrdev_open()
+ * calls to uart_open are serialised by the BKL in
+ *   fs/char_dev.c:chrdev_open()
  * Note that if this fails, then uart_close() _will_ be called.
  *
  * In time, we want to scrap the "opening nonpresent ports"
diff --git a/fs/char_dev.c b/fs/char_dev.c
index 2c7a8b5..038674a 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -357,7 +357,7 @@ void cdev_put(struct cdev *p)
 /*
  * Called every time a character special file is opened
  */
-int chrdev_open(struct inode * inode, struct file * filp)
+static int chrdev_open(struct inode *inode, struct file *filp)
 {
 	struct cdev *p;
 	struct cdev *new = NULL;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a516b67..a5fb302 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1620,7 +1620,6 @@ extern int register_chrdev(unsigned int, const char *,
 			   const struct file_operations *);
 extern void unregister_chrdev(unsigned int, const char *);
 extern void unregister_chrdev_region(dev_t, unsigned);
-extern int chrdev_open(struct inode *, struct file *);
 extern void chrdev_show(struct seq_file *,off_t);
 
 /* fs/block_dev.c */
-- 
1.5.3.8

