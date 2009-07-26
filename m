Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbZGZI0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbZGZI0t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZGZI0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:26:46 -0400
Received: from www.tglx.de ([62.245.132.106]:41583 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbZGZI0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:26:04 -0400
Message-Id: <20090726081557.935582320@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:20:32 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [Patch RFC 35/37] staging: Bulk convert the semaphore mess
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline;
	filename=staging-bulkconvert-the-semaphore-mess.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_MUTEX(_LOCKED) and DECLARE_MUTEX are going away. Bulk convert
staging users.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/comedi/drivers/dt9812.c        |    4 ++--
 drivers/staging/comedi/drivers/usbdux.c        |    4 ++--
 drivers/staging/comedi/drivers/usbduxfast.c    |    4 ++--
 drivers/staging/cpc-usb/cpc-usb_drv.c          |    4 ++--
 drivers/staging/frontier/alphatrack.c          |    2 +-
 drivers/staging/frontier/tranzport.c           |    2 +-
 drivers/staging/go7007/go7007-driver.c         |    2 +-
 drivers/staging/go7007/go7007-i2c.c            |    2 +-
 drivers/staging/go7007/go7007-usb.c            |    2 +-
 drivers/staging/go7007/go7007-v4l2.c           |    2 +-
 drivers/staging/go7007/s2250-loader.c          |    2 +-
 drivers/staging/mimio/mimio.c                  |    2 +-
 drivers/staging/octeon/ethernet-mdio.c         |    2 +-
 drivers/staging/otus/wwrap.c                   |    2 +-
 drivers/staging/p9auth/p9auth.c                |    2 +-
 drivers/staging/rspiusb/rspiusb.c              |    2 +-
 drivers/staging/rt2870/common/2870_rtmp_init.c |    6 +++---
 17 files changed, 23 insertions(+), 23 deletions(-)

Index: linux-2.6-tip/drivers/staging/comedi/drivers/dt9812.c
===================================================================
--- linux-2.6-tip.orig/drivers/staging/comedi/drivers/dt9812.c
+++ linux-2.6-tip/drivers/staging/comedi/drivers/dt9812.c
@@ -262,7 +262,7 @@ struct dt9812_usb_cmd {
 
 #define DT9812_NUM_SLOTS	16
 
-static DECLARE_MUTEX(dt9812_mutex);
+static DEFINE_SEMAPHORE(dt9812_mutex);
 
 static struct usb_device_id dt9812_table[] = {
 	{USB_DEVICE(0x0867, 0x9812)},
@@ -1121,7 +1121,7 @@ static int __init usb_dt9812_init(void)
 
 	/* Initialize all driver slots */
 	for (i = 0; i < DT9812_NUM_SLOTS; i++) {
-		init_MUTEX(&dt9812[i].mutex);
+		semaphore_init(&dt9812[i].mutex);
 		dt9812[i].serial = 0;
 		dt9812[i].usb = NULL;
 		dt9812[i].comedi = NULL;
Index: linux-2.6-tip/drivers/staging/comedi/drivers/usbdux.c
===================================================================
--- linux-2.6-tip.orig/drivers/staging/comedi/drivers/usbdux.c
+++ linux-2.6-tip/drivers/staging/comedi/drivers/usbdux.c
@@ -307,7 +307,7 @@ struct usbduxsub {
  */
 static struct usbduxsub usbduxsub[NUMUSBDUX];
 
-static DECLARE_MUTEX(start_stop_sem);
+static DEFINE_SEMAPHORE(start_stop_sem);
 
 /*
  * Stops the data acquision
@@ -2349,7 +2349,7 @@ static int usbduxsub_probe(struct usb_in
 	dev_dbg(dev, "comedi_: usbdux: "
 		"usbduxsub[%d] is ready to connect to comedi.\n", index);
 
-	init_MUTEX(&(usbduxsub[index].sem));
+	semaphore_init(&(usbduxsub[index].sem));
 	/* save a pointer to the usb device */
 	usbduxsub[index].usbdev = udev;
 
Index: linux-2.6-tip/drivers/staging/comedi/drivers/usbduxfast.c
===================================================================
--- linux-2.6-tip.orig/drivers/staging/comedi/drivers/usbduxfast.c
+++ linux-2.6-tip/drivers/staging/comedi/drivers/usbduxfast.c
@@ -201,7 +201,7 @@ struct usbduxfastsub_s {
  */
 static struct usbduxfastsub_s usbduxfastsub[NUMUSBDUXFAST];
 
-static DECLARE_MUTEX(start_stop_sem);
+static DEFINE_SEMAPHORE(start_stop_sem);
 
 /*
  * bulk transfers to usbduxfast
@@ -1500,7 +1500,7 @@ static int usbduxfastsub_probe(struct us
 	       "connect to comedi.\n", index);
 #endif
 
-	init_MUTEX(&(usbduxfastsub[index].sem));
+	semaphore_init(&(usbduxfastsub[index].sem));
 	/* save a pointer to the usb device */
 	usbduxfastsub[index].usbdev = udev;
 
Index: linux-2.6-tip/drivers/staging/cpc-usb/cpc-usb_drv.c
===================================================================
--- linux-2.6-tip.orig/drivers/staging/cpc-usb/cpc-usb_drv.c
+++ linux-2.6-tip/drivers/staging/cpc-usb/cpc-usb_drv.c
@@ -83,7 +83,7 @@ static CPC_USB_T *CPCUSB_Table[CPC_USB_C
 static unsigned int CPCUsbCnt;
 
 /* prevent races between open() and disconnect() */
-static DECLARE_MUTEX(disconnect_sem);
+static DEFINE_SEMAPHORE(disconnect_sem);
 
 /* local function prototypes */
 static ssize_t cpcusb_read(struct file *file, char *buffer, size_t count,
@@ -903,7 +903,7 @@ static int cpcusb_probe(struct usb_inter
 	memset(chan, 0, sizeof(CPC_CHAN_T));
 	ResetBuffer(chan);
 
-	init_MUTEX(&card->sem);
+	semaphore_init(&card->sem);
 	spin_lock_init(&card->slock);
 
 	card->udev = udev;
Index: linux-2.6-tip/drivers/staging/frontier/alphatrack.c
===================================================================
--- linux-2.6-tip.orig/drivers/staging/frontier/alphatrack.c
+++ linux-2.6-tip/drivers/staging/frontier/alphatrack.c
@@ -678,7 +678,7 @@ static int usb_alphatrack_probe(struct u
 		dev_err(&intf->dev, "Out of memory\n");
 		goto exit;
 	}
-	init_MUTEX(&dev->sem);
+	semaphore_init(&dev->sem);
 	dev->intf = intf;
 	init_waitqueue_head(&dev->read_wait);
 	init_waitqueue_head(&dev->write_wait);
Index: linux-2.6-tip/drivers/staging/frontier/tranzport.c
===================================================================
--- linux-2.6-tip.orig/drivers/staging/frontier/tranzport.c
+++ linux-2.6-tip/drivers/staging/frontier/tranzport.c
@@ -800,7 +800,7 @@ static int usb_tranzport_probe(struct us
 		dev_err(&intf->dev, "Out of memory\n");
 		goto exit;
 	}
-	init_MUTEX(&dev->sem);
+	semaphore_init(&dev->sem);
 	dev->intf = intf;
 	init_waitqueue_head(&dev->read_wait);
 	init_waitqueue_head(&dev->write_wait);
Index: linux-2.6-tip/drivers/staging/go7007/go7007-driver.c
===================================================================
--- linux-2.6-tip.orig/drivers/staging/go7007/go7007-driver.c
+++ linux-2.6-tip/drivers/staging/go7007/go7007-driver.c
@@ -604,7 +604,7 @@ struct go7007 *go7007_alloc(struct go700
 	go->tuner_type = -1;
 	go->channel_number = 0;
 	go->name[0] = 0;
-	init_MUTEX(&go->hw_lock);
+	semaphore_init(&go->hw_lock);
 	init_waitqueue_head(&go->frame_waitq);
 	spin_lock_init(&go->spinlock);
 	go->video_dev = NULL;
Index: linux-2.6-tip/drivers/staging/go7007/go7007-i2c.c
===================================================================
--- linux-2.6-tip.orig/drivers/staging/go7007/go7007-i2c.c
+++ linux-2.6-tip/drivers/staging/go7007/go7007-i2c.c
@@ -48,7 +48,7 @@
 
 /* There is only one I2C port on the TW2804 that feeds all four GO7007 VIPs
  * on the Adlink PCI-MPG24, so access is shared between all of them. */
-static DECLARE_MUTEX(adlink_mpg24_i2c_lock);
+static DEFINE_SEMAPHORE(adlink_mpg24_i2c_lock);
 
 static int go7007_i2c_xfer(struct go7007 *go, u16 addr, int read,
 		u16 command, int flags, u8 *data)
Index: linux-2.6-tip/drivers/staging/go7007/go7007-usb.c
===================================================================
--- linux-2.6-tip.orig/drivers/staging/go7007/go7007-usb.c
+++ linux-2.6-tip/drivers/staging/go7007/go7007-usb.c
@@ -1065,7 +1065,7 @@ static int go7007_usb_probe(struct usb_i
 	if (board->flags & GO7007_USB_EZUSB_I2C) {
 		memcpy(&go->i2c_adapter, &go7007_usb_adap_templ,
 				sizeof(go7007_usb_adap_templ));
-		init_MUTEX(&usb->i2c_lock);
+		semaphore_init(&usb->i2c_lock);
 		go->i2c_adapter.dev.parent = go->dev;
 		i2c_set_adapdata(&go->i2c_adapter, go);
 		if (i2c_add_adapter(&go->i2c_adapter) < 0) {
Index: linux-2.6-tip/drivers/staging/go7007/go7007-v4l2.c
===================================================================
--- linux-2.6-tip.orig/drivers/staging/go7007/go7007-v4l2.c
+++ linux-2.6-tip/drivers/staging/go7007/go7007-v4l2.c
@@ -101,7 +101,7 @@ static int go7007_open(struct file *file
 		return -ENOMEM;
 	++go->ref_count;
 	gofh->go = go;
-	init_MUTEX(&gofh->lock);
+	semaphore_init(&gofh->lock);
 	gofh->buf_count = 0;
 	file->private_data = gofh;
 	return 0;
Index: linux-2.6-tip/drivers/staging/go7007/s2250-loader.c
===================================================================
--- linux-2.6-tip.orig/drivers/staging/go7007/s2250-loader.c
+++ linux-2.6-tip/drivers/staging/go7007/s2250-loader.c
@@ -35,7 +35,7 @@ typedef struct device_extension_s {
 #define MAX_DEVICES 256
 
 static pdevice_extension_t s2250_dev_table[MAX_DEVICES];
-static DECLARE_MUTEX(s2250_dev_table_mutex);
+static DEFINE_SEMAPHORE(s2250_dev_table_mutex);
 
 #define to_s2250loader_dev_common(d) container_of(d, device_extension_t, kref)
 static void s2250loader_delete(struct kref *kref)
Index: linux-2.6-tip/drivers/staging/mimio/mimio.c
===================================================================
--- linux-2.6-tip.orig/drivers/staging/mimio/mimio.c
+++ linux-2.6-tip/drivers/staging/mimio/mimio.c
@@ -160,7 +160,7 @@ static struct usb_driver mimio_driver = 
 	.id_table = mimio_table,
 };
 
-static DECLARE_MUTEX(disconnect_sem);
+static DEFINE_SEMAPHORE(disconnect_sem);
 
 static void mimio_close(struct input_dev *idev)
 {
Index: linux-2.6-tip/drivers/staging/octeon/ethernet-mdio.c
===================================================================
--- linux-2.6-tip.orig/drivers/staging/octeon/ethernet-mdio.c
+++ linux-2.6-tip/drivers/staging/octeon/ethernet-mdio.c
@@ -39,7 +39,7 @@
 
 #include "cvmx-smix-defs.h"
 
-DECLARE_MUTEX(mdio_sem);
+DEFINE_SEMAPHORE(mdio_sem);
 
 /**
  * Perform an MII read. Called by the generic MII routines
Index: linux-2.6-tip/drivers/staging/otus/wwrap.c
===================================================================
--- linux-2.6-tip.orig/drivers/staging/otus/wwrap.c
+++ linux-2.6-tip/drivers/staging/otus/wwrap.c
@@ -1066,7 +1066,7 @@ u8_t zfLnxCreateThread(zdev_t *dev)
 
     /* Create Mutex and keventd */
     INIT_WORK(&macp->kevent, kevent);
-    init_MUTEX(&macp->ioctl_sem);
+    semaphore_init(&macp->ioctl_sem);
 
     return 0;
 }
Index: linux-2.6-tip/drivers/staging/p9auth/p9auth.c
===================================================================
--- linux-2.6-tip.orig/drivers/staging/p9auth/p9auth.c
+++ linux-2.6-tip/drivers/staging/p9auth/p9auth.c
@@ -388,7 +388,7 @@ static int cap_init_module(void)
 	/* Initialize each device. */
 	for (i = 0; i < cap_nr_devs; i++) {
 		cap_devices[i].node_size = cap_node_size;
-		init_MUTEX(&cap_devices[i].sem);
+		semaphore_init(&cap_devices[i].sem);
 		cap_setup_cdev(&cap_devices[i], i);
 	}
 
Index: linux-2.6-tip/drivers/staging/rspiusb/rspiusb.c
===================================================================
--- linux-2.6-tip.orig/drivers/staging/rspiusb/rspiusb.c
+++ linux-2.6-tip/drivers/staging/rspiusb/rspiusb.c
@@ -63,7 +63,7 @@ static int debug;
 #endif
 
 /* prevent races between open() and disconnect() */
-static DECLARE_MUTEX(disconnect_sem);
+static DEFINE_SEMAPHORE(disconnect_sem);
 
 /* Structure to hold all of our device specific stuff */
 struct device_extension {
Index: linux-2.6-tip/drivers/staging/rt2870/common/2870_rtmp_init.c
===================================================================
--- linux-2.6-tip.orig/drivers/staging/rt2870/common/2870_rtmp_init.c
+++ linux-2.6-tip/drivers/staging/rt2870/common/2870_rtmp_init.c
@@ -751,13 +751,13 @@ NDIS_STATUS	 CreateThreads(
 
 	//init_MUTEX(&(pAd->usbdev_semaphore));
 
-	init_MUTEX_LOCKED(&(pAd->mlme_semaphore));
+	semaphore_init_locked(&(pAd->mlme_semaphore));
 	init_completion (&pAd->mlmeComplete);
 
-	init_MUTEX_LOCKED(&(pAd->RTUSBCmd_semaphore));
+	semaphore_init_locked(&(pAd->RTUSBCmd_semaphore));
 	init_completion (&pAd->CmdQComplete);
 
-	init_MUTEX_LOCKED(&(pAd->RTUSBTimer_semaphore));
+	semaphore_init_locked(&(pAd->RTUSBTimer_semaphore));
 	init_completion (&pAd->TimerQComplete);
 
 	// Creat MLME Thread


