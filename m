Return-Path: <linux-kernel-owner+w=401wt.eu-S1764213AbXGPF3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764213AbXGPF3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 01:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbXGPF3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 01:29:05 -0400
Received: from havoc.gtf.org ([69.61.125.42]:60364 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088AbXGPF3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 01:29:03 -0400
Date: Mon, 16 Jul 2007 01:29:02 -0400
From: Jeff Garzik <jeff@garzik.org>
To: kkeil@suse.de, linux-kernel@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de
Cc: Andrew Morton <akpm@linux-foundation.org>, surya.prabhakar@wipro.com
Subject: [PATCH 6/7] HiSax hfc_pci: minor cleanups
Message-ID: <20070716052902.GF21782@havoc.gtf.org>
References: <20070715095716.GA20949@havoc.gtf.org> <20070716052647.GA21782@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716052647.GA21782@havoc.gtf.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit 163fc2ed7352b93cedb02af8a7a766c0b9bb475f
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sun Jul 15 21:48:07 2007 -0400

    [ISDN] HiSax hfc_pci: minor cleanups
    
    * trim trailing whitespace
    * remove CONFIG_PCI ifdefs, this driver is always PCI (Kconfig enforced)
    * remove return statements at the tail of a function
    * remove indentation levels by returning an error code immediately.
      Makes the code much more readable, and easier to update to PCI hotplug
      API.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/isdn/hisax/hfc_pci.c |  191 ++++++++++++++++++++-----------------------
 1 file changed, 93 insertions(+), 98 deletions(-)

163fc2ed7352b93cedb02af8a7a766c0b9bb475f
diff --git a/drivers/isdn/hisax/hfc_pci.c b/drivers/isdn/hisax/hfc_pci.c
index 8a48a3c..077080a 100644
--- a/drivers/isdn/hisax/hfc_pci.c
+++ b/drivers/isdn/hisax/hfc_pci.c
@@ -6,7 +6,7 @@
  *              based on existing driver for CCD hfc ISA cards
  * Copyright    by Werner Cornelius  <werner@isdn4linux.de>
  *              by Karsten Keil      <keil@isdn4linux.de>
- * 
+ *
  * This software may be used and distributed according to the terms
  * of the GNU General Public License, incorporated herein by reference.
  *
@@ -67,8 +67,6 @@ static const PCI_ENTRY id_list[] =
 };
 
 
-#ifdef CONFIG_PCI
-
 /******************************************/
 /* free hardware resources used by driver */
 /******************************************/
@@ -237,7 +235,7 @@ static void hfcpci_clear_fifo_rx(struct IsdnCardState *cs, int fifo)
 	if (fifo_state)
 	        cs->hw.hfcpci.fifo_en |= fifo_state;
 	Write_hfc(cs, HFCPCI_FIFO_EN, cs->hw.hfcpci.fifo_en);
-}   
+}
 
 /***************************************/
 /* clear the desired B-channel tx fifo */
@@ -263,7 +261,7 @@ static void hfcpci_clear_fifo_tx(struct IsdnCardState *cs, int fifo)
 	if (fifo_state)
 	        cs->hw.hfcpci.fifo_en |= fifo_state;
 	Write_hfc(cs, HFCPCI_FIFO_EN, cs->hw.hfcpci.fifo_en);
-}   
+}
 
 /*********************************************/
 /* read a complete B-frame out of the buffer */
@@ -511,7 +509,6 @@ main_rec_hfcpci(struct BCState *bcs)
 	test_and_clear_bit(FLG_LOCK_ATOMIC, &cs->HW_Flags);
 	if (count && receive)
 		goto Begin;
-	return;
 }
 
 /**************************/
@@ -582,7 +579,6 @@ hfcpci_fill_dfifo(struct IsdnCardState *cs)
 
 	dev_kfree_skb_any(cs->tx_skb);
 	cs->tx_skb = NULL;
-	return;
 }
 
 /**************************/
@@ -729,7 +725,6 @@ hfcpci_fill_fifo(struct BCState *bcs)
 	dev_kfree_skb_any(bcs->tx_skb);
 	bcs->tx_skb = NULL;
 	test_and_clear_bit(BC_FLG_BUSY, &bcs->Flag);
-	return;
 }
 
 /**********************************************/
@@ -924,7 +919,6 @@ receive_emsg(struct IsdnCardState *cs)
 	test_and_clear_bit(FLG_LOCK_ATOMIC, &cs->HW_Flags);
 	if (count && receive)
 		goto Begin;
-	return;
 }				/* receive_emsg */
 
 /*********************/
@@ -1350,13 +1344,13 @@ mode_hfcpci(struct BCState *bcs, int mode, int bc)
 				cs->hw.hfcpci.sctrl_r |= SCTRL_B1_ENA;
 			}
 			if (fifo2) {
-			        cs->hw.hfcpci.last_bfifo_cnt[1] = 0;  
+			        cs->hw.hfcpci.last_bfifo_cnt[1] = 0;
 				cs->hw.hfcpci.fifo_en |= HFCPCI_FIFOEN_B2;
 				cs->hw.hfcpci.int_m1 |= (HFCPCI_INTS_B2TRANS + HFCPCI_INTS_B2REC);
 				cs->hw.hfcpci.ctmt &= ~2;
 				cs->hw.hfcpci.conn &= ~0x18;
 			} else {
-			        cs->hw.hfcpci.last_bfifo_cnt[0] = 0;  
+			        cs->hw.hfcpci.last_bfifo_cnt[0] = 0;
 				cs->hw.hfcpci.fifo_en |= HFCPCI_FIFOEN_B1;
 				cs->hw.hfcpci.int_m1 |= (HFCPCI_INTS_B1TRANS + HFCPCI_INTS_B1REC);
 				cs->hw.hfcpci.ctmt &= ~1;
@@ -1642,8 +1636,6 @@ hfcpci_card_msg(struct IsdnCardState *cs, int mt, void *arg)
 /* this variable is used as card index when more than one cards are present */
 static struct pci_dev *dev_hfcpci __devinitdata = NULL;
 
-#endif				/* CONFIG_PCI */
-
 int __devinit
 setup_hfcpci(struct IsdnCard *card)
 {
@@ -1656,96 +1648,99 @@ setup_hfcpci(struct IsdnCard *card)
 #ifdef __BIG_ENDIAN
 #error "not running on big endian machines now"
 #endif
+
 	strcpy(tmp, hfcpci_revision);
 	printk(KERN_INFO "HiSax: HFC-PCI driver Rev. %s\n", HiSax_getrev(tmp));
-#ifdef CONFIG_PCI
+
 	cs->hw.hfcpci.int_s1 = 0;
 	cs->dc.hfcpci.ph_state = 0;
 	cs->hw.hfcpci.fifo = 255;
-	if (cs->typ == ISDN_CTYPE_HFC_PCI) {
-		i = 0;
-		while (id_list[i].vendor_id) {
-			tmp_hfcpci = pci_find_device(id_list[i].vendor_id,
-						     id_list[i].device_id,
-						     dev_hfcpci);
-			i++;
-			if (tmp_hfcpci) {
-				if (pci_enable_device(tmp_hfcpci))
-					continue;
-				pci_set_master(tmp_hfcpci);
-				if ((card->para[0]) && (card->para[0] != (tmp_hfcpci->resource[ 0].start & PCI_BASE_ADDRESS_IO_MASK)))
-					continue;
-				else
-					break;
-			}
-		}
-
+	if (cs->typ != ISDN_CTYPE_HFC_PCI)
+		return(0);
+
+	i = 0;
+	while (id_list[i].vendor_id) {
+		tmp_hfcpci = pci_find_device(id_list[i].vendor_id,
+					     id_list[i].device_id,
+					     dev_hfcpci);
+		i++;
 		if (tmp_hfcpci) {
-			i--;
-			dev_hfcpci = tmp_hfcpci;	/* old device */
-			cs->hw.hfcpci.dev = dev_hfcpci;
-			cs->irq = dev_hfcpci->irq;
-			if (!cs->irq) {
-				printk(KERN_WARNING "HFC-PCI: No IRQ for PCI card found\n");
-				return (0);
-			}
-			cs->hw.hfcpci.pci_io = (char *)(unsigned long)dev_hfcpci->resource[1].start;
-			printk(KERN_INFO "HiSax: HFC-PCI card manufacturer: %s card name: %s\n", id_list[i].vendor_name, id_list[i].card_name);
-		} else {
-			printk(KERN_WARNING "HFC-PCI: No PCI card found\n");
-			return (0);
-		}
-		if (!cs->hw.hfcpci.pci_io) {
-			printk(KERN_WARNING "HFC-PCI: No IO-Mem for PCI card found\n");
-			return (0);
-		}
-		/* Allocate memory for FIFOS */
-		/* Because the HFC-PCI needs a 32K physical alignment, we */
-		/* need to allocate the double mem and align the address */
-		if (!(cs->hw.hfcpci.share_start = kmalloc(65536, GFP_KERNEL))) {
-			printk(KERN_WARNING "HFC-PCI: Error allocating memory for FIFO!\n");
-			return 0;
+			if (pci_enable_device(tmp_hfcpci))
+				continue;
+			pci_set_master(tmp_hfcpci);
+			if ((card->para[0]) && (card->para[0] != (tmp_hfcpci->resource[ 0].start & PCI_BASE_ADDRESS_IO_MASK)))
+				continue;
+			else
+				break;
 		}
-		cs->hw.hfcpci.fifos = (void *)
-		    (((ulong) cs->hw.hfcpci.share_start) & ~0x7FFF) + 0x8000;
-		pci_write_config_dword(cs->hw.hfcpci.dev, 0x80, (u_int) virt_to_bus(cs->hw.hfcpci.fifos));
-		cs->hw.hfcpci.pci_io = ioremap((ulong) cs->hw.hfcpci.pci_io, 256);
-		printk(KERN_INFO
-		       "HFC-PCI: defined at mem %p fifo %p(%#x) IRQ %d HZ %d\n",
-		       cs->hw.hfcpci.pci_io,
-		       cs->hw.hfcpci.fifos,
-		       (u_int) virt_to_bus(cs->hw.hfcpci.fifos),
-		       cs->irq, HZ);
-		spin_lock_irqsave(&cs->lock, flags);
-		pci_write_config_word(cs->hw.hfcpci.dev, PCI_COMMAND, PCI_ENA_MEMIO);	/* enable memory mapped ports, disable busmaster */
-		cs->hw.hfcpci.int_m2 = 0;	/* disable alle interrupts */
-		cs->hw.hfcpci.int_m1 = 0;
-		Write_hfc(cs, HFCPCI_INT_M1, cs->hw.hfcpci.int_m1);
-		Write_hfc(cs, HFCPCI_INT_M2, cs->hw.hfcpci.int_m2);
-		/* At this point the needed PCI config is done */
-		/* fifos are still not enabled */
-		INIT_WORK(&cs->tqueue,  hfcpci_bh);
-		cs->setstack_d = setstack_hfcpci;
-		cs->BC_Send_Data = &hfcpci_send_data;
-		cs->readisac = NULL;
-		cs->writeisac = NULL;
-		cs->readisacfifo = NULL;
-		cs->writeisacfifo = NULL;
-		cs->BC_Read_Reg = NULL;
-		cs->BC_Write_Reg = NULL;
-		cs->irq_func = &hfcpci_interrupt;
-		cs->irq_flags |= IRQF_SHARED;
-		cs->hw.hfcpci.timer.function = (void *) hfcpci_Timer;
-		cs->hw.hfcpci.timer.data = (long) cs;
-		init_timer(&cs->hw.hfcpci.timer);
-		cs->cardmsg = &hfcpci_card_msg;
-		cs->auxcmd = &hfcpci_auxcmd;
-		spin_unlock_irqrestore(&cs->lock, flags);
-		return (1);
-	} else
-		return (0);	/* no valid card type */
-#else
-	printk(KERN_WARNING "HFC-PCI: NO_PCI_BIOS\n");
-	return (0);
-#endif				/* CONFIG_PCI */
+	}
+
+	if (!tmp_hfcpci) {
+		printk(KERN_WARNING "HFC-PCI: No PCI card found\n");
+		return (0);
+	}
+
+	i--;
+	dev_hfcpci = tmp_hfcpci;	/* old device */
+	cs->hw.hfcpci.dev = dev_hfcpci;
+	cs->irq = dev_hfcpci->irq;
+	if (!cs->irq) {
+		printk(KERN_WARNING "HFC-PCI: No IRQ for PCI card found\n");
+		return (0);
+	}
+	cs->hw.hfcpci.pci_io = (char *)(unsigned long)dev_hfcpci->resource[1].start;
+	printk(KERN_INFO "HiSax: HFC-PCI card manufacturer: %s card name: %s\n", id_list[i].vendor_name, id_list[i].card_name);
+
+	if (!cs->hw.hfcpci.pci_io) {
+		printk(KERN_WARNING "HFC-PCI: No IO-Mem for PCI card found\n");
+		return (0);
+	}
+	/* Allocate memory for FIFOS */
+	/* Because the HFC-PCI needs a 32K physical alignment, we */
+	/* need to allocate the double mem and align the address */
+	if (!(cs->hw.hfcpci.share_start = kmalloc(65536, GFP_KERNEL))) {
+		printk(KERN_WARNING "HFC-PCI: Error allocating memory for FIFO!\n");
+		return 0;
+	}
+	cs->hw.hfcpci.fifos = (void *)
+	    (((ulong) cs->hw.hfcpci.share_start) & ~0x7FFF) + 0x8000;
+	pci_write_config_dword(cs->hw.hfcpci.dev, 0x80, (u_int) virt_to_bus(cs->hw.hfcpci.fifos));
+	cs->hw.hfcpci.pci_io = ioremap((ulong) cs->hw.hfcpci.pci_io, 256);
+	printk(KERN_INFO
+	       "HFC-PCI: defined at mem %p fifo %p(%#x) IRQ %d HZ %d\n",
+	       cs->hw.hfcpci.pci_io,
+	       cs->hw.hfcpci.fifos,
+	       (u_int) virt_to_bus(cs->hw.hfcpci.fifos),
+	       cs->irq, HZ);
+
+	spin_lock_irqsave(&cs->lock, flags);
+
+	pci_write_config_word(cs->hw.hfcpci.dev, PCI_COMMAND, PCI_ENA_MEMIO);	/* enable memory mapped ports, disable busmaster */
+	cs->hw.hfcpci.int_m2 = 0;	/* disable alle interrupts */
+	cs->hw.hfcpci.int_m1 = 0;
+	Write_hfc(cs, HFCPCI_INT_M1, cs->hw.hfcpci.int_m1);
+	Write_hfc(cs, HFCPCI_INT_M2, cs->hw.hfcpci.int_m2);
+	/* At this point the needed PCI config is done */
+	/* fifos are still not enabled */
+
+	INIT_WORK(&cs->tqueue,  hfcpci_bh);
+	cs->setstack_d = setstack_hfcpci;
+	cs->BC_Send_Data = &hfcpci_send_data;
+	cs->readisac = NULL;
+	cs->writeisac = NULL;
+	cs->readisacfifo = NULL;
+	cs->writeisacfifo = NULL;
+	cs->BC_Read_Reg = NULL;
+	cs->BC_Write_Reg = NULL;
+	cs->irq_func = &hfcpci_interrupt;
+	cs->irq_flags |= IRQF_SHARED;
+	cs->hw.hfcpci.timer.function = (void *) hfcpci_Timer;
+	cs->hw.hfcpci.timer.data = (long) cs;
+	init_timer(&cs->hw.hfcpci.timer);
+	cs->cardmsg = &hfcpci_card_msg;
+	cs->auxcmd = &hfcpci_auxcmd;
+
+	spin_unlock_irqrestore(&cs->lock, flags);
+
+	return (1);
 }
