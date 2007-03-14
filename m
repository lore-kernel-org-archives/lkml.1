Return-Path: <linux-kernel-owner+w=401wt.eu-S1030759AbXCNJSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030759AbXCNJSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030740AbXCNJSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:18:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60472 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030779AbXCNJSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:18:01 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 1/17] misc NULL noise
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HRPcN-0003MX-W2@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 14 Mar 2007 09:17:59 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/x86_64/kernel/vsyscall.c              |    2 +-
 drivers/acpi/events/evmisc.c               |    2 +-
 drivers/ata/pata_mpc52xx.c                 |    2 +-
 drivers/char/watchdog/machzwd.c            |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.c  |    6 +++---
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c |    6 +++---
 drivers/ps3/vuart.c                        |    4 ++--
 drivers/video/backlight/progear_bl.c       |    4 ++--
 8 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86_64/kernel/vsyscall.c b/arch/x86_64/kernel/vsyscall.c
index 180ff91..b43c698 100644
--- a/arch/x86_64/kernel/vsyscall.c
+++ b/arch/x86_64/kernel/vsyscall.c
@@ -112,7 +112,7 @@ static __always_inline void do_vgettimeofday(struct timeval * tv)
 
 		vread = __vsyscall_gtod_data.clock.vread;
 		if (unlikely(!__vsyscall_gtod_data.sysctl_enabled || !vread)) {
-			gettimeofday(tv,0);
+			gettimeofday(tv,NULL);
 			return;
 		}
 		now = vread();
diff --git a/drivers/acpi/events/evmisc.c b/drivers/acpi/events/evmisc.c
index 8dcade6..3a799b9 100644
--- a/drivers/acpi/events/evmisc.c
+++ b/drivers/acpi/events/evmisc.c
@@ -549,7 +549,7 @@ acpi_status acpi_ev_release_global_lock(void)
 	acpi_gbl_global_lock_acquired = FALSE;
 
 	/* Release the local GL mutex */
-	acpi_ev_global_lock_thread_id = 0;
+	acpi_ev_global_lock_thread_id = NULL;
 	acpi_ev_global_lock_acquired = 0;
 	acpi_os_release_mutex(acpi_gbl_global_lock_mutex);
 	return_ACPI_STATUS(status);
diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index f5d8872..882c36e 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -329,7 +329,7 @@ mpc52xx_ata_init_one(struct device *dev, struct mpc52xx_ata_priv *priv)
 	ae->dev = dev;
 	ae->irq = priv->ata_irq;
 
-	aio->cmd_addr		= 0;	/* Don't have a classic reg block */
+	aio->cmd_addr		= NULL;	/* Don't have a classic reg block */
 	aio->altstatus_addr	= &priv->ata_regs->tf_control;
 	aio->ctl_addr		= &priv->ata_regs->tf_control;
 	aio->data_addr		= &priv->ata_regs->tf_data;
diff --git a/drivers/char/watchdog/machzwd.c b/drivers/char/watchdog/machzwd.c
index 4a328ba..81fb3de 100644
--- a/drivers/char/watchdog/machzwd.c
+++ b/drivers/char/watchdog/machzwd.c
@@ -324,7 +324,7 @@ static int zf_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 			return put_user(0, p);
 
 		case WDIOC_KEEPALIVE:
-			zf_ping(0);
+			zf_ping(NULL);
 			break;
 
 		default:
diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.c b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
index 1ff5138..9916cf3 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
@@ -1248,10 +1248,10 @@ int pvr2_upload_firmware2(struct pvr2_hdw *hdw)
 	ret |= pvr2_write_register(hdw, 0xaa18, 0x00840000); /*unknown*/
 	LOCK_TAKE(hdw->ctl_lock); do {
 		hdw->cmd_buffer[0] = FX2CMD_FWPOST1;
-		ret |= pvr2_send_request(hdw,hdw->cmd_buffer,1,0,0);
+		ret |= pvr2_send_request(hdw,hdw->cmd_buffer,1,NULL,0);
 		hdw->cmd_buffer[0] = FX2CMD_MEMSEL;
 		hdw->cmd_buffer[1] = 0;
-		ret |= pvr2_send_request(hdw,hdw->cmd_buffer,2,0,0);
+		ret |= pvr2_send_request(hdw,hdw->cmd_buffer,2,NULL,0);
 	} while (0); LOCK_GIVE(hdw->ctl_lock);
 
 	if (ret) {
@@ -1320,7 +1320,7 @@ int pvr2_upload_firmware2(struct pvr2_hdw *hdw)
 	LOCK_TAKE(hdw->ctl_lock); do {
 		hdw->cmd_buffer[0] = FX2CMD_MEMSEL;
 		hdw->cmd_buffer[1] = 0;
-		ret |= pvr2_send_request(hdw,hdw->cmd_buffer,2,0,0);
+		ret |= pvr2_send_request(hdw,hdw->cmd_buffer,2,NULL,0);
 	} while (0); LOCK_GIVE(hdw->ctl_lock);
 
 	if (ret) {
diff --git a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
index 5313d34..25d3830 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
@@ -808,11 +808,11 @@ static void pvr2_v4l2_destroy_no_lock(struct pvr2_v4l2 *vp)
 {
 	if (vp->dev_video) {
 		pvr2_v4l2_dev_destroy(vp->dev_video);
-		vp->dev_video = 0;
+		vp->dev_video = NULL;
 	}
 	if (vp->dev_radio) {
 		pvr2_v4l2_dev_destroy(vp->dev_radio);
-		vp->dev_radio = 0;
+		vp->dev_radio = NULL;
 	}
 
 	pvr2_trace(PVR2_TRACE_STRUCT,"Destroying pvr2_v4l2 id=%p",vp);
@@ -1138,7 +1138,7 @@ static void pvr2_v4l2_dev_init(struct pvr2_v4l2_dev *dip,
 {
 	int mindevnum;
 	int unit_number;
-	int *nr_ptr = 0;
+	int *nr_ptr = NULL;
 	dip->v4lp = vp;
 
 
diff --git a/drivers/ps3/vuart.c b/drivers/ps3/vuart.c
index 1adf186..6c12744 100644
--- a/drivers/ps3/vuart.c
+++ b/drivers/ps3/vuart.c
@@ -952,7 +952,7 @@ fail_alloc_irq:
 	kfree(dev->priv);
 	dev->priv = NULL;
 fail_alloc:
-	vuart_bus_priv.devices[port_number] = 0;
+	vuart_bus_priv.devices[port_number] = NULL;
 fail_match:
 	up(&vuart_bus_priv.probe_mutex);
 	dev_dbg(&dev->core, "%s:%d failed\n", __func__, __LINE__);
@@ -978,7 +978,7 @@ static int ps3_vuart_remove(struct device *_dev)
 		dev_dbg(&dev->core, "%s:%d: %s no remove method\n", __func__,
 			__LINE__, dev->core.bus_id);
 
-	vuart_bus_priv.devices[dev->priv->port_number] = 0;
+	vuart_bus_priv.devices[dev->priv->port_number] = NULL;
 
 	if (--vuart_bus_priv.use_count == 0) {
 		BUG();
diff --git a/drivers/video/backlight/progear_bl.c b/drivers/video/backlight/progear_bl.c
index 7022693..836ab4d 100644
--- a/drivers/video/backlight/progear_bl.c
+++ b/drivers/video/backlight/progear_bl.c
@@ -65,13 +65,13 @@ static int progearbl_probe(struct platform_device *pdev)
 	u8 temp;
 	struct backlight_device *progear_backlight_device;
 
-	pmu_dev = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M7101, 0);
+	pmu_dev = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M7101, NULL);
 	if (!pmu_dev) {
 		printk("ALI M7101 PMU not found.\n");
 		return -ENODEV;
 	}
 
-	sb_dev = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533, 0);
+	sb_dev = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533, NULL);
 	if (!sb_dev) {
 		printk("ALI 1533 SB not found.\n");
 		pci_dev_put(pmu_dev);
-- 
1.5.0-rc2.GIT


