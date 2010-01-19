Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863Ab0ASR55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab0ASR55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 12:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664Ab0ASR5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 12:57:55 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:41486 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753778Ab0ASR5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 12:57:40 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-kernel@vger.kernel.org
Cc: Nick Bowler <nbowler@draconx.ca>
Subject: [PATCH 2/2] Fix spelling of "occurred" in printk messages.
Date: Tue, 19 Jan 2010 12:57:08 -0500
Message-Id: <1263923828-15387-2-git-send-email-nbowler@elliptictech.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263923828-15387-1-git-send-email-nbowler@elliptictech.com>
References: <1263923828-15387-1-git-send-email-nbowler@elliptictech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Bowler <nbowler@draconx.ca>

The word "occurred" is spelled incorrectly throughout the kernel.  This
patch corrects such errors in any string literals which are passed to
printk.

Occurrences were found with cscope and then manually corrected.  Strings
which refer to variables or functions in the code were not modified.  No
attempt was made to correct the spelling of other words.

Signed-off-by: Nick Bowler <nbowler@draconx.ca>
---
 arch/blackfin/include/asm/traps.h       |    2 +-
 arch/cris/arch-v32/mach-a3/arbiter.c    |    5 +++--
 arch/cris/arch-v32/mach-fs/arbiter.c    |    2 +-
 arch/powerpc/sysdev/axonram.c           |    2 +-
 drivers/media/video/ov9640.c            |    2 +-
 drivers/mtd/nand/sh_flctl.c             |   10 +++++-----
 drivers/net/ipg.c                       |   12 ++++++------
 drivers/net/smsc911x.c                  |    2 +-
 drivers/net/smsc9420.c                  |    2 +-
 drivers/net/via-rhine.c                 |    2 +-
 drivers/parisc/pdc_stable.c             |    2 +-
 drivers/pnp/pnpbios/bioscalls.c         |    2 +-
 drivers/scsi/3w-9xxx.h                  |    2 +-
 drivers/serial/sn_console.c             |    2 +-
 drivers/staging/comedi/drivers/me4000.c |    4 ++--
 drivers/staging/octeon/cvmx-helper.c    |    2 +-
 drivers/usb/gadget/amd5536udc.c         |    8 ++++----
 drivers/usb/gadget/fsl_udc_core.c       |    2 +-
 drivers/usb/host/fhci-tds.c             |    4 ++--
 fs/ecryptfs/main.c                      |    2 +-
 net/netfilter/nf_conntrack_core.c       |    2 +-
 sound/pci/pcxhr/pcxhr_core.c            |    8 ++++----
 22 files changed, 41 insertions(+), 40 deletions(-)

diff --git a/arch/blackfin/include/asm/traps.h b/arch/blackfin/include/asm/traps.h
index 9fe0da6..70c4e51 100644
--- a/arch/blackfin/include/asm/traps.h
+++ b/arch/blackfin/include/asm/traps.h
@@ -57,7 +57,7 @@
 #define HWC_x3(level) \
 	"External Memory Addressing Error\n"
 #define EXC_0x04(level) \
-	"Unimplmented exception occured\n" \
+	"Unimplmented exception occurred\n" \
 	level " - Maybe you forgot to install a custom exception handler?\n"
 #define HWC_x12(level) \
 	"Performance Monitor Overflow\n"
diff --git a/arch/cris/arch-v32/mach-a3/arbiter.c b/arch/cris/arch-v32/mach-a3/arbiter.c
index 8b924db..ecc8de8 100644
--- a/arch/cris/arch-v32/mach-a3/arbiter.c
+++ b/arch/cris/arch-v32/mach-a3/arbiter.c
@@ -568,7 +568,7 @@ crisv32_foo_arbiter_irq(int irq, void *dev_id)
 	REG_WR(marb_foo_bp, watch->instance, rw_ack, ack);
 	REG_WR(marb_foo, regi_marb_foo, rw_ack_intr, ack_intr);
 
-	printk(KERN_DEBUG "IRQ occured at %X\n", (unsigned)get_irq_regs());
+	printk(KERN_DEBUG "IRQ occurred at %X\n", (unsigned)get_irq_regs());
 
 	if (watch->cb)
 		watch->cb();
@@ -624,7 +624,8 @@ crisv32_bar_arbiter_irq(int irq, void *dev_id)
 	REG_WR(marb_bar_bp, watch->instance, rw_ack, ack);
 	REG_WR(marb_bar, regi_marb_bar, rw_ack_intr, ack_intr);
 
-	printk(KERN_DEBUG "IRQ occured at %X\n", (unsigned)get_irq_regs()->erp);
+	printk(KERN_DEBUG "IRQ occurred at %X\n",
+		(unsigned)get_irq_regs()->erp);
 
 	if (watch->cb)
 		watch->cb();
diff --git a/arch/cris/arch-v32/mach-fs/arbiter.c b/arch/cris/arch-v32/mach-fs/arbiter.c
index 84d31bd..e7b43f2 100644
--- a/arch/cris/arch-v32/mach-fs/arbiter.c
+++ b/arch/cris/arch-v32/mach-fs/arbiter.c
@@ -395,7 +395,7 @@ static irqreturn_t crisv32_arbiter_irq(int irq, void *dev_id)
 	REG_WR(marb_bp, watch->instance, rw_ack, ack);
 	REG_WR(marb, regi_marb, rw_ack_intr, ack_intr);
 
-	printk(KERN_INFO "IRQ occured at %lX\n", get_irq_regs()->erp);
+	printk(KERN_INFO "IRQ occurred at %lX\n", get_irq_regs()->erp);
 
 	if (watch->cb)
 		watch->cb();
diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index 88f4ae7..4a34067 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -95,7 +95,7 @@ axon_ram_irq_handler(int irq, void *dev)
 
 	BUG_ON(!bank);
 
-	dev_err(&device->dev, "Correctable memory error occured\n");
+	dev_err(&device->dev, "Correctable memory error occurred\n");
 	bank->ecc_counter++;
 	return IRQ_HANDLED;
 }
diff --git a/drivers/media/video/ov9640.c b/drivers/media/video/ov9640.c
index 47bf60c..ec4184c 100644
--- a/drivers/media/video/ov9640.c
+++ b/drivers/media/video/ov9640.c
@@ -271,7 +271,7 @@ static int ov9640_reset(struct i2c_client *client)
 	ret = ov9640_reg_write(client, OV9640_COM7, OV9640_COM7_SCCB_RESET);
 	if (ret)
 		dev_err(&client->dev,
-			"An error occured while entering soft reset!\n");
+			"An error occurred while entering soft reset!\n");
 
 	return ret;
 }
diff --git a/drivers/mtd/nand/sh_flctl.c b/drivers/mtd/nand/sh_flctl.c
index 02bef21..7f2bf73 100644
--- a/drivers/mtd/nand/sh_flctl.c
+++ b/drivers/mtd/nand/sh_flctl.c
@@ -87,7 +87,7 @@ static void wait_completion(struct sh_flctl *flctl)
 		udelay(1);
 	}
 
-	printk(KERN_ERR "wait_completion(): Timeout occured \n");
+	printk(KERN_ERR "wait_completion(): Timeout occurred \n");
 	writeb(0x0, FLTRCR(flctl));
 }
 
@@ -132,7 +132,7 @@ static void wait_rfifo_ready(struct sh_flctl *flctl)
 			return;
 		udelay(1);
 	}
-	printk(KERN_ERR "wait_rfifo_ready(): Timeout occured \n");
+	printk(KERN_ERR "wait_rfifo_ready(): Timeout occurred \n");
 }
 
 static void wait_wfifo_ready(struct sh_flctl *flctl)
@@ -146,7 +146,7 @@ static void wait_wfifo_ready(struct sh_flctl *flctl)
 			return;
 		udelay(1);
 	}
-	printk(KERN_ERR "wait_wfifo_ready(): Timeout occured \n");
+	printk(KERN_ERR "wait_wfifo_ready(): Timeout occurred \n");
 }
 
 static int wait_recfifo_ready(struct sh_flctl *flctl, int sector_number)
@@ -198,7 +198,7 @@ static int wait_recfifo_ready(struct sh_flctl *flctl, int sector_number)
 		writel(0, FL4ECCCR(flctl));
 	}
 
-	printk(KERN_ERR "wait_recfifo_ready(): Timeout occured \n");
+	printk(KERN_ERR "wait_recfifo_ready(): Timeout occurred \n");
 	return 1;	/* timeout */
 }
 
@@ -214,7 +214,7 @@ static void wait_wecfifo_ready(struct sh_flctl *flctl)
 			return;
 		udelay(1);
 	}
-	printk(KERN_ERR "wait_wecfifo_ready(): Timeout occured \n");
+	printk(KERN_ERR "wait_wecfifo_ready(): Timeout occurred \n");
 }
 
 static void read_datareg(struct sh_flctl *flctl, int offset)
diff --git a/drivers/net/ipg.c b/drivers/net/ipg.c
index ba8d246..bf4491c 100644
--- a/drivers/net/ipg.c
+++ b/drivers/net/ipg.c
@@ -1145,13 +1145,13 @@ static int ipg_nic_rx_check_error(struct net_device *dev)
 
 		/* Increment detailed receive error statistics. */
 		if (le64_to_cpu(rxfd->rfs) & IPG_RFS_RXFIFOOVERRUN) {
-			IPG_DEBUG_MSG("RX FIFO overrun occured.\n");
+			IPG_DEBUG_MSG("RX FIFO overrun occurred.\n");
 
 			sp->stats.rx_fifo_errors++;
 		}
 
 		if (le64_to_cpu(rxfd->rfs) & IPG_RFS_RXRUNTFRAME) {
-			IPG_DEBUG_MSG("RX runt occured.\n");
+			IPG_DEBUG_MSG("RX runt occurred.\n");
 			sp->stats.rx_length_errors++;
 		}
 
@@ -1160,7 +1160,7 @@ static int ipg_nic_rx_check_error(struct net_device *dev)
 		 */
 
 		if (le64_to_cpu(rxfd->rfs) & IPG_RFS_RXALIGNMENTERROR) {
-			IPG_DEBUG_MSG("RX alignment error occured.\n");
+			IPG_DEBUG_MSG("RX alignment error occurred.\n");
 			sp->stats.rx_frame_errors++;
 		}
 
@@ -1425,12 +1425,12 @@ static int ipg_nic_rx(struct net_device *dev)
 
 			/* Increment detailed receive error statistics. */
 			if (le64_to_cpu(rxfd->rfs) & IPG_RFS_RXFIFOOVERRUN) {
-				IPG_DEBUG_MSG("RX FIFO overrun occured.\n");
+				IPG_DEBUG_MSG("RX FIFO overrun occurred.\n");
 				sp->stats.rx_fifo_errors++;
 			}
 
 			if (le64_to_cpu(rxfd->rfs) & IPG_RFS_RXRUNTFRAME) {
-				IPG_DEBUG_MSG("RX runt occured.\n");
+				IPG_DEBUG_MSG("RX runt occurred.\n");
 				sp->stats.rx_length_errors++;
 			}
 
@@ -1440,7 +1440,7 @@ static int ipg_nic_rx(struct net_device *dev)
 			 */
 
 			if (le64_to_cpu(rxfd->rfs) & IPG_RFS_RXALIGNMENTERROR) {
-				IPG_DEBUG_MSG("RX alignment error occured.\n");
+				IPG_DEBUG_MSG("RX alignment error occurred.\n");
 				sp->stats.rx_frame_errors++;
 			}
 
diff --git a/drivers/net/smsc911x.c b/drivers/net/smsc911x.c
index 494cd91..4d0f260 100644
--- a/drivers/net/smsc911x.c
+++ b/drivers/net/smsc911x.c
@@ -1666,7 +1666,7 @@ static int smsc911x_eeprom_send_cmd(struct smsc911x_data *pdata, u32 op)
 	}
 
 	if (e2cmd & E2P_CMD_EPC_TIMEOUT_) {
-		SMSC_TRACE(DRV, "Error occured during eeprom operation");
+		SMSC_TRACE(DRV, "Error occurred during eeprom operation");
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/smsc9420.c b/drivers/net/smsc9420.c
index 12f0f5d..5ceed06 100644
--- a/drivers/net/smsc9420.c
+++ b/drivers/net/smsc9420.c
@@ -363,7 +363,7 @@ static int smsc9420_eeprom_send_cmd(struct smsc9420_pdata *pd, u32 op)
 	}
 
 	if (e2cmd & E2P_CMD_EPC_TIMEOUT_) {
-		smsc_info(HW, "Error occured during eeprom operation");
+		smsc_info(HW, "Error occurred during eeprom operation");
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/via-rhine.c b/drivers/net/via-rhine.c
index d495e2a..a31a55a 100644
--- a/drivers/net/via-rhine.c
+++ b/drivers/net/via-rhine.c
@@ -1607,7 +1607,7 @@ static void rhine_restart_tx(struct net_device *dev) {
 		/* This should never happen */
 		if (debug > 1)
 			printk(KERN_WARNING "%s: rhine_restart_tx() "
-			       "Another error occured %8.8x.\n",
+			       "Another error occurred %8.8x.\n",
 			       dev->name, intr_status);
 	}
 
diff --git a/drivers/parisc/pdc_stable.c b/drivers/parisc/pdc_stable.c
index 0bc5d47..725e044 100644
--- a/drivers/parisc/pdc_stable.c
+++ b/drivers/parisc/pdc_stable.c
@@ -213,7 +213,7 @@ pdcspath_store(struct pdcspath_entry *entry)
 
 	/* addr, devpath and count must be word aligned */
 	if (pdc_stable_write(entry->addr, devpath, sizeof(*devpath)) != PDC_OK) {
-		printk(KERN_ERR "%s: an error occured when writing to PDC.\n"
+		printk(KERN_ERR "%s: an error occurred when writing to PDC.\n"
 				"It is likely that the Stable Storage data has been corrupted.\n"
 				"Please check it carefully upon next reboot.\n", __func__);
 		WARN_ON(1);
diff --git a/drivers/pnp/pnpbios/bioscalls.c b/drivers/pnp/pnpbios/bioscalls.c
index fc83783..710afeb 100644
--- a/drivers/pnp/pnpbios/bioscalls.c
+++ b/drivers/pnp/pnpbios/bioscalls.c
@@ -220,7 +220,7 @@ void pnpbios_print_status(const char *module, u16 status)
 		       module);
 		break;
 	case PNP_HARDWARE_ERROR:
-		printk(KERN_ERR "PnPBIOS: %s: a hardware failure has occured\n",
+		printk(KERN_ERR "PnPBIOS: %s: a hardware failure has occurred\n",
 		       module);
 		break;
 	default:
diff --git a/drivers/scsi/3w-9xxx.h b/drivers/scsi/3w-9xxx.h
index 2893eec..fdac0d0 100644
--- a/drivers/scsi/3w-9xxx.h
+++ b/drivers/scsi/3w-9xxx.h
@@ -60,7 +60,7 @@ static twa_message_type twa_aen_table[] = {
 	{0x0000, "AEN queue empty"},
 	{0x0001, "Controller reset occurred"},
 	{0x0002, "Degraded unit detected"},
-	{0x0003, "Controller error occured"},
+	{0x0003, "Controller error occurred"},
 	{0x0004, "Background rebuild failed"},
 	{0x0005, "Background rebuild done"},
 	{0x0006, "Incomplete unit detected"},
diff --git a/drivers/serial/sn_console.c b/drivers/serial/sn_console.c
index 9794e0c..a09dadb 100644
--- a/drivers/serial/sn_console.c
+++ b/drivers/serial/sn_console.c
@@ -481,7 +481,7 @@ sn_receive_chars(struct sn_cons_port *port, unsigned long flags)
 	while (port->sc_ops->sal_input_pending()) {
 		ch = port->sc_ops->sal_getc();
 		if (ch < 0) {
-			printk(KERN_ERR "sn_console: An error occured while "
+			printk(KERN_ERR "sn_console: An error occurred while "
 			       "obtaining data from the console (0x%0x)\n", ch);
 			break;
 		}
diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index 8b9fa0f..efd3031 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -1795,7 +1795,7 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 		       ai_context->irq_status_reg) &
 	    ME4000_IRQ_STATUS_BIT_AI_HF) {
 		ISR_PDEBUG
-		    ("me4000_ai_isr(): Fifo half full interrupt occured\n");
+		    ("me4000_ai_isr(): Fifo half full interrupt occurred\n");
 
 		/* Read status register to find out what happened */
 		tmp = me4000_inl(dev, ai_context->ctrl_reg);
@@ -1879,7 +1879,7 @@ static irqreturn_t me4000_ai_isr(int irq, void *dev_id)
 	if (me4000_inl(dev,
 		       ai_context->irq_status_reg) & ME4000_IRQ_STATUS_BIT_SC) {
 		ISR_PDEBUG
-		    ("me4000_ai_isr(): Sample counter interrupt occured\n");
+		    ("me4000_ai_isr(): Sample counter interrupt occurred\n");
 
 		s->async->events |= COMEDI_CB_BLOCK | COMEDI_CB_EOA;
 
diff --git a/drivers/staging/octeon/cvmx-helper.c b/drivers/staging/octeon/cvmx-helper.c
index 5915066..e9c5c83 100644
--- a/drivers/staging/octeon/cvmx-helper.c
+++ b/drivers/staging/octeon/cvmx-helper.c
@@ -691,7 +691,7 @@ int __cvmx_helper_errata_fix_ipd_ptr_alignment(void)
 
 		if (!retry_cnt)
 			cvmx_dprintf("WARNING: FIX_IPD_PTR_ALIGNMENT "
-				     "get_work() timeout occured.\n");
+				     "get_work() timeout occurred.\n");
 
 		/* Free packet */
 		if (work)
diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index 731150d..4014603 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -2136,7 +2136,7 @@ static irqreturn_t udc_data_out_isr(struct udc *dev, int ep_ix)
 	if (use_dma) {
 		/* BNA event ? */
 		if (tmp & AMD_BIT(UDC_EPSTS_BNA)) {
-			DBG(dev, "BNA ep%dout occured - DESPTR = %x \n",
+			DBG(dev, "BNA ep%dout occurred - DESPTR = %x \n",
 					ep->num, readl(&ep->regs->desptr));
 			/* clear BNA */
 			writel(tmp | AMD_BIT(UDC_EPSTS_BNA), &ep->regs->sts);
@@ -2150,7 +2150,7 @@ static irqreturn_t udc_data_out_isr(struct udc *dev, int ep_ix)
 	}
 	/* HE event ? */
 	if (tmp & AMD_BIT(UDC_EPSTS_HE)) {
-		dev_err(&dev->pdev->dev, "HE ep%dout occured\n", ep->num);
+		dev_err(&dev->pdev->dev, "HE ep%dout occurred\n", ep->num);
 
 		/* clear HE */
 		writel(tmp | AMD_BIT(UDC_EPSTS_HE), &ep->regs->sts);
@@ -2353,7 +2353,7 @@ static irqreturn_t udc_data_in_isr(struct udc *dev, int ep_ix)
 		/* BNA ? */
 		if (epsts & AMD_BIT(UDC_EPSTS_BNA)) {
 			dev_err(&dev->pdev->dev,
-				"BNA ep%din occured - DESPTR = %08lx \n",
+				"BNA ep%din occurred - DESPTR = %08lx \n",
 				ep->num,
 				(unsigned long) readl(&ep->regs->desptr));
 
@@ -2366,7 +2366,7 @@ static irqreturn_t udc_data_in_isr(struct udc *dev, int ep_ix)
 	/* HE event ? */
 	if (epsts & AMD_BIT(UDC_EPSTS_HE)) {
 		dev_err(&dev->pdev->dev,
-			"HE ep%dn occured - DESPTR = %08lx \n",
+			"HE ep%dn occurred - DESPTR = %08lx \n",
 			ep->num, (unsigned long) readl(&ep->regs->desptr));
 
 		/* clear HE */
diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index 4d366d6..885cb80 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -1467,7 +1467,7 @@ static int process_ep_req(struct fsl_udc *udc, int pipe,
 				status = -EILSEQ;
 				break;
 			} else
-				ERR("Unknown error has occured (0x%x)!\n",
+				ERR("Unknown error has occurred (0x%x)!\n",
 					errors);
 
 		} else if (le32_to_cpu(curr_td->size_ioc_sts)
diff --git a/drivers/usb/host/fhci-tds.c b/drivers/usb/host/fhci-tds.c
index d224ab4..88a3010 100644
--- a/drivers/usb/host/fhci-tds.c
+++ b/drivers/usb/host/fhci-tds.c
@@ -336,7 +336,7 @@ static void fhci_td_transaction_confirm(struct fhci_usb *usb)
 					pkt->status = USB_TD_RX_ER_NONOCT;
 				else
 					fhci_err(usb->fhci, "illegal error "
-						 "occured\n");
+						 "occurred\n");
 			} else if (td_status & TD_NAK)
 				pkt->status = USB_TD_TX_ER_NAK;
 			else if (td_status & TD_TO)
@@ -346,7 +346,7 @@ static void fhci_td_transaction_confirm(struct fhci_usb *usb)
 			else if (td_status & TD_STAL)
 				pkt->status = USB_TD_TX_ER_STALL;
 			else
-				fhci_err(usb->fhci, "illegal error occured\n");
+				fhci_err(usb->fhci, "illegal error occurred\n");
 		} else if ((extra_data & TD_TOK_IN) &&
 				pkt->len > td_length - CRC_SIZE) {
 			pkt->status = USB_TD_RX_DATA_UNDERUN;
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 567bc4b..51d0bb1 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -848,7 +848,7 @@ static int __init ecryptfs_init(void)
 	}
 	rc = ecryptfs_init_messaging();
 	if (rc) {
-		printk(KERN_ERR "Failure occured while attempting to "
+		printk(KERN_ERR "Failure occurred while attempting to "
 				"initialize the communications channel to "
 				"ecryptfsd\n");
 		goto out_destroy_kthread;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0e98c32..600d475 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -775,7 +775,7 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
 	ret = l3proto->get_l4proto(skb, skb_network_offset(skb),
 				   &dataoff, &protonum);
 	if (ret <= 0) {
-		pr_debug("not prepared to track yet or error occured\n");
+		pr_debug("not prepared to track yet or error occurred\n");
 		NF_CT_STAT_INC_ATOMIC(net, error);
 		NF_CT_STAT_INC_ATOMIC(net, invalid);
 		return -ret;
diff --git a/sound/pci/pcxhr/pcxhr_core.c b/sound/pci/pcxhr/pcxhr_core.c
index 2dc5dc2..304411c 100644
--- a/sound/pci/pcxhr/pcxhr_core.c
+++ b/sound/pci/pcxhr/pcxhr_core.c
@@ -1042,11 +1042,11 @@ void pcxhr_msg_tasklet(unsigned long arg)
 	int i, j;
 
 	if (mgr->src_it_dsp & PCXHR_IRQ_FREQ_CHANGE)
-		snd_printdd("TASKLET : PCXHR_IRQ_FREQ_CHANGE event occured\n");
+		snd_printdd("TASKLET : PCXHR_IRQ_FREQ_CHANGE event occurred\n");
 	if (mgr->src_it_dsp & PCXHR_IRQ_TIME_CODE)
-		snd_printdd("TASKLET : PCXHR_IRQ_TIME_CODE event occured\n");
+		snd_printdd("TASKLET : PCXHR_IRQ_TIME_CODE event occurred\n");
 	if (mgr->src_it_dsp & PCXHR_IRQ_NOTIFY)
-		snd_printdd("TASKLET : PCXHR_IRQ_NOTIFY event occured\n");
+		snd_printdd("TASKLET : PCXHR_IRQ_NOTIFY event occurred\n");
 	if (mgr->src_it_dsp & (PCXHR_IRQ_FREQ_CHANGE | PCXHR_IRQ_TIME_CODE)) {
 		/* clear events FREQ_CHANGE and TIME_CODE */
 		pcxhr_init_rmh(prmh, CMD_TEST_IT);
@@ -1055,7 +1055,7 @@ void pcxhr_msg_tasklet(unsigned long arg)
 			    err, prmh->stat[0]);
 	}
 	if (mgr->src_it_dsp & PCXHR_IRQ_ASYNC) {
-		snd_printdd("TASKLET : PCXHR_IRQ_ASYNC event occured\n");
+		snd_printdd("TASKLET : PCXHR_IRQ_ASYNC event occurred\n");
 
 		pcxhr_init_rmh(prmh, CMD_ASYNC);
 		prmh->cmd[0] |= 1;	/* add SEL_ASYNC_EVENTS */
-- 
1.6.6

