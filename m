Return-Path: <linux-kernel-owner+w=401wt.eu-S1761053AbXIMXty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761053AbXIMXty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 19:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932873AbXIMXpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 19:45:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57155 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932868AbXIMXpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 19:45:16 -0400
Date: Thu, 13 Sep 2007 16:43:11 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Subject: cdev: remove unneeded setting of cdev names
Message-ID: <20070913234311.GK10856@kroah.com>
References: <20070913233751.GA10856@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070913233751.GA10856@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

<resend with proper subject:>

struct cdev does not need the kobject name to be set, as it is never
used.  This patch fixes up the few places it is set.


Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/bsg.c                         |    5 +----
 drivers/char/raw.c                  |    5 +----
 drivers/media/dvb/dvb-core/dvbdev.c |    5 +----
 drivers/usb/core/devio.c            |    6 ++----
 4 files changed, 5 insertions(+), 16 deletions(-)

--- a/block/bsg.c
+++ b/block/bsg.c
@@ -1010,10 +1010,7 @@ unlock:
 }
 EXPORT_SYMBOL_GPL(bsg_register_queue);
 
-static struct cdev bsg_cdev = {
-	.kobj   = {.name = "bsg", },
-	.owner  = THIS_MODULE,
-};
+static struct cdev bsg_cdev;
 
 static int __init bsg_init(void)
 {
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -255,10 +255,7 @@ static const struct file_operations raw_
 	.owner	=	THIS_MODULE,
 };
 
-static struct cdev raw_cdev = {
-	.kobj	=	{.name = "raw", },
-	.owner	=	THIS_MODULE,
-};
+static struct cdev raw_cdev;
 
 static int __init raw_init(void)
 {
--- a/drivers/media/dvb/dvb-core/dvbdev.c
+++ b/drivers/media/dvb/dvb-core/dvbdev.c
@@ -109,10 +109,7 @@ static struct file_operations dvb_device
 	.open =		dvb_device_open,
 };
 
-static struct cdev dvb_device_cdev = {
-	.kobj   = {.name = "dvb", },
-	.owner  =       THIS_MODULE,
-};
+static struct cdev dvb_device_cdev;
 
 int dvb_generic_open(struct inode *inode, struct file *file)
 {
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1576,6 +1576,7 @@ static unsigned int usbdev_poll(struct f
 }
 
 const struct file_operations usbdev_file_operations = {
+	.owner = 	THIS_MODULE,
 	.llseek =	usbdev_lseek,
 	.read =		usbdev_read,
 	.poll =		usbdev_poll,
@@ -1625,10 +1626,7 @@ static struct notifier_block usbdev_nb =
 };
 #endif
 
-static struct cdev usb_device_cdev = {
-	.kobj   = {.name = "usb_device", },
-	.owner  = THIS_MODULE,
-};
+static struct cdev usb_device_cdev;
 
 int __init usb_devio_init(void)
 {
