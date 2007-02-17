Return-Path: <linux-kernel-owner+w=401wt.eu-S2992770AbXBQWRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992770AbXBQWRd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 17:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992768AbXBQWRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 17:17:32 -0500
Received: from havoc.gtf.org ([69.61.125.42]:34361 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992766AbXBQWR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 17:17:26 -0500
Date: Sat, 17 Feb 2007 17:17:25 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] net driver updates
Message-ID: <20070217221725.GA30619@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly fixes, a few cleanups. nothing really notable.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git upstream-linus

to receive the following updates:

 MAINTAINERS                                 |    4 +-
 drivers/atm/he.c                            |    2 +-
 drivers/atm/idt77252.c                      |    8 +-
 drivers/atm/nicstarmac.c                    |    4 +-
 drivers/net/Kconfig                         |   14 ++-
 drivers/net/arcnet/arc-rawmode.c            |    4 +-
 drivers/net/arcnet/arcnet.c                 |    2 +-
 drivers/net/arcnet/com20020-pci.c           |    3 +
 drivers/net/arcnet/com20020.c               |    2 +-
 drivers/net/atl1/atl1_hw.c                  |   37 ++++---
 drivers/net/atl1/atl1_main.c                |    5 +-
 drivers/net/b44.c                           |   19 ++--
 drivers/net/cxgb3/cxgb3_defs.h              |    1 -
 drivers/net/cxgb3/cxgb3_offload.c           |    1 -
 drivers/net/cxgb3/cxgb3_offload.h           |    1 -
 drivers/net/cxgb3/l2t.c                     |    1 -
 drivers/net/cxgb3/l2t.h                     |    1 -
 drivers/net/cxgb3/t3cdev.h                  |    1 -
 drivers/net/e1000/e1000.h                   |    1 -
 drivers/net/e1000/e1000_ethtool.c           |    2 +-
 drivers/net/e1000/e1000_main.c              |   70 ++----------
 drivers/net/ehea/ehea.h                     |    2 +-
 drivers/net/ehea/ehea_main.c                |    8 +-
 drivers/net/ehea/ehea_phyp.c                |   10 ++
 drivers/net/ehea/ehea_phyp.h                |    3 +
 drivers/net/ehea/ehea_qmr.c                 |   42 +++++++
 drivers/net/ehea/ehea_qmr.h                 |    5 +
 drivers/net/gianfar.c                       |   85 +++-----------
 drivers/net/gianfar_sysfs.c                 |  108 +++++++++--------
 drivers/net/ioc3-eth.c                      |   16 ++-
 drivers/net/macb.c                          |   24 +----
 drivers/net/meth.c                          |   26 ++--
 drivers/net/netxen/netxen_nic.h             |    9 +-
 drivers/net/netxen/netxen_nic_ethtool.c     |    9 +-
 drivers/net/netxen/netxen_nic_hw.c          |    2 +
 drivers/net/netxen/netxen_nic_init.c        |   12 ++-
 drivers/net/netxen/netxen_nic_main.c        |    3 +-
 drivers/net/netxen/netxen_nic_niu.c         |    2 +-
 drivers/net/pcmcia/3c574_cs.c               |    2 +-
 drivers/net/pcmcia/smc91c92_cs.c            |    2 +-
 drivers/net/phy/marvell.c                   |  156 ++++++++++++++++++++++--
 drivers/net/phy/phy_device.c                |    4 +-
 drivers/net/sk98lin/skge.c                  |    3 +
 drivers/net/sky2.c                          |  125 +++++++++++++-------
 drivers/net/sky2.h                          |    3 +-
 drivers/net/wan/Kconfig                     |    2 +-
 drivers/net/wan/pc300too.c                  |    2 +-
 drivers/net/wireless/bcm43xx/bcm43xx.h      |    1 +
 drivers/net/wireless/bcm43xx/bcm43xx_dma.c  |  171 +++++++++++++++++++--------
 drivers/net/wireless/bcm43xx/bcm43xx_main.c |   25 +++--
 drivers/net/wireless/bcm43xx/bcm43xx_wx.c   |   28 ++--
 drivers/net/wireless/ipw2100.c              |   16 ++--
 drivers/net/wireless/zd1211rw/zd_mac.c      |   44 ++++++--
 drivers/net/wireless/zd1211rw/zd_usb.c      |   12 ++
 include/linux/pci_ids.h                     |    1 +
 net/core/net-sysfs.c                        |    4 +-
 net/ieee80211/ieee80211_tx.c                |    3 -
 57 files changed, 706 insertions(+), 447 deletions(-)

Ahmed S. Darwish (1):
      atm: Use ARRAY_SIZE macro when appropriate

Al Viro (1):
      atl1: fix bad ioread address

Amit S. Kale (3):
      NetXen: Fixes for ppc architecture.
      NetXen: Updates for ethtool support
      NetXen: Fix to get the driver working after sparse changes

Andy Fleming (1):
      phylib: Add support for Marvell 88e1111S and 88e1145

Baruch Even (1):
      Hostess SV-11 depends on INET

Chris Snook (2):
      atl1: remove unused define
      atl1: add L1 device id to pci_ids, then use it

Daniel Drake (2):
      zd1211rw: Remove noisy debug message
      sk98lin: mark deprecated in Kconfig

Gary Zambrano (2):
      b44: replace define
      B44: increase wait loop

Haavard Skinnemoen (1):
      macb: Remove inappropriate spinlocks around mii calls

Jan-Bernd Themann (1):
      ehea: Fixed error recovery

Jay Cliburn (3):
      atl1: drop NET_PCI from Kconfig
      atl1: read MAC address from register
      atl1: bump version number

Jeff Morrow (1):
      bugfixes and new hardware support for arcnet driver

Kok, Auke (3):
      e1000: fix shared interrupt warning message
      e1000: remove obsolete custom pci_save_state code
      e1000: allow ethtool to see link status when down

Komuro (1):
      PCMCIA-NETDEV : the 2nd argument of el3_interrrupt and smc_interrupt is struct net_device*

Kumar Gala (1):
      Convert network devices to use struct device instead of class_device

Larry Finger (5):
      bcm43xx: Fix problem with >1 GB RAM
      bcm43xx: Fix scaling error for 'iwlist rate' information
      bcm43xx: Fix scaling error for 'iwlist freq' information
      bcm43xx: Check error returns in initialization routines
      ieee80211: Fix sparse warning

Maxime Austruy (1):
      zd1211rw: fix potential leak in usb_init

Michael Buesch (1):
      bcm43xx: Enable fwpostfix in nondebug bcm43xx

pcnet32@verizon.net (2):
      MAINTAINER
      pcnet32 NAPI no longer experimental

Ralf Baechle (2):
      Convert meth to netdev_priv
      Fix link autonegotiation timer.

Randy Dunlap (1):
      phy devices: use same arg types

Richard Knutsson (1):
      net/wan/pc300too.c: pci_module_init to pci_register_driver

Robert P. J. Day (2):
      Rename IPW2100 debugging macros to not look like config options.
      Replace incorrect macro name "WIRELESS_EXT" with "CONFIG_WIRELESS_EXT"

Sergei Shtylyov (1):
      gianfar: don't duplicate gfar_error()

Stephen Hemminger (7):
      sky2: dont flush good pause frames
      sky2: no need to reset pause bits on shutdown
      sky2: flow control negotiation for Yukon-FE
      sky2: transmit timeout
      sky2: receive error handling improvements
      sky2: v1.13
      sk98lin: planned removal

Steve Wise (1):
      cxgb3 Fix copyrights in the cxgb3 driver.

Ulrich Kunitz (3):
      zd1211rw: Reset device in the probe call
      zd1211rw: Fixed array size issue in reset_mode
      zd1211rw: Added error stats update

diff --git a/MAINTAINERS b/MAINTAINERS
index b0fd71b..c0f9a1a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2623,8 +2623,8 @@ T:	git kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
 S:	Maintained
 
 PCNET32 NETWORK DRIVER
-P:	Thomas Bogendörfer
-M:	tsbogend@alpha.franken.de
+P:	Don Fry
+M:	pcnet32@verizon.net
 L:	netdev@vger.kernel.org
 S:	Maintained
 
diff --git a/drivers/atm/he.c b/drivers/atm/he.c
index db33f6f..8510026 100644
--- a/drivers/atm/he.c
+++ b/drivers/atm/he.c
@@ -3017,7 +3017,7 @@ read_prom_byte(struct he_dev *he_dev, int addr)
 	he_writel(he_dev, val, HOST_CNTL);
        
 	/* Send READ instruction */
-	for (i = 0; i < sizeof(readtab)/sizeof(readtab[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(readtab); i++) {
 		he_writel(he_dev, val | readtab[i], HOST_CNTL);
 		udelay(EEPROM_DELAY);
 	}
diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index f407861..b4b8014 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -388,7 +388,7 @@ idt77252_eeprom_read_status(struct idt77252_dev *card)
 
 	gp = idt77252_read_gp(card) & ~(SAR_GP_EESCLK|SAR_GP_EECS|SAR_GP_EEDO);
 
-	for (i = 0; i < sizeof(rdsrtab)/sizeof(rdsrtab[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(rdsrtab); i++) {
 		idt77252_write_gp(card, gp | rdsrtab[i]);
 		udelay(5);
 	}
@@ -422,7 +422,7 @@ idt77252_eeprom_read_byte(struct idt77252_dev *card, u8 offset)
 
 	gp = idt77252_read_gp(card) & ~(SAR_GP_EESCLK|SAR_GP_EECS|SAR_GP_EEDO);
 
-	for (i = 0; i < sizeof(rdtab)/sizeof(rdtab[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(rdtab); i++) {
 		idt77252_write_gp(card, gp | rdtab[i]);
 		udelay(5);
 	}
@@ -469,14 +469,14 @@ idt77252_eeprom_write_byte(struct idt77252_dev *card, u8 offset, u8 data)
 
 	gp = idt77252_read_gp(card) & ~(SAR_GP_EESCLK|SAR_GP_EECS|SAR_GP_EEDO);
 
-	for (i = 0; i < sizeof(wrentab)/sizeof(wrentab[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(wrentab); i++) {
 		idt77252_write_gp(card, gp | wrentab[i]);
 		udelay(5);
 	}
 	idt77252_write_gp(card, gp | SAR_GP_EECS);
 	udelay(5);
 
-	for (i = 0; i < sizeof(wrtab)/sizeof(wrtab[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(wrtab); i++) {
 		idt77252_write_gp(card, gp | wrtab[i]);
 		udelay(5);
 	}
diff --git a/drivers/atm/nicstarmac.c b/drivers/atm/nicstarmac.c
index 2c5e3ae..480947f 100644
--- a/drivers/atm/nicstarmac.c
+++ b/drivers/atm/nicstarmac.c
@@ -7,6 +7,8 @@
  * Read this ForeRunner's MAC address from eprom/eeprom
  */
 
+#include <linux/kernel.h>
+
 typedef void __iomem *virt_addr_t;
 
 #define CYCLE_DELAY 5
@@ -176,7 +178,7 @@ read_eprom_byte(virt_addr_t base, u_int8_t offset)
    val = NICSTAR_REG_READ( base, NICSTAR_REG_GENERAL_PURPOSE ) & 0xFFFFFFF0;
 
    /* Send READ instruction */
-   for (i=0; i<sizeof readtab/sizeof readtab[0]; i++)
+   for (i=0; i<ARRAY_SIZE(readtab); i++)
    {
 	NICSTAR_REG_WRITE( base, NICSTAR_REG_GENERAL_PURPOSE,
 		(val | readtab[i]) );
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 38f41a5..d9400ef 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -1284,8 +1284,8 @@ config PCNET32
 	  will be called pcnet32.
 
 config PCNET32_NAPI
-	bool "Use RX polling (NAPI) (EXPERIMENTAL)"
-	depends on PCNET32 && EXPERIMENTAL
+	bool "Use RX polling (NAPI)"
+	depends on PCNET32
 	help
 	  NAPI is a new driver API designed to reduce CPU and interrupt load
 	  when the driver is receiving lots of packets from the card. It is
@@ -2125,14 +2125,16 @@ config SKY2
 	  will be called sky2.  This is recommended.
 
 config SK98LIN
-	tristate "Marvell Yukon Chipset / SysKonnect SK-98xx Support"
+	tristate "Marvell Yukon Chipset / SysKonnect SK-98xx Support (DEPRECATED)"
 	depends on PCI
 	---help---
 	  Say Y here if you have a Marvell Yukon or SysKonnect SK-98xx/SK-95xx
 	  compliant Gigabit Ethernet Adapter.
 
-	  This driver supports the original Yukon chipset. A cleaner driver is 
-	  also available (skge) which seems to work better than this one.
+	  This driver supports the original Yukon chipset. This driver is
+	  deprecated and will be removed from the kernel in the near future,
+	  it has been replaced by the skge driver. skge is cleaner and
+	  seems to work better.
 
 	  This driver does not support the newer Yukon2 chipset. A separate
 	  driver, sky2, is provided to support Yukon2-based adapters.
@@ -2337,7 +2339,7 @@ config QLA3XXX
 
 config ATL1
 	tristate "Attansic L1 Gigabit Ethernet support (EXPERIMENTAL)"
-	depends on NET_PCI && PCI && EXPERIMENTAL
+	depends on PCI && EXPERIMENTAL
 	select CRC32
 	select MII
 	help
diff --git a/drivers/net/arcnet/arc-rawmode.c b/drivers/net/arcnet/arc-rawmode.c
index e7555d4..6318814 100644
--- a/drivers/net/arcnet/arc-rawmode.c
+++ b/drivers/net/arcnet/arc-rawmode.c
@@ -94,7 +94,7 @@ static void rx(struct net_device *dev, int bufnum,
 
 	BUGMSG(D_DURING, "it's a raw packet (length=%d)\n", length);
 
-	if (length >= MinTU)
+	if (length > MTU)
 		ofs = 512 - length;
 	else
 		ofs = 256 - length;
@@ -183,7 +183,7 @@ static int prepare_tx(struct net_device *dev, struct archdr *pkt, int length,
 		       length, XMTU);
 		length = XMTU;
 	}
-	if (length > MinTU) {
+	if (length >= MinTU) {
 		hard->offset[0] = 0;
 		hard->offset[1] = ofs = 512 - length;
 	} else if (length > MTU) {
diff --git a/drivers/net/arcnet/arcnet.c b/drivers/net/arcnet/arcnet.c
index 4e91dab..83004fd 100644
--- a/drivers/net/arcnet/arcnet.c
+++ b/drivers/net/arcnet/arcnet.c
@@ -41,7 +41,7 @@
  *     <jojo@repas.de>
  */
 
-#define VERSION "arcnet: v3.93 BETA 2000/04/29 - by Avery Pennarun et al.\n"
+#define VERSION "arcnet: v3.94 BETA 2007/02/08 - by Avery Pennarun et al.\n"
 
 #include <linux/module.h>
 #include <linux/types.h>
diff --git a/drivers/net/arcnet/com20020-pci.c b/drivers/net/arcnet/com20020-pci.c
index 98d326b..b8c0fa6 100644
--- a/drivers/net/arcnet/com20020-pci.c
+++ b/drivers/net/arcnet/com20020-pci.c
@@ -155,6 +155,7 @@ static struct pci_device_id com20020pci_id_table[] = {
 	{ 0x1571, 0xa00b, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ARC_IS_5MBIT },
 	{ 0x1571, 0xa00c, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ARC_IS_5MBIT },
 	{ 0x1571, 0xa00d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ARC_IS_5MBIT },
+	{ 0x1571, 0xa00e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ARC_IS_5MBIT },
 	{ 0x1571, 0xa201, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ARC_CAN_10MBIT },
 	{ 0x1571, 0xa202, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ARC_CAN_10MBIT },
 	{ 0x1571, 0xa203, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ARC_CAN_10MBIT },
@@ -163,6 +164,8 @@ static struct pci_device_id com20020pci_id_table[] = {
 	{ 0x1571, 0xa206, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ARC_CAN_10MBIT },
 	{ 0x10B5, 0x9030, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ARC_CAN_10MBIT },
 	{ 0x10B5, 0x9050, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ARC_CAN_10MBIT },
+	{ 0x14BA, 0x6000, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ARC_CAN_10MBIT },
+	{ 0x10B5, 0x2200, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ARC_CAN_10MBIT },
 	{0,}
 };
 
diff --git a/drivers/net/arcnet/com20020.c b/drivers/net/arcnet/com20020.c
index 4218075..7cf0a25 100644
--- a/drivers/net/arcnet/com20020.c
+++ b/drivers/net/arcnet/com20020.c
@@ -104,7 +104,7 @@ int com20020_check(struct net_device *dev)
 	SET_SUBADR(SUB_SETUP1);
 	outb(lp->setup, _XREG);
 
-	if (lp->card_flags & ARC_CAN_10MBIT)
+	if (lp->clockm != 0)
 	{
 		SET_SUBADR(SUB_SETUP2);
 		outb(lp->setup2, _XREG);
diff --git a/drivers/net/atl1/atl1_hw.c b/drivers/net/atl1/atl1_hw.c
index 08b2d78..314dbaa 100644
--- a/drivers/net/atl1/atl1_hw.c
+++ b/drivers/net/atl1/atl1_hw.c
@@ -243,14 +243,8 @@ static int atl1_get_permanent_address(struct atl1_hw *hw)
 			i += 4;
 		}
 
-/*
- * The following 2 lines are the Attansic originals.  Saving for posterity.
- *		*(u32 *) & eth_addr[2] = LONGSWAP(addr[0]);
- *		*(u16 *) & eth_addr[0] = SHORTSWAP(*(u16 *) & addr[1]);
- */
-		*(u32 *) & eth_addr[2] = swab32(addr[0]);
-		*(u16 *) & eth_addr[0] = swab16(*(u16 *) & addr[1]);
-
+		*(u32 *) &eth_addr[2] = swab32(addr[0]);
+		*(u16 *) &eth_addr[0] = swab16(*(u16 *) &addr[1]);
 		if (is_valid_ether_addr(eth_addr)) {
 			memcpy(hw->perm_mac_addr, eth_addr, ETH_ALEN);
 			return 0;
@@ -281,17 +275,28 @@ static int atl1_get_permanent_address(struct atl1_hw *hw)
 		i += 4;
 	}
 
-/*
- * The following 2 lines are the Attansic originals.  Saving for posterity.
- *	*(u32 *) & eth_addr[2] = LONGSWAP(addr[0]);
- *	*(u16 *) & eth_addr[0] = SHORTSWAP(*(u16 *) & addr[1]);
- */
-	*(u32 *) & eth_addr[2] = swab32(addr[0]);
-	*(u16 *) & eth_addr[0] = swab16(*(u16 *) & addr[1]);
+	*(u32 *) &eth_addr[2] = swab32(addr[0]);
+	*(u16 *) &eth_addr[0] = swab16(*(u16 *) &addr[1]);
 	if (is_valid_ether_addr(eth_addr)) {
 		memcpy(hw->perm_mac_addr, eth_addr, ETH_ALEN);
 		return 0;
 	}
+
+	/*
+	 * On some motherboards, the MAC address is written by the
+	 * BIOS directly to the MAC register during POST, and is
+	 * not stored in eeprom.  If all else thus far has failed
+	 * to fetch the permanent MAC address, try reading it directly.
+	 */
+	addr[0] = ioread32(hw->hw_addr + REG_MAC_STA_ADDR);
+	addr[1] = ioread16(hw->hw_addr + (REG_MAC_STA_ADDR + 4));
+	*(u32 *) &eth_addr[2] = swab32(addr[0]);
+	*(u16 *) &eth_addr[0] = swab16(*(u16 *) &addr[1]);
+	if (is_valid_ether_addr(eth_addr)) {
+		memcpy(hw->perm_mac_addr, eth_addr, ETH_ALEN);
+		return 0;
+	}
+
 	return 1;
 }
 
@@ -357,7 +362,7 @@ void atl1_hash_set(struct atl1_hw *hw, u32 hash_value)
 	 */
 	hash_reg = (hash_value >> 31) & 0x1;
 	hash_bit = (hash_value >> 26) & 0x1F;
-	mta = ioread32((hw + REG_RX_HASH_TABLE) + (hash_reg << 2));
+	mta = ioread32((hw->hw_addr + REG_RX_HASH_TABLE) + (hash_reg << 2));
 	mta |= (1 << hash_bit);
 	iowrite32(mta, (hw->hw_addr + REG_RX_HASH_TABLE) + (hash_reg << 2));
 }
diff --git a/drivers/net/atl1/atl1_main.c b/drivers/net/atl1/atl1_main.c
index 6655640..6567348 100644
--- a/drivers/net/atl1/atl1_main.c
+++ b/drivers/net/atl1/atl1_main.c
@@ -82,8 +82,7 @@
 
 #include "atl1.h"
 
-#define RUN_REALTIME 0
-#define DRIVER_VERSION "2.0.6"
+#define DRIVER_VERSION "2.0.7"
 
 char atl1_driver_name[] = "atl1";
 static const char atl1_driver_string[] = "Attansic L1 Ethernet Network Driver";
@@ -100,7 +99,7 @@ MODULE_VERSION(DRIVER_VERSION);
  * atl1_pci_tbl - PCI Device ID Table
  */
 static const struct pci_device_id atl1_pci_tbl[] = {
-	{PCI_DEVICE(PCI_VENDOR_ID_ATTANSIC, 0x1048)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ATTANSIC, PCI_DEVICE_ID_ATTANSIC_L1)},
 	/* required last entry */
 	{0,}
 };
diff --git a/drivers/net/b44.c b/drivers/net/b44.c
index 5ff7882..aaada57 100644
--- a/drivers/net/b44.c
+++ b/drivers/net/b44.c
@@ -59,7 +59,6 @@
 #define B44_DEF_TX_RING_PENDING		(B44_TX_RING_SIZE - 1)
 #define B44_TX_RING_BYTES	(sizeof(struct dma_desc) * \
 				 B44_TX_RING_SIZE)
-#define B44_DMA_MASK 0x3fffffff
 
 #define TX_RING_GAP(BP)	\
 	(B44_TX_RING_SIZE - (BP)->tx_pending)
@@ -665,7 +664,7 @@ static int b44_alloc_rx_skb(struct b44 *bp, int src_idx, u32 dest_idx_unmasked)
 	/* Hardware bug work-around, the chip is unable to do PCI DMA
 	   to/from anything above 1GB :-( */
 	if (dma_mapping_error(mapping) ||
-		mapping + RX_PKT_BUF_SZ > B44_DMA_MASK) {
+		mapping + RX_PKT_BUF_SZ > DMA_30BIT_MASK) {
 		/* Sigh... */
 		if (!dma_mapping_error(mapping))
 			pci_unmap_single(bp->pdev, mapping, RX_PKT_BUF_SZ,PCI_DMA_FROMDEVICE);
@@ -677,7 +676,7 @@ static int b44_alloc_rx_skb(struct b44 *bp, int src_idx, u32 dest_idx_unmasked)
 					 RX_PKT_BUF_SZ,
 					 PCI_DMA_FROMDEVICE);
 		if (dma_mapping_error(mapping) ||
-			mapping + RX_PKT_BUF_SZ > B44_DMA_MASK) {
+			mapping + RX_PKT_BUF_SZ > DMA_30BIT_MASK) {
 			if (!dma_mapping_error(mapping))
 				pci_unmap_single(bp->pdev, mapping, RX_PKT_BUF_SZ,PCI_DMA_FROMDEVICE);
 			dev_kfree_skb_any(skb);
@@ -988,7 +987,7 @@ static int b44_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	mapping = pci_map_single(bp->pdev, skb->data, len, PCI_DMA_TODEVICE);
-	if (dma_mapping_error(mapping) || mapping + len > B44_DMA_MASK) {
+	if (dma_mapping_error(mapping) || mapping + len > DMA_30BIT_MASK) {
 		/* Chip can't handle DMA to/from >1GB, use bounce buffer */
 		if (!dma_mapping_error(mapping))
 			pci_unmap_single(bp->pdev, mapping, len, PCI_DMA_TODEVICE);
@@ -1000,7 +999,7 @@ static int b44_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		mapping = pci_map_single(bp->pdev, bounce_skb->data,
 					 len, PCI_DMA_TODEVICE);
-		if (dma_mapping_error(mapping) || mapping + len > B44_DMA_MASK) {
+		if (dma_mapping_error(mapping) || mapping + len > DMA_30BIT_MASK) {
 			if (!dma_mapping_error(mapping))
 				pci_unmap_single(bp->pdev, mapping,
 					 len, PCI_DMA_TODEVICE);
@@ -1227,7 +1226,7 @@ static int b44_alloc_consistent(struct b44 *bp)
 		                             DMA_BIDIRECTIONAL);
 
 		if (dma_mapping_error(rx_ring_dma) ||
-			rx_ring_dma + size > B44_DMA_MASK) {
+			rx_ring_dma + size > DMA_30BIT_MASK) {
 			kfree(rx_ring);
 			goto out_err;
 		}
@@ -1254,7 +1253,7 @@ static int b44_alloc_consistent(struct b44 *bp)
 		                             DMA_TO_DEVICE);
 
 		if (dma_mapping_error(tx_ring_dma) ||
-			tx_ring_dma + size > B44_DMA_MASK) {
+			tx_ring_dma + size > DMA_30BIT_MASK) {
 			kfree(tx_ring);
 			goto out_err;
 		}
@@ -1289,7 +1288,7 @@ static void b44_chip_reset(struct b44 *bp)
 	if (ssb_is_core_up(bp)) {
 		bw32(bp, B44_RCV_LAZY, 0);
 		bw32(bp, B44_ENET_CTRL, ENET_CTRL_DISABLE);
-		b44_wait_bit(bp, B44_ENET_CTRL, ENET_CTRL_DISABLE, 100, 1);
+		b44_wait_bit(bp, B44_ENET_CTRL, ENET_CTRL_DISABLE, 200, 1);
 		bw32(bp, B44_DMATX_CTRL, 0);
 		bp->tx_prod = bp->tx_cons = 0;
 		if (br32(bp, B44_DMARX_STAT) & DMARX_STAT_EMASK) {
@@ -2151,13 +2150,13 @@ static int __devinit b44_init_one(struct pci_dev *pdev,
 
 	pci_set_master(pdev);
 
-	err = pci_set_dma_mask(pdev, (u64) B44_DMA_MASK);
+	err = pci_set_dma_mask(pdev, (u64) DMA_30BIT_MASK);
 	if (err) {
 		dev_err(&pdev->dev, "No usable DMA configuration, aborting.\n");
 		goto err_out_free_res;
 	}
 
-	err = pci_set_consistent_dma_mask(pdev, (u64) B44_DMA_MASK);
+	err = pci_set_consistent_dma_mask(pdev, (u64) DMA_30BIT_MASK);
 	if (err) {
 		dev_err(&pdev->dev, "No usable DMA configuration, aborting.\n");
 		goto err_out_free_res;
diff --git a/drivers/net/cxgb3/cxgb3_defs.h b/drivers/net/cxgb3/cxgb3_defs.h
index 16e0049..e14862b 100644
--- a/drivers/net/cxgb3/cxgb3_defs.h
+++ b/drivers/net/cxgb3/cxgb3_defs.h
@@ -1,6 +1,5 @@
 /*
  * Copyright (c) 2006-2007 Chelsio, Inc. All rights reserved.
- * Copyright (c) 2006-2007 Open Grid Computing, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
diff --git a/drivers/net/cxgb3/cxgb3_offload.c b/drivers/net/cxgb3/cxgb3_offload.c
index c6b7266..b2cf5f6 100644
--- a/drivers/net/cxgb3/cxgb3_offload.c
+++ b/drivers/net/cxgb3/cxgb3_offload.c
@@ -1,6 +1,5 @@
 /*
  * Copyright (c) 2006-2007 Chelsio, Inc. All rights reserved.
- * Copyright (c) 2006-2007 Open Grid Computing, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
diff --git a/drivers/net/cxgb3/cxgb3_offload.h b/drivers/net/cxgb3/cxgb3_offload.h
index 0e6beb6..f15446a 100644
--- a/drivers/net/cxgb3/cxgb3_offload.h
+++ b/drivers/net/cxgb3/cxgb3_offload.h
@@ -1,6 +1,5 @@
 /*
  * Copyright (c) 2006-2007 Chelsio, Inc. All rights reserved.
- * Copyright (c) 2006-2007 Open Grid Computing, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
diff --git a/drivers/net/cxgb3/l2t.c b/drivers/net/cxgb3/l2t.c
index 3c0cb85..d660af7 100644
--- a/drivers/net/cxgb3/l2t.c
+++ b/drivers/net/cxgb3/l2t.c
@@ -1,6 +1,5 @@
 /*
  * Copyright (c) 2003-2007 Chelsio, Inc. All rights reserved.
- * Copyright (c) 2006-2007 Open Grid Computing, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
diff --git a/drivers/net/cxgb3/l2t.h b/drivers/net/cxgb3/l2t.h
index ba5d2cb..d790013 100644
--- a/drivers/net/cxgb3/l2t.h
+++ b/drivers/net/cxgb3/l2t.h
@@ -1,6 +1,5 @@
 /*
  * Copyright (c) 2003-2007 Chelsio, Inc. All rights reserved.
- * Copyright (c) 2006-2007 Open Grid Computing, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
diff --git a/drivers/net/cxgb3/t3cdev.h b/drivers/net/cxgb3/t3cdev.h
index 9af3bcd..fa4099b 100644
--- a/drivers/net/cxgb3/t3cdev.h
+++ b/drivers/net/cxgb3/t3cdev.h
@@ -1,6 +1,5 @@
 /*
  * Copyright (C) 2006-2007 Chelsio Communications.  All rights reserved.
- * Copyright (C) 2006-2007 Open Grid Computing, Inc.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
diff --git a/drivers/net/e1000/e1000.h b/drivers/net/e1000/e1000.h
index 689f158..dd4b728 100644
--- a/drivers/net/e1000/e1000.h
+++ b/drivers/net/e1000/e1000.h
@@ -337,7 +337,6 @@ struct e1000_adapter {
 	struct e1000_rx_ring test_rx_ring;
 
 
-	uint32_t *config_space;
 	int msg_enable;
 #ifdef CONFIG_PCI_MSI
 	boolean_t have_msi;
diff --git a/drivers/net/e1000/e1000_ethtool.c b/drivers/net/e1000/e1000_ethtool.c
index 44ebc72..6777887 100644
--- a/drivers/net/e1000/e1000_ethtool.c
+++ b/drivers/net/e1000/e1000_ethtool.c
@@ -166,7 +166,7 @@ e1000_get_settings(struct net_device *netdev, struct ethtool_cmd *ecmd)
 			ecmd->transceiver = XCVR_EXTERNAL;
 	}
 
-	if (netif_carrier_ok(adapter->netdev)) {
+	if (E1000_READ_REG(&adapter->hw, STATUS) & E1000_STATUS_LU) {
 
 		e1000_get_speed_and_duplex(hw, &adapter->link_speed,
 		                                   &adapter->link_duplex);
diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
index 619c892..a710237 100644
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -1417,10 +1417,6 @@ e1000_open(struct net_device *netdev)
 	if ((err = e1000_setup_all_rx_resources(adapter)))
 		goto err_setup_rx;
 
-	err = e1000_request_irq(adapter);
-	if (err)
-		goto err_req_irq;
-
 	e1000_power_up_phy(adapter);
 
 	if ((err = e1000_up(adapter)))
@@ -1431,6 +1427,10 @@ e1000_open(struct net_device *netdev)
 		e1000_update_mng_vlan(adapter);
 	}
 
+	err = e1000_request_irq(adapter);
+	if (err)
+		goto err_req_irq;
+
 	/* If AMT is enabled, let the firmware know that the network
 	 * interface is now open */
 	if (adapter->hw.mac_type == e1000_82573 &&
@@ -1439,10 +1439,10 @@ e1000_open(struct net_device *netdev)
 
 	return E1000_SUCCESS;
 
+err_req_irq:
+	e1000_down(adapter);
 err_up:
 	e1000_power_down_phy(adapter);
-	e1000_free_irq(adapter);
-err_req_irq:
 	e1000_free_all_rx_resources(adapter);
 err_setup_rx:
 	e1000_free_all_tx_resources(adapter);
@@ -5071,58 +5071,6 @@ e1000_set_spd_dplx(struct e1000_adapter *adapter, uint16_t spddplx)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-/* Save/restore 16 or 64 dwords of PCI config space depending on which
- * bus we're on (PCI(X) vs. PCI-E)
- */
-#define PCIE_CONFIG_SPACE_LEN 256
-#define PCI_CONFIG_SPACE_LEN 64
-static int
-e1000_pci_save_state(struct e1000_adapter *adapter)
-{
-	struct pci_dev *dev = adapter->pdev;
-	int size;
-	int i;
-
-	if (adapter->hw.mac_type >= e1000_82571)
-		size = PCIE_CONFIG_SPACE_LEN;
-	else
-		size = PCI_CONFIG_SPACE_LEN;
-
-	WARN_ON(adapter->config_space != NULL);
-
-	adapter->config_space = kmalloc(size, GFP_KERNEL);
-	if (!adapter->config_space) {
-		DPRINTK(PROBE, ERR, "unable to allocate %d bytes\n", size);
-		return -ENOMEM;
-	}
-	for (i = 0; i < (size / 4); i++)
-		pci_read_config_dword(dev, i * 4, &adapter->config_space[i]);
-	return 0;
-}
-
-static void
-e1000_pci_restore_state(struct e1000_adapter *adapter)
-{
-	struct pci_dev *dev = adapter->pdev;
-	int size;
-	int i;
-
-	if (adapter->config_space == NULL)
-		return;
-
-	if (adapter->hw.mac_type >= e1000_82571)
-		size = PCIE_CONFIG_SPACE_LEN;
-	else
-		size = PCI_CONFIG_SPACE_LEN;
-	for (i = 0; i < (size / 4); i++)
-		pci_write_config_dword(dev, i * 4, adapter->config_space[i]);
-	kfree(adapter->config_space);
-	adapter->config_space = NULL;
-	return;
-}
-#endif /* CONFIG_PM */
-
 static int
 e1000_suspend(struct pci_dev *pdev, pm_message_t state)
 {
@@ -5142,9 +5090,7 @@ e1000_suspend(struct pci_dev *pdev, pm_message_t state)
 	}
 
 #ifdef CONFIG_PM
-	/* Implement our own version of pci_save_state(pdev) because pci-
-	 * express adapters have 256-byte config spaces. */
-	retval = e1000_pci_save_state(adapter);
+	retval = pci_save_state(pdev);
 	if (retval)
 		return retval;
 #endif
@@ -5231,7 +5177,7 @@ e1000_resume(struct pci_dev *pdev)
 	uint32_t err;
 
 	pci_set_power_state(pdev, PCI_D0);
-	e1000_pci_restore_state(adapter);
+	pci_restore_state(pdev);
 	if ((err = pci_enable_device(pdev))) {
 		printk(KERN_ERR "e1000: Cannot enable PCI device from suspend\n");
 		return err;
diff --git a/drivers/net/ehea/ehea.h b/drivers/net/ehea/ehea.h
index 272e1ec..42295d6 100644
--- a/drivers/net/ehea/ehea.h
+++ b/drivers/net/ehea/ehea.h
@@ -39,7 +39,7 @@
 #include <asm/io.h>
 
 #define DRV_NAME	"ehea"
-#define DRV_VERSION	"EHEA_0045"
+#define DRV_VERSION	"EHEA_0046"
 
 #define EHEA_MSG_DEFAULT (NETIF_MSG_LINK | NETIF_MSG_TIMER \
 	| NETIF_MSG_RX_ERR | NETIF_MSG_TX_ERR)
diff --git a/drivers/net/ehea/ehea_main.c b/drivers/net/ehea/ehea_main.c
index 38b2fa4..88ad1c8 100644
--- a/drivers/net/ehea/ehea_main.c
+++ b/drivers/net/ehea/ehea_main.c
@@ -76,7 +76,7 @@ void ehea_dump(void *adr, int len, char *msg) {
 	int x;
 	unsigned char *deb = adr;
 	for (x = 0; x < len; x += 16) {
-		printk(DRV_NAME "%s adr=%p ofs=%04x %016lx %016lx\n", msg,
+		printk(DRV_NAME " %s adr=%p ofs=%04x %016lx %016lx\n", msg,
 			  deb, x, *((u64*)&deb[0]), *((u64*)&deb[8]));
 		deb += 16;
 	}
@@ -555,6 +555,7 @@ static irqreturn_t ehea_qp_aff_irq_handler(int irq, void *param)
 {
 	struct ehea_port *port = param;
 	struct ehea_eqe *eqe;
+	struct ehea_qp *qp;
 	u32 qp_token;
 
 	eqe = ehea_poll_eq(port->qp_eq);
@@ -563,9 +564,14 @@ static irqreturn_t ehea_qp_aff_irq_handler(int irq, void *param)
 		qp_token = EHEA_BMASK_GET(EHEA_EQE_QP_TOKEN, eqe->entry);
 		ehea_error("QP aff_err: entry=0x%lx, token=0x%x",
 			   eqe->entry, qp_token);
+
+		qp = port->port_res[qp_token].qp;
+		ehea_error_data(port->adapter, qp->fw_handle);
 		eqe = ehea_poll_eq(port->qp_eq);
 	}
 
+	queue_work(port->adapter->ehea_wq, &port->reset_task);
+
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/net/ehea/ehea_phyp.c b/drivers/net/ehea/ehea_phyp.c
index 37716e0..bc3c005 100644
--- a/drivers/net/ehea/ehea_phyp.c
+++ b/drivers/net/ehea/ehea_phyp.c
@@ -612,3 +612,13 @@ u64 ehea_h_reset_events(const u64 adapter_handle, const u64 neq_handle,
 				       event_mask,		/* R6 */
 				       0, 0, 0, 0);		/* R7-R12 */
 }
+
+u64 ehea_h_error_data(const u64 adapter_handle, const u64 ressource_handle,
+		      void *rblock)
+{
+	return ehea_plpar_hcall_norets(H_ERROR_DATA,
+				       adapter_handle,          /* R4 */
+				       ressource_handle,        /* R5 */
+				       virt_to_abs(rblock),     /* R6 */
+				       0, 0, 0, 0);             /* R7-R12 */
+}
diff --git a/drivers/net/ehea/ehea_phyp.h b/drivers/net/ehea/ehea_phyp.h
index 919f94b..90acddb 100644
--- a/drivers/net/ehea/ehea_phyp.h
+++ b/drivers/net/ehea/ehea_phyp.h
@@ -454,4 +454,7 @@ u64 ehea_h_reg_dereg_bcmc(const u64 adapter_handle, const u16 port_num,
 u64 ehea_h_reset_events(const u64 adapter_handle, const u64 neq_handle,
 			const u64 event_mask);
 
+u64 ehea_h_error_data(const u64 adapter_handle, const u64 ressource_handle,
+		      void *rblock);
+
 #endif	/* __EHEA_PHYP_H__ */
diff --git a/drivers/net/ehea/ehea_qmr.c b/drivers/net/ehea/ehea_qmr.c
index f143e13..96ff3b6 100644
--- a/drivers/net/ehea/ehea_qmr.c
+++ b/drivers/net/ehea/ehea_qmr.c
@@ -486,6 +486,7 @@ int ehea_destroy_qp(struct ehea_qp *qp)
 	if (!qp)
 		return 0;
 
+	ehea_h_disable_and_get_hea(qp->adapter->handle, qp->fw_handle);
 	hret = ehea_h_free_resource(qp->adapter->handle, qp->fw_handle);
 	if (hret != H_SUCCESS) {
 		ehea_error("destroy_qp failed");
@@ -581,4 +582,45 @@ out:
 	return ret;
 }
 
+void print_error_data(u64 *data)
+{
+	int length;
+	u64 type = EHEA_BMASK_GET(ERROR_DATA_TYPE, data[2]);
+	u64 resource = data[1];
+
+	length = EHEA_BMASK_GET(ERROR_DATA_LENGTH, data[0]);
+
+	if (length > EHEA_PAGESIZE)
+		length = EHEA_PAGESIZE;
+
+	if (type == 0x8) /* Queue Pair */
+		ehea_error("QP (resource=%lX) state: AER=0x%lX, AERR=0x%lX, "
+			   "port=%lX", resource, data[6], data[12], data[22]);
+
+	ehea_dump(data, length, "error data");
+}
+
+void ehea_error_data(struct ehea_adapter *adapter, u64 res_handle)
+{
+	unsigned long ret;
+	u64 *rblock;
+
+	rblock = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!rblock) {
+		ehea_error("Cannot allocate rblock memory.");
+		return;
+	}
 
+	ret = ehea_h_error_data(adapter->handle,
+				res_handle,
+				rblock);
+
+	if (ret == H_R_STATE)
+		ehea_error("No error data is available: %lX.", res_handle);
+	else if (ret == H_SUCCESS)
+		print_error_data(rblock);
+	else
+		ehea_error("Error data could not be fetched: %lX", res_handle);
+
+	kfree(rblock);
+}
diff --git a/drivers/net/ehea/ehea_qmr.h b/drivers/net/ehea/ehea_qmr.h
index 7efdc96..1ff6098 100644
--- a/drivers/net/ehea/ehea_qmr.h
+++ b/drivers/net/ehea/ehea_qmr.h
@@ -180,6 +180,9 @@ struct ehea_eqe {
 	u64 entry;
 };
 
+#define ERROR_DATA_LENGTH  EHEA_BMASK_IBM(52,63)
+#define ERROR_DATA_TYPE    EHEA_BMASK_IBM(0,7)
+
 static inline void *hw_qeit_calc(struct hw_queue *queue, u64 q_offset)
 {
 	struct ehea_page *current_page;
@@ -355,4 +358,6 @@ int ehea_destroy_qp(struct ehea_qp *qp);
 
 int ehea_reg_mr_adapter(struct ehea_adapter *adapter);
 
+void ehea_error_data(struct ehea_adapter *adapter, u64 res_handle);
+
 #endif	/* __EHEA_QMR_H__ */
diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
index 1be4a84..1f83988 100644
--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -10,6 +10,7 @@
  * Maintainer: Kumar Gala
  *
  * Copyright (c) 2002-2006 Freescale Semiconductor, Inc.
+ * Copyright (c) 2007 MontaVista Software, Inc.
  *
  * This program is free software; you can redistribute  it and/or modify it
  * under  the terms of  the GNU General  Public License as published by the
@@ -1612,71 +1613,17 @@ static irqreturn_t gfar_interrupt(int irq, void *dev_id)
 	/* Save ievent for future reference */
 	u32 events = gfar_read(&priv->regs->ievent);
 
-	/* Clear IEVENT */
-	gfar_write(&priv->regs->ievent, events);
-
 	/* Check for reception */
-	if ((events & IEVENT_RXF0) || (events & IEVENT_RXB0))
+	if (events & IEVENT_RX_MASK)
 		gfar_receive(irq, dev_id);
 
 	/* Check for transmit completion */
-	if ((events & IEVENT_TXF) || (events & IEVENT_TXB))
+	if (events & IEVENT_TX_MASK)
 		gfar_transmit(irq, dev_id);
 
-	/* Update error statistics */
-	if (events & IEVENT_TXE) {
-		priv->stats.tx_errors++;
-
-		if (events & IEVENT_LC)
-			priv->stats.tx_window_errors++;
-		if (events & IEVENT_CRL)
-			priv->stats.tx_aborted_errors++;
-		if (events & IEVENT_XFUN) {
-			if (netif_msg_tx_err(priv))
-				printk(KERN_WARNING "%s: tx underrun. dropped packet\n", dev->name);
-			priv->stats.tx_dropped++;
-			priv->extra_stats.tx_underrun++;
-
-			/* Reactivate the Tx Queues */
-			gfar_write(&priv->regs->tstat, TSTAT_CLEAR_THALT);
-		}
-	}
-	if (events & IEVENT_BSY) {
-		priv->stats.rx_errors++;
-		priv->extra_stats.rx_bsy++;
-
-		gfar_receive(irq, dev_id);
-
-#ifndef CONFIG_GFAR_NAPI
-		/* Clear the halt bit in RSTAT */
-		gfar_write(&priv->regs->rstat, RSTAT_CLEAR_RHALT);
-#endif
-
-		if (netif_msg_rx_err(priv))
-			printk(KERN_DEBUG "%s: busy error (rhalt: %x)\n",
-					dev->name,
-					gfar_read(&priv->regs->rstat));
-	}
-	if (events & IEVENT_BABR) {
-		priv->stats.rx_errors++;
-		priv->extra_stats.rx_babr++;
-
-		if (netif_msg_rx_err(priv))
-			printk(KERN_DEBUG "%s: babbling error\n", dev->name);
-	}
-	if (events & IEVENT_EBERR) {
-		priv->extra_stats.eberr++;
-		if (netif_msg_rx_err(priv))
-			printk(KERN_DEBUG "%s: EBERR\n", dev->name);
-	}
-	if ((events & IEVENT_RXC) && (netif_msg_rx_err(priv)))
-			printk(KERN_DEBUG "%s: control frame\n", dev->name);
-
-	if (events & IEVENT_BABT) {
-		priv->extra_stats.tx_babt++;
-		if (netif_msg_rx_err(priv))
-			printk(KERN_DEBUG "%s: babt error\n", dev->name);
-	}
+	/* Check for errors */
+	if (events & IEVENT_ERR_MASK)
+		gfar_error(irq, dev_id);
 
 	return IRQ_HANDLED;
 }
@@ -1938,7 +1885,7 @@ static irqreturn_t gfar_error(int irq, void *dev_id)
 	/* Hmm... */
 	if (netif_msg_rx_err(priv) || netif_msg_tx_err(priv))
 		printk(KERN_DEBUG "%s: error interrupt (ievent=0x%08x imask=0x%08x)\n",
-				dev->name, events, gfar_read(&priv->regs->imask));
+		       dev->name, events, gfar_read(&priv->regs->imask));
 
 	/* Update the error counters */
 	if (events & IEVENT_TXE) {
@@ -1950,8 +1897,8 @@ static irqreturn_t gfar_error(int irq, void *dev_id)
 			priv->stats.tx_aborted_errors++;
 		if (events & IEVENT_XFUN) {
 			if (netif_msg_tx_err(priv))
-				printk(KERN_DEBUG "%s: underrun.  packet dropped.\n",
-						dev->name);
+				printk(KERN_DEBUG "%s: TX FIFO underrun, "
+				       "packet dropped.\n", dev->name);
 			priv->stats.tx_dropped++;
 			priv->extra_stats.tx_underrun++;
 
@@ -1973,30 +1920,28 @@ static irqreturn_t gfar_error(int irq, void *dev_id)
 #endif
 
 		if (netif_msg_rx_err(priv))
-			printk(KERN_DEBUG "%s: busy error (rhalt: %x)\n",
-					dev->name,
-					gfar_read(&priv->regs->rstat));
+			printk(KERN_DEBUG "%s: busy error (rstat: %x)\n",
+			       dev->name, gfar_read(&priv->regs->rstat));
 	}
 	if (events & IEVENT_BABR) {
 		priv->stats.rx_errors++;
 		priv->extra_stats.rx_babr++;
 
 		if (netif_msg_rx_err(priv))
-			printk(KERN_DEBUG "%s: babbling error\n", dev->name);
+			printk(KERN_DEBUG "%s: babbling RX error\n", dev->name);
 	}
 	if (events & IEVENT_EBERR) {
 		priv->extra_stats.eberr++;
 		if (netif_msg_rx_err(priv))
-			printk(KERN_DEBUG "%s: EBERR\n", dev->name);
+			printk(KERN_DEBUG "%s: bus error\n", dev->name);
 	}
 	if ((events & IEVENT_RXC) && netif_msg_rx_status(priv))
-		if (netif_msg_rx_status(priv))
-			printk(KERN_DEBUG "%s: control frame\n", dev->name);
+		printk(KERN_DEBUG "%s: control frame\n", dev->name);
 
 	if (events & IEVENT_BABT) {
 		priv->extra_stats.tx_babt++;
 		if (netif_msg_tx_err(priv))
-			printk(KERN_DEBUG "%s: babt error\n", dev->name);
+			printk(KERN_DEBUG "%s: babbling TX error\n", dev->name);
 	}
 	return IRQ_HANDLED;
 }
diff --git a/drivers/net/gianfar_sysfs.c b/drivers/net/gianfar_sysfs.c
index 45ffb5d..aec9ab1 100644
--- a/drivers/net/gianfar_sysfs.c
+++ b/drivers/net/gianfar_sysfs.c
@@ -38,13 +38,15 @@
 #include "gianfar.h"
 
 #define GFAR_ATTR(_name) \
-static ssize_t gfar_show_##_name(struct class_device *cdev, char *buf); \
-static ssize_t gfar_set_##_name(struct class_device *cdev, \
+static ssize_t gfar_show_##_name(struct device *dev, \
+	 struct device_attribute *attr, char *buf); \
+static ssize_t gfar_set_##_name(struct device *dev, \
+		struct device_attribute *attr, \
 		const char *buf, size_t count); \
-static CLASS_DEVICE_ATTR(_name, 0644, gfar_show_##_name, gfar_set_##_name)
+static DEVICE_ATTR(_name, 0644, gfar_show_##_name, gfar_set_##_name)
 
 #define GFAR_CREATE_FILE(_dev, _name) \
-	class_device_create_file(&_dev->class_dev, &class_device_attr_##_name)
+	device_create_file(&_dev->dev, &dev_attr_##_name)
 
 GFAR_ATTR(bd_stash);
 GFAR_ATTR(rx_stash_size);
@@ -53,29 +55,28 @@ GFAR_ATTR(fifo_threshold);
 GFAR_ATTR(fifo_starve);
 GFAR_ATTR(fifo_starve_off);
 
-#define to_net_dev(cd) container_of(cd, struct net_device, class_dev)
-
-static ssize_t gfar_show_bd_stash(struct class_device *cdev, char *buf)
+static ssize_t gfar_show_bd_stash(struct device *dev,
+				  struct device_attribute *attr, char *buf)
 {
-	struct net_device *dev = to_net_dev(cdev);
-	struct gfar_private *priv = netdev_priv(dev);
+	struct gfar_private *priv = netdev_priv(to_net_dev(dev));
 
-	return sprintf(buf, "%s\n", priv->bd_stash_en? "on" : "off");
+	return sprintf(buf, "%s\n", priv->bd_stash_en ? "on" : "off");
 }
 
-static ssize_t gfar_set_bd_stash(struct class_device *cdev,
-		const char *buf, size_t count)
+static ssize_t gfar_set_bd_stash(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
 {
-	struct net_device *dev = to_net_dev(cdev);
-	struct gfar_private *priv = netdev_priv(dev);
+	struct gfar_private *priv = netdev_priv(to_net_dev(dev));
 	int new_setting = 0;
 	u32 temp;
 	unsigned long flags;
 
 	/* Find out the new setting */
-	if (!strncmp("on", buf, count-1) || !strncmp("1", buf, count-1))
+	if (!strncmp("on", buf, count - 1) || !strncmp("1", buf, count - 1))
 		new_setting = 1;
-	else if (!strncmp("off", buf, count-1) || !strncmp("0", buf, count-1))
+	else if (!strncmp("off", buf, count - 1)
+		 || !strncmp("0", buf, count - 1))
 		new_setting = 0;
 	else
 		return count;
@@ -99,19 +100,19 @@ static ssize_t gfar_set_bd_stash(struct class_device *cdev,
 	return count;
 }
 
-static ssize_t gfar_show_rx_stash_size(struct class_device *cdev, char *buf)
+static ssize_t gfar_show_rx_stash_size(struct device *dev,
+				       struct device_attribute *attr, char *buf)
 {
-	struct net_device *dev = to_net_dev(cdev);
-	struct gfar_private *priv = netdev_priv(dev);
+	struct gfar_private *priv = netdev_priv(to_net_dev(dev));
 
 	return sprintf(buf, "%d\n", priv->rx_stash_size);
 }
 
-static ssize_t gfar_set_rx_stash_size(struct class_device *cdev,
-		const char *buf, size_t count)
+static ssize_t gfar_set_rx_stash_size(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
 {
-	struct net_device *dev = to_net_dev(cdev);
-	struct gfar_private *priv = netdev_priv(dev);
+	struct gfar_private *priv = netdev_priv(to_net_dev(dev));
 	unsigned int length = simple_strtoul(buf, NULL, 0);
 	u32 temp;
 	unsigned long flags;
@@ -145,21 +146,21 @@ static ssize_t gfar_set_rx_stash_size(struct class_device *cdev,
 	return count;
 }
 
-
 /* Stashing will only be enabled when rx_stash_size != 0 */
-static ssize_t gfar_show_rx_stash_index(struct class_device *cdev, char *buf)
+static ssize_t gfar_show_rx_stash_index(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
 {
-	struct net_device *dev = to_net_dev(cdev);
-	struct gfar_private *priv = netdev_priv(dev);
+	struct gfar_private *priv = netdev_priv(to_net_dev(dev));
 
 	return sprintf(buf, "%d\n", priv->rx_stash_index);
 }
 
-static ssize_t gfar_set_rx_stash_index(struct class_device *cdev,
-		const char *buf, size_t count)
+static ssize_t gfar_set_rx_stash_index(struct device *dev,
+				       struct device_attribute *attr,
+				       const char *buf, size_t count)
 {
-	struct net_device *dev = to_net_dev(cdev);
-	struct gfar_private *priv = netdev_priv(dev);
+	struct gfar_private *priv = netdev_priv(to_net_dev(dev));
 	unsigned short index = simple_strtoul(buf, NULL, 0);
 	u32 temp;
 	unsigned long flags;
@@ -183,19 +184,20 @@ static ssize_t gfar_set_rx_stash_index(struct class_device *cdev,
 	return count;
 }
 
-static ssize_t gfar_show_fifo_threshold(struct class_device *cdev, char *buf)
+static ssize_t gfar_show_fifo_threshold(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
 {
-	struct net_device *dev = to_net_dev(cdev);
-	struct gfar_private *priv = netdev_priv(dev);
+	struct gfar_private *priv = netdev_priv(to_net_dev(dev));
 
 	return sprintf(buf, "%d\n", priv->fifo_threshold);
 }
 
-static ssize_t gfar_set_fifo_threshold(struct class_device *cdev,
-		const char *buf, size_t count)
+static ssize_t gfar_set_fifo_threshold(struct device *dev,
+				       struct device_attribute *attr,
+				       const char *buf, size_t count)
 {
-	struct net_device *dev = to_net_dev(cdev);
-	struct gfar_private *priv = netdev_priv(dev);
+	struct gfar_private *priv = netdev_priv(to_net_dev(dev));
 	unsigned int length = simple_strtoul(buf, NULL, 0);
 	u32 temp;
 	unsigned long flags;
@@ -217,20 +219,19 @@ static ssize_t gfar_set_fifo_threshold(struct class_device *cdev,
 	return count;
 }
 
-static ssize_t gfar_show_fifo_starve(struct class_device *cdev, char *buf)
+static ssize_t gfar_show_fifo_starve(struct device *dev,
+				     struct device_attribute *attr, char *buf)
 {
-	struct net_device *dev = to_net_dev(cdev);
-	struct gfar_private *priv = netdev_priv(dev);
+	struct gfar_private *priv = netdev_priv(to_net_dev(dev));
 
 	return sprintf(buf, "%d\n", priv->fifo_starve);
 }
 
-
-static ssize_t gfar_set_fifo_starve(struct class_device *cdev,
-		const char *buf, size_t count)
+static ssize_t gfar_set_fifo_starve(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
 {
-	struct net_device *dev = to_net_dev(cdev);
-	struct gfar_private *priv = netdev_priv(dev);
+	struct gfar_private *priv = netdev_priv(to_net_dev(dev));
 	unsigned int num = simple_strtoul(buf, NULL, 0);
 	u32 temp;
 	unsigned long flags;
@@ -252,19 +253,20 @@ static ssize_t gfar_set_fifo_starve(struct class_device *cdev,
 	return count;
 }
 
-static ssize_t gfar_show_fifo_starve_off(struct class_device *cdev, char *buf)
+static ssize_t gfar_show_fifo_starve_off(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
 {
-	struct net_device *dev = to_net_dev(cdev);
-	struct gfar_private *priv = netdev_priv(dev);
+	struct gfar_private *priv = netdev_priv(to_net_dev(dev));
 
 	return sprintf(buf, "%d\n", priv->fifo_starve_off);
 }
 
-static ssize_t gfar_set_fifo_starve_off(struct class_device *cdev,
-		const char *buf, size_t count)
+static ssize_t gfar_set_fifo_starve_off(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
 {
-	struct net_device *dev = to_net_dev(cdev);
-	struct gfar_private *priv = netdev_priv(dev);
+	struct gfar_private *priv = netdev_priv(to_net_dev(dev));
 	unsigned int num = simple_strtoul(buf, NULL, 0);
 	u32 temp;
 	unsigned long flags;
diff --git a/drivers/net/ioc3-eth.c b/drivers/net/ioc3-eth.c
index f0d30cf..4ad7807 100644
--- a/drivers/net/ioc3-eth.c
+++ b/drivers/net/ioc3-eth.c
@@ -836,13 +836,17 @@ static int ioc3_mii_init(struct ioc3_private *ip)
 	}
 
 	ip->mii.phy_id = i;
+
+out:
+	return res;
+}
+
+static void ioc3_mii_start(struct ioc3_private *ip)
+{
 	ip->ioc3_timer.expires = jiffies + (12 * HZ)/10;  /* 1.2 sec. */
 	ip->ioc3_timer.data = (unsigned long) ip;
 	ip->ioc3_timer.function = &ioc3_timer;
 	add_timer(&ip->ioc3_timer);
-
-out:
-	return res;
 }
 
 static inline void ioc3_clean_rx_ring(struct ioc3_private *ip)
@@ -1071,6 +1075,7 @@ static int ioc3_open(struct net_device *dev)
 	ip->ehar_h = 0;
 	ip->ehar_l = 0;
 	ioc3_init(dev);
+	ioc3_mii_start(ip);
 
 	netif_start_queue(dev);
 	return 0;
@@ -1274,6 +1279,7 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_stop;
 	}
 
+	ioc3_mii_start(ip);
 	ioc3_ssram_disc(ip);
 	ioc3_get_eaddr(ip);
 
@@ -1314,6 +1320,7 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 out_stop:
 	ioc3_stop(ip);
+	del_timer_sync(&ip->ioc3_timer);
 	ioc3_free_rings(ip);
 out_res:
 	pci_release_regions(pdev);
@@ -1335,6 +1342,8 @@ static void __devexit ioc3_remove_one (struct pci_dev *pdev)
 	struct ioc3 *ioc3 = ip->regs;
 
 	unregister_netdev(dev);
+	del_timer_sync(&ip->ioc3_timer);
+
 	iounmap(ioc3);
 	pci_release_regions(pdev);
 	free_netdev(dev);
@@ -1492,6 +1501,7 @@ static void ioc3_timeout(struct net_device *dev)
 	ioc3_stop(ip);
 	ioc3_init(dev);
 	ioc3_mii_init(ip);
+	ioc3_mii_start(ip);
 
 	spin_unlock_irq(&ip->ioc3_lock);
 
diff --git a/drivers/net/macb.c b/drivers/net/macb.c
index a41418b..2e9571b 100644
--- a/drivers/net/macb.c
+++ b/drivers/net/macb.c
@@ -881,27 +881,15 @@ static struct net_device_stats *macb_get_stats(struct net_device *dev)
 static int macb_get_settings(struct net_device *dev, struct ethtool_cmd *cmd)
 {
 	struct macb *bp = netdev_priv(dev);
-	int ret;
-	unsigned long flags;
-
-	spin_lock_irqsave(&bp->lock, flags);
-	ret = mii_ethtool_gset(&bp->mii, cmd);
-	spin_unlock_irqrestore(&bp->lock, flags);
 
-	return ret;
+	return mii_ethtool_gset(&bp->mii, cmd);
 }
 
 static int macb_set_settings(struct net_device *dev, struct ethtool_cmd *cmd)
 {
 	struct macb *bp = netdev_priv(dev);
-	int ret;
-	unsigned long flags;
-
-	spin_lock_irqsave(&bp->lock, flags);
-	ret = mii_ethtool_sset(&bp->mii, cmd);
-	spin_unlock_irqrestore(&bp->lock, flags);
 
-	return ret;
+	return mii_ethtool_sset(&bp->mii, cmd);
 }
 
 static void macb_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
@@ -930,17 +918,11 @@ static struct ethtool_ops macb_ethtool_ops = {
 static int macb_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 {
 	struct macb *bp = netdev_priv(dev);
-	int ret;
-	unsigned long flags;
 
 	if (!netif_running(dev))
 		return -EINVAL;
 
-	spin_lock_irqsave(&bp->lock, flags);
-	ret = generic_mii_ioctl(&bp->mii, if_mii(rq), cmd, NULL);
-	spin_unlock_irqrestore(&bp->lock, flags);
-
-	return ret;
+	return generic_mii_ioctl(&bp->mii, if_mii(rq), cmd, NULL);
 }
 
 static ssize_t macb_mii_show(const struct device *_dev, char *buf,
diff --git a/drivers/net/meth.c b/drivers/net/meth.c
index d38b7c7..7e69ca6 100644
--- a/drivers/net/meth.c
+++ b/drivers/net/meth.c
@@ -170,7 +170,7 @@ static int mdio_probe(struct meth_private *priv)
 
 static void meth_check_link(struct net_device *dev)
 {
-	struct meth_private *priv = (struct meth_private *) dev->priv;
+	struct meth_private *priv = netdev_priv(dev);
 	unsigned long mii_advertising = mdio_read(priv, 4);
 	unsigned long mii_partner = mdio_read(priv, 5);
 	unsigned long negotiated = mii_advertising & mii_partner;
@@ -268,7 +268,7 @@ static void meth_free_rx_ring(struct meth_private *priv)
 
 int meth_reset(struct net_device *dev)
 {
-	struct meth_private *priv = (struct meth_private *) dev->priv;
+	struct meth_private *priv = netdev_priv(dev);
 
 	/* Reset card */
 	mace->eth.mac_ctrl = SGI_MAC_RESET;
@@ -310,7 +310,7 @@ int meth_reset(struct net_device *dev)
  */
 static int meth_open(struct net_device *dev)
 {
-	struct meth_private *priv = dev->priv;
+	struct meth_private *priv = netdev_priv(dev);
 	int ret;
 
 	priv->phy_addr = -1;    /* No PHY is known yet... */
@@ -354,7 +354,7 @@ out_free_tx_ring:
 
 static int meth_release(struct net_device *dev)
 {
-	struct meth_private *priv = dev->priv;
+	struct meth_private *priv = netdev_priv(dev);
 
 	DPRINTK("Stopping queue\n");
 	netif_stop_queue(dev); /* can't transmit any more */
@@ -376,7 +376,7 @@ static void meth_rx(struct net_device* dev, unsigned long int_status)
 {
 	struct sk_buff *skb;
 	unsigned long status;
-	struct meth_private *priv = (struct meth_private *) dev->priv;
+	struct meth_private *priv = netdev_priv(dev);
 	unsigned long fifo_rptr = (int_status & METH_INT_RX_RPTR_MASK) >> 8;
 
 	spin_lock(&priv->meth_lock);
@@ -466,14 +466,14 @@ static void meth_rx(struct net_device* dev, unsigned long int_status)
 
 static int meth_tx_full(struct net_device *dev)
 {
-	struct meth_private *priv = (struct meth_private *) dev->priv;
+	struct meth_private *priv = netdev_priv(dev);
 
 	return (priv->tx_count >= TX_RING_ENTRIES - 1);
 }
 
 static void meth_tx_cleanup(struct net_device* dev, unsigned long int_status)
 {
-	struct meth_private *priv = dev->priv;
+	struct meth_private *priv = netdev_priv(dev);
 	unsigned long status;
 	struct sk_buff *skb;
 	unsigned long rptr = (int_status&TX_INFO_RPTR) >> 16;
@@ -536,7 +536,7 @@ static void meth_tx_cleanup(struct net_device* dev, unsigned long int_status)
 
 static void meth_error(struct net_device* dev, unsigned status)
 {
-	struct meth_private *priv = (struct meth_private *) dev->priv;
+	struct meth_private *priv = netdev_priv(dev);
 
 	printk(KERN_WARNING "meth: error status: 0x%08x\n",status);
 	/* check for errors too... */
@@ -570,7 +570,7 @@ static void meth_error(struct net_device* dev, unsigned status)
 static irqreturn_t meth_interrupt(int irq, void *dev_id)
 {
 	struct net_device *dev = (struct net_device *)dev_id;
-	struct meth_private *priv = (struct meth_private *) dev->priv;
+	struct meth_private *priv = netdev_priv(dev);
 	unsigned long status;
 
 	status = mace->eth.int_stat;
@@ -695,7 +695,7 @@ static void meth_add_to_tx_ring(struct meth_private *priv, struct sk_buff *skb)
  */
 static int meth_tx(struct sk_buff *skb, struct net_device *dev)
 {
-	struct meth_private *priv = (struct meth_private *) dev->priv;
+	struct meth_private *priv = netdev_priv(dev);
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->meth_lock, flags);
@@ -726,7 +726,7 @@ static int meth_tx(struct sk_buff *skb, struct net_device *dev)
  */
 static void meth_tx_timeout(struct net_device *dev)
 {
-	struct meth_private *priv = (struct meth_private *) dev->priv;
+	struct meth_private *priv = netdev_priv(dev);
 	unsigned long flags;
 
 	printk(KERN_WARNING "%s: transmit timed out\n", dev->name);
@@ -778,7 +778,7 @@ static int meth_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
  */
 static struct net_device_stats *meth_stats(struct net_device *dev)
 {
-	struct meth_private *priv = (struct meth_private *) dev->priv;
+	struct meth_private *priv = netdev_priv(dev);
 	return &priv->stats;
 }
 
@@ -807,7 +807,7 @@ static struct net_device *meth_init(void)
 	dev->irq	     = MACE_ETHERNET_IRQ;
 	dev->base_addr	     = (unsigned long)&mace->eth;
 
-	priv = (struct meth_private *) dev->priv;
+	priv = netdev_priv(dev);
 	spin_lock_init(&priv->meth_lock);
 
 	ret = register_netdev(dev);
diff --git a/drivers/net/netxen/netxen_nic.h b/drivers/net/netxen/netxen_nic.h
index 3f3896e..2807ef4 100644
--- a/drivers/net/netxen/netxen_nic.h
+++ b/drivers/net/netxen/netxen_nic.h
@@ -252,7 +252,7 @@ typedef u32 netxen_ctx_msg;
 #define netxen_set_msg_ctxid(config_word, val)	\
 	((config_word) &= ~(0x3ff<<18), (config_word) |= (val & 0x3ff) << 18)
 #define netxen_set_msg_opcode(config_word, val)	\
-	((config_word) &= ~(0xf<<24), (config_word) |= (val & 0xf) << 24)
+	((config_word) &= ~(0xf<<28), (config_word) |= (val & 0xf) << 28)
 
 struct netxen_rcv_context {
 	__le64 rcv_ring_addr;
@@ -303,14 +303,14 @@ struct netxen_ring_ctx {
 	(cmd_desc)->flags_opcode |= cpu_to_le16((val) & 0x7f))
 #define netxen_set_cmd_desc_opcode(cmd_desc, val)	\
 	((cmd_desc)->flags_opcode &= ~cpu_to_le16(0x3f<<7), \
-	(cmd_desc)->flags_opcode |= cpu_to_le16((val) & (0x3f<<7)))
+	(cmd_desc)->flags_opcode |= cpu_to_le16(((val & 0x3f)<<7)))
 
 #define netxen_set_cmd_desc_num_of_buff(cmd_desc, val)	\
 	((cmd_desc)->num_of_buffers_total_length &= ~cpu_to_le32(0xff), \
 	(cmd_desc)->num_of_buffers_total_length |= cpu_to_le32((val) & 0xff))
 #define netxen_set_cmd_desc_totallength(cmd_desc, val)	\
-	((cmd_desc)->num_of_buffers_total_length &= cpu_to_le32(0xff), \
-	(cmd_desc)->num_of_buffers_total_length |= cpu_to_le32(val << 24))
+	((cmd_desc)->num_of_buffers_total_length &= ~cpu_to_le32(0xffffff00), \
+	(cmd_desc)->num_of_buffers_total_length |= cpu_to_le32(val << 8))
 
 #define netxen_get_cmd_desc_opcode(cmd_desc)	\
 	((le16_to_cpu((cmd_desc)->flags_opcode) >> 7) & 0x003F)
@@ -1040,6 +1040,7 @@ int netxen_flash_unlock(struct netxen_adapter *adapter);
 int netxen_backup_crbinit(struct netxen_adapter *adapter);
 int netxen_flash_erase_secondary(struct netxen_adapter *adapter);
 int netxen_flash_erase_primary(struct netxen_adapter *adapter);
+void netxen_halt_pegs(struct netxen_adapter *adapter);
 
 int netxen_rom_fast_write(struct netxen_adapter *adapter, int addr, int data);
 int netxen_rom_se(struct netxen_adapter *adapter, int addr);
diff --git a/drivers/net/netxen/netxen_nic_ethtool.c b/drivers/net/netxen/netxen_nic_ethtool.c
index cc0efe2..6252e9a 100644
--- a/drivers/net/netxen/netxen_nic_ethtool.c
+++ b/drivers/net/netxen/netxen_nic_ethtool.c
@@ -402,7 +402,7 @@ netxen_nic_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 	wol->wolopts = 0;
 }
 
-static u32 netxen_nic_get_link(struct net_device *dev)
+static u32 netxen_nic_test_link(struct net_device *dev)
 {
 	struct netxen_port *port = netdev_priv(dev);
 	struct netxen_adapter *adapter = port->adapter;
@@ -459,6 +459,7 @@ netxen_nic_set_eeprom(struct net_device *dev, struct ethtool_eeprom *eeprom,
 	int ret;
 
 	if (flash_start == 0) {
+		netxen_halt_pegs(adapter);
 		ret = netxen_flash_unlock(adapter);
 		if (ret < 0) {
 			printk(KERN_ERR "%s: Flash unlock failed.\n",
@@ -712,7 +713,7 @@ netxen_nic_diag_test(struct net_device *dev, struct ethtool_test *eth_test,
 {
 	if (eth_test->flags == ETH_TEST_FL_OFFLINE) {	/* offline tests */
 		/* link test */
-		if (!(data[4] = (u64) netxen_nic_get_link(dev)))
+		if (!(data[4] = (u64) netxen_nic_test_link(dev)))
 			eth_test->flags |= ETH_TEST_FL_FAILED;
 
 		if (netif_running(dev))
@@ -727,7 +728,7 @@ netxen_nic_diag_test(struct net_device *dev, struct ethtool_test *eth_test,
 			dev->open(dev);
 	} else {		/* online tests */
 		/* link test */
-		if (!(data[4] = (u64) netxen_nic_get_link(dev)))
+		if (!(data[4] = (u64) netxen_nic_test_link(dev)))
 			eth_test->flags |= ETH_TEST_FL_FAILED;
 
 		/* other tests pass by default */
@@ -783,7 +784,7 @@ struct ethtool_ops netxen_nic_ethtool_ops = {
 	.get_regs_len = netxen_nic_get_regs_len,
 	.get_regs = netxen_nic_get_regs,
 	.get_wol = netxen_nic_get_wol,
-	.get_link = netxen_nic_get_link,
+	.get_link = ethtool_op_get_link,
 	.get_eeprom_len = netxen_nic_get_eeprom_len,
 	.get_eeprom = netxen_nic_get_eeprom,
 	.set_eeprom = netxen_nic_set_eeprom,
diff --git a/drivers/net/netxen/netxen_nic_hw.c b/drivers/net/netxen/netxen_nic_hw.c
index f263232..7195af3 100644
--- a/drivers/net/netxen/netxen_nic_hw.c
+++ b/drivers/net/netxen/netxen_nic_hw.c
@@ -420,6 +420,7 @@ static int netxen_get_flash_block(struct netxen_adapter *adapter, int base,
 	for (i = 0; i < size / sizeof(u32); i++) {
 		if (netxen_rom_fast_read(adapter, addr, ptr32) == -1)
 			return -1;
+		*ptr32 = cpu_to_le32(*ptr32);
 		ptr32++;
 		addr += sizeof(u32);
 	}
@@ -428,6 +429,7 @@ static int netxen_get_flash_block(struct netxen_adapter *adapter, int base,
 
 		if (netxen_rom_fast_read(adapter, addr, &local) == -1)
 			return -1;
+		local = cpu_to_le32(local);
 		memcpy(ptr32, &local, (char *)buf + size - (char *)ptr32);
 	}
 
diff --git a/drivers/net/netxen/netxen_nic_init.c b/drivers/net/netxen/netxen_nic_init.c
index f7bb8c9..2f32436 100644
--- a/drivers/net/netxen/netxen_nic_init.c
+++ b/drivers/net/netxen/netxen_nic_init.c
@@ -717,6 +717,14 @@ netxen_flash_erase_primary(struct netxen_adapter *adapter)
 	return ret;
 }
 
+void netxen_halt_pegs(struct netxen_adapter *adapter)
+{
+	 netxen_crb_writelit_adapter(adapter, NETXEN_CRB_PEG_NET_0 + 0x3c, 1);
+	 netxen_crb_writelit_adapter(adapter, NETXEN_CRB_PEG_NET_1 + 0x3c, 1);
+	 netxen_crb_writelit_adapter(adapter, NETXEN_CRB_PEG_NET_2 + 0x3c, 1);
+	 netxen_crb_writelit_adapter(adapter, NETXEN_CRB_PEG_NET_3 + 0x3c, 1);
+}
+
 int netxen_flash_unlock(struct netxen_adapter *adapter)
 {
 	int ret = 0;
@@ -1246,7 +1254,7 @@ int netxen_process_cmd_ring(unsigned long data)
 	 * the netdev which is associated with that device.
 	 */
 
-	consumer = *(adapter->cmd_consumer);
+	consumer = le32_to_cpu(*(adapter->cmd_consumer));
 	if (last_consumer == consumer) {	/* Ring is empty    */
 		DPRINTK(INFO, "last_consumer %d == consumer %d\n",
 			last_consumer, consumer);
@@ -1340,7 +1348,7 @@ int netxen_process_cmd_ring(unsigned long data)
 	if (adapter->last_cmd_consumer == consumer &&
 	    (((adapter->cmd_producer + 1) %
 	      adapter->max_tx_desc_count) == adapter->last_cmd_consumer)) {
-		consumer = *(adapter->cmd_consumer);
+		consumer = le32_to_cpu(*(adapter->cmd_consumer));
 	}
 	done = (adapter->last_cmd_consumer == consumer);
 
diff --git a/drivers/net/netxen/netxen_nic_main.c b/drivers/net/netxen/netxen_nic_main.c
index 36ba6a1..225ff55 100644
--- a/drivers/net/netxen/netxen_nic_main.c
+++ b/drivers/net/netxen/netxen_nic_main.c
@@ -434,12 +434,13 @@ netxen_nic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		adapter->port_count++;
 		adapter->port[i] = port;
 	}
-
+#ifndef CONFIG_PPC64
 	writel(0, NETXEN_CRB_NORMALIZE(adapter, CRB_CMDPEG_STATE));
 	netxen_pinit_from_rom(adapter, 0);
 	udelay(500);
 	netxen_load_firmware(adapter);
 	netxen_phantom_init(adapter, NETXEN_NIC_PEG_TUNE);
+#endif
 	/*
 	 * delay a while to ensure that the Pegs are up & running.
 	 * Otherwise, we might see some flaky behaviour.
diff --git a/drivers/net/netxen/netxen_nic_niu.c b/drivers/net/netxen/netxen_nic_niu.c
index 40d7003..d5d9507 100644
--- a/drivers/net/netxen/netxen_nic_niu.c
+++ b/drivers/net/netxen/netxen_nic_niu.c
@@ -458,7 +458,7 @@ int netxen_niu_gbe_init_port(struct netxen_adapter *adapter, int port)
 
 int netxen_niu_xg_init_port(struct netxen_adapter *adapter, int port)
 {
-	long reg = 0, ret = 0;
+	u32 reg = 0, ret = 0;
 
 	if (adapter->ahw.boardcfg.board_type == NETXEN_BRDTYPE_P2_SB31_10G_IMEZ) {
 		netxen_crb_writelit_adapter(adapter,
diff --git a/drivers/net/pcmcia/3c574_cs.c b/drivers/net/pcmcia/3c574_cs.c
index 448bf4a..c7bd9c1 100644
--- a/drivers/net/pcmcia/3c574_cs.c
+++ b/drivers/net/pcmcia/3c574_cs.c
@@ -915,7 +915,7 @@ static void media_check(unsigned long arg)
 	if ((inw(ioaddr + EL3_STATUS) & IntLatch) && (inb(ioaddr + Timer) == 0xff)) {
 		if (!lp->fast_poll)
 			printk(KERN_INFO "%s: interrupt(s) dropped!\n", dev->name);
-		el3_interrupt(dev->irq, lp);
+		el3_interrupt(dev->irq, dev);
 		lp->fast_poll = HZ;
 	}
 	if (lp->fast_poll) {
diff --git a/drivers/net/pcmcia/smc91c92_cs.c b/drivers/net/pcmcia/smc91c92_cs.c
index 530df88..2561f76 100644
--- a/drivers/net/pcmcia/smc91c92_cs.c
+++ b/drivers/net/pcmcia/smc91c92_cs.c
@@ -1927,7 +1927,7 @@ static void media_check(u_long arg)
     if (smc->watchdog++ && ((i>>8) & i)) {
 	if (!smc->fast_poll)
 	    printk(KERN_INFO "%s: interrupt(s) dropped!\n", dev->name);
-	smc_interrupt(dev->irq, smc);
+	smc_interrupt(dev->irq, dev);
 	smc->fast_poll = HZ;
     }
     if (smc->fast_poll) {
diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index f4d4eb6..22aec5c 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -42,6 +42,19 @@
 #define MII_M1011_IMASK_INIT		0x6400
 #define MII_M1011_IMASK_CLEAR		0x0000
 
+#define MII_M1011_PHY_SCR		0x10
+#define MII_M1011_PHY_SCR_AUTO_CROSS	0x0060
+
+#define MII_M1145_PHY_EXT_CR		0x14
+#define MII_M1145_RGMII_RX_DELAY	0x0080
+#define MII_M1145_RGMII_TX_DELAY	0x0002
+
+#define M1145_DEV_FLAGS_RESISTANCE	0x00000001
+
+#define MII_M1111_PHY_LED_CONTROL	0x18
+#define MII_M1111_PHY_LED_DIRECT	0x4100
+#define MII_M1111_PHY_LED_COMBINE	0x411c
+
 MODULE_DESCRIPTION("Marvell PHY driver");
 MODULE_AUTHOR("Andy Fleming");
 MODULE_LICENSE("GPL");
@@ -63,7 +76,7 @@ static int marvell_config_intr(struct phy_device *phydev)
 {
 	int err;
 
-	if(phydev->interrupts == PHY_INTERRUPT_ENABLED)
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
 		err = phy_write(phydev, MII_M1011_IMASK, MII_M1011_IMASK_INIT);
 	else
 		err = phy_write(phydev, MII_M1011_IMASK, MII_M1011_IMASK_CLEAR);
@@ -103,34 +116,153 @@ static int marvell_config_aneg(struct phy_device *phydev)
 	if (err < 0)
 		return err;
 
+	err = phy_write(phydev, MII_M1011_PHY_SCR,
+			MII_M1011_PHY_SCR_AUTO_CROSS);
+	if (err < 0)
+		return err;
+
+	err = phy_write(phydev, MII_M1111_PHY_LED_CONTROL,
+			MII_M1111_PHY_LED_DIRECT);
+	if (err < 0)
+		return err;
 
 	err = genphy_config_aneg(phydev);
 
 	return err;
 }
 
+static int m88e1145_config_init(struct phy_device *phydev)
+{
+	int err;
+
+	/* Take care of errata E0 & E1 */
+	err = phy_write(phydev, 0x1d, 0x001b);
+	if (err < 0)
+		return err;
+
+	err = phy_write(phydev, 0x1e, 0x418f);
+	if (err < 0)
+		return err;
+
+	err = phy_write(phydev, 0x1d, 0x0016);
+	if (err < 0)
+		return err;
+
+	err = phy_write(phydev, 0x1e, 0xa2da);
+	if (err < 0)
+		return err;
+
+	if (phydev->interface == PHY_INTERFACE_MODE_RGMII) {
+		int temp = phy_read(phydev, MII_M1145_PHY_EXT_CR);
+		if (temp < 0)
+			return temp;
+
+		temp |= (MII_M1145_RGMII_RX_DELAY | MII_M1145_RGMII_TX_DELAY);
+
+		err = phy_write(phydev, MII_M1145_PHY_EXT_CR, temp);
+		if (err < 0)
+			return err;
+
+		if (phydev->dev_flags & M1145_DEV_FLAGS_RESISTANCE) {
+			err = phy_write(phydev, 0x1d, 0x0012);
+			if (err < 0)
+				return err;
+
+			temp = phy_read(phydev, 0x1e);
+			if (temp < 0)
+				return temp;
+
+			temp &= 0xf03f;
+			temp |= 2 << 9;	/* 36 ohm */
+			temp |= 2 << 6;	/* 39 ohm */
+
+			err = phy_write(phydev, 0x1e, temp);
+			if (err < 0)
+				return err;
+
+			err = phy_write(phydev, 0x1d, 0x3);
+			if (err < 0)
+				return err;
+
+			err = phy_write(phydev, 0x1e, 0x8000);
+			if (err < 0)
+				return err;
+		}
+	}
+
+	return 0;
+}
 
 static struct phy_driver m88e1101_driver = {
-	.phy_id		= 0x01410c00,
-	.phy_id_mask	= 0xffffff00,
-	.name		= "Marvell 88E1101",
-	.features	= PHY_GBIT_FEATURES,
-	.flags		= PHY_HAS_INTERRUPT,
-	.config_aneg	= &marvell_config_aneg,
-	.read_status	= &genphy_read_status,
-	.ack_interrupt	= &marvell_ack_interrupt,
-	.config_intr	= &marvell_config_intr,
-	.driver 	= { .owner = THIS_MODULE,},
+	.phy_id = 0x01410c60,
+	.phy_id_mask = 0xfffffff0,
+	.name = "Marvell 88E1101",
+	.features = PHY_GBIT_FEATURES,
+	.flags = PHY_HAS_INTERRUPT,
+	.config_aneg = &marvell_config_aneg,
+	.read_status = &genphy_read_status,
+	.ack_interrupt = &marvell_ack_interrupt,
+	.config_intr = &marvell_config_intr,
+	.driver = {.owner = THIS_MODULE,},
+};
+
+static struct phy_driver m88e1111s_driver = {
+	.phy_id = 0x01410cc0,
+	.phy_id_mask = 0xfffffff0,
+	.name = "Marvell 88E1111",
+	.features = PHY_GBIT_FEATURES,
+	.flags = PHY_HAS_INTERRUPT,
+	.config_aneg = &marvell_config_aneg,
+	.read_status = &genphy_read_status,
+	.ack_interrupt = &marvell_ack_interrupt,
+	.config_intr = &marvell_config_intr,
+	.driver = {.owner = THIS_MODULE,},
+};
+
+static struct phy_driver m88e1145_driver = {
+	.phy_id = 0x01410cd0,
+	.phy_id_mask = 0xfffffff0,
+	.name = "Marvell 88E1145",
+	.features = PHY_GBIT_FEATURES,
+	.flags = PHY_HAS_INTERRUPT,
+	.config_init = &m88e1145_config_init,
+	.config_aneg = &marvell_config_aneg,
+	.read_status = &genphy_read_status,
+	.ack_interrupt = &marvell_ack_interrupt,
+	.config_intr = &marvell_config_intr,
+	.driver = {.owner = THIS_MODULE,},
 };
 
 static int __init marvell_init(void)
 {
-	return phy_driver_register(&m88e1101_driver);
+	int ret;
+
+	ret = phy_driver_register(&m88e1101_driver);
+	if (ret)
+		return ret;
+
+	ret = phy_driver_register(&m88e1111s_driver);
+	if (ret)
+		goto err1111s;
+
+	ret = phy_driver_register(&m88e1145_driver);
+	if (ret)
+		goto err1145;
+
+	return 0;
+
+      err1145:
+	phy_driver_unregister(&m88e1111s_driver);
+      err1111s:
+	phy_driver_unregister(&m88e1101_driver);
+	return ret;
 }
 
 static void __exit marvell_exit(void)
 {
 	phy_driver_unregister(&m88e1101_driver);
+	phy_driver_unregister(&m88e1111s_driver);
+	phy_driver_unregister(&m88e1145_driver);
 }
 
 module_init(marvell_init);
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index fdf45fd..7d5b6d1 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -138,7 +138,7 @@ void phy_prepare_link(struct phy_device *phydev,
  */
 struct phy_device * phy_connect(struct net_device *dev, const char *phy_id,
 		void (*handler)(struct net_device *), u32 flags,
-		u32 interface)
+		phy_interface_t interface)
 {
 	struct phy_device *phydev;
 
@@ -187,7 +187,7 @@ static int phy_compare_id(struct device *dev, void *data)
 }
 
 struct phy_device *phy_attach(struct net_device *dev,
-		const char *phy_id, u32 flags, u32 interface)
+		const char *phy_id, u32 flags, phy_interface_t interface)
 {
 	struct bus_type *bus = &mdio_bus_type;
 	struct phy_device *phydev;
diff --git a/drivers/net/sk98lin/skge.c b/drivers/net/sk98lin/skge.c
index 92d11b9..e94ab25 100644
--- a/drivers/net/sk98lin/skge.c
+++ b/drivers/net/sk98lin/skge.c
@@ -5188,6 +5188,9 @@ static struct pci_driver skge_driver = {
 
 static int __init skge_init(void)
 {
+	printk(KERN_NOTICE "sk98lin: driver has been replaced by the skge driver"
+	       " and is scheduled for removal\n");
+
 	return pci_register_driver(&skge_driver);
 }
 
diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
index f2ab3d5..52edbd7 100644
--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -49,7 +49,7 @@
 #include "sky2.h"
 
 #define DRV_NAME		"sky2"
-#define DRV_VERSION		"1.12"
+#define DRV_VERSION		"1.13"
 #define PFX			DRV_NAME " "
 
 /*
@@ -1742,13 +1742,6 @@ static void sky2_link_down(struct sky2_port *sky2)
 	reg &= ~(GM_GPCR_RX_ENA | GM_GPCR_TX_ENA);
 	gma_write16(hw, port, GM_GP_CTRL, reg);
 
-	if (sky2->flow_status == FC_RX) {
-		/* restore Asymmetric Pause bit */
-		gm_phy_write(hw, port, PHY_MARV_AUNE_ADV,
-			     gm_phy_read(hw, port, PHY_MARV_AUNE_ADV)
-			     | PHY_M_AN_ASP);
-	}
-
 	netif_carrier_off(sky2->netdev);
 	netif_stop_queue(sky2->netdev);
 
@@ -1773,10 +1766,10 @@ static int sky2_autoneg_done(struct sky2_port *sky2, u16 aux)
 {
 	struct sky2_hw *hw = sky2->hw;
 	unsigned port = sky2->port;
-	u16 lpa;
+	u16 advert, lpa;
 
+	advert = gm_phy_read(hw, port, PHY_MARV_AUNE_ADV);
 	lpa = gm_phy_read(hw, port, PHY_MARV_AUNE_LP);
-
 	if (lpa & PHY_M_AN_RF) {
 		printk(KERN_ERR PFX "%s: remote fault", sky2->netdev->name);
 		return -1;
@@ -1791,20 +1784,40 @@ static int sky2_autoneg_done(struct sky2_port *sky2, u16 aux)
 	sky2->speed = sky2_phy_speed(hw, aux);
 	sky2->duplex = (aux & PHY_M_PS_FULL_DUP) ? DUPLEX_FULL : DUPLEX_HALF;
 
-	/* Pause bits are offset (9..8) */
-	if (hw->chip_id == CHIP_ID_YUKON_XL
-	    || hw->chip_id == CHIP_ID_YUKON_EC_U
-	    || hw->chip_id == CHIP_ID_YUKON_EX)
-		aux >>= 6;
-
-	sky2->flow_status = sky2_flow(aux & PHY_M_PS_RX_P_EN,
-				      aux & PHY_M_PS_TX_P_EN);
+	/* Since the pause result bits seem to in different positions on
+	 * different chips. look at registers.
+	 */
+	if (!sky2_is_copper(hw)) {
+		/* Shift for bits in fiber PHY */
+		advert &= ~(ADVERTISE_PAUSE_CAP|ADVERTISE_PAUSE_ASYM);
+		lpa &= ~(LPA_PAUSE_CAP|LPA_PAUSE_ASYM);
+
+		if (advert & ADVERTISE_1000XPAUSE)
+			advert |= ADVERTISE_PAUSE_CAP;
+		if (advert & ADVERTISE_1000XPSE_ASYM)
+			advert |= ADVERTISE_PAUSE_ASYM;
+		if (lpa & LPA_1000XPAUSE)
+			lpa |= LPA_PAUSE_CAP;
+		if (lpa & LPA_1000XPAUSE_ASYM)
+			lpa |= LPA_PAUSE_ASYM;
+	}
+
+	sky2->flow_status = FC_NONE;
+	if (advert & ADVERTISE_PAUSE_CAP) {
+		if (lpa & LPA_PAUSE_CAP)
+			sky2->flow_status = FC_BOTH;
+		else if (advert & ADVERTISE_PAUSE_ASYM)
+			sky2->flow_status = FC_RX;
+	} else if (advert & ADVERTISE_PAUSE_ASYM) {
+		if ((lpa & LPA_PAUSE_CAP) && (lpa & LPA_PAUSE_ASYM))
+			sky2->flow_status = FC_TX;
+	}
 
 	if (sky2->duplex == DUPLEX_HALF && sky2->speed < SPEED_1000
 	    && !(hw->chip_id == CHIP_ID_YUKON_EC_U || hw->chip_id == CHIP_ID_YUKON_EX))
 		sky2->flow_status = FC_NONE;
 
-	if (aux & PHY_M_PS_RX_P_EN)
+	if (sky2->flow_status & FC_TX)
 		sky2_write8(hw, SK_REG(port, GMAC_CTRL), GMC_PAUSE_ON);
 	else
 		sky2_write8(hw, SK_REG(port, GMAC_CTRL), GMC_PAUSE_OFF);
@@ -1853,16 +1866,13 @@ out:
 	spin_unlock(&sky2->phy_lock);
 }
 
-
 /* Transmit timeout is only called if we are running, carrier is up
  * and tx queue is full (stopped).
- * Called with netif_tx_lock held.
  */
 static void sky2_tx_timeout(struct net_device *dev)
 {
 	struct sky2_port *sky2 = netdev_priv(dev);
 	struct sky2_hw *hw = sky2->hw;
-	u32 imask;
 
 	if (netif_msg_timer(sky2))
 		printk(KERN_ERR PFX "%s: tx timeout\n", dev->name);
@@ -1872,19 +1882,8 @@ static void sky2_tx_timeout(struct net_device *dev)
 	       sky2_read16(hw, sky2->port == 0 ? STAT_TXA1_RIDX : STAT_TXA2_RIDX),
 	       sky2_read16(hw, Q_ADDR(txqaddr[sky2->port], Q_DONE)));
 
-	imask = sky2_read32(hw, B0_IMSK);	/* block IRQ in hw */
-	sky2_write32(hw, B0_IMSK, 0);
-	sky2_read32(hw, B0_IMSK);
-
-	netif_poll_disable(hw->dev[0]);		/* stop NAPI poll */
-	synchronize_irq(hw->pdev->irq);
-
-	netif_start_queue(dev);			/* don't wakeup during flush */
-	sky2_tx_complete(sky2, sky2->tx_prod);	/* Flush transmit queue */
-
-	sky2_write32(hw, B0_IMSK, imask);
-
-	sky2_phy_reinit(sky2);			/* this clears flow control etc */
+	/* can't restart safely under softirq */
+	schedule_work(&hw->restart_work);
 }
 
 static int sky2_change_mtu(struct net_device *dev, int new_mtu)
@@ -2057,9 +2056,6 @@ static struct sk_buff *sky2_receive(struct net_device *dev,
 	if (!(status & GMR_FS_RX_OK))
 		goto resubmit;
 
-	if (length > dev->mtu + ETH_HLEN)
-		goto oversize;
-
 	if (length < copybreak)
 		skb = receive_copy(sky2, re, length);
 	else
@@ -2069,14 +2065,10 @@ resubmit:
 
 	return skb;
 
-oversize:
-	++sky2->net_stats.rx_over_errors;
-	goto resubmit;
-
 error:
 	++sky2->net_stats.rx_errors;
 	if (status & GMR_FS_RX_FF_OV) {
-		sky2->net_stats.rx_fifo_errors++;
+		sky2->net_stats.rx_over_errors++;
 		goto resubmit;
 	}
 
@@ -2638,6 +2630,49 @@ static void sky2_reset(struct sky2_hw *hw)
 	sky2_write8(hw, STAT_ISR_TIMER_CTRL, TIM_START);
 }
 
+static void sky2_restart(struct work_struct *work)
+{
+	struct sky2_hw *hw = container_of(work, struct sky2_hw, restart_work);
+	struct net_device *dev;
+	int i, err;
+
+	dev_dbg(&hw->pdev->dev, "restarting\n");
+
+	del_timer_sync(&hw->idle_timer);
+
+	rtnl_lock();
+	sky2_write32(hw, B0_IMSK, 0);
+	sky2_read32(hw, B0_IMSK);
+
+	netif_poll_disable(hw->dev[0]);
+
+	for (i = 0; i < hw->ports; i++) {
+		dev = hw->dev[i];
+		if (netif_running(dev))
+			sky2_down(dev);
+	}
+
+	sky2_reset(hw);
+	sky2_write32(hw, B0_IMSK, Y2_IS_BASE);
+	netif_poll_enable(hw->dev[0]);
+
+	for (i = 0; i < hw->ports; i++) {
+		dev = hw->dev[i];
+		if (netif_running(dev)) {
+			err = sky2_up(dev);
+			if (err) {
+				printk(KERN_INFO PFX "%s: could not restart %d\n",
+				       dev->name, err);
+				dev_close(dev);
+			}
+		}
+	}
+
+	sky2_idle_start(hw);
+
+	rtnl_unlock();
+}
+
 static inline u8 sky2_wol_supported(const struct sky2_hw *hw)
 {
 	return sky2_is_copper(hw) ? (WAKE_PHY | WAKE_MAGIC) : 0;
@@ -3600,6 +3635,8 @@ static int __devinit sky2_probe(struct pci_dev *pdev,
 	}
 
 	setup_timer(&hw->idle_timer, sky2_idle, (unsigned long) hw);
+	INIT_WORK(&hw->restart_work, sky2_restart);
+
 	sky2_idle_start(hw);
 
 	pci_set_drvdata(pdev, hw);
@@ -3636,6 +3673,8 @@ static void __devexit sky2_remove(struct pci_dev *pdev)
 
 	del_timer_sync(&hw->idle_timer);
 
+	flush_scheduled_work();
+
 	sky2_write32(hw, B0_IMSK, 0);
 	synchronize_irq(hw->pdev->irq);
 
diff --git a/drivers/net/sky2.h b/drivers/net/sky2.h
index 3b01895..ac24bdc 100644
--- a/drivers/net/sky2.h
+++ b/drivers/net/sky2.h
@@ -1589,7 +1589,7 @@ enum {
 
 	GMR_FS_ANY_ERR	= GMR_FS_RX_FF_OV | GMR_FS_CRC_ERR |
 			  GMR_FS_FRAGMENT | GMR_FS_LONG_ERR |
-		  	  GMR_FS_MII_ERR | GMR_FS_GOOD_FC | GMR_FS_BAD_FC |
+		  	  GMR_FS_MII_ERR | GMR_FS_BAD_FC |
 			  GMR_FS_UN_SIZE | GMR_FS_JABBER,
 };
 
@@ -1933,6 +1933,7 @@ struct sky2_hw {
 	dma_addr_t   	     st_dma;
 
 	struct timer_list    idle_timer;
+	struct work_struct   restart_work;
 	int		     msi;
 	wait_queue_head_t    msi_wait;
 };
diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index 61708cf..8897f53 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -26,7 +26,7 @@ config WAN
 # There is no way to detect a comtrol sv11 - force it modular for now.
 config HOSTESS_SV11
 	tristate "Comtrol Hostess SV-11 support"
-	depends on WAN && ISA && m && ISA_DMA_API
+	depends on WAN && ISA && m && ISA_DMA_API && INET
 	help
 	  Driver for Comtrol Hostess SV-11 network card which
 	  operates on low speed synchronous serial links at up to
diff --git a/drivers/net/wan/pc300too.c b/drivers/net/wan/pc300too.c
index bc156b5..aff05db 100644
--- a/drivers/net/wan/pc300too.c
+++ b/drivers/net/wan/pc300too.c
@@ -542,7 +542,7 @@ static int __init pc300_init_module(void)
 
 	CLOCK_BASE = use_crystal_clock ? 24576000 : pci_clock_freq;
 
-	return pci_module_init(&pc300_pci_driver);
+	return pci_register_driver(&pc300_pci_driver);
 }
 
 
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx.h b/drivers/net/wireless/bcm43xx/bcm43xx.h
index 3a064de..0e790ef 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx.h
+++ b/drivers/net/wireless/bcm43xx/bcm43xx.h
@@ -771,6 +771,7 @@ struct bcm43xx_private {
 	 * This is currently always BCM43xx_BUSTYPE_PCI
 	 */
 	u8 bustype;
+	u64 dma_mask;
 
 	u16 board_vendor;
 	u16 board_type;
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_dma.c b/drivers/net/wireless/bcm43xx/bcm43xx_dma.c
index 978ed09..6e0dc76 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_dma.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_dma.c
@@ -145,16 +145,14 @@ dma_addr_t map_descbuffer(struct bcm43xx_dmaring *ring,
 			  int tx)
 {
 	dma_addr_t dmaaddr;
+	int direction = PCI_DMA_FROMDEVICE;
 
-	if (tx) {
-		dmaaddr = dma_map_single(&ring->bcm->pci_dev->dev,
-					 buf, len,
-					 DMA_TO_DEVICE);
-	} else {
-		dmaaddr = dma_map_single(&ring->bcm->pci_dev->dev,
+	if (tx)
+		direction = PCI_DMA_TODEVICE;
+
+	dmaaddr = pci_map_single(ring->bcm->pci_dev,
 					 buf, len,
-					 DMA_FROM_DEVICE);
-	}
+					 direction);
 
 	return dmaaddr;
 }
@@ -166,13 +164,13 @@ void unmap_descbuffer(struct bcm43xx_dmaring *ring,
 		      int tx)
 {
 	if (tx) {
-		dma_unmap_single(&ring->bcm->pci_dev->dev,
+		pci_unmap_single(ring->bcm->pci_dev,
 				 addr, len,
-				 DMA_TO_DEVICE);
+				 PCI_DMA_TODEVICE);
 	} else {
-		dma_unmap_single(&ring->bcm->pci_dev->dev,
+		pci_unmap_single(ring->bcm->pci_dev,
 				 addr, len,
-				 DMA_FROM_DEVICE);
+				 PCI_DMA_FROMDEVICE);
 	}
 }
 
@@ -183,8 +181,8 @@ void sync_descbuffer_for_cpu(struct bcm43xx_dmaring *ring,
 {
 	assert(!ring->tx);
 
-	dma_sync_single_for_cpu(&ring->bcm->pci_dev->dev,
-				addr, len, DMA_FROM_DEVICE);
+	pci_dma_sync_single_for_cpu(ring->bcm->pci_dev,
+				    addr, len, PCI_DMA_FROMDEVICE);
 }
 
 static inline
@@ -194,8 +192,8 @@ void sync_descbuffer_for_device(struct bcm43xx_dmaring *ring,
 {
 	assert(!ring->tx);
 
-	dma_sync_single_for_device(&ring->bcm->pci_dev->dev,
-				   addr, len, DMA_FROM_DEVICE);
+	pci_dma_sync_single_for_cpu(ring->bcm->pci_dev,
+				    addr, len, PCI_DMA_TODEVICE);
 }
 
 /* Unmap and free a descriptor buffer. */
@@ -214,17 +212,53 @@ void free_descriptor_buffer(struct bcm43xx_dmaring *ring,
 
 static int alloc_ringmemory(struct bcm43xx_dmaring *ring)
 {
-	struct device *dev = &(ring->bcm->pci_dev->dev);
-
-	ring->descbase = dma_alloc_coherent(dev, BCM43xx_DMA_RINGMEMSIZE,
-					    &(ring->dmabase), GFP_KERNEL);
+	ring->descbase = pci_alloc_consistent(ring->bcm->pci_dev, BCM43xx_DMA_RINGMEMSIZE,
+					    &(ring->dmabase));
 	if (!ring->descbase) {
-		printk(KERN_ERR PFX "DMA ringmemory allocation failed\n");
-		return -ENOMEM;
+		/* Allocation may have failed due to pci_alloc_consistent
+		   insisting on use of GFP_DMA, which is more restrictive
+		   than necessary...  */
+		struct dma_desc *rx_ring;
+		dma_addr_t rx_ring_dma;
+
+		rx_ring = kzalloc(BCM43xx_DMA_RINGMEMSIZE, GFP_KERNEL);
+		if (!rx_ring)
+			goto out_err;
+
+		rx_ring_dma = pci_map_single(ring->bcm->pci_dev, rx_ring,
+					     BCM43xx_DMA_RINGMEMSIZE,
+					     PCI_DMA_BIDIRECTIONAL);
+
+		if (pci_dma_mapping_error(rx_ring_dma) ||
+		    rx_ring_dma + BCM43xx_DMA_RINGMEMSIZE > ring->bcm->dma_mask) {
+			/* Sigh... */
+			if (!pci_dma_mapping_error(rx_ring_dma))
+				pci_unmap_single(ring->bcm->pci_dev,
+						 rx_ring_dma, BCM43xx_DMA_RINGMEMSIZE,
+						 PCI_DMA_BIDIRECTIONAL);
+			rx_ring_dma = pci_map_single(ring->bcm->pci_dev,
+						 rx_ring, BCM43xx_DMA_RINGMEMSIZE,
+						 PCI_DMA_BIDIRECTIONAL);
+			if (pci_dma_mapping_error(rx_ring_dma) ||
+			    rx_ring_dma + BCM43xx_DMA_RINGMEMSIZE > ring->bcm->dma_mask) {
+				assert(0);
+				if (!pci_dma_mapping_error(rx_ring_dma))
+					pci_unmap_single(ring->bcm->pci_dev,
+							 rx_ring_dma, BCM43xx_DMA_RINGMEMSIZE,
+							 PCI_DMA_BIDIRECTIONAL);
+				goto out_err;
+			}
+                }
+
+                ring->descbase = rx_ring;
+                ring->dmabase = rx_ring_dma;
 	}
 	memset(ring->descbase, 0, BCM43xx_DMA_RINGMEMSIZE);
 
 	return 0;
+out_err:
+	printk(KERN_ERR PFX "DMA ringmemory allocation failed\n");
+	return -ENOMEM;
 }
 
 static void free_ringmemory(struct bcm43xx_dmaring *ring)
@@ -407,6 +441,29 @@ static int setup_rx_descbuffer(struct bcm43xx_dmaring *ring,
 	if (unlikely(!skb))
 		return -ENOMEM;
 	dmaaddr = map_descbuffer(ring, skb->data, ring->rx_buffersize, 0);
+	/* This hardware bug work-around adapted from the b44 driver.
+	   The chip may be unable to do PCI DMA to/from anything above 1GB */
+	if (pci_dma_mapping_error(dmaaddr) ||
+	    dmaaddr + ring->rx_buffersize > ring->bcm->dma_mask) {
+		/* This one has 30-bit addressing... */
+		if (!pci_dma_mapping_error(dmaaddr))
+			pci_unmap_single(ring->bcm->pci_dev,
+					 dmaaddr, ring->rx_buffersize,
+					 PCI_DMA_FROMDEVICE);
+		dev_kfree_skb_any(skb);
+		skb = __dev_alloc_skb(ring->rx_buffersize,GFP_DMA);
+		if (skb == NULL)
+			return -ENOMEM;
+		dmaaddr = pci_map_single(ring->bcm->pci_dev,
+					 skb->data, ring->rx_buffersize,
+					 PCI_DMA_FROMDEVICE);
+		if (pci_dma_mapping_error(dmaaddr) ||
+		    dmaaddr + ring->rx_buffersize > ring->bcm->dma_mask) {
+			assert(0);
+			dev_kfree_skb_any(skb);
+			return -ENOMEM;
+		}
+	}
 	meta->skb = skb;
 	meta->dmaaddr = dmaaddr;
 	skb->dev = ring->bcm->net_dev;
@@ -636,8 +693,10 @@ struct bcm43xx_dmaring * bcm43xx_setup_dmaring(struct bcm43xx_private *bcm,
 	err = dmacontroller_setup(ring);
 	if (err)
 		goto err_free_ringmemory;
+	return ring;
 
 out:
+	printk(KERN_ERR PFX "Error in bcm43xx_setup_dmaring\n");
 	return ring;
 
 err_free_ringmemory:
@@ -705,30 +764,16 @@ int bcm43xx_dma_init(struct bcm43xx_private *bcm)
 	struct bcm43xx_dmaring *ring;
 	int err = -ENOMEM;
 	int dma64 = 0;
-	u64 mask = bcm43xx_get_supported_dma_mask(bcm);
-	int nobits;
 
-	if (mask == DMA_64BIT_MASK) {
+	bcm->dma_mask = bcm43xx_get_supported_dma_mask(bcm);
+	if (bcm->dma_mask == DMA_64BIT_MASK)
 		dma64 = 1;
-		nobits = 64;
-	} else if (mask == DMA_32BIT_MASK)
-		nobits = 32;
-	else
-		nobits = 30;
-	err = pci_set_dma_mask(bcm->pci_dev, mask);
-	err |= pci_set_consistent_dma_mask(bcm->pci_dev, mask);
-	if (err) {
-#ifdef CONFIG_BCM43XX_PIO
-		printk(KERN_WARNING PFX "DMA not supported on this device."
-					" Falling back to PIO.\n");
-		bcm->__using_pio = 1;
-		return -ENOSYS;
-#else
-		printk(KERN_ERR PFX "FATAL: DMA not supported and PIO not configured. "
-				    "Please recompile the driver with PIO support.\n");
-		return -ENODEV;
-#endif /* CONFIG_BCM43XX_PIO */
-	}
+	err = pci_set_dma_mask(bcm->pci_dev, bcm->dma_mask);
+	if (err)
+		goto no_dma;
+	err = pci_set_consistent_dma_mask(bcm->pci_dev, bcm->dma_mask);
+	if (err)
+		goto no_dma;
 
 	/* setup TX DMA channels. */
 	ring = bcm43xx_setup_dmaring(bcm, 0, 1, dma64);
@@ -774,7 +819,9 @@ int bcm43xx_dma_init(struct bcm43xx_private *bcm)
 		dma->rx_ring3 = ring;
 	}
 
-	dprintk(KERN_INFO PFX "%d-bit DMA initialized\n", nobits);
+	dprintk(KERN_INFO PFX "%d-bit DMA initialized\n",
+		(bcm->dma_mask == DMA_64BIT_MASK) ? 64 :
+		(bcm->dma_mask == DMA_32BIT_MASK) ? 32 : 30);
 	err = 0;
 out:
 	return err;
@@ -800,7 +847,17 @@ err_destroy_tx1:
 err_destroy_tx0:
 	bcm43xx_destroy_dmaring(dma->tx_ring0);
 	dma->tx_ring0 = NULL;
-	goto out;
+no_dma:
+#ifdef CONFIG_BCM43XX_PIO
+	printk(KERN_WARNING PFX "DMA not supported on this device."
+				" Falling back to PIO.\n");
+	bcm->__using_pio = 1;
+	return -ENOSYS;
+#else
+	printk(KERN_ERR PFX "FATAL: DMA not supported and PIO not configured. "
+			    "Please recompile the driver with PIO support.\n");
+	return -ENODEV;
+#endif /* CONFIG_BCM43XX_PIO */
 }
 
 /* Generate a cookie for the TX header. */
@@ -905,6 +962,7 @@ static void dma_tx_fragment(struct bcm43xx_dmaring *ring,
 	struct bcm43xx_dmadesc_generic *desc;
 	struct bcm43xx_dmadesc_meta *meta;
 	dma_addr_t dmaaddr;
+	struct sk_buff *bounce_skb;
 
 	assert(skb_shinfo(skb)->nr_frags == 0);
 
@@ -924,9 +982,28 @@ static void dma_tx_fragment(struct bcm43xx_dmaring *ring,
 			       skb->len - sizeof(struct bcm43xx_txhdr),
 			       (cur_frag == 0),
 			       generate_cookie(ring, slot));
+	dmaaddr = map_descbuffer(ring, skb->data, skb->len, 1);
+	if (dma_mapping_error(dmaaddr) || dmaaddr + skb->len > ring->bcm->dma_mask) {
+		/* chip cannot handle DMA to/from > 1GB, use bounce buffer (copied from b44 driver) */
+		if (!dma_mapping_error(dmaaddr))
+			unmap_descbuffer(ring, dmaaddr, skb->len, 1);
+		bounce_skb = __dev_alloc_skb(skb->len, GFP_ATOMIC|GFP_DMA);
+		if (!bounce_skb)
+			return;
+		dmaaddr = map_descbuffer(ring, bounce_skb->data, bounce_skb->len, 1);
+		if (dma_mapping_error(dmaaddr) || dmaaddr + skb->len > ring->bcm->dma_mask) {
+			if (!dma_mapping_error(dmaaddr))
+				unmap_descbuffer(ring, dmaaddr, skb->len, 1);
+			dev_kfree_skb_any(bounce_skb);
+			assert(0);
+			return;
+		}
+		memcpy(skb_put(bounce_skb, skb->len), skb->data, skb->len);
+		dev_kfree_skb_any(skb);
+		skb = bounce_skb;
+	}
 
 	meta->skb = skb;
-	dmaaddr = map_descbuffer(ring, skb->data, skb->len, 1);
 	meta->dmaaddr = dmaaddr;
 
 	fill_descriptor(ring, desc, dmaaddr,
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_main.c b/drivers/net/wireless/bcm43xx/bcm43xx_main.c
index 23aaf1e..2e400aa 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -95,13 +95,9 @@ static int modparam_noleds;
 module_param_named(noleds, modparam_noleds, int, 0444);
 MODULE_PARM_DESC(noleds, "Turn off all LED activity");
 
-#ifdef CONFIG_BCM43XX_DEBUG
 static char modparam_fwpostfix[64];
 module_param_string(fwpostfix, modparam_fwpostfix, 64, 0444);
-MODULE_PARM_DESC(fwpostfix, "Postfix for .fw files. Useful for debugging.");
-#else
-# define modparam_fwpostfix  ""
-#endif /* CONFIG_BCM43XX_DEBUG*/
+MODULE_PARM_DESC(fwpostfix, "Postfix for .fw files. Useful for using multiple firmware image versions.");
 
 
 /* If you want to debug with just a single device, enable this,
@@ -2983,8 +2979,10 @@ static int bcm43xx_chipset_attach(struct bcm43xx_private *bcm)
 	err = bcm43xx_pctl_set_crystal(bcm, 1);
 	if (err)
 		goto out;
-	bcm43xx_pci_read_config16(bcm, PCI_STATUS, &pci_status);
-	bcm43xx_pci_write_config16(bcm, PCI_STATUS, pci_status & ~PCI_STATUS_SIG_TARGET_ABORT);
+	err = bcm43xx_pci_read_config16(bcm, PCI_STATUS, &pci_status);
+	if (err)
+		goto out;
+	err = bcm43xx_pci_write_config16(bcm, PCI_STATUS, pci_status & ~PCI_STATUS_SIG_TARGET_ABORT);
 
 out:
 	return err;
@@ -3796,12 +3794,18 @@ static int bcm43xx_attach_board(struct bcm43xx_private *bcm)
 	}
 	net_dev->base_addr = (unsigned long)bcm->mmio_addr;
 
-	bcm43xx_pci_read_config16(bcm, PCI_SUBSYSTEM_VENDOR_ID,
+	err = bcm43xx_pci_read_config16(bcm, PCI_SUBSYSTEM_VENDOR_ID,
 	                          &bcm->board_vendor);
-	bcm43xx_pci_read_config16(bcm, PCI_SUBSYSTEM_ID,
+	if (err)
+		goto err_iounmap;
+	err = bcm43xx_pci_read_config16(bcm, PCI_SUBSYSTEM_ID,
 	                          &bcm->board_type);
-	bcm43xx_pci_read_config16(bcm, PCI_REVISION_ID,
+	if (err)
+		goto err_iounmap;
+	err = bcm43xx_pci_read_config16(bcm, PCI_REVISION_ID,
 	                          &bcm->board_revision);
+	if (err)
+		goto err_iounmap;
 
 	err = bcm43xx_chipset_attach(bcm);
 	if (err)
@@ -3892,6 +3896,7 @@ err_pci_release:
 	pci_release_regions(pci_dev);
 err_pci_disable:
 	pci_disable_device(pci_dev);
+	printk(KERN_ERR PFX "Unable to attach board\n");
 	goto out;
 }
 
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_wx.c b/drivers/net/wireless/bcm43xx/bcm43xx_wx.c
index d2ca949..7b665e2 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_wx.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_wx.c
@@ -260,22 +260,22 @@ static int bcm43xx_wx_get_rangeparams(struct net_device *net_dev,
 	if (phy->type == BCM43xx_PHYTYPE_A ||
 	    phy->type == BCM43xx_PHYTYPE_G) {
 		range->num_bitrates = 8;
-		range->bitrate[i++] = IEEE80211_OFDM_RATE_6MB;
-		range->bitrate[i++] = IEEE80211_OFDM_RATE_9MB;
-		range->bitrate[i++] = IEEE80211_OFDM_RATE_12MB;
-		range->bitrate[i++] = IEEE80211_OFDM_RATE_18MB;
-		range->bitrate[i++] = IEEE80211_OFDM_RATE_24MB;
-		range->bitrate[i++] = IEEE80211_OFDM_RATE_36MB;
-		range->bitrate[i++] = IEEE80211_OFDM_RATE_48MB;
-		range->bitrate[i++] = IEEE80211_OFDM_RATE_54MB;
+		range->bitrate[i++] = IEEE80211_OFDM_RATE_6MB * 500000;
+		range->bitrate[i++] = IEEE80211_OFDM_RATE_9MB * 500000;
+		range->bitrate[i++] = IEEE80211_OFDM_RATE_12MB * 500000;
+		range->bitrate[i++] = IEEE80211_OFDM_RATE_18MB * 500000;
+		range->bitrate[i++] = IEEE80211_OFDM_RATE_24MB * 500000;
+		range->bitrate[i++] = IEEE80211_OFDM_RATE_36MB * 500000;
+		range->bitrate[i++] = IEEE80211_OFDM_RATE_48MB * 500000;
+		range->bitrate[i++] = IEEE80211_OFDM_RATE_54MB * 500000;
 	}
 	if (phy->type == BCM43xx_PHYTYPE_B ||
 	    phy->type == BCM43xx_PHYTYPE_G) {
 		range->num_bitrates += 4;
-		range->bitrate[i++] = IEEE80211_CCK_RATE_1MB;
-		range->bitrate[i++] = IEEE80211_CCK_RATE_2MB;
-		range->bitrate[i++] = IEEE80211_CCK_RATE_5MB;
-		range->bitrate[i++] = IEEE80211_CCK_RATE_11MB;
+		range->bitrate[i++] = IEEE80211_CCK_RATE_1MB * 500000;
+		range->bitrate[i++] = IEEE80211_CCK_RATE_2MB * 500000;
+		range->bitrate[i++] = IEEE80211_CCK_RATE_5MB * 500000;
+		range->bitrate[i++] = IEEE80211_CCK_RATE_11MB * 500000;
 	}
 
 	geo = ieee80211_get_geo(bcm->ieee);
@@ -285,7 +285,7 @@ static int bcm43xx_wx_get_rangeparams(struct net_device *net_dev,
 		if (j == IW_MAX_FREQUENCIES)
 			break;
 		range->freq[j].i = j + 1;
-		range->freq[j].m = geo->a[i].freq;//FIXME?
+		range->freq[j].m = geo->a[i].freq * 100000;
 		range->freq[j].e = 1;
 		j++;
 	}
@@ -293,7 +293,7 @@ static int bcm43xx_wx_get_rangeparams(struct net_device *net_dev,
 		if (j == IW_MAX_FREQUENCIES)
 			break;
 		range->freq[j].i = j + 1;
-		range->freq[j].m = geo->bg[i].freq;//FIXME?
+		range->freq[j].m = geo->bg[i].freq * 100000;
 		range->freq[j].e = 1;
 		j++;
 	}
diff --git a/drivers/net/wireless/ipw2100.c b/drivers/net/wireless/ipw2100.c
index b85857a..d0639a4 100644
--- a/drivers/net/wireless/ipw2100.c
+++ b/drivers/net/wireless/ipw2100.c
@@ -175,7 +175,7 @@ that only one external action is invoked at a time.
 
 /* Debugging stuff */
 #ifdef CONFIG_IPW2100_DEBUG
-#define CONFIG_IPW2100_RX_DEBUG	/* Reception debugging */
+#define IPW2100_RX_DEBUG	/* Reception debugging */
 #endif
 
 MODULE_DESCRIPTION(DRV_DESCRIPTION);
@@ -2239,7 +2239,7 @@ static void ipw2100_snapshot_free(struct ipw2100_priv *priv)
 	priv->snapshot[0] = NULL;
 }
 
-#ifdef CONFIG_IPW2100_DEBUG_C3
+#ifdef IPW2100_DEBUG_C3
 static int ipw2100_snapshot_alloc(struct ipw2100_priv *priv)
 {
 	int i;
@@ -2314,13 +2314,13 @@ static u32 ipw2100_match_buf(struct ipw2100_priv *priv, u8 * in_buf,
  * The size of the constructed ethernet
  *
  */
-#ifdef CONFIG_IPW2100_RX_DEBUG
+#ifdef IPW2100_RX_DEBUG
 static u8 packet_data[IPW_RX_NIC_BUFFER_LENGTH];
 #endif
 
 static void ipw2100_corruption_detected(struct ipw2100_priv *priv, int i)
 {
-#ifdef CONFIG_IPW2100_DEBUG_C3
+#ifdef IPW2100_DEBUG_C3
 	struct ipw2100_status *status = &priv->status_queue.drv[i];
 	u32 match, reg;
 	int j;
@@ -2342,7 +2342,7 @@ static void ipw2100_corruption_detected(struct ipw2100_priv *priv, int i)
 	}
 #endif
 
-#ifdef CONFIG_IPW2100_DEBUG_C3
+#ifdef IPW2100_DEBUG_C3
 	/* Halt the fimrware so we can get a good image */
 	write_register(priv->net_dev, IPW_REG_RESET_REG,
 		       IPW_AUX_HOST_RESET_REG_STOP_MASTER);
@@ -2413,7 +2413,7 @@ static void isr_rx(struct ipw2100_priv *priv, int i,
 
 	skb_put(packet->skb, status->frame_size);
 
-#ifdef CONFIG_IPW2100_RX_DEBUG
+#ifdef IPW2100_RX_DEBUG
 	/* Make a copy of the frame so we can dump it to the logs if
 	 * ieee80211_rx fails */
 	memcpy(packet_data, packet->skb->data,
@@ -2421,7 +2421,7 @@ static void isr_rx(struct ipw2100_priv *priv, int i,
 #endif
 
 	if (!ieee80211_rx(priv->ieee, packet->skb, stats)) {
-#ifdef CONFIG_IPW2100_RX_DEBUG
+#ifdef IPW2100_RX_DEBUG
 		IPW_DEBUG_DROP("%s: Non consumed packet:\n",
 			       priv->net_dev->name);
 		printk_buf(IPW_DL_DROP, packet_data, status->frame_size);
@@ -4912,7 +4912,7 @@ static int ipw2100_set_power_mode(struct ipw2100_priv *priv, int power_level)
 	else
 		priv->power_mode = IPW_POWER_ENABLED | power_level;
 
-#ifdef CONFIG_IPW2100_TX_POWER
+#ifdef IPW2100_TX_POWER
 	if (priv->port_type == IBSS && priv->adhoc_power != DFTL_IBSS_TX_POWER) {
 		/* Set beacon interval */
 		cmd.host_command = TX_POWER_INDEX;
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index a085241..4c5f78e 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -156,7 +156,7 @@ void zd_mac_clear(struct zd_mac *mac)
 static int reset_mode(struct zd_mac *mac)
 {
 	struct ieee80211_device *ieee = zd_mac_to_ieee80211(mac);
-	struct zd_ioreq32 ioreqs[3] = {
+	struct zd_ioreq32 ioreqs[] = {
 		{ CR_RX_FILTER, STA_RX_FILTER },
 		{ CR_SNIFFER_ON, 0U },
 	};
@@ -164,10 +164,9 @@ static int reset_mode(struct zd_mac *mac)
 	if (ieee->iw_mode == IW_MODE_MONITOR) {
 		ioreqs[0].value = 0xffffffff;
 		ioreqs[1].value = 0x1;
-		ioreqs[2].value = ENC_SNIFFER;
 	}
 
-	return zd_iowrite32a(&mac->chip, ioreqs, 3);
+	return zd_iowrite32a(&mac->chip, ioreqs, ARRAY_SIZE(ioreqs));
 }
 
 int zd_mac_open(struct net_device *netdev)
@@ -904,16 +903,21 @@ static int fill_ctrlset(struct zd_mac *mac,
 static int zd_mac_tx(struct zd_mac *mac, struct ieee80211_txb *txb, int pri)
 {
 	int i, r;
+	struct ieee80211_device *ieee = zd_mac_to_ieee80211(mac);
 
 	for (i = 0; i < txb->nr_frags; i++) {
 		struct sk_buff *skb = txb->fragments[i];
 
 		r = fill_ctrlset(mac, txb, i);
-		if (r)
+		if (r) {
+			ieee->stats.tx_dropped++;
 			return r;
+		}
 		r = zd_usb_tx(&mac->chip.usb, skb->data, skb->len);
-		if (r)
+		if (r) {
+			ieee->stats.tx_dropped++;
 			return r;
+		}
 	}
 
 	/* FIXME: shouldn't this be handled by the upper layers? */
@@ -1063,9 +1067,23 @@ static int fill_rx_stats(struct ieee80211_rx_stats *stats,
 
 	*pstatus = status = zd_tail(buffer, length, sizeof(struct rx_status));
 	if (status->frame_status & ZD_RX_ERROR) {
-		/* FIXME: update? */
+		struct ieee80211_device *ieee = zd_mac_to_ieee80211(mac);
+		ieee->stats.rx_errors++;
+		if (status->frame_status & ZD_RX_TIMEOUT_ERROR)
+			ieee->stats.rx_missed_errors++;
+		else if (status->frame_status & ZD_RX_FIFO_OVERRUN_ERROR)
+			ieee->stats.rx_fifo_errors++;
+		else if (status->frame_status & ZD_RX_DECRYPTION_ERROR)
+			ieee->ieee_stats.rx_discards_undecryptable++;
+		else if (status->frame_status & ZD_RX_CRC32_ERROR) {
+			ieee->stats.rx_crc_errors++;
+			ieee->ieee_stats.rx_fcs_errors++;
+		}
+		else if (status->frame_status & ZD_RX_CRC16_ERROR)
+			ieee->stats.rx_crc_errors++;
 		return -EINVAL;
 	}
+
 	memset(stats, 0, sizeof(struct ieee80211_rx_stats));
 	stats->len = length - (ZD_PLCP_HEADER_SIZE + IEEE80211_FCS_LEN +
 		               + sizeof(struct rx_status));
@@ -1094,14 +1112,16 @@ static void zd_mac_rx(struct zd_mac *mac, struct sk_buff *skb)
 	if (skb->len < ZD_PLCP_HEADER_SIZE + IEEE80211_1ADDR_LEN +
 	               IEEE80211_FCS_LEN + sizeof(struct rx_status))
 	{
-		dev_dbg_f(zd_mac_dev(mac), "Packet with length %u to small.\n",
-			 skb->len);
+		ieee->stats.rx_errors++;
+		ieee->stats.rx_length_errors++;
 		goto free_skb;
 	}
 
 	r = fill_rx_stats(&stats, &status, mac, skb->data, skb->len);
 	if (r) {
-		/* Only packets with rx errors are included here. */
+		/* Only packets with rx errors are included here.
+		 * The error stats have already been set in fill_rx_stats.
+		 */
 		goto free_skb;
 	}
 
@@ -1114,8 +1134,10 @@ static void zd_mac_rx(struct zd_mac *mac, struct sk_buff *skb)
 
 	r = filter_rx(ieee, skb->data, skb->len, &stats);
 	if (r <= 0) {
-		if (r < 0)
+		if (r < 0) {
+			ieee->stats.rx_errors++;
 			dev_dbg_f(zd_mac_dev(mac), "Error in packet.\n");
+		}
 		goto free_skb;
 	}
 
@@ -1146,7 +1168,9 @@ int zd_mac_rx_irq(struct zd_mac *mac, const u8 *buffer, unsigned int length)
 
 	skb = dev_alloc_skb(sizeof(struct zd_rt_hdr) + length);
 	if (!skb) {
+		struct ieee80211_device *ieee = zd_mac_to_ieee80211(mac);
 		dev_warn(zd_mac_dev(mac), "Could not allocate skb.\n");
+		ieee->stats.rx_dropped++;
 		return -ENOMEM;
 	}
 	skb_reserve(skb, sizeof(struct zd_rt_hdr));
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 75ef556..aac8a1c 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -313,6 +313,12 @@ out:
 
 static inline void handle_retry_failed_int(struct urb *urb)
 {
+	struct zd_usb *usb = urb->context;
+	struct zd_mac *mac = zd_usb_to_mac(usb);
+	struct ieee80211_device *ieee = zd_mac_to_ieee80211(mac);
+
+	ieee->stats.tx_errors++;
+	ieee->ieee_stats.tx_retry_limit_exceeded++;
 	dev_dbg_f(urb_dev(urb), "retry failed interrupt\n");
 }
 
@@ -487,6 +493,9 @@ static void handle_rx_packet(struct zd_usb *usb, const u8 *buffer,
 
 	if (length < sizeof(struct rx_length_info)) {
 		/* It's not a complete packet anyhow. */
+		struct ieee80211_device *ieee = zd_mac_to_ieee80211(mac);
+		ieee->stats.rx_errors++;
+		ieee->stats.rx_length_errors++;
 		return;
 	}
 	length_info = (struct rx_length_info *)
@@ -923,6 +932,8 @@ static int probe(struct usb_interface *intf, const struct usb_device_id *id)
 		goto error;
 	}
 
+	usb_reset_device(interface_to_usbdev(intf));
+
 	netdev = zd_netdev_alloc(intf);
 	if (netdev == NULL) {
 		r = -ENOMEM;
@@ -1024,6 +1035,7 @@ static int __init usb_init(void)
 
 	r = usb_register(&driver);
 	if (r) {
+		destroy_workqueue(zd_workqueue);
 		printk(KERN_ERR "%s usb_register() failed. Error number %d\n",
 		       driver.name, r);
 		return r;
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 182a96f..600308f 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2089,6 +2089,7 @@
 #define PCI_VENDOR_ID_PASEMI		0x1959
 
 #define PCI_VENDOR_ID_ATTANSIC		0x1969
+#define PCI_DEVICE_ID_ATTANSIC_L1	0x1048
 
 #define PCI_VENDOR_ID_JMICRON		0x197B
 #define PCI_DEVICE_ID_JMICRON_JMB360	0x2360
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 6189dc0..4cbb129 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -340,7 +340,7 @@ static struct attribute_group netstat_group = {
 	.attrs  = netstat_attrs,
 };
 
-#ifdef WIRELESS_EXT
+#ifdef CONFIG_WIRELESS_EXT
 /* helper function that does all the locking etc for wireless stats */
 static ssize_t wireless_show(struct device *d, char *buf,
 			     ssize_t (*format)(const struct iw_statistics *,
@@ -473,7 +473,7 @@ int netdev_register_sysfs(struct net_device *net)
 	if (net->get_stats)
 		*groups++ = &netstat_group;
 
-#ifdef WIRELESS_EXT
+#ifdef CONFIG_WIRELESS_EXT
 	if (net->wireless_handlers && net->wireless_handlers->get_wireless_stats)
 		*groups++ = &wireless_group;
 #endif
diff --git a/net/ieee80211/ieee80211_tx.c b/net/ieee80211/ieee80211_tx.c
index c55949e..0292d63 100644
--- a/net/ieee80211/ieee80211_tx.c
+++ b/net/ieee80211/ieee80211_tx.c
@@ -502,9 +502,6 @@ int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
 		if (host_encrypt)
 			ieee80211_encrypt_fragment(ieee, skb_frag, hdr_len);
 		else if (host_build_iv) {
-			struct ieee80211_crypt_data *crypt;
-
-			crypt = ieee->crypt[ieee->tx_keyidx];
 			atomic_inc(&crypt->refcnt);
 			if (crypt->ops->build_iv)
 				crypt->ops->build_iv(skb_frag, hdr_len,
