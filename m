Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbZCDNcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbZCDNcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 08:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbZCDNcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 08:32:32 -0500
Received: from ti-out-0910.google.com ([209.85.142.185]:33910 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbZCDNcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 08:32:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:user-agent;
        b=SL5DUaPbrwVneGClLW0DgitlGDfjhO4MSyCgz07h2XWJdd/y6LVYTsv+AZxwryTh+g
         lsxZoq+M8xHGnV05q4OCrroQkdjbDlg5OB4wD9URn+YZBQjdrtYa1QvAzKQGxCIlgeCj
         Fndpiav7FWx1Z5/m0NDywRPEaOAK2CtSnfBfM=
Date: Wed, 4 Mar 2009 21:31:57 +0800
From: Zhenwen Xu <helight.xu@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH]some cleanup on drivers/i2c/i2c-core.c
Message-ID: <20090304133157.GA7629@helight>
Reply-To: Zhenwen Xu <helight.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Some lines over 80. 
 The printk(KERN_ERR ... ) should be dev_err.
 And some blankspace should be deleted.

-- 
---------------------------------
Zhenwen Xu - Open and Free
Home Page:	http://zhwen.org
My Studio:	http://dim4.cn

>From 3926e6026d97a7c956bff87c695920e0654694b7 Mon Sep 17 00:00:00 2001
From: Zhenwen Xu<helight.xu@gmail.com>
Date: Wed, 4 Mar 2009 21:20:51 +0800
Subject: [PATCH] do some cleanup on drivers/i2c/i2c-core.c


Signed-off-by: Zhenwen Xu<helight.xu@gmail.com>
---
 drivers/i2c/i2c-core.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index e7d9848..5281860 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -152,7 +152,7 @@ static void i2c_device_shutdown(struct device *dev)
 		driver->shutdown(to_i2c_client(dev));
 }
 
-static int i2c_device_suspend(struct device * dev, pm_message_t mesg)
+static int i2c_device_suspend(struct device *dev, pm_message_t mesg)
 {
 	struct i2c_driver *driver;
 
@@ -164,7 +164,7 @@ static int i2c_device_suspend(struct device * dev, pm_message_t mesg)
 	return driver->suspend(to_i2c_client(dev), mesg);
 }
 
-static int i2c_device_resume(struct device * dev)
+static int i2c_device_resume(struct device *dev)
 {
 	struct i2c_driver *driver;
 
@@ -187,13 +187,15 @@ static void i2c_client_dev_release(struct device *dev)
 	kfree(to_i2c_client(dev));
 }
 
-static ssize_t show_client_name(struct device *dev, struct device_attribute *attr, char *buf)
+static ssize_t
+show_client_name(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	return sprintf(buf, "%s\n", client->name);
 }
 
-static ssize_t show_modalias(struct device *dev, struct device_attribute *attr, char *buf)
+static ssize_t
+show_modalias(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	return sprintf(buf, "%s%s\n", I2C_MODULE_PREFIX, client->name);
@@ -365,8 +367,7 @@ static struct i2c_driver dummy_driver = {
  * This returns the new i2c client, which should be saved for later use with
  * i2c_unregister_device(); or NULL to indicate an error.
  */
-struct i2c_client *
-i2c_new_dummy(struct i2c_adapter *adapter, u16 address)
+struct i2c_client *i2c_new_dummy(struct i2c_adapter *adapter, u16 address)
 {
 	struct i2c_board_info info = {
 		I2C_BOARD_INFO("dummy", address),
@@ -413,7 +414,8 @@ static void i2c_scan_static_board_info(struct i2c_adapter *adapter)
 		if (devinfo->busnum == adapter->nr
 				&& !i2c_new_device(adapter,
 						&devinfo->board_info))
-			printk(KERN_ERR "i2c-core: can't create i2c%d-%04x\n",
+			dev_err(&adapter->dev,
+				"i2c-core: can't create i2c%d-%04x\n",
 				i2c_adapter_id(adapter),
 				devinfo->board_info.addr);
 	}
@@ -1012,7 +1014,7 @@ module_exit(i2c_exit);
  * Note that there is no requirement that each message be sent to
  * the same slave address, although that is the most common model.
  */
-int i2c_transfer(struct i2c_adapter * adap, struct i2c_msg *msgs, int num)
+int i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 {
 	int ret;
 
@@ -1519,8 +1521,7 @@ EXPORT_SYMBOL(i2c_put_adapter);
 /* The SMBus parts */
 
 #define POLY    (0x1070U << 3)
-static u8
-crc8(u16 data)
+static u8 crc8(u16 data)
 {
 	int i;
 
@@ -1984,9 +1985,9 @@ static s32 i2c_smbus_xfer_emulated(struct i2c_adapter * adapter, u16 addr,
  * This executes an SMBus protocol operation, and returns a negative
  * errno code else zero on success.
  */
-s32 i2c_smbus_xfer(struct i2c_adapter * adapter, u16 addr, unsigned short flags,
-		   char read_write, u8 command, int protocol,
-                   union i2c_smbus_data * data)
+s32 i2c_smbus_xfer(struct i2c_adapter *adapter, u16 addr, unsigned short flags,
+		char read_write, u8 command, int protocol,
+		union i2c_smbus_data *data)
 {
 	s32 res;
 
-- 
1.5.6.5

