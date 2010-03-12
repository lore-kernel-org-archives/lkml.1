Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab0CLPvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 10:51:19 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:40033 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755736Ab0CLPvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 10:51:17 -0500
X-Greylist: delayed 542 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Mar 2010 10:51:17 EST
Date: Fri, 12 Mar 2010 10:42:14 -0500
To: uClinux development list <uclinux-dev@uclinux.org>
Cc: Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org
Subject: Re: [uClinux-dev] Re: [PATCH v2] m68knommu: driver for Freescale
	Coldfire I2C controller.
Message-ID: <20100312154214.GR4307@caffeine.csclub.uwaterloo.ca>
References: <201001101600.41932.sfking@fdwdc.com> <201001111024.05506.sfking@fdwdc.com> <20100124151519.GB28675@fluff.org.uk> <201001251156.31110.sfking@fdwdc.com> <20100312110453.GA16156@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100312110453.GA16156@frolo.macqel>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 12:04:53PM +0100, Philippe De Muyter wrote:
> Hello all,
> 
> On Mon, Jan 25, 2010 at 11:56:30AM -0800, Steven King wrote:
> > > >
> > > > Add support for the I2C controller used on Freescale/Motorola Coldfire
> > > > MCUs.
> > > >
> > > > Signed-off-by: Steven King <sfking@fdwdc.com>
> 
> What's the status of this ?
> 
> I need to use i2c for a coldfire uclinux project (with a mcf5484) and I
> now have 3 different coldfire i2c drivers, none of which is in mainline.
> 
> i2c-mcf.c (from uClinux-dist-20090618, but not in http://git.kernel.org/?p=linux/kernel/git/gerg/m68knommu.git;a=summary)

It seems I use that one based on the filename.

> i2c-mcf548x.c (from ltib-m5475evb-20080808, found as "Linux BSP for MCF5484LITE, MCF5475/85EVB" at http://www.freescale.com/webapp/sps/site/prod_summary.jsp?code=MCF548X&fpsp=1&tab=Design_Tools_Tab)
> i2c-coldfire.c (from http://lkml.org/lkml/2010/1/11/165)
> 
> I like to work with mainline sources to be be able to contribute to and benefit
> from collective work.
> 
> Which one has the best chances to be put in mainline ?

No idea.

I am using this one on a 5271:

http://www.bitshrine.org/gpp/0006-I2C-device-driver.patch
http://www.bitshrine.org/gpp/0043-I2C-bug-fix.patch

No problems so far.

This is the patch that I use on top of
git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git

diff -urN build-2.6.29-1-m68k-uclinux-target1-nfs/arch/m68k/include/asm/m527xsim.h build-2.6.29-1-m68k-uclinux-target1/arch/m68k/include/asm/m527xsim.h
--- build-2.6.29-1-m68k-uclinux-target1-nfs/arch/m68k/include/asm/m527xsim.h	2010-02-12 11:49:19.000000000 -0500
+++ build-2.6.29-1-m68k-uclinux-target1/arch/m68k/include/asm/m527xsim.h	2010-02-12 12:10:59.000000000 -0500
@@ -248,5 +248,44 @@
 #define	MCF_RCR_SWRESET		0x80		/* Software reset bit */
 #define	MCF_RCR_FRCSTOUT	0x40		/* Force external reset */
 
+/*********************************************************************
+*
+* I2C Module (I2C) (Stolen from m5301xsim.h)
+*
+*********************************************************************/
+/* Register read/write macros */
+#ifdef CONFIG_M5271
+#define MCF_I2C_I2ADR           (volatile unsigned char *)(MCF_MBAR + 0x300)
+#define MCF_I2C_I2FDR           (volatile unsigned char *)(MCF_MBAR + 0x304)
+#define MCF_I2C_I2CR            (volatile unsigned char *)(MCF_MBAR + 0x308)
+#define MCF_I2C_I2SR            (volatile unsigned char *)(MCF_MBAR + 0x30C)
+#define MCF_I2C_I2DR            (volatile unsigned char *)(MCF_MBAR + 0x310)
+
+/* Bit definitions and macros for I2AR */
+#define MCF_I2C_I2AR_ADR(x)     (((x)&0x7F)<<1)
+
+/* Bit definitions and macros for I2FDR */
+#define MCF_I2C_I2FDR_IC(x)     (((x)&0x3F))
+
+/* Bit definitions and macros for I2CR */
+#define MCF_I2C_I2CR_RSTA       (0x04)
+#define MCF_I2C_I2CR_TXAK       (0x08)
+#define MCF_I2C_I2CR_MTX        (0x10)
+#define MCF_I2C_I2CR_MSTA       (0x20)
+#define MCF_I2C_I2CR_IIEN       (0x40)
+#define MCF_I2C_I2CR_IEN        (0x80)
+
+/* Bit definitions and macros for I2SR */
+#define MCF_I2C_I2SR_RXAK       (0x01)
+#define MCF_I2C_I2SR_IIF        (0x02)
+#define MCF_I2C_I2SR_SRW        (0x04)
+#define MCF_I2C_I2SR_IAL        (0x10)
+#define MCF_I2C_I2SR_IBB        (0x20)
+#define MCF_I2C_I2SR_IAAS       (0x40)
+#define MCF_I2C_I2SR_ICF        (0x80)
+
+/* Bit definitions and macros for I2DR */
+#define MCF_I2C_I2DR_DATA(x)    (x)
+#endif /* I2C Module for CONFIG_M5271 */
 /****************************************************************************/
 #endif	/* m527xsim_h */
diff -urN build-2.6.29-1-m68k-uclinux-target1-nfs/drivers/i2c/busses/Kconfig build-2.6.29-1-m68k-uclinux-target1/drivers/i2c/busses/Kconfig
--- build-2.6.29-1-m68k-uclinux-target1-nfs/drivers/i2c/busses/Kconfig	2010-02-12 11:49:21.000000000 -0500
+++ build-2.6.29-1-m68k-uclinux-target1/drivers/i2c/busses/Kconfig	2010-02-12 12:10:59.000000000 -0500
@@ -417,6 +417,16 @@
 	  This driver is deprecated and will be dropped soon. Use i2c-gpio
 	  instead.
 
+config I2C_MCF
+	tristate "MCF ColdFire"
+	depends on I2C && EXPERIMENTAL
+	help
+	  If you say yes to this option, support will be included for the
+	  I2C on most ColdFire CPUs
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called i2c-mcf.
+
 config I2C_MPC
 	tristate "MPC107/824x/85xx/52xx/86xx"
 	depends on PPC32
diff -urN build-2.6.29-1-m68k-uclinux-target1-nfs/drivers/i2c/busses/Makefile build-2.6.29-1-m68k-uclinux-target1/drivers/i2c/busses/Makefile
--- build-2.6.29-1-m68k-uclinux-target1-nfs/drivers/i2c/busses/Makefile	2010-02-12 11:49:21.000000000 -0500
+++ build-2.6.29-1-m68k-uclinux-target1/drivers/i2c/busses/Makefile	2010-02-12 12:10:59.000000000 -0500
@@ -71,6 +71,7 @@
 obj-$(CONFIG_I2C_STUB)		+= i2c-stub.o
 obj-$(CONFIG_SCx200_ACB)	+= scx200_acb.o
 obj-$(CONFIG_SCx200_I2C)	+= scx200_i2c.o
+obj-$(CONFIG_I2C_MCF)		+= i2c-mcf.o
 
 ifeq ($(CONFIG_I2C_DEBUG_BUS),y)
 EXTRA_CFLAGS += -DDEBUG
diff -urN build-2.6.29-1-m68k-uclinux-target1-nfs/drivers/i2c/busses/i2c-mcf.c build-2.6.29-1-m68k-uclinux-target1/drivers/i2c/busses/i2c-mcf.c
--- build-2.6.29-1-m68k-uclinux-target1-nfs/drivers/i2c/busses/i2c-mcf.c	1969-12-31 19:00:00.000000000 -0500
+++ build-2.6.29-1-m68k-uclinux-target1/drivers/i2c/busses/i2c-mcf.c	2010-02-12 12:10:59.000000000 -0500
@@ -0,0 +1,601 @@
+/*
+    i2c-mcf.c - Part of lm_sensors, Linux kernel modules for hardware monitoring
+
+    Copyright (c) 2005, Derek CL Cheung <derek.cheung@sympatico.ca>
+					<http://www3.sympatico.ca/derek.cheung>
+
+    Copyright (c) 2006, emlix Sebastian Hess <sh@emlix.com>
+
+    Yaroslav Vinogradov <yaroslav.vinogradov@freescale.com>
+    Copyright Freescale Semiconductor, Inc 2006-2007
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+
+	Changes:
+	v0.1	26 March 2005
+	Initial Release - developed on uClinux with 2.6.9 kernel
+
+	v0.2	29 May 2006
+	Modified to be more generic and added support for
+	i2c_master_xfer
+
+	v0.3	12 Sep 2007
+	Added support for more Coldfire systems, removed c++ comments
+
+    This I2C adaptor supports the ColdFire 5282 CPU I2C module. Since most Coldfire
+    CPUs' I2C module use the same register set (e.g., MCF5249), the code is very
+    portable and re-usable to other Coldfire CPUs.
+
+    The transmission frequency is set at about 100KHz for the 5282Lite CPU board with
+    8MHz crystal. If the CPU board uses different system clock frequency, you should
+    change the following line:
+                static int __init i2c_coldfire_init(void)
+                {
+                                .........
+                        // Set transmission frequency 0x15 = ~100kHz
+                        *MCF_I2C_I2FDR = 0x15;
+                                ........
+                }
+
+    Remember to perform a dummy read to set the ColdFire CPU's I2C module for read before
+    reading the actual byte from a device
+
+    The I2C_SM_BUS_BLOCK_DATA function are not yet ready but most lm_senors do not care
+
+*/
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/i2c.h>
+#include <linux/delay.h>
+#include <linux/string.h>
+#include <asm/coldfire.h>
+#include <asm/mcfsim.h>
+#include <asm/types.h>
+#include <linux/platform_device.h>
+#include "i2c-mcf.h"
+
+static struct i2c_algorithm coldfire_algorithm = {
+	.smbus_xfer = coldfire_i2c_access,
+	.master_xfer = coldfire_i2c_master,
+	.functionality = coldfire_func,
+};
+
+static struct i2c_adapter coldfire_adapter = {
+	.owner = THIS_MODULE,
+	.class = I2C_CLASS_HWMON,
+	.algo = &coldfire_algorithm,
+	.name = "ColdFire I2C adapter",
+};
+
+__u16 lastaddr;
+__u16 lastop;
+
+static inline int coldfire_do_first_start(__u16 addr, __u16 flags)
+{
+	int err;
+	/*
+	 * Generate a stop and put the I2C module into slave mode
+	 */
+	*MCF_I2C_I2CR &= ~MCF_I2C_I2CR_MSTA;
+
+	/*
+	 * Generate a new Start signal
+	 */
+	err =
+	    coldfire_i2c_start(flags & I2C_M_RD ? I2C_SMBUS_READ :
+			       I2C_SMBUS_WRITE, addr, FIRST_START);
+	if (err)
+		return err;
+
+	lastaddr = addr;
+	lastop = flags & I2C_M_RD;	/* Ensure everything for new start */
+	return 0;
+}
+
+/*
+ *  read one byte data from the I2C bus
+ */
+static int coldfire_read_data(u8 * const rxData,
+			      const enum I2C_ACK_TYPE ackType)
+{
+
+	int timeout;
+
+	*MCF_I2C_I2CR &= ~MCF_I2C_I2CR_MTX;	/* master receive mode */
+
+	if (ackType == NACK)
+		*MCF_I2C_I2CR |= MCF_I2C_I2CR_TXAK;	/* generate NA */
+	else
+		*MCF_I2C_I2CR &= ~MCF_I2C_I2CR_TXAK;	/* generate ACK */
+
+	/* read data from the I2C bus */
+	*rxData = *MCF_I2C_I2DR;
+
+	/* printk(">>> %s I2DR data is %.2x \n", __FUNCTION__, *rxData); */
+
+	/* wait for data transfer to complete */
+	timeout = 500;
+	while (timeout-- && !(*MCF_I2C_I2SR & MCF_I2C_I2SR_IIF))
+		udelay(1);
+	if (timeout <= 0)
+		printk("%s - I2C IIF never set. Timeout is %d \n", __FUNCTION__,
+		       timeout);
+
+	/* reset the interrupt bit */
+	*MCF_I2C_I2SR &= ~MCF_I2C_I2SR_IIF;
+
+	if (timeout <= 0)
+		return -1;
+	else
+		return 0;
+
+};
+
+/*
+ *  write one byte data onto the I2C bus
+ */
+static int coldfire_write_data(const u8 txData)
+{
+
+	int timeout;
+
+	timeout = 500;
+
+	*MCF_I2C_I2CR |= MCF_I2C_I2CR_MTX;	/* I2C module into TX mode */
+	*MCF_I2C_I2DR = txData;	/* send the data */
+
+	/* wait for data transfer to complete */
+	/* rely on the interrupt handling bit */
+	timeout = 500;
+	while (timeout-- && !(*MCF_I2C_I2SR & MCF_I2C_I2SR_IIF))
+		udelay(1);
+	if (timeout <= 0)
+		printk("%s - I2C IIF never set. Timeout is %d \n", __FUNCTION__,
+		       timeout);
+
+	/* reset the interrupt bit */
+	*MCF_I2C_I2SR &= ~MCF_I2C_I2SR_IIF;
+#if defined(CONFIG_M532x) || defined(CONFIG_M537x)
+	if (timeout <= 0 || (*MCF_I2C_I2SR & MCF_I2C_I2SR_RXAK))
+#else
+	if (timeout <= 0)
+#endif
+		return -1;
+	else
+		return 0;
+
+};
+
+/*
+ *  Generate I2C start or repeat start signal
+ *  Combine the 7 bit target_address and the R/W bit and put it onto the I2C bus
+ */
+static int coldfire_i2c_start(const char read_write, const u16 target_address,
+			      const enum I2C_START_TYPE start_type)
+{
+
+	int timeout;
+
+	/* printk(">>> %s START TYPE %s \n", __FUNCTION__, start_type == FIRST_START ? "FIRST_START" : "REPEAT_START"); */
+
+	*MCF_I2C_I2CR |= MCF_I2C_I2CR_IEN;
+
+	if (start_type == FIRST_START) {
+		/* Make sure the I2C bus is idle */
+		timeout = 500;	/* 500us timeout */
+		while (timeout-- && (*MCF_I2C_I2SR & MCF_I2C_I2SR_IBB))
+			udelay(1);
+		if (timeout <= 0) {
+			printk
+			    ("%s - I2C bus always busy in the past 500us timeout is %d \n",
+			     __FUNCTION__, timeout);
+			goto check_rc;
+		}
+		/* generate a START and put the I2C module into MASTER TX mode */
+		*MCF_I2C_I2CR |= (MCF_I2C_I2CR_MSTA | MCF_I2C_I2CR_MTX);
+
+		/* wait for bus busy to be set */
+		timeout = 500;
+		while (timeout-- && !(*MCF_I2C_I2SR & MCF_I2C_I2SR_IBB))
+			udelay(1);
+		if (timeout <= 0) {
+			printk
+			    ("%s - I2C bus is never busy after START. Timeout is %d \n",
+			     __FUNCTION__, timeout);
+			goto check_rc;
+		}
+
+	} else {
+		/* this is repeat START */
+		udelay(500);	/* need some delay before repeat start */
+		*MCF_I2C_I2CR |= (MCF_I2C_I2CR_MSTA | MCF_I2C_I2CR_RSTA);
+	}
+
+	/* combine the R/W bit and the 7 bit target address and put it onto the I2C bus */
+	*MCF_I2C_I2DR =
+	    ((target_address & 0x7F) << 1) | (read_write ==
+					      I2C_SMBUS_WRITE ? 0x00 : 0x01);
+
+	/* wait for bus transfer to complete */
+	/* when one byte transfer is completed, IIF set at the faling edge of the 9th clock */
+	timeout = 500;
+	while (timeout-- && !(*MCF_I2C_I2SR & MCF_I2C_I2SR_IIF))
+		udelay(1);
+	if (timeout <= 0)
+		printk("%s - I2C IIF never set. Timeout is %d \n", __FUNCTION__,
+		       timeout);
+
+      check_rc:
+	/* reset the interrupt bit */
+	*MCF_I2C_I2SR &= ~MCF_I2C_I2SR_IIF;
+
+#if defined(CONFIG_M532x) || defined(CONFIG_M537x)
+	if (timeout <= 0 || (*MCF_I2C_I2SR & MCF_I2C_I2SR_RXAK))
+#else
+	if (timeout <= 0)
+#endif
+		return -1;
+	else
+		return 0;
+};
+
+/*
+ *  5282 SMBUS supporting functions
+ */
+
+static s32 coldfire_i2c_access(struct i2c_adapter *adap, u16 addr,
+			       unsigned short flags, char read_write,
+			       u8 command, int size, union i2c_smbus_data *data)
+{
+	int i, len, rc = 0;
+	u8 rxData, tempRxData[2];
+
+	switch (size) {
+	case I2C_SMBUS_QUICK:
+		rc = coldfire_i2c_start(read_write, addr, FIRST_START);	/* generate START */
+		break;
+	case I2C_SMBUS_BYTE:
+		rc = coldfire_i2c_start(read_write, addr, FIRST_START);
+		*MCF_I2C_I2CR |= MCF_I2C_I2CR_TXAK;	/* generate NA */
+		if (read_write == I2C_SMBUS_WRITE)
+			rc += coldfire_write_data(command);
+		else {
+			coldfire_read_data(&rxData, NACK);	/* dummy read */
+			rc += coldfire_read_data(&rxData, NACK);
+			data->byte = rxData;
+		}
+		*MCF_I2C_I2CR &= ~MCF_I2C_I2CR_TXAK;	/* reset ACK bit */
+		break;
+	case I2C_SMBUS_BYTE_DATA:
+		rc = coldfire_i2c_start(I2C_SMBUS_WRITE, addr, FIRST_START);
+		rc += coldfire_write_data(command);
+		if (read_write == I2C_SMBUS_WRITE)
+			rc += coldfire_write_data(data->byte);
+		else {
+			/* This is SMBus READ Byte Data Request. Perform REPEAT START */
+			rc +=
+			    coldfire_i2c_start(I2C_SMBUS_READ, addr,
+					       REPEAT_START);
+			coldfire_read_data(&rxData, ACK);	/* dummy read */
+			/* Disable Acknowledge, generate STOP after next byte transfer */
+			rc += coldfire_read_data(&rxData, NACK);
+			data->byte = rxData;
+		}
+		*MCF_I2C_I2CR &= ~MCF_I2C_I2CR_TXAK;	/* reset to normal ACk */
+		break;
+	case I2C_SMBUS_PROC_CALL:
+	case I2C_SMBUS_WORD_DATA:
+		dev_info(&adap->dev, "size = I2C_SMBUS_WORD_DATA \n");
+		rc = coldfire_i2c_start(I2C_SMBUS_WRITE, addr, FIRST_START);
+		rc += coldfire_write_data(command);
+		if (read_write == I2C_SMBUS_WRITE) {
+			rc += coldfire_write_data(data->word & 0x00FF);
+			rc += coldfire_write_data((data->word & 0x00FF) >> 8);
+		} else {
+			/* This is SMBUS READ WORD request. Peform REPEAT START */
+			rc +=
+			    coldfire_i2c_start(I2C_SMBUS_READ, addr,
+					       REPEAT_START);
+			coldfire_read_data(&rxData, ACK);	/* dummy read */
+			/* Disable Acknowledge, generate STOP after next byte transfer */
+			/* read the MS byte from the device */
+			rc += coldfire_read_data(&rxData, NACK);
+			tempRxData[1] = rxData;
+			/* read the LS byte from the device */
+			rc += coldfire_read_data(&rxData, NACK);
+			tempRxData[0] = rxData;
+			/* the host driver expect little endian convention. Swap the byte */
+			data->word = (tempRxData[0] << 8) | tempRxData[1];
+		}
+		*MCF_I2C_I2CR &= ~MCF_I2C_I2CR_TXAK;
+		break;
+	case I2C_SMBUS_BLOCK_DATA:
+		/* this is not ready yet!!! */
+		break;
+	case I2C_SMBUS_BLOCK_PROC_CALL:
+		{
+			rc = coldfire_i2c_start(I2C_SMBUS_WRITE, addr,
+						FIRST_START);
+			rc += coldfire_write_data(command);
+			if (read_write == I2C_SMBUS_READ) {
+				/* This is SMBUS READ BLOCK request. Peform REPEAT START */
+				rc +=
+				    coldfire_i2c_start(I2C_SMBUS_READ, addr,
+						       REPEAT_START);
+				coldfire_read_data(&rxData, ACK);	/* dummy read */
+				len = data->block[0];
+				if (len < 0)
+					len = 0;
+				if (len > 32)
+					len = 32;
+				for (i = 1; i < len; i++) {
+					/* read byte from the device */
+					rc +=
+					    coldfire_read_data(&data->block[i],
+							       ACK);
+				}
+				/* read last byte from the device */
+				rc += coldfire_read_data(&data->block[i], NACK);
+			}
+			*MCF_I2C_I2CR &= ~MCF_I2C_I2CR_TXAK;
+			break;
+		}
+	default:
+		printk("Unsupported I2C size \n");
+		rc = -1;
+		break;
+	};
+
+	/* Generate a STOP and put I2C module into slave mode */
+	*MCF_I2C_I2CR &= ~MCF_I2C_I2CR_MSTA;
+
+	/* restore interrupt */
+	*MCF_I2C_I2CR |= MCF_I2C_I2CR_IIEN;
+
+	if (rc < 0)
+		return -1;
+	else
+		return 0;
+};
+
+/*
+ *  List the SMBUS functions supported by this I2C adaptor
+ *  Also tell the I2C Subsystem that we are able of master_xfer()
+ */
+static u32 coldfire_func(struct i2c_adapter *adapter)
+{
+	return (I2C_FUNC_SMBUS_QUICK |
+		I2C_FUNC_SMBUS_BYTE |
+		I2C_FUNC_SMBUS_PROC_CALL |
+		I2C_FUNC_SMBUS_BYTE_DATA |
+		I2C_FUNC_SMBUS_WORD_DATA |
+		I2C_FUNC_I2C | I2C_FUNC_SMBUS_BLOCK_DATA);
+};
+
+static int coldfire_i2c_master(struct i2c_adapter *adap, struct i2c_msg *msgs,
+			       int num)
+{
+	u8 dummyRead;
+	struct i2c_msg *p;
+	int i, err = 0;
+	int ic = 0;
+
+	lastaddr = 0;
+	lastop = 8;
+
+	/* disable the IRQ, we are doing polling */
+	*MCF_I2C_I2CR &= ~MCF_I2C_I2CR_IIEN;
+
+	dev_dbg(&adap->dev, "Num of actions: %d\n", num);
+
+	for (i = 0; !err && i < num; i++) {
+		p = &msgs[i];
+
+		if (!p->len) {
+			dev_dbg(&adap->dev, "p->len == 0!\n");
+			continue;
+		}
+		/*
+		 * Generate a new Start, if the target address differs from the last target,
+		 * generate a stop in this case first
+		 */
+		if (p->addr != lastaddr) {
+			err = coldfire_do_first_start(p->addr, p->flags);
+			if (err) {
+				dev_dbg(&adap->dev, "First Init failed!\n");
+				break;
+			}
+		}
+
+		else if ((p->flags & I2C_M_RD) != lastop) {
+			/*
+			 * If the Operational Mode changed, we need to do this here ...
+			 */
+			dev_dbg(&adap->dev,
+				"%s(): Direction changed, was: %d; is now: %d\n",
+				__FUNCTION__, lastop, p->flags & I2C_M_RD);
+
+			/* Last op was an read, now it's write: complete stop and reinit */
+			if (lastop & I2C_M_RD) {
+				dev_dbg(&adap->dev,
+					"%s(): The device is in read state, we must reset!\n",
+					__FUNCTION__);
+				if ((err =
+				     coldfire_do_first_start(p->addr,
+							     p->flags)))
+					break;
+			} else {
+				dev_dbg(&adap->dev,
+					"%s(): We switchted to read mode\n",
+					__FUNCTION__);
+				if ((err =
+				     coldfire_i2c_start((p->
+							 flags & I2C_M_RD) ?
+							I2C_SMBUS_READ :
+							I2C_SMBUS_WRITE,
+							p->addr, REPEAT_START)))
+					break;
+			}
+
+			lastop = p->flags & I2C_M_RD;	/* Save the last op */
+		}
+
+		if (p->flags & I2C_M_RD) {
+			/*
+			 * When ever we get here, a new session was activated, so
+			 * read a dummy byte
+			 */
+			coldfire_read_data(&dummyRead, ACK);
+			/*
+			 * read p->len -1 bytes with ACK to the slave,
+			 * read the last byte without the ACK, to inform him about the
+			 * stop afterwards
+			 */
+			ic = 0;
+			while (!err && (ic < p->len - 1)) {
+				err = coldfire_read_data(p->buf + ic, ACK);
+				ic++;
+			}
+			if (!err)
+				err = coldfire_read_data(p->buf + ic, NACK);
+			dev_dbg(&coldfire_adapter.dev, "read: %2x\n",
+				p->buf[ic]);
+		} else {
+			if (p->len == 2)
+				dev_dbg(&coldfire_adapter.dev,
+					"writing: 0x %2x %2x\n", p->buf[0],
+					p->buf[1]);
+
+			/*
+			 * Write data to the slave
+			 */
+			for (ic = 0; !err && ic < p->len; ic++) {
+				err = coldfire_write_data(p->buf[ic]);
+				if (err) {
+					dev_dbg(&coldfire_adapter.dev,
+						"Failed to write data\n");
+				}
+			}
+		}
+	}
+
+	/*
+	 * Put the device into slave mode to enable the STOP Generation (the RTC needs this)
+	 */
+	*MCF_I2C_I2CR &= ~MCF_I2C_I2CR_MSTA;
+
+	*MCF_I2C_I2CR &= ~MCF_I2C_I2CR_TXAK;	/* reset the ACK bit */
+
+	/* restore interrupt */
+	*MCF_I2C_I2CR |= MCF_I2C_I2CR_IIEN;
+
+	/* Return the number of messages processed, or the error code. */
+	if (err == 0)
+		err = num;
+	return err;
+}
+
+/*
+ *  Initalize the 5282 I2C module
+ *  Disable the 5282 I2C interrupt capability. Just use callback
+ */
+
+static int __init i2c_coldfire_init(void)
+{
+	int retval;
+	u8 dummyRead;
+
+#if defined(CONFIG_M532x) || defined(CONFIG_M523x) || defined(CONFIG_M537x)
+	/*
+	 * Initialize the GPIOs for I2C
+	 */
+	MCF_GPIO_PAR_FECI2C |= (0 | MCF_GPIO_PAR_FECI2C_PAR_SDA(3)
+				| MCF_GPIO_PAR_FECI2C_PAR_SCL(3));
+#elif defined(CONFIG_M5253)
+	{
+		volatile u32 *reg;
+		/* GPIO Bit 41 = SCL0, Bit 42 = SDA0 */
+		reg = (volatile u32 *)(MCF_MBAR2 + MCFSIM2_GPIO1FUNC);
+		*reg &= 0xFFFFF9FF;
+	}
+#elif defined(CONFIG_M5227x)
+	/* Initialize the GPIOs for I2C */
+	MCF_GPIO_PAR_I2C |= (0
+			     | MCF_GPIO_PAR_I2C_PAR_SDA_SDA
+			     | MCF_GPIO_PAR_I2C_PAR_SCL_SCL);
+#elif defined(CONFIG_M5301x)
+	MCF_GPIO_PAR_FECI2C |= (0
+				| MCF_GPIO_PAR_FECI2C_PAR_SDA_SDA
+				| MCF_GPIO_PAR_FECI2C_PAR_SCL_SCL);
+#else
+	/* Initialize PASP0 and PASP1 to I2C functions, 5282 user guide 26-19 */
+	/* Port AS Pin Assignment Register (PASPAR)             */
+	/*              PASPA1 = 11 = AS1 pin is I2C SDA        */
+	/*              PASPA0 = 11 = AS0 pin is I2C SCL        */
+	*MCF5282_GPIO_PASPAR |= 0x000F;	/* u16 declaration */
+#endif
+
+	/* Set transmission frequency 0x15 = ~100kHz */
+	*MCF_I2C_I2FDR = 0x15;
+
+	/* set the 5282 I2C slave address though we never use it */
+	*MCF_I2C_I2ADR = 0x6A;
+
+	/* Enable I2C module and if IBB is set, do the special initialzation */
+	/* procedures as are documented at the 5282 User Guide page 24-11 */
+	*MCF_I2C_I2CR |= MCF_I2C_I2CR_IEN;
+	if ((*MCF_I2C_I2SR & MCF_I2C_I2SR_IBB) == 1) {
+		printk("%s - do special 5282 I2C init procedures \n",
+		       __FUNCTION__);
+		*MCF_I2C_I2CR = 0x00;
+		*MCF_I2C_I2CR = 0xA0;
+		dummyRead = *MCF_I2C_I2DR;
+		*MCF_I2C_I2SR = 0x00;
+		*MCF_I2C_I2CR = 0x00;
+	}
+
+	/* default I2C mode is - slave and receive */
+	*MCF_I2C_I2CR &= ~(MCF_I2C_I2CR_MSTA | MCF_I2C_I2CR_MTX);
+
+	coldfire_adapter.dev.parent = &platform_bus;
+	retval = i2c_add_adapter(&coldfire_adapter);
+
+	if (retval < 0)
+		printk("%s - return code is: %d \n", __FUNCTION__, retval);
+
+	return retval;
+};
+
+/*
+ *  I2C module exit function
+ */
+
+static void __exit i2c_coldfire_exit(void)
+{
+	/* disable I2C and Interrupt */
+	*MCF_I2C_I2CR &= ~(MCF_I2C_I2CR_IEN | MCF_I2C_I2CR_IIEN);
+	i2c_del_adapter(&coldfire_adapter);
+
+};
+
+MODULE_AUTHOR("Derek CL Cheung <derek.cheung@sympatico.ca>");
+MODULE_DESCRIPTION("MCF5282 I2C adaptor");
+MODULE_LICENSE("GPL");
+
+module_init(i2c_coldfire_init);
+module_exit(i2c_coldfire_exit);
diff -urN build-2.6.29-1-m68k-uclinux-target1-nfs/drivers/i2c/busses/i2c-mcf.h build-2.6.29-1-m68k-uclinux-target1/drivers/i2c/busses/i2c-mcf.h
--- build-2.6.29-1-m68k-uclinux-target1-nfs/drivers/i2c/busses/i2c-mcf.h	1969-12-31 19:00:00.000000000 -0500
+++ build-2.6.29-1-m68k-uclinux-target1/drivers/i2c/busses/i2c-mcf.h	2010-02-12 12:10:59.000000000 -0500
@@ -0,0 +1,52 @@
+/*
+    i2c-mcf5282.h - header file for i2c-mcf5282.c
+
+    Copyright (c) 2005, Derek CL Cheung <derek.cheung@sympatico.ca>
+                                        <http://www3.sympatico.ca/derek.cheung>
+
+    Copyright (c) 2006, emlix and Freescale
+			Sebastian Hess <sh@emlix.com>
+			Yaroslav Vinogradov <yaroslav.vinogradov@freescale.com>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+
+    Changes:
+    v0.1	26 March 2005
+        	Initial Release - developed on uClinux with 2.6.9 kernel
+    v0.2	29 May 2006
+		Modified to be more generic and added support for
+		i2c_master_xfer
+*/
+
+
+#ifndef __I2C_MCF5282_H__
+#define __I2C_MCF5282_H__
+
+enum I2C_START_TYPE { FIRST_START, REPEAT_START };
+enum I2C_ACK_TYPE { ACK, NACK};
+
+/* Function prototypes */
+static u32 coldfire_func(struct i2c_adapter *adapter);
+static s32 coldfire_i2c_access(struct i2c_adapter *adap, u16 address,
+                              unsigned short flags, char read_write,
+                              u8 command, int size, union i2c_smbus_data *data);
+static int coldfire_write_data(const u8 data);
+static int coldfire_i2c_start(const char read_write, const u16 target_address, const enum I2C_START_TYPE i2c_start);
+static int coldfire_read_data(u8 * const rxData, const enum I2C_ACK_TYPE ackType);
+static int coldfire_i2c_master(struct i2c_adapter *adap,struct i2c_msg *msgs, int num);
+void dumpReg(char *, u16 addr, u8 data);
+
+/********************************************************************/
+#endif /*  __I2C_MCF5282_H__ */

I think that __I2C_MCF5282_H__ should be __I2C_MCF_H__ instead, but well
what can you do.

-- 
Len Sorensen
