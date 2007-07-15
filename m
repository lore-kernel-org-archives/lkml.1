Return-Path: <linux-kernel-owner+w=401wt.eu-S1757878AbXGOIyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbXGOIyY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 04:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbXGOIyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 04:54:11 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:25446 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbXGOIyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 04:54:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer;
        b=Z1o+XIL4NEayzunSWTtNeRiDSH8IdqvskspIFUXJnHQAmTx5XY230n/xJVDDZz8WA+0sUc+xKCUbBLaPSb5dDY8VAYs9LVwWbUhCihBVUy91PqwbIOoaNZt5YpJOL0zL/3WGU5rKFqxJ2PhdsZCAgh5UOdyFzPvrogRUEBl+nb4=
From: Denis Cheng <crquan@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Denis Cheng <crquan@gmail.com>
Subject: [PATCH 1/2] run scripts/Lindent on it to match Documentation/CodingStyle
Date: Sun, 15 Jul 2007 16:52:50 +0800
Message-Id: <1184489571313-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.2.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 drivers/net/wireless/wavelan.c |  806 ++++++++++++++++++----------------------
 1 files changed, 369 insertions(+), 437 deletions(-)

diff --git a/drivers/net/wireless/wavelan.c b/drivers/net/wireless/wavelan.c
index 1cf090d..796011b 100644
--- a/drivers/net/wireless/wavelan.c
+++ b/drivers/net/wireless/wavelan.c
@@ -66,7 +66,7 @@ static char *wv_struct_check(void)
 
 #undef	SC
 
-	return ((char *) NULL);
+	return ((char *)NULL);
 }				/* wv_struct_check */
 #endif				/* STRUCT_CHECK */
 
@@ -153,11 +153,11 @@ static inline void wv_16_on(unsigned long ioaddr, u16 hacr)
  * Disable interrupts on the WaveLAN hardware.
  * (called by wv_82586_stop())
  */
-static inline void wv_ints_off(struct net_device * dev)
+static inline void wv_ints_off(struct net_device *dev)
 {
 	net_local *lp = (net_local *) dev->priv;
 	unsigned long ioaddr = dev->base_addr;
-	
+
 	lp->hacr &= ~HACR_INTRON;
 	hacr_write(ioaddr, lp->hacr);
 }				/* wv_ints_off */
@@ -167,7 +167,7 @@ static inline void wv_ints_off(struct net_device * dev)
  * Enable interrupts on the WaveLAN hardware.
  * (called by wv_hw_reset())
  */
-static inline void wv_ints_on(struct net_device * dev)
+static inline void wv_ints_on(struct net_device *dev)
 {
 	net_local *lp = (net_local *) dev->priv;
 	unsigned long ioaddr = dev->base_addr;
@@ -224,8 +224,8 @@ static void psa_write(unsigned long ioaddr, u16 hacr, int o,	/* Offset in PSA */
 
 		/* Wait for the memory to finish its write cycle */
 		count = 0;
-		while ((count++ < 100) &&
-		       (hasr_read(ioaddr) & HASR_PSA_BUSY)) mdelay(1);
+		while ((count++ < 100) && (hasr_read(ioaddr) & HASR_PSA_BUSY))
+			mdelay(1);
 	}
 
 	wv_16_on(ioaddr, hacr);
@@ -243,7 +243,7 @@ static void psa_write(unsigned long ioaddr, u16 hacr, int o,	/* Offset in PSA */
  * depend on it.
  */
 static u16 psa_crc(u8 * psa,	/* The PSA */
-			      int size)
+		   int size)
 {				/* Number of short for CRC */
 	int byte_cnt;		/* Loop on the PSA */
 	u16 crc_bytes = 0;	/* Data in the PSA */
@@ -268,17 +268,18 @@ static u16 psa_crc(u8 * psa,	/* The PSA */
 /*
  * update the checksum field in the Wavelan's PSA
  */
-static void update_psa_checksum(struct net_device * dev, unsigned long ioaddr, u16 hacr)
+static void update_psa_checksum(struct net_device *dev, unsigned long ioaddr,
+				u16 hacr)
 {
 #ifdef SET_PSA_CRC
 	psa_t psa;
 	u16 crc;
 
 	/* read the parameter storage area */
-	psa_read(ioaddr, hacr, 0, (unsigned char *) &psa, sizeof(psa));
+	psa_read(ioaddr, hacr, 0, (unsigned char *)&psa, sizeof(psa));
 
 	/* update the checksum */
-	crc = psa_crc((unsigned char *) &psa,
+	crc = psa_crc((unsigned char *)&psa,
 		      sizeof(psa) - sizeof(psa.psa_crc[0]) -
 		      sizeof(psa.psa_crc[1])
 		      - sizeof(psa.psa_crc_status));
@@ -287,15 +288,15 @@ static void update_psa_checksum(struct net_device * dev, unsigned long ioaddr, u
 	psa.psa_crc[1] = (crc & 0xFF00) >> 8;
 
 	/* Write it ! */
-	psa_write(ioaddr, hacr, (char *) &psa.psa_crc - (char *) &psa,
-		  (unsigned char *) &psa.psa_crc, 2);
+	psa_write(ioaddr, hacr, (char *)&psa.psa_crc - (char *)&psa,
+		  (unsigned char *)&psa.psa_crc, 2);
 
 #ifdef DEBUG_IOCTL_INFO
 	printk(KERN_DEBUG "%s: update_psa_checksum(): crc = 0x%02x%02x\n",
 	       dev->name, psa.psa_crc[0], psa.psa_crc[1]);
 
 	/* Check again (luxury !) */
-	crc = psa_crc((unsigned char *) &psa,
+	crc = psa_crc((unsigned char *)&psa,
 		      sizeof(psa) - sizeof(psa.psa_crc_status));
 
 	if (crc != 0)
@@ -398,7 +399,8 @@ static inline void fee_wait(unsigned long ioaddr,	/* I/O port of the card */
 
 	while ((count++ < number) &&
 	       (mmc_in(ioaddr, mmroff(0, mmr_fee_status)) &
-		MMR_FEE_STATUS_BUSY)) udelay(delay);
+		MMR_FEE_STATUS_BUSY))
+		udelay(delay);
 }
 
 /*------------------------------------------------------------------*/
@@ -418,8 +420,7 @@ static void fee_read(unsigned long ioaddr,	/* I/O port of the card */
 	/* Loop on all buffer */
 	while (n-- > 0) {
 		/* Write the read command */
-		mmc_out(ioaddr, mmwoff(0, mmw_fee_ctrl),
-			MMW_FEE_CTRL_READ);
+		mmc_out(ioaddr, mmwoff(0, mmw_fee_ctrl), MMW_FEE_CTRL_READ);
 
 		/* Wait until EEPROM is ready (should be quick). */
 		fee_wait(ioaddr, 10, 100);
@@ -430,7 +431,6 @@ static void fee_read(unsigned long ioaddr,	/* I/O port of the card */
 	}
 }
 
-
 /*------------------------------------------------------------------*/
 /*
  * Write bytes from the Frequency EEPROM (frequency select cards).
@@ -491,8 +491,7 @@ static void fee_write(unsigned long ioaddr,	/* I/O port of the card */
 		mmc_out(ioaddr, mmwoff(0, mmw_fee_data_l), *b & 0xFF);
 
 		/* Write the write command. */
-		mmc_out(ioaddr, mmwoff(0, mmw_fee_ctrl),
-			MMW_FEE_CTRL_WRITE);
+		mmc_out(ioaddr, mmwoff(0, mmw_fee_ctrl), MMW_FEE_CTRL_WRITE);
 
 		/* WaveLAN documentation says to wait at least 10 ms for EEBUSY = 0 */
 		mdelay(10);
@@ -528,7 +527,7 @@ static /*inline */ void obram_read(unsigned long ioaddr,
 				   u16 o, u8 * b, int n)
 {
 	outw(o, PIOR1(ioaddr));
-	insw(PIOP1(ioaddr), (unsigned short *) b, (n + 1) >> 1);
+	insw(PIOP1(ioaddr), (unsigned short *)b, (n + 1) >> 1);
 }
 
 /*------------------------------------------------------------------*/
@@ -538,14 +537,14 @@ static /*inline */ void obram_read(unsigned long ioaddr,
 static inline void obram_write(unsigned long ioaddr, u16 o, u8 * b, int n)
 {
 	outw(o, PIOR1(ioaddr));
-	outsw(PIOP1(ioaddr), (unsigned short *) b, (n + 1) >> 1);
+	outsw(PIOP1(ioaddr), (unsigned short *)b, (n + 1) >> 1);
 }
 
 /*------------------------------------------------------------------*/
 /*
  * Acknowledge the reading of the status issued by the i82586.
  */
-static void wv_ack(struct net_device * dev)
+static void wv_ack(struct net_device *dev)
 {
 	net_local *lp = (net_local *) dev->priv;
 	unsigned long ioaddr = dev->base_addr;
@@ -553,20 +552,20 @@ static void wv_ack(struct net_device * dev)
 	int i;
 
 	obram_read(ioaddr, scboff(OFFSET_SCB, scb_status),
-		   (unsigned char *) &scb_cs, sizeof(scb_cs));
+		   (unsigned char *)&scb_cs, sizeof(scb_cs));
 	scb_cs &= SCB_ST_INT;
 
 	if (scb_cs == 0)
 		return;
 
 	obram_write(ioaddr, scboff(OFFSET_SCB, scb_command),
-		    (unsigned char *) &scb_cs, sizeof(scb_cs));
+		    (unsigned char *)&scb_cs, sizeof(scb_cs));
 
 	set_chan_attn(ioaddr, lp->hacr);
 
 	for (i = 1000; i > 0; i--) {
 		obram_read(ioaddr, scboff(OFFSET_SCB, scb_command),
-			   (unsigned char *) &scb_cs, sizeof(scb_cs));
+			   (unsigned char *)&scb_cs, sizeof(scb_cs));
 		if (scb_cs == 0)
 			break;
 
@@ -587,7 +586,7 @@ static void wv_ack(struct net_device * dev)
  * Set channel attention bit and busy wait until command has
  * completed, then acknowledge completion of the command.
  */
-static int wv_synchronous_cmd(struct net_device * dev, const char *str)
+static int wv_synchronous_cmd(struct net_device *dev, const char *str)
 {
 	net_local *lp = (net_local *) dev->priv;
 	unsigned long ioaddr = dev->base_addr;
@@ -597,13 +596,12 @@ static int wv_synchronous_cmd(struct net_device * dev, const char *str)
 
 	scb_cmd = SCB_CMD_CUC & SCB_CMD_CUC_GO;
 	obram_write(ioaddr, scboff(OFFSET_SCB, scb_command),
-		    (unsigned char *) &scb_cmd, sizeof(scb_cmd));
+		    (unsigned char *)&scb_cmd, sizeof(scb_cmd));
 
 	set_chan_attn(ioaddr, lp->hacr);
 
 	for (i = 1000; i > 0; i--) {
-		obram_read(ioaddr, OFFSET_CU, (unsigned char *) &cb,
-			   sizeof(cb));
+		obram_read(ioaddr, OFFSET_CU, (unsigned char *)&cb, sizeof(cb));
 		if (cb.ac_status & AC_SFLD_C)
 			break;
 
@@ -634,7 +632,7 @@ static int wv_synchronous_cmd(struct net_device * dev, const char *str)
  * Check if done, and if OK.
  */
 static int
-wv_config_complete(struct net_device * dev, unsigned long ioaddr, net_local * lp)
+wv_config_complete(struct net_device *dev, unsigned long ioaddr, net_local * lp)
 {
 	unsigned short mcs_addr;
 	unsigned short status;
@@ -649,7 +647,7 @@ wv_config_complete(struct net_device * dev, unsigned long ioaddr, net_local * lp
 
 	/* Read the status of the last command (set mc list). */
 	obram_read(ioaddr, acoff(mcs_addr, ac_status),
-		   (unsigned char *) &status, sizeof(status));
+		   (unsigned char *)&status, sizeof(status));
 
 	/* If not completed -> exit */
 	if ((status & AC_SFLD_C) == 0)
@@ -668,7 +666,7 @@ wv_config_complete(struct net_device * dev, unsigned long ioaddr, net_local * lp
 		/* check ia-config command */
 		ias_addr = mcs_addr - sizeof(ac_ias_t);
 		obram_read(ioaddr, acoff(ias_addr, ac_status),
-			   (unsigned char *) &status, sizeof(status));
+			   (unsigned char *)&status, sizeof(status));
 		if ((status & AC_SFLD_OK) != AC_SFLD_OK)
 			printk(KERN_INFO
 			       "%s: wv_config_complete(): set_MAC_address failed; status = 0x%x\n",
@@ -677,19 +675,18 @@ wv_config_complete(struct net_device * dev, unsigned long ioaddr, net_local * lp
 		/* Check config command. */
 		cfg_addr = ias_addr - sizeof(ac_cfg_t);
 		obram_read(ioaddr, acoff(cfg_addr, ac_status),
-			   (unsigned char *) &status, sizeof(status));
+			   (unsigned char *)&status, sizeof(status));
 		if ((status & AC_SFLD_OK) != AC_SFLD_OK)
 			printk(KERN_INFO
 			       "%s: wv_config_complete(): configure failed; status = 0x%x\n",
 			       dev->name, status);
-#endif	/* DEBUG_CONFIG_ERROR */
+#endif				/* DEBUG_CONFIG_ERROR */
 
 		ret = 1;	/* Ready to be scrapped */
 	}
 
 #ifdef DEBUG_INTERRUPT_TRACE
-	printk(KERN_DEBUG "%s: <-wv_config_complete() - %d\n", dev->name,
-	       ret);
+	printk(KERN_DEBUG "%s: <-wv_config_complete() - %d\n", dev->name, ret);
 #endif
 	return ret;
 }
@@ -701,7 +698,8 @@ wv_config_complete(struct net_device * dev, unsigned long ioaddr, net_local * lp
  * (called in wavelan_interrupt()).
  * Note : the spinlock is already grabbed for us.
  */
-static int wv_complete(struct net_device * dev, unsigned long ioaddr, net_local * lp)
+static int wv_complete(struct net_device *dev, unsigned long ioaddr,
+		       net_local * lp)
 {
 	int nreaped = 0;
 
@@ -715,8 +713,7 @@ static int wv_complete(struct net_device * dev, unsigned long ioaddr, net_local
 
 		/* Read the first transmit buffer */
 		obram_read(ioaddr, acoff(lp->tx_first_in_use, ac_status),
-			   (unsigned char *) &tx_status,
-			   sizeof(tx_status));
+			   (unsigned char *)&tx_status, sizeof(tx_status));
 
 		/* If not completed -> exit */
 		if ((tx_status & AC_SFLD_C) == 0)
@@ -743,9 +740,8 @@ if (lp->tx_n_in_use > 0)
 			/* Next one in the chain */
 			lp->tx_first_in_use += TXBLOCKZ;
 			if (lp->tx_first_in_use >=
-			    OFFSET_CU +
-			    NTXBLOCKS * TXBLOCKZ) lp->tx_first_in_use -=
-				    NTXBLOCKS * TXBLOCKZ;
+			    OFFSET_CU + NTXBLOCKS * TXBLOCKZ)
+				lp->tx_first_in_use -= NTXBLOCKS * TXBLOCKZ;
 		}
 
 		/* Hack for reconfiguration */
@@ -843,7 +839,7 @@ if (lp->tx_n_in_use > 0)
  * wavelan_interrupt is not an option), so you may experience
  * delays sometimes.
  */
-static void wv_82586_reconfig(struct net_device * dev)
+static void wv_82586_reconfig(struct net_device *dev)
 {
 	net_local *lp = (net_local *) dev->priv;
 	unsigned long flags;
@@ -852,17 +848,16 @@ static void wv_82586_reconfig(struct net_device * dev)
 	lp->reconfig_82586 = 1;
 
 	/* Check if we can do it now ! */
-	if((netif_running(dev)) && !(netif_queue_stopped(dev))) {
+	if ((netif_running(dev)) && !(netif_queue_stopped(dev))) {
 		spin_lock_irqsave(&lp->spinlock, flags);
 		/* May fail */
 		wv_82586_config(dev);
 		spin_unlock_irqrestore(&lp->spinlock, flags);
-	}
-	else {
+	} else {
 #ifdef DEBUG_CONFIG_INFO
 		printk(KERN_DEBUG
 		       "%s: wv_82586_reconfig(): delayed (state = %lX)\n",
-			       dev->name, dev->state);
+		       dev->name, dev->state);
 #endif
 	}
 }
@@ -907,8 +902,7 @@ static void wv_psa_show(psa_t * p)
 	       p->psa_local_mac_addr[0], p->psa_local_mac_addr[1],
 	       p->psa_local_mac_addr[2], p->psa_local_mac_addr[3],
 	       p->psa_local_mac_addr[4], p->psa_local_mac_addr[5]);
-	printk(KERN_DEBUG "psa_univ_local_sel: %d, ",
-	       p->psa_univ_local_sel);
+	printk(KERN_DEBUG "psa_univ_local_sel: %d, ", p->psa_univ_local_sel);
 	printk("psa_comp_number: %d, ", p->psa_comp_number);
 	printk("psa_thr_pre_set: 0x%02x\n", p->psa_thr_pre_set);
 	printk(KERN_DEBUG "psa_feature_select/decay_prm: 0x%02x, ",
@@ -952,7 +946,7 @@ static void wv_psa_show(psa_t * p)
  * Print the formatted status of the Modem Management Controller.
  * This function needs to be completed.
  */
-static void wv_mmc_show(struct net_device * dev)
+static void wv_mmc_show(struct net_device *dev)
 {
 	unsigned long ioaddr = dev->base_addr;
 	net_local *lp = (net_local *) dev->priv;
@@ -961,8 +955,7 @@ static void wv_mmc_show(struct net_device * dev)
 	/* Basic check */
 	if (hasr_read(ioaddr) & HASR_NO_CLK) {
 		printk(KERN_WARNING
-		       "%s: wv_mmc_show: modem not connected\n",
-		       dev->name);
+		       "%s: wv_mmc_show: modem not connected\n", dev->name);
 		return;
 	}
 
@@ -1015,9 +1008,7 @@ static void wv_mmc_show(struct net_device * dev)
 	       (m.mmr_wrong_nwid_h << 8) | m.mmr_wrong_nwid_l);
 	printk(KERN_DEBUG "thr_pre_set: 0x%x [current signal %s]\n",
 	       m.mmr_thr_pre_set & MMR_THR_PRE_SET,
-	       (m.
-		mmr_thr_pre_set & MMR_THR_PRE_SET_CUR) ? "above" :
-	       "below");
+	       (m.mmr_thr_pre_set & MMR_THR_PRE_SET_CUR) ? "above" : "below");
 	printk(KERN_DEBUG "signal_lvl: %d [%s], ",
 	       m.mmr_signal_lvl & MMR_SIGNAL_LVL,
 	       (m.
@@ -1030,8 +1021,7 @@ static void wv_mmc_show(struct net_device * dev)
 	       "no new update");
 	printk("sgnl_qual: 0x%x [%s]\n", m.mmr_sgnl_qual & MMR_SGNL_QUAL,
 	       (m.
-		mmr_sgnl_qual & MMR_SGNL_QUAL_ANT) ? "Antenna 1" :
-	       "Antenna 0");
+		mmr_sgnl_qual & MMR_SGNL_QUAL_ANT) ? "Antenna 1" : "Antenna 0");
 #ifdef DEBUG_SHOW_UNUSED
 	printk(KERN_DEBUG "netw_id_l: %x\n", m.mmr_netw_id_l);
 #endif				/* DEBUG_SHOW_UNUSED */
@@ -1047,8 +1037,7 @@ static void wv_scb_show(unsigned long ioaddr)
 {
 	scb_t scb;
 
-	obram_read(ioaddr, OFFSET_SCB, (unsigned char *) &scb,
-		   sizeof(scb));
+	obram_read(ioaddr, OFFSET_SCB, (unsigned char *)&scb, sizeof(scb));
 
 	printk(KERN_DEBUG "##### WaveLAN system control block: #####\n");
 
@@ -1063,8 +1052,7 @@ static void wv_scb_show(unsigned long ioaddr)
 	       (scb.
 		scb_status & SCB_ST_CNA) ? "command unit not active," : "",
 	       (scb.
-		scb_status & SCB_ST_RNR) ? "receiving unit not ready," :
-	       "");
+		scb_status & SCB_ST_RNR) ? "receiving unit not ready," : "");
 	printk("cus 0x%x[%s%s%s] ", (scb.scb_status & SCB_ST_CUS) >> 8,
 	       ((scb.scb_status & SCB_ST_CUS) ==
 		SCB_ST_CUS_IDLE) ? "idle" : "",
@@ -1093,8 +1081,7 @@ static void wv_scb_show(unsigned long ioaddr)
 		scb_command & SCB_CMD_ACK_FR) ? "ack frame received," : "",
 	       (scb.
 		scb_command & SCB_CMD_ACK_CNA) ? "ack CU not active," : "",
-	       (scb.
-		scb_command & SCB_CMD_ACK_RNR) ? "ack RU not ready," : "");
+	       (scb.scb_command & SCB_CMD_ACK_RNR) ? "ack RU not ready," : "");
 	printk("cuc 0x%x[%s%s%s%s%s] ",
 	       (scb.scb_command & SCB_CMD_CUC) >> 8,
 	       ((scb.scb_command & SCB_CMD_CUC) ==
@@ -1133,12 +1120,11 @@ static void wv_scb_show(unsigned long ioaddr)
 /*
  * Print the formatted status of the i82586's receive unit.
  */
-static void wv_ru_show(struct net_device * dev)
+static void wv_ru_show(struct net_device *dev)
 {
 	/* net_local *lp = (net_local *) dev->priv; */
 
-	printk(KERN_DEBUG
-	       "##### WaveLAN i82586 receiver unit status: #####\n");
+	printk(KERN_DEBUG "##### WaveLAN i82586 receiver unit status: #####\n");
 	printk(KERN_DEBUG "ru:");
 	/*
 	 * Not implemented yet
@@ -1150,7 +1136,7 @@ static void wv_ru_show(struct net_device * dev)
 /*
  * Display info about one control block of the i82586 memory.
  */
-static void wv_cu_show_one(struct net_device * dev, net_local * lp, int i, u16 p)
+static void wv_cu_show_one(struct net_device *dev, net_local * lp, int i, u16 p)
 {
 	unsigned long ioaddr;
 	ac_tx_t actx;
@@ -1159,7 +1145,7 @@ static void wv_cu_show_one(struct net_device * dev, net_local * lp, int i, u16 p
 
 	printk("%d: 0x%x:", i, p);
 
-	obram_read(ioaddr, p, (unsigned char *) &actx, sizeof(actx));
+	obram_read(ioaddr, p, (unsigned char *)&actx, sizeof(actx));
 	printk(" status=0x%x,", actx.tx_h.ac_status);
 	printk(" command=0x%x,", actx.tx_h.ac_command);
 
@@ -1179,14 +1165,13 @@ static void wv_cu_show_one(struct net_device * dev, net_local * lp, int i, u16 p
 /*
  * Print status of the command unit of the i82586.
  */
-static void wv_cu_show(struct net_device * dev)
+static void wv_cu_show(struct net_device *dev)
 {
 	net_local *lp = (net_local *) dev->priv;
 	unsigned int i;
 	u16 p;
 
-	printk(KERN_DEBUG
-	       "##### WaveLAN i82586 command unit status: #####\n");
+	printk(KERN_DEBUG "##### WaveLAN i82586 command unit status: #####\n");
 
 	printk(KERN_DEBUG);
 	for (i = 0, p = lp->tx_first_in_use; i < NTXBLOCKS; i++) {
@@ -1205,7 +1190,7 @@ static void wv_cu_show(struct net_device * dev)
 /*
  * Print the formatted status of the WaveLAN PCMCIA device driver.
  */
-static void wv_dev_show(struct net_device * dev)
+static void wv_dev_show(struct net_device *dev)
 {
 	printk(KERN_DEBUG "dev:");
 	printk(" state=%lX,", dev->state);
@@ -1219,7 +1204,7 @@ static void wv_dev_show(struct net_device * dev)
  * Print the formatted status of the WaveLAN PCMCIA device driver's
  * private information.
  */
-static void wv_local_show(struct net_device * dev)
+static void wv_local_show(struct net_device *dev)
 {
 	net_local *lp;
 
@@ -1254,8 +1239,7 @@ static inline void wv_packet_info(u8 * p,	/* Packet to dump */
 	       msg1, msg2, p[0], p[1], p[2], p[3], p[4], p[5], length);
 	printk(KERN_DEBUG
 	       "%s: %s(): src %02X:%02X:%02X:%02X:%02X:%02X, type 0x%02X%02X\n",
-	       msg1, msg2, p[6], p[7], p[8], p[9], p[10], p[11], p[12],
-	       p[13]);
+	       msg1, msg2, p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13]);
 
 #ifdef DEBUG_PACKET_DUMP
 
@@ -1281,7 +1265,7 @@ static inline void wv_packet_info(u8 * p,	/* Packet to dump */
  * This is the information which is displayed by the driver at startup.
  * There are lots of flags for configuring it to your liking.
  */
-static void wv_init_info(struct net_device * dev)
+static void wv_init_info(struct net_device *dev)
 {
 	short ioaddr = dev->base_addr;
 	net_local *lp = (net_local *) dev->priv;
@@ -1289,7 +1273,7 @@ static void wv_init_info(struct net_device * dev)
 	int i;
 
 	/* Read the parameter storage area */
-	psa_read(ioaddr, lp->hacr, 0, (unsigned char *) &psa, sizeof(psa));
+	psa_read(ioaddr, lp->hacr, 0, (unsigned char *)&psa, sizeof(psa));
 
 #ifdef DEBUG_PSA_SHOW
 	wv_psa_show(&psa);
@@ -1310,8 +1294,7 @@ static void wv_init_info(struct net_device * dev)
 
 	/* Print current network ID. */
 	if (psa.psa_nwid_select)
-		printk(", nwid 0x%02X-%02X", psa.psa_nwid[0],
-		       psa.psa_nwid[1]);
+		printk(", nwid 0x%02X-%02X", psa.psa_nwid[0], psa.psa_nwid[1]);
 	else
 		printk(", nwid off");
 
@@ -1391,7 +1374,7 @@ static void wv_init_info(struct net_device * dev)
  * card open or closed.
  * Used when the user read /proc/net/dev
  */
-static en_stats *wavelan_get_stats(struct net_device * dev)
+static en_stats *wavelan_get_stats(struct net_device *dev)
 {
 #ifdef DEBUG_IOCTL_TRACE
 	printk(KERN_DEBUG "%s: <>wavelan_get_stats()\n", dev->name);
@@ -1408,13 +1391,12 @@ static en_stats *wavelan_get_stats(struct net_device * dev)
  * num_addrs > 0	Multicast mode, receive normal and MC packets,
  *			and do best-effort filtering.
  */
-static void wavelan_set_multicast_list(struct net_device * dev)
+static void wavelan_set_multicast_list(struct net_device *dev)
 {
 	net_local *lp = (net_local *) dev->priv;
 
 #ifdef DEBUG_IOCTL_TRACE
-	printk(KERN_DEBUG "%s: ->wavelan_set_multicast_list()\n",
-	       dev->name);
+	printk(KERN_DEBUG "%s: ->wavelan_set_multicast_list()\n", dev->name);
 #endif
 
 #ifdef DEBUG_IOCTL_INFO
@@ -1443,7 +1425,7 @@ static void wavelan_set_multicast_list(struct net_device * dev)
 		}
 	} else
 		/* Are there multicast addresses to send? */
-	if (dev->mc_list != (struct dev_mc_list *) NULL) {
+	if (dev->mc_list != (struct dev_mc_list *)NULL) {
 		/*
 		 * Disable promiscuous mode, but receive all packets
 		 * in multicast list
@@ -1470,8 +1452,7 @@ static void wavelan_set_multicast_list(struct net_device * dev)
 		}
 	}
 #ifdef DEBUG_IOCTL_TRACE
-	printk(KERN_DEBUG "%s: <-wavelan_set_multicast_list()\n",
-	       dev->name);
+	printk(KERN_DEBUG "%s: <-wavelan_set_multicast_list()\n", dev->name);
 #endif
 }
 
@@ -1481,7 +1462,7 @@ static void wavelan_set_multicast_list(struct net_device * dev)
  * (Note : it was a nice way to test the reconfigure stuff...)
  */
 #ifdef SET_MAC_ADDRESS
-static int wavelan_set_mac_address(struct net_device * dev, void *addr)
+static int wavelan_set_mac_address(struct net_device *dev, void *addr)
 {
 	struct sockaddr *mac = addr;
 
@@ -1495,7 +1476,6 @@ static int wavelan_set_mac_address(struct net_device * dev, void *addr)
 }
 #endif				/* SET_MAC_ADDRESS */
 
-
 /*------------------------------------------------------------------*/
 /*
  * Frequency setting (for hardware capable of it)
@@ -1503,7 +1483,7 @@ static int wavelan_set_mac_address(struct net_device * dev, void *addr)
  * (called in wavelan_ioctl)
  */
 static int wv_set_frequency(unsigned long ioaddr,	/* I/O port of the card */
-				   iw_freq * frequency)
+			    iw_freq * frequency)
 {
 	const int BAND_NUM = 10;	/* Number of bands */
 	long freq = 0L;		/* offset to 2.4 GHz in .5 MHz */
@@ -1516,9 +1496,8 @@ static int wv_set_frequency(unsigned long ioaddr,	/* I/O port of the card */
 	 * the two limits with a 0.5 MHz precision. In practice,
 	 * I don't want you to have trouble with local regulations.
 	 */
-	if ((frequency->e == 1) &&
-	    (frequency->m >= (int) 2.412e8)
-	    && (frequency->m <= (int) 2.487e8)) {
+	if ((frequency->e == 1) && (frequency->m >= (int)2.412e8)
+	    && (frequency->m <= (int)2.487e8)) {
 		freq = ((frequency->m / 10000) - 24000L) / 5;
 	}
 
@@ -1547,7 +1526,8 @@ static int wv_set_frequency(unsigned long ioaddr,	/* I/O port of the card */
 
 		/* Look in the table to see whether the frequency is allowed. */
 		if (!(table[9 - ((freq - 24) / 16)] &
-		      (1 << ((freq - 24) % 16)))) return -EINVAL;	/* not allowed */
+		      (1 << ((freq - 24) % 16))))
+			return -EINVAL;	/* not allowed */
 	} else
 		return -EINVAL;
 
@@ -1567,7 +1547,7 @@ static int wv_set_frequency(unsigned long ioaddr,	/* I/O port of the card */
 		/* Search for the gain. */
 		power_band = 0;
 		while ((freq > power_limit[power_band]) &&
-		       (power_limit[++power_band] != 0));
+		       (power_limit[++power_band] != 0)) ;
 
 		/* Read the first area. */
 		fee_read(ioaddr, 0x00, area, 16);
@@ -1576,8 +1556,7 @@ static int wv_set_frequency(unsigned long ioaddr,	/* I/O port of the card */
 		fee_read(ioaddr, 0x60, dac, 2);
 
 		/* Read the new power adjust value. */
-		fee_read(ioaddr, 0x6B - (power_band >> 1), &power_adjust,
-			 1);
+		fee_read(ioaddr, 0x6B - (power_band >> 1), &power_adjust, 1);
 		if (power_band & 0x1)
 			power_adjust >>= 8;
 		else
@@ -1678,10 +1657,10 @@ static int wv_set_frequency(unsigned long ioaddr,	/* I/O port of the card */
  * Give the list of available frequencies.
  */
 static int wv_frequency_list(unsigned long ioaddr,	/* I/O port of the card */
-				    iw_freq * list,	/* List of frequencies to fill */
-				    int max)
+			     iw_freq * list,	/* List of frequencies to fill */
+			     int max)
 {				/* Maximum number of frequencies */
-	u16 table[10];	/* Authorized frequency table */
+	u16 table[10];		/* Authorized frequency table */
 	long freq = 0L;		/* offset to 2.4 GHz in .5 MHz + 12 MHz */
 	int i;			/* index in the table */
 	int c = 0;		/* Channel number */
@@ -1696,7 +1675,7 @@ static int wv_frequency_list(unsigned long ioaddr,	/* I/O port of the card */
 		if (table[9 - (freq / 16)] & (1 << (freq % 16))) {
 			/* Compute approximate channel number */
 			while ((c < ARRAY_SIZE(channel_bands)) &&
-				(((channel_bands[c] >> 1) - 24) < freq)) 
+			       (((channel_bands[c] >> 1) - 24) < freq))
 				c++;
 			list[i].i = c;	/* Set the list index */
 
@@ -1719,10 +1698,9 @@ static int wv_frequency_list(unsigned long ioaddr,	/* I/O port of the card */
  * address with our list, and if they match, get the statistics.
  * Sorry, but this function really needs the wireless extensions.
  */
-static inline void wl_spy_gather(struct net_device * dev,
-				 u8 *	mac,	/* MAC address */
-				 u8 *	stats)	/* Statistics to gather */
-{
+static inline void wl_spy_gather(struct net_device *dev, u8 * mac,	/* MAC address */
+				 u8 * stats)
+{				/* Statistics to gather */
 	struct iw_quality wstats;
 
 	wstats.qual = stats[2] & MMR_SGNL_QUAL;
@@ -1733,7 +1711,7 @@ static inline void wl_spy_gather(struct net_device * dev,
 	/* Update spy records */
 	wireless_spy_update(dev, mac, &wstats);
 }
-#endif /* IW_WIRELESS_SPY */
+#endif				/* IW_WIRELESS_SPY */
 
 #ifdef HISTOGRAM
 /*------------------------------------------------------------------*/
@@ -1745,7 +1723,7 @@ static inline void wl_spy_gather(struct net_device * dev,
  * With this histogram you may detect if one WaveLAN is really weak,
  * or you may also calculate the mean and standard deviation of the level.
  */
-static inline void wl_his_gather(struct net_device * dev, u8 * stats)
+static inline void wl_his_gather(struct net_device *dev, u8 * stats)
 {				/* Statistics to gather */
 	net_local *lp = (net_local *) dev->priv;
 	u8 level = stats[0] & MMR_SIGNAL_LVL;
@@ -1754,12 +1732,12 @@ static inline void wl_his_gather(struct net_device * dev, u8 * stats)
 	/* Find the correct interval. */
 	i = 0;
 	while ((i < (lp->his_number - 1))
-	       && (level >= lp->his_range[i++]));
+	       && (level >= lp->his_range[i++])) ;
 
 	/* Increment interval counter. */
 	(lp->his_sum[i])++;
 }
-#endif /* HISTOGRAM */
+#endif				/* HISTOGRAM */
 
 /*------------------------------------------------------------------*/
 /*
@@ -1767,8 +1745,7 @@ static inline void wl_his_gather(struct net_device * dev, u8 * stats)
  */
 static int wavelan_get_name(struct net_device *dev,
 			    struct iw_request_info *info,
-			    union iwreq_data *wrqu,
-			    char *extra)
+			    union iwreq_data *wrqu, char *extra)
 {
 	strcpy(wrqu->name, "WaveLAN");
 	return 0;
@@ -1780,8 +1757,7 @@ static int wavelan_get_name(struct net_device *dev,
  */
 static int wavelan_set_nwid(struct net_device *dev,
 			    struct iw_request_info *info,
-			    union iwreq_data *wrqu,
-			    char *extra)
+			    union iwreq_data *wrqu, char *extra)
 {
 	unsigned long ioaddr = dev->base_addr;
 	net_local *lp = (net_local *) dev->priv;	/* lp is not unused */
@@ -1792,7 +1768,7 @@ static int wavelan_set_nwid(struct net_device *dev,
 
 	/* Disable interrupts and save flags. */
 	spin_lock_irqsave(&lp->spinlock, flags);
-	
+
 	/* Set NWID in WaveLAN. */
 	if (!wrqu->nwid.disabled) {
 		/* Set NWID in psa */
@@ -1800,25 +1776,23 @@ static int wavelan_set_nwid(struct net_device *dev,
 		psa.psa_nwid[1] = wrqu->nwid.value & 0xFF;
 		psa.psa_nwid_select = 0x01;
 		psa_write(ioaddr, lp->hacr,
-			  (char *) psa.psa_nwid - (char *) &psa,
-			  (unsigned char *) psa.psa_nwid, 3);
+			  (char *)psa.psa_nwid - (char *)&psa,
+			  (unsigned char *)psa.psa_nwid, 3);
 
 		/* Set NWID in mmc. */
 		m.w.mmw_netw_id_l = psa.psa_nwid[1];
 		m.w.mmw_netw_id_h = psa.psa_nwid[0];
 		mmc_write(ioaddr,
-			  (char *) &m.w.mmw_netw_id_l -
-			  (char *) &m,
-			  (unsigned char *) &m.w.mmw_netw_id_l, 2);
+			  (char *)&m.w.mmw_netw_id_l -
+			  (char *)&m, (unsigned char *)&m.w.mmw_netw_id_l, 2);
 		mmc_out(ioaddr, mmwoff(0, mmw_loopt_sel), 0x00);
 	} else {
 		/* Disable NWID in the psa. */
 		psa.psa_nwid_select = 0x00;
 		psa_write(ioaddr, lp->hacr,
-			  (char *) &psa.psa_nwid_select -
-			  (char *) &psa,
-			  (unsigned char *) &psa.psa_nwid_select,
-			  1);
+			  (char *)&psa.psa_nwid_select -
+			  (char *)&psa,
+			  (unsigned char *)&psa.psa_nwid_select, 1);
 
 		/* Disable NWID in the mmc (no filtering). */
 		mmc_out(ioaddr, mmwoff(0, mmw_loopt_sel),
@@ -1839,8 +1813,7 @@ static int wavelan_set_nwid(struct net_device *dev,
  */
 static int wavelan_get_nwid(struct net_device *dev,
 			    struct iw_request_info *info,
-			    union iwreq_data *wrqu,
-			    char *extra)
+			    union iwreq_data *wrqu, char *extra)
 {
 	unsigned long ioaddr = dev->base_addr;
 	net_local *lp = (net_local *) dev->priv;	/* lp is not unused */
@@ -1850,11 +1823,11 @@ static int wavelan_get_nwid(struct net_device *dev,
 
 	/* Disable interrupts and save flags. */
 	spin_lock_irqsave(&lp->spinlock, flags);
-	
+
 	/* Read the NWID. */
 	psa_read(ioaddr, lp->hacr,
-		 (char *) psa.psa_nwid - (char *) &psa,
-		 (unsigned char *) psa.psa_nwid, 3);
+		 (char *)psa.psa_nwid - (char *)&psa,
+		 (unsigned char *)psa.psa_nwid, 3);
 	wrqu->nwid.value = (psa.psa_nwid[0] << 8) + psa.psa_nwid[1];
 	wrqu->nwid.disabled = !(psa.psa_nwid_select);
 	wrqu->nwid.fixed = 1;	/* Superfluous */
@@ -1871,8 +1844,7 @@ static int wavelan_get_nwid(struct net_device *dev,
  */
 static int wavelan_set_freq(struct net_device *dev,
 			    struct iw_request_info *info,
-			    union iwreq_data *wrqu,
-			    char *extra)
+			    union iwreq_data *wrqu, char *extra)
 {
 	unsigned long ioaddr = dev->base_addr;
 	net_local *lp = (net_local *) dev->priv;	/* lp is not unused */
@@ -1881,7 +1853,7 @@ static int wavelan_set_freq(struct net_device *dev,
 
 	/* Disable interrupts and save flags. */
 	spin_lock_irqsave(&lp->spinlock, flags);
-	
+
 	/* Attempt to recognise 2.00 cards (2.4 GHz frequency selectable). */
 	if (!(mmc_in(ioaddr, mmroff(0, mmr_fee_status)) &
 	      (MMR_FEE_STATUS_DWLD | MMR_FEE_STATUS_BUSY)))
@@ -1901,8 +1873,7 @@ static int wavelan_set_freq(struct net_device *dev,
  */
 static int wavelan_get_freq(struct net_device *dev,
 			    struct iw_request_info *info,
-			    union iwreq_data *wrqu,
-			    char *extra)
+			    union iwreq_data *wrqu, char *extra)
 {
 	unsigned long ioaddr = dev->base_addr;
 	net_local *lp = (net_local *) dev->priv;	/* lp is not unused */
@@ -1912,7 +1883,7 @@ static int wavelan_get_freq(struct net_device *dev,
 
 	/* Disable interrupts and save flags. */
 	spin_lock_irqsave(&lp->spinlock, flags);
-	
+
 	/* Attempt to recognise 2.00 cards (2.4 GHz frequency selectable).
 	 * Does it work for everybody, especially old cards? */
 	if (!(mmc_in(ioaddr, mmroff(0, mmr_fee_status)) &
@@ -1925,8 +1896,8 @@ static int wavelan_get_freq(struct net_device *dev,
 		wrqu->freq.e = 1;
 	} else {
 		psa_read(ioaddr, lp->hacr,
-			 (char *) &psa.psa_subband - (char *) &psa,
-			 (unsigned char *) &psa.psa_subband, 1);
+			 (char *)&psa.psa_subband - (char *)&psa,
+			 (unsigned char *)&psa.psa_subband, 1);
 
 		if (psa.psa_subband <= 4) {
 			wrqu->freq.m = fixed_bands[psa.psa_subband];
@@ -1947,8 +1918,7 @@ static int wavelan_get_freq(struct net_device *dev,
  */
 static int wavelan_set_sens(struct net_device *dev,
 			    struct iw_request_info *info,
-			    union iwreq_data *wrqu,
-			    char *extra)
+			    union iwreq_data *wrqu, char *extra)
 {
 	unsigned long ioaddr = dev->base_addr;
 	net_local *lp = (net_local *) dev->priv;	/* lp is not unused */
@@ -1958,18 +1928,17 @@ static int wavelan_set_sens(struct net_device *dev,
 
 	/* Disable interrupts and save flags. */
 	spin_lock_irqsave(&lp->spinlock, flags);
-	
+
 	/* Set the level threshold. */
 	/* We should complain loudly if wrqu->sens.fixed = 0, because we
 	 * can't set auto mode... */
 	psa.psa_thr_pre_set = wrqu->sens.value & 0x3F;
 	psa_write(ioaddr, lp->hacr,
-		  (char *) &psa.psa_thr_pre_set - (char *) &psa,
-		  (unsigned char *) &psa.psa_thr_pre_set, 1);
+		  (char *)&psa.psa_thr_pre_set - (char *)&psa,
+		  (unsigned char *)&psa.psa_thr_pre_set, 1);
 	/* update the Wavelan checksum */
 	update_psa_checksum(dev, ioaddr, lp->hacr);
-	mmc_out(ioaddr, mmwoff(0, mmw_thr_pre_set),
-		psa.psa_thr_pre_set);
+	mmc_out(ioaddr, mmwoff(0, mmw_thr_pre_set), psa.psa_thr_pre_set);
 
 	/* Enable interrupts and restore flags. */
 	spin_unlock_irqrestore(&lp->spinlock, flags);
@@ -1983,8 +1952,7 @@ static int wavelan_set_sens(struct net_device *dev,
  */
 static int wavelan_get_sens(struct net_device *dev,
 			    struct iw_request_info *info,
-			    union iwreq_data *wrqu,
-			    char *extra)
+			    union iwreq_data *wrqu, char *extra)
 {
 	unsigned long ioaddr = dev->base_addr;
 	net_local *lp = (net_local *) dev->priv;	/* lp is not unused */
@@ -1994,11 +1962,11 @@ static int wavelan_get_sens(struct net_device *dev,
 
 	/* Disable interrupts and save flags. */
 	spin_lock_irqsave(&lp->spinlock, flags);
-	
+
 	/* Read the level threshold. */
 	psa_read(ioaddr, lp->hacr,
-		 (char *) &psa.psa_thr_pre_set - (char *) &psa,
-		 (unsigned char *) &psa.psa_thr_pre_set, 1);
+		 (char *)&psa.psa_thr_pre_set - (char *)&psa,
+		 (unsigned char *)&psa.psa_thr_pre_set, 1);
 	wrqu->sens.value = psa.psa_thr_pre_set & 0x3F;
 	wrqu->sens.fixed = 1;
 
@@ -2014,8 +1982,7 @@ static int wavelan_get_sens(struct net_device *dev,
  */
 static int wavelan_set_encode(struct net_device *dev,
 			      struct iw_request_info *info,
-			      union iwreq_data *wrqu,
-			      char *extra)
+			      union iwreq_data *wrqu, char *extra)
 {
 	unsigned long ioaddr = dev->base_addr;
 	net_local *lp = (net_local *) dev->priv;	/* lp is not unused */
@@ -2032,11 +1999,11 @@ static int wavelan_set_encode(struct net_device *dev,
 	}
 
 	/* Check the size of the key */
-	if((wrqu->encoding.length != 8) && (wrqu->encoding.length != 0)) {
+	if ((wrqu->encoding.length != 8) && (wrqu->encoding.length != 0)) {
 		ret = -EINVAL;
 	}
 
-	if(!ret) {
+	if (!ret) {
 		/* Basic checking... */
 		if (wrqu->encoding.length == 8) {
 			/* Copy the key in the driver */
@@ -2045,25 +2012,24 @@ static int wavelan_set_encode(struct net_device *dev,
 			psa.psa_encryption_select = 1;
 
 			psa_write(ioaddr, lp->hacr,
-				  (char *) &psa.psa_encryption_select -
-				  (char *) &psa,
-				  (unsigned char *) &psa.
+				  (char *)&psa.psa_encryption_select -
+				  (char *)&psa,
+				  (unsigned char *)&psa.
 				  psa_encryption_select, 8 + 1);
 
 			mmc_out(ioaddr, mmwoff(0, mmw_encr_enable),
 				MMW_ENCR_ENABLE_EN | MMW_ENCR_ENABLE_MODE);
 			mmc_write(ioaddr, mmwoff(0, mmw_encr_key),
-				  (unsigned char *) &psa.
-				  psa_encryption_key, 8);
+				  (unsigned char *)&psa.psa_encryption_key, 8);
 		}
 
 		/* disable encryption */
 		if (wrqu->encoding.flags & IW_ENCODE_DISABLED) {
 			psa.psa_encryption_select = 0;
 			psa_write(ioaddr, lp->hacr,
-				  (char *) &psa.psa_encryption_select -
-				  (char *) &psa,
-				  (unsigned char *) &psa.
+				  (char *)&psa.psa_encryption_select -
+				  (char *)&psa,
+				  (unsigned char *)&psa.
 				  psa_encryption_select, 1);
 
 			mmc_out(ioaddr, mmwoff(0, mmw_encr_enable), 0);
@@ -2084,8 +2050,7 @@ static int wavelan_set_encode(struct net_device *dev,
  */
 static int wavelan_get_encode(struct net_device *dev,
 			      struct iw_request_info *info,
-			      union iwreq_data *wrqu,
-			      char *extra)
+			      union iwreq_data *wrqu, char *extra)
 {
 	unsigned long ioaddr = dev->base_addr;
 	net_local *lp = (net_local *) dev->priv;	/* lp is not unused */
@@ -2095,17 +2060,16 @@ static int wavelan_get_encode(struct net_device *dev,
 
 	/* Disable interrupts and save flags. */
 	spin_lock_irqsave(&lp->spinlock, flags);
-	
+
 	/* Check if encryption is available */
 	if (!mmc_encr(ioaddr)) {
 		ret = -EOPNOTSUPP;
 	} else {
 		/* Read the encryption key */
 		psa_read(ioaddr, lp->hacr,
-			 (char *) &psa.psa_encryption_select -
-			 (char *) &psa,
-			 (unsigned char *) &psa.
-			 psa_encryption_select, 1 + 8);
+			 (char *)&psa.psa_encryption_select -
+			 (char *)&psa,
+			 (unsigned char *)&psa.psa_encryption_select, 1 + 8);
 
 		/* encryption is enabled ? */
 		if (psa.psa_encryption_select)
@@ -2131,12 +2095,11 @@ static int wavelan_get_encode(struct net_device *dev,
  */
 static int wavelan_get_range(struct net_device *dev,
 			     struct iw_request_info *info,
-			     union iwreq_data *wrqu,
-			     char *extra)
+			     union iwreq_data *wrqu, char *extra)
 {
 	unsigned long ioaddr = dev->base_addr;
 	net_local *lp = (net_local *) dev->priv;	/* lp is not unused */
-	struct iw_range *range = (struct iw_range *) extra;
+	struct iw_range *range = (struct iw_range *)extra;
 	unsigned long flags;
 	int ret = 0;
 
@@ -2159,7 +2122,7 @@ static int wavelan_get_range(struct net_device *dev,
 	range->max_qual.qual = MMR_SGNL_QUAL;
 	range->max_qual.level = MMR_SIGNAL_LVL;
 	range->max_qual.noise = MMR_SILENCE_LVL;
-	range->avg_qual.qual = MMR_SGNL_QUAL; /* Always max */
+	range->avg_qual.qual = MMR_SGNL_QUAL;	/* Always max */
 	/* Need to get better values for those two */
 	range->avg_qual.level = 30;
 	range->avg_qual.noise = 8;
@@ -2174,13 +2137,13 @@ static int wavelan_get_range(struct net_device *dev,
 
 	/* Disable interrupts and save flags. */
 	spin_lock_irqsave(&lp->spinlock, flags);
-	
+
 	/* Attempt to recognise 2.00 cards (2.4 GHz frequency selectable). */
 	if (!(mmc_in(ioaddr, mmroff(0, mmr_fee_status)) &
 	      (MMR_FEE_STATUS_DWLD | MMR_FEE_STATUS_BUSY))) {
 		range->num_channels = 10;
 		range->num_frequency = wv_frequency_list(ioaddr, range->freq,
-							IW_MAX_FREQUENCIES);
+							 IW_MAX_FREQUENCIES);
 	} else
 		range->num_channels = range->num_frequency = 0;
 
@@ -2206,8 +2169,7 @@ static int wavelan_get_range(struct net_device *dev,
  */
 static int wavelan_set_qthr(struct net_device *dev,
 			    struct iw_request_info *info,
-			    union iwreq_data *wrqu,
-			    char *extra)
+			    union iwreq_data *wrqu, char *extra)
 {
 	unsigned long ioaddr = dev->base_addr;
 	net_local *lp = (net_local *) dev->priv;	/* lp is not unused */
@@ -2216,15 +2178,14 @@ static int wavelan_set_qthr(struct net_device *dev,
 
 	/* Disable interrupts and save flags. */
 	spin_lock_irqsave(&lp->spinlock, flags);
-	
+
 	psa.psa_quality_thr = *(extra) & 0x0F;
 	psa_write(ioaddr, lp->hacr,
-		  (char *) &psa.psa_quality_thr - (char *) &psa,
-		  (unsigned char *) &psa.psa_quality_thr, 1);
+		  (char *)&psa.psa_quality_thr - (char *)&psa,
+		  (unsigned char *)&psa.psa_quality_thr, 1);
 	/* update the Wavelan checksum */
 	update_psa_checksum(dev, ioaddr, lp->hacr);
-	mmc_out(ioaddr, mmwoff(0, mmw_quality_thr),
-		psa.psa_quality_thr);
+	mmc_out(ioaddr, mmwoff(0, mmw_quality_thr), psa.psa_quality_thr);
 
 	/* Enable interrupts and restore flags. */
 	spin_unlock_irqrestore(&lp->spinlock, flags);
@@ -2238,8 +2199,7 @@ static int wavelan_set_qthr(struct net_device *dev,
  */
 static int wavelan_get_qthr(struct net_device *dev,
 			    struct iw_request_info *info,
-			    union iwreq_data *wrqu,
-			    char *extra)
+			    union iwreq_data *wrqu, char *extra)
 {
 	unsigned long ioaddr = dev->base_addr;
 	net_local *lp = (net_local *) dev->priv;	/* lp is not unused */
@@ -2248,10 +2208,10 @@ static int wavelan_get_qthr(struct net_device *dev,
 
 	/* Disable interrupts and save flags. */
 	spin_lock_irqsave(&lp->spinlock, flags);
-	
+
 	psa_read(ioaddr, lp->hacr,
-		 (char *) &psa.psa_quality_thr - (char *) &psa,
-		 (unsigned char *) &psa.psa_quality_thr, 1);
+		 (char *)&psa.psa_quality_thr - (char *)&psa,
+		 (unsigned char *)&psa.psa_quality_thr, 1);
 	*(extra) = psa.psa_quality_thr & 0x0F;
 
 	/* Enable interrupts and restore flags. */
@@ -2267,14 +2227,13 @@ static int wavelan_get_qthr(struct net_device *dev,
  */
 static int wavelan_set_histo(struct net_device *dev,
 			     struct iw_request_info *info,
-			     union iwreq_data *wrqu,
-			     char *extra)
+			     union iwreq_data *wrqu, char *extra)
 {
 	net_local *lp = (net_local *) dev->priv;	/* lp is not unused */
 
 	/* Check the number of intervals. */
 	if (wrqu->data.length > 16) {
-		return(-E2BIG);
+		return (-E2BIG);
 	}
 
 	/* Disable histo while we copy the addresses.
@@ -2287,11 +2246,11 @@ static int wavelan_set_histo(struct net_device *dev,
 		memcpy(lp->his_range, extra, wrqu->data.length);
 
 		{
-		  int i;
-		  printk(KERN_DEBUG "Histo :");
-		  for(i = 0; i < wrqu->data.length; i++)
-		    printk(" %d", lp->his_range[i]);
-		  printk("\n");
+			int i;
+			printk(KERN_DEBUG "Histo :");
+			for (i = 0; i < wrqu->data.length; i++)
+				printk(" %d", lp->his_range[i]);
+			printk("\n");
 		}
 
 		/* Reset result structure. */
@@ -2301,7 +2260,7 @@ static int wavelan_set_histo(struct net_device *dev,
 	/* Now we can set the number of ranges */
 	lp->his_number = wrqu->data.length;
 
-	return(0);
+	return (0);
 }
 
 /*------------------------------------------------------------------*/
@@ -2310,8 +2269,7 @@ static int wavelan_set_histo(struct net_device *dev,
  */
 static int wavelan_get_histo(struct net_device *dev,
 			     struct iw_request_info *info,
-			     union iwreq_data *wrqu,
-			     char *extra)
+			     union iwreq_data *wrqu, char *extra)
 {
 	net_local *lp = (net_local *) dev->priv;	/* lp is not unused */
 
@@ -2319,93 +2277,93 @@ static int wavelan_get_histo(struct net_device *dev,
 	wrqu->data.length = lp->his_number;
 
 	/* Give back the distribution statistics */
-	if(lp->his_number > 0)
+	if (lp->his_number > 0)
 		memcpy(extra, lp->his_sum, sizeof(long) * lp->his_number);
 
-	return(0);
+	return (0);
 }
-#endif			/* HISTOGRAM */
+#endif				/* HISTOGRAM */
 
 /*------------------------------------------------------------------*/
 /*
  * Structures to export the Wireless Handlers
  */
 
-static const iw_handler		wavelan_handler[] =
-{
-	NULL,				/* SIOCSIWNAME */
-	wavelan_get_name,		/* SIOCGIWNAME */
-	wavelan_set_nwid,		/* SIOCSIWNWID */
-	wavelan_get_nwid,		/* SIOCGIWNWID */
-	wavelan_set_freq,		/* SIOCSIWFREQ */
-	wavelan_get_freq,		/* SIOCGIWFREQ */
-	NULL,				/* SIOCSIWMODE */
-	NULL,				/* SIOCGIWMODE */
-	wavelan_set_sens,		/* SIOCSIWSENS */
-	wavelan_get_sens,		/* SIOCGIWSENS */
-	NULL,				/* SIOCSIWRANGE */
-	wavelan_get_range,		/* SIOCGIWRANGE */
-	NULL,				/* SIOCSIWPRIV */
-	NULL,				/* SIOCGIWPRIV */
-	NULL,				/* SIOCSIWSTATS */
-	NULL,				/* SIOCGIWSTATS */
-	iw_handler_set_spy,		/* SIOCSIWSPY */
-	iw_handler_get_spy,		/* SIOCGIWSPY */
-	iw_handler_set_thrspy,		/* SIOCSIWTHRSPY */
-	iw_handler_get_thrspy,		/* SIOCGIWTHRSPY */
-	NULL,				/* SIOCSIWAP */
-	NULL,				/* SIOCGIWAP */
-	NULL,				/* -- hole -- */
-	NULL,				/* SIOCGIWAPLIST */
-	NULL,				/* -- hole -- */
-	NULL,				/* -- hole -- */
-	NULL,				/* SIOCSIWESSID */
-	NULL,				/* SIOCGIWESSID */
-	NULL,				/* SIOCSIWNICKN */
-	NULL,				/* SIOCGIWNICKN */
-	NULL,				/* -- hole -- */
-	NULL,				/* -- hole -- */
-	NULL,				/* SIOCSIWRATE */
-	NULL,				/* SIOCGIWRATE */
-	NULL,				/* SIOCSIWRTS */
-	NULL,				/* SIOCGIWRTS */
-	NULL,				/* SIOCSIWFRAG */
-	NULL,				/* SIOCGIWFRAG */
-	NULL,				/* SIOCSIWTXPOW */
-	NULL,				/* SIOCGIWTXPOW */
-	NULL,				/* SIOCSIWRETRY */
-	NULL,				/* SIOCGIWRETRY */
+static const iw_handler wavelan_handler[] = {
+	NULL,			/* SIOCSIWNAME */
+	wavelan_get_name,	/* SIOCGIWNAME */
+	wavelan_set_nwid,	/* SIOCSIWNWID */
+	wavelan_get_nwid,	/* SIOCGIWNWID */
+	wavelan_set_freq,	/* SIOCSIWFREQ */
+	wavelan_get_freq,	/* SIOCGIWFREQ */
+	NULL,			/* SIOCSIWMODE */
+	NULL,			/* SIOCGIWMODE */
+	wavelan_set_sens,	/* SIOCSIWSENS */
+	wavelan_get_sens,	/* SIOCGIWSENS */
+	NULL,			/* SIOCSIWRANGE */
+	wavelan_get_range,	/* SIOCGIWRANGE */
+	NULL,			/* SIOCSIWPRIV */
+	NULL,			/* SIOCGIWPRIV */
+	NULL,			/* SIOCSIWSTATS */
+	NULL,			/* SIOCGIWSTATS */
+	iw_handler_set_spy,	/* SIOCSIWSPY */
+	iw_handler_get_spy,	/* SIOCGIWSPY */
+	iw_handler_set_thrspy,	/* SIOCSIWTHRSPY */
+	iw_handler_get_thrspy,	/* SIOCGIWTHRSPY */
+	NULL,			/* SIOCSIWAP */
+	NULL,			/* SIOCGIWAP */
+	NULL,			/* -- hole -- */
+	NULL,			/* SIOCGIWAPLIST */
+	NULL,			/* -- hole -- */
+	NULL,			/* -- hole -- */
+	NULL,			/* SIOCSIWESSID */
+	NULL,			/* SIOCGIWESSID */
+	NULL,			/* SIOCSIWNICKN */
+	NULL,			/* SIOCGIWNICKN */
+	NULL,			/* -- hole -- */
+	NULL,			/* -- hole -- */
+	NULL,			/* SIOCSIWRATE */
+	NULL,			/* SIOCGIWRATE */
+	NULL,			/* SIOCSIWRTS */
+	NULL,			/* SIOCGIWRTS */
+	NULL,			/* SIOCSIWFRAG */
+	NULL,			/* SIOCGIWFRAG */
+	NULL,			/* SIOCSIWTXPOW */
+	NULL,			/* SIOCGIWTXPOW */
+	NULL,			/* SIOCSIWRETRY */
+	NULL,			/* SIOCGIWRETRY */
 	/* Bummer ! Why those are only at the end ??? */
-	wavelan_set_encode,		/* SIOCSIWENCODE */
-	wavelan_get_encode,		/* SIOCGIWENCODE */
+	wavelan_set_encode,	/* SIOCSIWENCODE */
+	wavelan_get_encode,	/* SIOCGIWENCODE */
 };
 
-static const iw_handler		wavelan_private_handler[] =
-{
-	wavelan_set_qthr,		/* SIOCIWFIRSTPRIV */
-	wavelan_get_qthr,		/* SIOCIWFIRSTPRIV + 1 */
+static const iw_handler wavelan_private_handler[] = {
+	wavelan_set_qthr,	/* SIOCIWFIRSTPRIV */
+	wavelan_get_qthr,	/* SIOCIWFIRSTPRIV + 1 */
 #ifdef HISTOGRAM
-	wavelan_set_histo,		/* SIOCIWFIRSTPRIV + 2 */
-	wavelan_get_histo,		/* SIOCIWFIRSTPRIV + 3 */
-#endif	/* HISTOGRAM */
+	wavelan_set_histo,	/* SIOCIWFIRSTPRIV + 2 */
+	wavelan_get_histo,	/* SIOCIWFIRSTPRIV + 3 */
+#endif				/* HISTOGRAM */
 };
 
 static const struct iw_priv_args wavelan_private_args[] = {
 /*{ cmd,         set_args,                            get_args, name } */
-  { SIOCSIPQTHR, IW_PRIV_TYPE_BYTE | IW_PRIV_SIZE_FIXED | 1, 0, "setqualthr" },
-  { SIOCGIPQTHR, 0, IW_PRIV_TYPE_BYTE | IW_PRIV_SIZE_FIXED | 1, "getqualthr" },
-  { SIOCSIPHISTO, IW_PRIV_TYPE_BYTE | 16,                    0, "sethisto" },
-  { SIOCGIPHISTO, 0,                     IW_PRIV_TYPE_INT | 16, "gethisto" },
+	{SIOCSIPQTHR, IW_PRIV_TYPE_BYTE | IW_PRIV_SIZE_FIXED | 1, 0,
+	 "setqualthr"},
+	{SIOCGIPQTHR, 0, IW_PRIV_TYPE_BYTE | IW_PRIV_SIZE_FIXED | 1,
+	 "getqualthr"},
+	{SIOCSIPHISTO, IW_PRIV_TYPE_BYTE | 16, 0, "sethisto"},
+	{SIOCGIPHISTO, 0, IW_PRIV_TYPE_INT | 16, "gethisto"},
 };
 
-static const struct iw_handler_def	wavelan_handler_def =
-{
-	.num_standard	= sizeof(wavelan_handler)/sizeof(iw_handler),
-	.num_private	= sizeof(wavelan_private_handler)/sizeof(iw_handler),
-	.num_private_args = sizeof(wavelan_private_args)/sizeof(struct iw_priv_args),
-	.standard	= wavelan_handler,
-	.private	= wavelan_private_handler,
-	.private_args	= wavelan_private_args,
+static const struct iw_handler_def wavelan_handler_def = {
+	.num_standard = sizeof(wavelan_handler) / sizeof(iw_handler),
+	.num_private = sizeof(wavelan_private_handler) / sizeof(iw_handler),
+	.num_private_args =
+	    sizeof(wavelan_private_args) / sizeof(struct iw_priv_args),
+	.standard = wavelan_handler,
+	.private = wavelan_private_handler,
+	.private_args = wavelan_private_args,
 	.get_wireless_stats = wavelan_get_wireless_stats,
 };
 
@@ -2414,7 +2372,7 @@ static const struct iw_handler_def	wavelan_handler_def =
  * Get wireless statistics.
  * Called by /proc/net/wireless
  */
-static iw_stats *wavelan_get_wireless_stats(struct net_device * dev)
+static iw_stats *wavelan_get_wireless_stats(struct net_device *dev)
 {
 	unsigned long ioaddr = dev->base_addr;
 	net_local *lp = (net_local *) dev->priv;
@@ -2423,27 +2381,24 @@ static iw_stats *wavelan_get_wireless_stats(struct net_device * dev)
 	unsigned long flags;
 
 #ifdef DEBUG_IOCTL_TRACE
-	printk(KERN_DEBUG "%s: ->wavelan_get_wireless_stats()\n",
-	       dev->name);
+	printk(KERN_DEBUG "%s: ->wavelan_get_wireless_stats()\n", dev->name);
 #endif
 
 	/* Check */
 	if (lp == (net_local *) NULL)
 		return (iw_stats *) NULL;
-	
+
 	/* Disable interrupts and save flags. */
 	spin_lock_irqsave(&lp->spinlock, flags);
-	
+
 	wstats = &lp->wstats;
 
 	/* Get data from the mmc. */
 	mmc_out(ioaddr, mmwoff(0, mmw_freeze), 1);
 
 	mmc_read(ioaddr, mmroff(0, mmr_dce_status), &m.mmr_dce_status, 1);
-	mmc_read(ioaddr, mmroff(0, mmr_wrong_nwid_l), &m.mmr_wrong_nwid_l,
-		 2);
-	mmc_read(ioaddr, mmroff(0, mmr_thr_pre_set), &m.mmr_thr_pre_set,
-		 4);
+	mmc_read(ioaddr, mmroff(0, mmr_wrong_nwid_l), &m.mmr_wrong_nwid_l, 2);
+	mmc_read(ioaddr, mmroff(0, mmr_thr_pre_set), &m.mmr_thr_pre_set, 4);
 
 	mmc_out(ioaddr, mmwoff(0, mmw_freeze), 0);
 
@@ -2452,9 +2407,11 @@ static iw_stats *wavelan_get_wireless_stats(struct net_device * dev)
 	wstats->qual.qual = m.mmr_sgnl_qual & MMR_SGNL_QUAL;
 	wstats->qual.level = m.mmr_signal_lvl & MMR_SIGNAL_LVL;
 	wstats->qual.noise = m.mmr_silence_lvl & MMR_SILENCE_LVL;
-	wstats->qual.updated = (((m. mmr_signal_lvl & MMR_SIGNAL_LVL_VALID) >> 7) 
-			| ((m.mmr_signal_lvl & MMR_SIGNAL_LVL_VALID) >> 6) 
-			| ((m.mmr_silence_lvl & MMR_SILENCE_LVL_VALID) >> 5));
+	wstats->qual.updated = (((m.mmr_signal_lvl & MMR_SIGNAL_LVL_VALID) >> 7)
+				| ((m.mmr_signal_lvl & MMR_SIGNAL_LVL_VALID) >>
+				   6)
+				| ((m.mmr_silence_lvl & MMR_SILENCE_LVL_VALID)
+				   >> 5));
 	wstats->discard.nwid += (m.mmr_wrong_nwid_h << 8) | m.mmr_wrong_nwid_l;
 	wstats->discard.code = 0L;
 	wstats->discard.misc = 0L;
@@ -2463,8 +2420,7 @@ static iw_stats *wavelan_get_wireless_stats(struct net_device * dev)
 	spin_unlock_irqrestore(&lp->spinlock, flags);
 
 #ifdef DEBUG_IOCTL_TRACE
-	printk(KERN_DEBUG "%s: <-wavelan_get_wireless_stats()\n",
-	       dev->name);
+	printk(KERN_DEBUG "%s: <-wavelan_get_wireless_stats()\n", dev->name);
 #endif
 	return &lp->wstats;
 }
@@ -2489,8 +2445,7 @@ static iw_stats *wavelan_get_wireless_stats(struct net_device * dev)
  * Note: if any errors occur, the packet is "dropped on the floor".
  * (called by wv_packet_rcv())
  */
-static void
-wv_packet_read(struct net_device * dev, u16 buf_off, int sksize)
+static void wv_packet_read(struct net_device *dev, u16 buf_off, int sksize)
 {
 	net_local *lp = (net_local *) dev->priv;
 	unsigned long ioaddr = dev->base_addr;
@@ -2502,7 +2457,7 @@ wv_packet_read(struct net_device * dev, u16 buf_off, int sksize)
 #endif
 
 	/* Allocate buffer for the data */
-	if ((skb = dev_alloc_skb(sksize)) == (struct sk_buff *) NULL) {
+	if ((skb = dev_alloc_skb(sksize)) == (struct sk_buff *)NULL) {
 #ifdef DEBUG_RX_ERROR
 		printk(KERN_INFO
 		       "%s: wv_packet_read(): could not alloc_skb(%d, GFP_ATOMIC).\n",
@@ -2527,10 +2482,10 @@ wv_packet_read(struct net_device * dev, u16 buf_off, int sksize)
 	if (
 #ifdef IW_WIRELESS_SPY		/* defined in iw_handler.h */
 		   (lp->spy_data.spy_number > 0) ||
-#endif /* IW_WIRELESS_SPY */
+#endif				/* IW_WIRELESS_SPY */
 #ifdef HISTOGRAM
 		   (lp->his_number > 0) ||
-#endif /* HISTOGRAM */
+#endif				/* HISTOGRAM */
 		   0) {
 		u8 stats[3];	/* signal level, noise level, signal quality */
 
@@ -2556,10 +2511,10 @@ wv_packet_read(struct net_device * dev, u16 buf_off, int sksize)
 #ifdef IW_WIRELESS_SPY
 		wl_spy_gather(dev, skb_mac_header(skb) + WAVELAN_ADDR_SIZE,
 			      stats);
-#endif /* IW_WIRELESS_SPY */
+#endif				/* IW_WIRELESS_SPY */
 #ifdef HISTOGRAM
 		wl_his_gather(dev, stats);
-#endif /* HISTOGRAM */
+#endif				/* HISTOGRAM */
 	}
 
 	/*
@@ -2584,7 +2539,7 @@ wv_packet_read(struct net_device * dev, u16 buf_off, int sksize)
  * (called in wavelan_interrupt()).
  * Note : the spinlock is already grabbed for us.
  */
-static void wv_receive(struct net_device * dev)
+static void wv_receive(struct net_device *dev)
 {
 	unsigned long ioaddr = dev->base_addr;
 	net_local *lp = (net_local *) dev->priv;
@@ -2598,7 +2553,7 @@ static void wv_receive(struct net_device * dev)
 
 	/* Loop on each received packet. */
 	for (;;) {
-		obram_read(ioaddr, lp->rx_head, (unsigned char *) &fd,
+		obram_read(ioaddr, lp->rx_head, (unsigned char *)&fd,
 			   sizeof(fd));
 
 		/* Note about the status :
@@ -2622,26 +2577,26 @@ static void wv_receive(struct net_device * dev)
 			if (fd.fd_rbd_offset != I82586NULL) {
 				/* Read the receive buffer descriptor */
 				obram_read(ioaddr, fd.fd_rbd_offset,
-					   (unsigned char *) &rbd,
-					   sizeof(rbd));
+					   (unsigned char *)&rbd, sizeof(rbd));
 
 #ifdef DEBUG_RX_ERROR
 				if ((rbd.rbd_status & RBD_STATUS_EOF) !=
-				    RBD_STATUS_EOF) printk(KERN_INFO
-							   "%s: wv_receive(): missing EOF flag.\n",
-							   dev->name);
+				    RBD_STATUS_EOF)
+					printk(KERN_INFO
+					       "%s: wv_receive(): missing EOF flag.\n",
+					       dev->name);
 
 				if ((rbd.rbd_status & RBD_STATUS_F) !=
-				    RBD_STATUS_F) printk(KERN_INFO
-							 "%s: wv_receive(): missing F flag.\n",
-							 dev->name);
+				    RBD_STATUS_F)
+					printk(KERN_INFO
+					       "%s: wv_receive(): missing F flag.\n",
+					       dev->name);
 #endif				/* DEBUG_RX_ERROR */
 
 				/* Read the packet and transmit to Linux */
 				wv_packet_read(dev, rbd.rbd_bufl,
 					       rbd.
-					       rbd_status &
-					       RBD_STATUS_ACNT);
+					       rbd_status & RBD_STATUS_ACNT);
 			}
 #ifdef DEBUG_RX_ERROR
 			else	/* if frame has no data */
@@ -2714,17 +2669,17 @@ static void wv_receive(struct net_device * dev)
 
 		fd.fd_status = 0;
 		obram_write(ioaddr, fdoff(lp->rx_head, fd_status),
-			    (unsigned char *) &fd.fd_status,
+			    (unsigned char *)&fd.fd_status,
 			    sizeof(fd.fd_status));
 
 		fd.fd_command = FD_COMMAND_EL;
 		obram_write(ioaddr, fdoff(lp->rx_head, fd_command),
-			    (unsigned char *) &fd.fd_command,
+			    (unsigned char *)&fd.fd_command,
 			    sizeof(fd.fd_command));
 
 		fd.fd_command = 0;
 		obram_write(ioaddr, fdoff(lp->rx_last, fd_command),
-			    (unsigned char *) &fd.fd_command,
+			    (unsigned char *)&fd.fd_command,
 			    sizeof(fd.fd_command));
 
 		lp->rx_last = lp->rx_head;
@@ -2767,7 +2722,7 @@ static void wv_receive(struct net_device * dev)
  *
  * (called in wavelan_packet_xmit())
  */
-static int wv_packet_write(struct net_device * dev, void *buf, short length)
+static int wv_packet_write(struct net_device *dev, void *buf, short length)
 {
 	net_local *lp = (net_local *) dev->priv;
 	unsigned long ioaddr = dev->base_addr;
@@ -2784,8 +2739,7 @@ static int wv_packet_write(struct net_device * dev, void *buf, short length)
 	unsigned long flags;
 
 #ifdef DEBUG_TX_TRACE
-	printk(KERN_DEBUG "%s: ->wv_packet_write(%d)\n", dev->name,
-	       length);
+	printk(KERN_DEBUG "%s: ->wv_packet_write(%d)\n", dev->name, length);
 #endif
 
 	spin_lock_irqsave(&lp->spinlock, flags);
@@ -2822,7 +2776,7 @@ static int wv_packet_write(struct net_device * dev, void *buf, short length)
 	 */
 	tx.tx_h.ac_status = 0;
 	obram_write(ioaddr, toff(ac_tx_t, tx_addr, tx_h.ac_status),
-		    (unsigned char *) &tx.tx_h.ac_status,
+		    (unsigned char *)&tx.tx_h.ac_status,
 		    sizeof(tx.tx_h.ac_status));
 
 	/*
@@ -2830,11 +2784,11 @@ static int wv_packet_write(struct net_device * dev, void *buf, short length)
 	 */
 	nop.nop_h.ac_status = 0;
 	obram_write(ioaddr, toff(ac_nop_t, nop_addr, nop_h.ac_status),
-		    (unsigned char *) &nop.nop_h.ac_status,
+		    (unsigned char *)&nop.nop_h.ac_status,
 		    sizeof(nop.nop_h.ac_status));
 	nop.nop_h.ac_link = nop_addr;
 	obram_write(ioaddr, toff(ac_nop_t, nop_addr, nop_h.ac_link),
-		    (unsigned char *) &nop.nop_h.ac_link,
+		    (unsigned char *)&nop.nop_h.ac_link,
 		    sizeof(nop.nop_h.ac_link));
 
 	/*
@@ -2844,7 +2798,7 @@ static int wv_packet_write(struct net_device * dev, void *buf, short length)
 	tbd.tbd_next_bd_offset = I82586NULL;
 	tbd.tbd_bufl = buf_addr;
 	tbd.tbd_bufh = 0;
-	obram_write(ioaddr, tbd_addr, (unsigned char *) &tbd, sizeof(tbd));
+	obram_write(ioaddr, tbd_addr, (unsigned char *)&tbd, sizeof(tbd));
 
 	/*
 	 * Data
@@ -2858,11 +2812,11 @@ static int wv_packet_write(struct net_device * dev, void *buf, short length)
 	nop_addr = txpred + sizeof(tx);
 	nop.nop_h.ac_status = 0;
 	obram_write(ioaddr, toff(ac_nop_t, nop_addr, nop_h.ac_status),
-		    (unsigned char *) &nop.nop_h.ac_status,
+		    (unsigned char *)&nop.nop_h.ac_status,
 		    sizeof(nop.nop_h.ac_status));
 	nop.nop_h.ac_link = txblock;
 	obram_write(ioaddr, toff(ac_nop_t, nop_addr, nop_h.ac_link),
-		    (unsigned char *) &nop.nop_h.ac_link,
+		    (unsigned char *)&nop.nop_h.ac_link,
 		    sizeof(nop.nop_h.ac_link));
 
 	/* Make sure the watchdog will keep quiet for a while */
@@ -2878,10 +2832,9 @@ static int wv_packet_write(struct net_device * dev, void *buf, short length)
 		netif_wake_queue(dev);
 
 	spin_unlock_irqrestore(&lp->spinlock, flags);
-	
+
 #ifdef DEBUG_TX_INFO
-	wv_packet_info((u8 *) buf, length, dev->name,
-		       "wv_packet_write");
+	wv_packet_info((u8 *) buf, length, dev->name, "wv_packet_write");
 #endif				/* DEBUG_TX_INFO */
 
 #ifdef DEBUG_TX_TRACE
@@ -2898,7 +2851,7 @@ static int wv_packet_write(struct net_device * dev, void *buf, short length)
  * the packet.  We also prevent reentrance.  Then we call the function
  * to send the packet.
  */
-static int wavelan_packet_xmit(struct sk_buff *skb, struct net_device * dev)
+static int wavelan_packet_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	net_local *lp = (net_local *) dev->priv;
 	unsigned long flags;
@@ -2906,7 +2859,7 @@ static int wavelan_packet_xmit(struct sk_buff *skb, struct net_device * dev)
 
 #ifdef DEBUG_TX_TRACE
 	printk(KERN_DEBUG "%s: ->wavelan_packet_xmit(0x%X)\n", dev->name,
-	       (unsigned) skb);
+	       (unsigned)skb);
 #endif
 
 	/*
@@ -2940,13 +2893,11 @@ static int wavelan_packet_xmit(struct sk_buff *skb, struct net_device * dev)
 		memset(data, 0, ETH_ZLEN);
 		skb_copy_from_linear_data(skb, data, skb->len);
 		/* Write packet on the card */
-		if(wv_packet_write(dev, data, ETH_ZLEN))
+		if (wv_packet_write(dev, data, ETH_ZLEN))
 			return 1;	/* We failed */
-	}
-	else if(wv_packet_write(dev, skb->data, skb->len))
+	} else if (wv_packet_write(dev, skb->data, skb->len))
 		return 1;	/* We failed */
 
-
 	dev_kfree_skb(skb);
 
 #ifdef DEBUG_TX_TRACE
@@ -2965,7 +2916,7 @@ static int wavelan_packet_xmit(struct sk_buff *skb, struct net_device * dev)
  * Routine to initialize the Modem Management Controller.
  * (called by wv_hw_reset())
  */
-static int wv_mmc_init(struct net_device * dev)
+static int wv_mmc_init(struct net_device *dev)
 {
 	unsigned long ioaddr = dev->base_addr;
 	net_local *lp = (net_local *) dev->priv;
@@ -2978,7 +2929,7 @@ static int wv_mmc_init(struct net_device * dev)
 #endif
 
 	/* Read the parameter storage area. */
-	psa_read(ioaddr, lp->hacr, 0, (unsigned char *) &psa, sizeof(psa));
+	psa_read(ioaddr, lp->hacr, 0, (unsigned char *)&psa, sizeof(psa));
 
 #ifdef USE_PSA_CONFIG
 	configured = psa.psa_conf_status & 1;
@@ -3015,17 +2966,17 @@ static int wv_mmc_init(struct net_device * dev)
 #ifdef USE_PSA_CONFIG
 		/* Write the psa. */
 		psa_write(ioaddr, lp->hacr,
-			  (char *) psa.psa_nwid - (char *) &psa,
-			  (unsigned char *) psa.psa_nwid, 4);
+			  (char *)psa.psa_nwid - (char *)&psa,
+			  (unsigned char *)psa.psa_nwid, 4);
 		psa_write(ioaddr, lp->hacr,
-			  (char *) &psa.psa_thr_pre_set - (char *) &psa,
-			  (unsigned char *) &psa.psa_thr_pre_set, 1);
+			  (char *)&psa.psa_thr_pre_set - (char *)&psa,
+			  (unsigned char *)&psa.psa_thr_pre_set, 1);
 		psa_write(ioaddr, lp->hacr,
-			  (char *) &psa.psa_quality_thr - (char *) &psa,
-			  (unsigned char *) &psa.psa_quality_thr, 1);
+			  (char *)&psa.psa_quality_thr - (char *)&psa,
+			  (unsigned char *)&psa.psa_quality_thr, 1);
 		psa_write(ioaddr, lp->hacr,
-			  (char *) &psa.psa_conf_status - (char *) &psa,
-			  (unsigned char *) &psa.psa_conf_status, 1);
+			  (char *)&psa.psa_conf_status - (char *)&psa,
+			  (unsigned char *)&psa.psa_conf_status, 1);
 		/* update the Wavelan checksum */
 		update_psa_checksum(dev, ioaddr, lp->hacr);
 #endif
@@ -3047,8 +2998,7 @@ static int wv_mmc_init(struct net_device * dev)
 	       sizeof(m.mmw_encr_key));
 
 	if (psa.psa_encryption_select)
-		m.mmw_encr_enable =
-		    MMW_ENCR_ENABLE_EN | MMW_ENCR_ENABLE_MODE;
+		m.mmw_encr_enable = MMW_ENCR_ENABLE_EN | MMW_ENCR_ENABLE_MODE;
 	else
 		m.mmw_encr_enable = 0;
 
@@ -3095,16 +3045,16 @@ static int wv_mmc_init(struct net_device * dev)
 		 * if the area... */
 		m.mmw_fee_addr = 0x0F;
 		m.mmw_fee_ctrl = MMW_FEE_CTRL_READ | MMW_FEE_CTRL_DWLD;
-		mmc_write(ioaddr, (char *) &m.mmw_fee_ctrl - (char *) &m,
-			  (unsigned char *) &m.mmw_fee_ctrl, 2);
+		mmc_write(ioaddr, (char *)&m.mmw_fee_ctrl - (char *)&m,
+			  (unsigned char *)&m.mmw_fee_ctrl, 2);
 
 		/* Wait until the download is finished. */
 		fee_wait(ioaddr, 100, 100);
 
 #ifdef DEBUG_CONFIG_INFO
 		/* The frequency was in the last word downloaded. */
-		mmc_read(ioaddr, (char *) &m.mmw_fee_data_l - (char *) &m,
-			 (unsigned char *) &m.mmw_fee_data_l, 2);
+		mmc_read(ioaddr, (char *)&m.mmw_fee_data_l - (char *)&m,
+			 (unsigned char *)&m.mmw_fee_data_l, 2);
 
 		/* Print some info for the user. */
 		printk(KERN_DEBUG
@@ -3119,8 +3069,8 @@ static int wv_mmc_init(struct net_device * dev)
 		 * the synthesizers (from the EEPROM - area 7 - DAC). */
 		m.mmw_fee_addr = 0x61;
 		m.mmw_fee_ctrl = MMW_FEE_CTRL_READ | MMW_FEE_CTRL_DWLD;
-		mmc_write(ioaddr, (char *) &m.mmw_fee_ctrl - (char *) &m,
-			  (unsigned char *) &m.mmw_fee_ctrl, 2);
+		mmc_write(ioaddr, (char *)&m.mmw_fee_ctrl - (char *)&m,
+			  (unsigned char *)&m.mmw_fee_ctrl, 2);
 
 		/* Wait until the download is finished. */
 	}
@@ -3137,7 +3087,7 @@ static int wv_mmc_init(struct net_device * dev)
  * Start the receive unit.
  * (called by wv_hw_reset())
  */
-static int wv_ru_start(struct net_device * dev)
+static int wv_ru_start(struct net_device *dev)
 {
 	net_local *lp = (net_local *) dev->priv;
 	unsigned long ioaddr = dev->base_addr;
@@ -3153,21 +3103,20 @@ static int wv_ru_start(struct net_device * dev)
 #endif
 
 	obram_read(ioaddr, scboff(OFFSET_SCB, scb_status),
-		   (unsigned char *) &scb_cs, sizeof(scb_cs));
+		   (unsigned char *)&scb_cs, sizeof(scb_cs));
 	if ((scb_cs & SCB_ST_RUS) == SCB_ST_RUS_RDY)
 		return 0;
 
 	lp->rx_head = OFFSET_RU;
 
 	for (i = 0, rx = lp->rx_head; i < NRXBLOCKS; i++, rx = rx_next) {
-		rx_next =
-		    (i == NRXBLOCKS - 1) ? lp->rx_head : rx + RXBLOCKZ;
+		rx_next = (i == NRXBLOCKS - 1) ? lp->rx_head : rx + RXBLOCKZ;
 
 		fd.fd_status = 0;
 		fd.fd_command = (i == NRXBLOCKS - 1) ? FD_COMMAND_EL : 0;
 		fd.fd_link_offset = rx_next;
 		fd.fd_rbd_offset = rx + sizeof(fd);
-		obram_write(ioaddr, rx, (unsigned char *) &fd, sizeof(fd));
+		obram_write(ioaddr, rx, (unsigned char *)&fd, sizeof(fd));
 
 		rbd.rbd_status = 0;
 		rbd.rbd_next_rbd_offset = I82586NULL;
@@ -3175,23 +3124,23 @@ static int wv_ru_start(struct net_device * dev)
 		rbd.rbd_bufh = 0;
 		rbd.rbd_el_size = RBD_EL | (RBD_SIZE & MAXDATAZ);
 		obram_write(ioaddr, rx + sizeof(fd),
-			    (unsigned char *) &rbd, sizeof(rbd));
+			    (unsigned char *)&rbd, sizeof(rbd));
 
 		lp->rx_last = rx;
 	}
 
 	obram_write(ioaddr, scboff(OFFSET_SCB, scb_rfa_offset),
-		    (unsigned char *) &lp->rx_head, sizeof(lp->rx_head));
+		    (unsigned char *)&lp->rx_head, sizeof(lp->rx_head));
 
 	scb_cs = SCB_CMD_RUC_GO;
 	obram_write(ioaddr, scboff(OFFSET_SCB, scb_command),
-		    (unsigned char *) &scb_cs, sizeof(scb_cs));
+		    (unsigned char *)&scb_cs, sizeof(scb_cs));
 
 	set_chan_attn(ioaddr, lp->hacr);
 
 	for (i = 1000; i > 0; i--) {
 		obram_read(ioaddr, scboff(OFFSET_SCB, scb_command),
-			   (unsigned char *) &scb_cs, sizeof(scb_cs));
+			   (unsigned char *)&scb_cs, sizeof(scb_cs));
 		if (scb_cs == 0)
 			break;
 
@@ -3229,7 +3178,7 @@ static int wv_ru_start(struct net_device * dev)
  *
  * (called by wv_hw_reset())
  */
-static int wv_cu_start(struct net_device * dev)
+static int wv_cu_start(struct net_device *dev)
 {
 	net_local *lp = (net_local *) dev->priv;
 	unsigned long ioaddr = dev->base_addr;
@@ -3264,37 +3213,35 @@ static int wv_cu_start(struct net_device * dev)
 		tx.tx_h.ac_command = acmd_transmit | AC_CFLD_I;
 		tx.tx_h.ac_link = nop_addr;
 		tx.tx_tbd_offset = tbd_addr;
-		obram_write(ioaddr, tx_addr, (unsigned char *) &tx,
-			    sizeof(tx));
+		obram_write(ioaddr, tx_addr, (unsigned char *)&tx, sizeof(tx));
 
 		nop.nop_h.ac_status = 0;
 		nop.nop_h.ac_command = acmd_nop;
 		nop.nop_h.ac_link = nop_addr;
-		obram_write(ioaddr, nop_addr, (unsigned char *) &nop,
+		obram_write(ioaddr, nop_addr, (unsigned char *)&nop,
 			    sizeof(nop));
 
 		tbd.tbd_status = TBD_STATUS_EOF;
 		tbd.tbd_next_bd_offset = I82586NULL;
 		tbd.tbd_bufl = buf_addr;
 		tbd.tbd_bufh = 0;
-		obram_write(ioaddr, tbd_addr, (unsigned char *) &tbd,
+		obram_write(ioaddr, tbd_addr, (unsigned char *)&tbd,
 			    sizeof(tbd));
 	}
 
-	first_nop =
-	    OFFSET_CU + (NTXBLOCKS - 1) * TXBLOCKZ + sizeof(ac_tx_t);
+	first_nop = OFFSET_CU + (NTXBLOCKS - 1) * TXBLOCKZ + sizeof(ac_tx_t);
 	obram_write(ioaddr, scboff(OFFSET_SCB, scb_cbl_offset),
-		    (unsigned char *) &first_nop, sizeof(first_nop));
+		    (unsigned char *)&first_nop, sizeof(first_nop));
 
 	scb_cs = SCB_CMD_CUC_GO;
 	obram_write(ioaddr, scboff(OFFSET_SCB, scb_command),
-		    (unsigned char *) &scb_cs, sizeof(scb_cs));
+		    (unsigned char *)&scb_cs, sizeof(scb_cs));
 
 	set_chan_attn(ioaddr, lp->hacr);
 
 	for (i = 1000; i > 0; i--) {
 		obram_read(ioaddr, scboff(OFFSET_SCB, scb_command),
-			   (unsigned char *) &scb_cs, sizeof(scb_cs));
+			   (unsigned char *)&scb_cs, sizeof(scb_cs));
 		if (scb_cs == 0)
 			break;
 
@@ -3330,7 +3277,7 @@ static int wv_cu_start(struct net_device * dev)
  *
  * (called by wv_hw_reset())
  */
-static int wv_82586_start(struct net_device * dev)
+static int wv_82586_start(struct net_device *dev)
 {
 	net_local *lp = (net_local *) dev->priv;
 	unsigned long ioaddr = dev->base_addr;
@@ -3359,31 +3306,28 @@ static int wv_82586_start(struct net_device * dev)
 	memset(&scp, 0x00, sizeof(scp));
 	scp.scp_sysbus = SCP_SY_16BBUS;
 	scp.scp_iscpl = OFFSET_ISCP;
-	obram_write(ioaddr, OFFSET_SCP, (unsigned char *) &scp,
-		    sizeof(scp));
+	obram_write(ioaddr, OFFSET_SCP, (unsigned char *)&scp, sizeof(scp));
 
 	memset(&iscp, 0x00, sizeof(iscp));
 	iscp.iscp_busy = 1;
 	iscp.iscp_offset = OFFSET_SCB;
-	obram_write(ioaddr, OFFSET_ISCP, (unsigned char *) &iscp,
-		    sizeof(iscp));
+	obram_write(ioaddr, OFFSET_ISCP, (unsigned char *)&iscp, sizeof(iscp));
 
 	/* Our first command is to reset the i82586. */
 	memset(&scb, 0x00, sizeof(scb));
 	scb.scb_command = SCB_CMD_RESET;
 	scb.scb_cbl_offset = OFFSET_CU;
 	scb.scb_rfa_offset = OFFSET_RU;
-	obram_write(ioaddr, OFFSET_SCB, (unsigned char *) &scb,
-		    sizeof(scb));
+	obram_write(ioaddr, OFFSET_SCB, (unsigned char *)&scb, sizeof(scb));
 
 	set_chan_attn(ioaddr, lp->hacr);
 
 	/* Wait for command to finish. */
 	for (i = 1000; i > 0; i--) {
-		obram_read(ioaddr, OFFSET_ISCP, (unsigned char *) &iscp,
+		obram_read(ioaddr, OFFSET_ISCP, (unsigned char *)&iscp,
 			   sizeof(iscp));
 
-		if (iscp.iscp_busy == (unsigned short) 0)
+		if (iscp.iscp_busy == (unsigned short)0)
 			break;
 
 		udelay(10);
@@ -3392,15 +3336,14 @@ static int wv_82586_start(struct net_device * dev)
 	if (i <= 0) {
 #ifdef DEBUG_CONFIG_ERROR
 		printk(KERN_INFO
-		       "%s: wv_82586_start(): iscp_busy timeout.\n",
-		       dev->name);
+		       "%s: wv_82586_start(): iscp_busy timeout.\n", dev->name);
 #endif
 		return -1;
 	}
 
 	/* Check command completion. */
 	for (i = 15; i > 0; i--) {
-		obram_read(ioaddr, OFFSET_SCB, (unsigned char *) &scb,
+		obram_read(ioaddr, OFFSET_SCB, (unsigned char *)&scb,
 			   sizeof(scb));
 
 		if (scb.scb_status == (SCB_ST_CX | SCB_ST_CNA))
@@ -3424,12 +3367,12 @@ static int wv_82586_start(struct net_device * dev)
 	memset(&cb, 0x00, sizeof(cb));
 	cb.ac_command = AC_CFLD_EL | (AC_CFLD_CMD & acmd_diagnose);
 	cb.ac_link = OFFSET_CU;
-	obram_write(ioaddr, OFFSET_CU, (unsigned char *) &cb, sizeof(cb));
+	obram_write(ioaddr, OFFSET_CU, (unsigned char *)&cb, sizeof(cb));
 
 	if (wv_synchronous_cmd(dev, "diag()") == -1)
 		return -1;
 
-	obram_read(ioaddr, OFFSET_CU, (unsigned char *) &cb, sizeof(cb));
+	obram_read(ioaddr, OFFSET_CU, (unsigned char *)&cb, sizeof(cb));
 	if (cb.ac_status & AC_SFLD_FAIL) {
 #ifdef DEBUG_CONFIG_ERROR
 		printk(KERN_INFO
@@ -3462,7 +3405,7 @@ static int wv_82586_start(struct net_device * dev)
  *
  * (called by wv_hw_reset(), wv_82586_reconfig(), wavelan_packet_xmit())
  */
-static void wv_82586_config(struct net_device * dev)
+static void wv_82586_config(struct net_device *dev)
 {
 	net_local *lp = (net_local *) dev->priv;
 	unsigned long ioaddr = dev->base_addr;
@@ -3518,7 +3461,7 @@ static void wv_82586_config(struct net_device * dev)
 	 */
 	tx.tx_h.ac_status = 0xFFFF;	/* Fake completion value */
 	obram_write(ioaddr, toff(ac_tx_t, tx_addr, tx_h.ac_status),
-		    (unsigned char *) &tx.tx_h.ac_status,
+		    (unsigned char *)&tx.tx_h.ac_status,
 		    sizeof(tx.tx_h.ac_status));
 
 	/*
@@ -3526,11 +3469,11 @@ static void wv_82586_config(struct net_device * dev)
 	 */
 	nop.nop_h.ac_status = 0;
 	obram_write(ioaddr, toff(ac_nop_t, nop_addr, nop_h.ac_status),
-		    (unsigned char *) &nop.nop_h.ac_status,
+		    (unsigned char *)&nop.nop_h.ac_status,
 		    sizeof(nop.nop_h.ac_status));
 	nop.nop_h.ac_link = nop_addr;
 	obram_write(ioaddr, toff(ac_nop_t, nop_addr, nop_h.ac_link),
-		    (unsigned char *) &nop.nop_h.ac_link,
+		    (unsigned char *)&nop.nop_h.ac_link,
 		    sizeof(nop.nop_h.ac_link));
 
 	/* Create a configure action. */
@@ -3543,16 +3486,14 @@ static void wv_82586_config(struct net_device * dev)
 	 *
 	 * Updated from Wavelan Manual WCIN085B
 	 */
-	cfg.cfg_byte_cnt =
-	    AC_CFG_BYTE_CNT(sizeof(ac_cfg_t) - sizeof(ach_t));
+	cfg.cfg_byte_cnt = AC_CFG_BYTE_CNT(sizeof(ac_cfg_t) - sizeof(ach_t));
 	cfg.cfg_fifolim = AC_CFG_FIFOLIM(4);
 	cfg.cfg_byte8 = AC_CFG_SAV_BF(1) | AC_CFG_SRDY(0);
 	cfg.cfg_byte9 = AC_CFG_ELPBCK(0) |
 	    AC_CFG_ILPBCK(0) |
 	    AC_CFG_PRELEN(AC_CFG_PLEN_2) |
 	    AC_CFG_ALOC(1) | AC_CFG_ADDRLEN(WAVELAN_ADDR_SIZE);
-	cfg.cfg_byte10 = AC_CFG_BOFMET(1) |
-	    AC_CFG_ACR(6) | AC_CFG_LINPRIO(0);
+	cfg.cfg_byte10 = AC_CFG_BOFMET(1) | AC_CFG_ACR(6) | AC_CFG_LINPRIO(0);
 	cfg.cfg_ifs = 0x20;
 	cfg.cfg_slotl = 0x0C;
 	cfg.cfg_byte13 = AC_CFG_RETRYNUM(15) | AC_CFG_SLTTMHI(0);
@@ -3561,8 +3502,7 @@ static void wv_82586_config(struct net_device * dev)
 	    AC_CFG_CRC16(0) |
 	    AC_CFG_NCRC(0) |
 	    AC_CFG_TNCRS(1) |
-	    AC_CFG_MANCH(0) |
-	    AC_CFG_BCDIS(0) | AC_CFG_PRM(lp->promiscuous);
+	    AC_CFG_MANCH(0) | AC_CFG_BCDIS(0) | AC_CFG_PRM(lp->promiscuous);
 	cfg.cfg_byte15 = AC_CFG_ICDS(0) |
 	    AC_CFG_CDTF(0) | AC_CFG_ICSS(0) | AC_CFG_CSTF(0);
 /*
@@ -3572,22 +3512,22 @@ static void wv_82586_config(struct net_device * dev)
 
 	cfg.cfg_h.ac_command = (AC_CFLD_CMD & acmd_configure);
 	cfg.cfg_h.ac_link = ias_addr;
-	obram_write(ioaddr, cfg_addr, (unsigned char *) &cfg, sizeof(cfg));
+	obram_write(ioaddr, cfg_addr, (unsigned char *)&cfg, sizeof(cfg));
 
 	/* Set up the MAC address */
 	memset(&ias, 0x00, sizeof(ias));
 	ias.ias_h.ac_command = (AC_CFLD_CMD & acmd_ia_setup);
 	ias.ias_h.ac_link = mcs_addr;
-	memcpy(&ias.ias_addr[0], (unsigned char *) &dev->dev_addr[0],
+	memcpy(&ias.ias_addr[0], (unsigned char *)&dev->dev_addr[0],
 	       sizeof(ias.ias_addr));
-	obram_write(ioaddr, ias_addr, (unsigned char *) &ias, sizeof(ias));
+	obram_write(ioaddr, ias_addr, (unsigned char *)&ias, sizeof(ias));
 
 	/* Initialize adapter's Ethernet multicast addresses */
 	memset(&mcs, 0x00, sizeof(mcs));
 	mcs.mcs_h.ac_command = AC_CFLD_I | (AC_CFLD_CMD & acmd_mc_setup);
 	mcs.mcs_h.ac_link = nop_addr;
 	mcs.mcs_cnt = WAVELAN_ADDR_SIZE * lp->mc_count;
-	obram_write(ioaddr, mcs_addr, (unsigned char *) &mcs, sizeof(mcs));
+	obram_write(ioaddr, mcs_addr, (unsigned char *)&mcs, sizeof(mcs));
 
 	/* Any address to set? */
 	if (lp->mc_count) {
@@ -3615,11 +3555,11 @@ static void wv_82586_config(struct net_device * dev)
 	nop_addr = txpred + sizeof(tx);
 	nop.nop_h.ac_status = 0;
 	obram_write(ioaddr, toff(ac_nop_t, nop_addr, nop_h.ac_status),
-		    (unsigned char *) &nop.nop_h.ac_status,
+		    (unsigned char *)&nop.nop_h.ac_status,
 		    sizeof(nop.nop_h.ac_status));
 	nop.nop_h.ac_link = cfg_addr;
 	obram_write(ioaddr, toff(ac_nop_t, nop_addr, nop_h.ac_link),
-		    (unsigned char *) &nop.nop_h.ac_link,
+		    (unsigned char *)&nop.nop_h.ac_link,
 		    sizeof(nop.nop_h.ac_link));
 
 	/* Job done, clear the flag */
@@ -3642,7 +3582,7 @@ static void wv_82586_config(struct net_device * dev)
  * WaveLAN controller (i82586).
  * (called by wavelan_close())
  */
-static void wv_82586_stop(struct net_device * dev)
+static void wv_82586_stop(struct net_device *dev)
 {
 	net_local *lp = (net_local *) dev->priv;
 	unsigned long ioaddr = dev->base_addr;
@@ -3654,10 +3594,9 @@ static void wv_82586_stop(struct net_device * dev)
 
 	/* Suspend both command unit and receive unit. */
 	scb_cmd =
-	    (SCB_CMD_CUC & SCB_CMD_CUC_SUS) | (SCB_CMD_RUC &
-					       SCB_CMD_RUC_SUS);
+	    (SCB_CMD_CUC & SCB_CMD_CUC_SUS) | (SCB_CMD_RUC & SCB_CMD_RUC_SUS);
 	obram_write(ioaddr, scboff(OFFSET_SCB, scb_command),
-		    (unsigned char *) &scb_cmd, sizeof(scb_cmd));
+		    (unsigned char *)&scb_cmd, sizeof(scb_cmd));
 	set_chan_attn(ioaddr, lp->hacr);
 
 	/* No more interrupts */
@@ -3679,14 +3618,14 @@ static void wv_82586_stop(struct net_device * dev)
  *	5. Start the LAN controller's receive unit
  * (called by wavelan_interrupt(), wavelan_watchdog() & wavelan_open())
  */
-static int wv_hw_reset(struct net_device * dev)
+static int wv_hw_reset(struct net_device *dev)
 {
 	net_local *lp = (net_local *) dev->priv;
 	unsigned long ioaddr = dev->base_addr;
 
 #ifdef DEBUG_CONFIG_TRACE
 	printk(KERN_DEBUG "%s: ->wv_hw_reset(dev=0x%x)\n", dev->name,
-	       (unsigned int) dev);
+	       (unsigned int)dev);
 #endif
 
 	/* Increase the number of resets done. */
@@ -3730,14 +3669,13 @@ static int wv_check_ioaddr(unsigned long ioaddr, u8 * mac)
 
 	/* Check if the base address if available. */
 	if (!request_region(ioaddr, sizeof(ha_t), "wavelan probe"))
-		return -EBUSY;		/* ioaddr already used */
+		return -EBUSY;	/* ioaddr already used */
 
 	/* Reset host interface */
 	wv_hacr_reset(ioaddr);
 
 	/* Read the MAC address from the parameter storage area. */
-	psa_read(ioaddr, HACR_DEFAULT, psaoff(0, psa_univ_mac_addr),
-		 mac, 6);
+	psa_read(ioaddr, HACR_DEFAULT, psaoff(0, psa_univ_mac_addr), mac, 6);
 
 	release_region(ioaddr, sizeof(ha_t));
 
@@ -3787,7 +3725,7 @@ static irqreturn_t wavelan_interrupt(int irq, void *dev_id)
 
 #ifdef DEBUG_INTERRUPT_INFO
 	/* Check state of our spinlock */
-	if(spin_is_locked(&lp->spinlock))
+	if (spin_is_locked(&lp->spinlock))
 		printk(KERN_DEBUG
 		       "%s: wavelan_interrupt(): spinlock is already locked !!!\n",
 		       dev->name);
@@ -3843,20 +3781,20 @@ static irqreturn_t wavelan_interrupt(int irq, void *dev_id)
 		       "%s: wavelan_interrupt(): interrupt not coming from i82586 - hasr 0x%04x.\n",
 		       dev->name, hasr);
 #endif
-		spin_unlock (&lp->spinlock);
+		spin_unlock(&lp->spinlock);
 		return IRQ_NONE;
 	}
 
 	/* Read interrupt data. */
 	obram_read(ioaddr, scboff(OFFSET_SCB, scb_status),
-		   (unsigned char *) &status, sizeof(status));
+		   (unsigned char *)&status, sizeof(status));
 
 	/*
 	 * Acknowledge the interrupt(s).
 	 */
 	ack_cmd = status & SCB_ST_INT;
 	obram_write(ioaddr, scboff(OFFSET_SCB, scb_command),
-		    (unsigned char *) &ack_cmd, sizeof(ack_cmd));
+		    (unsigned char *)&ack_cmd, sizeof(ack_cmd));
 	set_chan_attn(ioaddr, lp->hacr);
 
 #ifdef DEBUG_INTERRUPT_INFO
@@ -3909,7 +3847,7 @@ static irqreturn_t wavelan_interrupt(int irq, void *dev_id)
 	}
 
 	/* Release spinlock */
-	spin_unlock (&lp->spinlock);
+	spin_unlock(&lp->spinlock);
 
 #ifdef DEBUG_INTERRUPT_TRACE
 	printk(KERN_DEBUG "%s: <-wavelan_interrupt()\n", dev->name);
@@ -3923,12 +3861,12 @@ static irqreturn_t wavelan_interrupt(int irq, void *dev_id)
  * kernel.  If the transmission completes, this timer is disabled. If
  * the timer expires, we are called and we try to unlock the hardware.
  */
-static void wavelan_watchdog(struct net_device *	dev)
+static void wavelan_watchdog(struct net_device *dev)
 {
-	net_local *	lp = (net_local *)dev->priv;
-	u_long		ioaddr = dev->base_addr;
-	unsigned long	flags;
-	unsigned int	nreaped;
+	net_local *lp = (net_local *) dev->priv;
+	u_long ioaddr = dev->base_addr;
+	unsigned long flags;
+	unsigned int nreaped;
 
 #ifdef DEBUG_INTERRUPT_TRACE
 	printk(KERN_DEBUG "%s: ->wavelan_watchdog()\n", dev->name);
@@ -3959,7 +3897,7 @@ static void wavelan_watchdog(struct net_device *	dev)
 #ifdef DEBUG_PSA_SHOW
 	{
 		psa_t psa;
-		psa_read(dev, 0, (unsigned char *) &psa, sizeof(psa));
+		psa_read(dev, 0, (unsigned char *)&psa, sizeof(psa));
 		wv_psa_show(&psa);
 	}
 #endif
@@ -3985,7 +3923,7 @@ static void wavelan_watchdog(struct net_device *	dev)
 		netif_wake_queue(dev);
 
 	spin_unlock_irqrestore(&lp->spinlock, flags);
-	
+
 #ifdef DEBUG_INTERRUPT_TRACE
 	printk(KERN_DEBUG "%s: <-wavelan_watchdog()\n", dev->name);
 #endif
@@ -4003,27 +3941,25 @@ static void wavelan_watchdog(struct net_device *	dev)
  * Configure and start up the WaveLAN PCMCIA adaptor.
  * Called by NET3 when it "opens" the device.
  */
-static int wavelan_open(struct net_device * dev)
+static int wavelan_open(struct net_device *dev)
 {
-	net_local *	lp = (net_local *)dev->priv;
-	unsigned long	flags;
+	net_local *lp = (net_local *) dev->priv;
+	unsigned long flags;
 
 #ifdef DEBUG_CALLBACK_TRACE
 	printk(KERN_DEBUG "%s: ->wavelan_open(dev=0x%x)\n", dev->name,
-	       (unsigned int) dev);
+	       (unsigned int)dev);
 #endif
 
 	/* Check irq */
 	if (dev->irq == 0) {
 #ifdef DEBUG_CONFIG_ERROR
-		printk(KERN_WARNING "%s: wavelan_open(): no IRQ\n",
-		       dev->name);
+		printk(KERN_WARNING "%s: wavelan_open(): no IRQ\n", dev->name);
 #endif
 		return -ENXIO;
 	}
 
-	if (request_irq(dev->irq, &wavelan_interrupt, 0, "WaveLAN", dev) != 0) 
-	{
+	if (request_irq(dev->irq, &wavelan_interrupt, 0, "WaveLAN", dev) != 0) {
 #ifdef DEBUG_CONFIG_ERROR
 		printk(KERN_WARNING "%s: wavelan_open(): invalid IRQ\n",
 		       dev->name);
@@ -4032,7 +3968,7 @@ static int wavelan_open(struct net_device * dev)
 	}
 
 	spin_lock_irqsave(&lp->spinlock, flags);
-	
+
 	if (wv_hw_reset(dev) != -1) {
 		netif_start_queue(dev);
 	} else {
@@ -4046,7 +3982,7 @@ static int wavelan_open(struct net_device * dev)
 		return -EAGAIN;
 	}
 	spin_unlock_irqrestore(&lp->spinlock, flags);
-	
+
 #ifdef DEBUG_CALLBACK_TRACE
 	printk(KERN_DEBUG "%s: <-wavelan_open()\n", dev->name);
 #endif
@@ -4058,14 +3994,14 @@ static int wavelan_open(struct net_device * dev)
  * Shut down the WaveLAN ISA card.
  * Called by NET3 when it "closes" the device.
  */
-static int wavelan_close(struct net_device * dev)
+static int wavelan_close(struct net_device *dev)
 {
 	net_local *lp = (net_local *) dev->priv;
 	unsigned long flags;
 
 #ifdef DEBUG_CALLBACK_TRACE
 	printk(KERN_DEBUG "%s: ->wavelan_close(dev=0x%x)\n", dev->name,
-	       (unsigned int) dev);
+	       (unsigned int)dev);
 #endif
 
 	netif_stop_queue(dev);
@@ -4112,7 +4048,7 @@ static int __init wavelan_config(struct net_device *dev, unsigned short ioaddr)
 
 #ifdef DEBUG_CALLBACK_TRACE
 	printk(KERN_DEBUG "%s: ->wavelan_config(dev=0x%x, ioaddr=0x%lx)\n",
-	       dev->name, (unsigned int) dev, ioaddr);
+	       dev->name, (unsigned int)dev, ioaddr);
 #endif
 
 	/* Check IRQ argument on command line. */
@@ -4140,8 +4076,7 @@ static int __init wavelan_config(struct net_device *dev, unsigned short ioaddr)
 		}
 	}
 
-	psa_read(ioaddr, HACR_DEFAULT, psaoff(0, psa_int_req_no),
-		 &irq_mask, 1);
+	psa_read(ioaddr, HACR_DEFAULT, psaoff(0, psa_int_req_no), &irq_mask, 1);
 	if ((irq = wv_psa_to_irq(irq_mask)) == -1) {
 #ifdef DEBUG_CONFIG_ERROR
 		printk(KERN_INFO
@@ -4183,8 +4118,8 @@ static int __init wavelan_config(struct net_device *dev, unsigned short ioaddr)
 	dev->hard_start_xmit = wavelan_packet_xmit;
 	dev->get_stats = wavelan_get_stats;
 	dev->set_multicast_list = &wavelan_set_multicast_list;
-        dev->tx_timeout		= &wavelan_watchdog;
-        dev->watchdog_timeo	= WATCHDOG_JIFFIES;
+	dev->tx_timeout = &wavelan_watchdog;
+	dev->watchdog_timeo = WATCHDOG_JIFFIES;
 #ifdef SET_MAC_ADDRESS
 	dev->set_mac_address = &wavelan_set_mac_address;
 #endif				/* SET_MAC_ADDRESS */
@@ -4202,7 +4137,7 @@ static int __init wavelan_config(struct net_device *dev, unsigned short ioaddr)
 	printk(KERN_DEBUG "%s: <-wavelan_config()\n", dev->name);
 #endif
 	return 0;
-out:
+      out:
 	release_region(ioaddr, sizeof(ha_t));
 	return err;
 }
@@ -4215,7 +4150,7 @@ out:
  * We follow the example in drivers/net/ne.c.
  * (called in "Space.c")
  */
-struct net_device * __init wavelan_probe(int unit)
+struct net_device *__init wavelan_probe(int unit)
 {
 	struct net_device *dev;
 	short base_addr;
@@ -4224,7 +4159,7 @@ struct net_device * __init wavelan_probe(int unit)
 	int r = 0;
 
 #ifdef	STRUCT_CHECK
-	if (wv_struct_check() != (char *) NULL) {
+	if (wv_struct_check() != (char *)NULL) {
 		printk(KERN_WARNING
 		       "%s: wavelan_probe(): structure/compiler botch: \"%s\"\n",
 		       dev->name, wv_struct_check());
@@ -4244,7 +4179,7 @@ struct net_device * __init wavelan_probe(int unit)
 #ifdef DEBUG_CALLBACK_TRACE
 	printk(KERN_DEBUG
 	       "%s: ->wavelan_probe(dev=%p (base_addr=0x%x))\n",
-	       dev->name, dev, (unsigned int) dev->base_addr);
+	       dev->name, dev, (unsigned int)dev->base_addr);
 #endif
 
 	/* Don't probe at all. */
@@ -4255,7 +4190,7 @@ struct net_device * __init wavelan_probe(int unit)
 		       dev->name);
 #endif
 		r = -ENXIO;
-	} else if (base_addr > 0x100) { /* Check a single specified location. */
+	} else if (base_addr > 0x100) {	/* Check a single specified location. */
 		r = wavelan_config(dev, base_addr);
 #ifdef DEBUG_CONFIG_INFO
 		if (r != 0)
@@ -4267,14 +4202,13 @@ struct net_device * __init wavelan_probe(int unit)
 #ifdef DEBUG_CALLBACK_TRACE
 		printk(KERN_DEBUG "%s: <-wavelan_probe()\n", dev->name);
 #endif
-	} else { /* Scan all possible addresses of the WaveLAN hardware. */
+	} else {		/* Scan all possible addresses of the WaveLAN hardware. */
 		for (i = 0; i < ARRAY_SIZE(iobase); i++) {
 			dev->irq = def_irq;
 			if (wavelan_config(dev, iobase[i]) == 0) {
 #ifdef DEBUG_CALLBACK_TRACE
 				printk(KERN_DEBUG
-				       "%s: <-wavelan_probe()\n",
-				       dev->name);
+				       "%s: <-wavelan_probe()\n", dev->name);
 #endif
 				break;
 			}
@@ -4282,16 +4216,16 @@ struct net_device * __init wavelan_probe(int unit)
 		if (i == ARRAY_SIZE(iobase))
 			r = -ENODEV;
 	}
-	if (r) 
+	if (r)
 		goto out;
 	r = register_netdev(dev);
 	if (r)
 		goto out1;
 	return dev;
-out1:
+      out1:
 	release_region(dev->base_addr, sizeof(ha_t));
 	wavelan_list = wavelan_list->next;
-out:
+      out:
 	free_netdev(dev);
 	return ERR_PTR(r);
 }
@@ -4330,7 +4264,6 @@ int __init init_module(void)
 			io[i] = iobase[i];
 	}
 
-
 	/* Loop on all possible base addresses. */
 	i = -1;
 	while ((io[++i] != 0) && (i < ARRAY_SIZE(io))) {
@@ -4357,8 +4290,7 @@ int __init init_module(void)
 
 #ifdef DEBUG_CONFIG_ERROR
 	if (!wavelan_list)
-		printk(KERN_WARNING
-		       "WaveLAN init_module(): no device found\n");
+		printk(KERN_WARNING "WaveLAN init_module(): no device found\n");
 #endif
 
 #ifdef DEBUG_MODULE_TRACE
@@ -4384,7 +4316,7 @@ void cleanup_module(void)
 #ifdef DEBUG_CONFIG_INFO
 		printk(KERN_DEBUG
 		       "%s: cleanup_module(): removing device at 0x%x\n",
-		       dev->name, (unsigned int) dev);
+		       dev->name, (unsigned int)dev);
 #endif
 		unregister_netdev(dev);
 
-- 
1.5.2.2

