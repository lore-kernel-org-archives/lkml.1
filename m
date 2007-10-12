Return-Path: <linux-kernel-owner+w=401wt.eu-S932972AbXJLWY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972AbXJLWY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760672AbXJLWSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:18:36 -0400
Received: from ns2.suse.de ([195.135.220.15]:49634 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759692AbXJLWSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:18:34 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 13/75] cdev: remove unneeded setting of cdev names
Date: Fri, 12 Oct 2007 15:16:17 -0700
Message-Id: <11922274993462-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922274941588-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

struct cdev does not need the kobject name to be set, as it is never
used.  This patch fixes up the few places it is set.


Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>
---
 block/bsg.c                         |    5 +----
 drivers/char/raw.c                  |    5 +----
 drivers/media/dvb/dvb-core/dvbdev.c |    5 +----
 drivers/usb/core/devio.c            |    6 ++----
 4 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index ed26468..b8ddfc6 100644
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
diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index 1f0d7c6..bbfa0e2 100644
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -255,10 +255,7 @@ static const struct file_operations raw_ctl_fops = {
 	.owner	=	THIS_MODULE,
 };
 
-static struct cdev raw_cdev = {
-	.kobj	=	{.name = "raw", },
-	.owner	=	THIS_MODULE,
-};
+static struct cdev raw_cdev;
 
 static int __init raw_init(void)
 {
diff --git a/drivers/media/dvb/dvb-core/dvbdev.c b/drivers/media/dvb/dvb-core/dvbdev.c
index 56231d8..18738fa 100644
--- a/drivers/media/dvb/dvb-core/dvbdev.c
+++ b/drivers/media/dvb/dvb-core/dvbdev.c
@@ -103,10 +103,7 @@ static struct file_operations dvb_device_fops =
 	.open =		dvb_device_open,
 };
 
-static struct cdev dvb_device_cdev = {
-	.kobj   = {.name = "dvb", },
-	.owner  =       THIS_MODULE,
-};
+static struct cdev dvb_device_cdev;
 
 int dvb_generic_open(struct inode *inode, struct file *file)
 {
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 927a181..fe98796 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1576,6 +1576,7 @@ static unsigned int usbdev_poll(struct file *file, struct poll_table_struct *wai
 }
 
 const struct file_operations usbdev_file_operations = {
+	.owner = 	THIS_MODULE,
 	.llseek =	usbdev_lseek,
 	.read =		usbdev_read,
 	.poll =		usbdev_poll,
@@ -1625,10 +1626,7 @@ static struct notifier_block usbdev_nb = {
 };
 #endif
 
-static struct cdev usb_device_cdev = {
-	.kobj   = {.name = "usb_device", },
-	.owner  = THIS_MODULE,
-};
+static struct cdev usb_device_cdev;
 
 int __init usb_devio_init(void)
 {
-- 
1.5.3.4

