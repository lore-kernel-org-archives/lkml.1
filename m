Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbYH0Kgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbYH0Kgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 06:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbYH0KgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 06:36:23 -0400
Received: from havoc.gtf.org ([69.61.125.42]:56990 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbYH0KgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 06:36:19 -0400
Date: Wed, 27 Aug 2008 06:36:17 -0400
From: Jeff Garzik <jeff@garzik.org>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] net driver fixes
Message-ID: <20080827103617.GA27022@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Various fixes, except myri version bump and net/usb/mcs7830 (gets
networking for some users, with minimal code -- set_mac_addr)

Please pull from 'davem-fixes' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git davem-fixes

to receive the following updates:

 arch/powerpc/include/asm/cpm2.h    |    5 ++
 drivers/net/Kconfig                |    6 +-
 drivers/net/atl1e/atl1e_main.c     |    3 +-
 drivers/net/atlx/atl1.c            |    1 -
 drivers/net/e100.c                 |    4 +-
 drivers/net/forcedeth.c            |    4 +-
 drivers/net/fs_enet/fs_enet-main.c |    8 ++++
 drivers/net/fs_enet/mac-scc.c      |    8 +++-
 drivers/net/gianfar.c              |   22 ++++++++--
 drivers/net/gianfar.h              |    1 +
 drivers/net/ibm_newemac/core.c     |    6 +-
 drivers/net/ibmveth.c              |    5 +-
 drivers/net/igb/e1000_82575.c      |    1 -
 drivers/net/igb/e1000_hw.h         |    1 -
 drivers/net/igb/igb_ethtool.c      |   17 +++-----
 drivers/net/igb/igb_main.c         |   25 +++++------
 drivers/net/ixgbe/ixgbe_main.c     |    8 ++-
 drivers/net/mv643xx_eth.c          |   35 +++++++++-------
 drivers/net/myri10ge/myri10ge.c    |    2 +-
 drivers/net/r8169.c                |    2 +-
 drivers/net/skfp/ess.c             |    6 +-
 drivers/net/smc91x.c               |    2 +-
 drivers/net/usb/hso.c              |    3 +-
 drivers/net/usb/mcs7830.c          |   47 +++++++++++++++++++++-
 drivers/net/wd.c                   |    2 +-
 drivers/s390/net/claw.c            |   79 +++++++++++++++++------------------
 drivers/s390/net/ctcm_fsms.c       |   56 +++++++++++++-------------
 drivers/s390/net/ctcm_main.c       |   24 +++++-----
 drivers/s390/net/ctcm_main.h       |    9 ++--
 drivers/s390/net/ctcm_mpc.c        |   46 ++++++++++----------
 drivers/s390/net/lcs.c             |    3 +-
 drivers/s390/net/qeth_core.h       |    1 +
 drivers/s390/net/qeth_core_main.c  |    2 +-
 drivers/s390/net/qeth_l2_main.c    |   27 ++++++++++--
 drivers/s390/net/qeth_l3_sys.c     |    2 +-
 35 files changed, 284 insertions(+), 189 deletions(-)

Alan Cox (1):
      [netdrvr] fix build issue: undefined reference to `NS8390p_init'

Alexander Duyck (5):
      ixgbe: fix vlan filtering
      igb: force all queues to interrupt once every 2 seconds
      igb: ethtool -d reads EICR which is incorrect as it is read on clear
      igb: fix setting the number of tx queues
      igb: remove 82576 quad adapter

Arnd Bergmann (1):
      net/usb/mcs7830: new device IDs

Ayaz Abdulla (1):
      forcedeth: fix checksum flag

Benjamin Herrenschmidt (1):
      ibm_newemac: Don't call dev_mc_add() before device is registered

Brice Goglin (1):
      myri10ge: update version string to 1.4.3-1.358

Denis Joseph Barrow (2):
      [netdrvr] hso: icon 322 detection fix
      [netdrvr] hso: dev_kfree_skb crash fix

Francois Romieu (1):
      r8169: balance pci_map / pci_unmap pair

Frank Blaschka (2):
      qeth: l2 write unicast list to hardware
      qeth: preallocated header account offset

Heiko Schocher (1):
      fs_enet: Fix SCC Ethernet on CPM2, and crash in fs_enet_rx_napi()

Ilpo Järvinen (1):
      atl1e: multistatement if missing braces

Jay Cliburn (1):
      atl1: disable TSO by default

Jeff Garzik (1):
      [netdrvr] smc91x: fix resource removal (null ptr deref)

Jiri Slaby (1):
      e100, fix iomap read

Klaus-D. Wacker (1):
      LCS recovery dumps when cable reconnect

Lennert Buytenhek (6):
      mv643xx_eth: fix NAPI 'rotting packet' issue
      mv643xx_eth: fix double add_timer() on the receive oom timer
      mv643xx_eth: fix inconsistent lock semantics
      mv643xx_eth: fix NULL pointer dereference in rxq_process()
      mv643xx_eth: enforce multiple-of-8-bytes receive buffer size restriction
      mv643xx_eth: bump version to 1.3

Martin Schwidefsky (1):
      claw: fix memory leak in claw_probe.

Mike Frysinger (1):
      Blackfin EMAC Driver: the BF526 also supports the MAC,

Oliver Martin (1):
      net/usb/mcs7830: add set_mac_address

Peter Tiedemann (2):
      claw: netdev->priv vs. netdev->ml_priv
      ctcm: netdev->priv vs. netdev->ml_priv

Santiago Leon (1):
      ibmveth: fix bad UDP checksums

Sebastian Siewior (1):
      net: don't grab a mutex within a timer context in gianfar

Takashi Iwai (1):
      drivers/net/skfp/ess.c: fix compile warnings

Ursula Braun (1):
      qeth: use -EOPNOTSUPP instead of -ENOTSUPP.

diff --git a/arch/powerpc/include/asm/cpm2.h b/arch/powerpc/include/asm/cpm2.h
index 2a6fa01..0f5e8ff 100644
--- a/arch/powerpc/include/asm/cpm2.h
+++ b/arch/powerpc/include/asm/cpm2.h
@@ -337,6 +337,11 @@ typedef struct scc_param {
 	uint	scc_tcrc;	/* Internal */
 } sccp_t;
 
+/* Function code bits.
+*/
+#define SCC_EB	((u_char) 0x10)	/* Set big endian byte order */
+#define SCC_GBL	((u_char) 0x20) /* Snooping enabled */
+
 /* CPM Ethernet through SCC1.
  */
 typedef struct scc_enet {
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index a5c141c..4a11296 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -822,14 +822,14 @@ config ULTRA32
 	  will be called smc-ultra32.
 
 config BFIN_MAC
-	tristate "Blackfin 527/536/537 on-chip mac support"
-	depends on NET_ETHERNET && (BF527 || BF537 || BF536)
+	tristate "Blackfin on-chip MAC support"
+	depends on NET_ETHERNET && (BF526 || BF527 || BF536 || BF537)
 	select CRC32
 	select MII
 	select PHYLIB
 	select BFIN_MAC_USE_L1 if DMA_UNCACHED_NONE
 	help
-	  This is the driver for blackfin on-chip mac device. Say Y if you want it
+	  This is the driver for Blackfin on-chip mac device. Say Y if you want it
 	  compiled into the kernel. This driver is also available as a module
 	  ( = code which can be inserted in and removed from the running kernel
 	  whenever you want). The module will be called bfin_mac.
diff --git a/drivers/net/atl1e/atl1e_main.c b/drivers/net/atl1e/atl1e_main.c
index 82d7be1..7685b99 100644
--- a/drivers/net/atl1e/atl1e_main.c
+++ b/drivers/net/atl1e/atl1e_main.c
@@ -2232,10 +2232,11 @@ static int atl1e_resume(struct pci_dev *pdev)
 
 	AT_WRITE_REG(&adapter->hw, REG_WOL_CTRL, 0);
 
-	if (netif_running(netdev))
+	if (netif_running(netdev)) {
 		err = atl1e_request_irq(adapter);
 		if (err)
 			return err;
+	}
 
 	atl1e_reset_hw(&adapter->hw);
 
diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index e6a7bb7..e23ce77 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -3022,7 +3022,6 @@ static int __devinit atl1_probe(struct pci_dev *pdev,
 	netdev->features = NETIF_F_HW_CSUM;
 	netdev->features |= NETIF_F_SG;
 	netdev->features |= (NETIF_F_HW_VLAN_TX | NETIF_F_HW_VLAN_RX);
-	netdev->features |= NETIF_F_TSO;
 	netdev->features |= NETIF_F_LLTX;
 
 	/*
diff --git a/drivers/net/e100.c b/drivers/net/e100.c
index 19d32a2..453115a 100644
--- a/drivers/net/e100.c
+++ b/drivers/net/e100.c
@@ -1838,7 +1838,7 @@ static int e100_rx_indicate(struct nic *nic, struct rx *rx,
 		if ((le16_to_cpu(rfd->command) & cb_el) &&
 		    (RU_RUNNING == nic->ru_running))
 
-			if (readb(&nic->csr->scb.status) & rus_no_res)
+			if (ioread8(&nic->csr->scb.status) & rus_no_res)
 				nic->ru_running = RU_SUSPENDED;
 		return -ENODATA;
 	}
@@ -1861,7 +1861,7 @@ static int e100_rx_indicate(struct nic *nic, struct rx *rx,
 	if ((le16_to_cpu(rfd->command) & cb_el) &&
 	    (RU_RUNNING == nic->ru_running)) {
 
-	    if (readb(&nic->csr->scb.status) & rus_no_res)
+	    if (ioread8(&nic->csr->scb.status) & rus_no_res)
 		nic->ru_running = RU_SUSPENDED;
 	}
 
diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
index 053971e..331b86b 100644
--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -5522,7 +5522,7 @@ static int __devinit nv_probe(struct pci_dev *pci_dev, const struct pci_device_i
 	if (id->driver_data & DEV_HAS_CHECKSUM) {
 		np->rx_csum = 1;
 		np->txrxctl_bits |= NVREG_TXRXCTL_RXCHECK;
-		dev->features |= NETIF_F_HW_CSUM | NETIF_F_SG;
+		dev->features |= NETIF_F_IP_CSUM | NETIF_F_SG;
 		dev->features |= NETIF_F_TSO;
 	}
 
@@ -5835,7 +5835,7 @@ static int __devinit nv_probe(struct pci_dev *pci_dev, const struct pci_device_i
 
 	dev_printk(KERN_INFO, &pci_dev->dev, "%s%s%s%s%s%s%s%s%s%sdesc-v%u\n",
 		   dev->features & NETIF_F_HIGHDMA ? "highdma " : "",
-		   dev->features & (NETIF_F_HW_CSUM | NETIF_F_SG) ?
+		   dev->features & (NETIF_F_IP_CSUM | NETIF_F_SG) ?
 		   	"csum " : "",
 		   dev->features & (NETIF_F_HW_VLAN_RX | NETIF_F_HW_VLAN_TX) ?
 		   	"vlan " : "",
diff --git a/drivers/net/fs_enet/fs_enet-main.c b/drivers/net/fs_enet/fs_enet-main.c
index 9a51ec8..9d46182 100644
--- a/drivers/net/fs_enet/fs_enet-main.c
+++ b/drivers/net/fs_enet/fs_enet-main.c
@@ -792,6 +792,10 @@ static int fs_enet_open(struct net_device *dev)
 	int r;
 	int err;
 
+	/* to initialize the fep->cur_rx,... */
+	/* not doing this, will cause a crash in fs_enet_rx_napi */
+	fs_init_bds(fep->ndev);
+
 	if (fep->fpi->use_napi)
 		napi_enable(&fep->napi);
 
@@ -1167,6 +1171,10 @@ static struct of_device_id fs_enet_match[] = {
 		.compatible = "fsl,cpm1-scc-enet",
 		.data = (void *)&fs_scc_ops,
 	},
+	{
+		.compatible = "fsl,cpm2-scc-enet",
+		.data = (void *)&fs_scc_ops,
+	},
 #endif
 #ifdef CONFIG_FS_ENET_HAS_FCC
 	{
diff --git a/drivers/net/fs_enet/mac-scc.c b/drivers/net/fs_enet/mac-scc.c
index 029b3c7..22f50dd 100644
--- a/drivers/net/fs_enet/mac-scc.c
+++ b/drivers/net/fs_enet/mac-scc.c
@@ -47,7 +47,6 @@
 #include "fs_enet.h"
 
 /*************************************************/
-
 #if defined(CONFIG_CPM1)
 /* for a 8xx __raw_xxx's are sufficient */
 #define __fs_out32(addr, x)	__raw_writel(x, addr)
@@ -62,6 +61,8 @@
 #define __fs_out16(addr, x)	out_be16(addr, x)
 #define __fs_in32(addr)	in_be32(addr)
 #define __fs_in16(addr)	in_be16(addr)
+#define __fs_out8(addr, x)	out_8(addr, x)
+#define __fs_in8(addr)	in_8(addr)
 #endif
 
 /* write, read, set bits, clear bits */
@@ -262,8 +263,13 @@ static void restart(struct net_device *dev)
 
 	/* Initialize function code registers for big-endian.
 	 */
+#ifndef CONFIG_NOT_COHERENT_CACHE
+	W8(ep, sen_genscc.scc_rfcr, SCC_EB | SCC_GBL);
+	W8(ep, sen_genscc.scc_tfcr, SCC_EB | SCC_GBL);
+#else
 	W8(ep, sen_genscc.scc_rfcr, SCC_EB);
 	W8(ep, sen_genscc.scc_tfcr, SCC_EB);
+#endif
 
 	/* Set maximum bytes per receive buffer.
 	 * This appears to be an Ethernet frame size, not the buffer
diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
index 999d691..4320a98 100644
--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -105,6 +105,7 @@ const char gfar_driver_version[] = "1.3";
 
 static int gfar_enet_open(struct net_device *dev);
 static int gfar_start_xmit(struct sk_buff *skb, struct net_device *dev);
+static void gfar_reset_task(struct work_struct *work);
 static void gfar_timeout(struct net_device *dev);
 static int gfar_close(struct net_device *dev);
 struct sk_buff *gfar_new_skb(struct net_device *dev);
@@ -209,6 +210,7 @@ static int gfar_probe(struct platform_device *pdev)
 	spin_lock_init(&priv->txlock);
 	spin_lock_init(&priv->rxlock);
 	spin_lock_init(&priv->bflock);
+	INIT_WORK(&priv->reset_task, gfar_reset_task);
 
 	platform_set_drvdata(pdev, dev);
 
@@ -1212,6 +1214,7 @@ static int gfar_close(struct net_device *dev)
 
 	napi_disable(&priv->napi);
 
+	cancel_work_sync(&priv->reset_task);
 	stop_gfar(dev);
 
 	/* Disconnect from the PHY */
@@ -1326,13 +1329,16 @@ static int gfar_change_mtu(struct net_device *dev, int new_mtu)
 	return 0;
 }
 
-/* gfar_timeout gets called when a packet has not been
+/* gfar_reset_task gets scheduled when a packet has not been
  * transmitted after a set amount of time.
  * For now, assume that clearing out all the structures, and
- * starting over will fix the problem. */
-static void gfar_timeout(struct net_device *dev)
+ * starting over will fix the problem.
+ */
+static void gfar_reset_task(struct work_struct *work)
 {
-	dev->stats.tx_errors++;
+	struct gfar_private *priv = container_of(work, struct gfar_private,
+			reset_task);
+	struct net_device *dev = priv->dev;
 
 	if (dev->flags & IFF_UP) {
 		stop_gfar(dev);
@@ -1342,6 +1348,14 @@ static void gfar_timeout(struct net_device *dev)
 	netif_tx_schedule_all(dev);
 }
 
+static void gfar_timeout(struct net_device *dev)
+{
+	struct gfar_private *priv = netdev_priv(dev);
+
+	dev->stats.tx_errors++;
+	schedule_work(&priv->reset_task);
+}
+
 /* Interrupt Handler for Transmit complete */
 static int gfar_clean_tx_ring(struct net_device *dev)
 {
diff --git a/drivers/net/gianfar.h b/drivers/net/gianfar.h
index d59df98..f46e9b6 100644
--- a/drivers/net/gianfar.h
+++ b/drivers/net/gianfar.h
@@ -756,6 +756,7 @@ struct gfar_private {
 
 	uint32_t msg_enable;
 
+	struct work_struct reset_task;
 	/* Network Statistics */
 	struct gfar_extra_stats extra_stats;
 };
diff --git a/drivers/net/ibm_newemac/core.c b/drivers/net/ibm_newemac/core.c
index 2e720f2..ccd9d90 100644
--- a/drivers/net/ibm_newemac/core.c
+++ b/drivers/net/ibm_newemac/core.c
@@ -663,9 +663,6 @@ static int emac_configure(struct emac_instance *dev)
 	if (emac_phy_gpcs(dev->phy.mode))
 		emac_mii_reset_phy(&dev->phy);
 
-	/* Required for Pause packet support in EMAC */
-	dev_mc_add(ndev, default_mcast_addr, sizeof(default_mcast_addr), 1);
-
 	return 0;
 }
 
@@ -1150,6 +1147,9 @@ static int emac_open(struct net_device *ndev)
 	} else
 		netif_carrier_on(dev->ndev);
 
+	/* Required for Pause packet support in EMAC */
+	dev_mc_add(ndev, default_mcast_addr, sizeof(default_mcast_addr), 1);
+
 	emac_configure(dev);
 	mal_poll_add(dev->mal, &dev->commac);
 	mal_enable_tx_channel(dev->mal, dev->mal_tx_chan);
diff --git a/drivers/net/ibmveth.c b/drivers/net/ibmveth.c
index a03fe1f..c2d57f8 100644
--- a/drivers/net/ibmveth.c
+++ b/drivers/net/ibmveth.c
@@ -904,8 +904,6 @@ static int ibmveth_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 	unsigned long data_dma_addr;
 
 	desc.fields.flags_len = IBMVETH_BUF_VALID | skb->len;
-	data_dma_addr = dma_map_single(&adapter->vdev->dev, skb->data,
-				       skb->len, DMA_TO_DEVICE);
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL &&
 	    ip_hdr(skb)->protocol != IPPROTO_TCP && skb_checksum_help(skb)) {
@@ -924,6 +922,8 @@ static int ibmveth_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 		buf[1] = 0;
 	}
 
+	data_dma_addr = dma_map_single(&adapter->vdev->dev, skb->data,
+				       skb->len, DMA_TO_DEVICE);
 	if (dma_mapping_error(&adapter->vdev->dev, data_dma_addr)) {
 		if (!firmware_has_feature(FW_FEATURE_CMO))
 			ibmveth_error_printk("tx: unable to map xmit buffer\n");
@@ -932,6 +932,7 @@ static int ibmveth_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 		desc.fields.address = adapter->bounce_buffer_dma;
 		tx_map_failed++;
 		used_bounce = 1;
+		wmb();
 	} else
 		desc.fields.address = data_dma_addr;
 
diff --git a/drivers/net/igb/e1000_82575.c b/drivers/net/igb/e1000_82575.c
index bb823ac..f5e2e72 100644
--- a/drivers/net/igb/e1000_82575.c
+++ b/drivers/net/igb/e1000_82575.c
@@ -87,7 +87,6 @@ static s32 igb_get_invariants_82575(struct e1000_hw *hw)
 	case E1000_DEV_ID_82576:
 	case E1000_DEV_ID_82576_FIBER:
 	case E1000_DEV_ID_82576_SERDES:
-	case E1000_DEV_ID_82576_QUAD_COPPER:
 		mac->type = e1000_82576;
 		break;
 	default:
diff --git a/drivers/net/igb/e1000_hw.h b/drivers/net/igb/e1000_hw.h
index a65ccc3..99504a6 100644
--- a/drivers/net/igb/e1000_hw.h
+++ b/drivers/net/igb/e1000_hw.h
@@ -41,7 +41,6 @@ struct e1000_hw;
 #define E1000_DEV_ID_82576                    0x10C9
 #define E1000_DEV_ID_82576_FIBER              0x10E6
 #define E1000_DEV_ID_82576_SERDES             0x10E7
-#define E1000_DEV_ID_82576_QUAD_COPPER        0x10E8
 #define E1000_DEV_ID_82575EB_COPPER           0x10A7
 #define E1000_DEV_ID_82575EB_FIBER_SERDES     0x10A9
 #define E1000_DEV_ID_82575GB_QUAD_COPPER      0x10D6
diff --git a/drivers/net/igb/igb_ethtool.c b/drivers/net/igb/igb_ethtool.c
index 11aee13..58906c9 100644
--- a/drivers/net/igb/igb_ethtool.c
+++ b/drivers/net/igb/igb_ethtool.c
@@ -373,13 +373,17 @@ static void igb_get_regs(struct net_device *netdev,
 	regs_buff[12] = rd32(E1000_EECD);
 
 	/* Interrupt */
-	regs_buff[13] = rd32(E1000_EICR);
+	/* Reading EICS for EICR because they read the
+	 * same but EICS does not clear on read */
+	regs_buff[13] = rd32(E1000_EICS);
 	regs_buff[14] = rd32(E1000_EICS);
 	regs_buff[15] = rd32(E1000_EIMS);
 	regs_buff[16] = rd32(E1000_EIMC);
 	regs_buff[17] = rd32(E1000_EIAC);
 	regs_buff[18] = rd32(E1000_EIAM);
-	regs_buff[19] = rd32(E1000_ICR);
+	/* Reading ICS for ICR because they read the
+	 * same but ICS does not clear on read */
+	regs_buff[19] = rd32(E1000_ICS);
 	regs_buff[20] = rd32(E1000_ICS);
 	regs_buff[21] = rd32(E1000_IMS);
 	regs_buff[22] = rd32(E1000_IMC);
@@ -1746,15 +1750,6 @@ static int igb_wol_exclusion(struct igb_adapter *adapter,
 		/* return success for non excluded adapter ports */
 		retval = 0;
 		break;
-	case E1000_DEV_ID_82576_QUAD_COPPER:
-		/* quad port adapters only support WoL on port A */
-		if (!(adapter->flags & IGB_FLAG_QUAD_PORT_A)) {
-			wol->supported = 0;
-			break;
-		}
-		/* return success for non excluded adapter ports */
-		retval = 0;
-		break;
 	default:
 		/* dual port cards only support WoL on port A from now on
 		 * unless it was enabled in the eeprom for port B
diff --git a/drivers/net/igb/igb_main.c b/drivers/net/igb/igb_main.c
index 8f66e15..634c4c9 100644
--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -61,7 +61,6 @@ static struct pci_device_id igb_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_82576), board_82575 },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_82576_FIBER), board_82575 },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_82576_SERDES), board_82575 },
-	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_82576_QUAD_COPPER), board_82575 },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_82575EB_COPPER), board_82575 },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_82575EB_FIBER_SERDES), board_82575 },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_82575GB_QUAD_COPPER), board_82575 },
@@ -521,7 +520,7 @@ static void igb_set_interrupt_capability(struct igb_adapter *adapter)
 			      adapter->msix_entries,
 			      numvecs);
 	if (err == 0)
-		return;
+		goto out;
 
 	igb_reset_interrupt_capability(adapter);
 
@@ -531,7 +530,7 @@ msi_only:
 	adapter->num_tx_queues = 1;
 	if (!pci_enable_msi(adapter->pdev))
 		adapter->flags |= IGB_FLAG_HAS_MSI;
-
+out:
 	/* Notify the stack of the (possibly) reduced Tx Queue count. */
 	adapter->netdev->real_num_tx_queues = adapter->num_tx_queues;
 	return;
@@ -1217,16 +1216,6 @@ static int __devinit igb_probe(struct pci_dev *pdev,
 		if (rd32(E1000_STATUS) & E1000_STATUS_FUNC_1)
 			adapter->eeprom_wol = 0;
 		break;
-	case E1000_DEV_ID_82576_QUAD_COPPER:
-		/* if quad port adapter, disable WoL on all but port A */
-		if (global_quad_port_a != 0)
-			adapter->eeprom_wol = 0;
-		else
-			adapter->flags |= IGB_FLAG_QUAD_PORT_A;
-		/* Reset for multiple quad port adapters */
-		if (++global_quad_port_a == 4)
-			global_quad_port_a = 0;
-		break;
 	}
 
 	/* initialize the wol settings based on the eeprom settings */
@@ -2290,7 +2279,9 @@ static void igb_watchdog_task(struct work_struct *work)
 	struct igb_ring *tx_ring = adapter->tx_ring;
 	struct e1000_mac_info *mac = &adapter->hw.mac;
 	u32 link;
+	u32 eics = 0;
 	s32 ret_val;
+	int i;
 
 	if ((netif_carrier_ok(netdev)) &&
 	    (rd32(E1000_STATUS) & E1000_STATUS_LU))
@@ -2392,7 +2383,13 @@ link_up:
 	}
 
 	/* Cause software interrupt to ensure rx ring is cleaned */
-	wr32(E1000_ICS, E1000_ICS_RXDMT0);
+	if (adapter->msix_entries) {
+		for (i = 0; i < adapter->num_rx_queues; i++)
+			eics |= adapter->rx_ring[i].eims_value;
+		wr32(E1000_EICS, eics);
+	} else {
+		wr32(E1000_ICS, E1000_ICS_RXDMT0);
+	}
 
 	/* Force detection of hung controller every watchdog period */
 	tx_ring->detect_tx_hung = true;
diff --git a/drivers/net/ixgbe/ixgbe_main.c b/drivers/net/ixgbe/ixgbe_main.c
index 34bca16..53f41b6 100644
--- a/drivers/net/ixgbe/ixgbe_main.c
+++ b/drivers/net/ixgbe/ixgbe_main.c
@@ -1636,16 +1636,17 @@ static void ixgbe_set_multi(struct net_device *netdev)
 	struct ixgbe_hw *hw = &adapter->hw;
 	struct dev_mc_list *mc_ptr;
 	u8 *mta_list;
-	u32 fctrl;
+	u32 fctrl, vlnctrl;
 	int i;
 
 	/* Check for Promiscuous and All Multicast modes */
 
 	fctrl = IXGBE_READ_REG(hw, IXGBE_FCTRL);
+	vlnctrl = IXGBE_READ_REG(hw, IXGBE_VLNCTRL);
 
 	if (netdev->flags & IFF_PROMISC) {
 		fctrl |= (IXGBE_FCTRL_UPE | IXGBE_FCTRL_MPE);
-		fctrl &= ~IXGBE_VLNCTRL_VFE;
+		vlnctrl &= ~IXGBE_VLNCTRL_VFE;
 	} else {
 		if (netdev->flags & IFF_ALLMULTI) {
 			fctrl |= IXGBE_FCTRL_MPE;
@@ -1653,10 +1654,11 @@ static void ixgbe_set_multi(struct net_device *netdev)
 		} else {
 			fctrl &= ~(IXGBE_FCTRL_UPE | IXGBE_FCTRL_MPE);
 		}
-		fctrl |= IXGBE_VLNCTRL_VFE;
+		vlnctrl |= IXGBE_VLNCTRL_VFE;
 	}
 
 	IXGBE_WRITE_REG(hw, IXGBE_FCTRL, fctrl);
+	IXGBE_WRITE_REG(hw, IXGBE_VLNCTRL, vlnctrl);
 
 	if (netdev->mc_count) {
 		mta_list = kcalloc(netdev->mc_count, ETH_ALEN, GFP_ATOMIC);
diff --git a/drivers/net/mv643xx_eth.c b/drivers/net/mv643xx_eth.c
index 46819af..0a18b9e 100644
--- a/drivers/net/mv643xx_eth.c
+++ b/drivers/net/mv643xx_eth.c
@@ -55,7 +55,7 @@
 #include <asm/system.h>
 
 static char mv643xx_eth_driver_name[] = "mv643xx_eth";
-static char mv643xx_eth_driver_version[] = "1.2";
+static char mv643xx_eth_driver_version[] = "1.3";
 
 #define MV643XX_ETH_CHECKSUM_OFFLOAD_TX
 #define MV643XX_ETH_NAPI
@@ -474,11 +474,19 @@ static void rxq_refill(struct rx_queue *rxq)
 		/*
 		 * Reserve 2+14 bytes for an ethernet header (the
 		 * hardware automatically prepends 2 bytes of dummy
-		 * data to each received packet), 4 bytes for a VLAN
-		 * header, and 4 bytes for the trailing FCS -- 24
-		 * bytes total.
+		 * data to each received packet), 16 bytes for up to
+		 * four VLAN tags, and 4 bytes for the trailing FCS
+		 * -- 36 bytes total.
 		 */
-		skb_size = mp->dev->mtu + 24;
+		skb_size = mp->dev->mtu + 36;
+
+		/*
+		 * Make sure that the skb size is a multiple of 8
+		 * bytes, as the lower three bits of the receive
+		 * descriptor's buffer size field are ignored by
+		 * the hardware.
+		 */
+		skb_size = (skb_size + 7) & ~7;
 
 		skb = dev_alloc_skb(skb_size + dma_get_cache_alignment() - 1);
 		if (skb == NULL)
@@ -509,10 +517,8 @@ static void rxq_refill(struct rx_queue *rxq)
 		skb_reserve(skb, 2);
 	}
 
-	if (rxq->rx_desc_count != rxq->rx_ring_size) {
-		rxq->rx_oom.expires = jiffies + (HZ / 10);
-		add_timer(&rxq->rx_oom);
-	}
+	if (rxq->rx_desc_count != rxq->rx_ring_size)
+		mod_timer(&rxq->rx_oom, jiffies + (HZ / 10));
 
 	spin_unlock_irqrestore(&mp->lock, flags);
 }
@@ -529,7 +535,7 @@ static int rxq_process(struct rx_queue *rxq, int budget)
 	int rx;
 
 	rx = 0;
-	while (rx < budget) {
+	while (rx < budget && rxq->rx_desc_count) {
 		struct rx_desc *rx_desc;
 		unsigned int cmd_sts;
 		struct sk_buff *skb;
@@ -554,7 +560,7 @@ static int rxq_process(struct rx_queue *rxq, int budget)
 		spin_unlock_irqrestore(&mp->lock, flags);
 
 		dma_unmap_single(NULL, rx_desc->buf_ptr + 2,
-				 mp->dev->mtu + 24, DMA_FROM_DEVICE);
+				 rx_desc->buf_size, DMA_FROM_DEVICE);
 		rxq->rx_desc_count--;
 		rx++;
 
@@ -636,9 +642,9 @@ static int mv643xx_eth_poll(struct napi_struct *napi, int budget)
 				txq_reclaim(mp->txq + i, 0);
 
 		if (netif_carrier_ok(mp->dev)) {
-			spin_lock(&mp->lock);
+			spin_lock_irq(&mp->lock);
 			__txq_maybe_wake(mp->txq + mp->txq_primary);
-			spin_unlock(&mp->lock);
+			spin_unlock_irq(&mp->lock);
 		}
 	}
 #endif
@@ -650,8 +656,6 @@ static int mv643xx_eth_poll(struct napi_struct *napi, int budget)
 
 	if (rx < budget) {
 		netif_rx_complete(mp->dev, napi);
-		wrl(mp, INT_CAUSE(mp->port_num), 0);
-		wrl(mp, INT_CAUSE_EXT(mp->port_num), 0);
 		wrl(mp, INT_MASK(mp->port_num), INT_TX_END | INT_RX | INT_EXT);
 	}
 
@@ -1796,6 +1800,7 @@ static irqreturn_t mv643xx_eth_irq(int irq, void *dev_id)
 	 */
 #ifdef MV643XX_ETH_NAPI
 	if (int_cause & INT_RX) {
+		wrl(mp, INT_CAUSE(mp->port_num), ~(int_cause & INT_RX));
 		wrl(mp, INT_MASK(mp->port_num), 0x00000000);
 		rdl(mp, INT_MASK(mp->port_num));
 
diff --git a/drivers/net/myri10ge/myri10ge.c b/drivers/net/myri10ge/myri10ge.c
index 5d76cd0..f684753 100644
--- a/drivers/net/myri10ge/myri10ge.c
+++ b/drivers/net/myri10ge/myri10ge.c
@@ -76,7 +76,7 @@
 #include "myri10ge_mcp.h"
 #include "myri10ge_mcp_gen_header.h"
 
-#define MYRI10GE_VERSION_STR "1.3.99-1.347"
+#define MYRI10GE_VERSION_STR "1.4.3-1.358"
 
 MODULE_DESCRIPTION("Myricom 10G driver (10GbE)");
 MODULE_AUTHOR("Maintainer: help@myri.com");
diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index a3e3895..0f6f974 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -2792,7 +2792,7 @@ static int rtl8169_rx_interrupt(struct net_device *dev,
 					pkt_size, PCI_DMA_FROMDEVICE);
 				rtl8169_mark_to_asic(desc, tp->rx_buf_sz);
 			} else {
-				pci_unmap_single(pdev, addr, pkt_size,
+				pci_unmap_single(pdev, addr, tp->rx_buf_sz,
 						 PCI_DMA_FROMDEVICE);
 				tp->Rx_skbuff[entry] = NULL;
 			}
diff --git a/drivers/net/skfp/ess.c b/drivers/net/skfp/ess.c
index 889f987..a85efcf 100644
--- a/drivers/net/skfp/ess.c
+++ b/drivers/net/skfp/ess.c
@@ -510,7 +510,7 @@ static void ess_send_response(struct s_smc *smc, struct smt_header *sm,
 	chg->path.para.p_type = SMT_P320B ;
 	chg->path.para.p_len = sizeof(struct smt_p_320b) - PARA_LEN ;
 	chg->path.mib_index = SBAPATHINDEX ;
-	chg->path.path_pad = (u_short)NULL ;
+	chg->path.path_pad = 0;
 	chg->path.path_index = PRIMARY_RING ;
 
 	/* set P320F */
@@ -606,7 +606,7 @@ static void ess_send_alc_req(struct s_smc *smc)
 	req->path.para.p_type = SMT_P320B ;
 	req->path.para.p_len = sizeof(struct smt_p_320b) - PARA_LEN ;
 	req->path.mib_index = SBAPATHINDEX ;
-	req->path.path_pad = (u_short)NULL ;
+	req->path.path_pad = 0;
 	req->path.path_index = PRIMARY_RING ;
 
 	/* set P0017 */
@@ -636,7 +636,7 @@ static void ess_send_alc_req(struct s_smc *smc)
 	/* set P19 */
 	req->a_addr.para.p_type = SMT_P0019 ;
 	req->a_addr.para.p_len = sizeof(struct smt_p_0019) - PARA_LEN ;
-	req->a_addr.sba_pad = (u_short)NULL ;
+	req->a_addr.sba_pad = 0;
 	req->a_addr.alloc_addr = null_addr ;
 
 	/* set P1A */
diff --git a/drivers/net/smc91x.c b/drivers/net/smc91x.c
index 2040965..24768c1 100644
--- a/drivers/net/smc91x.c
+++ b/drivers/net/smc91x.c
@@ -2255,7 +2255,7 @@ static int smc_drv_remove(struct platform_device *pdev)
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "smc91x-regs");
 	if (!res)
-		platform_get_resource(pdev, IORESOURCE_MEM, 0);
+		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(res->start, SMC_IO_EXTENT);
 
 	free_netdev(ndev);
diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 1b7cac7..6e42b5a 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -397,7 +397,7 @@ static const struct usb_device_id hso_ids[] = {
 	{default_port_device(0x0af0, 0xc031)},	/* Icon-Edge */
 	{icon321_port_device(0x0af0, 0xd013)},	/* Module HSxPA */
 	{icon321_port_device(0x0af0, 0xd031)},	/* Icon-321 */
-	{default_port_device(0x0af0, 0xd033)},	/* Icon-322 */
+	{icon321_port_device(0x0af0, 0xd033)},	/* Icon-322 */
 	{USB_DEVICE(0x0af0, 0x7301)},		/* GE40x */
 	{USB_DEVICE(0x0af0, 0x7361)},		/* GE40x */
 	{USB_DEVICE(0x0af0, 0x7401)},		/* GI 0401 */
@@ -2613,6 +2613,7 @@ static int hso_resume(struct usb_interface *iface)
 					"Transmitting lingering data\n");
 				hso_net_start_xmit(hso_net->skb_tx_buf,
 						   hso_net->net);
+				hso_net->skb_tx_buf = NULL;
 			}
 			result = hso_start_net_device(network_table[i]);
 			if (result)
diff --git a/drivers/net/usb/mcs7830.c b/drivers/net/usb/mcs7830.c
index c3d119f..ca9d00c 100644
--- a/drivers/net/usb/mcs7830.c
+++ b/drivers/net/usb/mcs7830.c
@@ -46,6 +46,10 @@
 
 #define MCS7830_VENDOR_ID	0x9710
 #define MCS7830_PRODUCT_ID	0x7830
+#define MCS7730_PRODUCT_ID	0x7730
+
+#define SITECOM_VENDOR_ID	0x0DF6
+#define LN_030_PRODUCT_ID	0x0021
 
 #define MCS7830_MII_ADVERTISE	(ADVERTISE_PAUSE_CAP | ADVERTISE_100FULL | \
 				 ADVERTISE_100HALF | ADVERTISE_10FULL | \
@@ -442,6 +446,29 @@ static struct ethtool_ops mcs7830_ethtool_ops = {
 	.nway_reset		= usbnet_nway_reset,
 };
 
+static int mcs7830_set_mac_address(struct net_device *netdev, void *p)
+{
+	int ret;
+	struct usbnet *dev = netdev_priv(netdev);
+	struct sockaddr *addr = p;
+
+	if (netif_running(netdev))
+		return -EBUSY;
+
+	if (!is_valid_ether_addr(addr->sa_data))
+		return -EINVAL;
+
+	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
+
+	ret = mcs7830_set_reg(dev, HIF_REG_ETHERNET_ADDR, ETH_ALEN,
+			netdev->dev_addr);
+
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
 static int mcs7830_bind(struct usbnet *dev, struct usb_interface *udev)
 {
 	struct net_device *net = dev->net;
@@ -455,6 +482,7 @@ static int mcs7830_bind(struct usbnet *dev, struct usb_interface *udev)
 	net->ethtool_ops = &mcs7830_ethtool_ops;
 	net->set_multicast_list = mcs7830_set_multicast;
 	mcs7830_set_multicast(net);
+	net->set_mac_address = mcs7830_set_mac_address;
 
 	/* reserve space for the status byte on rx */
 	dev->rx_urb_size = ETH_FRAME_LEN + 1;
@@ -491,7 +519,16 @@ static int mcs7830_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 }
 
 static const struct driver_info moschip_info = {
-	.description	= "MOSCHIP 7830 usb-NET adapter",
+	.description	= "MOSCHIP 7830/7730 usb-NET adapter",
+	.bind		= mcs7830_bind,
+	.rx_fixup	= mcs7830_rx_fixup,
+	.flags		= FLAG_ETHER,
+	.in		= 1,
+	.out		= 2,
+};
+
+static const struct driver_info sitecom_info = {
+	.description    = "Sitecom LN-30 usb-NET adapter",
 	.bind		= mcs7830_bind,
 	.rx_fixup	= mcs7830_rx_fixup,
 	.flags		= FLAG_ETHER,
@@ -504,6 +541,14 @@ static const struct usb_device_id products[] = {
 		USB_DEVICE(MCS7830_VENDOR_ID, MCS7830_PRODUCT_ID),
 		.driver_info = (unsigned long) &moschip_info,
 	},
+	{
+		USB_DEVICE(MCS7830_VENDOR_ID, MCS7730_PRODUCT_ID),
+		.driver_info = (unsigned long) &moschip_info,
+	},
+	{
+		USB_DEVICE(SITECOM_VENDOR_ID, LN_030_PRODUCT_ID),
+		.driver_info = (unsigned long) &sitecom_info,
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(usb, products);
diff --git a/drivers/net/wd.c b/drivers/net/wd.c
index 6f9aa16..fa14255 100644
--- a/drivers/net/wd.c
+++ b/drivers/net/wd.c
@@ -337,7 +337,7 @@ static int __init wd_probe1(struct net_device *dev, int ioaddr)
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	dev->poll_controller = ei_poll;
 #endif
-	NS8390p_init(dev, 0);
+	NS8390_init(dev, 0);
 
 #if 1
 	/* Enable interrupt generation on softconfig cards -- M.U */
diff --git a/drivers/s390/net/claw.c b/drivers/s390/net/claw.c
index a08b168..e10ac9a 100644
--- a/drivers/s390/net/claw.c
+++ b/drivers/s390/net/claw.c
@@ -133,14 +133,14 @@ claw_register_debug_facility(void)
 static inline void
 claw_set_busy(struct net_device *dev)
 {
- ((struct claw_privbk *) dev->priv)->tbusy=1;
+ ((struct claw_privbk *)dev->ml_priv)->tbusy = 1;
  eieio();
 }
 
 static inline void
 claw_clear_busy(struct net_device *dev)
 {
-	clear_bit(0, &(((struct claw_privbk *) dev->priv)->tbusy));
+	clear_bit(0, &(((struct claw_privbk *) dev->ml_priv)->tbusy));
 	netif_wake_queue(dev);
 	eieio();
 }
@@ -149,20 +149,20 @@ static inline int
 claw_check_busy(struct net_device *dev)
 {
 	eieio();
-	return ((struct claw_privbk *) dev->priv)->tbusy;
+	return ((struct claw_privbk *) dev->ml_priv)->tbusy;
 }
 
 static inline void
 claw_setbit_busy(int nr,struct net_device *dev)
 {
 	netif_stop_queue(dev);
- 	set_bit(nr, (void *)&(((struct claw_privbk *)dev->priv)->tbusy));
+	set_bit(nr, (void *)&(((struct claw_privbk *)dev->ml_priv)->tbusy));
 }
 
 static inline void
 claw_clearbit_busy(int nr,struct net_device *dev)
 {
- 	clear_bit(nr,(void *)&(((struct claw_privbk *)dev->priv)->tbusy));
+	clear_bit(nr, (void *)&(((struct claw_privbk *)dev->ml_priv)->tbusy));
 	netif_wake_queue(dev);
 }
 
@@ -171,7 +171,7 @@ claw_test_and_setbit_busy(int nr,struct net_device *dev)
 {
 	netif_stop_queue(dev);
 	return test_and_set_bit(nr,
- 		(void *)&(((struct claw_privbk *) dev->priv)->tbusy));
+		(void *)&(((struct claw_privbk *) dev->ml_priv)->tbusy));
 }
 
 
@@ -271,6 +271,7 @@ claw_probe(struct ccwgroup_device *cgdev)
 	if (!get_device(&cgdev->dev))
 		return -ENODEV;
 	privptr = kzalloc(sizeof(struct claw_privbk), GFP_KERNEL);
+	cgdev->dev.driver_data = privptr;
 	if (privptr == NULL) {
 		probe_error(cgdev);
 		put_device(&cgdev->dev);
@@ -305,7 +306,6 @@ claw_probe(struct ccwgroup_device *cgdev)
 	privptr->p_env->p_priv = privptr;
         cgdev->cdev[0]->handler = claw_irq_handler;
 	cgdev->cdev[1]->handler = claw_irq_handler;
-	cgdev->dev.driver_data = privptr;
 	CLAW_DBF_TEXT(2, setup, "prbext 0");
 
         return 0;
@@ -319,7 +319,7 @@ static int
 claw_tx(struct sk_buff *skb, struct net_device *dev)
 {
         int             rc;
-        struct claw_privbk *privptr=dev->priv;
+	struct claw_privbk *privptr = dev->ml_priv;
 	unsigned long saveflags;
         struct chbk *p_ch;
 
@@ -404,7 +404,7 @@ claw_pack_skb(struct claw_privbk *privptr)
 static int
 claw_change_mtu(struct net_device *dev, int new_mtu)
 {
-	struct claw_privbk  *privptr=dev->priv;
+	struct claw_privbk *privptr = dev->ml_priv;
 	int buff_size;
 	CLAW_DBF_TEXT(4, trace, "setmtu");
 	buff_size = privptr->p_env->write_size;
@@ -434,7 +434,7 @@ claw_open(struct net_device *dev)
         struct ccwbk *p_buf;
 
 	CLAW_DBF_TEXT(4, trace, "open");
-	privptr = (struct claw_privbk *)dev->priv;
+	privptr = (struct claw_privbk *)dev->ml_priv;
         /*   allocate and initialize CCW blocks */
 	if (privptr->buffs_alloc == 0) {
 	        rc=init_ccw_bk(dev);
@@ -780,7 +780,7 @@ claw_irq_tasklet ( unsigned long data )
 	p_ch = (struct chbk *) data;
         dev = (struct net_device *)p_ch->ndev;
 	CLAW_DBF_TEXT(4, trace, "IRQtask");
-        privptr = (struct claw_privbk *) dev->priv;
+	privptr = (struct claw_privbk *)dev->ml_priv;
         unpack_read(dev);
         clear_bit(CLAW_BH_ACTIVE, (void *)&p_ch->flag_a);
 	CLAW_DBF_TEXT(4, trace, "TskletXt");
@@ -805,7 +805,7 @@ claw_release(struct net_device *dev)
 
 	if (!dev)
                 return 0;
-        privptr = (struct claw_privbk *) dev->priv;
+	privptr = (struct claw_privbk *)dev->ml_priv;
         if (!privptr)
                 return 0;
 	CLAW_DBF_TEXT(4, trace, "release");
@@ -960,7 +960,7 @@ claw_write_next ( struct chbk * p_ch )
         if (p_ch->claw_state == CLAW_STOP)
                 return;
         dev = (struct net_device *) p_ch->ndev;
-	privptr = (struct claw_privbk *) dev->priv;
+	privptr = (struct claw_privbk *) dev->ml_priv;
         claw_free_wrt_buf( dev );
 	if ((privptr->write_free_count > 0) &&
 	    !skb_queue_empty(&p_ch->collect_queue)) {
@@ -1042,7 +1042,7 @@ add_claw_reads(struct net_device *dev, struct ccwbk* p_first,
         struct ccw1  temp_ccw;
         struct endccw * p_end;
 	CLAW_DBF_TEXT(4, trace, "addreads");
-        privptr = dev->priv;
+	privptr = dev->ml_priv;
         p_end = privptr->p_end_ccw;
 
         /* first CCW and last CCW contains a new set of read channel programs
@@ -1212,7 +1212,7 @@ find_link(struct net_device *dev, char *host_name, char *ws_name )
 	int    rc=0;
 
 	CLAW_DBF_TEXT(2, setup, "findlink");
-        privptr=dev->priv;
+	privptr = dev->ml_priv;
         p_env=privptr->p_env;
 	switch (p_env->packing)
 	{
@@ -1264,7 +1264,7 @@ claw_hw_tx(struct sk_buff *skb, struct net_device *dev, long linkid)
 	struct chbk			*ch;
 
 	CLAW_DBF_TEXT(4, trace, "hw_tx");
-        privptr = (struct claw_privbk *) (dev->priv);
+	privptr = (struct claw_privbk *)(dev->ml_priv);
         p_ch=(struct chbk *)&privptr->channel[WRITE];
 	p_env =privptr->p_env;
 	claw_free_wrt_buf(dev);	/* Clean up free chain if posible */
@@ -1483,8 +1483,8 @@ init_ccw_bk(struct net_device *dev)
 	struct ccwbk*p_last_CCWB;
 	struct ccwbk*p_first_CCWB;
         struct endccw *p_endccw=NULL;
-        addr_t  real_address;
-        struct claw_privbk *privptr=dev->priv;
+	addr_t  real_address;
+	struct claw_privbk *privptr = dev->ml_priv;
         struct clawh *pClawH=NULL;
         addr_t   real_TIC_address;
         int i,j;
@@ -1960,19 +1960,16 @@ init_ccw_bk(struct net_device *dev)
 static void
 probe_error( struct ccwgroup_device *cgdev)
 {
-  struct claw_privbk *privptr;
+	struct claw_privbk *privptr;
 
 	CLAW_DBF_TEXT(4, trace, "proberr");
-        privptr=(struct claw_privbk *)cgdev->dev.driver_data;
-	if (privptr!=NULL) {
+	privptr = (struct claw_privbk *) cgdev->dev.driver_data;
+	if (privptr != NULL) {
+		cgdev->dev.driver_data = NULL;
 		kfree(privptr->p_env);
-		privptr->p_env=NULL;
-                kfree(privptr->p_mtc_envelope);
-               	privptr->p_mtc_envelope=NULL;
-                kfree(privptr);
-                privptr=NULL;
-        }
-        return;
+		kfree(privptr->p_mtc_envelope);
+		kfree(privptr);
+	}
 }    /*    probe_error    */
 
 /*-------------------------------------------------------------------*
@@ -2000,7 +1997,7 @@ claw_process_control( struct net_device *dev, struct ccwbk * p_ccw)
 	CLAW_DBF_TEXT(2, setup, "clw_cntl");
         udelay(1000);  /* Wait a ms for the control packets to
 			*catch up to each other */
-        privptr=dev->priv;
+	privptr = dev->ml_priv;
         p_env=privptr->p_env;
 	tdev = &privptr->channel[READ].cdev->dev;
 	memcpy( &temp_host_name, p_env->host_name, 8);
@@ -2278,7 +2275,7 @@ claw_send_control(struct net_device *dev, __u8 type, __u8 link,
         struct sk_buff 			*skb;
 
 	CLAW_DBF_TEXT(2, setup, "sndcntl");
-        privptr=dev->priv;
+	privptr = dev->ml_priv;
         p_ctl=(struct clawctl *)&privptr->ctl_bk;
 
         p_ctl->command=type;
@@ -2348,7 +2345,7 @@ static int
 claw_snd_conn_req(struct net_device *dev, __u8 link)
 {
         int                rc;
-        struct claw_privbk *privptr=dev->priv;
+	struct claw_privbk *privptr = dev->ml_priv;
         struct clawctl 	   *p_ctl;
 
 	CLAW_DBF_TEXT(2, setup, "snd_conn");
@@ -2408,7 +2405,7 @@ claw_snd_sys_validate_rsp(struct net_device *dev,
         int    rc;
 
 	CLAW_DBF_TEXT(2, setup, "chkresp");
-        privptr = dev->priv;
+	privptr = dev->ml_priv;
         p_env=privptr->p_env;
         rc=claw_send_control(dev, SYSTEM_VALIDATE_RESPONSE,
 		p_ctl->linkid,
@@ -2446,7 +2443,7 @@ net_device_stats *claw_stats(struct net_device *dev)
         struct claw_privbk *privptr;
 
 	CLAW_DBF_TEXT(4, trace, "stats");
-        privptr = dev->priv;
+	privptr = dev->ml_priv;
         return &privptr->stats;
 }     /*   end of claw_stats   */
 
@@ -2482,7 +2479,7 @@ unpack_read(struct net_device *dev )
         p_last_ccw=NULL;
 	p_packh=NULL;
 	p_packd=NULL;
-        privptr=dev->priv;
+	privptr = dev->ml_priv;
 
 	p_dev = &privptr->channel[READ].cdev->dev;
 	p_env = privptr->p_env;
@@ -2651,7 +2648,7 @@ claw_strt_read (struct net_device *dev, int lock )
         int        rc = 0;
         __u32      parm;
         unsigned long  saveflags = 0;
-        struct claw_privbk *privptr=dev->priv;
+	struct claw_privbk *privptr = dev->ml_priv;
         struct ccwbk*p_ccwbk;
         struct chbk *p_ch;
         struct clawh *p_clawh;
@@ -2708,7 +2705,7 @@ claw_strt_out_IO( struct net_device *dev )
 	if (!dev) {
 		return;
 	}
-        privptr=(struct claw_privbk *)dev->priv;
+	privptr = (struct claw_privbk *)dev->ml_priv;
         p_ch=&privptr->channel[WRITE];
 
 	CLAW_DBF_TEXT(4, trace, "strt_io");
@@ -2741,7 +2738,7 @@ static void
 claw_free_wrt_buf( struct net_device *dev )
 {
 
-        struct claw_privbk *privptr=(struct claw_privbk *)dev->priv;
+	struct claw_privbk *privptr = (struct claw_privbk *)dev->ml_priv;
         struct ccwbk*p_first_ccw;
 	struct ccwbk*p_last_ccw;
 	struct ccwbk*p_this_ccw;
@@ -2798,13 +2795,13 @@ claw_free_netdevice(struct net_device * dev, int free_dev)
 	if (!dev)
 		return;
 	CLAW_DBF_TEXT_(2, setup, "%s", dev->name);
-	privptr = dev->priv;
+	privptr = dev->ml_priv;
 	if (dev->flags & IFF_RUNNING)
 		claw_release(dev);
 	if (privptr) {
 		privptr->channel[READ].ndev = NULL;  /* say it's free */
 	}
-	dev->priv=NULL;
+	dev->ml_priv = NULL;
 #ifdef MODULE
 	if (free_dev) {
 		free_netdev(dev);
@@ -2921,7 +2918,7 @@ claw_new_device(struct ccwgroup_device *cgdev)
 		printk(KERN_WARNING "%s:alloc_netdev failed\n",__func__);
 		goto out;
 	}
-	dev->priv = privptr;
+	dev->ml_priv = privptr;
 	cgdev->dev.driver_data = privptr;
         cgdev->cdev[READ]->dev.driver_data = privptr;
         cgdev->cdev[WRITE]->dev.driver_data = privptr;
@@ -3002,7 +2999,7 @@ claw_shutdown_device(struct ccwgroup_device *cgdev)
 			ret = claw_release(ndev);
 		ndev->flags &=~IFF_RUNNING;
 		unregister_netdev(ndev);
-		ndev->priv = NULL;  /* cgdev data, not ndev's to free */
+		ndev->ml_priv = NULL;  /* cgdev data, not ndev's to free */
 		claw_free_netdevice(ndev, 1);
 		priv->channel[READ].ndev = NULL;
 		priv->channel[WRITE].ndev = NULL;
diff --git a/drivers/s390/net/ctcm_fsms.c b/drivers/s390/net/ctcm_fsms.c
index 0b4e625..4277655 100644
--- a/drivers/s390/net/ctcm_fsms.c
+++ b/drivers/s390/net/ctcm_fsms.c
@@ -245,7 +245,7 @@ static void chx_txdone(fsm_instance *fi, int event, void *arg)
 {
 	struct channel *ch = arg;
 	struct net_device *dev = ch->netdev;
-	struct ctcm_priv *priv = dev->priv;
+	struct ctcm_priv *priv = dev->ml_priv;
 	struct sk_buff *skb;
 	int first = 1;
 	int i;
@@ -336,7 +336,7 @@ void ctcm_chx_txidle(fsm_instance *fi, int event, void *arg)
 {
 	struct channel *ch = arg;
 	struct net_device *dev = ch->netdev;
-	struct ctcm_priv *priv = dev->priv;
+	struct ctcm_priv *priv = dev->ml_priv;
 
 	CTCM_PR_DEBUG("%s(%s): %s\n", __func__, ch->id, dev->name);
 
@@ -357,7 +357,7 @@ static void chx_rx(fsm_instance *fi, int event, void *arg)
 {
 	struct channel *ch = arg;
 	struct net_device *dev = ch->netdev;
-	struct ctcm_priv *priv = dev->priv;
+	struct ctcm_priv *priv = dev->ml_priv;
 	int len = ch->max_bufsize - ch->irb->scsw.cmd.count;
 	struct sk_buff *skb = ch->trans_skb;
 	__u16 block_len = *((__u16 *)skb->data);
@@ -459,7 +459,7 @@ static void chx_firstio(fsm_instance *fi, int event, void *arg)
 			chx_rxidle(fi, event, arg);
 		} else {
 			struct net_device *dev = ch->netdev;
-			struct ctcm_priv *priv = dev->priv;
+			struct ctcm_priv *priv = dev->ml_priv;
 			fsm_newstate(fi, CTC_STATE_TXIDLE);
 			fsm_event(priv->fsm, DEV_EVENT_TXUP, dev);
 		}
@@ -496,7 +496,7 @@ static void chx_firstio(fsm_instance *fi, int event, void *arg)
 	if ((CHANNEL_DIRECTION(ch->flags) == READ) &&
 	    (ch->protocol == CTCM_PROTO_S390)) {
 		struct net_device *dev = ch->netdev;
-		struct ctcm_priv *priv = dev->priv;
+		struct ctcm_priv *priv = dev->ml_priv;
 		fsm_event(priv->fsm, DEV_EVENT_RXUP, dev);
 	}
 }
@@ -514,7 +514,7 @@ static void chx_rxidle(fsm_instance *fi, int event, void *arg)
 {
 	struct channel *ch = arg;
 	struct net_device *dev = ch->netdev;
-	struct ctcm_priv *priv = dev->priv;
+	struct ctcm_priv *priv = dev->ml_priv;
 	__u16 buflen;
 	int rc;
 
@@ -699,7 +699,7 @@ static void ctcm_chx_cleanup(fsm_instance *fi, int state,
 		struct channel *ch)
 {
 	struct net_device *dev = ch->netdev;
-	struct ctcm_priv *priv = dev->priv;
+	struct ctcm_priv *priv = dev->ml_priv;
 
 	CTCM_DBF_TEXT_(SETUP, CTC_DBF_NOTICE,
 			"%s(%s): %s[%d]\n",
@@ -784,7 +784,7 @@ static void ctcm_chx_setuperr(fsm_instance *fi, int event, void *arg)
 {
 	struct channel *ch = arg;
 	struct net_device *dev = ch->netdev;
-	struct ctcm_priv *priv = dev->priv;
+	struct ctcm_priv *priv = dev->ml_priv;
 
 	/*
 	 * Special case: Got UC_RCRESET on setmode.
@@ -874,7 +874,7 @@ static void ctcm_chx_rxiniterr(fsm_instance *fi, int event, void *arg)
 {
 	struct channel *ch = arg;
 	struct net_device *dev = ch->netdev;
-	struct ctcm_priv *priv = dev->priv;
+	struct ctcm_priv *priv = dev->ml_priv;
 
 	if (event == CTC_EVENT_TIMER) {
 		if (!IS_MPCDEV(dev))
@@ -902,7 +902,7 @@ static void ctcm_chx_rxinitfail(fsm_instance *fi, int event, void *arg)
 {
 	struct channel *ch = arg;
 	struct net_device *dev = ch->netdev;
-	struct ctcm_priv *priv = dev->priv;
+	struct ctcm_priv *priv = dev->ml_priv;
 
 	CTCM_DBF_TEXT_(ERROR, CTC_DBF_ERROR,
 			"%s(%s): RX %s busy, init. fail",
@@ -923,7 +923,7 @@ static void ctcm_chx_rxdisc(fsm_instance *fi, int event, void *arg)
 	struct channel *ch = arg;
 	struct channel *ch2;
 	struct net_device *dev = ch->netdev;
-	struct ctcm_priv *priv = dev->priv;
+	struct ctcm_priv *priv = dev->ml_priv;
 
 	CTCM_DBF_TEXT_(TRACE, CTC_DBF_NOTICE,
 			"%s: %s: remote disconnect - re-init ...",
@@ -954,7 +954,7 @@ static void ctcm_chx_txiniterr(fsm_instance *fi, int event, void *arg)
 {
 	struct channel *ch = arg;
 	struct net_device *dev = ch->netdev;
-	struct ctcm_priv *priv = dev->priv;
+	struct ctcm_priv *priv = dev->ml_priv;
 
 	if (event == CTC_EVENT_TIMER) {
 		fsm_deltimer(&ch->timer);
@@ -984,7 +984,7 @@ static void ctcm_chx_txretry(fsm_instance *fi, int event, void *arg)
 {
 	struct channel *ch = arg;
 	struct net_device *dev = ch->netdev;
-	struct ctcm_priv *priv = dev->priv;
+	struct ctcm_priv *priv = dev->ml_priv;
 	struct sk_buff *skb;
 
 	CTCM_PR_DEBUG("Enter: %s: cp=%i ch=0x%p id=%s\n",
@@ -1057,7 +1057,7 @@ static void ctcm_chx_iofatal(fsm_instance *fi, int event, void *arg)
 {
 	struct channel *ch = arg;
 	struct net_device *dev = ch->netdev;
-	struct ctcm_priv *priv = dev->priv;
+	struct ctcm_priv *priv = dev->ml_priv;
 	int rd = CHANNEL_DIRECTION(ch->flags);
 
 	fsm_deltimer(&ch->timer);
@@ -1207,7 +1207,7 @@ static void ctcmpc_chx_txdone(fsm_instance *fi, int event, void *arg)
 {
 	struct channel		*ch = arg;
 	struct net_device	*dev = ch->netdev;
-	struct ctcm_priv	*priv = dev->priv;
+	struct ctcm_priv	*priv = dev->ml_priv;
 	struct mpc_group	*grp = priv->mpcg;
 	struct sk_buff		*skb;
 	int		first = 1;
@@ -1368,7 +1368,7 @@ static void ctcmpc_chx_rx(fsm_instance *fi, int event, void *arg)
 {
 	struct channel		*ch = arg;
 	struct net_device	*dev = ch->netdev;
-	struct ctcm_priv	*priv = dev->priv;
+	struct ctcm_priv	*priv = dev->ml_priv;
 	struct mpc_group	*grp = priv->mpcg;
 	struct sk_buff		*skb = ch->trans_skb;
 	struct sk_buff		*new_skb;
@@ -1471,7 +1471,7 @@ static void ctcmpc_chx_firstio(fsm_instance *fi, int event, void *arg)
 {
 	struct channel		*ch = arg;
 	struct net_device	*dev = ch->netdev;
-	struct ctcm_priv	*priv = dev->priv;
+	struct ctcm_priv	*priv = dev->ml_priv;
 	struct mpc_group	*gptr = priv->mpcg;
 
 	CTCM_PR_DEBUG("Enter %s: id=%s, ch=0x%p\n",
@@ -1525,7 +1525,7 @@ void ctcmpc_chx_rxidle(fsm_instance *fi, int event, void *arg)
 {
 	struct channel *ch = arg;
 	struct net_device *dev = ch->netdev;
-	struct ctcm_priv  *priv = dev->priv;
+	struct ctcm_priv  *priv = dev->ml_priv;
 	struct mpc_group  *grp = priv->mpcg;
 	int rc;
 	unsigned long saveflags = 0;	/* avoids compiler warning */
@@ -1580,7 +1580,7 @@ static void ctcmpc_chx_attn(fsm_instance *fsm, int event, void *arg)
 {
 	struct channel	  *ch     = arg;
 	struct net_device *dev    = ch->netdev;
-	struct ctcm_priv  *priv   = dev->priv;
+	struct ctcm_priv  *priv   = dev->ml_priv;
 	struct mpc_group  *grp = priv->mpcg;
 
 	CTCM_PR_DEBUG("%s(%s): %s(ch=0x%p), cp=%i, ChStat:%s, GrpStat:%s\n",
@@ -1639,7 +1639,7 @@ static void ctcmpc_chx_attnbusy(fsm_instance *fsm, int event, void *arg)
 {
 	struct channel	  *ch     = arg;
 	struct net_device *dev    = ch->netdev;
-	struct ctcm_priv  *priv   = dev->priv;
+	struct ctcm_priv  *priv   = dev->ml_priv;
 	struct mpc_group  *grp    = priv->mpcg;
 
 	CTCM_PR_DEBUG("%s(%s): %s\n  ChState:%s GrpState:%s\n",
@@ -1724,7 +1724,7 @@ static void ctcmpc_chx_resend(fsm_instance *fsm, int event, void *arg)
 {
 	struct channel	   *ch	   = arg;
 	struct net_device  *dev    = ch->netdev;
-	struct ctcm_priv   *priv   = dev->priv;
+	struct ctcm_priv   *priv   = dev->ml_priv;
 	struct mpc_group   *grp    = priv->mpcg;
 
 	fsm_event(grp->fsm, MPCG_EVENT_XID0DO, ch);
@@ -1740,7 +1740,7 @@ static void ctcmpc_chx_send_sweep(fsm_instance *fsm, int event, void *arg)
 {
 	struct channel *ach = arg;
 	struct net_device *dev = ach->netdev;
-	struct ctcm_priv *priv = dev->priv;
+	struct ctcm_priv *priv = dev->ml_priv;
 	struct mpc_group *grp = priv->mpcg;
 	struct channel *wch = priv->channel[WRITE];
 	struct channel *rch = priv->channel[READ];
@@ -2050,7 +2050,7 @@ int mpc_ch_fsm_len = ARRAY_SIZE(ctcmpc_ch_fsm);
 static void dev_action_start(fsm_instance *fi, int event, void *arg)
 {
 	struct net_device *dev = arg;
-	struct ctcm_priv *priv = dev->priv;
+	struct ctcm_priv *priv = dev->ml_priv;
 	int direction;
 
 	CTCMY_DBF_DEV_NAME(SETUP, dev, "");
@@ -2076,7 +2076,7 @@ static void dev_action_stop(fsm_instance *fi, int event, void *arg)
 {
 	int direction;
 	struct net_device *dev = arg;
-	struct ctcm_priv *priv = dev->priv;
+	struct ctcm_priv *priv = dev->ml_priv;
 
 	CTCMY_DBF_DEV_NAME(SETUP, dev, "");
 
@@ -2096,7 +2096,7 @@ static void dev_action_restart(fsm_instance *fi, int event, void *arg)
 {
 	int restart_timer;
 	struct net_device *dev = arg;
-	struct ctcm_priv *priv = dev->priv;
+	struct ctcm_priv *priv = dev->ml_priv;
 
 	CTCMY_DBF_DEV_NAME(TRACE, dev, "");
 
@@ -2133,12 +2133,12 @@ static void dev_action_restart(fsm_instance *fi, int event, void *arg)
 static void dev_action_chup(fsm_instance *fi, int event, void *arg)
 {
 	struct net_device *dev = arg;
-	struct ctcm_priv *priv = dev->priv;
+	struct ctcm_priv *priv = dev->ml_priv;
 	int dev_stat = fsm_getstate(fi);
 
 	CTCM_DBF_TEXT_(SETUP, CTC_DBF_NOTICE,
 			"%s(%s): priv = %p [%d,%d]\n ",	CTCM_FUNTAIL,
-				dev->name, dev->priv, dev_stat, event);
+				dev->name, dev->ml_priv, dev_stat, event);
 
 	switch (fsm_getstate(fi)) {
 	case DEV_STATE_STARTWAIT_RXTX:
@@ -2195,7 +2195,7 @@ static void dev_action_chdown(fsm_instance *fi, int event, void *arg)
 {
 
 	struct net_device *dev = arg;
-	struct ctcm_priv *priv = dev->priv;
+	struct ctcm_priv *priv = dev->ml_priv;
 
 	CTCMY_DBF_DEV_NAME(SETUP, dev, "");
 
diff --git a/drivers/s390/net/ctcm_main.c b/drivers/s390/net/ctcm_main.c
index 126a3eb..b11fec2 100644
--- a/drivers/s390/net/ctcm_main.c
+++ b/drivers/s390/net/ctcm_main.c
@@ -69,7 +69,7 @@ struct channel *channels;
 void ctcm_unpack_skb(struct channel *ch, struct sk_buff *pskb)
 {
 	struct net_device *dev = ch->netdev;
-	struct ctcm_priv *priv = dev->priv;
+	struct ctcm_priv *priv = dev->ml_priv;
 	__u16 len = *((__u16 *) pskb->data);
 
 	skb_put(pskb, 2 + LL_HEADER_LENGTH);
@@ -414,7 +414,7 @@ int ctcm_ch_alloc_buffer(struct channel *ch)
  */
 int ctcm_open(struct net_device *dev)
 {
-	struct ctcm_priv *priv = dev->priv;
+	struct ctcm_priv *priv = dev->ml_priv;
 
 	CTCMY_DBF_DEV_NAME(SETUP, dev, "");
 	if (!IS_MPC(priv))
@@ -432,7 +432,7 @@ int ctcm_open(struct net_device *dev)
  */
 int ctcm_close(struct net_device *dev)
 {
-	struct ctcm_priv *priv = dev->priv;
+	struct ctcm_priv *priv = dev->ml_priv;
 
 	CTCMY_DBF_DEV_NAME(SETUP, dev, "");
 	if (!IS_MPC(priv))
@@ -573,7 +573,7 @@ static int ctcm_transmit_skb(struct channel *ch, struct sk_buff *skb)
 		skb_pull(skb, LL_HEADER_LENGTH + 2);
 	} else if (ccw_idx == 0) {
 		struct net_device *dev = ch->netdev;
-		struct ctcm_priv *priv = dev->priv;
+		struct ctcm_priv *priv = dev->ml_priv;
 		priv->stats.tx_packets++;
 		priv->stats.tx_bytes += skb->len - LL_HEADER_LENGTH;
 	}
@@ -592,7 +592,7 @@ static void ctcmpc_send_sweep_req(struct channel *rch)
 	struct channel *ch;
 	/* int rc = 0; */
 
-	priv = dev->priv;
+	priv = dev->ml_priv;
 	grp = priv->mpcg;
 	ch = priv->channel[WRITE];
 
@@ -652,7 +652,7 @@ static int ctcmpc_transmit_skb(struct channel *ch, struct sk_buff *skb)
 {
 	struct pdu *p_header;
 	struct net_device *dev = ch->netdev;
-	struct ctcm_priv *priv = dev->priv;
+	struct ctcm_priv *priv = dev->ml_priv;
 	struct mpc_group *grp = priv->mpcg;
 	struct th_header *header;
 	struct sk_buff *nskb;
@@ -867,7 +867,7 @@ done:
 /* first merge version - leaving both functions separated */
 static int ctcm_tx(struct sk_buff *skb, struct net_device *dev)
 {
-	struct ctcm_priv *priv = dev->priv;
+	struct ctcm_priv *priv = dev->ml_priv;
 
 	if (skb == NULL) {
 		CTCM_DBF_TEXT_(ERROR, CTC_DBF_ERROR,
@@ -911,7 +911,7 @@ static int ctcm_tx(struct sk_buff *skb, struct net_device *dev)
 static int ctcmpc_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	int len = 0;
-	struct ctcm_priv *priv = dev->priv;
+	struct ctcm_priv *priv = dev->ml_priv;
 	struct mpc_group *grp  = priv->mpcg;
 	struct sk_buff *newskb = NULL;
 
@@ -1025,7 +1025,7 @@ static int ctcm_change_mtu(struct net_device *dev, int new_mtu)
 	if (new_mtu < 576 || new_mtu > 65527)
 		return -EINVAL;
 
-	priv = dev->priv;
+	priv = dev->ml_priv;
 	max_bufsize = priv->channel[READ]->max_bufsize;
 
 	if (IS_MPC(priv)) {
@@ -1050,7 +1050,7 @@ static int ctcm_change_mtu(struct net_device *dev, int new_mtu)
  */
 static struct net_device_stats *ctcm_stats(struct net_device *dev)
 {
-	return &((struct ctcm_priv *)dev->priv)->stats;
+	return &((struct ctcm_priv *)dev->ml_priv)->stats;
 }
 
 static void ctcm_free_netdevice(struct net_device *dev)
@@ -1060,7 +1060,7 @@ static void ctcm_free_netdevice(struct net_device *dev)
 
 	CTCM_DBF_TEXT_(SETUP, CTC_DBF_INFO,
 			"%s(%s)", CTCM_FUNTAIL, dev->name);
-	priv = dev->priv;
+	priv = dev->ml_priv;
 	if (priv) {
 		grp = priv->mpcg;
 		if (grp) {
@@ -1125,7 +1125,7 @@ static struct net_device *ctcm_init_netdevice(struct ctcm_priv *priv)
 			CTCM_FUNTAIL);
 		return NULL;
 	}
-	dev->priv = priv;
+	dev->ml_priv = priv;
 	priv->fsm = init_fsm("ctcmdev", dev_state_names, dev_event_names,
 				CTCM_NR_DEV_STATES, CTCM_NR_DEV_EVENTS,
 				dev_fsm, dev_fsm_len, GFP_KERNEL);
diff --git a/drivers/s390/net/ctcm_main.h b/drivers/s390/net/ctcm_main.h
index a72e0fe..8e10ee8 100644
--- a/drivers/s390/net/ctcm_main.h
+++ b/drivers/s390/net/ctcm_main.h
@@ -229,14 +229,14 @@ void ctcm_remove_files(struct device *dev);
  */
 static inline void ctcm_clear_busy_do(struct net_device *dev)
 {
-	clear_bit(0, &(((struct ctcm_priv *)dev->priv)->tbusy));
+	clear_bit(0, &(((struct ctcm_priv *)dev->ml_priv)->tbusy));
 	netif_wake_queue(dev);
 }
 
 static inline void ctcm_clear_busy(struct net_device *dev)
 {
 	struct mpc_group *grp;
-	grp = ((struct ctcm_priv *)dev->priv)->mpcg;
+	grp = ((struct ctcm_priv *)dev->ml_priv)->mpcg;
 
 	if (!(grp && grp->in_sweep))
 		ctcm_clear_busy_do(dev);
@@ -246,7 +246,8 @@ static inline void ctcm_clear_busy(struct net_device *dev)
 static inline int ctcm_test_and_set_busy(struct net_device *dev)
 {
 	netif_stop_queue(dev);
-	return test_and_set_bit(0, &(((struct ctcm_priv *)dev->priv)->tbusy));
+	return test_and_set_bit(0,
+			&(((struct ctcm_priv *)dev->ml_priv)->tbusy));
 }
 
 extern int loglevel;
@@ -292,7 +293,7 @@ struct mpc_group *ctcmpc_init_mpc_group(struct ctcm_priv *priv);
 #define IS_MPC(p) ((p)->protocol == CTCM_PROTO_MPC)
 
 /* test if struct ctcm_priv of struct net_device has MPC protocol setting */
-#define IS_MPCDEV(d) IS_MPC((struct ctcm_priv *)d->priv)
+#define IS_MPCDEV(dev) IS_MPC((struct ctcm_priv *)dev->ml_priv)
 
 static inline gfp_t gfp_type(void)
 {
diff --git a/drivers/s390/net/ctcm_mpc.c b/drivers/s390/net/ctcm_mpc.c
index 49ae1cd..407f816 100644
--- a/drivers/s390/net/ctcm_mpc.c
+++ b/drivers/s390/net/ctcm_mpc.c
@@ -313,10 +313,10 @@ static struct net_device *ctcmpc_get_dev(int port_num)
 					CTCM_FUNTAIL, device);
 		return NULL;
 	}
-	priv = dev->priv;
+	priv = dev->ml_priv;
 	if (priv == NULL) {
 		CTCM_DBF_TEXT_(MPC_ERROR, CTC_DBF_ERROR,
-			"%s(%s): dev->priv is NULL",
+			"%s(%s): dev->ml_priv is NULL",
 					CTCM_FUNTAIL, device);
 		return NULL;
 	}
@@ -345,7 +345,7 @@ int ctc_mpc_alloc_channel(int port_num, void (*callback)(int, int))
 	dev = ctcmpc_get_dev(port_num);
 	if (dev == NULL)
 		return 1;
-	priv = dev->priv;
+	priv = dev->ml_priv;
 	grp = priv->mpcg;
 
 	grp->allochanfunc = callback;
@@ -417,7 +417,7 @@ void ctc_mpc_establish_connectivity(int port_num,
 	dev = ctcmpc_get_dev(port_num);
 	if (dev == NULL)
 		return;
-	priv = dev->priv;
+	priv = dev->ml_priv;
 	grp = priv->mpcg;
 	rch = priv->channel[READ];
 	wch = priv->channel[WRITE];
@@ -535,7 +535,7 @@ void ctc_mpc_dealloc_ch(int port_num)
 	dev = ctcmpc_get_dev(port_num);
 	if (dev == NULL)
 		return;
-	priv = dev->priv;
+	priv = dev->ml_priv;
 	grp = priv->mpcg;
 
 	CTCM_DBF_TEXT_(MPC_SETUP, CTC_DBF_DEBUG,
@@ -571,7 +571,7 @@ void ctc_mpc_flow_control(int port_num, int flowc)
 	dev = ctcmpc_get_dev(port_num);
 	if (dev == NULL)
 		return;
-	priv = dev->priv;
+	priv = dev->ml_priv;
 	grp = priv->mpcg;
 
 	CTCM_DBF_TEXT_(MPC_TRACE, CTC_DBF_DEBUG,
@@ -620,7 +620,7 @@ static void mpc_rcvd_sweep_resp(struct mpcg_info *mpcginfo)
 {
 	struct channel	  *rch = mpcginfo->ch;
 	struct net_device *dev = rch->netdev;
-	struct ctcm_priv   *priv = dev->priv;
+	struct ctcm_priv   *priv = dev->ml_priv;
 	struct mpc_group  *grp = priv->mpcg;
 	struct channel	  *ch = priv->channel[WRITE];
 
@@ -651,7 +651,7 @@ static void mpc_rcvd_sweep_resp(struct mpcg_info *mpcginfo)
 static void ctcmpc_send_sweep_resp(struct channel *rch)
 {
 	struct net_device *dev = rch->netdev;
-	struct ctcm_priv *priv = dev->priv;
+	struct ctcm_priv *priv = dev->ml_priv;
 	struct mpc_group *grp = priv->mpcg;
 	int rc = 0;
 	struct th_sweep *header;
@@ -713,7 +713,7 @@ static void mpc_rcvd_sweep_req(struct mpcg_info *mpcginfo)
 {
 	struct channel	  *rch     = mpcginfo->ch;
 	struct net_device *dev     = rch->netdev;
-	struct ctcm_priv  *priv = dev->priv;
+	struct ctcm_priv  *priv = dev->ml_priv;
 	struct mpc_group  *grp  = priv->mpcg;
 	struct channel	  *ch	   = priv->channel[WRITE];
 
@@ -847,7 +847,7 @@ static int mpcg_fsm_len = ARRAY_SIZE(mpcg_fsm);
 static void mpc_action_go_ready(fsm_instance *fsm, int event, void *arg)
 {
 	struct net_device *dev = arg;
-	struct ctcm_priv *priv = dev->priv;
+	struct ctcm_priv *priv = dev->ml_priv;
 	struct mpc_group *grp = priv->mpcg;
 
 	if (grp == NULL) {
@@ -891,7 +891,7 @@ static void mpc_action_go_ready(fsm_instance *fsm, int event, void *arg)
 void mpc_group_ready(unsigned long adev)
 {
 	struct net_device *dev = (struct net_device *)adev;
-	struct ctcm_priv *priv = dev->priv;
+	struct ctcm_priv *priv = dev->ml_priv;
 	struct mpc_group *grp = priv->mpcg;
 	struct channel *ch = NULL;
 
@@ -947,7 +947,7 @@ void mpc_group_ready(unsigned long adev)
 void mpc_channel_action(struct channel *ch, int direction, int action)
 {
 	struct net_device  *dev  = ch->netdev;
-	struct ctcm_priv   *priv = dev->priv;
+	struct ctcm_priv   *priv = dev->ml_priv;
 	struct mpc_group   *grp  = priv->mpcg;
 
 	if (grp == NULL) {
@@ -1057,7 +1057,7 @@ done:
 static void ctcmpc_unpack_skb(struct channel *ch, struct sk_buff *pskb)
 {
 	struct net_device *dev	= ch->netdev;
-	struct ctcm_priv *priv = dev->priv;
+	struct ctcm_priv *priv = dev->ml_priv;
 	struct mpc_group *grp = priv->mpcg;
 	struct pdu *curr_pdu;
 	struct mpcg_info *mpcginfo;
@@ -1255,7 +1255,7 @@ void ctcmpc_bh(unsigned long thischan)
 	struct channel	  *ch	= (struct channel *)thischan;
 	struct sk_buff	  *skb;
 	struct net_device *dev	= ch->netdev;
-	struct ctcm_priv  *priv	= dev->priv;
+	struct ctcm_priv  *priv	= dev->ml_priv;
 	struct mpc_group  *grp	= priv->mpcg;
 
 	CTCM_PR_DEBUG("%s cp:%i enter:  %s() %s\n",
@@ -1377,7 +1377,7 @@ static void mpc_action_go_inop(fsm_instance *fi, int event, void *arg)
 	BUG_ON(dev == NULL);
 	CTCM_PR_DEBUG("Enter %s: %s\n",	__func__, dev->name);
 
-	priv  = dev->priv;
+	priv  = dev->ml_priv;
 	grp =  priv->mpcg;
 	grp->flow_off_called = 0;
 	fsm_deltimer(&grp->timer);
@@ -1483,7 +1483,7 @@ static void mpc_action_timeout(fsm_instance *fi, int event, void *arg)
 
 	BUG_ON(dev == NULL);
 
-	priv = dev->priv;
+	priv = dev->ml_priv;
 	grp = priv->mpcg;
 	wch = priv->channel[WRITE];
 	rch = priv->channel[READ];
@@ -1521,7 +1521,7 @@ void mpc_action_discontact(fsm_instance *fi, int event, void *arg)
 	if (ch) {
 		dev = ch->netdev;
 		if (dev) {
-			priv = dev->priv;
+			priv = dev->ml_priv;
 			if (priv) {
 				CTCM_DBF_TEXT_(MPC_TRACE, CTC_DBF_NOTICE,
 					"%s: %s: %s\n",
@@ -1569,7 +1569,7 @@ static int mpc_validate_xid(struct mpcg_info *mpcginfo)
 {
 	struct channel	   *ch	 = mpcginfo->ch;
 	struct net_device  *dev  = ch->netdev;
-	struct ctcm_priv   *priv = dev->priv;
+	struct ctcm_priv   *priv = dev->ml_priv;
 	struct mpc_group   *grp  = priv->mpcg;
 	struct xid2	   *xid  = mpcginfo->xid;
 	int	rc	 = 0;
@@ -1866,7 +1866,7 @@ static void mpc_action_doxid0(fsm_instance *fsm, int event, void *arg)
 {
 	struct channel	   *ch   = arg;
 	struct net_device  *dev  = ch->netdev;
-	struct ctcm_priv   *priv = dev->priv;
+	struct ctcm_priv   *priv = dev->ml_priv;
 	struct mpc_group   *grp  = priv->mpcg;
 
 	CTCM_PR_DEBUG("Enter %s: cp=%i ch=0x%p id=%s\n",
@@ -1906,7 +1906,7 @@ static void mpc_action_doxid0(fsm_instance *fsm, int event, void *arg)
 static void mpc_action_doxid7(fsm_instance *fsm, int event, void *arg)
 {
 	struct net_device *dev = arg;
-	struct ctcm_priv  *priv = dev->priv;
+	struct ctcm_priv  *priv = dev->ml_priv;
 	struct mpc_group  *grp  = NULL;
 	int direction;
 	int send = 0;
@@ -1983,7 +1983,7 @@ static void mpc_action_rcvd_xid0(fsm_instance *fsm, int event, void *arg)
 	struct mpcg_info   *mpcginfo  = arg;
 	struct channel	   *ch   = mpcginfo->ch;
 	struct net_device  *dev  = ch->netdev;
-	struct ctcm_priv   *priv = dev->priv;
+	struct ctcm_priv   *priv = dev->ml_priv;
 	struct mpc_group   *grp  = priv->mpcg;
 
 	CTCM_PR_DEBUG("%s: ch-id:%s xid2:%i xid7:%i xidt_p2:%i \n",
@@ -2045,7 +2045,7 @@ static void mpc_action_rcvd_xid7(fsm_instance *fsm, int event, void *arg)
 	struct mpcg_info   *mpcginfo   = arg;
 	struct channel	   *ch	       = mpcginfo->ch;
 	struct net_device  *dev        = ch->netdev;
-	struct ctcm_priv   *priv    = dev->priv;
+	struct ctcm_priv   *priv    = dev->ml_priv;
 	struct mpc_group   *grp     = priv->mpcg;
 
 	CTCM_PR_DEBUG("Enter %s: cp=%i ch=0x%p id=%s\n",
@@ -2097,7 +2097,7 @@ static int mpc_send_qllc_discontact(struct net_device *dev)
 	__u32	new_len	= 0;
 	struct sk_buff   *skb;
 	struct qllc      *qllcptr;
-	struct ctcm_priv *priv = dev->priv;
+	struct ctcm_priv *priv = dev->ml_priv;
 	struct mpc_group *grp = priv->mpcg;
 
 	CTCM_PR_DEBUG("%s: GROUP STATE: %s\n",
diff --git a/drivers/s390/net/lcs.c b/drivers/s390/net/lcs.c
index 6de2838..9bcfa04 100644
--- a/drivers/s390/net/lcs.c
+++ b/drivers/s390/net/lcs.c
@@ -1412,7 +1412,8 @@ lcs_irq(struct ccw_device *cdev, unsigned long intparm, struct irb *irb)
 	}
 	/* How far in the ccw chain have we processed? */
 	if ((channel->state != LCS_CH_STATE_INIT) &&
-	    (irb->scsw.cmd.fctl & SCSW_FCTL_START_FUNC)) {
+	    (irb->scsw.cmd.fctl & SCSW_FCTL_START_FUNC) &&
+	    (irb->scsw.cmd.cpa != 0)) {
 		index = (struct ccw1 *) __va((addr_t) irb->scsw.cmd.cpa)
 			- channel->ccws;
 		if ((irb->scsw.cmd.actl & SCSW_ACTL_SUSPENDED) ||
diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 80971c2..bf8a75c 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -689,6 +689,7 @@ struct qeth_mc_mac {
 	struct list_head list;
 	__u8 mc_addr[MAX_ADDR_LEN];
 	unsigned char mc_addrlen;
+	int is_vmac;
 };
 
 struct qeth_card {
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index bd420d1..c7ab1b8 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -3024,7 +3024,7 @@ static inline void __qeth_fill_buffer(struct sk_buff *skb,
 	struct qdio_buffer *buffer, int is_tso, int *next_element_to_fill,
 	int offset)
 {
-	int length = skb->len;
+	int length = skb->len - offset;
 	int length_here;
 	int element;
 	char *data;
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index b3cee03..3ac3cc1 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -177,9 +177,10 @@ static int qeth_l2_send_delgroupmac(struct qeth_card *card, __u8 *mac)
 					  qeth_l2_send_delgroupmac_cb);
 }
 
-static void qeth_l2_add_mc(struct qeth_card *card, __u8 *mac)
+static void qeth_l2_add_mc(struct qeth_card *card, __u8 *mac, int vmac)
 {
 	struct qeth_mc_mac *mc;
+	int rc;
 
 	mc = kmalloc(sizeof(struct qeth_mc_mac), GFP_ATOMIC);
 
@@ -188,8 +189,16 @@ static void qeth_l2_add_mc(struct qeth_card *card, __u8 *mac)
 
 	memcpy(mc->mc_addr, mac, OSA_ADDR_LEN);
 	mc->mc_addrlen = OSA_ADDR_LEN;
+	mc->is_vmac = vmac;
+
+	if (vmac) {
+		rc = qeth_l2_send_setdelmac(card, mac, IPA_CMD_SETVMAC,
+					NULL);
+	} else {
+		rc = qeth_l2_send_setgroupmac(card, mac);
+	}
 
-	if (!qeth_l2_send_setgroupmac(card, mac))
+	if (!rc)
 		list_add_tail(&mc->list, &card->mc_list);
 	else
 		kfree(mc);
@@ -201,7 +210,11 @@ static void qeth_l2_del_all_mc(struct qeth_card *card)
 
 	spin_lock_bh(&card->mclock);
 	list_for_each_entry_safe(mc, tmp, &card->mc_list, list) {
-		qeth_l2_send_delgroupmac(card, mc->mc_addr);
+		if (mc->is_vmac)
+			qeth_l2_send_setdelmac(card, mc->mc_addr,
+					IPA_CMD_DELVMAC, NULL);
+		else
+			qeth_l2_send_delgroupmac(card, mc->mc_addr);
 		list_del(&mc->list);
 		kfree(mc);
 	}
@@ -590,7 +603,7 @@ static int qeth_l2_set_mac_address(struct net_device *dev, void *p)
 static void qeth_l2_set_multicast_list(struct net_device *dev)
 {
 	struct qeth_card *card = dev->ml_priv;
-	struct dev_mc_list *dm;
+	struct dev_addr_list *dm;
 
 	if (card->info.type == QETH_CARD_TYPE_OSN)
 		return ;
@@ -599,7 +612,11 @@ static void qeth_l2_set_multicast_list(struct net_device *dev)
 	qeth_l2_del_all_mc(card);
 	spin_lock_bh(&card->mclock);
 	for (dm = dev->mc_list; dm; dm = dm->next)
-		qeth_l2_add_mc(card, dm->dmi_addr);
+		qeth_l2_add_mc(card, dm->da_addr, 0);
+
+	for (dm = dev->uc_list; dm; dm = dm->next)
+		qeth_l2_add_mc(card, dm->da_addr, 1);
+
 	spin_unlock_bh(&card->mclock);
 	if (!qeth_adp_supported(card, IPA_SETADP_SET_PROMISC_MODE))
 		return;
diff --git a/drivers/s390/net/qeth_l3_sys.c b/drivers/s390/net/qeth_l3_sys.c
index ac19937..210ddb6 100644
--- a/drivers/s390/net/qeth_l3_sys.c
+++ b/drivers/s390/net/qeth_l3_sys.c
@@ -136,7 +136,7 @@ static ssize_t qeth_l3_dev_route6_store(struct device *dev,
 		return -EINVAL;
 
 	if (!qeth_is_supported(card, IPA_IPV6)) {
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 	}
 
 	return qeth_l3_dev_route_store(card, &card->options.route6,
