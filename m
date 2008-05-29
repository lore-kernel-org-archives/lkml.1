Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbYE2Re2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbYE2Re2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 13:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbYE2ReS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 13:34:18 -0400
Received: from sslsrv.de ([62.75.159.123]:58022 "EHLO sslsrv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbYE2ReH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 13:34:07 -0400
From: Philipp Marek <philipp@marek.priv.at>
To: linux-trivial@kernel.org
Subject: [patch] removes casting of (void*) private structure members
Date: Thu, 29 May 2008 19:33:54 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_CkuPIlo2oI1LROu"
Message-Id: <200805291933.54529@marek.priv.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_CkuPIlo2oI1LROu
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello everybody,

here's another trivial patch, against v2.6.26-rc3-243-gd40ace0.


It's compile tested, but not entirely checkpatch-clean:
	ERROR: code indent should use tabs where possible
	#3296: FILE: drivers/s390/net/lcs.c:1289:
	+        card = dev->priv;$

	ERROR: code indent should use tabs where possible
	#3363: FILE: drivers/s390/net/claw.c:1012:
	+        privptr = dev->priv;$

	ERROR: code indent should use tabs where possible
	#3372: FILE: drivers/s390/net/claw.c:1047:
	+        privptr = dev->priv;$

	ERROR: code indent should use tabs where possible
	#3540: FILE: drivers/s390/block/dasd_eckd.c:168:
	+        private = device->private;$

	total: 4 errors, 0 warnings, 4451 lines checked


I don't think it's a good idea to change the indent of single
lines just because of this warnings, that's why I let them as-is.

The script can be downloaded from
  http://kernelnewbies.org/KernelJanitors/Todo/VoidPointerConvs


diffstat | sort -k3 -n (and removed files with < 20 lines):
 ...
drivers/net/atarilance.c                     |   20 +++---
 net/atm/lec.c                                |   20 +++---
 drivers/net/ni52.c                           |   22 +++----
 drivers/net/3c523.c                          |   24 +++----
 drivers/net/mace.c                           |   24 +++----
 drivers/net/sun3_82586.c                     |   24 +++----
 drivers/net/ni65.c                           |   26 ++++----
 drivers/net/dm9000.c                         |   28 ++++-----
 drivers/s390/block/dasd_alias.c              |   28 ++++-----
 drivers/net/depca.c                          |   30 ++++-----
 drivers/message/i2o/i2o_proc.c               |   38 ++++++------
 drivers/s390/block/dasd_eckd.c               |   42 ++++++-------
 drivers/net/au1000_eth.c                     |   46 +++++++-------
 drivers/net/wan/sbni.c                       |   50 ++++++++--------
 drivers/net/wireless/zd1201.c                |   62 +++++++++----------
 drivers/net/wireless/wavelan.c               |   84 +++++++++++++--------------
 112 files changed, 553 insertions(+), 558 deletions(-)


There are some private structure variables that are not defined as (void*),
(but int or long) and cannot be done without a cast; examples in
	drivers/char/hw_random/intel-rng.c
	drivers/crypto/hifn_795x.c
	drivers/mtd/mtdblock.c
	drivers/mtd/mtdoops.c
	drivers/mtd/rfd_ftl.c
	fs/jffs2/erase.c

Should these be converted to (void*), and an additional patch supplied?


Regards,

Phil


-- 
Versioning your /etc, /home or even your whole installation?
             Try fsvs (fsvs.tigris.org)!

--Boundary-00=_CkuPIlo2oI1LROu
Content-Type: text/x-diff;
  charset="utf-8";
  name="voidp_vars.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="voidp_vars.patch"

---

Remove unneeded explicit casting from (void*) private structure members.

Signed-off-by: Ph. Marek <philipp@marek.priv.at>

--- linux-2.6.git/drivers/char/hw_random/geode-rng.c
+++ linux-2.6.git/drivers/char/hw_random/geode-rng.c
@@ -55,7 +55,7 @@ MODULE_DEVICE_TABLE(pci, pci_tbl);
 
 static int geode_rng_data_read(struct hwrng *rng, u32 *data)
 {
-	void __iomem *mem = (void __iomem *)rng->priv;
+	void __iomem *mem = rng->priv;
 
 	*data = readl(mem + GEODE_RNG_DATA_REG);
 
@@ -64,7 +64,7 @@ static int geode_rng_data_read(struct hw
 
 static int geode_rng_data_present(struct hwrng *rng, int wait)
 {
-	void __iomem *mem = (void __iomem *)rng->priv;
+	void __iomem *mem = rng->priv;
 	int data, i;
 
 	for (i = 0; i < 20; i++) {

--- linux-2.6.git/drivers/char/hw_random/ixp4xx-rng.c
+++ linux-2.6.git/drivers/char/hw_random/ixp4xx-rng.c
@@ -28,7 +28,7 @@
 
 static int ixp4xx_rng_data_read(struct hwrng *rng, u32 *buffer)
 {
-	void __iomem * rng_base = (void __iomem *)rng->priv;
+	void __iomem *rng_base = rng->priv;
 
 	*buffer = __raw_readl(rng_base);
 
--- linux-2.6.git/drivers/char/hw_random/pasemi-rng.c
+++ linux-2.6.git/drivers/char/hw_random/pasemi-rng.c
@@ -44,7 +44,7 @@
 
 static int pasemi_rng_data_present(struct hwrng *rng, int wait)
 {
-	void __iomem *rng_regs = (void __iomem *)rng->priv;
+	void __iomem *rng_regs = rng->priv;
 	int data, i;
 
 	for (i = 0; i < 20; i++) {
@@ -59,14 +59,14 @@ static int pasemi_rng_data_present(struc
 
 static int pasemi_rng_data_read(struct hwrng *rng, u32 *data)
 {
-	void __iomem *rng_regs = (void __iomem *)rng->priv;
+	void __iomem *rng_regs = rng->priv;
 	*data = in_le32(rng_regs + SDCRNG_VAL_REG);
 	return 4;
 }
 
 static int pasemi_rng_init(struct hwrng *rng)
 {
-	void __iomem *rng_regs = (void __iomem *)rng->priv;
+	void __iomem *rng_regs = rng->priv;
 	u32 ctl;
 
 	ctl = SDCRNG_CTL_DR | SDCRNG_CTL_SELECT_RRG_RNG | SDCRNG_CTL_KSZ;
@@ -78,7 +78,7 @@ static int pasemi_rng_init(struct hwrng 
 
 static void pasemi_rng_cleanup(struct hwrng *rng)
 {
-	void __iomem *rng_regs = (void __iomem *)rng->priv;
+	void __iomem *rng_regs = rng->priv;
 	u32 ctl;
 
 	ctl = SDCRNG_CTL_RE | SDCRNG_CTL_CE;
--- linux-2.6.git/drivers/net/ni65.c
+++ linux-2.6.git/drivers/net/ni65.c
@@ -295,7 +295,7 @@ static void ni65_set_performance(struct 
  */
 static int ni65_open(struct net_device *dev)
 {
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 	int irqval = request_irq(dev->irq, &ni65_interrupt,0,
                         cards[p->cardno].cardname,dev);
 	if (irqval) {
@@ -321,7 +321,7 @@ static int ni65_open(struct net_device *
  */
 static int ni65_close(struct net_device *dev)
 {
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 
 	netif_stop_queue(dev);
 
@@ -345,7 +345,7 @@ static int ni65_close(struct net_device 
 
 static void cleanup_card(struct net_device *dev)
 {
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 	disable_dma(dev->dma);
 	free_dma(dev->dma);
 	release_region(dev->base_addr, cards[p->cardno].total_size);
@@ -444,7 +444,7 @@ static int __init ni65_probe1(struct net
 		release_region(ioaddr, cards[i].total_size);
 		return j;
 	}
-	p = (struct priv *) dev->priv;
+	p = dev->priv;
 	p->cmdr_addr = ioaddr + cards[i].cmd_offset;
 	p->cardno = i;
 	spin_lock_init(&p->ring_lock);
@@ -790,7 +790,7 @@ static void ni65_stop_start(struct net_d
 static int ni65_lance_reinit(struct net_device *dev)
 {
 	 int i;
-	 struct priv *p = (struct priv *) dev->priv;
+	 struct priv *p = dev->priv;
 	 unsigned long flags;
 
 	 p->lock = 0;
@@ -876,7 +876,7 @@ static irqreturn_t ni65_interrupt(int ir
 	struct priv *p;
 	int bcnt = 32;
 
-	p = (struct priv *) dev->priv;
+	p = dev->priv;
 
 	spin_lock(&p->ring_lock);
 
@@ -899,7 +899,7 @@ static irqreturn_t ni65_interrupt(int ir
 
 		if(csr0 & CSR0_ERR)
 		{
-			struct priv *p = (struct priv *) dev->priv;
+			struct priv *p = dev->priv;
 			if(debuglevel > 1)
 				printk(KERN_ERR "%s: general error: %04x.\n",dev->name,csr0);
 			if(csr0 & CSR0_BABL)
@@ -924,7 +924,7 @@ static irqreturn_t ni65_interrupt(int ir
  int j;
  for(j=0;j<RMDNUM;j++)
  {
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 	int i,k,num1,num2;
 	for(i=RMDNUM-1;i>0;i--) {
 		 num2 = (p->rmdnum + i) & (RMDNUM-1);
@@ -982,7 +982,7 @@ static irqreturn_t ni65_interrupt(int ir
  */
 static void ni65_xmit_intr(struct net_device *dev,int csr0)
 {
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 
 	while(p->xmit_queued)
 	{
@@ -1049,7 +1049,7 @@ static void ni65_recv_intr(struct net_de
 	struct rmd *rmdp;
 	int rmdstat,len;
 	int cnt=0;
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 
 	rmdp = p->rmdhead + p->rmdnum;
 	while(!( (rmdstat = rmdp->u.s.status) & RCV_OWN))
@@ -1140,7 +1140,7 @@ static void ni65_recv_intr(struct net_de
 static void ni65_timeout(struct net_device *dev)
 {
 	int i;
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 
 	printk(KERN_ERR "%s: xmitter timed out, try to restart!\n",dev->name);
 	for(i=0;i<TMDNUM;i++)
@@ -1157,7 +1157,7 @@ static void ni65_timeout(struct net_devi
 
 static int ni65_send_packet(struct sk_buff *skb, struct net_device *dev)
 {
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 
 	netif_stop_queue(dev);
 
@@ -1222,7 +1222,7 @@ static struct net_device_stats *ni65_get
 
 #if 0
 	int i;
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 	for(i=0;i<RMDNUM;i++)
 	{
 		struct rmd *rmdp = p->rmdhead + ((p->rmdnum + i) & (RMDNUM-1));
--- linux-2.6.git/drivers/net/au1000_eth.c
+++ linux-2.6.git/drivers/net/au1000_eth.c
@@ -193,7 +193,7 @@ struct au1000_private *au_macs[NUM_ETH_I
  */
 static int mdio_read(struct net_device *dev, int phy_addr, int reg)
 {
-	struct au1000_private *aup = (struct au1000_private *) dev->priv;
+	struct au1000_private *aup = dev->priv;
 	volatile u32 *const mii_control_reg = &aup->mac->mii_control;
 	volatile u32 *const mii_data_reg = &aup->mac->mii_data;
 	u32 timedout = 20;
@@ -227,7 +227,7 @@ static int mdio_read(struct net_device *
 
 static void mdio_write(struct net_device *dev, int phy_addr, int reg, u16 value)
 {
-	struct au1000_private *aup = (struct au1000_private *) dev->priv;
+	struct au1000_private *aup = dev->priv;
 	volatile u32 *const mii_control_reg = &aup->mac->mii_control;
 	volatile u32 *const mii_data_reg = &aup->mac->mii_data;
 	u32 timedout = 20;
@@ -282,7 +282,7 @@ static int mdiobus_reset(struct mii_bus 
 
 static int mii_probe (struct net_device *dev)
 {
-	struct au1000_private *const aup = (struct au1000_private *) dev->priv;
+	struct au1000_private *const aup = dev->priv;
 	struct phy_device *phydev = NULL;
 
 #if defined(AU1XXX_PHY_STATIC_CONFIG)
@@ -414,7 +414,7 @@ void ReleaseDB(struct au1000_private *au
 
 static void enable_rx_tx(struct net_device *dev)
 {
-	struct au1000_private *aup = (struct au1000_private *) dev->priv;
+	struct au1000_private *aup = dev->priv;
 
 	if (au1000_debug > 4)
 		printk(KERN_INFO "%s: enable_rx_tx\n", dev->name);
@@ -425,7 +425,7 @@ static void enable_rx_tx(struct net_devi
 
 static void hard_stop(struct net_device *dev)
 {
-	struct au1000_private *aup = (struct au1000_private *) dev->priv;
+	struct au1000_private *aup = dev->priv;
 
 	if (au1000_debug > 4)
 		printk(KERN_INFO "%s: hard stop\n", dev->name);
@@ -437,7 +437,7 @@ static void hard_stop(struct net_device 
 static void enable_mac(struct net_device *dev, int force_reset)
 {
 	unsigned long flags;
-	struct au1000_private *aup = (struct au1000_private *) dev->priv;
+	struct au1000_private *aup = dev->priv;
 
 	spin_lock_irqsave(&aup->lock, flags);
 
@@ -456,7 +456,7 @@ static void enable_mac(struct net_device
 
 static void reset_mac_unlocked(struct net_device *dev)
 {
-	struct au1000_private *const aup = (struct au1000_private *) dev->priv;
+	struct au1000_private *const aup = dev->priv;
 	int i;
 
 	hard_stop(dev);
@@ -482,7 +482,7 @@ static void reset_mac_unlocked(struct ne
 
 static void reset_mac(struct net_device *dev)
 {
-	struct au1000_private *const aup = (struct au1000_private *) dev->priv;
+	struct au1000_private *const aup = dev->priv;
 	unsigned long flags;
 
 	if (au1000_debug > 4)
@@ -571,7 +571,7 @@ static int __init au1000_init_module(voi
 
 static int au1000_get_settings(struct net_device *dev, struct ethtool_cmd *cmd)
 {
-	struct au1000_private *aup = (struct au1000_private *)dev->priv;
+	struct au1000_private *aup = dev->priv;
 
 	if (aup->phy_dev)
 		return phy_ethtool_gset(aup->phy_dev, cmd);
@@ -581,7 +581,7 @@ static int au1000_get_settings(struct ne
 
 static int au1000_set_settings(struct net_device *dev, struct ethtool_cmd *cmd)
 {
-	struct au1000_private *aup = (struct au1000_private *)dev->priv;
+	struct au1000_private *aup = dev->priv;
 
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
@@ -595,7 +595,7 @@ static int au1000_set_settings(struct ne
 static void
 au1000_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
-	struct au1000_private *aup = (struct au1000_private *)dev->priv;
+	struct au1000_private *aup = dev->priv;
 
 	strcpy(info->driver, DRV_NAME);
 	strcpy(info->version, DRV_VERSION);
@@ -806,7 +806,7 @@ err_out:
  */
 static int au1000_init(struct net_device *dev)
 {
-	struct au1000_private *aup = (struct au1000_private *) dev->priv;
+	struct au1000_private *aup = dev->priv;
 	u32 flags;
 	int i;
 	u32 control;
@@ -857,7 +857,7 @@ static int au1000_init(struct net_device
 static void
 au1000_adjust_link(struct net_device *dev)
 {
-	struct au1000_private *aup = (struct au1000_private *) dev->priv;
+	struct au1000_private *aup = dev->priv;
 	struct phy_device *phydev = aup->phy_dev;
 	unsigned long flags;
 
@@ -937,7 +937,7 @@ au1000_adjust_link(struct net_device *de
 static int au1000_open(struct net_device *dev)
 {
 	int retval;
-	struct au1000_private *aup = (struct au1000_private *) dev->priv;
+	struct au1000_private *aup = dev->priv;
 
 	if (au1000_debug > 4)
 		printk("%s: open: dev=%p\n", dev->name, dev);
@@ -972,7 +972,7 @@ static int au1000_open(struct net_device
 static int au1000_close(struct net_device *dev)
 {
 	unsigned long flags;
-	struct au1000_private *const aup = (struct au1000_private *) dev->priv;
+	struct au1000_private *const aup = dev->priv;
 
 	if (au1000_debug > 4)
 		printk("%s: close: dev=%p\n", dev->name, dev);
@@ -1003,7 +1003,7 @@ static void __exit au1000_cleanup_module
 	for (i = 0; i < num_ifs; i++) {
 		dev = iflist[i].dev;
 		if (dev) {
-			aup = (struct au1000_private *) dev->priv;
+			aup = dev->priv;
 			unregister_netdev(dev);
 			for (j = 0; j < NUM_RX_DMA; j++)
 				if (aup->rx_db_inuse[j])
@@ -1023,7 +1023,7 @@ static void __exit au1000_cleanup_module
 
 static void update_tx_stats(struct net_device *dev, u32 status)
 {
-	struct au1000_private *aup = (struct au1000_private *) dev->priv;
+	struct au1000_private *aup = dev->priv;
 	struct net_device_stats *ps = &dev->stats;
 
 	if (status & TX_FRAME_ABORTED) {
@@ -1052,7 +1052,7 @@ static void update_tx_stats(struct net_d
  */
 static void au1000_tx_ack(struct net_device *dev)
 {
-	struct au1000_private *aup = (struct au1000_private *) dev->priv;
+	struct au1000_private *aup = dev->priv;
 	volatile tx_dma_t *ptxd;
 
 	ptxd = aup->tx_dma_ring[aup->tx_tail];
@@ -1079,7 +1079,7 @@ static void au1000_tx_ack(struct net_dev
  */
 static int au1000_tx(struct sk_buff *skb, struct net_device *dev)
 {
-	struct au1000_private *aup = (struct au1000_private *) dev->priv;
+	struct au1000_private *aup = dev->priv;
 	struct net_device_stats *ps = &dev->stats;
 	volatile tx_dma_t *ptxd;
 	u32 buff_stat;
@@ -1133,7 +1133,7 @@ static int au1000_tx(struct sk_buff *skb
 
 static inline void update_rx_stats(struct net_device *dev, u32 status)
 {
-	struct au1000_private *aup = (struct au1000_private *) dev->priv;
+	struct au1000_private *aup = dev->priv;
 	struct net_device_stats *ps = &dev->stats;
 
 	ps->rx_packets++;
@@ -1161,7 +1161,7 @@ static inline void update_rx_stats(struc
  */
 static int au1000_rx(struct net_device *dev)
 {
-	struct au1000_private *aup = (struct au1000_private *) dev->priv;
+	struct au1000_private *aup = dev->priv;
 	struct sk_buff *skb;
 	volatile rx_dma_t *prxd;
 	u32 buff_stat, status;
@@ -1269,7 +1269,7 @@ static void au1000_tx_timeout(struct net
 
 static void set_rx_mode(struct net_device *dev)
 {
-	struct au1000_private *aup = (struct au1000_private *) dev->priv;
+	struct au1000_private *aup = dev->priv;
 
 	if (au1000_debug > 4)
 		printk("%s: set_rx_mode: flags=%x\n", dev->name, dev->flags);
@@ -1301,7 +1301,7 @@ static void set_rx_mode(struct net_devic
 
 static int au1000_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 {
-	struct au1000_private *aup = (struct au1000_private *)dev->priv;
+	struct au1000_private *aup = dev->priv;
 
 	if (!netif_running(dev)) return -EINVAL;
 
--- linux-2.6.git/drivers/net/wan/lmc/lmc_main.c
+++ linux-2.6.git/drivers/net/wan/lmc/lmc_main.c
@@ -1166,7 +1166,7 @@ static int lmc_open (struct net_device *
 static void lmc_running_reset (struct net_device *dev) /*fold00*/
 {
 
-    lmc_softc_t *sc = (lmc_softc_t *) dev->priv;
+    lmc_softc_t *sc = dev->priv;
 
     lmc_trace(dev, "lmc_runnig_reset in");
 
--- linux-2.6.git/drivers/net/wan/cycx_x25.c
+++ linux-2.6.git/drivers/net/wan/cycx_x25.c
@@ -1302,7 +1302,7 @@ static struct net_device *cycx_x25_get_d
 	struct cycx_x25_channel *chan;
 
 	while (dev) {
-		chan = (struct cycx_x25_channel*)dev->priv;
+		chan = dev->priv;
 
 		if (chan->lcn == lcn)
 			break;
@@ -1319,7 +1319,7 @@ static struct net_device *
 	struct cycx_x25_channel *chan;
 
 	while (dev) {
-		chan = (struct cycx_x25_channel*)dev->priv;
+		chan = dev->priv;
 
 		if (!strcmp(chan->addr, dte))
 			break;
--- linux-2.6.git/drivers/net/wan/dlci.c
+++ linux-2.6.git/drivers/net/wan/dlci.c
@@ -391,7 +391,7 @@ static int dlci_add(struct dlci_add *dlc
 
 	*(short *)(master->dev_addr) = dlci->dlci;
 
-	dlp = (struct dlci_local *) master->priv;
+	dlp = master->priv;
 	dlp->slave = slave;
 	dlp->master = master;
 
--- linux-2.6.git/drivers/net/wan/sbni.c
+++ linux-2.6.git/drivers/net/wan/sbni.c
@@ -447,7 +447,7 @@ sbni_start_xmit( struct sk_buff  *skb,  
 
 	/* Looking for idle device in the list */
 	for( p = dev;  p; ) {
-		struct net_local  *nl = (struct net_local *) p->priv;
+		struct net_local  *nl = p->priv;
 		spin_lock( &nl->lock );
 		if( nl->tx_buf_p  ||  (nl->state & FL_LINE_DOWN) ) {
 			p = nl->link;
@@ -469,7 +469,7 @@ sbni_start_xmit( struct sk_buff  *skb,  
 static int
 sbni_start_xmit( struct sk_buff  *skb,  struct net_device  *dev )
 {
-	struct net_local  *nl  = (struct net_local *) dev->priv;
+	struct net_local  *nl  = dev->priv;
 
 	netif_stop_queue( dev );
 	spin_lock( &nl->lock );
@@ -531,7 +531,7 @@ sbni_interrupt( int  irq,  void  *dev_id
 static void
 handle_channel( struct net_device  *dev )
 {
-	struct net_local	*nl    = (struct net_local *) dev->priv;
+	struct net_local	*nl    = dev->priv;
 	unsigned long		ioaddr = dev->base_addr;
 
 	int  req_ans;
@@ -589,7 +589,7 @@ handle_channel( struct net_device  *dev 
 static int
 recv_frame( struct net_device  *dev )
 {
-	struct net_local  *nl   = (struct net_local *) dev->priv;
+	struct net_local  *nl   = dev->priv;
 	unsigned long  ioaddr	= dev->base_addr;
 
 	u32  crc = CRC32_INITIAL;
@@ -623,7 +623,7 @@ recv_frame( struct net_device  *dev )
 static void
 send_frame( struct net_device  *dev )
 {
-	struct net_local  *nl    = (struct net_local *) dev->priv;
+	struct net_local  *nl    = dev->priv;
 
 	u32  crc = CRC32_INITIAL;
 
@@ -680,7 +680,7 @@ do_send:
 static void
 download_data( struct net_device  *dev,  u32  *crc_p )
 {
-	struct net_local  *nl    = (struct net_local *) dev->priv;
+	struct net_local  *nl    = dev->priv;
 	struct sk_buff    *skb	 = nl->tx_buf_p;
 
 	unsigned  len = min_t(unsigned int, skb->len - nl->outpos, nl->framelen);
@@ -699,7 +699,7 @@ static int
 upload_data( struct net_device  *dev,  unsigned  framelen,  unsigned  frameno,
 	     unsigned  is_first,  u32  crc )
 {
-	struct net_local  *nl = (struct net_local *) dev->priv;
+	struct net_local  *nl = dev->priv;
 
 	int  frame_ok;
 
@@ -775,7 +775,7 @@ send_complete( struct net_local  *nl )
 static void
 interpret_ack( struct net_device  *dev,  unsigned  ack )
 {
-	struct net_local  *nl = (struct net_local *) dev->priv;
+	struct net_local  *nl = dev->priv;
 
 	if( ack == FRAME_SENT_OK ) {
 		nl->state &= ~FL_NEED_RESEND;
@@ -809,7 +809,7 @@ interpret_ack( struct net_device  *dev, 
 static int
 append_frame_to_pkt( struct net_device  *dev,  unsigned  framelen,  u32  crc )
 {
-	struct net_local  *nl = (struct net_local *) dev->priv;
+	struct net_local  *nl = dev->priv;
 
 	u8  *p;
 
@@ -840,7 +840,7 @@ append_frame_to_pkt( struct net_device  
 static void
 prepare_to_send( struct sk_buff  *skb,  struct net_device  *dev )
 {
-	struct net_local  *nl = (struct net_local *) dev->priv;
+	struct net_local  *nl = dev->priv;
 
 	unsigned int  len;
 
@@ -871,7 +871,7 @@ prepare_to_send( struct sk_buff  *skb,  
 static void
 drop_xmit_queue( struct net_device  *dev )
 {
-	struct net_local  *nl = (struct net_local *) dev->priv;
+	struct net_local  *nl = dev->priv;
 
 	if( nl->tx_buf_p )
 		dev_kfree_skb_any( nl->tx_buf_p ),
@@ -903,7 +903,7 @@ drop_xmit_queue( struct net_device  *dev
 static void
 send_frame_header( struct net_device  *dev,  u32  *crc_p )
 {
-	struct net_local  *nl  = (struct net_local *) dev->priv;
+	struct net_local  *nl  = dev->priv;
 
 	u32  crc = *crc_p;
 	u32  len_field = nl->framelen + 6;	/* CRC + frameno + reserved */
@@ -1005,7 +1005,7 @@ get_rx_buf( struct net_device  *dev )
 static void
 indicate_pkt( struct net_device  *dev )
 {
-	struct net_local  *nl  = (struct net_local *) dev->priv;
+	struct net_local  *nl  = dev->priv;
 	struct sk_buff    *skb = nl->rx_buf_p;
 
 	skb_put( skb, nl->inppos );
@@ -1038,7 +1038,7 @@ static void
 sbni_watchdog( unsigned long  arg )
 {
 	struct net_device  *dev = (struct net_device *) arg;
-	struct net_local   *nl  = (struct net_local *) dev->priv;
+	struct net_local   *nl  = dev->priv;
 	struct timer_list  *w   = &nl->watchdog; 
 	unsigned long	   flags;
 	unsigned char	   csr0;
@@ -1091,7 +1091,7 @@ static unsigned char  timeout_rxl_tab[] 
 static void
 card_start( struct net_device  *dev )
 {
-	struct net_local  *nl = (struct net_local *) dev->priv;
+	struct net_local  *nl = dev->priv;
 
 	nl->timer_ticks = CHANGE_LEVEL_START_TICKS;
 	nl->state &= ~(FL_WAIT_ACK | FL_NEED_RESEND);
@@ -1113,7 +1113,7 @@ card_start( struct net_device  *dev )
 static void
 change_level( struct net_device  *dev )
 {
-	struct net_local  *nl = (struct net_local *) dev->priv;
+	struct net_local  *nl = dev->priv;
 
 	if( nl->delta_rxl == 0 )	/* do not auto-negotiate RxL */
 		return;
@@ -1137,7 +1137,7 @@ change_level( struct net_device  *dev )
 static void
 timeout_change_level( struct net_device  *dev )
 {
-	struct net_local  *nl = (struct net_local *) dev->priv;
+	struct net_local  *nl = dev->priv;
 
 	nl->cur_rxl_index = timeout_rxl_tab[ nl->timeout_rxl ];
 	if( ++nl->timeout_rxl >= 4 )
@@ -1160,7 +1160,7 @@ timeout_change_level( struct net_device 
 static int
 sbni_open( struct net_device  *dev )
 {
-	struct net_local	*nl = (struct net_local *) dev->priv;
+	struct net_local	*nl = dev->priv;
 	struct timer_list	*w  = &nl->watchdog;
 
 	/*
@@ -1216,7 +1216,7 @@ handler_attached:
 static int
 sbni_close( struct net_device  *dev )
 {
-	struct net_local  *nl = (struct net_local *) dev->priv;
+	struct net_local  *nl = dev->priv;
 
 	if( nl->second  &&  nl->second->flags & IFF_UP ) {
 		printk( KERN_NOTICE "Secondary channel (%s) is active!\n",
@@ -1300,7 +1300,7 @@ sbni_card_probe( unsigned long  ioaddr )
 static int
 sbni_ioctl( struct net_device  *dev,  struct ifreq  *ifr,  int  cmd )
 {
-	struct net_local  *nl = (struct net_local *) dev->priv; 
+	struct net_local  *nl = dev->priv;
 	struct sbni_flags  flags;
 	int  error = 0;
 
@@ -1390,8 +1390,8 @@ sbni_ioctl( struct net_device  *dev,  st
 static int
 enslave( struct net_device  *dev,  struct net_device  *slave_dev )
 {
-	struct net_local  *nl  = (struct net_local *) dev->priv;
-	struct net_local  *snl = (struct net_local *) slave_dev->priv;
+	struct net_local  *nl  = dev->priv;
+	struct net_local  *snl = slave_dev->priv;
 
 	if( nl->state & FL_SLAVE )	/* This isn't master or free device */
 		return  -EBUSY;
@@ -1425,9 +1425,9 @@ enslave( struct net_device  *dev,  struc
 static int
 emancipate( struct net_device  *dev )
 {
-	struct net_local   *snl = (struct net_local *) dev->priv;
+	struct net_local   *snl = dev->priv;
 	struct net_device  *p   = snl->master;
-	struct net_local   *nl  = (struct net_local *) p->priv;
+	struct net_local   *nl  = p->priv;
 
 	if( !(snl->state & FL_SLAVE) )
 		return  -EINVAL;
@@ -1438,7 +1438,7 @@ emancipate( struct net_device  *dev )
 
 	/* exclude from list */
 	for(;;) {	/* must be in list */
-		struct net_local  *t = (struct net_local *) p->priv;
+		struct net_local  *t = p->priv;
 		if( t->link == dev ) {
 			t->link = snl->link;
 			break;
--- linux-2.6.git/drivers/net/wan/pc300_drv.c
+++ linux-2.6.git/drivers/net/wan/pc300_drv.c
@@ -1772,7 +1772,7 @@ cpc_trace(struct net_device *dev, struct
 
 static void cpc_tx_timeout(struct net_device *dev)
 {
-	pc300dev_t *d = (pc300dev_t *) dev->priv;
+	pc300dev_t *d = dev->priv;
 	pc300ch_t *chan = (pc300ch_t *) d->chan;
 	pc300_t *card = (pc300_t *) chan->card;
 	struct net_device_stats *stats = hdlc_stats(dev);
@@ -1800,7 +1800,7 @@ static void cpc_tx_timeout(struct net_de
 
 static int cpc_queue_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	pc300dev_t *d = (pc300dev_t *) dev->priv;
+	pc300dev_t *d = dev->priv;
 	pc300ch_t *chan = (pc300ch_t *) d->chan;
 	pc300_t *card = (pc300_t *) chan->card;
 	struct net_device_stats *stats = hdlc_stats(dev);
@@ -1883,7 +1883,7 @@ static int cpc_queue_xmit(struct sk_buff
 
 static void cpc_net_rx(struct net_device *dev)
 {
-	pc300dev_t *d = (pc300dev_t *) dev->priv;
+	pc300dev_t *d = dev->priv;
 	pc300ch_t *chan = (pc300ch_t *) d->chan;
 	pc300_t *card = (pc300_t *) chan->card;
 	struct net_device_stats *stats = hdlc_stats(dev);
@@ -2533,7 +2533,7 @@ static int cpc_change_mtu(struct net_dev
 
 static int cpc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
-	pc300dev_t *d = (pc300dev_t *) dev->priv;
+	pc300dev_t *d = dev->priv;
 	pc300ch_t *chan = (pc300ch_t *) d->chan;
 	pc300_t *card = (pc300_t *) chan->card;
 	pc300conf_t conf_aux;
@@ -3074,7 +3074,7 @@ static int tx_config(pc300dev_t * d)
 static int cpc_attach(struct net_device *dev, unsigned short encoding,
 		      unsigned short parity)
 {
-	pc300dev_t *d = (pc300dev_t *)dev->priv;
+	pc300dev_t *d = dev->priv;
 	pc300ch_t *chan = (pc300ch_t *)d->chan;
 	pc300_t *card = (pc300_t *)chan->card;
 	pc300chconf_t *conf = (pc300chconf_t *)&chan->conf;
@@ -3154,7 +3154,7 @@ static void cpc_closech(pc300dev_t * d)
 
 int cpc_open(struct net_device *dev)
 {
-	pc300dev_t *d = (pc300dev_t *) dev->priv;
+	pc300dev_t *d = dev->priv;
 	struct ifreq ifr;
 	int result;
 
@@ -3191,7 +3191,7 @@ err_out:
 
 static int cpc_close(struct net_device *dev)
 {
-	pc300dev_t *d = (pc300dev_t *) dev->priv;
+	pc300dev_t *d = dev->priv;
 	pc300ch_t *chan = (pc300ch_t *) d->chan;
 	pc300_t *card = (pc300_t *) chan->card;
 	unsigned long flags;
--- linux-2.6.git/drivers/net/lp486e.c
+++ linux-2.6.git/drivers/net/lp486e.c
@@ -390,7 +390,7 @@ i596_timeout(struct net_device *dev, cha
 	struct i596_private *lp;
 	int boguscnt = ct;
 
-	lp = (struct i596_private *) dev->priv;
+	lp = dev->priv;
 	while (lp->scb.command) {
 		if (--boguscnt == 0) {
 			printk("%s: %s timed out - stat %4.4x, cmd %4.4x\n",
@@ -411,7 +411,7 @@ init_rx_bufs(struct net_device *dev, int
 	int i;
 	// struct i596_rbd *rbd;
 
-	lp = (struct i596_private *) dev->priv;
+	lp = dev->priv;
 	lp->scb.pa_rfd = I596_NULL;
 
 	for (i = 0; i < num; i++) {
@@ -468,7 +468,7 @@ remove_rx_bufs(struct net_device *dev) {
 	struct i596_private *lp;
 	struct i596_rfd *rfd;
 
-	lp = (struct i596_private *) dev->priv;
+	lp = dev->priv;
 	lp->rx_tail->pa_next = I596_NULL;
 
 	do {
@@ -622,7 +622,7 @@ init_i596(struct net_device *dev) {
 	if (i596_scp_setup(dev))
 		return 1;
 
-	lp = (struct i596_private *) dev->priv;
+	lp = dev->priv;
 	lp->scb.command = 0;
 
 	memcpy ((void *)lp->i596_config, init_setup, 14);
@@ -705,7 +705,7 @@ i596_rx_one(struct net_device *dev, stru
 
 static int
 i596_rx(struct net_device *dev) {
-	struct i596_private *lp = (struct i596_private *) dev->priv;
+	struct i596_private *lp = dev->priv;
 	struct i596_rfd *rfd;
 	int frames = 0;
 
@@ -738,7 +738,7 @@ i596_cleanup_cmd(struct net_device *dev)
 	struct i596_private *lp;
 	struct i596_cmd *cmd;
 
-	lp = (struct i596_private *) dev->priv;
+	lp = dev->priv;
 	while (lp->cmd_head) {
 		cmd = (struct i596_cmd *)lp->cmd_head;
 
@@ -970,7 +970,7 @@ static int __init lp486e_probe(struct ne
 		return -EBUSY;
 	}
 
-	lp = (struct i596_private *) dev->priv;
+	lp = dev->priv;
 	spin_lock_init(&lp->cmd_lock);
 
 	/*
--- linux-2.6.git/drivers/net/ni52.c
+++ linux-2.6.git/drivers/net/ni52.c
@@ -354,7 +354,7 @@ Enodev:
  */
 static void alloc586(struct net_device *dev)
 {
-	struct priv *p =	(struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 
 	ni_reset586();
 	mdelay(32);
@@ -588,7 +588,7 @@ static int init586(struct net_device *de
 {
 	void __iomem *ptr;
 	int i, result = 0;
-	struct priv *p = (struct priv *)dev->priv;
+	struct priv *p = dev->priv;
 	struct configure_cmd_struct __iomem *cfg_cmd;
 	struct iasetup_cmd_struct __iomem *ias_cmd;
 	struct tdr_cmd_struct __iomem *tdr_cmd;
@@ -829,7 +829,7 @@ static void __iomem *alloc_rfa(struct ne
 	struct rfd_struct __iomem *rfd = ptr;
 	struct rbd_struct __iomem *rbd;
 	int i;
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 
 	memset_io(rfd, 0,
 		sizeof(struct rfd_struct) * (p->num_recv_buffs + rfdadd));
@@ -878,7 +878,7 @@ static irqreturn_t ni52_interrupt(int ir
 	int cnt = 0;
 	struct priv *p;
 
-	p = (struct priv *) dev->priv;
+	p = dev->priv;
 
 	if (debuglevel > 1)
 		printk("I");
@@ -950,7 +950,7 @@ static void ni52_rcv_int(struct net_devi
 	unsigned short totlen;
 	struct sk_buff *skb;
 	struct rbd_struct __iomem *rbd;
-	struct priv *p = (struct priv *)dev->priv;
+	struct priv *p = dev->priv;
 
 	if (debuglevel > 0)
 		printk("R");
@@ -1040,7 +1040,7 @@ static void ni52_rcv_int(struct net_devi
 
 static void ni52_rnr_int(struct net_device *dev)
 {
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 
 	p->stats.rx_errors++;
 
@@ -1065,7 +1065,7 @@ static void ni52_rnr_int(struct net_devi
 static void ni52_xmt_int(struct net_device *dev)
 {
 	int status;
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 
 	if (debuglevel > 0)
 		printk("X");
@@ -1113,7 +1113,7 @@ static void ni52_xmt_int(struct net_devi
 
 static void startrecv586(struct net_device *dev)
 {
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 
 	wait_for_scb_cmd(dev);
 	wait_for_scb_cmd_ruc(dev);
@@ -1126,7 +1126,7 @@ static void startrecv586(struct net_devi
 
 static void ni52_timeout(struct net_device *dev)
 {
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 #ifndef NO_NOPCOMMANDS
 	if (readb(&p->scb->cus) & CU_ACTIVE) { /* COMMAND-UNIT active? */
 		netif_wake_queue(dev);
@@ -1177,7 +1177,7 @@ static int ni52_send_packet(struct sk_bu
 #ifndef NO_NOPCOMMANDS
 	int next_nop;
 #endif
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 
 	if (skb->len > XMIT_BUFF_SIZE) {
 		printk(KERN_ERR "%s: Sorry, max. framelength is %d bytes. The length of your frame is %d bytes.\n", dev->name, XMIT_BUFF_SIZE, skb->len);
@@ -1274,7 +1274,7 @@ static int ni52_send_packet(struct sk_bu
 
 static struct net_device_stats *ni52_get_stats(struct net_device *dev)
 {
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 	unsigned short crc, aln, rsc, ovrn;
 
 	/* Get error-statistics from the ni82586 */
--- linux-2.6.git/drivers/net/arcnet/capmode.c
+++ linux-2.6.git/drivers/net/arcnet/capmode.c
@@ -103,7 +103,7 @@ MODULE_LICENSE("GPL");
 static void rx(struct net_device *dev, int bufnum,
 	       struct archdr *pkthdr, int length)
 {
-	struct arcnet_local *lp = (struct arcnet_local *) dev->priv;
+	struct arcnet_local *lp = dev->priv;
 	struct sk_buff *skb;
 	struct archdr *pkt = pkthdr;
 	char *pktbuf, *pkthdrbuf;
@@ -198,7 +198,7 @@ static int build_header(struct sk_buff *
 static int prepare_tx(struct net_device *dev, struct archdr *pkt, int length,
 		      int bufnum)
 {
-	struct arcnet_local *lp = (struct arcnet_local *) dev->priv;
+	struct arcnet_local *lp = dev->priv;
 	struct arc_hardware *hard = &pkt->hard;
 	int ofs;
 
@@ -250,7 +250,7 @@ static int prepare_tx(struct net_device 
 
 static int ack_tx(struct net_device *dev, int acked)
 {
-  struct arcnet_local *lp = (struct arcnet_local *) dev->priv;
+  struct arcnet_local *lp = dev->priv;
   struct sk_buff *ackskb;
   struct archdr *ackpkt;
   int length=sizeof(struct arc_cap);
--- linux-2.6.git/drivers/net/arcnet/arcnet.c
+++ linux-2.6.git/drivers/net/arcnet/arcnet.c
@@ -357,7 +357,7 @@ struct net_device *alloc_arcdev(char *na
 	dev = alloc_netdev(sizeof(struct arcnet_local),
 			   name && *name ? name : "arc%d", arcdev_setup);
 	if(dev) {
-		struct arcnet_local *lp = (struct arcnet_local *) dev->priv;
+		struct arcnet_local *lp = dev->priv;
 		spin_lock_init(&lp->lock);
 	}
 
--- linux-2.6.git/drivers/net/wireless/wavelan_cs.c
+++ linux-2.6.git/drivers/net/wireless/wavelan_cs.c
@@ -3895,7 +3895,7 @@ wv_hw_reset(struct net_device *	dev)
 static int
 wv_pcmcia_config(struct pcmcia_device *	link)
 {
-  struct net_device *	dev = (struct net_device *) link->priv;
+  struct net_device *	dev = link->priv;
   int			i;
   win_req_t		req;
   memreq_t		mem;
@@ -4013,7 +4013,7 @@ wv_pcmcia_config(struct pcmcia_device *	
 static void
 wv_pcmcia_release(struct pcmcia_device *link)
 {
-	struct net_device *	dev = (struct net_device *) link->priv;
+	struct net_device *	dev = link->priv;
 	net_local *		lp = netdev_priv(dev);
 
 #ifdef DEBUG_CONFIG_TRACE
@@ -4596,7 +4596,7 @@ wavelan_detach(struct pcmcia_device *lin
   /* Free pieces */
   if(link->priv)
     {
-      struct net_device *	dev = (struct net_device *) link->priv;
+      struct net_device *dev = link->priv;
 
       /* Remove ourselves from the kernel list of ethernet devices */
       /* Warning : can't be called from interrupt, timer or wavelan_close() */
@@ -4615,7 +4615,7 @@ wavelan_detach(struct pcmcia_device *lin
 
 static int wavelan_suspend(struct pcmcia_device *link)
 {
-	struct net_device *	dev = (struct net_device *) link->priv;
+	struct net_device *dev = link->priv;
 
 	/* NB: wavelan_close will be called, but too late, so we are
 	 * obliged to close nicely the wavelan here. David, could you
@@ -4637,7 +4637,7 @@ static int wavelan_suspend(struct pcmcia
 
 static int wavelan_resume(struct pcmcia_device *link)
 {
-	struct net_device *	dev = (struct net_device *) link->priv;
+	struct net_device *dev = link->priv;
 
 	if (link->open) {
 		wv_hw_reset(dev);
--- linux-2.6.git/drivers/net/wireless/hostap/hostap_cs.c
+++ linux-2.6.git/drivers/net/wireless/hostap/hostap_cs.c
@@ -773,7 +773,7 @@ static void prism2_release(u_long arg)
 
 static int hostap_cs_suspend(struct pcmcia_device *link)
 {
-	struct net_device *dev = (struct net_device *) link->priv;
+	struct net_device *dev = link->priv;
 	int dev_open = 0;
 	struct hostap_interface *iface = NULL;
 
@@ -794,7 +794,7 @@ static int hostap_cs_suspend(struct pcmc
 
 static int hostap_cs_resume(struct pcmcia_device *link)
 {
-	struct net_device *dev = (struct net_device *) link->priv;
+	struct net_device *dev = link->priv;
 	int dev_open = 0;
 	struct hostap_interface *iface = NULL;
 
--- linux-2.6.git/drivers/net/wireless/libertas/ethtool.c
+++ linux-2.6.git/drivers/net/wireless/libertas/ethtool.c
@@ -23,7 +23,7 @@ static const char * mesh_stat_strings[]=
 static void lbs_ethtool_get_drvinfo(struct net_device *dev,
 					 struct ethtool_drvinfo *info)
 {
-	struct lbs_private *priv = (struct lbs_private *) dev->priv;
+	struct lbs_private *priv = dev->priv;
 
 	snprintf(info->fw_version, 32, "%u.%u.%u.p%u",
 		priv->fwrelease >> 24 & 0xff,
@@ -47,7 +47,7 @@ static int lbs_ethtool_get_eeprom_len(st
 static int lbs_ethtool_get_eeprom(struct net_device *dev,
                                   struct ethtool_eeprom *eeprom, u8 * bytes)
 {
-	struct lbs_private *priv = (struct lbs_private *) dev->priv;
+	struct lbs_private *priv = dev->priv;
 	struct cmd_ds_802_11_eeprom_access cmd;
 	int ret;
 
--- linux-2.6.git/drivers/net/wireless/libertas/if_usb.c
+++ linux-2.6.git/drivers/net/wireless/libertas/if_usb.c
@@ -264,7 +264,7 @@ error:
 static void if_usb_disconnect(struct usb_interface *intf)
 {
 	struct if_usb_card *cardp = usb_get_intfdata(intf);
-	struct lbs_private *priv = (struct lbs_private *) cardp->priv;
+	struct lbs_private *priv = cardp->priv;
 
 	lbs_deb_enter(LBS_DEB_MAIN);
 
--- linux-2.6.git/drivers/net/wireless/libertas/main.c
+++ linux-2.6.git/drivers/net/wireless/libertas/main.c
@@ -391,7 +391,7 @@ static struct attribute_group lbs_mesh_a
  */
 static int lbs_dev_open(struct net_device *dev)
 {
-	struct lbs_private *priv = (struct lbs_private *) dev->priv ;
+	struct lbs_private *priv = dev->priv ;
 	int ret = 0;
 
 	lbs_deb_enter(LBS_DEB_NET);
@@ -458,7 +458,7 @@ static int lbs_mesh_stop(struct net_devi
  */
 static int lbs_eth_stop(struct net_device *dev)
 {
-	struct lbs_private *priv = (struct lbs_private *) dev->priv;
+	struct lbs_private *priv = dev->priv;
 
 	lbs_deb_enter(LBS_DEB_NET);
 
@@ -473,7 +473,7 @@ static int lbs_eth_stop(struct net_devic
 
 static void lbs_tx_timeout(struct net_device *dev)
 {
-	struct lbs_private *priv = (struct lbs_private *) dev->priv;
+	struct lbs_private *priv = dev->priv;
 
 	lbs_deb_enter(LBS_DEB_TX);
 
@@ -525,7 +525,7 @@ EXPORT_SYMBOL_GPL(lbs_host_to_card_done)
  */
 static struct net_device_stats *lbs_get_stats(struct net_device *dev)
 {
-	struct lbs_private *priv = (struct lbs_private *) dev->priv;
+	struct lbs_private *priv = dev->priv;
 
 	lbs_deb_enter(LBS_DEB_NET);
 	return &priv->stats;
@@ -534,7 +534,7 @@ static struct net_device_stats *lbs_get_
 static int lbs_set_mac_address(struct net_device *dev, void *addr)
 {
 	int ret = 0;
-	struct lbs_private *priv = (struct lbs_private *) dev->priv;
+	struct lbs_private *priv = dev->priv;
 	struct sockaddr *phwaddr = addr;
 	struct cmd_ds_802_11_mac_address cmd;
 
--- linux-2.6.git/drivers/net/wireless/airo.c
+++ linux-2.6.git/drivers/net/wireless/airo.c
@@ -7527,7 +7527,7 @@ static const struct iw_handler_def	airo_
 static int airo_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 {
 	int rc = 0;
-	struct airo_info *ai = (struct airo_info *)dev->priv;
+	struct airo_info *ai = dev->priv;
 
 	if (ai->power.event)
 		return 0;
--- linux-2.6.git/drivers/net/wireless/ray_cs.c
+++ linux-2.6.git/drivers/net/wireless/ray_cs.c
@@ -412,7 +412,7 @@ static int ray_config(struct pcmcia_devi
     int i;
     win_req_t req;
     memreq_t mem;
-    struct net_device *dev = (struct net_device *)link->priv;
+    struct net_device *dev = link->priv;
     ray_dev_t *local = netdev_priv(dev);
     DECLARE_MAC_BUF(mac);
 
@@ -2600,7 +2600,7 @@ static int ray_cs_proc_show(struct seq_f
     link = this_device;
     if (!link)
     	return 0;
-    dev = (struct net_device *)link->priv;
+    dev = link->priv;
     if (!dev)
     	return 0;
     local = netdev_priv(dev);
--- linux-2.6.git/drivers/net/wireless/zd1201.c
+++ linux-2.6.git/drivers/net/wireless/zd1201.c
@@ -745,7 +745,7 @@ static int zd1201_join(struct zd1201 *zd
 
 static int zd1201_net_open(struct net_device *dev)
 {
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 
 	/* Start MAC with wildcard if no essid set */
 	if (!zd->mac_enabled)
@@ -783,7 +783,7 @@ static int zd1201_net_stop(struct net_de
  */
 static int zd1201_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 	unsigned char *txbuf = zd->txdata;
 	int txbuflen, pad = 0, err;
 	struct urb *urb = zd->tx_urb;
@@ -833,7 +833,7 @@ static int zd1201_hard_start_xmit(struct
 
 static void zd1201_tx_timeout(struct net_device *dev)
 {
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 
 	if (!zd)
 		return;
@@ -848,7 +848,7 @@ static void zd1201_tx_timeout(struct net
 static int zd1201_set_mac_address(struct net_device *dev, void *p)
 {
 	struct sockaddr *addr = p;
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 	int err;
 
 	if (!zd)
@@ -865,21 +865,21 @@ static int zd1201_set_mac_address(struct
 
 static struct net_device_stats *zd1201_get_stats(struct net_device *dev)
 {
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 
 	return &zd->stats;
 }
 
 static struct iw_statistics *zd1201_get_wireless_stats(struct net_device *dev)
 {
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 
 	return &zd->iwstats;
 }
 
 static void zd1201_set_multicast(struct net_device *dev)
 {
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 	struct dev_mc_list *mc = dev->mc_list;
 	unsigned char reqbuf[ETH_ALEN*ZD1201_MAXMULTI];
 	int i;
@@ -899,7 +899,7 @@ static void zd1201_set_multicast(struct 
 static int zd1201_config_commit(struct net_device *dev, 
     struct iw_request_info *info, struct iw_point *data, char *essid)
 {
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 
 	return zd1201_mac_reset(zd);
 }
@@ -914,7 +914,7 @@ static int zd1201_get_name(struct net_de
 static int zd1201_set_freq(struct net_device *dev,
     struct iw_request_info *info, struct iw_freq *freq, char *extra)
 {
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 	short channel = 0;
 	int err;
 
@@ -939,7 +939,7 @@ static int zd1201_set_freq(struct net_de
 static int zd1201_get_freq(struct net_device *dev,
     struct iw_request_info *info, struct iw_freq *freq, char *extra)
 {
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 	short channel;
 	int err;
 
@@ -955,7 +955,7 @@ static int zd1201_get_freq(struct net_de
 static int zd1201_set_mode(struct net_device *dev,
     struct iw_request_info *info, __u32 *mode, char *extra)
 {
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 	short porttype, monitor = 0;
 	unsigned char buffer[IW_ESSID_MAX_SIZE+2];
 	int err;
@@ -1017,7 +1017,7 @@ static int zd1201_set_mode(struct net_de
 static int zd1201_get_mode(struct net_device *dev,
     struct iw_request_info *info, __u32 *mode, char *extra)
 {
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 	short porttype;
 	int err;
 
@@ -1093,7 +1093,7 @@ static int zd1201_get_range(struct net_d
 static int zd1201_get_wap(struct net_device *dev,
     struct iw_request_info *info, struct sockaddr *ap_addr, char *extra)
 {
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 	unsigned char buffer[6];
 
 	if (!zd1201_getconfig(zd, ZD1201_RID_COMMSQUALITY, buffer, 6)) {
@@ -1121,7 +1121,7 @@ static int zd1201_set_scan(struct net_de
 static int zd1201_get_scan(struct net_device *dev,
     struct iw_request_info *info, struct iw_point *srq, char *extra)
 {
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 	int err, i, j, enabled_save;
 	struct iw_event iwe;
 	char *cev = extra;
@@ -1208,7 +1208,7 @@ static int zd1201_get_scan(struct net_de
 static int zd1201_set_essid(struct net_device *dev,
     struct iw_request_info *info, struct iw_point *data, char *essid)
 {
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 
 	if (data->length > IW_ESSID_MAX_SIZE)
 		return -EINVAL;
@@ -1223,7 +1223,7 @@ static int zd1201_set_essid(struct net_d
 static int zd1201_get_essid(struct net_device *dev,
     struct iw_request_info *info, struct iw_point *data, char *essid)
 {
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 
 	memcpy(essid, zd->essid, zd->essidlen);
 	data->flags = 1;
@@ -1244,7 +1244,7 @@ static int zd1201_get_nick(struct net_de
 static int zd1201_set_rate(struct net_device *dev,
     struct iw_request_info *info, struct iw_param *rrq, char *extra)
 {
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 	short rate;
 	int err;
 
@@ -1277,7 +1277,7 @@ static int zd1201_set_rate(struct net_de
 static int zd1201_get_rate(struct net_device *dev,
     struct iw_request_info *info, struct iw_param *rrq, char *extra)
 {
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 	short rate;
 	int err;
 
@@ -1310,7 +1310,7 @@ static int zd1201_get_rate(struct net_de
 static int zd1201_set_rts(struct net_device *dev, struct iw_request_info *info,
     struct iw_param *rts, char *extra)
 {
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 	int err;
 	short val = rts->value;
 
@@ -1330,7 +1330,7 @@ static int zd1201_set_rts(struct net_dev
 static int zd1201_get_rts(struct net_device *dev, struct iw_request_info *info,
     struct iw_param *rts, char *extra)
 {
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 	short rtst;
 	int err;
 
@@ -1347,7 +1347,7 @@ static int zd1201_get_rts(struct net_dev
 static int zd1201_set_frag(struct net_device *dev, struct iw_request_info *info,
     struct iw_param *frag, char *extra)
 {
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 	int err;
 	short val = frag->value;
 
@@ -1368,7 +1368,7 @@ static int zd1201_set_frag(struct net_de
 static int zd1201_get_frag(struct net_device *dev, struct iw_request_info *info,
     struct iw_param *frag, char *extra)
 {
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 	short fragt;
 	int err;
 
@@ -1397,7 +1397,7 @@ static int zd1201_get_retry(struct net_d
 static int zd1201_set_encode(struct net_device *dev,
     struct iw_request_info *info, struct iw_point *erq, char *key)
 {
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 	short i;
 	int err, rid;
 
@@ -1454,7 +1454,7 @@ static int zd1201_set_encode(struct net_
 static int zd1201_get_encode(struct net_device *dev,
     struct iw_request_info *info, struct iw_point *erq, char *key)
 {
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 	short i;
 	int err;
 
@@ -1487,7 +1487,7 @@ static int zd1201_get_encode(struct net_
 static int zd1201_set_power(struct net_device *dev, 
     struct iw_request_info *info, struct iw_param *vwrq, char *extra)
 {
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 	short enabled, duration, level;
 	int err;
 
@@ -1526,7 +1526,7 @@ out:
 static int zd1201_get_power(struct net_device *dev,
     struct iw_request_info *info, struct iw_param *vwrq, char *extra)
 {
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 	short enabled, level, duration;
 	int err;
 
@@ -1613,7 +1613,7 @@ static const iw_handler zd1201_iw_handle
 static int zd1201_set_hostauth(struct net_device *dev,
     struct iw_request_info *info, struct iw_param *rrq, char *extra)
 {
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 
 	if (!zd->ap)
 		return -EOPNOTSUPP;
@@ -1624,7 +1624,7 @@ static int zd1201_set_hostauth(struct ne
 static int zd1201_get_hostauth(struct net_device *dev,
     struct iw_request_info *info, struct iw_param *rrq, char *extra)
 {
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 	short hostauth;
 	int err;
 
@@ -1643,7 +1643,7 @@ static int zd1201_get_hostauth(struct ne
 static int zd1201_auth_sta(struct net_device *dev,
     struct iw_request_info *info, struct sockaddr *sta, char *extra)
 {
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 	unsigned char buffer[10];
 
 	if (!zd->ap)
@@ -1659,7 +1659,7 @@ static int zd1201_auth_sta(struct net_de
 static int zd1201_set_maxassoc(struct net_device *dev,
     struct iw_request_info *info, struct iw_param *rrq, char *extra)
 {
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 	int err;
 
 	if (!zd->ap)
@@ -1674,7 +1674,7 @@ static int zd1201_set_maxassoc(struct ne
 static int zd1201_get_maxassoc(struct net_device *dev,
     struct iw_request_info *info, struct iw_param *rrq, char *extra)
 {
-	struct zd1201 *zd = (struct zd1201 *)dev->priv;
+	struct zd1201 *zd = dev->priv;
 	short maxassoc;
 	int err;
 
--- linux-2.6.git/drivers/net/wireless/wavelan.c
+++ linux-2.6.git/drivers/net/wireless/wavelan.c
@@ -134,7 +134,7 @@ static inline void wv_16_on(unsigned lon
  */
 static inline void wv_ints_off(struct net_device * dev)
 {
-	net_local *lp = (net_local *) dev->priv;
+	net_local *lp = dev->priv;
 	unsigned long ioaddr = dev->base_addr;
 	
 	lp->hacr &= ~HACR_INTRON;
@@ -148,7 +148,7 @@ static inline void wv_ints_off(struct ne
  */
 static inline void wv_ints_on(struct net_device * dev)
 {
-	net_local *lp = (net_local *) dev->priv;
+	net_local *lp = dev->priv;
 	unsigned long ioaddr = dev->base_addr;
 
 	lp->hacr |= HACR_INTRON;
@@ -526,7 +526,7 @@ static inline void obram_write(unsigned 
  */
 static void wv_ack(struct net_device * dev)
 {
-	net_local *lp = (net_local *) dev->priv;
+	net_local *lp = dev->priv;
 	unsigned long ioaddr = dev->base_addr;
 	u16 scb_cs;
 	int i;
@@ -568,7 +568,7 @@ static void wv_ack(struct net_device * d
  */
 static int wv_synchronous_cmd(struct net_device * dev, const char *str)
 {
-	net_local *lp = (net_local *) dev->priv;
+	net_local *lp = dev->priv;
 	unsigned long ioaddr = dev->base_addr;
 	u16 scb_cmd;
 	ach_t cb;
@@ -824,7 +824,7 @@ if (lp->tx_n_in_use > 0)
  */
 static void wv_82586_reconfig(struct net_device * dev)
 {
-	net_local *lp = (net_local *) dev->priv;
+	net_local *lp = dev->priv;
 	unsigned long flags;
 
 	/* Arm the flag, will be cleard in wv_82586_config() */
@@ -927,7 +927,7 @@ static void wv_psa_show(psa_t * p)
 static void wv_mmc_show(struct net_device * dev)
 {
 	unsigned long ioaddr = dev->base_addr;
-	net_local *lp = (net_local *) dev->priv;
+	net_local *lp = dev->priv;
 	mmr_t m;
 
 	/* Basic check */
@@ -1107,7 +1107,7 @@ static void wv_scb_show(unsigned long io
  */
 static void wv_ru_show(struct net_device * dev)
 {
-	/* net_local *lp = (net_local *) dev->priv; */
+	/* net_local *lp = dev->priv; */
 
 	printk(KERN_DEBUG
 	       "##### WaveLAN i82586 receiver unit status: #####\n");
@@ -1153,7 +1153,7 @@ static void wv_cu_show_one(struct net_de
  */
 static void wv_cu_show(struct net_device * dev)
 {
-	net_local *lp = (net_local *) dev->priv;
+	net_local *lp = dev->priv;
 	unsigned int i;
 	u16 p;
 
@@ -1195,7 +1195,7 @@ static void wv_local_show(struct net_dev
 {
 	net_local *lp;
 
-	lp = (net_local *) dev->priv;
+	lp = dev->priv;
 
 	printk(KERN_DEBUG "local:");
 	printk(" tx_n_in_use=%d,", lp->tx_n_in_use);
@@ -1256,7 +1256,7 @@ static inline void wv_packet_info(u8 * p
 static void wv_init_info(struct net_device * dev)
 {
 	short ioaddr = dev->base_addr;
-	net_local *lp = (net_local *) dev->priv;
+	net_local *lp = dev->priv;
 	psa_t psa;
 #ifdef DEBUG_BASIC_SHOW
 	DECLARE_MAC_BUF(mac);
@@ -1382,7 +1382,7 @@ static en_stats *wavelan_get_stats(struc
  */
 static void wavelan_set_multicast_list(struct net_device * dev)
 {
-	net_local *lp = (net_local *) dev->priv;
+	net_local *lp = dev->priv;
 
 #ifdef DEBUG_IOCTL_TRACE
 	printk(KERN_DEBUG "%s: ->wavelan_set_multicast_list()\n",
@@ -1719,7 +1719,7 @@ static inline void wl_spy_gather(struct 
  */
 static inline void wl_his_gather(struct net_device * dev, u8 * stats)
 {				/* Statistics to gather */
-	net_local *lp = (net_local *) dev->priv;
+	net_local *lp = dev->priv;
 	u8 level = stats[0] & MMR_SIGNAL_LVL;
 	int i;
 
@@ -1756,7 +1756,7 @@ static int wavelan_set_nwid(struct net_d
 			    char *extra)
 {
 	unsigned long ioaddr = dev->base_addr;
-	net_local *lp = (net_local *) dev->priv;	/* lp is not unused */
+	net_local *lp = dev->priv;	/* lp is not unused */
 	psa_t psa;
 	mm_t m;
 	unsigned long flags;
@@ -1815,7 +1815,7 @@ static int wavelan_get_nwid(struct net_d
 			    char *extra)
 {
 	unsigned long ioaddr = dev->base_addr;
-	net_local *lp = (net_local *) dev->priv;	/* lp is not unused */
+	net_local *lp = dev->priv;	/* lp is not unused */
 	psa_t psa;
 	unsigned long flags;
 	int ret = 0;
@@ -1847,7 +1847,7 @@ static int wavelan_set_freq(struct net_d
 			    char *extra)
 {
 	unsigned long ioaddr = dev->base_addr;
-	net_local *lp = (net_local *) dev->priv;	/* lp is not unused */
+	net_local *lp = dev->priv;	/* lp is not unused */
 	unsigned long flags;
 	int ret;
 
@@ -1877,7 +1877,7 @@ static int wavelan_get_freq(struct net_d
 			    char *extra)
 {
 	unsigned long ioaddr = dev->base_addr;
-	net_local *lp = (net_local *) dev->priv;	/* lp is not unused */
+	net_local *lp = dev->priv;	/* lp is not unused */
 	psa_t psa;
 	unsigned long flags;
 	int ret = 0;
@@ -1923,7 +1923,7 @@ static int wavelan_set_sens(struct net_d
 			    char *extra)
 {
 	unsigned long ioaddr = dev->base_addr;
-	net_local *lp = (net_local *) dev->priv;	/* lp is not unused */
+	net_local *lp = dev->priv;	/* lp is not unused */
 	psa_t psa;
 	unsigned long flags;
 	int ret = 0;
@@ -1959,7 +1959,7 @@ static int wavelan_get_sens(struct net_d
 			    char *extra)
 {
 	unsigned long ioaddr = dev->base_addr;
-	net_local *lp = (net_local *) dev->priv;	/* lp is not unused */
+	net_local *lp = dev->priv;	/* lp is not unused */
 	psa_t psa;
 	unsigned long flags;
 	int ret = 0;
@@ -1990,7 +1990,7 @@ static int wavelan_set_encode(struct net
 			      char *extra)
 {
 	unsigned long ioaddr = dev->base_addr;
-	net_local *lp = (net_local *) dev->priv;	/* lp is not unused */
+	net_local *lp = dev->priv;	/* lp is not unused */
 	unsigned long flags;
 	psa_t psa;
 	int ret = 0;
@@ -2060,7 +2060,7 @@ static int wavelan_get_encode(struct net
 			      char *extra)
 {
 	unsigned long ioaddr = dev->base_addr;
-	net_local *lp = (net_local *) dev->priv;	/* lp is not unused */
+	net_local *lp = dev->priv;	/* lp is not unused */
 	psa_t psa;
 	unsigned long flags;
 	int ret = 0;
@@ -2107,7 +2107,7 @@ static int wavelan_get_range(struct net_
 			     char *extra)
 {
 	unsigned long ioaddr = dev->base_addr;
-	net_local *lp = (net_local *) dev->priv;	/* lp is not unused */
+	net_local *lp = dev->priv;	/* lp is not unused */
 	struct iw_range *range = (struct iw_range *) extra;
 	unsigned long flags;
 	int ret = 0;
@@ -2182,7 +2182,7 @@ static int wavelan_set_qthr(struct net_d
 			    char *extra)
 {
 	unsigned long ioaddr = dev->base_addr;
-	net_local *lp = (net_local *) dev->priv;	/* lp is not unused */
+	net_local *lp = dev->priv;	/* lp is not unused */
 	psa_t psa;
 	unsigned long flags;
 
@@ -2214,7 +2214,7 @@ static int wavelan_get_qthr(struct net_d
 			    char *extra)
 {
 	unsigned long ioaddr = dev->base_addr;
-	net_local *lp = (net_local *) dev->priv;	/* lp is not unused */
+	net_local *lp = dev->priv;	/* lp is not unused */
 	psa_t psa;
 	unsigned long flags;
 
@@ -2242,7 +2242,7 @@ static int wavelan_set_histo(struct net_
 			     union iwreq_data *wrqu,
 			     char *extra)
 {
-	net_local *lp = (net_local *) dev->priv;	/* lp is not unused */
+	net_local *lp = dev->priv;	/* lp is not unused */
 
 	/* Check the number of intervals. */
 	if (wrqu->data.length > 16) {
@@ -2285,7 +2285,7 @@ static int wavelan_get_histo(struct net_
 			     union iwreq_data *wrqu,
 			     char *extra)
 {
-	net_local *lp = (net_local *) dev->priv;	/* lp is not unused */
+	net_local *lp = dev->priv;	/* lp is not unused */
 
 	/* Set the number of intervals. */
 	wrqu->data.length = lp->his_number;
@@ -2389,7 +2389,7 @@ static const struct iw_handler_def	wavel
 static iw_stats *wavelan_get_wireless_stats(struct net_device * dev)
 {
 	unsigned long ioaddr = dev->base_addr;
-	net_local *lp = (net_local *) dev->priv;
+	net_local *lp = dev->priv;
 	mmr_t m;
 	iw_stats *wstats;
 	unsigned long flags;
@@ -2464,7 +2464,7 @@ static iw_stats *wavelan_get_wireless_st
 static void
 wv_packet_read(struct net_device * dev, u16 buf_off, int sksize)
 {
-	net_local *lp = (net_local *) dev->priv;
+	net_local *lp = dev->priv;
 	unsigned long ioaddr = dev->base_addr;
 	struct sk_buff *skb;
 
@@ -2559,7 +2559,7 @@ wv_packet_read(struct net_device * dev, 
 static void wv_receive(struct net_device * dev)
 {
 	unsigned long ioaddr = dev->base_addr;
-	net_local *lp = (net_local *) dev->priv;
+	net_local *lp = dev->priv;
 	fd_t fd;
 	rbd_t rbd;
 	int nreaped = 0;
@@ -2741,7 +2741,7 @@ static void wv_receive(struct net_device
  */
 static int wv_packet_write(struct net_device * dev, void *buf, short length)
 {
-	net_local *lp = (net_local *) dev->priv;
+	net_local *lp = dev->priv;
 	unsigned long ioaddr = dev->base_addr;
 	unsigned short txblock;
 	unsigned short txpred;
@@ -2872,7 +2872,7 @@ static int wv_packet_write(struct net_de
  */
 static int wavelan_packet_xmit(struct sk_buff *skb, struct net_device * dev)
 {
-	net_local *lp = (net_local *) dev->priv;
+	net_local *lp = dev->priv;
 	unsigned long flags;
 	char data[ETH_ZLEN];
 
@@ -2940,7 +2940,7 @@ static int wavelan_packet_xmit(struct sk
 static int wv_mmc_init(struct net_device * dev)
 {
 	unsigned long ioaddr = dev->base_addr;
-	net_local *lp = (net_local *) dev->priv;
+	net_local *lp = dev->priv;
 	psa_t psa;
 	mmw_t m;
 	int configured;
@@ -3111,7 +3111,7 @@ static int wv_mmc_init(struct net_device
  */
 static int wv_ru_start(struct net_device * dev)
 {
-	net_local *lp = (net_local *) dev->priv;
+	net_local *lp = dev->priv;
 	unsigned long ioaddr = dev->base_addr;
 	u16 scb_cs;
 	fd_t fd;
@@ -3203,7 +3203,7 @@ static int wv_ru_start(struct net_device
  */
 static int wv_cu_start(struct net_device * dev)
 {
-	net_local *lp = (net_local *) dev->priv;
+	net_local *lp = dev->priv;
 	unsigned long ioaddr = dev->base_addr;
 	int i;
 	u16 txblock;
@@ -3304,7 +3304,7 @@ static int wv_cu_start(struct net_device
  */
 static int wv_82586_start(struct net_device * dev)
 {
-	net_local *lp = (net_local *) dev->priv;
+	net_local *lp = dev->priv;
 	unsigned long ioaddr = dev->base_addr;
 	scp_t scp;		/* system configuration pointer */
 	iscp_t iscp;		/* intermediate scp */
@@ -3436,7 +3436,7 @@ static int wv_82586_start(struct net_dev
  */
 static void wv_82586_config(struct net_device * dev)
 {
-	net_local *lp = (net_local *) dev->priv;
+	net_local *lp = dev->priv;
 	unsigned long ioaddr = dev->base_addr;
 	unsigned short txblock;
 	unsigned short txpred;
@@ -3616,7 +3616,7 @@ static void wv_82586_config(struct net_d
  */
 static void wv_82586_stop(struct net_device * dev)
 {
-	net_local *lp = (net_local *) dev->priv;
+	net_local *lp = dev->priv;
 	unsigned long ioaddr = dev->base_addr;
 	u16 scb_cmd;
 
@@ -3653,7 +3653,7 @@ static void wv_82586_stop(struct net_dev
  */
 static int wv_hw_reset(struct net_device * dev)
 {
-	net_local *lp = (net_local *) dev->priv;
+	net_local *lp = dev->priv;
 	unsigned long ioaddr = dev->base_addr;
 
 #ifdef DEBUG_CONFIG_TRACE
@@ -3754,7 +3754,7 @@ static irqreturn_t wavelan_interrupt(int
 	printk(KERN_DEBUG "%s: ->wavelan_interrupt()\n", dev->name);
 #endif
 
-	lp = (net_local *) dev->priv;
+	lp = dev->priv;
 	ioaddr = dev->base_addr;
 
 #ifdef DEBUG_INTERRUPT_INFO
@@ -3897,7 +3897,7 @@ static irqreturn_t wavelan_interrupt(int
  */
 static void wavelan_watchdog(struct net_device *	dev)
 {
-	net_local *	lp = (net_local *)dev->priv;
+	net_local *lp = dev->priv;
 	u_long		ioaddr = dev->base_addr;
 	unsigned long	flags;
 	unsigned int	nreaped;
@@ -3977,7 +3977,7 @@ static void wavelan_watchdog(struct net_
  */
 static int wavelan_open(struct net_device * dev)
 {
-	net_local *	lp = (net_local *)dev->priv;
+	net_local *lp = dev->priv;
 	unsigned long	flags;
 
 #ifdef DEBUG_CALLBACK_TRACE
@@ -4032,7 +4032,7 @@ static int wavelan_open(struct net_devic
  */
 static int wavelan_close(struct net_device * dev)
 {
-	net_local *lp = (net_local *) dev->priv;
+	net_local *lp = dev->priv;
 	unsigned long flags;
 
 #ifdef DEBUG_CALLBACK_TRACE
@@ -4132,7 +4132,7 @@ static int __init wavelan_config(struct 
 
 	/* Initialize device structures */
 	memset(dev->priv, 0, sizeof(net_local));
-	lp = (net_local *) dev->priv;
+	lp = dev->priv;
 
 	/* Back link to the device structure. */
 	lp->dev = dev;
--- linux-2.6.git/drivers/net/netxen/netxen_nic_main.c
+++ linux-2.6.git/drivers/net/netxen/netxen_nic_main.c
@@ -834,7 +834,7 @@ static void __devexit netxen_nic_remove(
  */
 static int netxen_nic_open(struct net_device *netdev)
 {
-	struct netxen_adapter *adapter = (struct netxen_adapter *)netdev->priv;
+	struct netxen_adapter *adapter = netdev->priv;
 	int err = 0;
 	int ctx, ring;
 	irq_handler_t handler;
--- linux-2.6.git/drivers/net/gianfar_mii.c
+++ linux-2.6.git/drivers/net/gianfar_mii.c
@@ -103,7 +103,7 @@ int gfar_local_mdio_read(struct gfar_mii
  * All PHY configuration is done through the TSEC1 MIIM regs */
 int gfar_mdio_write(struct mii_bus *bus, int mii_id, int regnum, u16 value)
 {
-	struct gfar_mii __iomem *regs = (void __iomem *)bus->priv;
+	struct gfar_mii __iomem *regs = bus->priv;
 
 	/* Write to the local MII regs */
 	return(gfar_local_mdio_write(regs, mii_id, regnum, value));
@@ -114,7 +114,7 @@ int gfar_mdio_write(struct mii_bus *bus,
  * configuration has to be done through the TSEC1 MIIM regs */
 int gfar_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 {
-	struct gfar_mii __iomem *regs = (void __iomem *)bus->priv;
+	struct gfar_mii __iomem *regs = bus->priv;
 
 	/* Read the local MII regs */
 	return(gfar_local_mdio_read(regs, mii_id, regnum));
@@ -123,7 +123,7 @@ int gfar_mdio_read(struct mii_bus *bus, 
 /* Reset the MIIM registers, and wait for the bus to free */
 static int gfar_mdio_reset(struct mii_bus *bus)
 {
-	struct gfar_mii __iomem *regs = (void __iomem *)bus->priv;
+	struct gfar_mii __iomem *regs = bus->priv;
 	unsigned int timeout = PHY_INIT_TIMEOUT;
 
 	mutex_lock(&bus->mdio_lock);
--- linux-2.6.git/drivers/net/declance.c
+++ linux-2.6.git/drivers/net/declance.c
@@ -1039,7 +1039,7 @@ static int __init dec_lance_probe(struct
 		dev = root_lance_dev;
 		while (dev) {
 			i++;
-			lp = (struct lance_private *)dev->priv;
+			lp = dev->priv;
 			dev = lp->next;
 		}
 		snprintf(name, sizeof(name), fmt, i);
--- linux-2.6.git/drivers/net/sfc/falcon.c
+++ linux-2.6.git/drivers/net/sfc/falcon.c
@@ -1940,7 +1940,7 @@ static int falcon_gmii_wait(struct efx_n
 static void falcon_mdio_write(struct net_device *net_dev, int phy_id,
 			      int addr, int value)
 {
-	struct efx_nic *efx = (struct efx_nic *)net_dev->priv;
+	struct efx_nic *efx = net_dev->priv;
 	unsigned int phy_id2 = phy_id & FALCON_PHY_ID_ID_MASK;
 	efx_oword_t reg;
 
@@ -2008,7 +2008,7 @@ static void falcon_mdio_write(struct net
  * could be read, -1 will be returned. */
 static int falcon_mdio_read(struct net_device *net_dev, int phy_id, int addr)
 {
-	struct efx_nic *efx = (struct efx_nic *)net_dev->priv;
+	struct efx_nic *efx = net_dev->priv;
 	unsigned int phy_addr = phy_id & FALCON_PHY_ID_ID_MASK;
 	efx_oword_t reg;
 	int value = -1;
--- linux-2.6.git/drivers/net/mace.c
+++ linux-2.6.git/drivers/net/mace.c
@@ -165,7 +165,7 @@ static int __devinit mace_probe(struct m
 			in_8(&mp->mace->chipid_lo);
 
 
-	mp = (struct mace_data *) dev->priv;
+	mp = dev->priv;
 	mp->maccc = ENXMT | ENRCV;
 
 	mp->tx_dma = ioremap(macio_resource_start(mdev, 1), 0x1000);
@@ -312,7 +312,7 @@ static void dbdma_reset(volatile struct 
 
 static void mace_reset(struct net_device *dev)
 {
-    struct mace_data *mp = (struct mace_data *) dev->priv;
+    struct mace_data *mp = dev->priv;
     volatile struct mace __iomem *mb = mp->mace;
     int i;
 
@@ -367,7 +367,7 @@ static void mace_reset(struct net_device
 
 static void __mace_set_address(struct net_device *dev, void *addr)
 {
-    struct mace_data *mp = (struct mace_data *) dev->priv;
+    struct mace_data *mp = dev->priv;
     volatile struct mace __iomem *mb = mp->mace;
     unsigned char *p = addr;
     int i;
@@ -388,7 +388,7 @@ static void __mace_set_address(struct ne
 
 static int mace_set_address(struct net_device *dev, void *addr)
 {
-    struct mace_data *mp = (struct mace_data *) dev->priv;
+    struct mace_data *mp = dev->priv;
     volatile struct mace __iomem *mb = mp->mace;
     unsigned long flags;
 
@@ -423,7 +423,7 @@ static inline void mace_clean_rings(stru
 
 static int mace_open(struct net_device *dev)
 {
-    struct mace_data *mp = (struct mace_data *) dev->priv;
+    struct mace_data *mp = dev->priv;
     volatile struct mace __iomem *mb = mp->mace;
     volatile struct dbdma_regs __iomem *rd = mp->rx_dma;
     volatile struct dbdma_regs __iomem *td = mp->tx_dma;
@@ -493,7 +493,7 @@ static int mace_open(struct net_device *
 
 static int mace_close(struct net_device *dev)
 {
-    struct mace_data *mp = (struct mace_data *) dev->priv;
+    struct mace_data *mp = dev->priv;
     volatile struct mace __iomem *mb = mp->mace;
     volatile struct dbdma_regs __iomem *rd = mp->rx_dma;
     volatile struct dbdma_regs __iomem *td = mp->tx_dma;
@@ -513,7 +513,7 @@ static int mace_close(struct net_device 
 
 static inline void mace_set_timeout(struct net_device *dev)
 {
-    struct mace_data *mp = (struct mace_data *) dev->priv;
+    struct mace_data *mp = dev->priv;
 
     if (mp->timeout_active)
 	del_timer(&mp->tx_timeout);
@@ -526,7 +526,7 @@ static inline void mace_set_timeout(stru
 
 static int mace_xmit_start(struct sk_buff *skb, struct net_device *dev)
 {
-    struct mace_data *mp = (struct mace_data *) dev->priv;
+    struct mace_data *mp = dev->priv;
     volatile struct dbdma_regs __iomem *td = mp->tx_dma;
     volatile struct dbdma_cmd *cp, *np;
     unsigned long flags;
@@ -581,7 +581,7 @@ static int mace_xmit_start(struct sk_buf
 
 static void mace_set_multicast(struct net_device *dev)
 {
-    struct mace_data *mp = (struct mace_data *) dev->priv;
+    struct mace_data *mp = dev->priv;
     volatile struct mace __iomem *mb = mp->mace;
     int i, j;
     u32 crc;
@@ -656,7 +656,7 @@ static void mace_handle_misc_intrs(struc
 static irqreturn_t mace_interrupt(int irq, void *dev_id)
 {
     struct net_device *dev = (struct net_device *) dev_id;
-    struct mace_data *mp = (struct mace_data *) dev->priv;
+    struct mace_data *mp = dev->priv;
     volatile struct mace __iomem *mb = mp->mace;
     volatile struct dbdma_regs __iomem *td = mp->tx_dma;
     volatile struct dbdma_cmd *cp;
@@ -802,7 +802,7 @@ static irqreturn_t mace_interrupt(int ir
 static void mace_tx_timeout(unsigned long data)
 {
     struct net_device *dev = (struct net_device *) data;
-    struct mace_data *mp = (struct mace_data *) dev->priv;
+    struct mace_data *mp = dev->priv;
     volatile struct mace __iomem *mb = mp->mace;
     volatile struct dbdma_regs __iomem *td = mp->tx_dma;
     volatile struct dbdma_regs __iomem *rd = mp->rx_dma;
@@ -873,7 +873,7 @@ static irqreturn_t mace_txdma_intr(int i
 static irqreturn_t mace_rxdma_intr(int irq, void *dev_id)
 {
     struct net_device *dev = (struct net_device *) dev_id;
-    struct mace_data *mp = (struct mace_data *) dev->priv;
+    struct mace_data *mp = dev->priv;
     volatile struct dbdma_regs __iomem *rd = mp->rx_dma;
     volatile struct dbdma_cmd *cp, *np;
     int i, nb, stat, next;
--- linux-2.6.git/drivers/net/sun3_82586.c
+++ linux-2.6.git/drivers/net/sun3_82586.c
@@ -247,7 +247,7 @@ static int check586(struct net_device *d
  */
 static void alloc586(struct net_device *dev)
 {
-	struct priv *p =	(struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 
 	sun3_reset586();
 	DELAY(1);
@@ -397,7 +397,7 @@ static int init586(struct net_device *de
 {
 	void *ptr;
 	int i,result=0;
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 	volatile struct configure_cmd_struct	*cfg_cmd;
 	volatile struct iasetup_cmd_struct *ias_cmd;
 	volatile struct tdr_cmd_struct *tdr_cmd;
@@ -634,7 +634,7 @@ static void *alloc_rfa(struct net_device
 	volatile struct rfd_struct *rfd = (struct rfd_struct *)ptr;
 	volatile struct rbd_struct *rbd;
 	int i;
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 
 	memset((char *) rfd,0,sizeof(struct rfd_struct)*(p->num_recv_buffs+rfdadd));
 	p->rfd_first = rfd;
@@ -686,7 +686,7 @@ static irqreturn_t sun3_82586_interrupt(
 		printk ("sun3_82586-interrupt: irq %d for unknown device.\n",irq);
 		return IRQ_NONE;
 	}
-	p = (struct priv *) dev->priv;
+	p = dev->priv;
 
 	if(debuglevel > 1)
 		printk("I");
@@ -756,7 +756,7 @@ static void sun3_82586_rcv_int(struct ne
 	unsigned short totlen;
 	struct sk_buff *skb;
 	struct rbd_struct *rbd;
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 
 	if(debuglevel > 0)
 		printk("R");
@@ -874,7 +874,7 @@ static void sun3_82586_rcv_int(struct ne
 
 static void sun3_82586_rnr_int(struct net_device *dev)
 {
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 
 	p->stats.rx_errors++;
 
@@ -898,7 +898,7 @@ static void sun3_82586_rnr_int(struct ne
 static void sun3_82586_xmt_int(struct net_device *dev)
 {
 	int status;
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 
 	if(debuglevel > 0)
 		printk("X");
@@ -948,7 +948,7 @@ static void sun3_82586_xmt_int(struct ne
 
 static void startrecv586(struct net_device *dev)
 {
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 
 	WAIT_4_SCB_CMD();
 	WAIT_4_SCB_CMD_RUC();
@@ -960,7 +960,7 @@ static void startrecv586(struct net_devi
 
 static void sun3_82586_timeout(struct net_device *dev)
 {
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 #ifndef NO_NOPCOMMANDS
 	if(p->scb->cus & CU_ACTIVE) /* COMMAND-UNIT active? */
 	{
@@ -1002,7 +1002,7 @@ static int sun3_82586_send_packet(struct
 #ifndef NO_NOPCOMMANDS
 	int next_nop;
 #endif
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 
 	if(skb->len > XMIT_BUFF_SIZE)
 	{
@@ -1111,7 +1111,7 @@ static int sun3_82586_send_packet(struct
 
 static struct net_device_stats *sun3_82586_get_stats(struct net_device *dev)
 {
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 	unsigned short crc,aln,rsc,ovrn;
 
 	crc = swab16(p->scb->crc_errs); /* get error-statistic from the ni82586 */
@@ -1174,7 +1174,7 @@ void cleanup_module(void)
  */
 void sun3_82586_dump(struct net_device *dev,void *ptr)
 {
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 	struct dump_cmd_struct *dump_cmd = (struct dump_cmd_struct *) ptr;
 	int i;
 
--- linux-2.6.git/drivers/net/iseries_veth.c
+++ linux-2.6.git/drivers/net/iseries_veth.c
@@ -952,7 +952,7 @@ static int veth_change_mtu(struct net_de
 
 static void veth_set_multicast_list(struct net_device *dev)
 {
-	struct veth_port *port = (struct veth_port *) dev->priv;
+	struct veth_port *port = dev->priv;
 	unsigned long flags;
 
 	write_lock_irqsave(&port->mcast_gate, flags);
@@ -1044,7 +1044,7 @@ static struct net_device *veth_probe_one
 		return NULL;
 	}
 
-	port = (struct veth_port *) dev->priv;
+	port = dev->priv;
 
 	spin_lock_init(&port->queue_lock);
 	rwlock_init(&port->mcast_gate);
@@ -1102,7 +1102,7 @@ static int veth_transmit_to_one(struct s
 				struct net_device *dev)
 {
 	struct veth_lpar_connection *cnx = veth_cnx[rlp];
-	struct veth_port *port = (struct veth_port *) dev->priv;
+	struct veth_port *port = dev->priv;
 	HvLpEvent_Rc rc;
 	struct veth_msg *msg = NULL;
 	unsigned long flags;
@@ -1191,7 +1191,7 @@ static void veth_transmit_to_many(struct
 static int veth_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	unsigned char *frame = skb->data;
-	struct veth_port *port = (struct veth_port *) dev->priv;
+	struct veth_port *port = dev->priv;
 	HvLpIndexMap lpmask;
 
 	if (! (frame[0] & 0x01)) {
@@ -1255,7 +1255,7 @@ static void veth_wake_queues(struct veth
 		if (! dev)
 			continue;
 
-		port = (struct veth_port *)dev->priv;
+		port = dev->priv;
 
 		if (! (port->lpar_map & (1<<cnx->remote_lp)))
 			continue;
@@ -1284,7 +1284,7 @@ static void veth_stop_queues(struct veth
 		if (! dev)
 			continue;
 
-		port = (struct veth_port *)dev->priv;
+		port = dev->priv;
 
 		/* If this cnx is not on the vlan for this port, continue */
 		if (! (port->lpar_map & (1 << cnx->remote_lp)))
@@ -1506,7 +1506,7 @@ static void veth_receive(struct veth_lpa
 			continue;
 		}
 
-		port = (struct veth_port *)dev->priv;
+		port = dev->priv;
 		dest = *((u64 *) skb->data) & 0xFFFFFFFFFFFF0000;
 
 		if ((vlan > HVMAXARCHITECTEDVIRTUALLANS) || !port) {
--- linux-2.6.git/drivers/net/ppp_generic.c
+++ linux-2.6.git/drivers/net/ppp_generic.c
@@ -875,7 +875,7 @@ out_chrdev:
 static int
 ppp_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	struct ppp *ppp = (struct ppp *) dev->priv;
+	struct ppp *ppp = dev->priv;
 	int npi, proto;
 	unsigned char *pp;
 
--- linux-2.6.git/drivers/net/sb1250-mac.c
+++ linux-2.6.git/drivers/net/sb1250-mac.c
@@ -456,7 +456,7 @@ static void sbmac_mii_senddata(void __io
 
 static int sbmac_mii_read(struct mii_bus *bus, int phyaddr, int regidx)
 {
-	struct sbmac_softc *sc = (struct sbmac_softc *)bus->priv;
+	struct sbmac_softc *sc = bus->priv;
 	void __iomem *sbm_mdio = sc->sbm_mdio;
 	int idx;
 	int error;
@@ -550,7 +550,7 @@ static int sbmac_mii_read(struct mii_bus
 static int sbmac_mii_write(struct mii_bus *bus, int phyaddr, int regidx,
 			   u16 regval)
 {
-	struct sbmac_softc *sc = (struct sbmac_softc *)bus->priv;
+	struct sbmac_softc *sc = bus->priv;
 	void __iomem *sbm_mdio = sc->sbm_mdio;
 	int mac_mdio_genc;
 
--- linux-2.6.git/drivers/net/depca.c
+++ linux-2.6.git/drivers/net/depca.c
@@ -601,7 +601,7 @@ static int __init depca_hw_init (struct 
 		return -ENXIO;
 	}
 
-	lp = (struct depca_private *) dev->priv;
+	lp = dev->priv;
 	mem_start = lp->mem_start;
 
 	if (!mem_start || lp->adapter < DEPCA || lp->adapter >=unknown)
@@ -821,7 +821,7 @@ out_priv:
 
 static int depca_open(struct net_device *dev)
 {
-	struct depca_private *lp = (struct depca_private *) dev->priv;
+	struct depca_private *lp = dev->priv;
 	u_long ioaddr = dev->base_addr;
 	s16 nicsr;
 	int status = 0;
@@ -866,7 +866,7 @@ static int depca_open(struct net_device 
 /* Initialize the lance Rx and Tx descriptor rings. */
 static void depca_init_ring(struct net_device *dev)
 {
-	struct depca_private *lp = (struct depca_private *) dev->priv;
+	struct depca_private *lp = dev->priv;
 	u_int i;
 	u_long offset;
 
@@ -924,7 +924,7 @@ static void depca_tx_timeout(struct net_
 */
 static int depca_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	struct depca_private *lp = (struct depca_private *) dev->priv;
+	struct depca_private *lp = dev->priv;
 	u_long ioaddr = dev->base_addr;
 	int status = 0;
 
@@ -972,7 +972,7 @@ static irqreturn_t depca_interrupt(int i
 		return IRQ_NONE;
 	}
 
-	lp = (struct depca_private *) dev->priv;
+	lp = dev->priv;
 	ioaddr = dev->base_addr;
 
 	spin_lock(&lp->lock);
@@ -1010,7 +1010,7 @@ static irqreturn_t depca_interrupt(int i
 /* Called with lp->lock held */
 static int depca_rx(struct net_device *dev)
 {
-	struct depca_private *lp = (struct depca_private *) dev->priv;
+	struct depca_private *lp = dev->priv;
 	int i, entry;
 	s32 status;
 
@@ -1108,7 +1108,7 @@ static int depca_rx(struct net_device *d
 */
 static int depca_tx(struct net_device *dev)
 {
-	struct depca_private *lp = (struct depca_private *) dev->priv;
+	struct depca_private *lp = dev->priv;
 	int entry;
 	s32 status;
 	u_long ioaddr = dev->base_addr;
@@ -1149,7 +1149,7 @@ static int depca_tx(struct net_device *d
 
 static int depca_close(struct net_device *dev)
 {
-	struct depca_private *lp = (struct depca_private *) dev->priv;
+	struct depca_private *lp = dev->priv;
 	s16 nicsr;
 	u_long ioaddr = dev->base_addr;
 
@@ -1185,7 +1185,7 @@ static int depca_close(struct net_device
 
 static void LoadCSRs(struct net_device *dev)
 {
-	struct depca_private *lp = (struct depca_private *) dev->priv;
+	struct depca_private *lp = dev->priv;
 	u_long ioaddr = dev->base_addr;
 
 	outw(CSR1, DEPCA_ADDR);	/* initialisation block address LSW */
@@ -1202,7 +1202,7 @@ static void LoadCSRs(struct net_device *
 
 static int InitRestartDepca(struct net_device *dev)
 {
-	struct depca_private *lp = (struct depca_private *) dev->priv;
+	struct depca_private *lp = dev->priv;
 	u_long ioaddr = dev->base_addr;
 	int i, status = 0;
 
@@ -1234,7 +1234,7 @@ static int InitRestartDepca(struct net_d
 */
 static void set_multicast_list(struct net_device *dev)
 {
-	struct depca_private *lp = (struct depca_private *) dev->priv;
+	struct depca_private *lp = dev->priv;
 	u_long ioaddr = dev->base_addr;
 
 	netif_stop_queue(dev);
@@ -1263,7 +1263,7 @@ static void set_multicast_list(struct ne
 */
 static void SetMulticastFilter(struct net_device *dev)
 {
-	struct depca_private *lp = (struct depca_private *) dev->priv;
+	struct depca_private *lp = dev->priv;
 	struct dev_mc_list *dmi = dev->mc_list;
 	char *addrs;
 	int i, j, bit, byte;
@@ -1782,7 +1782,7 @@ static int __init get_hw_addr(struct net
 */
 static int load_packet(struct net_device *dev, struct sk_buff *skb)
 {
-	struct depca_private *lp = (struct depca_private *) dev->priv;
+	struct depca_private *lp = dev->priv;
 	int i, entry, end, len, status = 0;
 
 	entry = lp->tx_new;	/* Ring around buffer number. */
@@ -1837,7 +1837,7 @@ static int load_packet(struct net_device
 
 static void depca_dbg_open(struct net_device *dev)
 {
-	struct depca_private *lp = (struct depca_private *) dev->priv;
+	struct depca_private *lp = dev->priv;
 	u_long ioaddr = dev->base_addr;
 	struct depca_init *p = &lp->init_block;
 	int i;
@@ -1909,7 +1909,7 @@ static void depca_dbg_open(struct net_de
 */
 static int depca_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 {
-	struct depca_private *lp = (struct depca_private *) dev->priv;
+	struct depca_private *lp = dev->priv;
 	struct depca_ioctl *ioc = (struct depca_ioctl *) &rq->ifr_ifru;
 	int i, status = 0;
 	u_long ioaddr = dev->base_addr;
--- linux-2.6.git/drivers/net/eepro.c
+++ linux-2.6.git/drivers/net/eepro.c
@@ -605,7 +605,7 @@ out:
 
 static void __init printEEPROMInfo(struct net_device *dev)
 {
-	struct eepro_local *lp = (struct eepro_local *)dev->priv;
+	struct eepro_local *lp = dev->priv;
 	int ioaddr = dev->base_addr;
 	unsigned short Word;
 	int i,j;
@@ -1684,7 +1684,7 @@ eepro_transmit_interrupt(struct net_devi
 static int eepro_ethtool_get_settings(struct net_device *dev,
 					struct ethtool_cmd *cmd)
 {
-	struct eepro_local	*lp = (struct eepro_local *)dev->priv;
+	struct eepro_local	*lp = dev->priv;
 
 	cmd->supported = 	SUPPORTED_10baseT_Half |
 				SUPPORTED_10baseT_Full |
--- linux-2.6.git/drivers/net/ucc_geth_mii.c
+++ linux-2.6.git/drivers/net/ucc_geth_mii.c
@@ -61,7 +61,7 @@
 /* configuration has to be done through the master UEC MIIM regs */
 int uec_mdio_write(struct mii_bus *bus, int mii_id, int regnum, u16 value)
 {
-	struct ucc_mii_mng __iomem *regs = (void __iomem *)bus->priv;
+	struct ucc_mii_mng __iomem *regs = bus->priv;
 
 	/* Setting up the MII Mangement Address Register */
 	out_be32(&regs->miimadd,
@@ -82,7 +82,7 @@ int uec_mdio_write(struct mii_bus *bus, 
 /* configuration has to be done through the TSEC1 MIIM regs */
 int uec_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 {
-	struct ucc_mii_mng __iomem *regs = (void __iomem *)bus->priv;
+	struct ucc_mii_mng __iomem *regs = bus->priv;
 	u16 value;
 
 	/* Setting up the MII Mangement Address Register */
@@ -106,7 +106,7 @@ int uec_mdio_read(struct mii_bus *bus, i
 /* Reset the MIIM registers, and wait for the bus to free */
 static int uec_mdio_reset(struct mii_bus *bus)
 {
-	struct ucc_mii_mng __iomem *regs = (void __iomem *)bus->priv;
+	struct ucc_mii_mng __iomem *regs = bus->priv;
 	unsigned int timeout = PHY_INIT_TIMEOUT;
 
 	mutex_lock(&bus->mdio_lock);
--- linux-2.6.git/drivers/net/myri_sbus.c
+++ linux-2.6.git/drivers/net/myri_sbus.c
@@ -532,7 +532,7 @@ static void myri_rx(struct myri_eth *mp,
 static irqreturn_t myri_interrupt(int irq, void *dev_id)
 {
 	struct net_device *dev		= (struct net_device *) dev_id;
-	struct myri_eth *mp		= (struct myri_eth *) dev->priv;
+	struct myri_eth *mp		= dev->priv;
 	void __iomem *lregs		= mp->lregs;
 	struct myri_channel __iomem *chan = &mp->shmem->channel;
 	unsigned long flags;
@@ -571,14 +571,14 @@ static irqreturn_t myri_interrupt(int ir
 
 static int myri_open(struct net_device *dev)
 {
-	struct myri_eth *mp = (struct myri_eth *) dev->priv;
+	struct myri_eth *mp = dev->priv;
 
 	return myri_init(mp, in_interrupt());
 }
 
 static int myri_close(struct net_device *dev)
 {
-	struct myri_eth *mp = (struct myri_eth *) dev->priv;
+	struct myri_eth *mp = dev->priv;
 
 	myri_clean_rings(mp);
 	return 0;
@@ -586,7 +586,7 @@ static int myri_close(struct net_device 
 
 static void myri_tx_timeout(struct net_device *dev)
 {
-	struct myri_eth *mp = (struct myri_eth *) dev->priv;
+	struct myri_eth *mp = dev->priv;
 
 	printk(KERN_ERR "%s: transmit timed out, resetting\n", dev->name);
 
@@ -597,7 +597,7 @@ static void myri_tx_timeout(struct net_d
 
 static int myri_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	struct myri_eth *mp = (struct myri_eth *) dev->priv;
+	struct myri_eth *mp = dev->priv;
 	struct sendq __iomem *sq = mp->sq;
 	struct myri_txd __iomem *txd;
 	unsigned long flags;
@@ -912,7 +912,7 @@ static int __devinit myri_ether_init(str
 
 	SET_NETDEV_DEV(dev, &sdev->ofdev.dev);
 
-	mp = (struct myri_eth *) dev->priv;
+	mp = dev->priv;
 	spin_lock_init(&mp->irq_lock);
 	mp->myri_sdev = sdev;
 
--- linux-2.6.git/drivers/net/lance.c
+++ linux-2.6.git/drivers/net/lance.c
@@ -910,7 +910,7 @@ lance_restart(struct net_device *dev, un
 
 static void lance_tx_timeout (struct net_device *dev)
 {
-	struct lance_private *lp = (struct lance_private *) dev->priv;
+	struct lance_private *lp = dev->priv;
 	int ioaddr = dev->base_addr;
 
 	outw (0, ioaddr + LANCE_ADDR);
--- linux-2.6.git/drivers/net/mvme147.c
+++ linux-2.6.git/drivers/net/mvme147.c
@@ -106,7 +106,7 @@ struct net_device * __init mvme147lance_
 	       dev->name, dev->base_addr, MVME147_LANCE_IRQ,
 	       print_mac(mac, dev->dev_addr));
 
-	lp = (struct m147lance_private *)dev->priv;
+	lp = dev->priv;
 	lp->ram = __get_dma_pages(GFP_ATOMIC, 3);	/* 16K */
 	if (!lp->ram)
 	{
--- linux-2.6.git/drivers/net/irda/via-ircc.c
+++ linux-2.6.git/drivers/net/irda/via-ircc.c
@@ -824,7 +824,7 @@ static int via_ircc_hard_xmit_sir(struct
 	u16 iobase;
 	__u32 speed;
 
-	self = (struct via_ircc_cb *) dev->priv;
+	self = dev->priv;
 	IRDA_ASSERT(self != NULL, return 0;);
 	iobase = self->io.fir_base;
 
@@ -896,7 +896,7 @@ static int via_ircc_hard_xmit_fir(struct
 	__u32 speed;
 	unsigned long flags;
 
-	self = (struct via_ircc_cb *) dev->priv;
+	self = dev->priv;
 	iobase = self->io.fir_base;
 
 	if (self->st_fifo.len)
@@ -1522,7 +1522,7 @@ static int via_ircc_net_open(struct net_
 	IRDA_DEBUG(3, "%s()\n", __FUNCTION__);
 
 	IRDA_ASSERT(dev != NULL, return -1;);
-	self = (struct via_ircc_cb *) dev->priv;
+	self = dev->priv;
 	self->stats.rx_packets = 0;
 	IRDA_ASSERT(self != NULL, return 0;);
 	iobase = self->io.fir_base;
@@ -1588,7 +1588,7 @@ static int via_ircc_net_close(struct net
 	IRDA_DEBUG(3, "%s()\n", __FUNCTION__);
 
 	IRDA_ASSERT(dev != NULL, return -1;);
-	self = (struct via_ircc_cb *) dev->priv;
+	self = dev->priv;
 	IRDA_ASSERT(self != NULL, return 0;);
 
 	/* Stop device */
@@ -1660,7 +1660,7 @@ static int via_ircc_net_ioctl(struct net
 static struct net_device_stats *via_ircc_net_get_stats(struct net_device
 						       *dev)
 {
-	struct via_ircc_cb *self = (struct via_ircc_cb *) dev->priv;
+	struct via_ircc_cb *self = dev->priv;
 
 	return &self->stats;
 }
--- linux-2.6.git/drivers/net/irda/nsc-ircc.c
+++ linux-2.6.git/drivers/net/irda/nsc-ircc.c
@@ -1350,7 +1350,7 @@ static int nsc_ircc_hard_xmit_sir(struct
 	__s32 speed;
 	__u8 bank;
 	
-	self = (struct nsc_ircc_cb *) dev->priv;
+	self = dev->priv;
 
 	IRDA_ASSERT(self != NULL, return 0;);
 
@@ -1423,7 +1423,7 @@ static int nsc_ircc_hard_xmit_fir(struct
 	__u8 bank;
 	int mtt, diff;
 	
-	self = (struct nsc_ircc_cb *) dev->priv;
+	self = dev->priv;
 	iobase = self->io.fir_base;
 
 	netif_stop_queue(dev);
@@ -2162,7 +2162,7 @@ static int nsc_ircc_net_open(struct net_
 	IRDA_DEBUG(4, "%s()\n", __FUNCTION__);
 	
 	IRDA_ASSERT(dev != NULL, return -1;);
-	self = (struct nsc_ircc_cb *) dev->priv;
+	self = dev->priv;
 	
 	IRDA_ASSERT(self != NULL, return 0;);
 	
@@ -2225,7 +2225,7 @@ static int nsc_ircc_net_close(struct net
 	
 	IRDA_ASSERT(dev != NULL, return -1;);
 
-	self = (struct nsc_ircc_cb *) dev->priv;
+	self = dev->priv;
 	IRDA_ASSERT(self != NULL, return 0;);
 
 	/* Stop device */
@@ -2306,7 +2306,7 @@ static int nsc_ircc_net_ioctl(struct net
 
 static struct net_device_stats *nsc_ircc_net_get_stats(struct net_device *dev)
 {
-	struct nsc_ircc_cb *self = (struct nsc_ircc_cb *) dev->priv;
+	struct nsc_ircc_cb *self = dev->priv;
 	
 	return &self->stats;
 }
--- linux-2.6.git/drivers/net/irda/w83977af_ir.c
+++ linux-2.6.git/drivers/net/irda/w83977af_ir.c
@@ -497,7 +497,7 @@ int w83977af_hard_xmit(struct sk_buff *s
 	__u8 set;
 	int mtt;
 	
-	self = (struct w83977af_ir *) dev->priv;
+	self = dev->priv;
 
 	iobase = self->io.fir_base;
 
@@ -1192,7 +1192,7 @@ static int w83977af_net_open(struct net_
 	IRDA_DEBUG(0, "%s()\n", __FUNCTION__ );
 	
 	IRDA_ASSERT(dev != NULL, return -1;);
-	self = (struct w83977af_ir *) dev->priv;
+	self = dev->priv;
 	
 	IRDA_ASSERT(self != NULL, return 0;);
 	
@@ -1256,7 +1256,7 @@ static int w83977af_net_close(struct net
 
 	IRDA_ASSERT(dev != NULL, return -1;);
 	
-	self = (struct w83977af_ir *) dev->priv;
+	self = dev->priv;
 	
 	IRDA_ASSERT(self != NULL, return 0;);
 	
@@ -1339,7 +1339,7 @@ out:
 
 static struct net_device_stats *w83977af_net_get_stats(struct net_device *dev)
 {
-	struct w83977af_ir *self = (struct w83977af_ir *) dev->priv;
+	struct w83977af_ir *self = dev->priv;
 	
 	return &self->stats;
 }
--- linux-2.6.git/drivers/net/irda/irda-usb.c
+++ linux-2.6.git/drivers/net/irda/irda-usb.c
@@ -1175,7 +1175,7 @@ static int irda_usb_net_open(struct net_
 	IRDA_DEBUG(1, "%s()\n", __FUNCTION__);
 
 	IRDA_ASSERT(netdev != NULL, return -1;);
-	self = (struct irda_usb_cb *) netdev->priv;
+	self = netdev->priv;
 	IRDA_ASSERT(self != NULL, return -1;);
 
 	spin_lock_irqsave(&self->lock, flags);
@@ -1257,7 +1257,7 @@ static int irda_usb_net_close(struct net
 	IRDA_DEBUG(1, "%s()\n", __FUNCTION__);
 
 	IRDA_ASSERT(netdev != NULL, return -1;);
-	self = (struct irda_usb_cb *) netdev->priv;
+	self = netdev->priv;
 	IRDA_ASSERT(self != NULL, return -1;);
 
 	/* Clear this flag *before* unlinking the urbs and *before*
--- linux-2.6.git/drivers/net/irda/donauboe.c
+++ linux-2.6.git/drivers/net/irda/donauboe.c
@@ -983,7 +983,7 @@ toshoboe_hard_xmit (struct sk_buff *skb,
   unsigned long flags;
   struct irda_skb_cb *cb = (struct irda_skb_cb *) skb->cb;
 
-  self = (struct toshoboe_cb *) dev->priv;
+  self = dev->priv;
 
   IRDA_ASSERT (self != NULL, return 0; );
 
@@ -1388,7 +1388,7 @@ toshoboe_net_close (struct net_device *d
   IRDA_DEBUG (4, "%s()\n", __FUNCTION__);
 
   IRDA_ASSERT (dev != NULL, return -1; );
-  self = (struct toshoboe_cb *) dev->priv;
+  self = dev->priv;
 
   /* Stop device */
   netif_stop_queue(dev);
--- linux-2.6.git/drivers/net/irda/ali-ircc.c
+++ linux-2.6.git/drivers/net/irda/ali-ircc.c
@@ -1333,7 +1333,7 @@ static int ali_ircc_net_open(struct net_
 	
 	IRDA_ASSERT(dev != NULL, return -1;);
 	
-	self = (struct ali_ircc_cb *) dev->priv;
+	self = dev->priv;
 	
 	IRDA_ASSERT(self != NULL, return 0;);
 	
@@ -1396,7 +1396,7 @@ static int ali_ircc_net_close(struct net
 		
 	IRDA_ASSERT(dev != NULL, return -1;);
 
-	self = (struct ali_ircc_cb *) dev->priv;
+	self = dev->priv;
 	IRDA_ASSERT(self != NULL, return 0;);
 
 	/* Stop device */
@@ -1436,7 +1436,7 @@ static int ali_ircc_fir_hard_xmit(struct
 	
 	IRDA_DEBUG(1, "%s(), ---------------- Start -----------------\n", __FUNCTION__ );	
 	
-	self = (struct ali_ircc_cb *) dev->priv;
+	self = dev->priv;
 	iobase = self->io.fir_base;
 
 	netif_stop_queue(dev);
@@ -1960,7 +1960,7 @@ static int ali_ircc_sir_hard_xmit(struct
 	
 	IRDA_ASSERT(dev != NULL, return 0;);
 	
-	self = (struct ali_ircc_cb *) dev->priv;
+	self = dev->priv;
 	IRDA_ASSERT(self != NULL, return 0;);
 
 	iobase = self->io.sir_base;
@@ -2114,7 +2114,7 @@ static int ali_ircc_is_receiving(struct 
 
 static struct net_device_stats *ali_ircc_net_get_stats(struct net_device *dev)
 {
-	struct ali_ircc_cb *self = (struct ali_ircc_cb *) dev->priv;
+	struct ali_ircc_cb *self = dev->priv;
 	
 	IRDA_DEBUG(2, "%s(), ---------------- Start ----------------\n", __FUNCTION__ );
 		
--- linux-2.6.git/drivers/net/sgiseeq.c
+++ linux-2.6.git/drivers/net/sgiseeq.c
@@ -657,7 +657,7 @@ static void timeout(struct net_device *d
 
 static void sgiseeq_set_multicast(struct net_device *dev)
 {
-	struct sgiseeq_private *sp = (struct sgiseeq_private *) dev->priv;
+	struct sgiseeq_private *sp = dev->priv;
 	unsigned char oldmode = sp->mode;
 
 	if(dev->flags & IFF_PROMISC)
--- linux-2.6.git/drivers/net/hamradio/scc.c
+++ linux-2.6.git/drivers/net/hamradio/scc.c
@@ -1574,7 +1574,7 @@ static void scc_net_setup(struct net_dev
 
 static int scc_net_open(struct net_device *dev)
 {
-	struct scc_channel *scc = (struct scc_channel *) dev->priv;
+	struct scc_channel *scc = dev->priv;
 
  	if (!scc->init)
 		return -EINVAL;
@@ -1592,7 +1592,7 @@ static int scc_net_open(struct net_devic
 
 static int scc_net_close(struct net_device *dev)
 {
-	struct scc_channel *scc = (struct scc_channel *) dev->priv;
+	struct scc_channel *scc = dev->priv;
 	unsigned long flags;
 
 	netif_stop_queue(dev);
@@ -1634,7 +1634,7 @@ static void scc_net_rx(struct scc_channe
 
 static int scc_net_tx(struct sk_buff *skb, struct net_device *dev)
 {
-	struct scc_channel *scc = (struct scc_channel *) dev->priv;
+	struct scc_channel *scc = dev->priv;
 	unsigned long flags;
 	char kisscmd;
 
@@ -1704,7 +1704,7 @@ static int scc_net_ioctl(struct net_devi
 	struct scc_mem_config memcfg;
 	struct scc_hw_config hwcfg;
 	struct scc_calibrate cal;
-	struct scc_channel *scc = (struct scc_channel *) dev->priv;
+	struct scc_channel *scc = dev->priv;
 	int chan;
 	unsigned char device_name[IFNAMSIZ];
 	void __user *arg = ifr->ifr_data;
@@ -1951,7 +1951,7 @@ static int scc_net_set_mac_address(struc
 
 static struct net_device_stats *scc_net_get_stats(struct net_device *dev)
 {
-	struct scc_channel *scc = (struct scc_channel *) dev->priv;
+	struct scc_channel *scc = dev->priv;
 	
 	scc->dev_stat.rx_errors = scc->stat.rxerrs + scc->stat.rx_over;
 	scc->dev_stat.tx_errors = scc->stat.txerrs + scc->stat.tx_under;
--- linux-2.6.git/drivers/net/sunhme.c
+++ linux-2.6.git/drivers/net/sunhme.c
@@ -3035,7 +3035,7 @@ static int __devinit happy_meal_pci_prob
 
 	dev->base_addr = (long) pdev;
 
-	hp = (struct happy_meal *)dev->priv;
+	hp = dev->priv;
 	memset(hp, 0, sizeof(*hp));
 
 	hp->happy_dev = pdev;
--- linux-2.6.git/drivers/net/atarilance.c
+++ linux-2.6.git/drivers/net/atarilance.c
@@ -521,7 +521,7 @@ static unsigned long __init lance_probe1
 	return( 0 );
 
   probe_ok:
-	lp = (struct lance_private *)dev->priv;
+	lp = dev->priv;
 	MEM = (struct lance_memory *)memaddr;
 	IO = lp->iobase = (struct lance_ioreg *)ioaddr;
 	dev->base_addr = (unsigned long)ioaddr; /* informational only */
@@ -641,7 +641,7 @@ static unsigned long __init lance_probe1
 
 static int lance_open( struct net_device *dev )
 
-{	struct lance_private *lp = (struct lance_private *)dev->priv;
+{	struct lance_private *lp = dev->priv;
 	struct lance_ioreg	 *IO = lp->iobase;
 	int i;
 
@@ -682,7 +682,7 @@ static int lance_open( struct net_device
 
 static void lance_init_ring( struct net_device *dev )
 
-{	struct lance_private *lp = (struct lance_private *)dev->priv;
+{	struct lance_private *lp = dev->priv;
 	int i;
 	unsigned offset;
 
@@ -730,7 +730,7 @@ static void lance_init_ring( struct net_
 
 static void lance_tx_timeout (struct net_device *dev)
 {
-	struct lance_private *lp = (struct lance_private *) dev->priv;
+	struct lance_private *lp = dev->priv;
 	struct lance_ioreg	 *IO = lp->iobase;
 
 	AREG = CSR0;
@@ -773,7 +773,7 @@ static void lance_tx_timeout (struct net
 
 static int lance_start_xmit( struct sk_buff *skb, struct net_device *dev )
 
-{	struct lance_private *lp = (struct lance_private *)dev->priv;
+{	struct lance_private *lp = dev->priv;
 	struct lance_ioreg	 *IO = lp->iobase;
 	int entry, len;
 	struct lance_tx_head *head;
@@ -865,7 +865,7 @@ static irqreturn_t lance_interrupt( int 
 		return IRQ_NONE;
 	}
 
-	lp = (struct lance_private *)dev->priv;
+	lp = dev->priv;
 	IO = lp->iobase;
 	spin_lock (&lp->devlock);
 
@@ -966,7 +966,7 @@ static irqreturn_t lance_interrupt( int 
 
 static int lance_rx( struct net_device *dev )
 
-{	struct lance_private *lp = (struct lance_private *)dev->priv;
+{	struct lance_private *lp = dev->priv;
 	int entry = lp->cur_rx & RX_RING_MOD_MASK;
 	int i;
 
@@ -1058,7 +1058,7 @@ static int lance_rx( struct net_device *
 
 static int lance_close( struct net_device *dev )
 
-{	struct lance_private *lp = (struct lance_private *)dev->priv;
+{	struct lance_private *lp = dev->priv;
 	struct lance_ioreg	 *IO = lp->iobase;
 
 	netif_stop_queue (dev);
@@ -1085,7 +1085,7 @@ static int lance_close( struct net_devic
 
 static void set_multicast_list( struct net_device *dev )
 
-{	struct lance_private *lp = (struct lance_private *)dev->priv;
+{	struct lance_private *lp = dev->priv;
 	struct lance_ioreg	 *IO = lp->iobase;
 
 	if (netif_running(dev))
@@ -1127,7 +1127,7 @@ static void set_multicast_list( struct n
 
 static int lance_set_mac_address( struct net_device *dev, void *addr )
 
-{	struct lance_private *lp = (struct lance_private *)dev->priv;
+{	struct lance_private *lp = dev->priv;
 	struct sockaddr *saddr = addr;
 	int i;
 
--- linux-2.6.git/drivers/net/3c523.c
+++ linux-2.6.git/drivers/net/3c523.c
@@ -309,7 +309,7 @@ static int elmc_open(struct net_device *
 
 static int __init check586(struct net_device *dev, unsigned long where, unsigned size)
 {
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 	char *iscp_addrs[2];
 	int i = 0;
 
@@ -350,7 +350,7 @@ static int __init check586(struct net_de
 
 void alloc586(struct net_device *dev)
 {
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 
 	elmc_id_reset586();
 	DELAY(2);
@@ -617,7 +617,7 @@ static int init586(struct net_device *de
 	void *ptr;
 	unsigned long s;
 	int i, result = 0;
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 	volatile struct configure_cmd_struct *cfg_cmd;
 	volatile struct iasetup_cmd_struct *ias_cmd;
 	volatile struct tdr_cmd_struct *tdr_cmd;
@@ -855,7 +855,7 @@ static void *alloc_rfa(struct net_device
 	volatile struct rfd_struct *rfd = (struct rfd_struct *) ptr;
 	volatile struct rbd_struct *rbd;
 	int i;
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 
 	memset((char *) rfd, 0, sizeof(struct rfd_struct) * p->num_recv_buffs);
 	p->rfd_first = rfd;
@@ -916,7 +916,7 @@ elmc_interrupt(int irq, void *dev_id)
 	}
 	/* reading ELMC_CTRL also clears the INT bit. */
 
-	p = (struct priv *) dev->priv;
+	p = dev->priv;
 
 	while ((stat = p->scb->status & STAT_MASK))
 	{
@@ -972,7 +972,7 @@ static void elmc_rcv_int(struct net_devi
 	unsigned short totlen;
 	struct sk_buff *skb;
 	struct rbd_struct *rbd;
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 
 	for (; (status = p->rfd_top->status) & STAT_COMPL;) {
 		rbd = (struct rbd_struct *) make32(p->rfd_top->rbd_offset);
@@ -1016,7 +1016,7 @@ static void elmc_rcv_int(struct net_devi
 
 static void elmc_rnr_int(struct net_device *dev)
 {
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 
 	p->stats.rx_errors++;
 
@@ -1039,7 +1039,7 @@ static void elmc_rnr_int(struct net_devi
 static void elmc_xmt_int(struct net_device *dev)
 {
 	int status;
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 
 	status = p->xmit_cmds[p->xmit_last]->cmd_status;
 	if (!(status & STAT_COMPL)) {
@@ -1082,7 +1082,7 @@ static void elmc_xmt_int(struct net_devi
 
 static void startrecv586(struct net_device *dev)
 {
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 
 	p->scb->rfa_offset = make16(p->rfd_first);
 	p->scb->cmd = RUC_START;
@@ -1096,7 +1096,7 @@ static void startrecv586(struct net_devi
 
 static void elmc_timeout(struct net_device *dev)
 {
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 	/* COMMAND-UNIT active? */
 	if (p->scb->status & CU_ACTIVE) {
 #ifdef DEBUG
@@ -1132,7 +1132,7 @@ static int elmc_send_packet(struct sk_bu
 #ifndef NO_NOPCOMMANDS
 	int next_nop;
 #endif
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 
 	netif_stop_queue(dev);
 
@@ -1203,7 +1203,7 @@ static int elmc_send_packet(struct sk_bu
 
 static struct net_device_stats *elmc_get_stats(struct net_device *dev)
 {
-	struct priv *p = (struct priv *) dev->priv;
+	struct priv *p = dev->priv;
 	unsigned short crc, aln, rsc, ovrn;
 
 	crc = p->scb->crc_errs;	/* get error-statistic from the ni82586 */
--- linux-2.6.git/drivers/net/sunbmac.c
+++ linux-2.6.git/drivers/net/sunbmac.c
@@ -914,7 +914,7 @@ static irqreturn_t bigmac_interrupt(int 
 
 static int bigmac_open(struct net_device *dev)
 {
-	struct bigmac *bp = (struct bigmac *) dev->priv;
+	struct bigmac *bp = dev->priv;
 	int ret;
 
 	ret = request_irq(dev->irq, &bigmac_interrupt, IRQF_SHARED, dev->name, bp);
@@ -931,7 +931,7 @@ static int bigmac_open(struct net_device
 
 static int bigmac_close(struct net_device *dev)
 {
-	struct bigmac *bp = (struct bigmac *) dev->priv;
+	struct bigmac *bp = dev->priv;
 
 	del_timer(&bp->bigmac_timer);
 	bp->timer_state = asleep;
@@ -945,7 +945,7 @@ static int bigmac_close(struct net_devic
 
 static void bigmac_tx_timeout(struct net_device *dev)
 {
-	struct bigmac *bp = (struct bigmac *) dev->priv;
+	struct bigmac *bp = dev->priv;
 
 	bigmac_init_hw(bp, 0);
 	netif_wake_queue(dev);
@@ -954,7 +954,7 @@ static void bigmac_tx_timeout(struct net
 /* Put a packet on the wire. */
 static int bigmac_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	struct bigmac *bp = (struct bigmac *) dev->priv;
+	struct bigmac *bp = dev->priv;
 	int len, entry;
 	u32 mapping;
 
@@ -986,7 +986,7 @@ static int bigmac_start_xmit(struct sk_b
 
 static struct net_device_stats *bigmac_get_stats(struct net_device *dev)
 {
-	struct bigmac *bp = (struct bigmac *) dev->priv;
+	struct bigmac *bp = dev->priv;
 
 	bigmac_get_counters(bp, bp->bregs);
 	return &bp->enet_stats;
@@ -994,7 +994,7 @@ static struct net_device_stats *bigmac_g
 
 static void bigmac_set_multicast(struct net_device *dev)
 {
-	struct bigmac *bp = (struct bigmac *) dev->priv;
+	struct bigmac *bp = dev->priv;
 	void __iomem *bregs = bp->bregs;
 	struct dev_mc_list *dmi = dev->mc_list;
 	char *addrs;
--- linux-2.6.git/drivers/net/rionet.c
+++ linux-2.6.git/drivers/net/rionet.c
@@ -243,7 +243,7 @@ static void rionet_inb_msg_event(struct 
 {
 	int n;
 	struct net_device *ndev = dev_id;
-	struct rionet_private *rnet = (struct rionet_private *)ndev->priv;
+	struct rionet_private *rnet = ndev->priv;
 
 	if (netif_msg_intr(rnet))
 		printk(KERN_INFO "%s: inbound message event, mbox %d slot %d\n",
@@ -351,7 +351,7 @@ static int rionet_open(struct net_device
 
 static int rionet_close(struct net_device *ndev)
 {
-	struct rionet_private *rnet = (struct rionet_private *)ndev->priv;
+	struct rionet_private *rnet = ndev->priv;
 	struct rionet_peer *peer, *tmp;
 	int i;
 
@@ -456,7 +456,7 @@ static int rionet_setup_netdev(struct ri
 				RIO_MAX_ROUTE_ENTRIES(mport->sys_size));
 
 	/* Set up private area */
-	rnet = (struct rionet_private *)ndev->priv;
+	rnet = ndev->priv;
 	rnet->mport = mport;
 
 	/* Set the default MAC address */
--- linux-2.6.git/drivers/net/pppol2tp.c
+++ linux-2.6.git/drivers/net/pppol2tp.c
@@ -968,7 +968,7 @@ error:
 static int pppol2tp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
 {
 	static const u8 ppph[2] = { 0xff, 0x03 };
-	struct sock *sk = (struct sock *) chan->private;
+	struct sock *sk = chan->private;
 	struct sock *sk_tun;
 	int hdr_len;
 	struct pppol2tp_session *session;
--- linux-2.6.git/drivers/net/3c505.c
+++ linux-2.6.git/drivers/net/3c505.c
@@ -643,7 +643,7 @@ static irqreturn_t elp_interrupt(int irq
 	unsigned long timeout;
 
 	dev = dev_id;
-	adapter = (elp_device *) dev->priv;
+	adapter = dev->priv;
 
 	spin_lock(&adapter->lock);
 
@@ -1104,7 +1104,7 @@ static int elp_start_xmit(struct sk_buff
 
 static struct net_device_stats *elp_get_stats(struct net_device *dev)
 {
-	elp_device *adapter = (elp_device *) dev->priv;
+	elp_device *adapter = dev->priv;
 
 	if (elp_debug >= 3)
 		printk(KERN_DEBUG "%s: request for stats\n", dev->name);
@@ -1209,7 +1209,7 @@ static int elp_close(struct net_device *
 
 static void elp_set_mc_list(struct net_device *dev)
 {
-	elp_device *adapter = (elp_device *) dev->priv;
+	elp_device *adapter = dev->priv;
 	struct dev_mc_list *dmi = dev->mc_list;
 	int i;
 	unsigned long flags;
--- linux-2.6.git/drivers/net/sunqe.c
+++ linux-2.6.git/drivers/net/sunqe.c
@@ -511,7 +511,7 @@ static irqreturn_t qec_interrupt(int irq
 
 static int qe_open(struct net_device *dev)
 {
-	struct sunqe *qep = (struct sunqe *) dev->priv;
+	struct sunqe *qep = dev->priv;
 
 	qep->mconfig = (MREGS_MCONFIG_TXENAB |
 			MREGS_MCONFIG_RXENAB |
@@ -521,7 +521,7 @@ static int qe_open(struct net_device *de
 
 static int qe_close(struct net_device *dev)
 {
-	struct sunqe *qep = (struct sunqe *) dev->priv;
+	struct sunqe *qep = dev->priv;
 
 	qe_stop(qep);
 	return 0;
@@ -547,7 +547,7 @@ static void qe_tx_reclaim(struct sunqe *
 
 static void qe_tx_timeout(struct net_device *dev)
 {
-	struct sunqe *qep = (struct sunqe *) dev->priv;
+	struct sunqe *qep = dev->priv;
 	int tx_full;
 
 	spin_lock_irq(&qep->lock);
@@ -573,7 +573,7 @@ out:
 /* Get a packet queued to go onto the wire. */
 static int qe_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	struct sunqe *qep = (struct sunqe *) dev->priv;
+	struct sunqe *qep = dev->priv;
 	struct sunqe_buffers *qbufs = qep->buffers;
 	__u32 txbuf_dvma, qbufs_dvma = qep->buffers_dvma;
 	unsigned char *txbuf;
@@ -625,7 +625,7 @@ static int qe_start_xmit(struct sk_buff 
 
 static void qe_set_multicast(struct net_device *dev)
 {
-	struct sunqe *qep = (struct sunqe *) dev->priv;
+	struct sunqe *qep = dev->priv;
 	struct dev_mc_list *dmi = dev->mc_list;
 	u8 new_mconfig = qep->mconfig;
 	char *addrs;
--- linux-2.6.git/drivers/net/dm9000.c
+++ linux-2.6.git/drivers/net/dm9000.c
@@ -308,7 +308,7 @@ static void dm9000_schedule_poll(board_i
 /* Our watchdog timed out. Called by the networking layer */
 static void dm9000_timeout(struct net_device *dev)
 {
-	board_info_t *db = (board_info_t *) dev->priv;
+	board_info_t *db = dev->priv;
 	u8 reg_save;
 	unsigned long flags;
 
@@ -546,7 +546,7 @@ dm9000_probe(struct platform_device *pde
 	dev_dbg(&pdev->dev, "dm9000_probe()\n");
 
 	/* setup board info structure */
-	db = (struct board_info *) ndev->priv;
+	db = ndev->priv;
 	memset(db, 0, sizeof (*db));
 
 	db->dev = &pdev->dev;
@@ -755,7 +755,7 @@ out:
 static int
 dm9000_open(struct net_device *dev)
 {
-	board_info_t *db = (board_info_t *) dev->priv;
+	board_info_t *db = dev->priv;
 	unsigned long irqflags = db->irq_res->flags & IRQF_TRIGGER_MASK;
 
 	if (netif_msg_ifup(db))
@@ -795,7 +795,7 @@ dm9000_open(struct net_device *dev)
 static void
 dm9000_init_dm9000(struct net_device *dev)
 {
-	board_info_t *db = (board_info_t *) dev->priv;
+	board_info_t *db = dev->priv;
 
 	dm9000_dbg(db, 1, "entering %s\n", __func__);
 
@@ -839,7 +839,7 @@ static int
 dm9000_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	unsigned long flags;
-	board_info_t *db = (board_info_t *) dev->priv;
+	board_info_t *db = dev->priv;
 
 	dm9000_dbg(db, 3, "%s:\n", __func__);
 
@@ -882,7 +882,7 @@ dm9000_start_xmit(struct sk_buff *skb, s
 static void
 dm9000_shutdown(struct net_device *dev)
 {
-	board_info_t *db = (board_info_t *) dev->priv;
+	board_info_t *db = dev->priv;
 
 	/* RESET device */
 	dm9000_phy_write(dev, 0, MII_BMCR, BMCR_RESET);	/* PHY RESET */
@@ -898,7 +898,7 @@ dm9000_shutdown(struct net_device *dev)
 static int
 dm9000_stop(struct net_device *ndev)
 {
-	board_info_t *db = (board_info_t *) ndev->priv;
+	board_info_t *db = ndev->priv;
 
 	if (netif_msg_ifdown(db))
 		dev_dbg(db->dev, "shutting down %s\n", ndev->name);
@@ -949,7 +949,7 @@ static irqreturn_t
 dm9000_interrupt(int irq, void *dev_id)
 {
 	struct net_device *dev = dev_id;
-	board_info_t *db = (board_info_t *) dev->priv;
+	board_info_t *db = dev->priv;
 	int int_status;
 	u8 reg_save;
 
@@ -1003,7 +1003,7 @@ struct dm9000_rxhdr {
 static void
 dm9000_rx(struct net_device *dev)
 {
-	board_info_t *db = (board_info_t *) dev->priv;
+	board_info_t *db = dev->priv;
 	struct dm9000_rxhdr rxhdr;
 	struct sk_buff *skb;
 	u8 rxbyte, *rdptr;
@@ -1215,7 +1215,7 @@ dm9000_write_eeprom(board_info_t *db, in
 static void
 dm9000_hash_table(struct net_device *dev)
 {
-	board_info_t *db = (board_info_t *) dev->priv;
+	board_info_t *db = dev->priv;
 	struct dev_mc_list *mcptr = dev->mc_list;
 	int mc_cnt = dev->mc_count;
 	int i, oft;
@@ -1279,7 +1279,7 @@ static void dm9000_msleep(board_info_t *
 static int
 dm9000_phy_read(struct net_device *dev, int phy_reg_unused, int reg)
 {
-	board_info_t *db = (board_info_t *) dev->priv;
+	board_info_t *db = dev->priv;
 	unsigned long flags;
 	unsigned int reg_save;
 	int ret;
@@ -1325,7 +1325,7 @@ dm9000_phy_read(struct net_device *dev, 
 static void
 dm9000_phy_write(struct net_device *dev, int phyaddr_unused, int reg, int value)
 {
-	board_info_t *db = (board_info_t *) dev->priv;
+	board_info_t *db = dev->priv;
 	unsigned long flags;
 	unsigned long reg_save;
 
@@ -1370,7 +1370,7 @@ dm9000_drv_suspend(struct platform_devic
 	board_info_t *db;
 
 	if (ndev) {
-		db = (board_info_t *) ndev->priv;
+		db = ndev->priv;
 		db->in_suspend = 1;
 
 		if (netif_running(ndev)) {
@@ -1385,7 +1385,7 @@ static int
 dm9000_drv_resume(struct platform_device *dev)
 {
 	struct net_device *ndev = platform_get_drvdata(dev);
-	board_info_t *db = (board_info_t *) ndev->priv;
+	board_info_t *db = ndev->priv;
 
 	if (ndev) {
 
--- linux-2.6.git/drivers/net/pppoe.c
+++ linux-2.6.git/drivers/net/pppoe.c
@@ -907,7 +907,7 @@ abort:
  ***********************************************************************/
 static int pppoe_xmit(struct ppp_channel *chan, struct sk_buff *skb)
 {
-	struct sock *sk = (struct sock *) chan->private;
+	struct sock *sk = chan->private;
 	return __pppoe_xmit(sk, skb);
 }
 
--- linux-2.6.git/drivers/misc/sgi-xp/xpnet.c
+++ linux-2.6.git/drivers/misc/sgi-xp/xpnet.c
@@ -170,8 +170,7 @@ xpnet_receive(short partid, int channel,
 {
 	struct sk_buff *skb;
 	bte_result_t bret;
-	struct xpnet_dev_private *priv =
-	    (struct xpnet_dev_private *)xpnet_device->priv;
+	struct xpnet_dev_private *priv = xpnet_device->priv;
 
 	if (!XPNET_VALID_MSG(msg)) {
 		/*
@@ -395,7 +394,7 @@ xpnet_dev_get_stats(struct net_device *d
 {
 	struct xpnet_dev_private *priv;
 
-	priv = (struct xpnet_dev_private *)dev->priv;
+	priv = dev->priv;
 
 	return &priv->stats;
 }
@@ -448,7 +447,7 @@ xpnet_dev_hard_start_xmit(struct sk_buff
 	struct xpnet_dev_private *priv;
 	u16 embedded_bytes;
 
-	priv = (struct xpnet_dev_private *)dev->priv;
+	priv = dev->priv;
 
 	dev_dbg(xpnet, ">skb->head=0x%p skb->data=0x%p skb->tail=0x%p "
 		"skb->end=0x%p skb->len=%d\n", (void *)skb->head,
@@ -585,7 +584,7 @@ xpnet_dev_tx_timeout(struct net_device *
 {
 	struct xpnet_dev_private *priv;
 
-	priv = (struct xpnet_dev_private *)dev->priv;
+	priv = dev->priv;
 
 	priv->stats.tx_errors++;
 	return;
--- linux-2.6.git/drivers/s390/net/lcs.c
+++ linux-2.6.git/drivers/s390/net/lcs.c
@@ -1286,7 +1286,7 @@ lcs_set_multicast_list(struct net_device
         struct lcs_card *card;
 
         LCS_DBF_TEXT(4, trace, "setmulti");
-        card = (struct lcs_card *) dev->priv;
+        card = dev->priv;
 
         if (!lcs_set_thread_start_bit(card, LCS_SET_MC_THREAD))
 		schedule_work(&card->kernel_thread_starter);
@@ -1601,7 +1601,7 @@ lcs_start_xmit(struct sk_buff *skb, stru
 	int rc;
 
 	LCS_DBF_TEXT(5, trace, "pktxmit");
-	card = (struct lcs_card *) dev->priv;
+	card = dev->priv;
 	rc = __lcs_start_xmit(card, skb, dev);
 	return rc;
 }
@@ -1857,7 +1857,7 @@ lcs_getstats(struct net_device *dev)
 	struct lcs_card *card;
 
 	LCS_DBF_TEXT(4, trace, "netstats");
-	card = (struct lcs_card *) dev->priv;
+	card = dev->priv;
 	return &card->stats;
 }
 
@@ -1872,7 +1872,7 @@ lcs_stop_device(struct net_device *dev)
 	int rc;
 
 	LCS_DBF_TEXT(2, trace, "stopdev");
-	card   = (struct lcs_card *) dev->priv;
+	card   = dev->priv;
 	netif_carrier_off(dev);
 	netif_tx_disable(dev);
 	dev->flags &= ~IFF_UP;
@@ -1895,7 +1895,7 @@ lcs_open_device(struct net_device *dev)
 	int rc;
 
 	LCS_DBF_TEXT(2, trace, "opendev");
-	card = (struct lcs_card *) dev->priv;
+	card = dev->priv;
 	/* initialize statistics */
 	rc = lcs_detect(card);
 	if (rc) {
--- linux-2.6.git/drivers/s390/net/qeth_l3_main.c
+++ linux-2.6.git/drivers/s390/net/qeth_l3_main.c
@@ -1845,7 +1845,7 @@ static void qeth_l3_vlan_rx_register(str
 static void qeth_l3_vlan_rx_add_vid(struct net_device *dev, unsigned short vid)
 {
 	struct net_device *vlandev;
-	struct qeth_card *card = (struct qeth_card *) dev->priv;
+	struct qeth_card *card = dev->priv;
 	struct in_device *in_dev;
 
 	if (card->info.type == QETH_CARD_TYPE_IQD)
--- linux-2.6.git/drivers/s390/net/claw.c
+++ linux-2.6.git/drivers/s390/net/claw.c
@@ -530,7 +530,7 @@ claw_open(struct net_device *dev)
 	 	printk(KERN_WARNING "claw: Bad device at open failing \n");
 		return -ENODEV;
 	}
-	privptr = (struct claw_privbk *)dev->priv;
+	privptr = dev->priv;
         /*   allocate and initialize CCW blocks */
 	if (privptr->buffs_alloc == 0) {
 	        rc=init_ccw_bk(dev);
@@ -1009,7 +1009,7 @@ claw_irq_tasklet ( unsigned long data )
 #endif
 	CLAW_DBF_TEXT(4,trace,"IRQtask");
 
-        privptr = (struct claw_privbk *) dev->priv;
+        privptr = dev->priv;
 
 #ifdef DEBUGMSG
         printk(KERN_INFO "%s: bh routine - state-%02x\n" ,
@@ -1044,7 +1044,7 @@ claw_release(struct net_device *dev)
 
 	if (!dev)
                 return 0;
-        privptr = (struct claw_privbk *) dev->priv;
+        privptr = dev->priv;
         if (!privptr)
                 return 0;
 #ifdef FUNCTRACE
@@ -1243,7 +1243,7 @@ claw_write_next ( struct chbk * p_ch )
         if (p_ch->claw_state == CLAW_STOP)
                 return;
         dev = (struct net_device *) p_ch->ndev;
-	privptr = (struct claw_privbk *) dev->priv;
+	privptr = dev->priv;
         claw_free_wrt_buf( dev );
 	if ((privptr->write_free_count > 0) &&
 	    !skb_queue_empty(&p_ch->collect_queue)) {
--- linux-2.6.git/drivers/s390/crypto/zcrypt_pcixcc.c
+++ linux-2.6.git/drivers/s390/crypto/zcrypt_pcixcc.c
@@ -677,8 +677,7 @@ static void zcrypt_pcixcc_receive(struct
 		.type = TYPE82_RSP_CODE,
 		.reply_code = REP82_ERROR_MACHINE_FAILURE,
 	};
-	struct response_type *resp_type =
-		(struct response_type *) msg->private;
+	struct response_type *resp_type = msg->private;
 	struct type86x_reply *t86r = reply->message;
 	int length;
 
--- linux-2.6.git/drivers/s390/block/dasd_fba.c
+++ linux-2.6.git/drivers/s390/block/dasd_fba.c
@@ -123,7 +123,7 @@ dasd_fba_check_characteristics(struct da
 	void *rdc_data;
 	int rc;
 
-	private = (struct dasd_fba_private *) device->private;
+	private = device->private;
 	if (private == NULL) {
 		private = kzalloc(sizeof(struct dasd_fba_private),
 				  GFP_KERNEL | GFP_DMA);
--- linux-2.6.git/drivers/s390/block/dasd_alias.c
+++ linux-2.6.git/drivers/s390/block/dasd_alias.c
@@ -187,7 +187,7 @@ int dasd_alias_make_device_known_to_lcu(
 	int is_lcu_known;
 	struct dasd_uid *uid;
 
-	private = (struct dasd_eckd_private *) device->private;
+	private = device->private;
 	uid = &private->uid;
 	spin_lock_irqsave(&aliastree.lock, flags);
 	is_lcu_known = 1;
@@ -249,7 +249,7 @@ void dasd_alias_disconnect_device_from_l
 	struct alias_server *server;
 	int was_pending;
 
-	private = (struct dasd_eckd_private *) device->private;
+	private = device->private;
 	lcu = private->lcu;
 	spin_lock_irqsave(&lcu->lock, flags);
 	list_del_init(&device->alias_list);
@@ -308,7 +308,7 @@ static int _add_device_to_lcu(struct ali
 	struct alias_pav_group *group;
 	struct dasd_uid *uid;
 
-	private = (struct dasd_eckd_private *) device->private;
+	private = device->private;
 	uid = &private->uid;
 	uid->type = lcu->uac->unit[uid->real_unit_addr].ua_type;
 	uid->base_unit_addr = lcu->uac->unit[uid->real_unit_addr].base_ua;
@@ -351,7 +351,7 @@ static void _remove_device_from_lcu(stru
 	struct dasd_eckd_private *private;
 	struct alias_pav_group *group;
 
-	private = (struct dasd_eckd_private *) device->private;
+	private = device->private;
 	list_move(&device->alias_list, &lcu->inactive_devices);
 	group = private->pavgroup;
 	if (!group)
@@ -441,13 +441,13 @@ static int _lcu_update(struct dasd_devic
 		list_for_each_entry_safe(device, tempdev, &pavgroup->baselist,
 					 alias_list) {
 			list_move(&device->alias_list, &lcu->active_devices);
-			private = (struct dasd_eckd_private *) device->private;
+			private = device->private;
 			private->pavgroup = NULL;
 		}
 		list_for_each_entry_safe(device, tempdev, &pavgroup->aliaslist,
 					 alias_list) {
 			list_move(&device->alias_list, &lcu->active_devices);
-			private = (struct dasd_eckd_private *) device->private;
+			private = device->private;
 			private->pavgroup = NULL;
 		}
 		list_del(&pavgroup->group);
@@ -559,7 +559,7 @@ int dasd_alias_add_device(struct dasd_de
 	unsigned long flags;
 	int rc;
 
-	private = (struct dasd_eckd_private *) device->private;
+	private = device->private;
 	lcu = private->lcu;
 	rc = 0;
 	spin_lock_irqsave(&lcu->lock, flags);
@@ -582,7 +582,7 @@ int dasd_alias_remove_device(struct dasd
 	struct alias_lcu *lcu;
 	unsigned long flags;
 
-	private = (struct dasd_eckd_private *) device->private;
+	private = device->private;
 	lcu = private->lcu;
 	spin_lock_irqsave(&lcu->lock, flags);
 	_remove_device_from_lcu(lcu, device);
@@ -599,7 +599,7 @@ struct dasd_device *dasd_alias_get_start
 	struct dasd_eckd_private *private, *alias_priv;
 	unsigned long flags;
 
-	private = (struct dasd_eckd_private *) base_device->private;
+	private = base_device->private;
 	group = private->pavgroup;
 	lcu = private->lcu;
 	if (!group || !lcu)
@@ -627,7 +627,7 @@ struct dasd_device *dasd_alias_get_start
 		group->next = list_first_entry(&alias_device->alias_list,
 					       struct dasd_device, alias_list);
 	spin_unlock_irqrestore(&lcu->lock, flags);
-	alias_priv = (struct dasd_eckd_private *) alias_device->private;
+	alias_priv = alias_device->private;
 	if ((alias_priv->count < private->count) && !alias_device->stopped)
 		return alias_device;
 	else
@@ -675,14 +675,14 @@ static void _restart_all_base_devices_on
 
 	/* active and inactive list can contain alias as well as base devices */
 	list_for_each_entry(device, &lcu->active_devices, alias_list) {
-		private = (struct dasd_eckd_private *) device->private;
+		private = device->private;
 		if (private->uid.type != UA_BASE_DEVICE)
 			continue;
 		dasd_schedule_block_bh(device->block);
 		dasd_schedule_device_bh(device);
 	}
 	list_for_each_entry(device, &lcu->inactive_devices, alias_list) {
-		private = (struct dasd_eckd_private *) device->private;
+		private = device->private;
 		if (private->uid.type != UA_BASE_DEVICE)
 			continue;
 		dasd_schedule_block_bh(device->block);
@@ -719,7 +719,7 @@ static void flush_all_alias_devices_on_l
 	spin_lock_irqsave(&lcu->lock, flags);
 	list_for_each_entry_safe(device, temp, &lcu->active_devices,
 				 alias_list) {
-		private = (struct dasd_eckd_private *) device->private;
+		private = device->private;
 		if (private->uid.type == UA_BASE_DEVICE)
 			continue;
 		list_move(&device->alias_list, &active);
@@ -854,7 +854,7 @@ void dasd_alias_handle_summary_unit_chec
 	char reason;
 	struct dasd_eckd_private *private;
 
-	private = (struct dasd_eckd_private *) device->private;
+	private = device->private;
 
 	reason = irb->ecw[8];
 	DEV_MESSAGE(KERN_WARNING, device, "%s %x",
--- linux-2.6.git/drivers/s390/block/dasd_eckd.c
+++ linux-2.6.git/drivers/s390/block/dasd_eckd.c
@@ -165,7 +165,7 @@ check_XRC (struct ccw1         *de_ccw,
         struct dasd_eckd_private *private;
 	int rc;
 
-        private = (struct dasd_eckd_private *) device->private;
+        private = device->private;
 	if (!private->rdc_data.facilities.XRC_supported)
 		return 0;
 
@@ -191,7 +191,7 @@ define_extent(struct ccw1 * ccw, struct 
 	struct ch_t geo, beg, end;
 	int rc = 0;
 
-	private = (struct dasd_eckd_private *) device->private;
+	private = device->private;
 
 	ccw->cmd_code = DASD_ECKD_CCW_DEFINE_EXTENT;
 	ccw->flags = 0;
@@ -276,7 +276,7 @@ static int check_XRC_on_prefix(struct PF
 	struct dasd_eckd_private *private;
 	int rc;
 
-	private = (struct dasd_eckd_private *) device->private;
+	private = device->private;
 	if (!private->rdc_data.facilities.XRC_supported)
 		return 0;
 
@@ -301,8 +301,8 @@ static int prefix(struct ccw1 *ccw, stru
 	struct ch_t geo, beg, end;
 	int rc = 0;
 
-	basepriv = (struct dasd_eckd_private *) basedev->private;
-	startpriv = (struct dasd_eckd_private *) startdev->private;
+	basepriv = basedev->private;
+	startpriv = startdev->private;
 	data = &pfxdata->define_extend;
 
 	ccw->cmd_code = DASD_ECKD_CCW_PFX;
@@ -405,7 +405,7 @@ locate_record(struct ccw1 *ccw, struct L
 	int sector;
 	int dn, d;
 
-	private = (struct dasd_eckd_private *) device->private;
+	private = device->private;
 
 	DBF_DEV_EVENT(DBF_INFO, device,
 		  "Locate: trk %d, rec %d, no_rec %d, cmd %d, reclen %d",
@@ -542,7 +542,7 @@ dasd_eckd_generate_uid(struct dasd_devic
 	struct dasd_eckd_private *private;
 	struct dasd_eckd_confdata *confdata;
 
-	private = (struct dasd_eckd_private *) device->private;
+	private = device->private;
 	if (!private)
 		return -ENODEV;
 	confdata = &private->conf_data;
@@ -656,7 +656,7 @@ dasd_eckd_read_conf(struct dasd_device *
 	struct dasd_eckd_private *private;
 	struct dasd_eckd_path *path_data;
 
-	private = (struct dasd_eckd_private *) device->private;
+	private = device->private;
 	path_data = (struct dasd_eckd_path *) &private->path_data;
 	path_data->opm = ccw_device_get_path_mask(device->cdev);
 	lpm = 0x80;
@@ -716,7 +716,7 @@ static int dasd_eckd_read_features(struc
 	int rc;
 	struct dasd_eckd_private *private;
 
-	private = (struct dasd_eckd_private *) device->private;
+	private = device->private;
 	cqr = dasd_smalloc_request(dasd_eckd_discipline.name,
 				   1 /* PSF */	+ 1 /* RSSD */ ,
 				   (sizeof(struct dasd_psf_prssd_data) +
@@ -845,7 +845,7 @@ static int dasd_eckd_validate_server(str
 	rc = dasd_eckd_psf_ssc(device);
 	/* may be requested feature is not available on server,
 	 * therefore just report error and go ahead */
-	private = (struct dasd_eckd_private *) device->private;
+	private = device->private;
 	DEV_MESSAGE(KERN_INFO, device,
 		    "PSF-SSC on storage subsystem %s.%s.%04x returned rc=%d",
 		    private->uid.vendor, private->uid.serial,
@@ -866,7 +866,7 @@ dasd_eckd_check_characteristics(struct d
 	void *rdc_data;
 	int is_known, rc;
 
-	private = (struct dasd_eckd_private *) device->private;
+	private = device->private;
 	if (private == NULL) {
 		private = kzalloc(sizeof(struct dasd_eckd_private),
 				  GFP_KERNEL | GFP_DMA);
@@ -973,7 +973,7 @@ dasd_eckd_analysis_ccw(struct dasd_devic
 	int cplength, datasize;
 	int i;
 
-	private = (struct dasd_eckd_private *) device->private;
+	private = device->private;
 
 	cplength = 8;
 	datasize = sizeof(struct DE_eckd_data) + 2*sizeof(struct LO_eckd_data);
@@ -1036,7 +1036,7 @@ dasd_eckd_analysis_callback(struct dasd_
 	struct dasd_device *device;
 
 	device = init_cqr->startdev;
-	private = (struct dasd_eckd_private *) device->private;
+	private = device->private;
 	private->init_cqr_status = init_cqr->status;
 	dasd_sfree_request(init_cqr, device);
 	dasd_kick_device(device);
@@ -1069,7 +1069,7 @@ dasd_eckd_end_analysis(struct dasd_block
 	int status, i;
 
 	device = block->base;
-	private = (struct dasd_eckd_private *) device->private;
+	private = device->private;
 	status = private->init_cqr_status;
 	private->init_cqr_status = -1;
 	if (status != DASD_CQR_DONE) {
@@ -1188,7 +1188,7 @@ dasd_eckd_format_device(struct dasd_devi
 	int cplength, datasize;
 	int i;
 
-	private = (struct dasd_eckd_private *) device->private;
+	private = device->private;
 	rpt = recs_per_track(&private->rdc_data, 0, fdata->blksize);
 	cyl = fdata->start_unit / private->rdc_data.trk_per_cyl;
 	head = fdata->start_unit % private->rdc_data.trk_per_cyl;
@@ -1453,7 +1453,7 @@ static struct dasd_ccw_req *dasd_eckd_bu
 	struct dasd_device *basedev;
 
 	basedev = block->base;
-	private = (struct dasd_eckd_private *) basedev->private;
+	private = basedev->private;
 	if (rq_data_dir(req) == READ)
 		cmd = DASD_ECKD_CCW_READ_MT;
 	else if (rq_data_dir(req) == WRITE)
@@ -1704,7 +1704,7 @@ static struct dasd_ccw_req *dasd_eckd_bu
 	startdev = dasd_alias_get_start_dev(base);
 	if (!startdev)
 		startdev = base;
-	private = (struct dasd_eckd_private *) startdev->private;
+	private = startdev->private;
 	if (private->count >= DASD_ECKD_CHANQ_MAX_SIZE)
 		return ERR_PTR(-EBUSY);
 
@@ -1736,7 +1736,7 @@ dasd_eckd_fill_info(struct dasd_device *
 {
 	struct dasd_eckd_private *private;
 
-	private = (struct dasd_eckd_private *) device->private;
+	private = device->private;
 	info->label_block = 2;
 	info->FBA_layout = private->uses_cdl ? 0 : 1;
 	info->format = private->uses_cdl ? DASD_FORMAT_CDL : DASD_FORMAT_LDL;
@@ -1944,8 +1944,7 @@ dasd_eckd_performance(struct dasd_device
 static int
 dasd_eckd_get_attrib(struct dasd_device *device, void __user *argp)
 {
-	struct dasd_eckd_private *private =
-		(struct dasd_eckd_private *)device->private;
+	struct dasd_eckd_private *private = device->private;
 	struct attrib_data_t attrib = private->attrib;
 	int rc;
 
@@ -1969,8 +1968,7 @@ dasd_eckd_get_attrib(struct dasd_device 
 static int
 dasd_eckd_set_attrib(struct dasd_device *device, void __user *argp)
 {
-	struct dasd_eckd_private *private =
-		(struct dasd_eckd_private *)device->private;
+	struct dasd_eckd_private *private = device->private;
 	struct attrib_data_t attrib;
 
 	if (!capable(CAP_SYS_ADMIN))
--- linux-2.6.git/drivers/s390/block/dasd_diag.c
+++ linux-2.6.git/drivers/s390/block/dasd_diag.c
@@ -100,7 +100,7 @@ mdsk_init_io(struct dasd_device *device,
 	struct dasd_diag_init_io *iib;
 	int rc;
 
-	private = (struct dasd_diag_private *) device->private;
+	private = device->private;
 	iib = &private->iib;
 	memset(iib, 0, sizeof (struct dasd_diag_init_io));
 
@@ -126,7 +126,7 @@ mdsk_term_io(struct dasd_device * device
 	struct dasd_diag_init_io *iib;
 	int rc;
 
-	private = (struct dasd_diag_private *) device->private;
+	private = device->private;
 	iib = &private->iib;
 	memset(iib, 0, sizeof (struct dasd_diag_init_io));
 	iib->dev_nr = private->dev_id.devno;
@@ -165,7 +165,7 @@ dasd_start_diag(struct dasd_ccw_req * cq
 		cqr->status = DASD_CQR_ERROR;
 		return -EIO;
 	}
-	private = (struct dasd_diag_private *) device->private;
+	private = device->private;
 	dreq = (struct dasd_diag_req *) cqr->data;
 
 	private->iob.dev_nr = private->dev_id.devno;
@@ -318,7 +318,7 @@ dasd_diag_check_device(struct dasd_devic
 	unsigned int sb, bsize;
 	int rc;
 
-	private = (struct dasd_diag_private *) device->private;
+	private = device->private;
 	if (private == NULL) {
 		private = kzalloc(sizeof(struct dasd_diag_private),GFP_KERNEL);
 		if (private == NULL) {
@@ -567,7 +567,7 @@ dasd_diag_fill_info(struct dasd_device *
 {
 	struct dasd_diag_private *private;
 
-	private = (struct dasd_diag_private *) device->private;
+	private = device->private;
 	info->label_block = (unsigned int) private->pt_block;
 	info->FBA_layout = 1;
 	info->format = DASD_FORMAT_LDL;
--- linux-2.6.git/drivers/md/dm-crypt.c
+++ linux-2.6.git/drivers/md/dm-crypt.c
@@ -1080,7 +1080,7 @@ bad_cipher:
 
 static void crypt_dtr(struct dm_target *ti)
 {
-	struct crypt_config *cc = (struct crypt_config *) ti->private;
+	struct crypt_config *cc = ti->private;
 
 	destroy_workqueue(cc->io_queue);
 	destroy_workqueue(cc->crypt_queue);
@@ -1128,7 +1128,7 @@ static int crypt_map(struct dm_target *t
 static int crypt_status(struct dm_target *ti, status_type_t type,
 			char *result, unsigned int maxlen)
 {
-	struct crypt_config *cc = (struct crypt_config *) ti->private;
+	struct crypt_config *cc = ti->private;
 	unsigned int sz = 0;
 
 	switch (type) {
--- linux-2.6.git/drivers/md/dm-mpath.c
+++ linux-2.6.git/drivers/md/dm-mpath.c
@@ -806,7 +806,7 @@ static int multipath_ctr(struct dm_targe
 
 static void multipath_dtr(struct dm_target *ti)
 {
-	struct multipath *m = (struct multipath *) ti->private;
+	struct multipath *m = ti->private;
 
 	flush_workqueue(kmultipathd);
 	free_multipath(m);
@@ -820,7 +820,7 @@ static int multipath_map(struct dm_targe
 {
 	int r;
 	struct dm_mpath_io *mpio;
-	struct multipath *m = (struct multipath *) ti->private;
+	struct multipath *m = ti->private;
 
 	mpio = mempool_alloc(m->mpio_pool, GFP_NOIO);
 	dm_bio_record(&mpio->details, bio);
@@ -1154,7 +1154,7 @@ static int multipath_end_io(struct dm_ta
  */
 static void multipath_presuspend(struct dm_target *ti)
 {
-	struct multipath *m = (struct multipath *) ti->private;
+	struct multipath *m = ti->private;
 
 	queue_if_no_path(m, 0, 1);
 }
@@ -1164,7 +1164,7 @@ static void multipath_presuspend(struct 
  */
 static void multipath_resume(struct dm_target *ti)
 {
-	struct multipath *m = (struct multipath *) ti->private;
+	struct multipath *m = ti->private;
 	unsigned long flags;
 
 	spin_lock_irqsave(&m->lock, flags);
@@ -1193,7 +1193,7 @@ static int multipath_status(struct dm_ta
 {
 	int sz = 0;
 	unsigned long flags;
-	struct multipath *m = (struct multipath *) ti->private;
+	struct multipath *m = ti->private;
 	struct hw_handler *hwh = &m->hw_handler;
 	struct priority_group *pg;
 	struct pgpath *p;
@@ -1300,7 +1300,7 @@ static int multipath_message(struct dm_t
 {
 	int r;
 	struct dm_dev *dev;
-	struct multipath *m = (struct multipath *) ti->private;
+	struct multipath *m = ti->private;
 	action_fn action;
 
 	if (argc == 1) {
@@ -1349,7 +1349,7 @@ static int multipath_ioctl(struct dm_tar
 			   struct file *filp, unsigned int cmd,
 			   unsigned long arg)
 {
-	struct multipath *m = (struct multipath *) ti->private;
+	struct multipath *m = ti->private;
 	struct block_device *bdev = NULL;
 	unsigned long flags;
 	struct file fake_file = {};
--- linux-2.6.git/drivers/md/raid5.c
+++ linux-2.6.git/drivers/md/raid5.c
@@ -1245,7 +1245,7 @@ static void raid5_build_block (struct st
 static void error(mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	char b[BDEVNAME_SIZE];
-	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
+	raid5_conf_t *conf = mddev->private;
 	pr_debug("raid5: error called\n");
 
 	if (!test_bit(Faulty, &rdev->flags)) {
@@ -3697,7 +3697,7 @@ static sector_t reshape_request(mddev_t 
 	 * As the reads complete, handle_stripe will copy the data
 	 * into the destination stripe and release that stripe.
 	 */
-	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
+	raid5_conf_t *conf = mddev->private;
 	struct stripe_head *sh;
 	int pd_idx;
 	sector_t first_sector, last_sector;
@@ -3835,7 +3835,7 @@ static sector_t reshape_request(mddev_t 
 /* FIXME go_faster isn't used */
 static inline sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, int go_faster)
 {
-	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
+	raid5_conf_t *conf = mddev->private;
 	struct stripe_head *sh;
 	int pd_idx;
 	int raid_disks = conf->raid_disks;
@@ -4437,7 +4437,7 @@ abort:
 
 static int stop(mddev_t *mddev)
 {
-	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
+	raid5_conf_t *conf = mddev->private;
 
 	md_unregister_thread(mddev->thread);
 	mddev->thread = NULL;
@@ -4489,7 +4489,7 @@ static void printall (struct seq_file *s
 
 static void status (struct seq_file *seq, mddev_t *mddev)
 {
-	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
+	raid5_conf_t *conf = mddev->private;
 	int i;
 
 	seq_printf (seq, " level %d, %dk chunk, algorithm %d", mddev->level, mddev->chunk_size >> 10, mddev->layout);
--- linux-2.6.git/drivers/md/dm-linear.c
+++ linux-2.6.git/drivers/md/dm-linear.c
@@ -63,7 +63,7 @@ static int linear_ctr(struct dm_target *
 
 static void linear_dtr(struct dm_target *ti)
 {
-	struct linear_c *lc = (struct linear_c *) ti->private;
+	struct linear_c *lc = ti->private;
 
 	dm_put_device(ti, lc->dev);
 	kfree(lc);
@@ -72,7 +72,7 @@ static void linear_dtr(struct dm_target 
 static int linear_map(struct dm_target *ti, struct bio *bio,
 		      union map_info *map_context)
 {
-	struct linear_c *lc = (struct linear_c *) ti->private;
+	struct linear_c *lc = ti->private;
 
 	bio->bi_bdev = lc->dev->bdev;
 	bio->bi_sector = lc->start + (bio->bi_sector - ti->begin);
@@ -83,7 +83,7 @@ static int linear_map(struct dm_target *
 static int linear_status(struct dm_target *ti, status_type_t type,
 			 char *result, unsigned int maxlen)
 {
-	struct linear_c *lc = (struct linear_c *) ti->private;
+	struct linear_c *lc = ti->private;
 
 	switch (type) {
 	case STATUSTYPE_INFO:
@@ -102,7 +102,7 @@ static int linear_ioctl(struct dm_target
 			struct file *filp, unsigned int cmd,
 			unsigned long arg)
 {
-	struct linear_c *lc = (struct linear_c *) ti->private;
+	struct linear_c *lc = ti->private;
 	struct block_device *bdev = lc->dev->bdev;
 	struct file fake_file = {};
 	struct dentry fake_dentry = {};
--- linux-2.6.git/drivers/md/faulty.c
+++ linux-2.6.git/drivers/md/faulty.c
@@ -168,7 +168,7 @@ static void add_sector(conf_t *conf, sec
 static int make_request(struct request_queue *q, struct bio *bio)
 {
 	mddev_t *mddev = q->queuedata;
-	conf_t *conf = (conf_t*)mddev->private;
+	conf_t *conf = mddev->private;
 	int failit = 0;
 
 	if (bio_data_dir(bio) == WRITE) {
@@ -221,7 +221,7 @@ static int make_request(struct request_q
 
 static void status(struct seq_file *seq, mddev_t *mddev)
 {
-	conf_t *conf = (conf_t*)mddev->private;
+	conf_t *conf = mddev->private;
 	int n;
 
 	if ((n=atomic_read(&conf->counters[WriteTransient])) != 0)
@@ -307,7 +307,7 @@ static int run(mddev_t *mddev)
 
 static int stop(mddev_t *mddev)
 {
-	conf_t *conf = (conf_t *)mddev->private;
+	conf_t *conf = mddev->private;
 
 	kfree(conf);
 	mddev->private = NULL;
--- linux-2.6.git/drivers/md/dm-raid1.c
+++ linux-2.6.git/drivers/md/dm-raid1.c
@@ -1594,7 +1594,7 @@ err_free_context:
 
 static void mirror_dtr(struct dm_target *ti)
 {
-	struct mirror_set *ms = (struct mirror_set *) ti->private;
+	struct mirror_set *ms = ti->private;
 
 	del_timer_sync(&ms->timer);
 	flush_workqueue(ms->kmirrord_wq);
@@ -1677,7 +1677,7 @@ static int mirror_end_io(struct dm_targe
 			 int error, union map_info *map_context)
 {
 	int rw = bio_rw(bio);
-	struct mirror_set *ms = (struct mirror_set *) ti->private;
+	struct mirror_set *ms = ti->private;
 	struct mirror *m = NULL;
 	struct dm_bio_details *bd = NULL;
 	struct dm_raid1_read_record *read_record = map_context->ptr;
@@ -1741,7 +1741,7 @@ out:
 
 static void mirror_presuspend(struct dm_target *ti)
 {
-	struct mirror_set *ms = (struct mirror_set *) ti->private;
+	struct mirror_set *ms = ti->private;
 	struct dm_dirty_log *log = ms->rh.log;
 
 	atomic_set(&ms->suspend, 1);
@@ -1818,7 +1818,7 @@ static int mirror_status(struct dm_targe
 			 char *result, unsigned int maxlen)
 {
 	unsigned int m, sz = 0;
-	struct mirror_set *ms = (struct mirror_set *) ti->private;
+	struct mirror_set *ms = ti->private;
 	struct dm_dirty_log *log = ms->rh.log;
 	char buffer[ms->nr_mirrors + 1];
 
--- linux-2.6.git/drivers/md/dm-stripe.c
+++ linux-2.6.git/drivers/md/dm-stripe.c
@@ -198,7 +198,7 @@ static int stripe_ctr(struct dm_target *
 static void stripe_dtr(struct dm_target *ti)
 {
 	unsigned int i;
-	struct stripe_c *sc = (struct stripe_c *) ti->private;
+	struct stripe_c *sc = ti->private;
 
 	for (i = 0; i < sc->stripes; i++)
 		dm_put_device(ti, sc->stripe[i].dev);
@@ -210,7 +210,7 @@ static void stripe_dtr(struct dm_target 
 static int stripe_map(struct dm_target *ti, struct bio *bio,
 		      union map_info *map_context)
 {
-	struct stripe_c *sc = (struct stripe_c *) ti->private;
+	struct stripe_c *sc = ti->private;
 
 	sector_t offset = bio->bi_sector - ti->begin;
 	sector_t chunk = offset >> sc->chunk_shift;
@@ -238,7 +238,7 @@ static int stripe_map(struct dm_target *
 static int stripe_status(struct dm_target *ti,
 			 status_type_t type, char *result, unsigned int maxlen)
 {
-	struct stripe_c *sc = (struct stripe_c *) ti->private;
+	struct stripe_c *sc = ti->private;
 	char buffer[sc->stripes + 1];
 	unsigned int sz = 0;
 	unsigned int i;
--- linux-2.6.git/drivers/isdn/i4l/isdn_net.c
+++ linux-2.6.git/drivers/isdn/i4l/isdn_net.c
@@ -823,7 +823,7 @@ isdn_net_dial(void)
 void
 isdn_net_hangup(struct net_device *d)
 {
-	isdn_net_local *lp = (isdn_net_local *) d->priv;
+	isdn_net_local *lp = d->priv;
 	isdn_ctrl cmd;
 #ifdef CONFIG_ISDN_X25
 	struct concap_proto *cprot = lp->netdev->cprot;
@@ -1054,7 +1054,7 @@ isdn_net_xmit(struct net_device *ndev, s
 {
 	isdn_net_dev *nd;
 	isdn_net_local *slp;
-	isdn_net_local *lp = (isdn_net_local *) ndev->priv;
+	isdn_net_local *lp = ndev->priv;
 	int retv = 0;
 
 	if (((isdn_net_local *) (ndev->priv))->master) {
@@ -1118,7 +1118,7 @@ isdn_net_xmit(struct net_device *ndev, s
 static void
 isdn_net_adjust_hdr(struct sk_buff *skb, struct net_device *dev)
 {
-	isdn_net_local *lp = (isdn_net_local *) dev->priv;
+	isdn_net_local *lp = dev->priv;
 	if (!skb)
 		return;
 	if (lp->p_encap == ISDN_NET_ENCAP_ETHER) {
@@ -1133,7 +1133,7 @@ isdn_net_adjust_hdr(struct sk_buff *skb,
 
 static void isdn_net_tx_timeout(struct net_device * ndev)
 {
-	isdn_net_local *lp = (isdn_net_local *) ndev->priv;
+	isdn_net_local *lp = ndev->priv;
 
 	printk(KERN_WARNING "isdn_tx_timeout dev %s dialstate %d\n", ndev->name, lp->dialstate);
 	if (!lp->dialstate){
@@ -1167,7 +1167,7 @@ static void isdn_net_tx_timeout(struct n
 static int
 isdn_net_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
-	isdn_net_local *lp = (isdn_net_local *) ndev->priv;
+	isdn_net_local *lp = ndev->priv;
 #ifdef CONFIG_ISDN_X25
 	struct concap_proto * cprot = lp -> netdev -> cprot;
 /* At this point hard_start_xmit() passes control to the encapsulation
@@ -1348,7 +1348,7 @@ isdn_net_close(struct net_device *dev)
 static struct net_device_stats *
 isdn_net_get_stats(struct net_device *dev)
 {
-	isdn_net_local *lp = (isdn_net_local *) dev->priv;
+	isdn_net_local *lp = dev->priv;
 	return &lp->stats;
 }
 
@@ -1427,7 +1427,7 @@ isdn_net_ciscohdlck_alloc_skb(isdn_net_l
 static int
 isdn_ciscohdlck_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
-	isdn_net_local *lp = (isdn_net_local *) dev->priv;
+	isdn_net_local *lp = dev->priv;
 	unsigned long len = 0;
 	unsigned long expires = 0;
 	int tmp = 0;
@@ -1769,7 +1769,7 @@ isdn_net_ciscohdlck_receive(isdn_net_loc
 static void
 isdn_net_receive(struct net_device *ndev, struct sk_buff *skb)
 {
-	isdn_net_local *lp = (isdn_net_local *) ndev->priv;
+	isdn_net_local *lp = ndev->priv;
 	isdn_net_local *olp = lp;	/* original 'lp' */
 #ifdef CONFIG_ISDN_X25
 	struct concap_proto *cprot = lp -> netdev -> cprot;
@@ -1783,7 +1783,7 @@ isdn_net_receive(struct net_device *ndev
 		 * handle master's statistics and hangup-timeout
 		 */
 		ndev = lp->master;
-		lp = (isdn_net_local *) ndev->priv;
+		lp = ndev->priv;
 		lp->stats.rx_packets++;
 		lp->stats.rx_bytes += skb->len;
 	}
--- linux-2.6.git/drivers/isdn/i4l/isdn_concap.c
+++ linux-2.6.git/drivers/isdn/i4l/isdn_concap.c
@@ -61,7 +61,7 @@ static int isdn_concap_dl_data_req(struc
 static int isdn_concap_dl_connect_req(struct concap_proto *concap)
 {
 	struct net_device *ndev = concap -> net_dev;
-	isdn_net_local *lp = (isdn_net_local *) ndev->priv;
+	isdn_net_local *lp = ndev->priv;
 	int ret;
 	IX25DEBUG( "isdn_concap_dl_connect_req: %s \n", ndev -> name);
 
--- linux-2.6.git/drivers/isdn/i4l/isdn_ppp.c
+++ linux-2.6.git/drivers/isdn/i4l/isdn_ppp.c
@@ -1987,7 +1987,7 @@ isdn_ppp_dev_ioctl_stats(int slot, struc
 {
 	struct ppp_stats __user *res = ifr->ifr_data;
 	struct ppp_stats t;
-	isdn_net_local *lp = (isdn_net_local *) dev->priv;
+	isdn_net_local *lp = dev->priv;
 
 	if (!access_ok(VERIFY_WRITE, res, sizeof(struct ppp_stats)))
 		return -EFAULT;
@@ -2026,7 +2026,7 @@ isdn_ppp_dev_ioctl(struct net_device *de
 {
 	int error=0;
 	int len;
-	isdn_net_local *lp = (isdn_net_local *) dev->priv;
+	isdn_net_local *lp = dev->priv;
 
 
 	if (lp->p_encap != ISDN_NET_ENCAP_SYNCPPP)
@@ -2093,7 +2093,7 @@ isdn_ppp_dial_slave(char *name)
 
 	sdev = lp->slave;
 	while (sdev) {
-		isdn_net_local *mlp = (isdn_net_local *) sdev->priv;
+		isdn_net_local *mlp = sdev->priv;
 		if (!(mlp->flags & ISDN_NET_CONNECTED))
 			break;
 		sdev = mlp->slave;
@@ -2124,7 +2124,7 @@ isdn_ppp_hangup_slave(char *name)
 
 	sdev = lp->slave;
 	while (sdev) {
-		isdn_net_local *mlp = (isdn_net_local *) sdev->priv;
+		isdn_net_local *mlp = sdev->priv;
 
 		if (mlp->slave) { /* find last connected link in chain */
 			isdn_net_local *nlp = (isdn_net_local *) mlp->slave->priv;
--- linux-2.6.git/drivers/acpi/processor_thermal.c
+++ linux-2.6.git/drivers/acpi/processor_thermal.c
@@ -440,7 +440,7 @@ struct thermal_cooling_device_ops proces
 
 static int acpi_processor_limit_seq_show(struct seq_file *seq, void *offset)
 {
-	struct acpi_processor *pr = (struct acpi_processor *)seq->private;
+	struct acpi_processor *pr = seq->private;
 
 
 	if (!pr)
--- linux-2.6.git/drivers/media/video/cx18/cx18-dvb.c
+++ linux-2.6.git/drivers/media/video/cx18/cx18-dvb.c
@@ -67,7 +67,7 @@ static int dvb_register(struct cx18_stre
 static int cx18_dvb_start_feed(struct dvb_demux_feed *feed)
 {
 	struct dvb_demux *demux = feed->demux;
-	struct cx18_stream *stream = (struct cx18_stream *) demux->priv;
+	struct cx18_stream *stream = demux->priv;
 	struct cx18 *cx = stream->cx;
 	int ret = -EINVAL;
 	u32 v;
@@ -113,7 +113,7 @@ static int cx18_dvb_start_feed(struct dv
 static int cx18_dvb_stop_feed(struct dvb_demux_feed *feed)
 {
 	struct dvb_demux *demux = feed->demux;
-	struct cx18_stream *stream = (struct cx18_stream *)demux->priv;
+	struct cx18_stream *stream = demux->priv;
 	struct cx18 *cx = stream->cx;
 	int ret = -EINVAL;
 
--- linux-2.6.git/drivers/media/video/usbvideo/vicam.c
+++ linux-2.6.git/drivers/media/video/usbvideo/vicam.c
@@ -748,8 +748,7 @@ static int
 vicam_open(struct inode *inode, struct file *file)
 {
 	struct video_device *dev = video_devdata(file);
-	struct vicam_camera *cam =
-	    (struct vicam_camera *) dev->priv;
+	struct vicam_camera *cam = dev->priv;
 	DBG("open\n");
 
 	if (!cam) {
--- linux-2.6.git/drivers/media/video/au0828/au0828-dvb.c
+++ linux-2.6.git/drivers/media/video/au0828/au0828-dvb.c
@@ -154,7 +154,7 @@ err:
 static int au0828_dvb_start_feed(struct dvb_demux_feed *feed)
 {
 	struct dvb_demux *demux = feed->demux;
-	struct au0828_dev *dev = (struct au0828_dev *) demux->priv;
+	struct au0828_dev *dev = demux->priv;
 	struct au0828_dvb *dvb = &dev->dvb;
 	int ret = 0;
 
@@ -182,7 +182,7 @@ static int au0828_dvb_start_feed(struct 
 static int au0828_dvb_stop_feed(struct dvb_demux_feed *feed)
 {
 	struct dvb_demux *demux = feed->demux;
-	struct au0828_dev *dev = (struct au0828_dev *) demux->priv;
+	struct au0828_dev *dev = demux->priv;
 	struct au0828_dvb *dvb = &dev->dvb;
 	int ret = 0;
 
--- linux-2.6.git/drivers/media/video/pwc/pwc-if.c
+++ linux-2.6.git/drivers/media/video/pwc/pwc-if.c
@@ -1113,7 +1113,7 @@ static int pwc_video_open(struct inode *
 
 	PWC_DEBUG_OPEN(">> video_open called(vdev = 0x%p).\n", vdev);
 
-	pdev = (struct pwc_device *)vdev->priv;
+	pdev = vdev->priv;
 	BUG_ON(!pdev);
 	if (pdev->vopen) {
 		PWC_DEBUG_OPEN("I'm busy, someone is using the device.\n");
@@ -1234,7 +1234,7 @@ static int pwc_video_close(struct inode 
 	PWC_DEBUG_OPEN(">> video_close called(vdev = 0x%p).\n", vdev);
 
 	lock_kernel();
-	pdev = (struct pwc_device *)vdev->priv;
+	pdev = vdev->priv;
 	if (pdev->vopen == 0)
 		PWC_DEBUG_MODULE("video_close() called on closed device?\n");
 
--- linux-2.6.git/drivers/media/dvb/bt8xx/dst_ca.c
+++ linux-2.6.git/drivers/media/dvb/bt8xx/dst_ca.c
@@ -555,7 +555,7 @@ free_mem_and_exit:
 static int dst_ca_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long ioctl_arg)
 {
 	struct dvb_device* dvbdev = (struct dvb_device*) file->private_data;
-	struct dst_state* state = (struct dst_state*) dvbdev->priv;
+	struct dst_state* state = dvbdev->priv;
 	struct ca_slot_info *p_ca_slot_info;
 	struct ca_caps *p_ca_caps;
 	struct ca_msg *p_ca_message;
--- linux-2.6.git/drivers/media/dvb/ttpci/av7110_av.c
+++ linux-2.6.git/drivers/media/dvb/ttpci/av7110_av.c
@@ -93,7 +93,7 @@ static void p_to_t(u8 const *buf, long i
 
 int av7110_record_cb(struct dvb_filter_pes2ts *p2t, u8 *buf, size_t len)
 {
-	struct dvb_demux_feed *dvbdmxfeed = (struct dvb_demux_feed *) p2t->priv;
+	struct dvb_demux_feed *dvbdmxfeed = p2t->priv;
 
 	if (!(dvbdmxfeed->ts_type & TS_PACKET))
 		return 0;
@@ -783,7 +783,7 @@ static void p_to_t(u8 const *buf, long i
 int av7110_write_to_decoder(struct dvb_demux_feed *feed, const u8 *buf, size_t len)
 {
 	struct dvb_demux *demux = feed->demux;
-	struct av7110 *av7110 = (struct av7110 *) demux->priv;
+	struct av7110 *av7110 = demux->priv;
 	struct ipack *ipack = &av7110->ipack[feed->pes_type];
 
 	dprintk(2, "av7110:%p, \n", av7110);
--- linux-2.6.git/drivers/media/dvb/ttpci/budget-core.c
+++ linux-2.6.git/drivers/media/dvb/ttpci/budget-core.c
@@ -315,7 +315,7 @@ int ttpci_budget_debiwrite(struct budget
 static int budget_start_feed(struct dvb_demux_feed *feed)
 {
 	struct dvb_demux *demux = feed->demux;
-	struct budget *budget = (struct budget *) demux->priv;
+	struct budget *budget = demux->priv;
 	int status = 0;
 
 	dprintk(2, "budget: %p\n", budget);
@@ -334,7 +334,7 @@ static int budget_start_feed(struct dvb_
 static int budget_stop_feed(struct dvb_demux_feed *feed)
 {
 	struct dvb_demux *demux = feed->demux;
-	struct budget *budget = (struct budget *) demux->priv;
+	struct budget *budget = demux->priv;
 	int status = 0;
 
 	dprintk(2, "budget: %p\n", budget);
--- linux-2.6.git/drivers/media/dvb/ttusb-dec/ttusb_dec.c
+++ linux-2.6.git/drivers/media/dvb/ttusb-dec/ttusb_dec.c
@@ -1096,7 +1096,7 @@ static int ttusb_dec_stop_sec_feed(struc
 {
 	struct ttusb_dec *dec = dvbdmxfeed->demux->priv;
 	u8 b0[] = { 0x00, 0x00 };
-	struct filter_info *finfo = (struct filter_info *)dvbdmxfeed->priv;
+	struct filter_info *finfo = dvbdmxfeed->priv;
 	unsigned long flags;
 
 	b0[1] = finfo->stream_id;
--- linux-2.6.git/drivers/message/i2o/i2o_proc.c
+++ linux-2.6.git/drivers/message/i2o/i2o_proc.c
@@ -296,7 +296,7 @@ static char *bus_strings[] = {
 
 static int i2o_seq_show_hrt(struct seq_file *seq, void *v)
 {
-	struct i2o_controller *c = (struct i2o_controller *)seq->private;
+	struct i2o_controller *c = seq->private;
 	i2o_hrt *hrt = (i2o_hrt *) c->hrt.virt;
 	u32 bus;
 	int i;
@@ -397,7 +397,7 @@ static int i2o_seq_show_hrt(struct seq_f
 
 static int i2o_seq_show_lct(struct seq_file *seq, void *v)
 {
-	struct i2o_controller *c = (struct i2o_controller *)seq->private;
+	struct i2o_controller *c = seq->private;
 	i2o_lct *lct = (i2o_lct *) c->lct;
 	int entries;
 	int i;
@@ -527,7 +527,7 @@ static int i2o_seq_show_lct(struct seq_f
 
 static int i2o_seq_show_status(struct seq_file *seq, void *v)
 {
-	struct i2o_controller *c = (struct i2o_controller *)seq->private;
+	struct i2o_controller *c = seq->private;
 	char prodstr[25];
 	int version;
 	i2o_status_block *sb = c->status_block.virt;
@@ -724,7 +724,7 @@ static int i2o_seq_show_status(struct se
 
 static int i2o_seq_show_hw(struct seq_file *seq, void *v)
 {
-	struct i2o_controller *c = (struct i2o_controller *)seq->private;
+	struct i2o_controller *c = seq->private;
 	static u32 work32[5];
 	static u8 *work8 = (u8 *) work32;
 	static u16 *work16 = (u16 *) work32;
@@ -781,7 +781,7 @@ static int i2o_seq_show_hw(struct seq_fi
 /* Executive group 0003h - Executing DDM List (table) */
 static int i2o_seq_show_ddm_table(struct seq_file *seq, void *v)
 {
-	struct i2o_controller *c = (struct i2o_controller *)seq->private;
+	struct i2o_controller *c = seq->private;
 	int token;
 	int i;
 
@@ -857,7 +857,7 @@ static int i2o_seq_show_ddm_table(struct
 /* Executive group 0004h - Driver Store (scalar) */
 static int i2o_seq_show_driver_store(struct seq_file *seq, void *v)
 {
-	struct i2o_controller *c = (struct i2o_controller *)seq->private;
+	struct i2o_controller *c = seq->private;
 	u32 work32[8];
 	int token;
 
@@ -893,7 +893,7 @@ static int i2o_seq_show_drivers_stored(s
 		u32 module_flags;
 	} i2o_driver_store_table;
 
-	struct i2o_controller *c = (struct i2o_controller *)seq->private;
+	struct i2o_controller *c = seq->private;
 	int token;
 	int i;
 
@@ -959,7 +959,7 @@ static int i2o_seq_show_drivers_stored(s
 /* Generic group F000h - Params Descriptor (table) */
 static int i2o_seq_show_groups(struct seq_file *seq, void *v)
 {
-	struct i2o_device *d = (struct i2o_device *)seq->private;
+	struct i2o_device *d = seq->private;
 	int token;
 	int i;
 	u8 properties;
@@ -1035,7 +1035,7 @@ static int i2o_seq_show_groups(struct se
 /* Generic group F001h - Physical Device Table (table) */
 static int i2o_seq_show_phys_device(struct seq_file *seq, void *v)
 {
-	struct i2o_device *d = (struct i2o_device *)seq->private;
+	struct i2o_device *d = seq->private;
 	int token;
 	int i;
 
@@ -1076,7 +1076,7 @@ static int i2o_seq_show_phys_device(stru
 /* Generic group F002h - Claimed Table (table) */
 static int i2o_seq_show_claimed(struct seq_file *seq, void *v)
 {
-	struct i2o_device *d = (struct i2o_device *)seq->private;
+	struct i2o_device *d = seq->private;
 	int token;
 	int i;
 
@@ -1116,7 +1116,7 @@ static int i2o_seq_show_claimed(struct s
 /* Generic group F003h - User Table (table) */
 static int i2o_seq_show_users(struct seq_file *seq, void *v)
 {
-	struct i2o_device *d = (struct i2o_device *)seq->private;
+	struct i2o_device *d = seq->private;
 	int token;
 	int i;
 
@@ -1170,7 +1170,7 @@ static int i2o_seq_show_users(struct seq
 /* Generic group F005h - Private message extensions (table) (optional) */
 static int i2o_seq_show_priv_msgs(struct seq_file *seq, void *v)
 {
-	struct i2o_device *d = (struct i2o_device *)seq->private;
+	struct i2o_device *d = seq->private;
 	int token;
 	int i;
 
@@ -1219,7 +1219,7 @@ static int i2o_seq_show_priv_msgs(struct
 /* Generic group F006h - Authorized User Table (table) */
 static int i2o_seq_show_authorized_users(struct seq_file *seq, void *v)
 {
-	struct i2o_device *d = (struct i2o_device *)seq->private;
+	struct i2o_device *d = seq->private;
 	int token;
 	int i;
 
@@ -1260,7 +1260,7 @@ static int i2o_seq_show_authorized_users
 /* Generic group F100h - Device Identity (scalar) */
 static int i2o_seq_show_dev_identity(struct seq_file *seq, void *v)
 {
-	struct i2o_device *d = (struct i2o_device *)seq->private;
+	struct i2o_device *d = seq->private;
 	static u32 work32[128];	// allow for "stuff" + up to 256 byte (max) serial number
 	// == (allow) 512d bytes (max)
 	static u16 *work16 = (u16 *) work32;
@@ -1298,7 +1298,7 @@ static int i2o_seq_show_dev_identity(str
 
 static int i2o_seq_show_dev_name(struct seq_file *seq, void *v)
 {
-	struct i2o_device *d = (struct i2o_device *)seq->private;
+	struct i2o_device *d = seq->private;
 
 	seq_printf(seq, "%s\n", d->device.bus_id);
 
@@ -1308,7 +1308,7 @@ static int i2o_seq_show_dev_name(struct 
 /* Generic group F101h - DDM Identity (scalar) */
 static int i2o_seq_show_ddm_identity(struct seq_file *seq, void *v)
 {
-	struct i2o_device *d = (struct i2o_device *)seq->private;
+	struct i2o_device *d = seq->private;
 	int token;
 
 	struct {
@@ -1345,7 +1345,7 @@ static int i2o_seq_show_ddm_identity(str
 /* Generic group F102h - User Information (scalar) */
 static int i2o_seq_show_uinfo(struct seq_file *seq, void *v)
 {
-	struct i2o_device *d = (struct i2o_device *)seq->private;
+	struct i2o_device *d = seq->private;
 	int token;
 
 	struct {
@@ -1377,7 +1377,7 @@ static int i2o_seq_show_uinfo(struct seq
 /* Generic group F103h - SGL Operating Limits (scalar) */
 static int i2o_seq_show_sgl_limits(struct seq_file *seq, void *v)
 {
-	struct i2o_device *d = (struct i2o_device *)seq->private;
+	struct i2o_device *d = seq->private;
 	static u32 work32[12];
 	static u16 *work16 = (u16 *) work32;
 	static u8 *work8 = (u8 *) work32;
@@ -1424,7 +1424,7 @@ static int i2o_seq_show_sgl_limits(struc
 /* Generic group F200h - Sensors (scalar) */
 static int i2o_seq_show_sensors(struct seq_file *seq, void *v)
 {
-	struct i2o_device *d = (struct i2o_device *)seq->private;
+	struct i2o_device *d = seq->private;
 	int token;
 
 	struct {
--- linux-2.6.git/drivers/pci/pci-sysfs.c
+++ linux-2.6.git/drivers/pci/pci-sysfs.c
@@ -499,7 +499,7 @@ pci_mmap_resource(struct kobject *kobj, 
 {
 	struct pci_dev *pdev = to_pci_dev(container_of(kobj,
 						       struct device, kobj));
-	struct resource *res = (struct resource *)attr->private;
+	struct resource *res = attr->private;
 	enum pci_mmap_state mmap_type;
 	resource_size_t start, end;
 	int i;
--- linux-2.6.git/drivers/pci/hotplug/rpaphp_slot.c
+++ linux-2.6.git/drivers/pci/hotplug/rpaphp_slot.c
@@ -36,7 +36,7 @@
 static ssize_t address_read_file (struct hotplug_slot *php_slot, char *buf)
 {
 	int retval;
-	struct slot *slot = (struct slot *)php_slot->private;
+	struct slot *slot = php_slot->private;
 	struct pci_bus *bus;
 
 	if (!slot)
@@ -63,7 +63,7 @@ static struct hotplug_slot_attribute php
 /* free up the memory used by a slot */
 static void rpaphp_release_slot(struct hotplug_slot *hotplug_slot)
 {
-	struct slot *slot = (struct slot *) hotplug_slot->private;
+	struct slot *slot = hotplug_slot->private;
 	dealloc_slot_struct(slot);
 }
 
--- linux-2.6.git/drivers/pci/hotplug/rpaphp_core.c
+++ linux-2.6.git/drivers/pci/hotplug/rpaphp_core.c
@@ -64,7 +64,7 @@ module_param(debug, bool, 0644);
 static int set_attention_status(struct hotplug_slot *hotplug_slot, u8 value)
 {
 	int rc;
-	struct slot *slot = (struct slot *)hotplug_slot->private;
+	struct slot *slot = hotplug_slot->private;
 
 	switch (value) {
 	case 0:
@@ -91,7 +91,7 @@ static int set_attention_status(struct h
 static int get_power_status(struct hotplug_slot *hotplug_slot, u8 * value)
 {
 	int retval, level;
-	struct slot *slot = (struct slot *)hotplug_slot->private;
+	struct slot *slot = hotplug_slot->private;
 
 	retval = rtas_get_power_level (slot->power_domain, &level);
 	if (!retval)
@@ -106,14 +106,14 @@ static int get_power_status(struct hotpl
  */
 static int get_attention_status(struct hotplug_slot *hotplug_slot, u8 * value)
 {
-	struct slot *slot = (struct slot *)hotplug_slot->private;
+	struct slot *slot = hotplug_slot->private;
 	*value = slot->hotplug_slot->info->attention_status;
 	return 0;
 }
 
 static int get_adapter_status(struct hotplug_slot *hotplug_slot, u8 * value)
 {
-	struct slot *slot = (struct slot *)hotplug_slot->private;
+	struct slot *slot = hotplug_slot->private;
 	int rc, state;
 
 	rc = rpaphp_get_sensor_state(slot, &state);
@@ -132,7 +132,7 @@ static int get_adapter_status(struct hot
 
 static int get_max_bus_speed(struct hotplug_slot *hotplug_slot, enum pci_bus_speed *value)
 {
-	struct slot *slot = (struct slot *)hotplug_slot->private;
+	struct slot *slot = hotplug_slot->private;
 
 	switch (slot->type) {
 	case 1:
@@ -387,7 +387,7 @@ static void __exit rpaphp_exit(void)
 
 static int enable_slot(struct hotplug_slot *hotplug_slot)
 {
-	struct slot *slot = (struct slot *)hotplug_slot->private;
+	struct slot *slot = hotplug_slot->private;
 	int state;
 	int retval;
 
@@ -413,7 +413,7 @@ static int enable_slot(struct hotplug_sl
 
 static int disable_slot(struct hotplug_slot *hotplug_slot)
 {
-	struct slot *slot = (struct slot *)hotplug_slot->private;
+	struct slot *slot = hotplug_slot->private;
 	if (slot->state == NOT_CONFIGURED)
 		return -EINVAL;
 
--- linux-2.6.git/drivers/usb/serial/kl5kusb105.c
+++ linux-2.6.git/drivers/usb/serial/kl5kusb105.c
@@ -866,7 +866,7 @@ static void klsi_105_set_termios (struct
 static void mct_u232_break_ctl( struct usb_serial_port *port, int break_state )
 {
 	struct usb_serial *serial = port->serial;
-	struct mct_u232_private *priv = (struct mct_u232_private *)port->private;
+	struct mct_u232_private *priv = port->private;
 	unsigned char lcr = priv->last_lcr;
 
 	dbg("%sstate=%d", __func__, break_state);
--- linux-2.6.git/drivers/mtd/devices/mtd_dataflash.c
+++ linux-2.6.git/drivers/mtd/devices/mtd_dataflash.c
@@ -145,7 +145,7 @@ static int dataflash_waitready(struct sp
  */
 static int dataflash_erase(struct mtd_info *mtd, struct erase_info *instr)
 {
-	struct dataflash	*priv = (struct dataflash *)mtd->priv;
+	struct dataflash	*priv = mtd->priv;
 	struct spi_device	*spi = priv->spi;
 	struct spi_transfer	x = { .tx_dma = 0, };
 	struct spi_message	msg;
@@ -230,7 +230,7 @@ static int dataflash_erase(struct mtd_in
 static int dataflash_read(struct mtd_info *mtd, loff_t from, size_t len,
 			       size_t *retlen, u_char *buf)
 {
-	struct dataflash	*priv = (struct dataflash *)mtd->priv;
+	struct dataflash	*priv = mtd->priv;
 	struct spi_transfer	x[2] = { { .tx_dma = 0, }, };
 	struct spi_message	msg;
 	unsigned int		addr;
@@ -303,7 +303,7 @@ static int dataflash_read(struct mtd_inf
 static int dataflash_write(struct mtd_info *mtd, loff_t to, size_t len,
 				size_t * retlen, const u_char * buf)
 {
-	struct dataflash	*priv = (struct dataflash *)mtd->priv;
+	struct dataflash	*priv = mtd->priv;
 	struct spi_device	*spi = priv->spi;
 	struct spi_transfer	x[2] = { { .tx_dma = 0, }, };
 	struct spi_message	msg;
--- linux-2.6.git/drivers/mtd/nand/nandsim.c
+++ linux-2.6.git/drivers/mtd/nand/nandsim.c
@@ -466,7 +466,7 @@ static char *get_partition_name(int i)
  */
 static int init_nandsim(struct mtd_info *mtd)
 {
-	struct nand_chip *chip = (struct nand_chip *)mtd->priv;
+	struct nand_chip *chip = mtd->priv;
 	struct nandsim   *ns   = (struct nandsim *)(chip->priv);
 	int i, ret = 0;
 	u_int32_t remains;
@@ -1833,7 +1833,7 @@ static int ns_device_ready(struct mtd_in
 
 static uint16_t ns_nand_read_word(struct mtd_info *mtd)
 {
-	struct nand_chip *chip = (struct nand_chip *)mtd->priv;
+	struct nand_chip *chip = mtd->priv;
 
 	NS_DBG("read_word\n");
 
--- linux-2.6.git/net/atm/lec.c
+++ linux-2.6.git/net/atm/lec.c
@@ -152,7 +152,7 @@ static void lec_handle_bridge(struct sk_
 		buff += 4;
 		mesg->content.normal.flag = *buff & 0x01;	/* 0x01 is topology change */
 
-		priv = (struct lec_priv *)dev->priv;
+		priv = dev->priv;
 		atm_force_charge(priv->lecd, skb2->truesize);
 		sk = sk_atm(priv->lecd);
 		skb_queue_tail(&sk->sk_receive_queue, skb2);
@@ -218,7 +218,7 @@ static unsigned char *get_tr_dst(unsigne
 
 static int lec_open(struct net_device *dev)
 {
-	struct lec_priv *priv = (struct lec_priv *)dev->priv;
+	struct lec_priv *priv = dev->priv;
 
 	netif_start_queue(dev);
 	memset(&priv->stats, 0, sizeof(struct net_device_stats));
@@ -252,7 +252,7 @@ static void lec_tx_timeout(struct net_de
 static int lec_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct sk_buff *skb2;
-	struct lec_priv *priv = (struct lec_priv *)dev->priv;
+	struct lec_priv *priv = dev->priv;
 	struct lecdatahdr_8023 *lec_h;
 	struct atm_vcc *vcc;
 	struct lec_arp_table *entry;
@@ -449,7 +449,7 @@ static int lec_atm_send(struct atm_vcc *
 {
 	unsigned long flags;
 	struct net_device *dev = (struct net_device *)vcc->proto_data;
-	struct lec_priv *priv = (struct lec_priv *)dev->priv;
+	struct lec_priv *priv = dev->priv;
 	struct atmlec_msg *mesg;
 	struct lec_arp_table *entry;
 	int i;
@@ -596,7 +596,7 @@ static void lec_atm_close(struct atm_vcc
 {
 	struct sk_buff *skb;
 	struct net_device *dev = (struct net_device *)vcc->proto_data;
-	struct lec_priv *priv = (struct lec_priv *)dev->priv;
+	struct lec_priv *priv = dev->priv;
 
 	priv->lecd = NULL;
 	/* Do something needful? */
@@ -728,7 +728,7 @@ static void lec_push(struct atm_vcc *vcc
 {
 	unsigned long flags;
 	struct net_device *dev = (struct net_device *)vcc->proto_data;
-	struct lec_priv *priv = (struct lec_priv *)dev->priv;
+	struct lec_priv *priv = dev->priv;
 
 #if DUMP_PACKETS >0
 	int i = 0;
@@ -1280,7 +1280,7 @@ static int lane2_resolve(struct net_devi
 			 u8 **tlvs, u32 *sizeoftlvs)
 {
 	unsigned long flags;
-	struct lec_priv *priv = (struct lec_priv *)dev->priv;
+	struct lec_priv *priv = dev->priv;
 	struct lec_arp_table *table;
 	struct sk_buff *skb;
 	int retval;
@@ -1327,7 +1327,7 @@ static int lane2_associate_req(struct ne
 {
 	int retval;
 	struct sk_buff *skb;
-	struct lec_priv *priv = (struct lec_priv *)dev->priv;
+	struct lec_priv *priv = dev->priv;
 
 	if (compare_ether_addr(lan_dst, dev->dev_addr))
 		return (0);	/* not our mac address */
@@ -1364,7 +1364,7 @@ static void lane2_associate_ind(struct n
 #if 0
 	int i = 0;
 #endif
-	struct lec_priv *priv = (struct lec_priv *)dev->priv;
+	struct lec_priv *priv = dev->priv;
 #if 0				/*
 				 * Why have the TLVs in LE_ARP entries
 				 * since we do not use them? When you
@@ -1811,7 +1811,7 @@ static void lec_arp_expire_vcc(unsigned 
 {
 	unsigned long flags;
 	struct lec_arp_table *to_remove = (struct lec_arp_table *)data;
-	struct lec_priv *priv = (struct lec_priv *)to_remove->priv;
+	struct lec_priv *priv = to_remove->priv;
 
 	del_timer(&to_remove->timer);
 
--- linux-2.6.git/net/atm/mpc.c
+++ linux-2.6.git/net/atm/mpc.c
@@ -972,7 +972,7 @@ static int mpoa_event_listener(struct no
 
 	switch (event) {
 	case NETDEV_REGISTER:       /* a new lec device was allocated */
-		priv = (struct lec_priv *)dev->priv;
+		priv = dev->priv;
 		if (priv->lane_version < 2)
 			break;
 		priv->lane2_ops->associate_indicator = lane2_assoc_ind;
--- linux-2.6.git/net/ipv6/proc.c
+++ linux-2.6.git/net/ipv6/proc.c
@@ -166,7 +166,7 @@ snmp6_seq_show_item(struct seq_file *seq
 
 static int snmp6_seq_show(struct seq_file *seq, void *v)
 {
-	struct inet6_dev *idev = (struct inet6_dev *)seq->private;
+	struct inet6_dev *idev = seq->private;
 
 	if (idev) {
 		seq_printf(seq, "%-32s\t%u\n", "ifIndex", idev->dev->ifindex);
--- linux-2.6.git/net/ipv6/route.c
+++ linux-2.6.git/net/ipv6/route.c
@@ -2401,7 +2401,7 @@ static int rt6_info_route(struct rt6_inf
 
 static int ipv6_route_show(struct seq_file *m, void *v)
 {
-	struct net *net = (struct net *)m->private;
+	struct net *net = m->private;
 	fib6_clean_all(net, rt6_info_route, 0, m);
 	return 0;
 }
@@ -2440,7 +2440,7 @@ static const struct file_operations ipv6
 
 static int rt6_stats_seq_show(struct seq_file *seq, void *v)
 {
-	struct net *net = (struct net *)seq->private;
+	struct net *net = seq->private;
 	seq_printf(seq, "%04x %04x %04x %04x %04x %04x %04x\n",
 		   net->ipv6.rt6_stats->fib_nodes,
 		   net->ipv6.rt6_stats->fib_route_nodes,
@@ -2472,7 +2472,7 @@ static int rt6_stats_seq_open(struct ino
 static int rt6_stats_seq_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *seq = file->private_data;
-	struct net *net = (struct net *)seq->private;
+	struct net *net = seq->private;
 	put_net(net);
 	return single_release(inode, file);
 }
--- linux-2.6.git/net/8021q/vlanproc.c
+++ linux-2.6.git/net/8021q/vlanproc.c
@@ -284,7 +284,7 @@ static int vlan_seq_show(struct seq_file
 
 static int vlandev_seq_show(struct seq_file *seq, void *offset)
 {
-	struct net_device *vlandev = (struct net_device *) seq->private;
+	struct net_device *vlandev = seq->private;
 	const struct vlan_dev_info *dev_info = vlan_dev_info(vlandev);
 	struct net_device_stats *stats = &vlandev->stats;
 	static const char fmt[] = "%30s %12lu\n";
--- linux-2.6.git/net/irda/irnet/irnet_ppp.c
+++ linux-2.6.git/net/irda/irnet/irnet_ppp.c
@@ -882,7 +882,7 @@ static int
 ppp_irnet_send(struct ppp_channel *	chan,
 	       struct sk_buff *		skb)
 {
-  irnet_socket *	self = (struct irnet_socket *) chan->private;
+  irnet_socket *	self = chan->private;
   int			ret;
 
   DENTER(PPP_TRACE, "(channel=0x%p, ap/self=0x%p)\n",
@@ -984,7 +984,7 @@ ppp_irnet_ioctl(struct ppp_channel *	cha
 		unsigned int		cmd,
 		unsigned long		arg)
 {
-  irnet_socket *	ap = (struct irnet_socket *) chan->private;
+  irnet_socket *	ap = chan->private;
   int			err;
   int			val;
   u32			accm[8];
--- linux-2.6.git/net/9p/trans_fd.c
+++ linux-2.6.git/net/9p/trans_fd.c
@@ -1501,7 +1501,7 @@ p9_trans_create_tcp(const char *addr, ch
 	if (err < 0)
 		goto error;
 
-	p = (struct p9_trans_fd *) trans->priv;
+	p = trans->priv;
 	p->conn = p9_conn_create(trans);
 	if (IS_ERR(p->conn)) {
 		err = PTR_ERR(p->conn);
@@ -1562,7 +1562,7 @@ p9_trans_create_unix(const char *addr, c
 
 	trans->msize = msize;
 	trans->extended = dotu;
-	p = (struct p9_trans_fd *) trans->priv;
+	p = trans->priv;
 	p->conn = p9_conn_create(trans);
 	if (IS_ERR(p->conn)) {
 		err = PTR_ERR(p->conn);
@@ -1609,7 +1609,7 @@ p9_trans_create_fd(const char *name, cha
 
 	trans->msize = msize;
 	trans->extended = extended;
-	p = (struct p9_trans_fd *) trans->priv;
+	p = trans->priv;
 	p->conn = p9_conn_create(trans);
 	if (IS_ERR(p->conn)) {
 		err = PTR_ERR(p->conn);
--- linux-2.6.git/net/ipv4/fib_trie.c
+++ linux-2.6.git/net/ipv4/fib_trie.c
@@ -2223,7 +2223,7 @@ static void fib_table_print(struct seq_f
 
 static int fib_triestat_seq_show(struct seq_file *seq, void *v)
 {
-	struct net *net = (struct net *)seq->private;
+	struct net *net = seq->private;
 	unsigned int h;
 
 	seq_printf(seq,
--- linux-2.6.git/net/netfilter/x_tables.c
+++ linux-2.6.git/net/netfilter/x_tables.c
@@ -792,7 +792,7 @@ static const struct file_operations xt_t
 
 static void *xt_match_seq_start(struct seq_file *seq, loff_t *pos)
 {
-	struct proc_dir_entry *pde = (struct proc_dir_entry *)seq->private;
+	struct proc_dir_entry *pde = seq->private;
 	u_int16_t af = (unsigned long)pde->data;
 
 	mutex_lock(&xt[af].mutex);
@@ -801,7 +801,7 @@ static void *xt_match_seq_start(struct s
 
 static void *xt_match_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	struct proc_dir_entry *pde = (struct proc_dir_entry *)seq->private;
+	struct proc_dir_entry *pde = seq->private;
 	u_int16_t af = (unsigned long)pde->data;
 
 	return seq_list_next(v, &xt[af].match, pos);
@@ -855,7 +855,7 @@ static const struct file_operations xt_m
 
 static void *xt_target_seq_start(struct seq_file *seq, loff_t *pos)
 {
-	struct proc_dir_entry *pde = (struct proc_dir_entry *)seq->private;
+	struct proc_dir_entry *pde = seq->private;
 	u_int16_t af = (unsigned long)pde->data;
 
 	mutex_lock(&xt[af].mutex);
@@ -864,7 +864,7 @@ static void *xt_target_seq_start(struct 
 
 static void *xt_target_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	struct proc_dir_entry *pde = (struct proc_dir_entry *)seq->private;
+	struct proc_dir_entry *pde = seq->private;
 	u_int16_t af = (unsigned long)pde->data;
 
 	return seq_list_next(v, &xt[af].target, pos);
--- linux-2.6.git/net/sunrpc/rpc_pipe.c
+++ linux-2.6.git/net/sunrpc/rpc_pipe.c
@@ -370,7 +370,7 @@ static int
 rpc_info_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *m = file->private_data;
-	struct rpc_clnt *clnt = (struct rpc_clnt *)m->private;
+	struct rpc_clnt *clnt = m->private;
 
 	if (clnt)
 		rpc_release_client(clnt);
--- linux-2.6.git/fs/nfs/idmap.c
+++ linux-2.6.git/fs/nfs/idmap.c
@@ -377,7 +377,7 @@ static ssize_t
 idmap_pipe_downcall(struct file *filp, const char __user *src, size_t mlen)
 {
 	struct rpc_inode *rpci = RPC_I(filp->f_path.dentry->d_inode);
-	struct idmap *idmap = (struct idmap *)rpci->private;
+	struct idmap *idmap = rpci->private;
 	struct idmap_msg im_in, *im = &idmap->idmap_im;
 	struct idmap_hashtable *h;
 	struct idmap_hashent *he = NULL;
--- linux-2.6.git/fs/ocfs2/dlm/dlmdebug.c
+++ linux-2.6.git/fs/ocfs2/dlm/dlmdebug.c
@@ -738,7 +738,7 @@ bail:
 static int debug_lockres_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *seq = (struct seq_file *)file->private_data;
-	struct debug_lockres *dl = (struct debug_lockres *)seq->private;
+	struct debug_lockres *dl = seq->private;
 
 	if (dl->dl_res)
 		dlm_lockres_put(dl->dl_res);
--- linux-2.6.git/virt/kvm/ioapic.c
+++ linux-2.6.git/virt/kvm/ioapic.c
@@ -301,7 +301,7 @@ void kvm_ioapic_update_eoi(struct kvm *k
 
 static int ioapic_in_range(struct kvm_io_device *this, gpa_t addr)
 {
-	struct kvm_ioapic *ioapic = (struct kvm_ioapic *)this->private;
+	struct kvm_ioapic *ioapic = this->private;
 
 	return ((addr >= ioapic->base_address &&
 		 (addr < ioapic->base_address + IOAPIC_MEM_LENGTH)));
@@ -310,7 +310,7 @@ static int ioapic_in_range(struct kvm_io
 static void ioapic_mmio_read(struct kvm_io_device *this, gpa_t addr, int len,
 			     void *val)
 {
-	struct kvm_ioapic *ioapic = (struct kvm_ioapic *)this->private;
+	struct kvm_ioapic *ioapic = this->private;
 	u32 result;
 
 	ioapic_debug("addr %lx\n", (unsigned long)addr);
@@ -347,7 +347,7 @@ static void ioapic_mmio_read(struct kvm_
 static void ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, int len,
 			      const void *val)
 {
-	struct kvm_ioapic *ioapic = (struct kvm_ioapic *)this->private;
+	struct kvm_ioapic *ioapic = this->private;
 	u32 data;
 
 	ioapic_debug("ioapic_mmio_write addr=%p len=%d val=%p\n",
--- linux-2.6.git/arch/powerpc/platforms/pseries/hvCall_inst.c
+++ linux-2.6.git/arch/powerpc/platforms/pseries/hvCall_inst.c
@@ -54,7 +54,7 @@ static void hc_stop(struct seq_file *m, 
 static int hc_show(struct seq_file *m, void *p)
 {
 	unsigned long h_num = (unsigned long)p;
-	struct hcall_stats *hs = (struct hcall_stats *)m->private;
+	struct hcall_stats *hs = m->private;
 
 	if (hs[h_num].num_calls) {
 		if (cpu_has_feature(CPU_FTR_PURR))
--- linux-2.6.git/arch/x86/kvm/i8254.c
+++ linux-2.6.git/arch/x86/kvm/i8254.c
@@ -310,7 +310,7 @@ void kvm_pit_load_count(struct kvm *kvm,
 static void pit_ioport_write(struct kvm_io_device *this,
 			     gpa_t addr, int len, const void *data)
 {
-	struct kvm_pit *pit = (struct kvm_pit *)this->private;
+	struct kvm_pit *pit = this->private;
 	struct kvm_kpit_state *pit_state = &pit->pit_state;
 	struct kvm *kvm = pit->kvm;
 	int channel, access;
@@ -383,7 +383,7 @@ static void pit_ioport_write(struct kvm_
 static void pit_ioport_read(struct kvm_io_device *this,
 			    gpa_t addr, int len, void *data)
 {
-	struct kvm_pit *pit = (struct kvm_pit *)this->private;
+	struct kvm_pit *pit = this->private;
 	struct kvm_kpit_state *pit_state = &pit->pit_state;
 	struct kvm *kvm = pit->kvm;
 	int ret, count;
@@ -453,7 +453,7 @@ static int pit_in_range(struct kvm_io_de
 static void speaker_ioport_write(struct kvm_io_device *this,
 				 gpa_t addr, int len, const void *data)
 {
-	struct kvm_pit *pit = (struct kvm_pit *)this->private;
+	struct kvm_pit *pit = this->private;
 	struct kvm_kpit_state *pit_state = &pit->pit_state;
 	struct kvm *kvm = pit->kvm;
 	u32 val = *(u32 *) data;
@@ -467,7 +467,7 @@ static void speaker_ioport_write(struct 
 static void speaker_ioport_read(struct kvm_io_device *this,
 				gpa_t addr, int len, void *data)
 {
-	struct kvm_pit *pit = (struct kvm_pit *)this->private;
+	struct kvm_pit *pit = this->private;
 	struct kvm_kpit_state *pit_state = &pit->pit_state;
 	struct kvm *kvm = pit->kvm;
 	unsigned int refresh_clock;
--- linux-2.6.git/arch/x86/kvm/lapic.c
+++ linux-2.6.git/arch/x86/kvm/lapic.c
@@ -600,7 +600,7 @@ static u32 __apic_read(struct kvm_lapic 
 static void apic_mmio_read(struct kvm_io_device *this,
 			   gpa_t address, int len, void *data)
 {
-	struct kvm_lapic *apic = (struct kvm_lapic *)this->private;
+	struct kvm_lapic *apic = this->private;
 	unsigned int offset = address - apic->base_address;
 	unsigned char alignment = offset & 0xf;
 	u32 result;
@@ -669,7 +669,7 @@ static void start_apic_timer(struct kvm_
 static void apic_mmio_write(struct kvm_io_device *this,
 			    gpa_t address, int len, const void *data)
 {
-	struct kvm_lapic *apic = (struct kvm_lapic *)this->private;
+	struct kvm_lapic *apic = this->private;
 	unsigned int offset = address - apic->base_address;
 	unsigned char alignment = offset & 0xf;
 	u32 val;
@@ -782,7 +782,7 @@ static void apic_mmio_write(struct kvm_i
 
 static int apic_mmio_range(struct kvm_io_device *this, gpa_t addr)
 {
-	struct kvm_lapic *apic = (struct kvm_lapic *)this->private;
+	struct kvm_lapic *apic = this->private;
 	int ret = 0;
 
 
--- linux-2.6.git/arch/arm/mach-omap2/mailbox.c
+++ linux-2.6.git/arch/arm/mach-omap2/mailbox.c
@@ -144,7 +144,7 @@ static int omap2_mbox_fifo_full(struct o
 static void omap2_mbox_enable_irq(struct omap_mbox *mbox,
 		omap_mbox_type_t irq)
 {
-	struct omap_mbox2_priv *p = (struct omap_mbox2_priv *)mbox->priv;
+	struct omap_mbox2_priv *p = mbox->priv;
 	u32 l, bit = (irq == IRQ_TX) ? p->notfull_bit : p->newmsg_bit;
 
 	l = mbox_read_reg(p->irqenable);
@@ -155,7 +155,7 @@ static void omap2_mbox_enable_irq(struct
 static void omap2_mbox_disable_irq(struct omap_mbox *mbox,
 		omap_mbox_type_t irq)
 {
-	struct omap_mbox2_priv *p = (struct omap_mbox2_priv *)mbox->priv;
+	struct omap_mbox2_priv *p = mbox->priv;
 	u32 l, bit = (irq == IRQ_TX) ? p->notfull_bit : p->newmsg_bit;
 
 	l = mbox_read_reg(p->irqenable);
@@ -166,7 +166,7 @@ static void omap2_mbox_disable_irq(struc
 static void omap2_mbox_ack_irq(struct omap_mbox *mbox,
 		omap_mbox_type_t irq)
 {
-	struct omap_mbox2_priv *p = (struct omap_mbox2_priv *)mbox->priv;
+	struct omap_mbox2_priv *p = mbox->priv;
 	u32 bit = (irq == IRQ_TX) ? p->notfull_bit : p->newmsg_bit;
 
 	mbox_write_reg(bit, p->irqstatus);
@@ -175,7 +175,7 @@ static void omap2_mbox_ack_irq(struct om
 static int omap2_mbox_is_irq(struct omap_mbox *mbox,
 		omap_mbox_type_t irq)
 {
-	struct omap_mbox2_priv *p = (struct omap_mbox2_priv *)mbox->priv;
+	struct omap_mbox2_priv *p = mbox->priv;
 	u32 bit = (irq == IRQ_TX) ? p->notfull_bit : p->newmsg_bit;
 	u32 enable = mbox_read_reg(p->irqenable);
 	u32 status = mbox_read_reg(p->irqstatus);
--- linux-2.6.git/arch/ppc/8260_io/fcc_enet.c
+++ linux-2.6.git/arch/ppc/8260_io/fcc_enet.c
@@ -412,7 +412,7 @@ static void	mii_do_cmd(struct net_device
 static int
 fcc_enet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	struct fcc_enet_private *cep = (struct fcc_enet_private *)dev->priv;
+	struct fcc_enet_private *cep = dev->priv;
 	volatile cbd_t	*bdp;
 
 	/* Fill in a Tx ring entry */
@@ -480,7 +480,7 @@ fcc_enet_start_xmit(struct sk_buff *skb,
 static void
 fcc_enet_timeout(struct net_device *dev)
 {
-	struct fcc_enet_private *cep = (struct fcc_enet_private *)dev->priv;
+	struct fcc_enet_private *cep = dev->priv;
 
 	printk("%s: transmit timed out.\n", dev->name);
 	cep->stats.tx_errors++;
@@ -768,7 +768,7 @@ fcc_enet_close(struct net_device *dev)
 
 static struct net_device_stats *fcc_enet_get_stats(struct net_device *dev)
 {
-	struct fcc_enet_private *cep = (struct fcc_enet_private *)dev->priv;
+	struct fcc_enet_private *cep = dev->priv;
 
 	return &cep->stats;
 }
@@ -1595,7 +1595,7 @@ set_multicast_list(struct net_device *de
 	volatile fcc_enet_t *ep;
 	int	i, j;
 
-	cep = (struct fcc_enet_private *)dev->priv;
+	cep = dev->priv;
 
 return;
 	/* Get pointer to FCC area in parameter RAM.
--- linux-2.6.git/arch/ppc/8260_io/enet.c
+++ linux-2.6.git/arch/ppc/8260_io/enet.c
@@ -166,7 +166,7 @@ scc_enet_open(struct net_device *dev)
 static int
 scc_enet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	struct scc_enet_private *cep = (struct scc_enet_private *)dev->priv;
+	struct scc_enet_private *cep = dev->priv;
 	volatile cbd_t	*bdp;
 
 
@@ -237,7 +237,7 @@ scc_enet_start_xmit(struct sk_buff *skb,
 static void
 scc_enet_timeout(struct net_device *dev)
 {
-	struct scc_enet_private *cep = (struct scc_enet_private *)dev->priv;
+	struct scc_enet_private *cep = dev->priv;
 
 	printk("%s: transmit timed out.\n", dev->name);
 	cep->stats.tx_errors++;
@@ -518,7 +518,7 @@ scc_enet_close(struct net_device *dev)
 
 static struct net_device_stats *scc_enet_get_stats(struct net_device *dev)
 {
-	struct scc_enet_private *cep = (struct scc_enet_private *)dev->priv;
+	struct scc_enet_private *cep = dev->priv;
 
 	return &cep->stats;
 }
@@ -540,7 +540,7 @@ static void set_multicast_list(struct ne
 	u_char	*mcptr, *tdptr;
 	volatile scc_enet_t *ep;
 	int	i, j;
-	cep = (struct scc_enet_private *)dev->priv;
+	cep = dev->priv;
 
 	/* Get pointer to SCC area in parameter RAM.
 	*/
--- linux-2.6.git/arch/ppc/8xx_io/fec.c
+++ linux-2.6.git/arch/ppc/8xx_io/fec.c
@@ -782,7 +782,7 @@ fec_enet_mii(struct net_device *dev)
 	mii_list_t	*mip;
 	uint		mii_reg;
 
-	fep = (struct fec_enet_private *)dev->priv;
+	fep = dev->priv;
 	ep = &(((immap_t *)IMAP_ADDR)->im_cpm.cp_fec);
 	mii_reg = ep->fec_mii_data;
 
@@ -1494,7 +1494,7 @@ fec_enet_close(struct net_device *dev)
 
 static struct net_device_stats *fec_enet_get_stats(struct net_device *dev)
 {
-	struct fec_enet_private *fep = (struct fec_enet_private *)dev->priv;
+	struct fec_enet_private *fep = dev->priv;
 
 	return &fep->stats;
 }
@@ -1514,7 +1514,7 @@ static void set_multicast_list(struct ne
 	struct	fec_enet_private *fep;
 	volatile fec_t *ep;
 
-	fep = (struct fec_enet_private *)dev->priv;
+	fep = dev->priv;
 	ep = &(((immap_t *)IMAP_ADDR)->im_cpm.cp_fec);
 
 	if (dev->flags&IFF_PROMISC) {
--- linux-2.6.git/arch/ppc/8xx_io/enet.c
+++ linux-2.6.git/arch/ppc/8xx_io/enet.c
@@ -196,7 +196,7 @@ scc_enet_open(struct net_device *dev)
 static int
 scc_enet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	struct scc_enet_private *cep = (struct scc_enet_private *)dev->priv;
+	struct scc_enet_private *cep = dev->priv;
 	volatile cbd_t	*bdp;
 
 	/* Fill in a Tx ring entry */
@@ -272,7 +272,7 @@ scc_enet_start_xmit(struct sk_buff *skb,
 static void
 scc_enet_timeout(struct net_device *dev)
 {
-	struct scc_enet_private *cep = (struct scc_enet_private *)dev->priv;
+	struct scc_enet_private *cep = dev->priv;
 
 	printk("%s: transmit timed out.\n", dev->name);
 	cep->stats.tx_errors++;
@@ -313,7 +313,7 @@ scc_enet_interrupt(void *dev_id)
 	ushort	int_events;
 	int	must_restart;
 
-	cep = (struct scc_enet_private *)dev->priv;
+	cep = dev->priv;
 
 	/* Get the interrupt events that caused us to be here.
 	*/
@@ -448,7 +448,7 @@ scc_enet_rx(struct net_device *dev)
 	struct	sk_buff *skb;
 	ushort	pkt_len;
 
-	cep = (struct scc_enet_private *)dev->priv;
+	cep = dev->priv;
 
 	/* First, grab all of the stats for the incoming packet.
 	 * These get messed up if we get called due to a busy condition.
@@ -548,7 +548,7 @@ scc_enet_close(struct net_device *dev)
 
 static struct net_device_stats *scc_enet_get_stats(struct net_device *dev)
 {
-	struct scc_enet_private *cep = (struct scc_enet_private *)dev->priv;
+	struct scc_enet_private *cep = dev->priv;
 
 	return &cep->stats;
 }
@@ -570,7 +570,7 @@ static void set_multicast_list(struct ne
 	u_char	*mcptr, *tdptr;
 	volatile scc_enet_t *ep;
 	int	i, j;
-	cep = (struct scc_enet_private *)dev->priv;
+	cep = dev->priv;
 
 	/* Get pointer to SCC area in parameter RAM.
 	*/

--Boundary-00=_CkuPIlo2oI1LROu--
