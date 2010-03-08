Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab0CHKUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 05:20:38 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37715 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab0CHKUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 05:20:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=b2TPNITG7kRsID1O9zJDgFPA4d5+7mV85PzF0t92SjB6dlsndSJl0j6QzV195QyADF
         dbu2mlW7eovse4ZhHTdNnF9/Lg6t2tgaSEgrRyc/u4MJ2yMQsdxXUVTlbOyzJoBS/5rY
         SQ/5mC/M5ELPjYRHYfsBQeupYkHNhKWmJUk5Y=
From: Jason Dreisbach <jtdreisb@gmail.com>
To: jt@hp1.hp.com, gregkh@suse.de--to, jpirko@redhat.com,
       linville@tuxdriver.com, jtdreisb@gmail.com--cc
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       Jason <jtdreisb@gmail.com>
Subject: [PATCH] staging: wavelan: fix coding style of first 1000 lines in wavelan.c
Date: Mon,  8 Mar 2010 02:20:30 -0800
Message-Id: <1268043630-5893-1-git-send-email-jtdreisb@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason <jtdreisb@gmail.com>

---
 drivers/staging/wavelan/wavelan.c |  198 ++++++++++++++++++++-----------------
 1 files changed, 108 insertions(+), 90 deletions(-)

diff --git a/drivers/staging/wavelan/wavelan.c b/drivers/staging/wavelan/wavelan.c
index 54ca631..37ede43 100644
--- a/drivers/staging/wavelan/wavelan.c
+++ b/drivers/staging/wavelan/wavelan.c
@@ -36,7 +36,7 @@ static u8 wv_irq_to_psa(int irq)
 
 /*------------------------------------------------------------------*/
 /*
- * Translate PSA irq parameter to irq number 
+ * Translate PSA irq parameter to irq number
  */
 static int __init wv_psa_to_irq(u8 irqval)
 {
@@ -55,7 +55,7 @@ static int __init wv_psa_to_irq(u8 irqval)
  *
  * One major difference with the PCMCIA hardware (except the port mapping)
  * is that we have to keep the state of the Host Control Register
- * because of the interrupt enable & bus size flags.
+ *because of the interrupt enable & bus size flags.
  */
 
 /*------------------------------------------------------------------*/
@@ -64,7 +64,7 @@ static int __init wv_psa_to_irq(u8 irqval)
  */
 static inline u16 hasr_read(unsigned long ioaddr)
 {
-	return (inw(HASR(ioaddr)));
+	return inw(HASR(ioaddr));
 }				/* hasr_read */
 
 /*------------------------------------------------------------------*/
@@ -132,11 +132,11 @@ static inline void wv_16_on(unsigned long ioaddr, u16 hacr)
  * Disable interrupts on the WaveLAN hardware.
  * (called by wv_82586_stop())
  */
-static inline void wv_ints_off(struct net_device * dev)
+static inline void wv_ints_off(struct net_device *dev)
 {
 	net_local *lp = netdev_priv(dev);
 	unsigned long ioaddr = dev->base_addr;
-	
+
 	lp->hacr &= ~HACR_INTRON;
 	hacr_write(ioaddr, lp->hacr);
 }				/* wv_ints_off */
@@ -146,7 +146,7 @@ static inline void wv_ints_off(struct net_device * dev)
  * Enable interrupts on the WaveLAN hardware.
  * (called by wv_hw_reset())
  */
-static inline void wv_ints_on(struct net_device * dev)
+static inline void wv_ints_on(struct net_device *dev)
 {
 	net_local *lp = netdev_priv(dev);
 	unsigned long ioaddr = dev->base_addr;
@@ -167,9 +167,11 @@ static inline void wv_ints_on(struct net_device * dev)
 /*
  * Read bytes from the PSA.
  */
-static void psa_read(unsigned long ioaddr, u16 hacr, int o,	/* offset in PSA */
-		     u8 * b,	/* buffer to fill */
-		     int n)
+static void psa_read(unsigned long ioaddr,
+			u16 hacr,
+			int o,	/* offset in PSA */
+			u8 *b,	/*buffer to fill */
+			int n)
 {				/* size to read */
 	wv_16_off(ioaddr, hacr);
 
@@ -186,9 +188,11 @@ static void psa_read(unsigned long ioaddr, u16 hacr, int o,	/* offset in PSA */
 /*
  * Write the Parameter Storage Area to the WaveLAN card's memory.
  */
-static void psa_write(unsigned long ioaddr, u16 hacr, int o,	/* Offset in PSA */
-		      u8 * b,	/* Buffer in memory */
-		      int n)
+static void psa_write(unsigned long ioaddr,
+			u16 hacr,
+			int o,	/* Offset in PSA */
+			u8 *b,	/*buffer in memory */
+			int n)
 {				/* Length of buffer */
 	int count = 0;
 
@@ -203,8 +207,8 @@ static void psa_write(unsigned long ioaddr, u16 hacr, int o,	/* Offset in PSA */
 
 		/* Wait for the memory to finish its write cycle */
 		count = 0;
-		while ((count++ < 100) &&
-		       (hasr_read(ioaddr) & HASR_PSA_BUSY)) mdelay(1);
+		while ((count++ < 100) && (hasr_read(ioaddr) & HASR_PSA_BUSY))
+			mdelay(1);
 	}
 
 	wv_16_on(ioaddr, hacr);
@@ -221,8 +225,8 @@ static void psa_write(unsigned long ioaddr, u16 hacr, int o,	/* Offset in PSA */
  * The Windows drivers don't use the CRC, but the AP and the PtP tool
  * depend on it.
  */
-static u16 psa_crc(u8 * psa,	/* The PSA */
-			      int size)
+static u16 psa_crc(u8 *psa,	/* The PSA */
+			int size)
 {				/* Number of short for CRC */
 	int byte_cnt;		/* Loop on the PSA */
 	u16 crc_bytes = 0;	/* Data in the PSA */
@@ -247,7 +251,9 @@ static u16 psa_crc(u8 * psa,	/* The PSA */
 /*
  * update the checksum field in the Wavelan's PSA
  */
-static void update_psa_checksum(struct net_device * dev, unsigned long ioaddr, u16 hacr)
+static void update_psa_checksum(struct net_device *dev,
+				unsigned long ioaddr,
+				u16 hacr)
 {
 #ifdef SET_PSA_CRC
 	psa_t psa;
@@ -279,7 +285,8 @@ static void update_psa_checksum(struct net_device * dev, unsigned long ioaddr, u
 
 	if (crc != 0)
 		printk(KERN_WARNING
-		       "%s: update_psa_checksum(): CRC does not agree with PSA data (even after recalculating)\n",
+		       "%s: update_psa_checksum(): CRC does not \
+		       agree with PSA data (even after recalculating)\n",
 		       dev->name);
 #endif				/* DEBUG_IOCTL_INFO */
 #endif				/* SET_PSA_CRC */
@@ -305,7 +312,7 @@ static void mmc_out(unsigned long ioaddr, u16 o, u8 d)
  * Routine to write bytes to the Modem Management Controller.
  * We start at the end because it is the way it should be!
  */
-static void mmc_write(unsigned long ioaddr, u8 o, u8 * b, int n)
+static void mmc_write(unsigned long ioaddr, u8 o, u8 *b, int n)
 {
 	o += n;
 	b += n;
@@ -340,7 +347,7 @@ static u8 mmc_in(unsigned long ioaddr, u16 o)
  * (code has just been moved in the above function)
  * We start at the end because it is the way it should be!
  */
-static inline void mmc_read(unsigned long ioaddr, u8 o, u8 * b, int n)
+static inline void mmc_read(unsigned long ioaddr, u8 o, u8 *b, int n)
 {
 	o += n;
 	b += n;
@@ -369,15 +376,16 @@ static inline int mmc_encr(unsigned long ioaddr)
  * Wait for the frequency EEPROM to complete a command.
  * I hope this one will be optimally inlined.
  */
-static inline void fee_wait(unsigned long ioaddr,	/* I/O port of the card */
-			    int delay,	/* Base delay to wait for */
+static inline void fee_wait(unsigned long ioaddr, /* I/O port of the card */
+			    int delay,	/*base delay to wait for */
 			    int number)
 {				/* Number of time to wait */
 	int count = 0;		/* Wait only a limited time */
 
 	while ((count++ < number) &&
 	       (mmc_in(ioaddr, mmroff(0, mmr_fee_status)) &
-		MMR_FEE_STATUS_BUSY)) udelay(delay);
+		MMR_FEE_STATUS_BUSY))
+			udelay(delay);
 }
 
 /*------------------------------------------------------------------*/
@@ -386,7 +394,7 @@ static inline void fee_wait(unsigned long ioaddr,	/* I/O port of the card */
  */
 static void fee_read(unsigned long ioaddr,	/* I/O port of the card */
 		     u16 o,	/* destination offset */
-		     u16 * b,	/* data buffer */
+		     u16 *b,	/* data buffer */
 		     int n)
 {				/* number of registers */
 	b += n;			/* Position at the end of the area */
@@ -414,12 +422,12 @@ static void fee_read(unsigned long ioaddr,	/* I/O port of the card */
 /*
  * Write bytes from the Frequency EEPROM (frequency select cards).
  * This is a bit complicated, because the frequency EEPROM has to
- * be unprotected and the write enabled.
+ *be unprotected and the write enabled.
  * Jean II
  */
 static void fee_write(unsigned long ioaddr,	/* I/O port of the card */
 		      u16 o,	/* destination offset */
-		      u16 * b,	/* data buffer */
+		      u16 *b,	/* data buffer */
 		      int n)
 {				/* number of registers */
 	b += n;			/* Position at the end of the area. */
@@ -473,7 +481,9 @@ static void fee_write(unsigned long ioaddr,	/* I/O port of the card */
 		mmc_out(ioaddr, mmwoff(0, mmw_fee_ctrl),
 			MMW_FEE_CTRL_WRITE);
 
-		/* WaveLAN documentation says to wait at least 10 ms for EEBUSY = 0 */
+		/* WaveLAN documentation says to
+		* wait at least 10 ms for EEBUSY = 0
+		*/
 		mdelay(10);
 		fee_wait(ioaddr, 10, 100);
 	}
@@ -504,7 +514,7 @@ static void fee_write(unsigned long ioaddr,	/* I/O port of the card */
  * Why does inlining this function make it fail?
  */
 static /*inline */ void obram_read(unsigned long ioaddr,
-				   u16 o, u8 * b, int n)
+				   u16 o, u8 *b, int n)
 {
 	outw(o, PIOR1(ioaddr));
 	insw(PIOP1(ioaddr), (unsigned short *) b, (n + 1) >> 1);
@@ -514,7 +524,7 @@ static /*inline */ void obram_read(unsigned long ioaddr,
 /*
  * Write bytes to the on-board RAM.
  */
-static inline void obram_write(unsigned long ioaddr, u16 o, u8 * b, int n)
+static inline void obram_write(unsigned long ioaddr, u16 o, u8 *b, int n)
 {
 	outw(o, PIOR1(ioaddr));
 	outsw(PIOP1(ioaddr), (unsigned short *) b, (n + 1) >> 1);
@@ -524,7 +534,7 @@ static inline void obram_write(unsigned long ioaddr, u16 o, u8 * b, int n)
 /*
  * Acknowledge the reading of the status issued by the i82586.
  */
-static void wv_ack(struct net_device * dev)
+static void wv_ack(struct net_device *dev)
 {
 	net_local *lp = netdev_priv(dev);
 	unsigned long ioaddr = dev->base_addr;
@@ -566,7 +576,7 @@ static void wv_ack(struct net_device * dev)
  * Set channel attention bit and busy wait until command has
  * completed, then acknowledge completion of the command.
  */
-static int wv_synchronous_cmd(struct net_device * dev, const char *str)
+static int wv_synchronous_cmd(struct net_device *dev, const char *str)
 {
 	net_local *lp = netdev_priv(dev);
 	unsigned long ioaddr = dev->base_addr;
@@ -613,7 +623,7 @@ static int wv_synchronous_cmd(struct net_device * dev, const char *str)
  * Check if done, and if OK.
  */
 static int
-wv_config_complete(struct net_device * dev, unsigned long ioaddr, net_local * lp)
+wv_config_complete(struct net_device *dev, unsigned long ioaddr, net_local * lp)
 {
 	unsigned short mcs_addr;
 	unsigned short status;
@@ -641,7 +651,8 @@ wv_config_complete(struct net_device * dev, unsigned long ioaddr, net_local * lp
 		/* Check mc_config command */
 		if ((status & AC_SFLD_OK) != AC_SFLD_OK)
 			printk(KERN_INFO
-			       "%s: wv_config_complete(): set_multicast_address failed; status = 0x%x\n",
+			       "%s: wv_config_complete(): \
+			       set_multicast_address failed; status = 0x%x\n",
 			       dev->name, status);
 
 		/* check ia-config command */
@@ -650,7 +661,8 @@ wv_config_complete(struct net_device * dev, unsigned long ioaddr, net_local * lp
 			   (unsigned char *) &status, sizeof(status));
 		if ((status & AC_SFLD_OK) != AC_SFLD_OK)
 			printk(KERN_INFO
-			       "%s: wv_config_complete(): set_MAC_address failed; status = 0x%x\n",
+			       "%s: wv_config_complete(): set_MAC_address \
+				failed; status = 0x%x\n",
 			       dev->name, status);
 
 		/* Check config command. */
@@ -659,7 +671,8 @@ wv_config_complete(struct net_device * dev, unsigned long ioaddr, net_local * lp
 			   (unsigned char *) &status, sizeof(status));
 		if ((status & AC_SFLD_OK) != AC_SFLD_OK)
 			printk(KERN_INFO
-			       "%s: wv_config_complete(): configure failed; status = 0x%x\n",
+			       "%s: wv_config_complete(): configure failed; \
+			       status = 0x%x\n",
 			       dev->name, status);
 #endif	/* DEBUG_CONFIG_ERROR */
 
@@ -680,7 +693,9 @@ wv_config_complete(struct net_device * dev, unsigned long ioaddr, net_local * lp
  * (called in wavelan_interrupt()).
  * Note : the spinlock is already grabbed for us.
  */
-static int wv_complete(struct net_device * dev, unsigned long ioaddr, net_local * lp)
+static int wv_complete(struct net_device *dev,
+			unsigned long ioaddr,
+			net_local *lp)
 {
 	int nreaped = 0;
 
@@ -722,9 +737,8 @@ if (lp->tx_n_in_use > 0)
 			/* Next one in the chain */
 			lp->tx_first_in_use += TXBLOCKZ;
 			if (lp->tx_first_in_use >=
-			    OFFSET_CU +
-			    NTXBLOCKS * TXBLOCKZ) lp->tx_first_in_use -=
-				    NTXBLOCKS * TXBLOCKZ;
+				OFFSET_CU + NTXBLOCKS * TXBLOCKZ)
+				lp->tx_first_in_use -= NTXBLOCKS * TXBLOCKZ;
 		}
 
 		/* Hack for reconfiguration */
@@ -741,7 +755,8 @@ if (lp->tx_n_in_use > 0)
 #ifdef DEBUG_TX_INFO
 			if (ncollisions > 0)
 				printk(KERN_DEBUG
-				       "%s: wv_complete(): tx completed after %d collisions.\n",
+				       "%s: wv_complete(): tx completed after \
+					%d collisions.\n",
 				       dev->name, ncollisions);
 #endif
 		} else {
@@ -758,7 +773,8 @@ if (lp->tx_n_in_use > 0)
 				dev->stats.tx_carrier_errors++;
 #ifdef DEBUG_TX_FAIL
 				printk(KERN_DEBUG
-				       "%s: wv_complete(): tx error: lost CTS.\n",
+					"%s: wv_complete(): tx error: \
+					lost CTS.\n",
 				       dev->name);
 #endif
 			}
@@ -766,7 +782,8 @@ if (lp->tx_n_in_use > 0)
 				dev->stats.tx_fifo_errors++;
 #ifdef DEBUG_TX_FAIL
 				printk(KERN_DEBUG
-				       "%s: wv_complete(): tx error: slow DMA.\n",
+					"%s: wv_complete(): tx error: \
+					slow DMA.\n",
 				       dev->name);
 #endif
 			}
@@ -774,7 +791,8 @@ if (lp->tx_n_in_use > 0)
 				dev->stats.tx_heartbeat_errors++;
 #ifdef DEBUG_TX_FAIL
 				printk(KERN_DEBUG
-				       "%s: wv_complete(): tx error: heart beat.\n",
+					"%s: wv_complete(): tx error: \
+					heart beat.\n",
 				       dev->name);
 #endif
 			}
@@ -782,7 +800,8 @@ if (lp->tx_n_in_use > 0)
 				dev->stats.tx_aborted_errors++;
 #ifdef DEBUG_TX_FAIL
 				printk(KERN_DEBUG
-				       "%s: wv_complete(): tx error: too many collisions.\n",
+					"%s: wv_complete(): tx error: \
+					too many collisions.\n",
 				       dev->name);
 #endif
 			}
@@ -804,9 +823,9 @@ if (lp->tx_n_in_use > 0)
 	/*
 	 * Inform upper layers.
 	 */
-	if (lp->tx_n_in_use < NTXBLOCKS - 1) {
+	if (lp->tx_n_in_use < NTXBLOCKS - 1)
 		netif_wake_queue(dev);
-	}
+
 #ifdef DEBUG_INTERRUPT_TRACE
 	printk(KERN_DEBUG "%s: <-wv_complete()\n", dev->name);
 #endif
@@ -816,13 +835,13 @@ if (lp->tx_n_in_use > 0)
 /*------------------------------------------------------------------*/
 /*
  * Reconfigure the i82586, or at least ask for it.
- * Because wv_82586_config uses a transmission buffer, we must do it
+ *because wv_82586_config uses a transmission buffer, we must do it
  * when we are sure that there is one left, so we do it now
  * or in wavelan_packet_xmit() (I can't find any better place,
  * wavelan_interrupt is not an option), so you may experience
  * delays sometimes.
  */
-static void wv_82586_reconfig(struct net_device * dev)
+static void wv_82586_reconfig(struct net_device *dev)
 {
 	net_local *lp = netdev_priv(dev);
 	unsigned long flags;
@@ -831,13 +850,12 @@ static void wv_82586_reconfig(struct net_device * dev)
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
@@ -857,7 +875,7 @@ static void wv_82586_reconfig(struct net_device * dev)
 /*
  * Print the formatted contents of the Parameter Storage Area.
  */
-static void wv_psa_show(psa_t * p)
+static void wv_psa_show(psa_t *p)
 {
 	printk(KERN_DEBUG "##### WaveLAN PSA contents: #####\n");
 	printk(KERN_DEBUG "psa_io_base_addr_1: 0x%02X %02X %02X %02X\n",
@@ -919,13 +937,13 @@ static void wv_psa_show(psa_t * p)
  * Print the formatted status of the Modem Management Controller.
  * This function needs to be completed.
  */
-static void wv_mmc_show(struct net_device * dev)
+static void wv_mmc_show(struct net_device *dev)
 {
 	unsigned long ioaddr = dev->base_addr;
 	net_local *lp = netdev_priv(dev);
 	mmr_t m;
 
-	/* Basic check */
+	/*basic check */
 	if (hasr_read(ioaddr) & HASR_NO_CLK) {
 		printk(KERN_WARNING
 		       "%s: wv_mmc_show: modem not connected\n",
@@ -935,7 +953,7 @@ static void wv_mmc_show(struct net_device * dev)
 
 	/* Read the mmc */
 	mmc_out(ioaddr, mmwoff(0, mmw_freeze), 1);
-	mmc_read(ioaddr, 0, (u8 *) & m, sizeof(m));
+	mmc_read(ioaddr, 0, (u8 *) &m, sizeof(m));
 	mmc_out(ioaddr, mmwoff(0, mmw_freeze), 0);
 
 	/* Don't forget to update statistics */
@@ -1100,7 +1118,7 @@ static void wv_scb_show(unsigned long ioaddr)
 /*
  * Print the formatted status of the i82586's receive unit.
  */
-static void wv_ru_show(struct net_device * dev)
+static void wv_ru_show(struct net_device *dev)
 {
 	printk(KERN_DEBUG
 	       "##### WaveLAN i82586 receiver unit status: #####\n");
@@ -1115,7 +1133,7 @@ static void wv_ru_show(struct net_device * dev)
 /*
  * Display info about one control block of the i82586 memory.
  */
-static void wv_cu_show_one(struct net_device * dev, net_local * lp, int i, u16 p)
+static void wv_cu_show_one(struct net_device *dev, net_local * lp, int i, u16 p)
 {
 	unsigned long ioaddr;
 	ac_tx_t actx;
@@ -1144,7 +1162,7 @@ static void wv_cu_show_one(struct net_device * dev, net_local * lp, int i, u16 p
 /*
  * Print status of the command unit of the i82586.
  */
-static void wv_cu_show(struct net_device * dev)
+static void wv_cu_show(struct net_device *dev)
 {
 	net_local *lp = netdev_priv(dev);
 	unsigned int i;
@@ -1170,7 +1188,7 @@ static void wv_cu_show(struct net_device * dev)
 /*
  * Print the formatted status of the WaveLAN PCMCIA device driver.
  */
-static void wv_dev_show(struct net_device * dev)
+static void wv_dev_show(struct net_device *dev)
 {
 	printk(KERN_DEBUG "dev:");
 	printk(" state=%lX,", dev->state);
@@ -1184,7 +1202,7 @@ static void wv_dev_show(struct net_device * dev)
  * Print the formatted status of the WaveLAN PCMCIA device driver's
  * private information.
  */
-static void wv_local_show(struct net_device * dev)
+static void wv_local_show(struct net_device *dev)
 {
 	net_local *lp;
 
@@ -1245,7 +1263,7 @@ static inline void wv_packet_info(u8 * p,	/* Packet to dump */
  * This is the information which is displayed by the driver at startup.
  * There are lots of flags for configuring it to your liking.
  */
-static void wv_init_info(struct net_device * dev)
+static void wv_init_info(struct net_device *dev)
 {
 	short ioaddr = dev->base_addr;
 	net_local *lp = netdev_priv(dev);
@@ -1355,7 +1373,7 @@ static void wv_init_info(struct net_device * dev)
  * num_addrs > 0	Multicast mode, receive normal and MC packets,
  *			and do best-effort filtering.
  */
-static void wavelan_set_multicast_list(struct net_device * dev)
+static void wavelan_set_multicast_list(struct net_device *dev)
 {
 	net_local *lp = netdev_priv(dev);
 
@@ -1425,7 +1443,7 @@ static void wavelan_set_multicast_list(struct net_device * dev)
  * (Note : it was a nice way to test the reconfigure stuff...)
  */
 #ifdef SET_MAC_ADDRESS
-static int wavelan_set_mac_address(struct net_device * dev, void *addr)
+static int wavelan_set_mac_address(struct net_device *dev, void *addr)
 {
 	struct sockaddr *mac = addr;
 
@@ -1614,7 +1632,7 @@ static int wv_set_frequency(unsigned long ioaddr,	/* I/O port of the card */
 
 		return 0;
 	} else
-		return -EINVAL;	/* Bah, never get there... */
+		return -EINVAL;	/*bah, never get there... */
 }
 
 /*------------------------------------------------------------------*/
@@ -1663,7 +1681,7 @@ static int wv_frequency_list(unsigned long ioaddr,	/* I/O port of the card */
  * address with our list, and if they match, get the statistics.
  * Sorry, but this function really needs the wireless extensions.
  */
-static inline void wl_spy_gather(struct net_device * dev,
+static inline void wl_spy_gather(struct net_device *dev,
 				 u8 *	mac,	/* MAC address */
 				 u8 *	stats)	/* Statistics to gather */
 {
@@ -1689,7 +1707,7 @@ static inline void wl_spy_gather(struct net_device * dev,
  * With this histogram you may detect if one WaveLAN is really weak,
  * or you may also calculate the mean and standard deviation of the level.
  */
-static inline void wl_his_gather(struct net_device * dev, u8 * stats)
+static inline void wl_his_gather(struct net_device *dev, u8 * stats)
 {				/* Statistics to gather */
 	net_local *lp = netdev_priv(dev);
 	u8 level = stats[0] & MMR_SIGNAL_LVL;
@@ -1981,7 +1999,7 @@ static int wavelan_set_encode(struct net_device *dev,
 	}
 
 	if(!ret) {
-		/* Basic checking... */
+		/*basic checking... */
 		if (wrqu->encoding.length == 8) {
 			/* Copy the key in the driver */
 			memcpy(psa.psa_encryption_key, extra,
@@ -2319,7 +2337,7 @@ static const iw_handler		wavelan_handler[] =
 	NULL,				/* SIOCGIWTXPOW */
 	NULL,				/* SIOCSIWRETRY */
 	NULL,				/* SIOCGIWRETRY */
-	/* Bummer ! Why those are only at the end ??? */
+	/*bummer ! Why those are only at the end ??? */
 	wavelan_set_encode,		/* SIOCSIWENCODE */
 	wavelan_get_encode,		/* SIOCGIWENCODE */
 };
@@ -2358,7 +2376,7 @@ static const struct iw_handler_def	wavelan_handler_def =
  * Get wireless statistics.
  * Called by /proc/net/wireless
  */
-static iw_stats *wavelan_get_wireless_stats(struct net_device * dev)
+static iw_stats *wavelan_get_wireless_stats(struct net_device *dev)
 {
 	unsigned long ioaddr = dev->base_addr;
 	net_local *lp = netdev_priv(dev);
@@ -2434,7 +2452,7 @@ static iw_stats *wavelan_get_wireless_stats(struct net_device * dev)
  * (called by wv_packet_rcv())
  */
 static void
-wv_packet_read(struct net_device * dev, u16 buf_off, int sksize)
+wv_packet_read(struct net_device *dev, u16 buf_off, int sksize)
 {
 	net_local *lp = netdev_priv(dev);
 	unsigned long ioaddr = dev->base_addr;
@@ -2527,7 +2545,7 @@ wv_packet_read(struct net_device * dev, u16 buf_off, int sksize)
  * (called in wavelan_interrupt()).
  * Note : the spinlock is already grabbed for us.
  */
-static void wv_receive(struct net_device * dev)
+static void wv_receive(struct net_device *dev)
 {
 	unsigned long ioaddr = dev->base_addr;
 	net_local *lp = netdev_priv(dev);
@@ -2710,7 +2728,7 @@ static void wv_receive(struct net_device * dev)
  *
  * (called in wavelan_packet_xmit())
  */
-static int wv_packet_write(struct net_device * dev, void *buf, short length)
+static int wv_packet_write(struct net_device *dev, void *buf, short length)
 {
 	net_local *lp = netdev_priv(dev);
 	unsigned long ioaddr = dev->base_addr;
@@ -2842,7 +2860,7 @@ static int wv_packet_write(struct net_device * dev, void *buf, short length)
  * to send the packet.
  */
 static netdev_tx_t wavelan_packet_xmit(struct sk_buff *skb,
-					     struct net_device * dev)
+					     struct net_device *dev)
 {
 	net_local *lp = netdev_priv(dev);
 	unsigned long flags;
@@ -2854,7 +2872,7 @@ static netdev_tx_t wavelan_packet_xmit(struct sk_buff *skb,
 #endif
 
 	/*
-	 * Block a timer-based transmit from overlapping.
+	 *block a timer-based transmit from overlapping.
 	 * In other words, prevent reentering this routine.
 	 */
 	netif_stop_queue(dev);
@@ -2905,7 +2923,7 @@ static netdev_tx_t wavelan_packet_xmit(struct sk_buff *skb,
  * Routine to initialize the Modem Management Controller.
  * (called by wv_hw_reset())
  */
-static int wv_mmc_init(struct net_device * dev)
+static int wv_mmc_init(struct net_device *dev)
 {
 	unsigned long ioaddr = dev->base_addr;
 	net_local *lp = netdev_priv(dev);
@@ -3077,7 +3095,7 @@ static int wv_mmc_init(struct net_device * dev)
  * Start the receive unit.
  * (called by wv_hw_reset())
  */
-static int wv_ru_start(struct net_device * dev)
+static int wv_ru_start(struct net_device *dev)
 {
 	net_local *lp = netdev_priv(dev);
 	unsigned long ioaddr = dev->base_addr;
@@ -3159,8 +3177,8 @@ static int wv_ru_start(struct net_device * dev)
  * self-loop of the first transmit block.
  *
  * Here we create the list of send buffers used to transmit packets
- * between the PC and the command unit. For each buffer, we create a
- * buffer descriptor (pointing on the buffer), a transmit command
+ *between the PC and the command unit. For each buffer, we create a
+ *buffer descriptor (pointing on the buffer), a transmit command
  * (pointing to the buffer descriptor) and a NOP command.
  * The transmit command is linked to the NOP, and the NOP to itself.
  * When we will have finished executing the transmit command, we will
@@ -3169,7 +3187,7 @@ static int wv_ru_start(struct net_device * dev)
  *
  * (called by wv_hw_reset())
  */
-static int wv_cu_start(struct net_device * dev)
+static int wv_cu_start(struct net_device *dev)
 {
 	net_local *lp = netdev_priv(dev);
 	unsigned long ioaddr = dev->base_addr;
@@ -3270,7 +3288,7 @@ static int wv_cu_start(struct net_device * dev)
  *
  * (called by wv_hw_reset())
  */
-static int wv_82586_start(struct net_device * dev)
+static int wv_82586_start(struct net_device *dev)
 {
 	net_local *lp = netdev_priv(dev);
 	unsigned long ioaddr = dev->base_addr;
@@ -3402,7 +3420,7 @@ static int wv_82586_start(struct net_device * dev)
  *
  * (called by wv_hw_reset(), wv_82586_reconfig(), wavelan_packet_xmit())
  */
-static void wv_82586_config(struct net_device * dev)
+static void wv_82586_config(struct net_device *dev)
 {
 	net_local *lp = netdev_priv(dev);
 	unsigned long ioaddr = dev->base_addr;
@@ -3449,7 +3467,7 @@ static void wv_82586_config(struct net_device * dev)
 	tx_addr = txblock;
 	nop_addr = tx_addr + sizeof(tx);
 	tbd_addr = nop_addr + sizeof(nop);
-	cfg_addr = tbd_addr + sizeof(tbd_t);	/* beginning of the buffer */
+	cfg_addr = tbd_addr + sizeof(tbd_t);	/*beginning of the buffer */
 	ias_addr = cfg_addr + sizeof(cfg);
 	mcs_addr = ias_addr + sizeof(ias);
 
@@ -3578,7 +3596,7 @@ static void wv_82586_config(struct net_device * dev)
  * WaveLAN controller (i82586).
  * (called by wavelan_close())
  */
-static void wv_82586_stop(struct net_device * dev)
+static void wv_82586_stop(struct net_device *dev)
 {
 	net_local *lp = netdev_priv(dev);
 	unsigned long ioaddr = dev->base_addr;
@@ -3615,7 +3633,7 @@ static void wv_82586_stop(struct net_device * dev)
  *	5. Start the LAN controller's receive unit
  * (called by wavelan_interrupt(), wavelan_watchdog() & wavelan_open())
  */
-static int wv_hw_reset(struct net_device * dev)
+static int wv_hw_reset(struct net_device *dev)
 {
 	net_local *lp = netdev_priv(dev);
 	unsigned long ioaddr = dev->base_addr;
@@ -3939,7 +3957,7 @@ static void wavelan_watchdog(struct net_device *	dev)
  * Configure and start up the WaveLAN PCMCIA adaptor.
  * Called by NET3 when it "opens" the device.
  */
-static int wavelan_open(struct net_device * dev)
+static int wavelan_open(struct net_device *dev)
 {
 	net_local *lp = netdev_priv(dev);
 	unsigned long	flags;
@@ -3994,7 +4012,7 @@ static int wavelan_open(struct net_device * dev)
  * Shut down the WaveLAN ISA card.
  * Called by NET3 when it "closes" the device.
  */
-static int wavelan_close(struct net_device * dev)
+static int wavelan_close(struct net_device *dev)
 {
 	net_local *lp = netdev_priv(dev);
 	unsigned long flags;
@@ -4040,7 +4058,7 @@ static const struct net_device_ops wavelan_netdev_ops = {
 /*------------------------------------------------------------------*/
 /*
  * Probe an I/O address, and if the WaveLAN is there configure the
- * device structure
+ *device structure
  * (called by wavelan_probe() and via init_module()).
  */
 static int __init wavelan_config(struct net_device *dev, unsigned short ioaddr)
@@ -4114,7 +4132,7 @@ static int __init wavelan_config(struct net_device *dev, unsigned short ioaddr)
 	memset(netdev_priv(dev), 0, sizeof(net_local));
 	lp = netdev_priv(dev);
 
-	/* Back link to the device structure. */
+	/*back link to the device structure. */
 	lp->dev = dev;
 	/* Add the device at the beginning of the linked list. */
 	lp->next = wavelan_list;
@@ -4377,7 +4395,7 @@ MODULE_LICENSE("GPL");
  *
  * Please send bug reports, updates, comments to:
  *
- * Bruce Janson                                    Email:  bruce@cs.usyd.edu.au
- * Basser Department of Computer Science           Phone:  +61-2-9351-3423
+ *bruce Janson                                    Email:  bruce@cs.usyd.edu.au
+ *basser Department of Computer Science           Phone:  +61-2-9351-3423
  * University of Sydney, N.S.W., 2006, AUSTRALIA   Fax:    +61-2-9351-3838
  */
-- 
1.6.0.4

