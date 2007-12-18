Return-Path: <linux-kernel-owner+w=401wt.eu-S1764973AbXLRCj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764973AbXLRCj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 21:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbXLRCjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 21:39:32 -0500
Received: from vms040pub.verizon.net ([206.46.252.40]:45161 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbXLRCja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 21:39:30 -0500
Date: Mon, 17 Dec 2007 21:39:15 -0500
From: Jon Smirl <jonsmirl@gmail.com>
Subject: [PATCH 1/7] Copy mpc-i2c to preserve support for ARCH=ppc and allow
	changes on ARCH=powerpc
In-reply-to: <20071218023913.8530.46661.stgit@terra.home>
To: i2c@lm-sensors.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Message-id: <20071218023915.8530.67500.stgit@terra.home>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <20071218023913.8530.46661.stgit@terra.home>
User-Agent: StGIT/0.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Temporarily copy the mpc-i2c driver to continue support for the ppc architecture until it is removed in mid-2008. This file should be deleted as part of ppc's final removal.

Signed-off-by: Jon Smirl <jonsmirl@gmail.com>

Signed-off-by: Jon Smirl <jonsmirl@gmail.com>

Signed-off-by: Jon Smirl <jonsmirl@gmail.com>
---

 arch/ppc/configs/TQM8540_defconfig     |    2 
 arch/ppc/configs/TQM8541_defconfig     |    2 
 arch/ppc/configs/TQM8555_defconfig     |    2 
 arch/ppc/configs/TQM8560_defconfig     |    2 
 arch/ppc/configs/mpc834x_sys_defconfig |    2 
 arch/ppc/configs/mpc8540_ads_defconfig |    2 
 arch/ppc/configs/mpc8548_cds_defconfig |    2 
 arch/ppc/configs/mpc8555_cds_defconfig |    2 
 arch/ppc/configs/mpc8560_ads_defconfig |    2 
 drivers/i2c/busses/Kconfig             |   16 +
 drivers/i2c/busses/Makefile            |    1 
 drivers/i2c/busses/i2c-mpc-ppc.c       |  418 ++++++++++++++++++++++++++++++++
 12 files changed, 443 insertions(+), 10 deletions(-)
 create mode 100644 drivers/i2c/busses/i2c-mpc-ppc.c


diff --git a/arch/ppc/configs/TQM8540_defconfig b/arch/ppc/configs/TQM8540_defconfig
index f33f0e7..7098ed0 100644
--- a/arch/ppc/configs/TQM8540_defconfig
+++ b/arch/ppc/configs/TQM8540_defconfig
@@ -684,7 +684,7 @@ CONFIG_I2C_CHARDEV=y
 # CONFIG_I2C_I801 is not set
 # CONFIG_I2C_I810 is not set
 # CONFIG_I2C_PIIX4 is not set
-CONFIG_I2C_MPC=y
+CONFIG_I2C_MPC_PPC=y
 # CONFIG_I2C_NFORCE2 is not set
 # CONFIG_I2C_PARPORT_LIGHT is not set
 # CONFIG_I2C_PROSAVAGE is not set
diff --git a/arch/ppc/configs/TQM8541_defconfig b/arch/ppc/configs/TQM8541_defconfig
index e00cd62..2137d01 100644
--- a/arch/ppc/configs/TQM8541_defconfig
+++ b/arch/ppc/configs/TQM8541_defconfig
@@ -687,7 +687,7 @@ CONFIG_I2C_CHARDEV=y
 # CONFIG_I2C_I801 is not set
 # CONFIG_I2C_I810 is not set
 # CONFIG_I2C_PIIX4 is not set
-CONFIG_I2C_MPC=y
+CONFIG_I2C_MPC_PPC=y
 # CONFIG_I2C_MPC8260 is not set
 # CONFIG_I2C_NFORCE2 is not set
 # CONFIG_I2C_PARPORT_LIGHT is not set
diff --git a/arch/ppc/configs/TQM8555_defconfig b/arch/ppc/configs/TQM8555_defconfig
index 43a0d9d..f2317b6 100644
--- a/arch/ppc/configs/TQM8555_defconfig
+++ b/arch/ppc/configs/TQM8555_defconfig
@@ -687,7 +687,7 @@ CONFIG_I2C_CHARDEV=y
 # CONFIG_I2C_I801 is not set
 # CONFIG_I2C_I810 is not set
 # CONFIG_I2C_PIIX4 is not set
-CONFIG_I2C_MPC=y
+CONFIG_I2C_MPC_PPC=y
 # CONFIG_I2C_NFORCE2 is not set
 # CONFIG_I2C_PARPORT_LIGHT is not set
 # CONFIG_I2C_PROSAVAGE is not set
diff --git a/arch/ppc/configs/TQM8560_defconfig b/arch/ppc/configs/TQM8560_defconfig
index a814d17..6c19121 100644
--- a/arch/ppc/configs/TQM8560_defconfig
+++ b/arch/ppc/configs/TQM8560_defconfig
@@ -694,7 +694,7 @@ CONFIG_I2C_CHARDEV=y
 # CONFIG_I2C_I801 is not set
 # CONFIG_I2C_I810 is not set
 # CONFIG_I2C_PIIX4 is not set
-CONFIG_I2C_MPC=y
+CONFIG_I2C_MPC_PPC=y
 # CONFIG_I2C_MPC8260 is not set
 # CONFIG_I2C_NFORCE2 is not set
 # CONFIG_I2C_PARPORT_LIGHT is not set
diff --git a/arch/ppc/configs/mpc834x_sys_defconfig b/arch/ppc/configs/mpc834x_sys_defconfig
index d90c8a7..cd568d2 100644
--- a/arch/ppc/configs/mpc834x_sys_defconfig
+++ b/arch/ppc/configs/mpc834x_sys_defconfig
@@ -562,7 +562,7 @@ CONFIG_I2C_CHARDEV=y
 # CONFIG_I2C_I801 is not set
 # CONFIG_I2C_I810 is not set
 # CONFIG_I2C_PIIX4 is not set
-CONFIG_I2C_MPC=y
+CONFIG_I2C_MPC_PPC=y
 # CONFIG_I2C_NFORCE2 is not set
 # CONFIG_I2C_PARPORT_LIGHT is not set
 # CONFIG_I2C_PROSAVAGE is not set
diff --git a/arch/ppc/configs/mpc8540_ads_defconfig b/arch/ppc/configs/mpc8540_ads_defconfig
index bf676eb..5819835 100644
--- a/arch/ppc/configs/mpc8540_ads_defconfig
+++ b/arch/ppc/configs/mpc8540_ads_defconfig
@@ -452,7 +452,7 @@ CONFIG_I2C_CHARDEV=y
 # CONFIG_I2C_AMD8111 is not set
 # CONFIG_I2C_I801 is not set
 # CONFIG_I2C_I810 is not set
-CONFIG_I2C_MPC=y
+CONFIG_I2C_MPC_PPC=y
 # CONFIG_I2C_NFORCE2 is not set
 # CONFIG_I2C_PARPORT_LIGHT is not set
 # CONFIG_I2C_PIIX4 is not set
diff --git a/arch/ppc/configs/mpc8548_cds_defconfig b/arch/ppc/configs/mpc8548_cds_defconfig
index f36fc5d..e5b5071 100644
--- a/arch/ppc/configs/mpc8548_cds_defconfig
+++ b/arch/ppc/configs/mpc8548_cds_defconfig
@@ -413,7 +413,7 @@ CONFIG_I2C_CHARDEV=y
 #
 # I2C Hardware Bus support
 #
-CONFIG_I2C_MPC=y
+CONFIG_I2C_MPC_PPC=y
 # CONFIG_I2C_PARPORT_LIGHT is not set
 # CONFIG_I2C_PCA_ISA is not set
 
diff --git a/arch/ppc/configs/mpc8555_cds_defconfig b/arch/ppc/configs/mpc8555_cds_defconfig
index 4f1e320..08dbab0 100644
--- a/arch/ppc/configs/mpc8555_cds_defconfig
+++ b/arch/ppc/configs/mpc8555_cds_defconfig
@@ -518,7 +518,7 @@ CONFIG_I2C_CHARDEV=y
 # CONFIG_I2C_I801 is not set
 # CONFIG_I2C_I810 is not set
 # CONFIG_I2C_PIIX4 is not set
-CONFIG_I2C_MPC=y
+CONFIG_I2C_MPC_PPC=y
 # CONFIG_I2C_NFORCE2 is not set
 # CONFIG_I2C_PARPORT_LIGHT is not set
 # CONFIG_I2C_PROSAVAGE is not set
diff --git a/arch/ppc/configs/mpc8560_ads_defconfig b/arch/ppc/configs/mpc8560_ads_defconfig
index f12d48f..0e0080b 100644
--- a/arch/ppc/configs/mpc8560_ads_defconfig
+++ b/arch/ppc/configs/mpc8560_ads_defconfig
@@ -489,7 +489,7 @@ CONFIG_I2C_CHARDEV=y
 # CONFIG_I2C_I801 is not set
 # CONFIG_I2C_I810 is not set
 # CONFIG_I2C_PIIX4 is not set
-CONFIG_I2C_MPC=y
+CONFIG_I2C_MPC_PPC=y
 # CONFIG_I2C_NFORCE2 is not set
 # CONFIG_I2C_PARPORT_LIGHT is not set
 # CONFIG_I2C_PROSAVAGE is not set
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index c466c6c..c5ad557 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -301,7 +301,7 @@ config I2C_POWERMAC
 
 config I2C_MPC
 	tristate "MPC107/824x/85xx/52xx/86xx"
-	depends on PPC32
+	depends on PPC32 && PPC_MERGE
 	help
 	  If you say yes to this option, support will be included for the
 	  built-in I2C interface on the MPC107/Tsi107/MPC8240/MPC8245 and
@@ -311,6 +311,20 @@ config I2C_MPC
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-mpc.
 
+config I2C_MPC_PPC
+	tristate "MPC107/824x/85xx/52xx/86xx"
+	depends on PPC32 && !PPC_MERGE
+	help
+	  If you say yes to this option, support will be included for the
+	  built-in I2C interface on the MPC107/Tsi107/MPC8240/MPC8245 and
+	  MPC85xx/MPC8641 family processors. The driver may also work on 52xx
+	  family processors, though interrupts are known not to work.
+ 
+	  This version of the driver is scheduled for deletion with the PPC architecture.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called i2c-mpc.
+
 config I2C_NFORCE2
 	tristate "Nvidia nForce2, nForce3 and nForce4"
 	depends on PCI
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index 81d43c2..b7fe095 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_I2C_IXP2000)	+= i2c-ixp2000.o
 obj-$(CONFIG_I2C_IXP4XX)	+= i2c-ixp4xx.o
 obj-$(CONFIG_I2C_POWERMAC)	+= i2c-powermac.o
 obj-$(CONFIG_I2C_MPC)		+= i2c-mpc.o
+obj-$(CONFIG_I2C_MPC_PPC)	+= i2c-mpc-ppc.o
 obj-$(CONFIG_I2C_MV64XXX)	+= i2c-mv64xxx.o
 obj-$(CONFIG_I2C_NFORCE2)	+= i2c-nforce2.o
 obj-$(CONFIG_I2C_OCORES)	+= i2c-ocores.o
diff --git a/drivers/i2c/busses/i2c-mpc-ppc.c b/drivers/i2c/busses/i2c-mpc-ppc.c
new file mode 100644
index 0000000..d8de4ac
--- /dev/null
+++ b/drivers/i2c/busses/i2c-mpc-ppc.c
@@ -0,0 +1,418 @@
+/*
+ * (C) Copyright 2003-2004
+ * Humboldt Solutions Ltd, adrian@humboldt.co.uk.
+
+ * This is a combined i2c adapter and algorithm driver for the
+ * MPC107/Tsi107 PowerPC northbridge and processors that include
+ * the same I2C unit (8240, 8245, 85xx).
+ *
+ * Release 0.8
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+
+#include <asm/io.h>
+#include <linux/fsl_devices.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+
+#define MPC_I2C_ADDR  0x00
+#define MPC_I2C_FDR 	0x04
+#define MPC_I2C_CR	0x08
+#define MPC_I2C_SR	0x0c
+#define MPC_I2C_DR	0x10
+#define MPC_I2C_DFSRR 0x14
+#define MPC_I2C_REGION 0x20
+
+#define CCR_MEN  0x80
+#define CCR_MIEN 0x40
+#define CCR_MSTA 0x20
+#define CCR_MTX  0x10
+#define CCR_TXAK 0x08
+#define CCR_RSTA 0x04
+
+#define CSR_MCF  0x80
+#define CSR_MAAS 0x40
+#define CSR_MBB  0x20
+#define CSR_MAL  0x10
+#define CSR_SRW  0x04
+#define CSR_MIF  0x02
+#define CSR_RXAK 0x01
+
+struct mpc_i2c {
+	void __iomem *base;
+	u32 interrupt;
+	wait_queue_head_t queue;
+	struct i2c_adapter adap;
+	int irq;
+	u32 flags;
+};
+
+static __inline__ void writeccr(struct mpc_i2c *i2c, u32 x)
+{
+	writeb(x, i2c->base + MPC_I2C_CR);
+}
+
+static irqreturn_t mpc_i2c_isr(int irq, void *dev_id)
+{
+	struct mpc_i2c *i2c = dev_id;
+	if (readb(i2c->base + MPC_I2C_SR) & CSR_MIF) {
+		/* Read again to allow register to stabilise */
+		i2c->interrupt = readb(i2c->base + MPC_I2C_SR);
+		writeb(0, i2c->base + MPC_I2C_SR);
+		wake_up_interruptible(&i2c->queue);
+	}
+	return IRQ_HANDLED;
+}
+
+/* Sometimes 9th clock pulse isn't generated, and slave doesn't release
+ * the bus, because it wants to send ACK.
+ * Following sequence of enabling/disabling and sending start/stop generates
+ * the pulse, so it's all OK.
+ */
+static void mpc_i2c_fixup(struct mpc_i2c *i2c)
+{
+	writeccr(i2c, 0);
+	udelay(30);
+	writeccr(i2c, CCR_MEN);
+	udelay(30);
+	writeccr(i2c, CCR_MSTA | CCR_MTX);
+	udelay(30);
+	writeccr(i2c, CCR_MSTA | CCR_MTX | CCR_MEN);
+	udelay(30);
+	writeccr(i2c, CCR_MEN);
+	udelay(30);
+}
+
+static int i2c_wait(struct mpc_i2c *i2c, unsigned timeout, int writing)
+{
+	unsigned long orig_jiffies = jiffies;
+	u32 x;
+	int result = 0;
+
+	if (i2c->irq == 0)
+	{
+		while (!(readb(i2c->base + MPC_I2C_SR) & CSR_MIF)) {
+			schedule();
+			if (time_after(jiffies, orig_jiffies + timeout)) {
+				pr_debug("I2C: timeout\n");
+				writeccr(i2c, 0);
+				result = -EIO;
+				break;
+			}
+		}
+		x = readb(i2c->base + MPC_I2C_SR);
+		writeb(0, i2c->base + MPC_I2C_SR);
+	} else {
+		/* Interrupt mode */
+		result = wait_event_interruptible_timeout(i2c->queue,
+			(i2c->interrupt & CSR_MIF), timeout * HZ);
+
+		if (unlikely(result < 0)) {
+			pr_debug("I2C: wait interrupted\n");
+			writeccr(i2c, 0);
+		} else if (unlikely(!(i2c->interrupt & CSR_MIF))) {
+			pr_debug("I2C: wait timeout\n");
+			writeccr(i2c, 0);
+			result = -ETIMEDOUT;
+		}
+
+		x = i2c->interrupt;
+		i2c->interrupt = 0;
+	}
+
+	if (result < 0)
+		return result;
+
+	if (!(x & CSR_MCF)) {
+		pr_debug("I2C: unfinished\n");
+		return -EIO;
+	}
+
+	if (x & CSR_MAL) {
+		pr_debug("I2C: MAL\n");
+		return -EIO;
+	}
+
+	if (writing && (x & CSR_RXAK)) {
+		pr_debug("I2C: No RXAK\n");
+		/* generate stop */
+		writeccr(i2c, CCR_MEN);
+		return -EIO;
+	}
+	return 0;
+}
+
+static void mpc_i2c_setclock(struct mpc_i2c *i2c)
+{
+	/* Set clock and filters */
+	if (i2c->flags & FSL_I2C_DEV_SEPARATE_DFSRR) {
+		writeb(0x31, i2c->base + MPC_I2C_FDR);
+		writeb(0x10, i2c->base + MPC_I2C_DFSRR);
+	} else if (i2c->flags & FSL_I2C_DEV_CLOCK_5200)
+		writeb(0x3f, i2c->base + MPC_I2C_FDR);
+	else
+		writel(0x1031, i2c->base + MPC_I2C_FDR);
+}
+
+static void mpc_i2c_start(struct mpc_i2c *i2c)
+{
+	/* Clear arbitration */
+	writeb(0, i2c->base + MPC_I2C_SR);
+	/* Start with MEN */
+	writeccr(i2c, CCR_MEN);
+}
+
+static void mpc_i2c_stop(struct mpc_i2c *i2c)
+{
+	writeccr(i2c, CCR_MEN);
+}
+
+static int mpc_write(struct mpc_i2c *i2c, int target,
+		     const u8 * data, int length, int restart)
+{
+	int i;
+	unsigned timeout = i2c->adap.timeout;
+	u32 flags = restart ? CCR_RSTA : 0;
+
+	/* Start with MEN */
+	if (!restart)
+		writeccr(i2c, CCR_MEN);
+	/* Start as master */
+	writeccr(i2c, CCR_MIEN | CCR_MEN | CCR_MSTA | CCR_MTX | flags);
+	/* Write target byte */
+	writeb((target << 1), i2c->base + MPC_I2C_DR);
+
+	if (i2c_wait(i2c, timeout, 1) < 0)
+		return -1;
+
+	for (i = 0; i < length; i++) {
+		/* Write data byte */
+		writeb(data[i], i2c->base + MPC_I2C_DR);
+
+		if (i2c_wait(i2c, timeout, 1) < 0)
+			return -1;
+	}
+
+	return 0;
+}
+
+static int mpc_read(struct mpc_i2c *i2c, int target,
+		    u8 * data, int length, int restart)
+{
+	unsigned timeout = i2c->adap.timeout;
+	int i;
+	u32 flags = restart ? CCR_RSTA : 0;
+
+	/* Start with MEN */
+	if (!restart)
+		writeccr(i2c, CCR_MEN);
+	/* Switch to read - restart */
+	writeccr(i2c, CCR_MIEN | CCR_MEN | CCR_MSTA | CCR_MTX | flags);
+	/* Write target address byte - this time with the read flag set */
+	writeb((target << 1) | 1, i2c->base + MPC_I2C_DR);
+
+	if (i2c_wait(i2c, timeout, 1) < 0)
+		return -1;
+
+	if (length) {
+		if (length == 1)
+			writeccr(i2c, CCR_MIEN | CCR_MEN | CCR_MSTA | CCR_TXAK);
+		else
+			writeccr(i2c, CCR_MIEN | CCR_MEN | CCR_MSTA);
+		/* Dummy read */
+		readb(i2c->base + MPC_I2C_DR);
+	}
+
+	for (i = 0; i < length; i++) {
+		if (i2c_wait(i2c, timeout, 0) < 0)
+			return -1;
+
+		/* Generate txack on next to last byte */
+		if (i == length - 2)
+			writeccr(i2c, CCR_MIEN | CCR_MEN | CCR_MSTA | CCR_TXAK);
+		/* Generate stop on last byte */
+		if (i == length - 1)
+			writeccr(i2c, CCR_MIEN | CCR_MEN | CCR_TXAK);
+		data[i] = readb(i2c->base + MPC_I2C_DR);
+	}
+
+	return length;
+}
+
+static int mpc_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
+{
+	struct i2c_msg *pmsg;
+	int i;
+	int ret = 0;
+	unsigned long orig_jiffies = jiffies;
+	struct mpc_i2c *i2c = i2c_get_adapdata(adap);
+
+	mpc_i2c_start(i2c);
+
+	/* Allow bus up to 1s to become not busy */
+	while (readb(i2c->base + MPC_I2C_SR) & CSR_MBB) {
+		if (signal_pending(current)) {
+			pr_debug("I2C: Interrupted\n");
+			writeccr(i2c, 0);
+			return -EINTR;
+		}
+		if (time_after(jiffies, orig_jiffies + HZ)) {
+			pr_debug("I2C: timeout\n");
+			if (readb(i2c->base + MPC_I2C_SR) ==
+			    (CSR_MCF | CSR_MBB | CSR_RXAK))
+				mpc_i2c_fixup(i2c);
+			return -EIO;
+		}
+		schedule();
+	}
+
+	for (i = 0; ret >= 0 && i < num; i++) {
+		pmsg = &msgs[i];
+		pr_debug("Doing %s %d bytes to 0x%02x - %d of %d messages\n",
+			 pmsg->flags & I2C_M_RD ? "read" : "write",
+			 pmsg->len, pmsg->addr, i + 1, num);
+		if (pmsg->flags & I2C_M_RD)
+			ret =
+			    mpc_read(i2c, pmsg->addr, pmsg->buf, pmsg->len, i);
+		else
+			ret =
+			    mpc_write(i2c, pmsg->addr, pmsg->buf, pmsg->len, i);
+	}
+	mpc_i2c_stop(i2c);
+	return (ret < 0) ? ret : num;
+}
+
+static u32 mpc_functionality(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
+}
+
+static const struct i2c_algorithm mpc_algo = {
+	.master_xfer = mpc_xfer,
+	.functionality = mpc_functionality,
+};
+
+static struct i2c_adapter mpc_ops = {
+	.owner = THIS_MODULE,
+	.name = "MPC adapter",
+	.id = I2C_HW_MPC107,
+	.algo = &mpc_algo,
+	.class = I2C_CLASS_HWMON,
+	.timeout = 1,
+	.retries = 1
+};
+
+static int fsl_i2c_probe(struct platform_device *pdev)
+{
+	int result = 0;
+	struct mpc_i2c *i2c;
+	struct fsl_i2c_platform_data *pdata;
+	struct resource *r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	pdata = (struct fsl_i2c_platform_data *) pdev->dev.platform_data;
+
+	if (!(i2c = kzalloc(sizeof(*i2c), GFP_KERNEL))) {
+		return -ENOMEM;
+	}
+
+	i2c->irq = platform_get_irq(pdev, 0);
+	if (i2c->irq < 0) {
+		result = -ENXIO;
+		goto fail_get_irq;
+	}
+	i2c->flags = pdata->device_flags;
+	init_waitqueue_head(&i2c->queue);
+
+	i2c->base = ioremap((phys_addr_t)r->start, MPC_I2C_REGION);
+
+	if (!i2c->base) {
+		printk(KERN_ERR "i2c-mpc - failed to map controller\n");
+		result = -ENOMEM;
+		goto fail_map;
+	}
+
+	if (i2c->irq != 0)
+		if ((result = request_irq(i2c->irq, mpc_i2c_isr,
+					  IRQF_SHARED, "i2c-mpc", i2c)) < 0) {
+			printk(KERN_ERR
+			       "i2c-mpc - failed to attach interrupt\n");
+			goto fail_irq;
+		}
+
+	mpc_i2c_setclock(i2c);
+	platform_set_drvdata(pdev, i2c);
+
+	i2c->adap = mpc_ops;
+	i2c->adap.nr = pdev->id;
+	i2c_set_adapdata(&i2c->adap, i2c);
+	i2c->adap.dev.parent = &pdev->dev;
+	if ((result = i2c_add_numbered_adapter(&i2c->adap)) < 0) {
+		printk(KERN_ERR "i2c-mpc - failed to add adapter\n");
+		goto fail_add;
+	}
+
+	return result;
+
+      fail_add:
+	if (i2c->irq != 0)
+		free_irq(i2c->irq, i2c);
+      fail_irq:
+	iounmap(i2c->base);
+      fail_map:
+      fail_get_irq:
+	kfree(i2c);
+	return result;
+};
+
+static int fsl_i2c_remove(struct platform_device *pdev)
+{
+	struct mpc_i2c *i2c = platform_get_drvdata(pdev);
+
+	i2c_del_adapter(&i2c->adap);
+	platform_set_drvdata(pdev, NULL);
+
+	if (i2c->irq != 0)
+		free_irq(i2c->irq, i2c);
+
+	iounmap(i2c->base);
+	kfree(i2c);
+	return 0;
+};
+
+/* Structure for a device driver */
+static struct platform_driver fsl_i2c_driver = {
+	.probe = fsl_i2c_probe,
+	.remove = fsl_i2c_remove,
+	.driver	= {
+		.owner = THIS_MODULE,
+		.name = "fsl-i2c",
+	},
+};
+
+static int __init fsl_i2c_init(void)
+{
+	return platform_driver_register(&fsl_i2c_driver);
+}
+
+static void __exit fsl_i2c_exit(void)
+{
+	platform_driver_unregister(&fsl_i2c_driver);
+}
+
+module_init(fsl_i2c_init);
+module_exit(fsl_i2c_exit);
+
+MODULE_AUTHOR("Adrian Cox <adrian@humboldt.co.uk>");
+MODULE_DESCRIPTION
+    ("I2C-Bus adapter for MPC107 bridge and MPC824x/85xx/52xx processors");
+MODULE_LICENSE("GPL");

