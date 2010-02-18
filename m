Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757666Ab0BRRTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 12:19:22 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37414 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754830Ab0BRRTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 12:19:21 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Cameron <jic23@cam.ac.uk>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] staging: iio: Staticise non-exported functions
Date: Thu, 18 Feb 2010 17:19:17 +0000
Message-Id: <1266513557-32326-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Staticise a number of functions which aren't exported outside their
source files, and also add a __user annotation for the buffer in
iio_event_chrdev_read().

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/staging/iio/industrialio-core.c |   14 +++++++-------
 drivers/staging/iio/trigger_consumer.h  |    4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
index 4ff683a..b456dfc 100644
--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -118,7 +118,7 @@ int iio_push_event(struct iio_dev *dev_info,
 EXPORT_SYMBOL(iio_push_event);
 
 /* Generic interrupt line interrupt handler */
-irqreturn_t iio_interrupt_handler(int irq, void *_int_info)
+static irqreturn_t iio_interrupt_handler(int irq, void *_int_info)
 {
 	struct iio_interrupt *int_info = _int_info;
 	struct iio_dev *dev_info = int_info->dev_info;
@@ -252,10 +252,10 @@ void iio_remove_event_from_list(struct iio_event_handler_list *el,
 }
 EXPORT_SYMBOL(iio_remove_event_from_list);
 
-ssize_t iio_event_chrdev_read(struct file *filep,
-			      char *buf,
-			      size_t count,
-			      loff_t *f_ps)
+static ssize_t iio_event_chrdev_read(struct file *filep,
+				     char __user *buf,
+				     size_t count,
+				     loff_t *f_ps)
 {
 	struct iio_event_interface *ev_int = filep->private_data;
 	struct iio_detected_event_list *el;
@@ -313,7 +313,7 @@ error_ret:
 	return ret;
 }
 
-int iio_event_chrdev_release(struct inode *inode, struct file *filep)
+static int iio_event_chrdev_release(struct inode *inode, struct file *filep)
 {
 	struct iio_handler *hand = iio_cdev_to_handler(inode->i_cdev);
 	struct iio_event_interface *ev_int = hand->private;
@@ -335,7 +335,7 @@ int iio_event_chrdev_release(struct inode *inode, struct file *filep)
 	return 0;
 }
 
-int iio_event_chrdev_open(struct inode *inode, struct file *filep)
+static int iio_event_chrdev_open(struct inode *inode, struct file *filep)
 {
 	struct iio_handler *hand = iio_cdev_to_handler(inode->i_cdev);
 	struct iio_event_interface *ev_int = hand->private;
diff --git a/drivers/staging/iio/trigger_consumer.h b/drivers/staging/iio/trigger_consumer.h
index a02d70b..9d52d96 100644
--- a/drivers/staging/iio/trigger_consumer.h
+++ b/drivers/staging/iio/trigger_consumer.h
@@ -27,7 +27,7 @@ int iio_device_unregister_trigger_consumer(struct iio_dev *dev_info);
  * iio_device_register_trigger_consumer() - set up an iio_dev to use triggers
  * @dev_info: iio_dev associated with the device that will consume the trigger
  **/
-int iio_device_register_trigger_consumer(struct iio_dev *dev_info)
+static int iio_device_register_trigger_consumer(struct iio_dev *dev_info)
 {
 	return 0;
 };
@@ -36,7 +36,7 @@ int iio_device_register_trigger_consumer(struct iio_dev *dev_info)
  * iio_device_unregister_trigger_consumer() - reverse the registration process
  * @dev_info: iio_dev associated with the device that consumed the trigger
  **/
-int iio_device_unregister_trigger_consumer(struct iio_dev *dev_info)
+static int iio_device_unregister_trigger_consumer(struct iio_dev *dev_info)
 {
 	return 0;
 };
-- 
1.7.0

