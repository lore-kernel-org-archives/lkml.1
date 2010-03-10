Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab0CJFQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 00:16:14 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:59334 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab0CJFQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 00:16:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=n58wdRAgse+2QUTETWGj6sXJz9rUg66tViRSrSTP+MfkhiAxgstjb9tzwts0uAFisI
         mXpKSmTSqxs+J3oAO7kuaxj3sdZsAlT0gOGGhEJoBDYZW5ASxT+lVUoyId/vaqz6v4CA
         IVSqVhH2HkCeB+C3FoHKppf4NCNmJjGDuYRwc=
From: Jacob Silva <questforall@gmail.com>
To: gregkh@suse.de
Cc: linville@tuxdriver.com, davem@davemloft.net, jpirko@redhat.com,
       questforall@gmail.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: netwave: fixed coding style in netwave_cs.c
Date: Tue,  9 Mar 2010 23:15:07 -0600
Message-Id: <1268198107-16188-1-git-send-email-questforall@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the netwave_cs.c file that fixes up multiple whitespace and brace warnings found by the checkpatch.pl tool

Signed-off-by: Jacob Silva <questforall@gmail.com>
---
 drivers/staging/netwave/netwave_cs.c |  576 +++++++++++++++++-----------------
 1 files changed, 295 insertions(+), 281 deletions(-)

diff --git a/drivers/staging/netwave/netwave_cs.c b/drivers/staging/netwave/netwave_cs.c
index e936717..07861d1 100644
--- a/drivers/staging/netwave/netwave_cs.c
+++ b/drivers/staging/netwave/netwave_cs.c
@@ -1,5 +1,5 @@
 /*********************************************************************
- *                
+ *
  * Filename:      netwave_cs.c
  * Version:       0.4.1
  * Description:   Netwave AirSurfer Wireless LAN PC Card driver
@@ -10,27 +10,27 @@
  * Created at:    A long time ago!
  * Modified at:   Mon Nov 10 11:54:37 1997
  * Modified by:   Dag Brattli <dagb@cs.uit.no>
- * 
+ *
  *     Copyright (c) 1997 University of Tromsø, Norway
  *
  * Revision History:
  *
  *   08-Nov-97 15:14:47   John Markus Bjørndalen <johnm@cs.uit.no>
- *    - Fixed some bugs in netwave_rx and cleaned it up a bit. 
+ *    - Fixed some bugs in netwave_rx and cleaned it up a bit.
  *      (One of the bugs would have destroyed packets when receiving
- *      multiple packets per interrupt). 
- *    - Cleaned up parts of newave_hw_xmit. 
- *    - A few general cleanups. 
+ *      multiple packets per interrupt).
+ *    - Cleaned up parts of newave_hw_xmit.
+ *    - A few general cleanups.
  *   24-Oct-97 13:17:36   Dag Brattli <dagb@cs.uit.no>
  *    - Fixed netwave_rx receive function (got updated docs)
  *   Others:
- *    - Changed name from xircnw to netwave, take a look at 
+ *    - Changed name from xircnw to netwave, take a look at
  *      http://www.netwave-wireless.com
  *    - Some reorganizing of the code
  *    - Removed possible race condition between interrupt handler and transmit
  *      function
  *    - Started to add wireless extensions, but still needs some coding
- *    - Added watchdog for better handling of transmission timeouts 
+ *    - Added watchdog for better handling of transmission timeouts
  *      (hopefully this works better)
  ********************************************************************/
 
@@ -65,7 +65,7 @@
 #include <pcmcia/mem_op.h>
 
 #include <asm/system.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include <asm/dma.h>
 
 #define NETWAVE_REGOFF         0x8000
@@ -102,7 +102,7 @@
 
 /*
  * Commands used in the extended command buffer
- * NETWAVE_EREG_CB (0x100-0x10F) 
+ * NETWAVE_EREG_CB (0x100-0x10F)
  */
 #define NETWAVE_CMD_NOP        0x00
 #define NETWAVE_CMD_SRC        0x01
@@ -127,14 +127,15 @@
 
 #define TX_TIMEOUT		((32*HZ)/100)
 
-static const unsigned int imrConfRFU1 = 0x10; /* RFU interrupt mask, keep high */
+/* Keep RFU interrupt mask, keep high */
+static const unsigned int imrConfRFU1 = 0x10;
 static const unsigned int imrConfIENA = 0x02; /* Interrupt enable */
 
 static const unsigned int corConfIENA   = 0x01; /* Interrupt enable */
 static const unsigned int corConfLVLREQ = 0x40; /* Keep high */
 
 static const unsigned int rxConfRxEna  = 0x80; /* Receive Enable */
-static const unsigned int rxConfMAC    = 0x20; /* MAC host receive mode*/ 
+static const unsigned int rxConfMAC    = 0x20; /* MAC host receive mode*/
 static const unsigned int rxConfPro    = 0x10; /* Promiscuous */
 static const unsigned int rxConfAMP    = 0x08; /* Accept Multicast Packets */
 static const unsigned int rxConfBcast  = 0x04; /* Accept Broadcast Packets */
@@ -153,15 +154,15 @@ static const unsigned int txConfLoop   = 0x01; /* Loopback mode */
 /* Choose the domain, default is 0x100 */
 static u_int  domain = 0x100;
 
-/* Scramble key, range from 0x0 to 0xffff.  
- * 0x0 is no scrambling. 
+/* Scramble key, range from 0x0 to 0xffff.
+ * 0x0 is no scrambling.
  */
 static u_int  scramble_key = 0x0;
 
-/* Shared memory speed, in ns. The documentation states that 
- * the card should not be read faster than every 400ns. 
- * This timing should be provided by the HBA. If it becomes a 
- * problem, try setting mem_speed to 400. 
+/* Shared memory speed, in ns. The documentation states that
+ * the card should not be read faster than every 400ns.
+ * This timing should be provided by the HBA. If it becomes a
+ * problem, try setting mem_speed to 400.
  */
 static int mem_speed;
 
@@ -172,10 +173,12 @@ module_param(mem_speed, int, 0);
 /*====================================================================*/
 
 /* PCMCIA (Card Services) related functions */
-static void netwave_release(struct pcmcia_device *link);     /* Card removal */
-static int netwave_pcmcia_config(struct pcmcia_device *arg); /* Runs after card
-													   insertion */
-static void netwave_detach(struct pcmcia_device *p_dev);    /* Destroy instance */
+/* Card removal */
+/* Runs after card insertion */
+/* Destroy instance */
+static void netwave_release(struct pcmcia_device *link);
+static int netwave_pcmcia_config(struct pcmcia_device *arg);
+static void netwave_detach(struct pcmcia_device *p_dev);
 
 /* Hardware configuration */
 static void netwave_doreset(unsigned int iobase, u_char __iomem *ramBase);
@@ -186,16 +189,16 @@ static int netwave_open(struct net_device *dev);  /* Open the device */
 static int netwave_close(struct net_device *dev); /* Close the device */
 
 /* Packet transmission and Packet reception */
-static netdev_tx_t netwave_start_xmit( struct sk_buff *skb,
-					     struct net_device *dev);
-static int netwave_rx( struct net_device *dev);
+static netdev_tx_t netwave_start_xmit(struct sk_buff *skb,
+				      struct net_device *dev);
+static int netwave_rx(struct net_device *dev);
 
 /* Interrupt routines */
 static irqreturn_t netwave_interrupt(int irq, void *dev_id);
 static void netwave_watchdog(struct net_device *);
 
 /* Wireless extensions */
-static struct iw_statistics* netwave_get_wireless_stats(struct net_device *dev);
+static struct iw_statistics *netwave_get_wireless_stats(struct net_device *dev);
 
 static void set_multicast_list(struct net_device *dev);
 
@@ -218,7 +221,8 @@ static void set_multicast_list(struct net_device *dev);
 
 static const struct iw_handler_def	netwave_handler_def;
 
-#define SIOCGIPSNAP	SIOCIWFIRSTPRIV	+ 1	/* Site Survey Snapshot */
+/* Site Survey Snapshot */
+#define SIOCGIPSNAP	(SIOCIWFIRSTPRIV + 1)
 
 #define MAX_ESA 10
 
@@ -230,7 +234,7 @@ struct site_survey {
     u_short length;
     u_char  struct_revision;
     u_char  roaming_state;
-	
+
     u_char  sp_existsFlag;
     u_char  sp_link_quality;
     u_char  sp_max_link_quality;
@@ -240,14 +244,14 @@ struct site_survey {
     u_char  sp_goodness;
     u_char  sp_hotheadcount;
     u_char  roaming_condition;
-	
+
     net_addr sp;
     u_char   numAPs;
     net_addr nearByAccessPoints[MAX_ESA];
-};	
-   
+};
+
 typedef struct netwave_private {
-	struct pcmcia_device	*p_dev;
+    struct pcmcia_device	*p_dev;
     spinlock_t	spinlock;	/* Serialize access to the hardware (SMP) */
     dev_node_t node;
     u_char     __iomem *ramBase;
@@ -262,48 +266,50 @@ typedef struct netwave_private {
  * The Netwave card is little-endian, so won't work for big endian
  * systems.
  */
-static inline unsigned short get_uint16(u_char __iomem *staddr) 
+static inline unsigned short get_uint16(u_char __iomem *staddr)
 {
     return readw(staddr); /* Return only 16 bits */
 }
 
-static inline short get_int16(u_char __iomem * staddr)
+static inline short get_int16(u_char __iomem *staddr)
 {
     return readw(staddr);
 }
 
-/* 
- * Wait until the WOC (Write Operation Complete) bit in the 
- * ASR (Adapter Status Register) is asserted. 
- * This should have aborted if it takes too long time. 
+/*
+ * Wait until the WOC (Write Operation Complete) bit in the
+ * ASR (Adapter Status Register) is asserted.
+ * This should have aborted if it takes too long time.
  */
 static inline void wait_WOC(unsigned int iobase)
 {
-    /* Spin lock */
-    while ((inb(iobase + NETWAVE_REG_ASR) & 0x8) != 0x8) ; 
+	do {
+		/* Spin lock */
+	} while ((inb(iobase + NETWAVE_REG_ASR) & 0x8) != 0x8);
 }
 
-static void netwave_snapshot(netwave_private *priv, u_char __iomem *ramBase, 
-			     unsigned int iobase) {
+static void netwave_snapshot(netwave_private *priv,
+			     u_char __iomem *ramBase, unsigned int iobase)
+{
     u_short resultBuffer;
 
-    /* if time since last snapshot is > 1 sec. (100 jiffies?)  then take 
-     * new snapshot, else return cached data. This is the recommended rate.  
+    /* if time since last snapshot is > 1 sec. (100 jiffies?)  then take
+     * new snapshot, else return cached data. This is the recommended rate.
      */
-    if ( jiffies - priv->lastExec > 100) { 
-	/* Take site survey  snapshot */ 
+    if (jiffies - priv->lastExec > 100) {
+	/* Take site survey  snapshot */
 	/*printk( KERN_DEBUG "Taking new snapshot. %ld\n", jiffies -
 	  priv->lastExec); */
-	wait_WOC(iobase); 
-	writeb(NETWAVE_CMD_SSS, ramBase + NETWAVE_EREG_CB + 0); 
-	writeb(NETWAVE_CMD_EOC, ramBase + NETWAVE_EREG_CB + 1); 
-	wait_WOC(iobase); 
-
-	/* Get result and copy to cach */ 
-	resultBuffer = readw(ramBase + NETWAVE_EREG_CRBP); 
-	copy_from_pc( &priv->nss, ramBase+resultBuffer, 
-		      sizeof(struct site_survey)); 
-    } 
+	wait_WOC(iobase);
+	writeb(NETWAVE_CMD_SSS, ramBase + NETWAVE_EREG_CB + 0);
+	writeb(NETWAVE_CMD_EOC, ramBase + NETWAVE_EREG_CB + 1);
+	wait_WOC(iobase);
+
+	/* Get result and copy to cach */
+	resultBuffer = readw(ramBase + NETWAVE_EREG_CRBP);
+	copy_from_pc(&priv->nss, ramBase+resultBuffer,
+		     sizeof(struct site_survey));
+    }
 }
 
 /*
@@ -313,48 +319,48 @@ static void netwave_snapshot(netwave_private *priv, u_char __iomem *ramBase,
  *
  */
 static struct iw_statistics *netwave_get_wireless_stats(struct net_device *dev)
-{	
+{
     unsigned long flags;
     unsigned int iobase = dev->base_addr;
     netwave_private *priv = netdev_priv(dev);
     u_char __iomem *ramBase = priv->ramBase;
-    struct iw_statistics* wstats;
-	
+    struct iw_statistics *wstats;
+
     wstats = &priv->iw_stats;
 
     spin_lock_irqsave(&priv->spinlock, flags);
-	
-    netwave_snapshot( priv, ramBase, iobase);
+
+    netwave_snapshot(priv, ramBase, iobase);
 
     wstats->status = priv->nss.roaming_state;
-    wstats->qual.qual = readb( ramBase + NETWAVE_EREG_SPCQ); 
-    wstats->qual.level = readb( ramBase + NETWAVE_EREG_ISPLQ);
-    wstats->qual.noise = readb( ramBase + NETWAVE_EREG_SPU) & 0x3f;
+    wstats->qual.qual = readb(ramBase + NETWAVE_EREG_SPCQ);
+    wstats->qual.level = readb(ramBase + NETWAVE_EREG_ISPLQ);
+    wstats->qual.noise = readb(ramBase + NETWAVE_EREG_SPU) & 0x3f;
     wstats->discard.nwid = 0L;
     wstats->discard.code = 0L;
     wstats->discard.misc = 0L;
 
     spin_unlock_irqrestore(&priv->spinlock, flags);
-    
+
     return &priv->iw_stats;
 }
 
 static const struct net_device_ops netwave_netdev_ops = {
-	.ndo_open	 	= netwave_open,
+	.ndo_open		= netwave_open,
 	.ndo_stop		= netwave_close,
 	.ndo_start_xmit		= netwave_start_xmit,
 	.ndo_set_multicast_list = set_multicast_list,
 	.ndo_tx_timeout		= netwave_watchdog,
 	.ndo_change_mtu		= eth_change_mtu,
-	.ndo_set_mac_address 	= eth_mac_addr,
+	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 };
 
 /*
  * Function netwave_attach (void)
  *
- *     Creates an "instance" of the driver, allocating local data 
- *     structures for one device.  The device is registered with Card 
+ *     Creates an "instance" of the driver, allocating local data
+ *     structures for one device.  The device is registered with Card
  *     Services.
  *
  *     The dev_link structure is initialized, but we don't actually
@@ -379,14 +385,14 @@ static int netwave_probe(struct pcmcia_device *link)
     /* The io structure describes IO port mapping */
     link->io.NumPorts1 = 16;
     link->io.Attributes1 = IO_DATA_PATH_WIDTH_16;
-    /* link->io.NumPorts2 = 16; 
+    /* link->io.NumPorts2 = 16;
        link->io.Attributes2 = IO_DATA_PATH_WIDTH_16; */
     link->io.IOAddrLines = 5;
-    
+
     /* Interrupt setup */
     link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING;
     link->irq.Handler = &netwave_interrupt;
-    
+
     /* General socket configuration */
     link->conf.Attributes = CONF_ENABLE_IRQ;
     link->conf.IntType = INT_MEMORY_AND_IO;
@@ -403,7 +409,7 @@ static int netwave_probe(struct pcmcia_device *link)
 
     dev->watchdog_timeo = TX_TIMEOUT;
 
-    return netwave_pcmcia_config( link);
+    return netwave_pcmcia_config(link);
 } /* netwave_attach */
 
 /*
@@ -456,20 +462,20 @@ static int netwave_set_nwid(struct net_device *dev,
 	/* Disable interrupts & save flags */
 	spin_lock_irqsave(&priv->spinlock, flags);
 
-	if(!wrqu->nwid.disabled) {
-	    domain = wrqu->nwid.value;
-	    printk( KERN_DEBUG "Setting domain to 0x%x%02x\n", 
-		    (domain >> 8) & 0x01, domain & 0xff);
-	    wait_WOC(iobase);
-	    writeb(NETWAVE_CMD_SMD, ramBase + NETWAVE_EREG_CB + 0);
-	    writeb( domain & 0xff, ramBase + NETWAVE_EREG_CB + 1);
-	    writeb((domain >>8 ) & 0x01,ramBase + NETWAVE_EREG_CB+2);
-	    writeb(NETWAVE_CMD_EOC, ramBase + NETWAVE_EREG_CB + 3);
+	if (!wrqu->nwid.disabled) {
+		domain = wrqu->nwid.value;
+		printk(KERN_DEBUG "Setting domain to 0x%x%02x\n",
+			(domain >> 8) & 0x01, domain & 0xff);
+		wait_WOC(iobase);
+		writeb(NETWAVE_CMD_SMD, ramBase + NETWAVE_EREG_CB + 0);
+		writeb(domain & 0xff, ramBase + NETWAVE_EREG_CB + 1);
+		writeb((domain >> 8) & 0x01, ramBase + NETWAVE_EREG_CB+2);
+		writeb(NETWAVE_CMD_EOC, ramBase + NETWAVE_EREG_CB + 3);
 	}
 
 	/* ReEnable interrupts & restore flags */
 	spin_unlock_irqrestore(&priv->spinlock, flags);
-    
+
 	return 0;
 }
 
@@ -512,7 +518,7 @@ static int netwave_set_scramble(struct net_device *dev,
 
 	/* ReEnable interrupts & restore flags */
 	spin_unlock_irqrestore(&priv->spinlock, flags);
-    
+
 	return 0;
 }
 
@@ -539,7 +545,7 @@ static int netwave_get_mode(struct net_device *dev,
 			    union iwreq_data *wrqu,
 			    char *extra)
 {
-	if(domain & 0x100)
+	if (domain & 0x100)
 		wrqu->mode = IW_MODE_INFRA;
 	else
 		wrqu->mode = IW_MODE_ADHOC;
@@ -567,19 +573,19 @@ static int netwave_get_range(struct net_device *dev,
 	/* Set the Wireless Extension versions */
 	range->we_version_compiled = WIRELESS_EXT;
 	range->we_version_source = 9;	/* Nothing for us in v10 and v11 */
-		   
+
 	/* Set information in the range struct */
 	range->throughput = 450 * 1000;	/* don't argue on this ! */
 	range->min_nwid = 0x0000;
 	range->max_nwid = 0x01FF;
 
 	range->num_channels = range->num_frequency = 0;
-		   
+
 	range->sensitivity = 0x3F;
 	range->max_qual.qual = 255;
 	range->max_qual.level = 255;
 	range->max_qual.noise = 0;
-		   
+
 	range->num_bitrates = 1;
 	range->bitrate[0] = 1000000;	/* 1 Mb/s */
 
@@ -607,16 +613,16 @@ static int netwave_get_snap(struct net_device *dev,
 	spin_lock_irqsave(&priv->spinlock, flags);
 
 	/* Take snapshot of environment */
-	netwave_snapshot( priv, ramBase, iobase);
+	netwave_snapshot(priv, ramBase, iobase);
 	wrqu->data.length = priv->nss.length;
-	memcpy(extra, (u_char *) &priv->nss, sizeof( struct site_survey));
+	memcpy(extra, (u_char *) &priv->nss, sizeof(struct site_survey));
 
 	priv->lastExec = jiffies;
 
 	/* ReEnable interrupts & restore flags */
 	spin_unlock_irqrestore(&priv->spinlock, flags);
-    
-	return(0);
+
+	return 0;
 }
 
 /*
@@ -626,13 +632,12 @@ static int netwave_get_snap(struct net_device *dev,
 
 static const struct iw_priv_args netwave_private_args[] = {
 /*{ cmd,         set_args,                            get_args, name } */
-  { SIOCGIPSNAP, 0, 
-    IW_PRIV_TYPE_BYTE | IW_PRIV_SIZE_FIXED | sizeof(struct site_survey), 
+  { SIOCGIPSNAP, 0,
+    IW_PRIV_TYPE_BYTE | IW_PRIV_SIZE_FIXED | sizeof(struct site_survey),
     "getsitesurvey" },
 };
 
-static const iw_handler		netwave_handler[] =
-{
+static const iw_handler		netwave_handler[] = {
 	NULL,				/* SIOCSIWNAME */
 	netwave_get_name,		/* SIOCGIWNAME */
 	netwave_set_nwid,		/* SIOCSIWNWID */
@@ -679,14 +684,12 @@ static const iw_handler		netwave_handler[] =
 	netwave_get_scramble,		/* SIOCGIWENCODE */
 };
 
-static const iw_handler		netwave_private_handler[] =
-{
+static const iw_handler		netwave_private_handler[] = {
 	NULL,				/* SIOCIWFIRSTPRIV */
 	netwave_get_snap,		/* SIOCIWFIRSTPRIV + 1 */
 };
 
-static const struct iw_handler_def	netwave_handler_def =
-{
+static const struct iw_handler_def	netwave_handler_def = {
 	.num_standard	= ARRAY_SIZE(netwave_handler),
 	.num_private	= ARRAY_SIZE(netwave_private_handler),
 	.num_private_args = ARRAY_SIZE(netwave_private_args),
@@ -699,13 +702,14 @@ static const struct iw_handler_def	netwave_handler_def =
 /*
  * Function netwave_pcmcia_config (link)
  *
- *     netwave_pcmcia_config() is scheduled to run after a CARD_INSERTION 
+ *     netwave_pcmcia_config() is scheduled to run after a CARD_INSERTION
  *     event is received, to configure the PCMCIA socket, and to make the
- *     device available to the system. 
+ *     device available to the system.
  *
  */
 
-static int netwave_pcmcia_config(struct pcmcia_device *link) {
+static int netwave_pcmcia_config(struct pcmcia_device *link)
+{
     struct net_device *dev = link->priv;
     netwave_private *priv = netdev_priv(dev);
     int i, j, ret;
@@ -735,7 +739,7 @@ static int netwave_pcmcia_config(struct pcmcia_device *link) {
      */
     ret = pcmcia_request_irq(link, &link->irq);
     if (ret)
-	    goto failed;
+	goto failed;
 
     /*
      *  This actually configures the PCMCIA socket -- setting up
@@ -743,7 +747,7 @@ static int netwave_pcmcia_config(struct pcmcia_device *link) {
      */
     ret = pcmcia_request_configuration(link, &link->conf);
     if (ret)
-	    goto failed;
+	goto failed;
 
     /*
      *  Allocate a 32K memory window.  Note that the struct pcmcia_device
@@ -758,11 +762,11 @@ static int netwave_pcmcia_config(struct pcmcia_device *link) {
     req.AccessSpeed = mem_speed;
     ret = pcmcia_request_window(link, &req, &link->win);
     if (ret)
-	    goto failed;
-    mem.CardOffset = 0x20000; mem.Page = 0; 
+	goto failed;
+    mem.CardOffset = 0x20000; mem.Page = 0;
     ret = pcmcia_map_mem_page(link, link->win, &mem);
     if (ret)
-	    goto failed;
+	goto failed;
 
     /* Store base address of the common window frame */
     ramBase = ioremap(req.Base, 0x8000);
@@ -784,7 +788,7 @@ static int netwave_pcmcia_config(struct pcmcia_device *link) {
     netwave_doreset(dev->base_addr, ramBase);
 
     /* Read the ethernet address and fill in the Netwave registers. */
-    for (i = 0; i < 6; i++) 
+    for (i = 0; i < 6; i++)
 	dev->dev_addr[i] = readb(ramBase + NETWAVE_EREG_PA + i);
 
     printk(KERN_INFO "%s: Netwave: port %#3lx, irq %d, mem %lx, "
@@ -796,7 +800,7 @@ static int netwave_pcmcia_config(struct pcmcia_device *link) {
 	   dev->dev_addr);
 
     /* get revision words */
-    printk(KERN_DEBUG "Netwave_reset: revision %04x %04x\n", 
+    printk(KERN_DEBUG "Netwave_reset: revision %04x %04x\n",
 	   get_uint16(ramBase + NETWAVE_EREG_ARW),
 	   get_uint16(ramBase + NETWAVE_EREG_ARW+2));
     return 0;
@@ -865,9 +869,10 @@ static void netwave_doreset(unsigned int ioBase, u_char __iomem *ramBase)
 /*
  * Function netwave_reset (dev)
  *
- *    Reset and restore all of the netwave registers 
+ *    Reset and restore all of the netwave registers
  */
-static void netwave_reset(struct net_device *dev) {
+static void netwave_reset(struct net_device *dev)
+{
     /* u_char state; */
     netwave_private *priv = netdev_priv(dev);
     u_char __iomem *ramBase = priv->ramBase;
@@ -880,32 +885,33 @@ static void netwave_reset(struct net_device *dev) {
     /* Reset card */
     netwave_doreset(iobase, ramBase);
     printk(KERN_DEBUG "netwave_reset: Done with hardware reset\n");
-	
+
     /* Write a NOP to check the card */
     wait_WOC(iobase);
     writeb(NETWAVE_CMD_NOP, ramBase + NETWAVE_EREG_CB + 0);
     writeb(NETWAVE_CMD_EOC, ramBase + NETWAVE_EREG_CB + 1);
-	
+
     /* Set receive conf */
     wait_WOC(iobase);
     writeb(NETWAVE_CMD_SRC, ramBase + NETWAVE_EREG_CB + 0);
     writeb(rxConfRxEna + rxConfBcast, ramBase + NETWAVE_EREG_CB + 1);
     writeb(NETWAVE_CMD_EOC, ramBase + NETWAVE_EREG_CB + 2);
-    
+
     /* Set transmit conf */
     wait_WOC(iobase);
     writeb(NETWAVE_CMD_STC, ramBase + NETWAVE_EREG_CB + 0);
     writeb(txConfTxEna, ramBase + NETWAVE_EREG_CB + 1);
     writeb(NETWAVE_CMD_EOC, ramBase + NETWAVE_EREG_CB + 2);
-    
+
     /* Now set the MU Domain */
-    printk(KERN_DEBUG "Setting domain to 0x%x%02x\n", (domain >> 8) & 0x01, domain & 0xff);
+    printk(KERN_DEBUG "Setting domain to 0x%x%02x\n",
+	(domain >> 8) & 0x01, domain & 0xff);
     wait_WOC(iobase);
     writeb(NETWAVE_CMD_SMD, ramBase + NETWAVE_EREG_CB + 0);
     writeb(domain & 0xff, ramBase + NETWAVE_EREG_CB + 1);
     writeb((domain>>8) & 0x01, ramBase + NETWAVE_EREG_CB + 2);
     writeb(NETWAVE_CMD_EOC, ramBase + NETWAVE_EREG_CB + 3);
-	
+
     /* Set scramble key */
     printk(KERN_DEBUG "Setting scramble key to 0x%x\n", scramble_key);
     wait_WOC(iobase);
@@ -915,8 +921,8 @@ static void netwave_reset(struct net_device *dev) {
     writeb(NETWAVE_CMD_EOC, ramBase + NETWAVE_EREG_CB + 3);
 
     /* Enable interrupts, bit 4 high to keep unused
-     * source from interrupting us, bit 2 high to 
-     * set interrupt enable, 567 to enable TxDN, 
+     * source from interrupting us, bit 2 high to
+     * set interrupt enable, 567 to enable TxDN,
      * RxErr and RxRdy
      */
     wait_WOC(iobase);
@@ -927,31 +933,31 @@ static void netwave_reset(struct net_device *dev) {
      * skriv 80 til d000:3688
      * sjekk om det ble 80
      */
-    
+
     /* Enable Receiver */
     wait_WOC(iobase);
     writeb(NETWAVE_CMD_ER, ramBase + NETWAVE_EREG_CB + 0);
     writeb(NETWAVE_CMD_EOC, ramBase + NETWAVE_EREG_CB + 1);
-	
+
     /* Set the IENA bit in COR */
     wait_WOC(iobase);
     outb(corConfIENA + corConfLVLREQ, iobase + NETWAVE_REG_COR);
 }
 
 /*
- * Function netwave_hw_xmit (data, len, dev)    
+ * Function netwave_hw_xmit (data, len, dev)
  */
-static int netwave_hw_xmit(unsigned char* data, int len,
-			   struct net_device* dev) {
+static int netwave_hw_xmit(unsigned char *data, int len,
+			   struct net_device *dev) {
     unsigned long flags;
     unsigned int TxFreeList,
-	         curBuff,
-	         MaxData, 
-                 DataOffset;
-    int tmpcount; 
-	
+		curBuff,
+		MaxData,
+		DataOffset;
+    int tmpcount;
+
     netwave_private *priv = netdev_priv(dev);
-    u_char __iomem * ramBase = priv->ramBase;
+    u_char __iomem *ramBase = priv->ramBase;
     unsigned int iobase = dev->base_addr;
 
     /* Disable interrupts & save flags */
@@ -980,23 +986,23 @@ static int netwave_hw_xmit(unsigned char* data, int len,
     TxFreeList = get_uint16(ramBase + NETWAVE_EREG_TDP);
     MaxData    = get_uint16(ramBase + NETWAVE_EREG_TDP+2);
     DataOffset = get_uint16(ramBase + NETWAVE_EREG_TDP+4);
-	
+
     pr_debug("TxFreeList %x, MaxData %x, DataOffset %x\n",
 	  TxFreeList, MaxData, DataOffset);
 
     /* Copy packet to the adapter fragment buffers */
-    curBuff = TxFreeList; 
-    tmpcount = 0; 
+    curBuff = TxFreeList;
+    tmpcount = 0;
     while (tmpcount < len) {
-	int tmplen = len - tmpcount; 
-	copy_to_pc(ramBase + curBuff + DataOffset, data + tmpcount, 
+	int tmplen = len - tmpcount;
+	copy_to_pc(ramBase + curBuff + DataOffset, data + tmpcount,
 		   (tmplen < MaxData) ? tmplen : MaxData);
 	tmpcount += MaxData;
-			
+
 	/* Advance to next buffer */
 	curBuff = get_uint16(ramBase + curBuff);
     }
-    
+
     /* Now issue transmit list */
     wait_WOC(iobase);
     writeb(NETWAVE_CMD_TL, ramBase + NETWAVE_EREG_CB + 0);
@@ -1009,27 +1015,28 @@ static int netwave_hw_xmit(unsigned char* data, int len,
 }
 
 static netdev_tx_t netwave_start_xmit(struct sk_buff *skb,
-					    struct net_device *dev) {
+				      struct net_device *dev)
+{
 	/* This flag indicate that the hardware can't perform a transmission.
 	 * Theoritically, NET3 check it before sending a packet to the driver,
 	 * but in fact it never do that and pool continuously.
-	 * As the watchdog will abort too long transmissions, we are quite safe...
+	 * As the watchdog will abort too long transmissions, we are quite safe
 	 */
 
     netif_stop_queue(dev);
 
     {
 	short length = ETH_ZLEN < skb->len ? skb->len : ETH_ZLEN;
-	unsigned char* buf = skb->data;
-	
-	if (netwave_hw_xmit( buf, length, dev) == 1) {
-	    /* Some error, let's make them call us another time? */
-	    netif_start_queue(dev);
+	unsigned char *buf = skb->data;
+
+	if (netwave_hw_xmit(buf, length, dev) == 1) {
+		/* Some error, let's make them call us another time? */
+		netif_start_queue(dev);
 	}
 	dev->trans_start = jiffies;
     }
     dev_kfree_skb(skb);
-    
+
     return NETDEV_TX_OK;
 } /* netwave_start_xmit */
 
@@ -1037,13 +1044,13 @@ static netdev_tx_t netwave_start_xmit(struct sk_buff *skb,
  * Function netwave_interrupt (irq, dev_id)
  *
  *    This function is the interrupt handler for the Netwave card. This
- *    routine will be called whenever: 
+ *    routine will be called whenever:
  *	  1. A packet is received.
  *	  2. A packet has successfully been transferred and the unit is
  *	     ready to transmit another packet.
  *	  3. A command has completed execution.
  */
-static irqreturn_t netwave_interrupt(int irq, void* dev_id)
+static irqreturn_t netwave_interrupt(int irq, void *dev_id)
 {
     unsigned int iobase;
     u_char __iomem *ramBase;
@@ -1051,105 +1058,108 @@ static irqreturn_t netwave_interrupt(int irq, void* dev_id)
     struct netwave_private *priv = netdev_priv(dev);
     struct pcmcia_device *link = priv->p_dev;
     int i;
-    
+
     if (!netif_device_present(dev))
 	return IRQ_NONE;
-    
+
     iobase = dev->base_addr;
     ramBase = priv->ramBase;
-	
+
     /* Now find what caused the interrupt, check while interrupts ready */
     for (i = 0; i < 10; i++) {
 	u_char status;
-		
-	wait_WOC(iobase);	
-	if (!(inb(iobase+NETWAVE_REG_CCSR) & 0x02))
-	    break; /* None of the interrupt sources asserted (normal exit) */
-	
-        status = inb(iobase + NETWAVE_REG_ASR);
-		
+
+	wait_WOC(iobase);
+	if (!(inb(iobase+NETWAVE_REG_CCSR) & 0x02)) {
+		/* None of the interrupt sources asserted (normal exit) */
+		break;
+	}
+	status = inb(iobase + NETWAVE_REG_ASR);
+
 	if (!pcmcia_dev_present(link)) {
-	    pr_debug("netwave_interrupt: Interrupt with status 0x%x "
-		  "from removed or suspended card!\n", status);
-	    break;
+		pr_debug("netwave_interrupt: Interrupt with status 0x%x "
+			 "from removed or suspended card!\n", status);
+		break;
 	}
-		
+
 	/* RxRdy */
 	if (status & 0x80) {
-	    netwave_rx(dev);
-	    /* wait_WOC(iobase); */
-	    /* RxRdy cannot be reset directly by the host */
+		netwave_rx(dev);
+		/* wait_WOC(iobase); */
+		/* RxRdy cannot be reset directly by the host */
 	}
 	/* RxErr */
 	if (status & 0x40) {
-	    u_char rser;
-			
-	    rser = readb(ramBase + NETWAVE_EREG_RSER);			
-	    
-	    if (rser & 0x04) {
-		++dev->stats.rx_dropped;
-		++dev->stats.rx_crc_errors;
-	    }
-	    if (rser & 0x02)
-		++dev->stats.rx_frame_errors;
-			
-	    /* Clear the RxErr bit in RSER. RSER+4 is the
-	     * write part. Also clear the RxCRC (0x04) and 
-	     * RxBig (0x02) bits if present */
-	    wait_WOC(iobase);
-	    writeb(0x40 | (rser & 0x06), ramBase + NETWAVE_EREG_RSER + 4);
-
-	    /* Write bit 6 high to ASCC to clear RxErr in ASR,
-	     * WOC must be set first! 
-	     */
-	    wait_WOC(iobase);
-	    writeb(0x40, ramBase + NETWAVE_EREG_ASCC);
-
-	    /* Remember to count up dev->stats on error packets */
-	    ++dev->stats.rx_errors;
+		u_char rser;
+
+		rser = readb(ramBase + NETWAVE_EREG_RSER);
+
+		if (rser & 0x04) {
+			++dev->stats.rx_dropped;
+			++dev->stats.rx_crc_errors;
+		}
+		if (rser & 0x02)
+			++dev->stats.rx_frame_errors;
+
+		/* Clear the RxErr bit in RSER. RSER+4 is the
+		 * write part. Also clear the RxCRC (0x04) and
+		 * RxBig (0x02) bits if present */
+		wait_WOC(iobase);
+		writeb(0x40 | (rser & 0x06), ramBase + NETWAVE_EREG_RSER + 4);
+
+		/* Write bit 6 high to ASCC to clear RxErr in ASR,
+		 * WOC must be set first!
+		 */
+		wait_WOC(iobase);
+		writeb(0x40, ramBase + NETWAVE_EREG_ASCC);
+
+		/* Remember to count up dev->stats on error packets */
+		++dev->stats.rx_errors;
 	}
 	/* TxDN */
 	if (status & 0x20) {
-	    int txStatus;
-
-	    txStatus = readb(ramBase + NETWAVE_EREG_TSER);
-	    pr_debug("Transmit done. TSER = %x id %x\n",
-		  txStatus, readb(ramBase + NETWAVE_EREG_TSER + 1));
-	    
-	    if (txStatus & 0x20) {
-		/* Transmitting was okay, clear bits */
-		wait_WOC(iobase);
-		writeb(0x2f, ramBase + NETWAVE_EREG_TSER + 4);
-		++dev->stats.tx_packets;
-	    }
-			
-	    if (txStatus & 0xd0) {
-		if (txStatus & 0x80) {
-		    ++dev->stats.collisions; /* Because of /proc/net/dev*/
-		    /* ++dev->stats.tx_aborted_errors; */
-		    /* printk("Collision. %ld\n", jiffies - dev->trans_start); */
+		int txStatus;
+
+		txStatus = readb(ramBase + NETWAVE_EREG_TSER);
+		pr_debug("Transmit done. TSER = %x id %x\n", txStatus,
+			 readb(ramBase + NETWAVE_EREG_TSER + 1));
+
+		if (txStatus & 0x20) {
+			/* Transmitting was okay, clear bits */
+			wait_WOC(iobase);
+			writeb(0x2f, ramBase + NETWAVE_EREG_TSER + 4);
+			++dev->stats.tx_packets;
 		}
-		if (txStatus & 0x40) 
-		    ++dev->stats.tx_carrier_errors;
-		/* 0x80 TxGU Transmit giveup - nine times and no luck
-		 * 0x40 TxNOAP No access point. Discarded packet.
-		 * 0x10 TxErr Transmit error. Always set when 
-		 *      TxGU and TxNOAP is set. (Those are the only ones
-		 *      to set TxErr).
-		 */
-		pr_debug("netwave_interrupt: TxDN with error status %x\n",
-		      txStatus);
-		
-		/* Clear out TxGU, TxNOAP, TxErr and TxTrys */
-		wait_WOC(iobase);
-		writeb(0xdf & txStatus, ramBase+NETWAVE_EREG_TSER+4);
-		++dev->stats.tx_errors;
-	    }
-	    pr_debug("New status is TSER %x ASR %x\n",
-		  readb(ramBase + NETWAVE_EREG_TSER),
-		  inb(iobase + NETWAVE_REG_ASR));
-
-	    netif_wake_queue(dev);
+
+		if (txStatus & 0xd0) {
+			if (txStatus & 0x80) {
+				++dev->stats.collisions;
+				/* Because of /proc/net/dev*/
+				/* ++dev->stats.tx_aborted_errors; */
+				/* printk("Collision. %ld\n",
+					  jiffies - dev->trans_start); */
+			}
+			if (txStatus & 0x40)
+				++dev->stats.tx_carrier_errors;
+			/* 0x80 TxGU Transmit giveup - nine times and no luck
+			 * 0x40 TxNOAP No access point. Discarded packet.
+			 * 0x10 TxErr Transmit error. Always set when
+			 *      TxGU and TxNOAP is set. (Those are the only ones
+			 *      to set TxErr).
+			 */
+			pr_debug("netwave_interrupt: "
+				 "TxDN with error status %x\n", txStatus);
+
+			/* Clear out TxGU, TxNOAP, TxErr and TxTrys */
+			wait_WOC(iobase);
+			writeb(0xdf & txStatus, ramBase+NETWAVE_EREG_TSER+4);
+			++dev->stats.tx_errors;
+		}
+		pr_debug("New status is TSER %x ASR %x\n",
+		      readb(ramBase + NETWAVE_EREG_TSER),
+		      inb(iobase + NETWAVE_REG_ASR));
+
+		netif_wake_queue(dev);
 	}
 	/* TxBA, this would trigger on all error packets received */
 	/* if (status & 0x01) {
@@ -1169,7 +1179,8 @@ static irqreturn_t netwave_interrupt(int irq, void* dev_id)
  *    it expire, we reset the card.
  *
  */
-static void netwave_watchdog(struct net_device *dev) {
+static void netwave_watchdog(struct net_device *dev)
+{
 
     pr_debug("%s: netwave_watchdog: watchdog timer expired\n", dev->name);
     netwave_reset(dev);
@@ -1191,65 +1202,65 @@ static int netwave_rx(struct net_device *dev)
     int dataCount, dataOffset;
     int i;
     u_char *ptr;
-	
-    pr_debug("xinw_rx: Receiving ... \n");
+
+    pr_debug("xinw_rx: Receiving ...\n");
 
     /* Receive max 10 packets for now. */
     for (i = 0; i < 10; i++) {
 	/* Any packets? */
 	wait_WOC(iobase);
-	rxStatus = readb(ramBase + NETWAVE_EREG_RSER);		
-	if ( !( rxStatus & 0x80)) /* No more packets */
+	rxStatus = readb(ramBase + NETWAVE_EREG_RSER);
+	if (!(rxStatus & 0x80)) /* No more packets */
 	    break;
-		
+
 	/* Check if multicast/broadcast or other */
 	/* multicast = (rxStatus & 0x20);  */
-		
+
 	/* The receive list pointer and length of the packet */
 	wait_WOC(iobase);
-	rcvLen  = get_int16( ramBase + NETWAVE_EREG_RDP);
-	rcvList = get_uint16( ramBase + NETWAVE_EREG_RDP + 2);
-		
+	rcvLen  = get_int16(ramBase + NETWAVE_EREG_RDP);
+	rcvList = get_uint16(ramBase + NETWAVE_EREG_RDP + 2);
+
 	if (rcvLen < 0) {
-	    printk(KERN_DEBUG "netwave_rx: Receive packet with len %d\n", 
-		   rcvLen);
-	    return 0;
+		printk(KERN_DEBUG "netwave_rx: Receive packet with "
+			"len %d\n", rcvLen);
+		return 0;
 	}
-		
+
 	skb = dev_alloc_skb(rcvLen+5);
 	if (skb == NULL) {
-	    pr_debug("netwave_rx: Could not allocate an sk_buff of "
-		  "length %d\n", rcvLen);
-	    ++dev->stats.rx_dropped;
-	    /* Tell the adapter to skip the packet */
-	    wait_WOC(iobase);
-	    writeb(NETWAVE_CMD_SRP, ramBase + NETWAVE_EREG_CB + 0);
-	    writeb(NETWAVE_CMD_EOC, ramBase + NETWAVE_EREG_CB + 1);
-	    return 0;
+		pr_debug("netwave_rx: Could not allocate an sk_buff "
+			 "of length %d\n", rcvLen);
+		++dev->stats.rx_dropped;
+		/* Tell the adapter to skip the packet */
+		wait_WOC(iobase);
+		writeb(NETWAVE_CMD_SRP, ramBase + NETWAVE_EREG_CB + 0);
+		writeb(NETWAVE_CMD_EOC, ramBase + NETWAVE_EREG_CB + 1);
+		return 0;
 	}
 
-	skb_reserve( skb, 2);  /* Align IP on 16 byte */
-	skb_put( skb, rcvLen);
+	skb_reserve(skb, 2);  /* Align IP on 16 byte */
+	skb_put(skb, rcvLen);
 
 	/* Copy packet fragments to the skb data area */
-	ptr = (u_char*) skb->data;
+	ptr = (u_char *) skb->data;
 	curBuffer = rcvList;
-	tmpcount = 0; 
-	while ( tmpcount < rcvLen) {
-	    /* Get length and offset of current buffer */
-	    dataCount  = get_uint16( ramBase+curBuffer+2);
-	    dataOffset = get_uint16( ramBase+curBuffer+4);
-		
-	    copy_from_pc( ptr + tmpcount,
-			  ramBase+curBuffer+dataOffset, dataCount);
-
-	    tmpcount += dataCount;
-		
-	    /* Point to next buffer */
-	    curBuffer = get_uint16(ramBase + curBuffer);
+	tmpcount = 0;
+	while (tmpcount < rcvLen) {
+		/* Get length and offset of current buffer */
+		dataCount  = get_uint16(ramBase+curBuffer+2);
+		dataOffset = get_uint16(ramBase+curBuffer+4);
+
+		copy_from_pc(ptr + tmpcount, ramBase+curBuffer+dataOffset,
+			     dataCount);
+
+		tmpcount += dataCount;
+
+		/* Point to next buffer */
+		curBuffer = get_uint16(ramBase + curBuffer);
 	}
-	
-	skb->protocol = eth_type_trans(skb,dev);
+
+	skb->protocol = eth_type_trans(skb, dev);
 	/* Queue packet for network layer */
 	netif_rx(skb);
 
@@ -1265,12 +1276,13 @@ static int netwave_rx(struct net_device *dev)
     return 0;
 }
 
-static int netwave_open(struct net_device *dev) {
+static int netwave_open(struct net_device *dev)
+{
     netwave_private *priv = netdev_priv(dev);
     struct pcmcia_device *link = priv->p_dev;
 
     dev_dbg(&link->dev, "netwave_open: starting.\n");
-    
+
     if (!pcmcia_dev_present(link))
 	return -ENODEV;
 
@@ -1278,11 +1290,12 @@ static int netwave_open(struct net_device *dev) {
 
     netif_start_queue(dev);
     netwave_reset(dev);
-	
+
     return 0;
 }
 
-static int netwave_close(struct net_device *dev) {
+static int netwave_close(struct net_device *dev)
+{
     netwave_private *priv = netdev_priv(dev);
     struct pcmcia_device *link = priv->p_dev;
 
@@ -1295,7 +1308,8 @@ static int netwave_close(struct net_device *dev) {
 }
 
 static struct pcmcia_device_id netwave_ids[] = {
-	PCMCIA_DEVICE_PROD_ID12("Xircom", "CreditCard Netwave", 0x2e3ee845, 0x54e28a28),
+	PCMCIA_DEVICE_PROD_ID12("Xircom", "CreditCard Netwave",
+				0x2e3ee845, 0x54e28a28),
 	PCMCIA_DEVICE_NULL,
 };
 MODULE_DEVICE_TABLE(pcmcia, netwave_ids);
@@ -1335,20 +1349,20 @@ static void set_multicast_list(struct net_device *dev)
 {
     unsigned int iobase = dev->base_addr;
     netwave_private *priv = netdev_priv(dev);
-    u_char __iomem * ramBase = priv->ramBase;
+    u_char __iomem *ramBase = priv->ramBase;
     u_char  rcvMode = 0;
-   
+
 #ifdef PCMCIA_DEBUG
     {
 	xstatic int old;
 	if (old != netdev_mc_count(dev)) {
-	    old = netdev_mc_count(dev);
-	    pr_debug("%s: setting Rx mode to %d addresses.\n",
-		  dev->name, netdev_mc_count(dev));
+		old = netdev_mc_count(dev);
+		pr_debug("%s: setting Rx mode to %d addresses.\n",
+		dev->name, netdev_mc_count(dev));
 	}
     }
 #endif
-	
+
     if (!netdev_mc_empty(dev) || (dev->flags & IFF_ALLMULTI)) {
 	/* Multicast Mode */
 	rcvMode = rxConfRxEna + rxConfAMP + rxConfBcast;
@@ -1359,7 +1373,7 @@ static void set_multicast_list(struct net_device *dev)
 	/* Normal mode */
 	rcvMode = rxConfRxEna + rxConfBcast;
     }
-	
+
     /* printk("netwave set_multicast_list: rcvMode to %x\n", rcvMode);*/
     /* Now set receive mode */
     wait_WOC(iobase);
-- 
1.6.3.3

