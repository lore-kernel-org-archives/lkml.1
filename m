Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933899Ab0BFBvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 20:51:16 -0500
Received: from mail.perches.com ([173.55.12.10]:1869 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933133Ab0BFBvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 20:51:14 -0500
Subject: [PATCH] drivers/usb: Convert concatenated __FILE__ to %s, __FILE__
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Feb 2010 17:51:13 -0800
Message-ID: <1265421073.10226.56.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduces string space a bit
Neaten a macro redefine of dbg

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/host/ehci-ppc-of.c    |   12 ++++++------
 drivers/usb/host/ehci-xilinx-of.c |    6 +++---
 drivers/usb/host/ohci-dbg.c       |    4 ++--
 drivers/usb/host/ohci-lh7a404.c   |   11 +++++------
 drivers/usb/host/ohci-ppc-of.c    |    8 ++++----
 drivers/usb/host/ohci-ppc-soc.c   |    8 ++++----
 drivers/usb/host/ohci-sa1111.c    |    8 ++++----
 drivers/usb/misc/adutux.c         |    6 +++---
 drivers/usb/misc/ldusb.c          |    2 +-
 drivers/usb/misc/legousbtower.c   |   11 +++++++----
 drivers/usb/serial/omninet.c      |    4 ++--
 11 files changed, 41 insertions(+), 39 deletions(-)

diff --git a/drivers/usb/host/ehci-ppc-of.c b/drivers/usb/host/ehci-ppc-of.c
index 36f96da..fd79e22 100644
--- a/drivers/usb/host/ehci-ppc-of.c
+++ b/drivers/usb/host/ehci-ppc-of.c
@@ -134,21 +134,21 @@ ehci_hcd_ppc_of_probe(struct of_device *op, const struct of_device_id *match)
 	hcd->rsrc_len = res.end - res.start + 1;
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
-		printk(KERN_ERR __FILE__ ": request_mem_region failed\n");
+		printk(KERN_ERR "%s: request_mem_region failed\n", __FILE__);
 		rv = -EBUSY;
 		goto err_rmr;
 	}
 
 	irq = irq_of_parse_and_map(dn, 0);
 	if (irq == NO_IRQ) {
-		printk(KERN_ERR __FILE__ ": irq_of_parse_and_map failed\n");
+		printk(KERN_ERR "%s: irq_of_parse_and_map failed\n", __FILE__);
 		rv = -EBUSY;
 		goto err_irq;
 	}
 
 	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
 	if (!hcd->regs) {
-		printk(KERN_ERR __FILE__ ": ioremap failed\n");
+		printk(KERN_ERR "%s: ioremap failed\n", __FILE__);
 		rv = -ENOMEM;
 		goto err_ioremap;
 	}
@@ -161,9 +161,9 @@ ehci_hcd_ppc_of_probe(struct of_device *op, const struct of_device_id *match)
 			ehci->ohci_hcctrl_reg = ioremap(res.start +
 					OHCI_HCCTRL_OFFSET, OHCI_HCCTRL_LEN);
 		else
-			pr_debug(__FILE__ ": no ohci offset in fdt\n");
+			pr_debug("%s: no ohci offset in fdt\n", __FILE__);
 		if (!ehci->ohci_hcctrl_reg) {
-			pr_debug(__FILE__ ": ioremap for ohci hcctrl failed\n");
+			pr_debug("%s: ioremap for ohci hcctrl failed\n", __FILE__);
 		} else {
 			ehci->has_amcc_usb23 = 1;
 		}
@@ -241,7 +241,7 @@ static int ehci_hcd_ppc_of_remove(struct of_device *op)
 				else
 					release_mem_region(res.start, 0x4);
 			else
-				pr_debug(__FILE__ ": no ohci offset in fdt\n");
+				pr_debug("%s: no ohci offset in fdt\n", __FILE__);
 			of_node_put(np);
 		}
 
diff --git a/drivers/usb/host/ehci-xilinx-of.c b/drivers/usb/host/ehci-xilinx-of.c
index a586153..e1421a8 100644
--- a/drivers/usb/host/ehci-xilinx-of.c
+++ b/drivers/usb/host/ehci-xilinx-of.c
@@ -177,21 +177,21 @@ ehci_hcd_xilinx_of_probe(struct of_device *op, const struct of_device_id *match)
 	hcd->rsrc_len = res.end - res.start + 1;
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
-		printk(KERN_ERR __FILE__ ": request_mem_region failed\n");
+		printk(KERN_ERR "%s: request_mem_region failed\n", __FILE__);
 		rv = -EBUSY;
 		goto err_rmr;
 	}
 
 	irq = irq_of_parse_and_map(dn, 0);
 	if (irq == NO_IRQ) {
-		printk(KERN_ERR __FILE__ ": irq_of_parse_and_map failed\n");
+		printk(KERN_ERR "%s: irq_of_parse_and_map failed\n", __FILE__);
 		rv = -EBUSY;
 		goto err_irq;
 	}
 
 	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
 	if (!hcd->regs) {
-		printk(KERN_ERR __FILE__ ": ioremap failed\n");
+		printk(KERN_ERR "%s: ioremap failed\n", __FILE__);
 		rv = -ENOMEM;
 		goto err_ioremap;
 	}
diff --git a/drivers/usb/host/ohci-dbg.c b/drivers/usb/host/ohci-dbg.c
index 811f5df..8ad2441 100644
--- a/drivers/usb/host/ohci-dbg.c
+++ b/drivers/usb/host/ohci-dbg.c
@@ -53,13 +53,13 @@ urb_print(struct urb * urb, char * str, int small, int status)
 		int i, len;
 
 		if (usb_pipecontrol (pipe)) {
-			printk (KERN_DEBUG __FILE__ ": setup(8):");
+			printk (KERN_DEBUG "%s: setup(8):", __FILE__);
 			for (i = 0; i < 8 ; i++)
 				printk (" %02x", ((__u8 *) urb->setup_packet) [i]);
 			printk ("\n");
 		}
 		if (urb->transfer_buffer_length > 0 && urb->transfer_buffer) {
-			printk (KERN_DEBUG __FILE__ ": data(%d/%d):",
+			printk (KERN_DEBUG "%s: data(%d/%d):", __FILE__,
 				urb->actual_length,
 				urb->transfer_buffer_length);
 			len = usb_pipeout (pipe)?
diff --git a/drivers/usb/host/ohci-lh7a404.c b/drivers/usb/host/ohci-lh7a404.c
index de42283..18d39f0 100644
--- a/drivers/usb/host/ohci-lh7a404.c
+++ b/drivers/usb/host/ohci-lh7a404.c
@@ -28,8 +28,8 @@ extern int usb_disabled(void);
 
 static void lh7a404_start_hc(struct platform_device *dev)
 {
-	printk(KERN_DEBUG __FILE__
-	       ": starting LH7A404 OHCI USB Controller\n");
+	printk(KERN_DEBUG "%s: starting LH7A404 OHCI USB Controller\n",
+	       __FILE__);
 
 	/*
 	 * Now, carefully enable the USB clock, and take
@@ -39,14 +39,13 @@ static void lh7a404_start_hc(struct platform_device *dev)
 	udelay(1000);
 	USBH_CMDSTATUS = OHCI_HCR;
 
-	printk(KERN_DEBUG __FILE__
-		   ": Clock to USB host has been enabled \n");
+	printk(KERN_DEBUG "%s: Clock to USB host has been enabled \n", __FILE__);
 }
 
 static void lh7a404_stop_hc(struct platform_device *dev)
 {
-	printk(KERN_DEBUG __FILE__
-	       ": stopping LH7A404 OHCI USB Controller\n");
+	printk(KERN_DEBUG "%s: stopping LH7A404 OHCI USB Controller\n",
+	       __FILE__);
 
 	CSC_PWRCNT &= ~CSC_PWRCNT_USBH_EN; /* Disable clock */
 }
diff --git a/drivers/usb/host/ohci-ppc-of.c b/drivers/usb/host/ohci-ppc-of.c
index 68a3017..4b5e2a2 100644
--- a/drivers/usb/host/ohci-ppc-of.c
+++ b/drivers/usb/host/ohci-ppc-of.c
@@ -114,21 +114,21 @@ ohci_hcd_ppc_of_probe(struct of_device *op, const struct of_device_id *match)
 	hcd->rsrc_len = res.end - res.start + 1;
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
-		printk(KERN_ERR __FILE__ ": request_mem_region failed\n");
+		printk(KERN_ERR "%s: request_mem_region failed\n", __FILE__);
 		rv = -EBUSY;
 		goto err_rmr;
 	}
 
 	irq = irq_of_parse_and_map(dn, 0);
 	if (irq == NO_IRQ) {
-		printk(KERN_ERR __FILE__ ": irq_of_parse_and_map failed\n");
+		printk(KERN_ERR "%s: irq_of_parse_and_map failed\n", __FILE__);
 		rv = -EBUSY;
 		goto err_irq;
 	}
 
 	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
 	if (!hcd->regs) {
-		printk(KERN_ERR __FILE__ ": ioremap failed\n");
+		printk(KERN_ERR "%s: ioremap failed\n", __FILE__);
 		rv = -ENOMEM;
 		goto err_ioremap;
 	}
@@ -169,7 +169,7 @@ ohci_hcd_ppc_of_probe(struct of_device *op, const struct of_device_id *match)
 			} else
 				release_mem_region(res.start, 0x4);
 		} else
-		    pr_debug(__FILE__ ": cannot get ehci offset from fdt\n");
+			pr_debug("%s: cannot get ehci offset from fdt\n", __FILE__);
 	}
 
 	iounmap(hcd->regs);
diff --git a/drivers/usb/host/ohci-ppc-soc.c b/drivers/usb/host/ohci-ppc-soc.c
index cd3398b..89e670e 100644
--- a/drivers/usb/host/ohci-ppc-soc.c
+++ b/drivers/usb/host/ohci-ppc-soc.c
@@ -41,14 +41,14 @@ static int usb_hcd_ppc_soc_probe(const struct hc_driver *driver,
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!res) {
-		pr_debug(__FILE__ ": no irq\n");
+		pr_debug("%s: no irq\n", __FILE__);
 		return -ENODEV;
 	}
 	irq = res->start;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
-		pr_debug(__FILE__ ": no reg addr\n");
+		pr_debug("%s: no reg addr\n", __FILE__);
 		return -ENODEV;
 	}
 
@@ -59,14 +59,14 @@ static int usb_hcd_ppc_soc_probe(const struct hc_driver *driver,
 	hcd->rsrc_len = res->end - res->start + 1;
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
-		pr_debug(__FILE__ ": request_mem_region failed\n");
+		pr_debug("%s: request_mem_region failed\n", __FILE__);
 		retval = -EBUSY;
 		goto err1;
 	}
 
 	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
 	if (!hcd->regs) {
-		pr_debug(__FILE__ ": ioremap failed\n");
+		pr_debug("%s: ioremap failed\n", __FILE__);
 		retval = -ENOMEM;
 		goto err2;
 	}
diff --git a/drivers/usb/host/ohci-sa1111.c b/drivers/usb/host/ohci-sa1111.c
index e4bbe8e..d8eb3bd 100644
--- a/drivers/usb/host/ohci-sa1111.c
+++ b/drivers/usb/host/ohci-sa1111.c
@@ -31,8 +31,8 @@ static void sa1111_start_hc(struct sa1111_dev *dev)
 {
 	unsigned int usb_rst = 0;
 
-	printk(KERN_DEBUG __FILE__
-	       ": starting SA-1111 OHCI USB Controller\n");
+	printk(KERN_DEBUG "%s: starting SA-1111 OHCI USB Controller\n",
+	       __FILE__);
 
 #ifdef CONFIG_SA1100_BADGE4
 	if (machine_is_badge4()) {
@@ -65,8 +65,8 @@ static void sa1111_start_hc(struct sa1111_dev *dev)
 static void sa1111_stop_hc(struct sa1111_dev *dev)
 {
 	unsigned int usb_rst;
-	printk(KERN_DEBUG __FILE__
-	       ": stopping SA-1111 OHCI USB Controller\n");
+	printk(KERN_DEBUG "%s: stopping SA-1111 OHCI USB Controller\n",
+	       __FILE__);
 
 	/*
 	 * Put the USB host controller into reset.
diff --git a/drivers/usb/misc/adutux.c b/drivers/usb/misc/adutux.c
index 2035265..2e090a9 100644
--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -38,7 +38,7 @@ static int debug = 1;
 #define dbg(lvl, format, arg...) 					\
 do { 									\
 	if (debug >= lvl)						\
-		printk(KERN_DEBUG __FILE__ " : " format " \n", ## arg);	\
+		printk(KERN_DEBUG "%s: " format "\n", __FILE__, ##arg);	\
 } while (0)
 
 
@@ -132,8 +132,8 @@ static void adu_debug_data(int level, const char *function, int size,
 	if (debug < level)
 		return;
 
-	printk(KERN_DEBUG __FILE__": %s - length = %d, data = ",
-	       function, size);
+	printk(KERN_DEBUG "%s: %s - length = %d, data = ",
+	       __FILE__, function, size);
 	for (i = 0; i < size; ++i)
 		printk("%.2x ", data[i]);
 	printk("\n");
diff --git a/drivers/usb/misc/ldusb.c b/drivers/usb/misc/ldusb.c
index 90f1301..9e0dc96 100644
--- a/drivers/usb/misc/ldusb.c
+++ b/drivers/usb/misc/ldusb.c
@@ -798,7 +798,7 @@ static int __init ld_usb_init(void)
 	/* register this driver with the USB subsystem */
 	retval = usb_register(&ld_usb_driver);
 	if (retval)
-		err("usb_register failed for the "__FILE__" driver. Error number %d\n", retval);
+		err("usb_register failed for the %s driver. Error number %d\n", __FILE__, retval);
 
 	return retval;
 }
diff --git a/drivers/usb/misc/legousbtower.c b/drivers/usb/misc/legousbtower.c
index faa6d62..0ec3d3c 100644
--- a/drivers/usb/misc/legousbtower.c
+++ b/drivers/usb/misc/legousbtower.c
@@ -95,8 +95,11 @@
 
 /* Use our own dbg macro */
 #undef dbg
-#define dbg(lvl, format, arg...) do { if (debug >= lvl) printk(KERN_DEBUG  __FILE__ ": " format "\n", ## arg); } while (0)
-
+#define dbg(lvl, format, arg...)					\
+do {									\
+	if (debug >= lvl)						\
+		printk(KERN_DEBUG "%s: " format "\n", __FILE__, ##arg);	\
+} while (0)
 
 /* Version Information */
 #define DRIVER_VERSION "v0.96"
@@ -302,7 +305,7 @@ static inline void lego_usb_tower_debug_data (int level, const char *function, i
 	if (debug < level)
 		return;
 
-	printk (KERN_DEBUG __FILE__": %s - length = %d, data = ", function, size);
+	printk (KERN_DEBUG "%s: %s - length = %d, data = ", __FILE__, function, size);
 	for (i = 0; i < size; ++i) {
 		printk ("%.2x ", data[i]);
 	}
@@ -1055,7 +1058,7 @@ static int __init lego_usb_tower_init(void)
 	/* register this driver with the USB subsystem */
 	result = usb_register(&tower_driver);
 	if (result < 0) {
-		err("usb_register failed for the "__FILE__" driver. Error number %d", result);
+		err("usb_register failed for the %s driver. Error number %d", __FILE__, result);
 		retval = -1;
 		goto exit;
 	}
diff --git a/drivers/usb/serial/omninet.c b/drivers/usb/serial/omninet.c
index 40c3bff..3665b78 100644
--- a/drivers/usb/serial/omninet.c
+++ b/drivers/usb/serial/omninet.c
@@ -218,8 +218,8 @@ static void omninet_read_bulk_callback(struct urb *urb)
 
 	if (debug && header->oh_xxx != 0x30) {
 		if (urb->actual_length) {
-			printk(KERN_DEBUG __FILE__
-					": omninet_read %d: ", header->oh_len);
+			printk(KERN_DEBUG "%s: omninet_read %d: ",
+			       __FILE__, header->oh_len);
 			for (i = 0; i < (header->oh_len +
 						OMNINET_HEADERLEN); i++)
 				printk("%.2x ", data[i]);
-- 
1.7.0.rc1.33.g07cf0f



