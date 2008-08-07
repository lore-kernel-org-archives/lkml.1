Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbYHGKlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbYHGKlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 06:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbYHGIut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 04:50:49 -0400
Received: from havoc.gtf.org ([69.61.125.42]:46488 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbYHGIuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 04:50:11 -0400
Date: Thu, 7 Aug 2008 04:50:09 -0400
From: Jeff Garzik <jeff@garzik.org>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] net driver updates
Message-ID: <20080807085009.GA31681@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rough summary:

* fixes

* additions of the variety where only a few lines are added, to support
  new hardware (forcedeth, netxen)

* a WAN update that got missed, and IMO should go in for 2.6.27.  This
  is addressing the complaint about too much stuff still using syncppp,
  so things get switched more to generic HDLC.  MUCH more typesafe, and
  links directly with struct net_device, rather than through opaque void
  pointers and syncppp-specific structs.

* bonding update with core bits previously ack'd by you

* that ethtool.h change increasing speed to 32 bits

Please pull from 'upstream-davem' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git upstream-davem

to receive the following updates:

 Documentation/DocBook/z8530book.tmpl           |   38 +-
 arch/sh/include/asm/sh_eth.h                   |   11 +
 drivers/char/pcmcia/synclink_cs.c              |    4 -
 drivers/char/synclink.c                        |    4 -
 drivers/char/synclink_gt.c                     |    5 -
 drivers/char/synclinkmp.c                      |    4 -
 drivers/net/3c523.c                            |    4 +-
 drivers/net/3c527.c                            |    9 +-
 drivers/net/3c59x.c                            |   14 +-
 drivers/net/8390.c                             |   13 +-
 drivers/net/8390p.c                            |   19 +-
 drivers/net/Kconfig                            |    5 +-
 drivers/net/atlx/atl1.c                        |   19 +-
 drivers/net/atp.c                              |    9 +-
 drivers/net/bonding/bond_3ad.c                 |    1 +
 drivers/net/bonding/bond_main.c                |  398 ++++++--------
 drivers/net/bonding/bond_sysfs.c               |    3 -
 drivers/net/de620.c                            |    7 -
 drivers/net/dm9000.c                           |    5 +
 drivers/net/e1000e/e1000.h                     |   31 +-
 drivers/net/e1000e/ethtool.c                   |   44 +-
 drivers/net/e1000e/netdev.c                    |  246 ++++-----
 drivers/net/e1000e/param.c                     |   31 +-
 drivers/net/eepro.c                            |    8 -
 drivers/net/eth16i.c                           |    1 -
 drivers/net/forcedeth.c                        |  110 +++--
 drivers/net/fs_enet/mac-fcc.c                  |    2 +-
 drivers/net/gianfar.c                          |    4 -
 drivers/net/hamradio/mkiss.c                   |    2 +-
 drivers/net/igb/e1000_82575.c                  |   72 +---
 drivers/net/igb/e1000_82575.h                  |    1 -
 drivers/net/igb/e1000_defines.h                |    1 +
 drivers/net/igb/e1000_hw.h                     |    1 -
 drivers/net/igb/e1000_mac.c                    |   84 +---
 drivers/net/igb/e1000_mac.h                    |    5 +-
 drivers/net/igb/e1000_regs.h                   |    3 -
 drivers/net/igb/igb_main.c                     |   30 +-
 drivers/net/lp486e.c                           |    2 -
 drivers/net/meth.c                             |    2 +-
 drivers/net/myri10ge/myri10ge.c                |    1 +
 drivers/net/myri10ge/myri10ge_mcp.h            |   52 ++-
 drivers/net/myri10ge/myri10ge_mcp_gen_header.h |    2 +-
 drivers/net/netxen/netxen_nic.h                |   41 ++-
 drivers/net/netxen/netxen_nic_ctx.c            |    9 +-
 drivers/net/netxen/netxen_nic_ethtool.c        |   35 +-
 drivers/net/netxen/netxen_nic_hdr.h            |   10 +
 drivers/net/netxen/netxen_nic_hw.c             |  103 +++--
 drivers/net/netxen/netxen_nic_hw.h             |   13 +-
 drivers/net/netxen/netxen_nic_init.c           |    5 +
 drivers/net/netxen/netxen_nic_main.c           |   99 ++--
 drivers/net/netxen/netxen_nic_niu.c            |   16 +-
 drivers/net/netxen/netxen_nic_phan_reg.h       |    4 +-
 drivers/net/ni5010.c                           |    1 -
 drivers/net/ni52.c                             |    2 +-
 drivers/net/qla3xxx.c                          |   23 +-
 drivers/net/qla3xxx.h                          |  105 ----
 drivers/net/sh_eth.c                           |   69 ++-
 drivers/net/sh_eth.h                           |   22 +-
 drivers/net/sky2.c                             |  103 +----
 drivers/net/sky2.h                             |    2 -
 drivers/net/sun3_82586.c                       |    7 +-
 drivers/net/usb/pegasus.c                      |   21 +
 drivers/net/via-velocity.c                     |  301 ++++++-----
 drivers/net/via-velocity.h                     |   50 +-
 drivers/net/wan/Kconfig                        |   15 +-
 drivers/net/wan/Makefile                       |   11 +-
 drivers/net/wan/cosa.c                         |  293 +++++------
 drivers/net/wan/dscc4.c                        |    1 -
 drivers/net/wan/farsync.c                      |    5 +-
 drivers/net/wan/farsync.h                      |    6 -
 drivers/net/wan/hdlc.c                         |   25 +-
 drivers/net/wan/hdlc_cisco.c                   |   29 +-
 drivers/net/wan/hdlc_fr.c                      |   19 +-
 drivers/net/wan/hdlc_ppp.c                     |   15 +-
 drivers/net/wan/hdlc_raw.c                     |   15 +-
 drivers/net/wan/hdlc_raw_eth.c                 |   17 +-
 drivers/net/wan/hdlc_x25.c                     |   17 +-
 drivers/net/wan/hostess_sv11.c                 |  382 ++++++--------
 drivers/net/wan/lmc/lmc.h                      |   11 +-
 drivers/net/wan/lmc/lmc_debug.c                |    7 +-
 drivers/net/wan/lmc/lmc_debug.h                |    6 +-
 drivers/net/wan/lmc/lmc_ioctl.h                |    2 +-
 drivers/net/wan/lmc/lmc_main.c                 |  672 +++++++++++-------------
 drivers/net/wan/lmc/lmc_media.c                |   66 +--
 drivers/net/wan/lmc/lmc_proto.c                |  146 +-----
 drivers/net/wan/lmc/lmc_proto.h                |   14 +-
 drivers/net/wan/lmc/lmc_var.h                  |  360 +++++--------
 drivers/net/wan/pc300.h                        |  228 ++++-----
 drivers/net/wan/pc300_drv.c                    |  146 +++---
 drivers/net/wan/sealevel.c                     |  361 +++++--------
 drivers/net/wan/syncppp.c                      |    9 -
 drivers/net/wan/z85230.c                       |  193 +++----
 drivers/net/wan/z85230.h                       |   10 +-
 drivers/net/wireless/orinoco.c                 |    7 -
 drivers/net/wireless/wavelan.c                 |    3 -
 drivers/net/wireless/wavelan_cs.c              |    6 -
 drivers/net/xen-netfront.c                     |    2 +-
 include/linux/dm9000.h                         |    1 +
 include/linux/ethtool.h                        |   17 +-
 include/net/syncppp.h                          |    2 -
 net/core/dev.c                                 |   35 +-
 net/wanrouter/wanmain.c                        |   27 -
 102 files changed, 2327 insertions(+), 3202 deletions(-)
 create mode 100644 arch/sh/include/asm/sh_eth.h

Adrian Bunk (1):
      remove bogus CONFIG_GFAR_NAPI's

Alexander Duyck (6):
      igb: fix comments
      igb: fix null pointer dereference seen with fiber NICs
      igb: fixes 82576 serdes init to correctly support manual flow control changes
      igb: correct issue of set_mta member of mac.ops not being populated
      igb: remove three redundant functions left in the code
      igb: remove igb_init_managability as it is deprecated

Andrew Morton (1):
      drivers/net/netxen/netxen_nic_hw.c: fix printk warnings

Auke Kok (1):
      e1000e: perform basic 82573 EEPROM checks for known issues

Ayaz Abdulla (4):
      forcedeth: fix rx error policy
      forcedeth: add new tx stat counters
      forcedeth: add jumbo frame support for mcp79
      forcedeth: add tx pause limit

Ben Collins (1):
      pegasus: add blacklist support to fix Belkin bluetooth dongle.

Brandon Philips (1):
      ethtool: Expand ethtool_cmd.speed to 32 bits

Brice Goglin (2):
      myri10ge: update firmware headers
      myri10ge: set 64bits consistent DMA mask

Bruce Allan (1):
      e1000e: remove inapplicable test for ioport

Dhananjay Phadke (5):
      netxen: fix link status, link speed
      netxen: add new board types
      netxen: fix legacy interrupts
      netxen: fix cmd ring init
      netxen: fix promisc mode, mtu setting

Eduardo Habkost (1):
      xen-netfront: use netif_start_queue() on xennet_open()

Eugene Teo (1):
      hamradio: add missing sanity check to tty operation

Francois Romieu (2):
      via-velocity: separated struct allow wholesale copy during MTU changes.
      via-velocity: velocity_init_{rd/tx}_ring use kcalloc(..., GFP_KERNEL).

Gustavo F. Padovan (3):
      drivers/net: Remove 'return' of void function NS8390p_init()
      drivers/net: coding styles fixes to drivers/net/8390p.c
      drivers/net: coding styles fixes to drivers/net/8390.c

Jay Cliburn (1):
      atl1: deal with hardware rx checksum bug

Jay Vosburgh (1):
      bonding: refactor mii monitor

Jeff Kirsher (1):
      e1000e: convert ndev_ printks to something smaller

Jesse Brandeburg (1):
      e1000e: fix drv load issues

Joe Eykholt (3):
      net/core: Uninline skb_bond().
      net/core: Allow certain receives on inactive slave.
      net/core: Allow receive on active slaves.

Krzysztof Halasa (1):
      WAN: remove extra help text from HDLC_PPP config option

Krzysztof Hałasa (15):
      WAN: cosmetic changes to generic HDLC
      Remove bogus dosyncppp variable from synclink drivers.
      Remove bogus variables from syncppp.[ch]
      Remove dead code from wanmain.c, CONFIG_WANPIPE_MULTPPP doesn't exist
      wanmain.c doesn't need syncppp.h
      WAN: Remove unneeded "#include <net/syncppp.h>"
      WAN: Remove dead code from PC300 driver, part #1
      WAN: Remove dead code from PC300 driver, part #2
      WAN: Convert PC300 driver to use normal u8/u16/u32 types
      WAN: farsync driver no longer uses syncppp.c directly
      WAN: Port COSA driver to generic HDLC.
      WAN: Convert Zilog-based drivers to generic HDLC
      WAN: Port LMC driver to generic HDLC
      WAN: don't mention syncppp in z8530 DocBook.
      WAN: Use u32 type instead of u_int32_t in LMC driver.

Laurent Pinchart (1):
      dm9000: Support MAC address setting through platform data.

Li Yang (1):
      net/fs_enet: remove redundant messages for performance

Moni Shoua (1):
      bonding: Don't destroy bonding master when removing slave via sysfs

Ron Mercer (4):
      qla3xxx: fix: Remove unused set_multicast function.
      qla3xxx: fix: Fix IFF_MULTICAST setting.
      qla3xxx: cleanup: Remove some unused defined constants in the header file.
      qla3xxx: cleanup: Remove some unused structure definitions and structure elements.

Stephen Hemminger (2):
      sky2: fix PM related regressions
      3c59x: use netdev_alloc_skb

Thomas Bogendoerfer (1):
      METH: fix MAC address setup

Wang Chen (1):
      [netdrvr] Drivers should not set IFF_* flag themselves

Yoshinori Sato (1):
      [netdrvr] sh_eth: Add SH7619 support

root (1):
      qla3xxx: driver version change.

diff --git a/Documentation/DocBook/z8530book.tmpl b/Documentation/DocBook/z8530book.tmpl
index 42c75ba..a42a8a4 100644
--- a/Documentation/DocBook/z8530book.tmpl
+++ b/Documentation/DocBook/z8530book.tmpl
@@ -69,12 +69,6 @@
 	device to be used as both a tty interface and as a synchronous 
 	controller is a project for Linux post the 2.4 release
   </para>
-  <para>
-	The support code handles most common card configurations and
-	supports running both Cisco HDLC and Synchronous PPP. With extra
-	glue the frame relay and X.25 protocols can also be used with this
-	driver.
-  </para>
   </chapter>
   
   <chapter id="Driver_Modes">
@@ -179,35 +173,27 @@
   <para>
 	If you wish to use the network interface facilities of the driver,
 	then you need to attach a network device to each channel that is
-	present and in use. In addition to use the SyncPPP and Cisco HDLC
+	present and in use. In addition to use the generic HDLC
 	you need to follow some additional plumbing rules. They may seem 
 	complex but a look at the example hostess_sv11 driver should
 	reassure you.
   </para>
   <para>
 	The network device used for each channel should be pointed to by
-	the netdevice field of each channel. The dev-&gt; priv field of the
+	the netdevice field of each channel. The hdlc-&gt; priv field of the
 	network device points to your private data - you will need to be
-	able to find your ppp device from this. In addition to use the
-	sync ppp layer the private data must start with a void * pointer
-	to the syncppp structures.
+	able to find your private data from this.
   </para>
   <para>
 	The way most drivers approach this particular problem is to
 	create a structure holding the Z8530 device definition and
-	put that and the syncppp pointer into the private field of
-	the network device. The network device fields of the channels
-	then point back to the network devices. The ppp_device can also
-	be put in the private structure conveniently.
+	put that into the private field of the network device. The
+	network device fields of the channels then point back to the
+	network devices.
   </para>
   <para>
-	If you wish to use the synchronous ppp then you need to attach
-	the syncppp layer to the network device. You should do this before
-	you register the network device. The
-	<function>sppp_attach</function> requires that the first void *
-	pointer in your private data is pointing to an empty struct
-	ppp_device. The function fills in the initial data for the
-	ppp/hdlc layer.
+	If you wish to use the generic HDLC then you need to register
+	the HDLC device.
   </para>
   <para>
 	Before you register your network device you will also need to
@@ -314,10 +300,10 @@
 	buffer in sk_buff format and queues it for transmission. The
 	caller must provide the entire packet with the exception of the
 	bitstuffing and CRC. This is normally done by the caller via
-	the syncppp interface layer. It returns 0 if the buffer has been 
-        queued and non zero values  for queue full. If the function accepts 
-	the buffer it becomes property of the Z8530 layer and the caller 
-	should not free it. 
+	the generic HDLC interface layer. It returns 0 if the buffer has been
+	queued and non zero values for queue full. If the function accepts
+	the buffer it becomes property of the Z8530 layer and the caller
+	should not free it.
   </para>
   <para>
 	The function <function>z8530_get_stats</function> returns a pointer
diff --git a/arch/sh/include/asm/sh_eth.h b/arch/sh/include/asm/sh_eth.h
new file mode 100644
index 0000000..bb83258
--- /dev/null
+++ b/arch/sh/include/asm/sh_eth.h
@@ -0,0 +1,11 @@
+#ifndef __ASM_SH_ETH_H__
+#define __ASM_SH_ETH_H__
+
+enum {EDMAC_LITTLE_ENDIAN, EDMAC_BIG_ENDIAN};
+
+struct sh_eth_plat_data {
+	int phy;
+	int edmac_endian;
+};
+
+#endif
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index d1fceab..c240562 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -232,7 +232,6 @@ typedef struct _mgslpc_info {
 
 	/* SPPP/Cisco HDLC device parts */
 	int netcount;
-	int dosyncppp;
 	spinlock_t netlock;
 
 #if SYNCLINK_GENERIC_HDLC
@@ -459,13 +458,11 @@ static int ttymajor=0;
 
 static int debug_level = 0;
 static int maxframe[MAX_DEVICE_COUNT] = {0,};
-static int dosyncppp[MAX_DEVICE_COUNT] = {1,1,1,1};
 
 module_param(break_on_load, bool, 0);
 module_param(ttymajor, int, 0);
 module_param(debug_level, int, 0);
 module_param_array(maxframe, int, NULL, 0);
-module_param_array(dosyncppp, int, NULL, 0);
 
 MODULE_LICENSE("GPL");
 
@@ -2915,7 +2912,6 @@ static void mgslpc_add_device(MGSLPC_INFO *info)
 	if (info->line < MAX_DEVICE_COUNT) {
 		if (maxframe[info->line])
 			info->max_frame_size = maxframe[info->line];
-		info->dosyncppp = dosyncppp[info->line];
 	}
 
 	mgslpc_device_count++;
diff --git a/drivers/char/synclink.c b/drivers/char/synclink.c
index ef6706f..500f517 100644
--- a/drivers/char/synclink.c
+++ b/drivers/char/synclink.c
@@ -304,7 +304,6 @@ struct mgsl_struct {
 
 	/* generic HDLC device parts */
 	int netcount;
-	int dosyncppp;
 	spinlock_t netlock;
 
 #if SYNCLINK_GENERIC_HDLC
@@ -868,7 +867,6 @@ static int irq[MAX_ISA_DEVICES];
 static int dma[MAX_ISA_DEVICES];
 static int debug_level;
 static int maxframe[MAX_TOTAL_DEVICES];
-static int dosyncppp[MAX_TOTAL_DEVICES];
 static int txdmabufs[MAX_TOTAL_DEVICES];
 static int txholdbufs[MAX_TOTAL_DEVICES];
 	
@@ -879,7 +877,6 @@ module_param_array(irq, int, NULL, 0);
 module_param_array(dma, int, NULL, 0);
 module_param(debug_level, int, 0);
 module_param_array(maxframe, int, NULL, 0);
-module_param_array(dosyncppp, int, NULL, 0);
 module_param_array(txdmabufs, int, NULL, 0);
 module_param_array(txholdbufs, int, NULL, 0);
 
@@ -4258,7 +4255,6 @@ static void mgsl_add_device( struct mgsl_struct *info )
 	if (info->line < MAX_TOTAL_DEVICES) {
 		if (maxframe[info->line])
 			info->max_frame_size = maxframe[info->line];
-		info->dosyncppp = dosyncppp[info->line];
 
 		if (txdmabufs[info->line]) {
 			info->num_tx_dma_buffers = txdmabufs[info->line];
diff --git a/drivers/char/synclink_gt.c b/drivers/char/synclink_gt.c
index 3e90589..509c89a 100644
--- a/drivers/char/synclink_gt.c
+++ b/drivers/char/synclink_gt.c
@@ -128,17 +128,14 @@ static int slgt_device_count;
 static int ttymajor;
 static int debug_level;
 static int maxframe[MAX_DEVICES];
-static int dosyncppp[MAX_DEVICES];
 
 module_param(ttymajor, int, 0);
 module_param(debug_level, int, 0);
 module_param_array(maxframe, int, NULL, 0);
-module_param_array(dosyncppp, int, NULL, 0);
 
 MODULE_PARM_DESC(ttymajor, "TTY major device number override: 0=auto assigned");
 MODULE_PARM_DESC(debug_level, "Debug syslog output: 0=disabled, 1 to 5=increasing detail");
 MODULE_PARM_DESC(maxframe, "Maximum frame size used by device (4096 to 65535)");
-MODULE_PARM_DESC(dosyncppp, "Enable synchronous net device, 0=disable 1=enable");
 
 /*
  * tty support and callbacks
@@ -349,7 +346,6 @@ struct slgt_info {
 	/* SPPP/Cisco HDLC device parts */
 
 	int netcount;
-	int dosyncppp;
 	spinlock_t netlock;
 #if SYNCLINK_GENERIC_HDLC
 	struct net_device *netdev;
@@ -3405,7 +3401,6 @@ static void add_device(struct slgt_info *info)
 	if (info->line < MAX_DEVICES) {
 		if (maxframe[info->line])
 			info->max_frame_size = maxframe[info->line];
-		info->dosyncppp = dosyncppp[info->line];
 	}
 
 	slgt_device_count++;
diff --git a/drivers/char/synclinkmp.c b/drivers/char/synclinkmp.c
index c0490cb..6bdb44f 100644
--- a/drivers/char/synclinkmp.c
+++ b/drivers/char/synclinkmp.c
@@ -270,7 +270,6 @@ typedef struct _synclinkmp_info {
 
 	/* SPPP/Cisco HDLC device parts */
 	int netcount;
-	int dosyncppp;
 	spinlock_t netlock;
 
 #if SYNCLINK_GENERIC_HDLC
@@ -469,13 +468,11 @@ static int ttymajor = 0;
  */
 static int debug_level = 0;
 static int maxframe[MAX_DEVICES] = {0,};
-static int dosyncppp[MAX_DEVICES] = {0,};
 
 module_param(break_on_load, bool, 0);
 module_param(ttymajor, int, 0);
 module_param(debug_level, int, 0);
 module_param_array(maxframe, int, NULL, 0);
-module_param_array(dosyncppp, int, NULL, 0);
 
 static char *driver_name = "SyncLink MultiPort driver";
 static char *driver_version = "$Revision: 4.38 $";
@@ -3752,7 +3749,6 @@ static void add_device(SLMP_INFO *info)
 	if (info->line < MAX_DEVICES) {
 		if (maxframe[info->line])
 			info->max_frame_size = maxframe[info->line];
-		info->dosyncppp = dosyncppp[info->line];
 	}
 
 	synclinkmp_device_count++;
diff --git a/drivers/net/3c523.c b/drivers/net/3c523.c
index dc6e474..e2ce41d 100644
--- a/drivers/net/3c523.c
+++ b/drivers/net/3c523.c
@@ -640,10 +640,8 @@ static int init586(struct net_device *dev)
 	cfg_cmd->time_low = 0x00;
 	cfg_cmd->time_high = 0xf2;
 	cfg_cmd->promisc = 0;
-	if (dev->flags & (IFF_ALLMULTI | IFF_PROMISC)) {
+	if (dev->flags & (IFF_ALLMULTI | IFF_PROMISC))
 		cfg_cmd->promisc = 1;
-		dev->flags |= IFF_PROMISC;
-	}
 	cfg_cmd->carr_coll = 0x00;
 
 	p->scb->cbl_offset = make16(cfg_cmd);
diff --git a/drivers/net/3c527.c b/drivers/net/3c527.c
index 6aca0c6..abc84f7 100644
--- a/drivers/net/3c527.c
+++ b/drivers/net/3c527.c
@@ -1521,14 +1521,11 @@ static void do_mc32_set_multicast_list(struct net_device *dev, int retry)
 	struct mc32_local *lp = netdev_priv(dev);
 	u16 filt = (1<<2); /* Save Bad Packets, for stats purposes */
 
-	if (dev->flags&IFF_PROMISC)
+	if ((dev->flags&IFF_PROMISC) ||
+	    (dev->flags&IFF_ALLMULTI) ||
+	    dev->mc_count > 10)
 		/* Enable promiscuous mode */
 		filt |= 1;
-	else if((dev->flags&IFF_ALLMULTI) || dev->mc_count > 10)
-	{
-		dev->flags|=IFF_PROMISC;
-		filt |= 1;
-	}
 	else if(dev->mc_count)
 	{
 		unsigned char block[62];
diff --git a/drivers/net/3c59x.c b/drivers/net/3c59x.c
index 8db4e6b..491ee16 100644
--- a/drivers/net/3c59x.c
+++ b/drivers/net/3c59x.c
@@ -1692,12 +1692,14 @@ vortex_open(struct net_device *dev)
 			vp->rx_ring[i].next = cpu_to_le32(vp->rx_ring_dma + sizeof(struct boom_rx_desc) * (i+1));
 			vp->rx_ring[i].status = 0;	/* Clear complete bit. */
 			vp->rx_ring[i].length = cpu_to_le32(PKT_BUF_SZ | LAST_FRAG);
-			skb = dev_alloc_skb(PKT_BUF_SZ);
+
+			skb = __netdev_alloc_skb(dev, PKT_BUF_SZ + NET_IP_ALIGN,
+						 GFP_KERNEL);
 			vp->rx_skbuff[i] = skb;
 			if (skb == NULL)
 				break;			/* Bad news!  */
-			skb->dev = dev;			/* Mark as being used by this device. */
-			skb_reserve(skb, 2);	/* Align IP on 16 byte boundaries */
+
+			skb_reserve(skb, NET_IP_ALIGN);	/* Align IP on 16 byte boundaries */
 			vp->rx_ring[i].addr = cpu_to_le32(pci_map_single(VORTEX_PCI(vp), skb->data, PKT_BUF_SZ, PCI_DMA_FROMDEVICE));
 		}
 		if (i != RX_RING_SIZE) {
@@ -2538,7 +2540,7 @@ boomerang_rx(struct net_device *dev)
 		struct sk_buff *skb;
 		entry = vp->dirty_rx % RX_RING_SIZE;
 		if (vp->rx_skbuff[entry] == NULL) {
-			skb = dev_alloc_skb(PKT_BUF_SZ);
+			skb = netdev_alloc_skb(dev, PKT_BUF_SZ + NET_IP_ALIGN);
 			if (skb == NULL) {
 				static unsigned long last_jif;
 				if (time_after(jiffies, last_jif + 10 * HZ)) {
@@ -2549,8 +2551,8 @@ boomerang_rx(struct net_device *dev)
 					mod_timer(&vp->rx_oom_timer, RUN_AT(HZ * 1));
 				break;			/* Bad news!  */
 			}
-			skb->dev = dev;			/* Mark as being used by this device. */
-			skb_reserve(skb, 2);	/* Align IP on 16 byte boundaries */
+
+			skb_reserve(skb, NET_IP_ALIGN);
 			vp->rx_ring[entry].addr = cpu_to_le32(pci_map_single(VORTEX_PCI(vp), skb->data, PKT_BUF_SZ, PCI_DMA_FROMDEVICE));
 			vp->rx_skbuff[entry] = skb;
 		}
diff --git a/drivers/net/8390.c b/drivers/net/8390.c
index dc5d258..f72a2e8 100644
--- a/drivers/net/8390.c
+++ b/drivers/net/8390.c
@@ -9,42 +9,39 @@ int ei_open(struct net_device *dev)
 {
 	return __ei_open(dev);
 }
+EXPORT_SYMBOL(ei_open);
 
 int ei_close(struct net_device *dev)
 {
 	return __ei_close(dev);
 }
+EXPORT_SYMBOL(ei_close);
 
 irqreturn_t ei_interrupt(int irq, void *dev_id)
 {
 	return __ei_interrupt(irq, dev_id);
 }
+EXPORT_SYMBOL(ei_interrupt);
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
 void ei_poll(struct net_device *dev)
 {
 	__ei_poll(dev);
 }
+EXPORT_SYMBOL(ei_poll);
 #endif
 
 struct net_device *__alloc_ei_netdev(int size)
 {
 	return ____alloc_ei_netdev(size);
 }
+EXPORT_SYMBOL(__alloc_ei_netdev);
 
 void NS8390_init(struct net_device *dev, int startp)
 {
 	__NS8390_init(dev, startp);
 }
-
-EXPORT_SYMBOL(ei_open);
-EXPORT_SYMBOL(ei_close);
-EXPORT_SYMBOL(ei_interrupt);
-#ifdef CONFIG_NET_POLL_CONTROLLER
-EXPORT_SYMBOL(ei_poll);
-#endif
 EXPORT_SYMBOL(NS8390_init);
-EXPORT_SYMBOL(__alloc_ei_netdev);
 
 #if defined(MODULE)
 
diff --git a/drivers/net/8390p.c b/drivers/net/8390p.c
index 71f1988..4c6eea4 100644
--- a/drivers/net/8390p.c
+++ b/drivers/net/8390p.c
@@ -4,9 +4,9 @@ static const char version[] =
     "8390p.c:v1.10cvs 9/23/94 Donald Becker (becker@cesdis.gsfc.nasa.gov)\n";
 
 #define ei_inb(_p)	inb(_p)
-#define ei_outb(_v,_p)	outb(_v,_p)
+#define ei_outb(_v, _p)	outb(_v, _p)
 #define ei_inb_p(_p)	inb_p(_p)
-#define ei_outb_p(_v,_p) outb_p(_v,_p)
+#define ei_outb_p(_v, _p) outb_p(_v, _p)
 
 #include "lib8390.c"
 
@@ -14,42 +14,39 @@ int eip_open(struct net_device *dev)
 {
 	return __ei_open(dev);
 }
+EXPORT_SYMBOL(eip_open);
 
 int eip_close(struct net_device *dev)
 {
 	return __ei_close(dev);
 }
+EXPORT_SYMBOL(eip_close);
 
 irqreturn_t eip_interrupt(int irq, void *dev_id)
 {
 	return __ei_interrupt(irq, dev_id);
 }
+EXPORT_SYMBOL(eip_interrupt);
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
 void eip_poll(struct net_device *dev)
 {
 	__ei_poll(dev);
 }
+EXPORT_SYMBOL(eip_poll);
 #endif
 
 struct net_device *__alloc_eip_netdev(int size)
 {
 	return ____alloc_ei_netdev(size);
 }
+EXPORT_SYMBOL(__alloc_eip_netdev);
 
 void NS8390p_init(struct net_device *dev, int startp)
 {
-	return __NS8390_init(dev, startp);
+	__NS8390_init(dev, startp);
 }
-
-EXPORT_SYMBOL(eip_open);
-EXPORT_SYMBOL(eip_close);
-EXPORT_SYMBOL(eip_interrupt);
-#ifdef CONFIG_NET_POLL_CONTROLLER
-EXPORT_SYMBOL(eip_poll);
-#endif
 EXPORT_SYMBOL(NS8390p_init);
-EXPORT_SYMBOL(__alloc_eip_netdev);
 
 #if defined(MODULE)
 
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 8a03875..4b4cb2b 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -510,14 +510,15 @@ config STNIC
 config SH_ETH
 	tristate "Renesas SuperH Ethernet support"
 	depends on SUPERH && \
-		(CPU_SUBTYPE_SH7710 || CPU_SUBTYPE_SH7712 || CPU_SUBTYPE_SH7763)
+		(CPU_SUBTYPE_SH7710 || CPU_SUBTYPE_SH7712 || CPU_SUBTYPE_SH7763 || \
+		 CPU_SUBTYPE_SH7619)
 	select CRC32
 	select MII
 	select MDIO_BITBANG
 	select PHYLIB
 	help
 	  Renesas SuperH Ethernet device driver.
-	  This driver support SH7710, SH7712 and SH7763.
+	  This driver support SH7710, SH7712, SH7763 and SH7619.
 
 config SUNLANCE
 	tristate "Sun LANCE support"
diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index f12e3d1..e6a7bb7 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -1790,6 +1790,17 @@ static void atl1_rx_checksum(struct atl1_adapter *adapter,
 {
 	struct pci_dev *pdev = adapter->pdev;
 
+	/*
+	 * The L1 hardware contains a bug that erroneously sets the
+	 * PACKET_FLAG_ERR and ERR_FLAG_L4_CHKSUM bits whenever a
+	 * fragmented IP packet is received, even though the packet
+	 * is perfectly valid and its checksum is correct. There's
+	 * no way to distinguish between one of these good packets
+	 * and a packet that actually contains a TCP/UDP checksum
+	 * error, so all we can do is allow it to be handed up to
+	 * the higher layers and let it be sorted out there.
+	 */
+
 	skb->ip_summed = CHECKSUM_NONE;
 
 	if (unlikely(rrd->pkt_flg & PACKET_FLAG_ERR)) {
@@ -1816,14 +1827,6 @@ static void atl1_rx_checksum(struct atl1_adapter *adapter,
 		return;
 	}
 
-	/* IPv4, but hardware thinks its checksum is wrong */
-	if (netif_msg_rx_err(adapter))
-		dev_printk(KERN_DEBUG, &pdev->dev,
-			"hw csum wrong, pkt_flag:%x, err_flag:%x\n",
-			rrd->pkt_flg, rrd->err_flg);
-	skb->ip_summed = CHECKSUM_COMPLETE;
-	skb->csum = htons(rrd->xsz.xsum_sz.rx_chksum);
-	adapter->hw_csum_err++;
 	return;
 }
 
diff --git a/drivers/net/atp.c b/drivers/net/atp.c
index 3d44333..c10cd80 100644
--- a/drivers/net/atp.c
+++ b/drivers/net/atp.c
@@ -854,14 +854,9 @@ static void set_rx_mode_8002(struct net_device *dev)
 	struct net_local *lp = netdev_priv(dev);
 	long ioaddr = dev->base_addr;
 
-	if ( dev->mc_count > 0 || (dev->flags & (IFF_ALLMULTI|IFF_PROMISC))) {
-		/* We must make the kernel realise we had to move
-		 *	into promisc mode or we start all out war on
-		 *	the cable. - AC
-		 */
-		dev->flags|=IFF_PROMISC;
+	if (dev->mc_count > 0 || (dev->flags & (IFF_ALLMULTI|IFF_PROMISC)))
 		lp->addr_mode = CMR2h_PROMISC;
-	} else
+	else
 		lp->addr_mode = CMR2h_Normal;
 	write_reg_high(ioaddr, CMR2, lp->addr_mode);
 }
diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index ebb539e..6106660 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -2107,6 +2107,7 @@ void bond_3ad_state_machine_handler(struct work_struct *work)
 			aggregator = __get_first_agg(port);
 			ad_agg_selection_logic(aggregator);
 		}
+		bond_3ad_set_carrier(bond);
 	}
 
 	// for each port run the state machines
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index a641eea..c792138 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2223,272 +2223,217 @@ static int bond_slave_info_query(struct net_device *bond_dev, struct ifslave *in
 
 /*-------------------------------- Monitoring -------------------------------*/
 
-/*
- * if !have_locks, return nonzero if a failover is necessary.  if
- * have_locks, do whatever failover activities are needed.
- *
- * This is to separate the inspection and failover steps for locking
- * purposes; failover requires rtnl, but acquiring it for every
- * inspection is undesirable, so a wrapper first does inspection, and
- * the acquires the necessary locks and calls again to perform
- * failover if needed.  Since all locks are dropped, a complete
- * restart is needed between calls.
- */
-static int __bond_mii_monitor(struct bonding *bond, int have_locks)
-{
-	struct slave *slave, *oldcurrent;
-	int do_failover = 0;
-	int i;
-
-	if (bond->slave_cnt == 0)
-		goto out;
 
-	/* we will try to read the link status of each of our slaves, and
-	 * set their IFF_RUNNING flag appropriately. For each slave not
-	 * supporting MII status, we won't do anything so that a user-space
-	 * program could monitor the link itself if needed.
-	 */
-
-	read_lock(&bond->curr_slave_lock);
-	oldcurrent = bond->curr_active_slave;
-	read_unlock(&bond->curr_slave_lock);
+static int bond_miimon_inspect(struct bonding *bond)
+{
+	struct slave *slave;
+	int i, link_state, commit = 0;
 
 	bond_for_each_slave(bond, slave, i) {
-		struct net_device *slave_dev = slave->dev;
-		int link_state;
-		u16 old_speed = slave->speed;
-		u8 old_duplex = slave->duplex;
+		slave->new_link = BOND_LINK_NOCHANGE;
 
-		link_state = bond_check_dev_link(bond, slave_dev, 0);
+		link_state = bond_check_dev_link(bond, slave->dev, 0);
 
 		switch (slave->link) {
-		case BOND_LINK_UP:	/* the link was up */
-			if (link_state == BMSR_LSTATUS) {
-				if (!oldcurrent) {
-					if (!have_locks)
-						return 1;
-					do_failover = 1;
-				}
-				break;
-			} else { /* link going down */
-				slave->link  = BOND_LINK_FAIL;
-				slave->delay = bond->params.downdelay;
-
-				if (slave->link_failure_count < UINT_MAX) {
-					slave->link_failure_count++;
-				}
+		case BOND_LINK_UP:
+			if (link_state)
+				continue;
 
-				if (bond->params.downdelay) {
-					printk(KERN_INFO DRV_NAME
-					       ": %s: link status down for %s "
-					       "interface %s, disabling it in "
-					       "%d ms.\n",
-					       bond->dev->name,
-					       IS_UP(slave_dev)
-					       ? ((bond->params.mode == BOND_MODE_ACTIVEBACKUP)
-						  ? ((slave == oldcurrent)
-						     ? "active " : "backup ")
-						  : "")
-					       : "idle ",
-					       slave_dev->name,
-					       bond->params.downdelay * bond->params.miimon);
-				}
+			slave->link = BOND_LINK_FAIL;
+			slave->delay = bond->params.downdelay;
+			if (slave->delay) {
+				printk(KERN_INFO DRV_NAME
+				       ": %s: link status down for %s"
+				       "interface %s, disabling it in %d ms.\n",
+				       bond->dev->name,
+				       (bond->params.mode ==
+					BOND_MODE_ACTIVEBACKUP) ?
+				       ((slave->state == BOND_STATE_ACTIVE) ?
+					"active " : "backup ") : "",
+				       slave->dev->name,
+				       bond->params.downdelay * bond->params.miimon);
 			}
-			/* no break ! fall through the BOND_LINK_FAIL test to
-			   ensure proper action to be taken
-			*/
-		case BOND_LINK_FAIL:	/* the link has just gone down */
-			if (link_state != BMSR_LSTATUS) {
-				/* link stays down */
-				if (slave->delay <= 0) {
-					if (!have_locks)
-						return 1;
-
-					/* link down for too long time */
-					slave->link = BOND_LINK_DOWN;
-
-					/* in active/backup mode, we must
-					 * completely disable this interface
-					 */
-					if ((bond->params.mode == BOND_MODE_ACTIVEBACKUP) ||
-					    (bond->params.mode == BOND_MODE_8023AD)) {
-						bond_set_slave_inactive_flags(slave);
-					}
-
-					printk(KERN_INFO DRV_NAME
-					       ": %s: link status definitely "
-					       "down for interface %s, "
-					       "disabling it\n",
-					       bond->dev->name,
-					       slave_dev->name);
-
-					/* notify ad that the link status has changed */
-					if (bond->params.mode == BOND_MODE_8023AD) {
-						bond_3ad_handle_link_change(slave, BOND_LINK_DOWN);
-					}
-
-					if ((bond->params.mode == BOND_MODE_TLB) ||
-					    (bond->params.mode == BOND_MODE_ALB)) {
-						bond_alb_handle_link_change(bond, slave, BOND_LINK_DOWN);
-					}
-
-					if (slave == oldcurrent) {
-						do_failover = 1;
-					}
-				} else {
-					slave->delay--;
-				}
-			} else {
-				/* link up again */
-				slave->link  = BOND_LINK_UP;
+			/*FALLTHRU*/
+		case BOND_LINK_FAIL:
+			if (link_state) {
+				/*
+				 * recovered before downdelay expired
+				 */
+				slave->link = BOND_LINK_UP;
 				slave->jiffies = jiffies;
 				printk(KERN_INFO DRV_NAME
 				       ": %s: link status up again after %d "
 				       "ms for interface %s.\n",
 				       bond->dev->name,
-				       (bond->params.downdelay - slave->delay) * bond->params.miimon,
-				       slave_dev->name);
+				       (bond->params.downdelay - slave->delay) *
+				       bond->params.miimon,
+				       slave->dev->name);
+				continue;
 			}
-			break;
-		case BOND_LINK_DOWN:	/* the link was down */
-			if (link_state != BMSR_LSTATUS) {
-				/* the link stays down, nothing more to do */
-				break;
-			} else {	/* link going up */
-				slave->link  = BOND_LINK_BACK;
-				slave->delay = bond->params.updelay;
 
-				if (bond->params.updelay) {
-					/* if updelay == 0, no need to
-					   advertise about a 0 ms delay */
-					printk(KERN_INFO DRV_NAME
-					       ": %s: link status up for "
-					       "interface %s, enabling it "
-					       "in %d ms.\n",
-					       bond->dev->name,
-					       slave_dev->name,
-					       bond->params.updelay * bond->params.miimon);
-				}
+			if (slave->delay <= 0) {
+				slave->new_link = BOND_LINK_DOWN;
+				commit++;
+				continue;
 			}
-			/* no break ! fall through the BOND_LINK_BACK state in
-			   case there's something to do.
-			*/
-		case BOND_LINK_BACK:	/* the link has just come back */
-			if (link_state != BMSR_LSTATUS) {
-				/* link down again */
-				slave->link  = BOND_LINK_DOWN;
 
+			slave->delay--;
+			break;
+
+		case BOND_LINK_DOWN:
+			if (!link_state)
+				continue;
+
+			slave->link = BOND_LINK_BACK;
+			slave->delay = bond->params.updelay;
+
+			if (slave->delay) {
+				printk(KERN_INFO DRV_NAME
+				       ": %s: link status up for "
+				       "interface %s, enabling it in %d ms.\n",
+				       bond->dev->name, slave->dev->name,
+				       bond->params.updelay *
+				       bond->params.miimon);
+			}
+			/*FALLTHRU*/
+		case BOND_LINK_BACK:
+			if (!link_state) {
+				slave->link = BOND_LINK_DOWN;
 				printk(KERN_INFO DRV_NAME
 				       ": %s: link status down again after %d "
 				       "ms for interface %s.\n",
 				       bond->dev->name,
-				       (bond->params.updelay - slave->delay) * bond->params.miimon,
-				       slave_dev->name);
-			} else {
-				/* link stays up */
-				if (slave->delay == 0) {
-					if (!have_locks)
-						return 1;
-
-					/* now the link has been up for long time enough */
-					slave->link = BOND_LINK_UP;
-					slave->jiffies = jiffies;
-
-					if (bond->params.mode == BOND_MODE_8023AD) {
-						/* prevent it from being the active one */
-						slave->state = BOND_STATE_BACKUP;
-					} else if (bond->params.mode != BOND_MODE_ACTIVEBACKUP) {
-						/* make it immediately active */
-						slave->state = BOND_STATE_ACTIVE;
-					} else if (slave != bond->primary_slave) {
-						/* prevent it from being the active one */
-						slave->state = BOND_STATE_BACKUP;
-					}
+				       (bond->params.updelay - slave->delay) *
+				       bond->params.miimon,
+				       slave->dev->name);
 
-					printk(KERN_INFO DRV_NAME
-					       ": %s: link status definitely "
-					       "up for interface %s.\n",
-					       bond->dev->name,
-					       slave_dev->name);
-
-					/* notify ad that the link status has changed */
-					if (bond->params.mode == BOND_MODE_8023AD) {
-						bond_3ad_handle_link_change(slave, BOND_LINK_UP);
-					}
-
-					if ((bond->params.mode == BOND_MODE_TLB) ||
-					    (bond->params.mode == BOND_MODE_ALB)) {
-						bond_alb_handle_link_change(bond, slave, BOND_LINK_UP);
-					}
-
-					if ((!oldcurrent) ||
-					    (slave == bond->primary_slave)) {
-						do_failover = 1;
-					}
-				} else {
-					slave->delay--;
-				}
+				continue;
 			}
+
+			if (slave->delay <= 0) {
+				slave->new_link = BOND_LINK_UP;
+				commit++;
+				continue;
+			}
+
+			slave->delay--;
 			break;
-		default:
-			/* Should not happen */
-			printk(KERN_ERR DRV_NAME
-			       ": %s: Error: %s Illegal value (link=%d)\n",
-			       bond->dev->name,
-			       slave->dev->name,
-			       slave->link);
-			goto out;
-		} /* end of switch (slave->link) */
+		}
+	}
 
-		bond_update_speed_duplex(slave);
+	return commit;
+}
 
-		if (bond->params.mode == BOND_MODE_8023AD) {
-			if (old_speed != slave->speed) {
-				bond_3ad_adapter_speed_changed(slave);
-			}
+static void bond_miimon_commit(struct bonding *bond)
+{
+	struct slave *slave;
+	int i;
+
+	bond_for_each_slave(bond, slave, i) {
+		switch (slave->new_link) {
+		case BOND_LINK_NOCHANGE:
+			continue;
+
+		case BOND_LINK_UP:
+			slave->link = BOND_LINK_UP;
+			slave->jiffies = jiffies;
 
-			if (old_duplex != slave->duplex) {
-				bond_3ad_adapter_duplex_changed(slave);
+			if (bond->params.mode == BOND_MODE_8023AD) {
+				/* prevent it from being the active one */
+				slave->state = BOND_STATE_BACKUP;
+			} else if (bond->params.mode != BOND_MODE_ACTIVEBACKUP) {
+				/* make it immediately active */
+				slave->state = BOND_STATE_ACTIVE;
+			} else if (slave != bond->primary_slave) {
+				/* prevent it from being the active one */
+				slave->state = BOND_STATE_BACKUP;
 			}
-		}
 
-	} /* end of for */
+			printk(KERN_INFO DRV_NAME
+			       ": %s: link status definitely "
+			       "up for interface %s.\n",
+			       bond->dev->name, slave->dev->name);
 
-	if (do_failover) {
-		ASSERT_RTNL();
+			/* notify ad that the link status has changed */
+			if (bond->params.mode == BOND_MODE_8023AD)
+				bond_3ad_handle_link_change(slave, BOND_LINK_UP);
 
-		write_lock_bh(&bond->curr_slave_lock);
+			if ((bond->params.mode == BOND_MODE_TLB) ||
+			    (bond->params.mode == BOND_MODE_ALB))
+				bond_alb_handle_link_change(bond, slave,
+							    BOND_LINK_UP);
 
-		bond_select_active_slave(bond);
+			if (!bond->curr_active_slave ||
+			    (slave == bond->primary_slave))
+				goto do_failover;
 
-		write_unlock_bh(&bond->curr_slave_lock);
+			continue;
 
-	} else
-		bond_set_carrier(bond);
+		case BOND_LINK_DOWN:
+			slave->link = BOND_LINK_DOWN;
 
-out:
-	return 0;
+			if (bond->params.mode == BOND_MODE_ACTIVEBACKUP ||
+			    bond->params.mode == BOND_MODE_8023AD)
+				bond_set_slave_inactive_flags(slave);
+
+			printk(KERN_INFO DRV_NAME
+			       ": %s: link status definitely down for "
+			       "interface %s, disabling it\n",
+			       bond->dev->name, slave->dev->name);
+
+			if (bond->params.mode == BOND_MODE_8023AD)
+				bond_3ad_handle_link_change(slave,
+							    BOND_LINK_DOWN);
+
+			if (bond->params.mode == BOND_MODE_TLB ||
+			    bond->params.mode == BOND_MODE_ALB)
+				bond_alb_handle_link_change(bond, slave,
+							    BOND_LINK_DOWN);
+
+			if (slave == bond->curr_active_slave)
+				goto do_failover;
+
+			continue;
+
+		default:
+			printk(KERN_ERR DRV_NAME
+			       ": %s: invalid new link %d on slave %s\n",
+			       bond->dev->name, slave->new_link,
+			       slave->dev->name);
+			slave->new_link = BOND_LINK_NOCHANGE;
+
+			continue;
+		}
+
+do_failover:
+		ASSERT_RTNL();
+		write_lock_bh(&bond->curr_slave_lock);
+		bond_select_active_slave(bond);
+		write_unlock_bh(&bond->curr_slave_lock);
+	}
+
+	bond_set_carrier(bond);
 }
 
 /*
  * bond_mii_monitor
  *
  * Really a wrapper that splits the mii monitor into two phases: an
- * inspection, then (if inspection indicates something needs to be
- * done) an acquisition of appropriate locks followed by another pass
- * to implement whatever link state changes are indicated.
+ * inspection, then (if inspection indicates something needs to be done)
+ * an acquisition of appropriate locks followed by a commit phase to
+ * implement whatever link state changes are indicated.
  */
 void bond_mii_monitor(struct work_struct *work)
 {
 	struct bonding *bond = container_of(work, struct bonding,
 					    mii_work.work);
-	unsigned long delay;
 
 	read_lock(&bond->lock);
-	if (bond->kill_timers) {
-		read_unlock(&bond->lock);
-		return;
-	}
+	if (bond->kill_timers)
+		goto out;
+
+	if (bond->slave_cnt == 0)
+		goto re_arm;
 
 	if (bond->send_grat_arp) {
 		read_lock(&bond->curr_slave_lock);
@@ -2496,19 +2441,24 @@ void bond_mii_monitor(struct work_struct *work)
 		read_unlock(&bond->curr_slave_lock);
 	}
 
-	if (__bond_mii_monitor(bond, 0)) {
+	if (bond_miimon_inspect(bond)) {
 		read_unlock(&bond->lock);
 		rtnl_lock();
 		read_lock(&bond->lock);
-		__bond_mii_monitor(bond, 1);
+
+		bond_miimon_commit(bond);
+
 		read_unlock(&bond->lock);
 		rtnl_unlock();	/* might sleep, hold no other locks */
 		read_lock(&bond->lock);
 	}
 
-	delay = msecs_to_jiffies(bond->params.miimon);
+re_arm:
+	if (bond->params.miimon)
+		queue_delayed_work(bond->wq, &bond->mii_work,
+				   msecs_to_jiffies(bond->params.miimon));
+out:
 	read_unlock(&bond->lock);
-	queue_delayed_work(bond->wq, &bond->mii_work, delay);
 }
 
 static __be32 bond_glean_dev_ip(struct net_device *dev)
diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index 6caac0f..3bdb473 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -350,9 +350,6 @@ static ssize_t bonding_store_slaves(struct device *d,
 		if (dev) {
 			printk(KERN_INFO DRV_NAME ": %s: Removing slave %s\n",
 				bond->dev->name, dev->name);
-			if (bond->setup_by_slave)
-				res = bond_release_and_destroy(bond->dev, dev);
-			else
 				res = bond_release(bond->dev, dev);
 			if (res) {
 				ret = res;
diff --git a/drivers/net/de620.c b/drivers/net/de620.c
index 3f5190c..d454e14 100644
--- a/drivers/net/de620.c
+++ b/drivers/net/de620.c
@@ -488,13 +488,6 @@ static void de620_set_multicast_list(struct net_device *dev)
 {
 	if (dev->mc_count || dev->flags&(IFF_ALLMULTI|IFF_PROMISC))
 	{ /* Enable promiscuous mode */
-		/*
-		 *	We must make the kernel realise we had to move
-		 *	into promisc mode or we start all out war on
-		 *	the cable. - AC
-		 */
-		dev->flags|=IFF_PROMISC;
-
 		de620_set_register(dev, W_TCR, (TCR_DEF & ~RXPBM) | RXALL);
 	}
 	else
diff --git a/drivers/net/dm9000.c b/drivers/net/dm9000.c
index 0b0f1c4..f42c23f 100644
--- a/drivers/net/dm9000.c
+++ b/drivers/net/dm9000.c
@@ -1374,6 +1374,11 @@ dm9000_probe(struct platform_device *pdev)
 	for (i = 0; i < 6; i += 2)
 		dm9000_read_eeprom(db, i / 2, ndev->dev_addr+i);
 
+	if (!is_valid_ether_addr(ndev->dev_addr) && pdata != NULL) {
+		mac_src = "platform data";
+		memcpy(ndev->dev_addr, pdata->dev_addr, 6);
+	}
+
 	if (!is_valid_ether_addr(ndev->dev_addr)) {
 		/* try reading from mac */
 		
diff --git a/drivers/net/e1000e/e1000.h b/drivers/net/e1000e/e1000.h
index 4a4f62e..cf57050 100644
--- a/drivers/net/e1000e/e1000.h
+++ b/drivers/net/e1000e/e1000.h
@@ -41,24 +41,25 @@
 
 struct e1000_info;
 
-#define ndev_printk(level, netdev, format, arg...) \
-	printk(level "%s: " format, (netdev)->name, ## arg)
+#define e_printk(level, adapter, format, arg...) \
+	printk(level "%s: %s: " format, pci_name(adapter->pdev), \
+	       adapter->netdev->name, ## arg)
 
 #ifdef DEBUG
-#define ndev_dbg(netdev, format, arg...) \
-	ndev_printk(KERN_DEBUG , netdev, format, ## arg)
+#define e_dbg(format, arg...) \
+	e_printk(KERN_DEBUG , adapter, format, ## arg)
 #else
-#define ndev_dbg(netdev, format, arg...) do { (void)(netdev); } while (0)
+#define e_dbg(format, arg...) do { (void)(adapter); } while (0)
 #endif
 
-#define ndev_err(netdev, format, arg...) \
-	ndev_printk(KERN_ERR , netdev, format, ## arg)
-#define ndev_info(netdev, format, arg...) \
-	ndev_printk(KERN_INFO , netdev, format, ## arg)
-#define ndev_warn(netdev, format, arg...) \
-	ndev_printk(KERN_WARNING , netdev, format, ## arg)
-#define ndev_notice(netdev, format, arg...) \
-	ndev_printk(KERN_NOTICE , netdev, format, ## arg)
+#define e_err(format, arg...) \
+	e_printk(KERN_ERR, adapter, format, ## arg)
+#define e_info(format, arg...) \
+	e_printk(KERN_INFO, adapter, format, ## arg)
+#define e_warn(format, arg...) \
+	e_printk(KERN_WARNING, adapter, format, ## arg)
+#define e_notice(format, arg...) \
+	e_printk(KERN_NOTICE, adapter, format, ## arg)
 
 
 /* Tx/Rx descriptor defines */
@@ -283,10 +284,6 @@ struct e1000_adapter {
 	unsigned long led_status;
 
 	unsigned int flags;
-
-	/* for ioport free */
-	int bars;
-	int need_ioport;
 };
 
 struct e1000_info {
diff --git a/drivers/net/e1000e/ethtool.c b/drivers/net/e1000e/ethtool.c
index 9350564..cf9679f 100644
--- a/drivers/net/e1000e/ethtool.c
+++ b/drivers/net/e1000e/ethtool.c
@@ -189,8 +189,7 @@ static int e1000_set_spd_dplx(struct e1000_adapter *adapter, u16 spddplx)
 	/* Fiber NICs only allow 1000 gbps Full duplex */
 	if ((adapter->hw.phy.media_type == e1000_media_type_fiber) &&
 		spddplx != (SPEED_1000 + DUPLEX_FULL)) {
-		ndev_err(adapter->netdev, "Unsupported Speed/Duplex "
-			 "configuration\n");
+		e_err("Unsupported Speed/Duplex configuration\n");
 		return -EINVAL;
 	}
 
@@ -213,8 +212,7 @@ static int e1000_set_spd_dplx(struct e1000_adapter *adapter, u16 spddplx)
 		break;
 	case SPEED_1000 + DUPLEX_HALF: /* not supported */
 	default:
-		ndev_err(adapter->netdev, "Unsupported Speed/Duplex "
-			 "configuration\n");
+		e_err("Unsupported Speed/Duplex configuration\n");
 		return -EINVAL;
 	}
 	return 0;
@@ -231,8 +229,8 @@ static int e1000_set_settings(struct net_device *netdev,
 	 * cannot be changed
 	 */
 	if (e1000_check_reset_block(hw)) {
-		ndev_err(netdev, "Cannot change link "
-			 "characteristics when SoL/IDER is active.\n");
+		e_err("Cannot change link characteristics when SoL/IDER is "
+		      "active.\n");
 		return -EINVAL;
 	}
 
@@ -380,8 +378,7 @@ static int e1000_set_tso(struct net_device *netdev, u32 data)
 		netdev->features &= ~NETIF_F_TSO6;
 	}
 
-	ndev_info(netdev, "TSO is %s\n",
-		  data ? "Enabled" : "Disabled");
+	e_info("TSO is %s\n", data ? "Enabled" : "Disabled");
 	adapter->flags |= FLAG_TSO_FORCE;
 	return 0;
 }
@@ -722,10 +719,9 @@ static bool reg_pattern_test(struct e1000_adapter *adapter, u64 *data,
 				      (test[pat] & write));
 		val = E1000_READ_REG_ARRAY(&adapter->hw, reg, offset);
 		if (val != (test[pat] & write & mask)) {
-			ndev_err(adapter->netdev, "pattern test reg %04X "
-				 "failed: got 0x%08X expected 0x%08X\n",
-				 reg + offset,
-				 val, (test[pat] & write & mask));
+			e_err("pattern test reg %04X failed: got 0x%08X "
+			      "expected 0x%08X\n", reg + offset, val,
+			      (test[pat] & write & mask));
 			*data = reg;
 			return 1;
 		}
@@ -740,9 +736,8 @@ static bool reg_set_and_check(struct e1000_adapter *adapter, u64 *data,
 	__ew32(&adapter->hw, reg, write & mask);
 	val = __er32(&adapter->hw, reg);
 	if ((write & mask) != (val & mask)) {
-		ndev_err(adapter->netdev, "set/check reg %04X test failed: "
-			 "got 0x%08X expected 0x%08X\n", reg, (val & mask),
-			 (write & mask));
+		e_err("set/check reg %04X test failed: got 0x%08X "
+		      "expected 0x%08X\n", reg, (val & mask), (write & mask));
 		*data = reg;
 		return 1;
 	}
@@ -766,7 +761,6 @@ static int e1000_reg_test(struct e1000_adapter *adapter, u64 *data)
 {
 	struct e1000_hw *hw = &adapter->hw;
 	struct e1000_mac_info *mac = &adapter->hw.mac;
-	struct net_device *netdev = adapter->netdev;
 	u32 value;
 	u32 before;
 	u32 after;
@@ -799,8 +793,8 @@ static int e1000_reg_test(struct e1000_adapter *adapter, u64 *data)
 	ew32(STATUS, toggle);
 	after = er32(STATUS) & toggle;
 	if (value != after) {
-		ndev_err(netdev, "failed STATUS register test got: "
-			 "0x%08X expected: 0x%08X\n", after, value);
+		e_err("failed STATUS register test got: 0x%08X expected: "
+		      "0x%08X\n", after, value);
 		*data = 1;
 		return 1;
 	}
@@ -903,8 +897,7 @@ static int e1000_intr_test(struct e1000_adapter *adapter, u64 *data)
 		*data = 1;
 		return -1;
 	}
-	ndev_info(netdev, "testing %s interrupt\n",
-		  (shared_int ? "shared" : "unshared"));
+	e_info("testing %s interrupt\n", (shared_int ? "shared" : "unshared"));
 
 	/* Disable all the interrupts */
 	ew32(IMC, 0xFFFFFFFF);
@@ -1526,8 +1519,7 @@ static int e1000_loopback_test(struct e1000_adapter *adapter, u64 *data)
 	 * sessions are active
 	 */
 	if (e1000_check_reset_block(&adapter->hw)) {
-		ndev_err(adapter->netdev, "Cannot do PHY loopback test "
-			 "when SoL/IDER is active.\n");
+		e_err("Cannot do PHY loopback test when SoL/IDER is active.\n");
 		*data = 0;
 		goto out;
 	}
@@ -1612,7 +1604,7 @@ static void e1000_diag_test(struct net_device *netdev,
 		forced_speed_duplex = adapter->hw.mac.forced_speed_duplex;
 		autoneg = adapter->hw.mac.autoneg;
 
-		ndev_info(netdev, "offline testing starting\n");
+		e_info("offline testing starting\n");
 
 		/*
 		 * Link test performed before hardware reset so autoneg doesn't
@@ -1658,7 +1650,7 @@ static void e1000_diag_test(struct net_device *netdev,
 		if (if_running)
 			dev_open(netdev);
 	} else {
-		ndev_info(netdev, "online testing starting\n");
+		e_info("online testing starting\n");
 		/* Online tests */
 		if (e1000_link_test(adapter, &data[4]))
 			eth_test->flags |= ETH_TEST_FL_FAILED;
@@ -1694,8 +1686,8 @@ static void e1000_get_wol(struct net_device *netdev,
 		wol->supported &= ~WAKE_UCAST;
 
 		if (adapter->wol & E1000_WUFC_EX)
-			ndev_err(netdev, "Interface does not support "
-				 "directed (unicast) frame wake-up packets\n");
+			e_err("Interface does not support directed (unicast) "
+			      "frame wake-up packets\n");
 	}
 
 	if (adapter->wol & E1000_WUFC_EX)
diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index d136778..05b0b2f 100644
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -484,8 +484,8 @@ static bool e1000_clean_rx_irq(struct e1000_adapter *adapter,
 		 * packet, also make sure the frame isn't just CRC only */
 		if (!(status & E1000_RXD_STAT_EOP) || (length <= 4)) {
 			/* All receives must fit into a single buffer */
-			ndev_dbg(netdev, "%s: Receive packet consumed "
-				 "multiple buffers\n", netdev->name);
+			e_dbg("%s: Receive packet consumed multiple buffers\n",
+			      netdev->name);
 			/* recycle */
 			buffer_info->skb = skb;
 			goto next_desc;
@@ -576,28 +576,26 @@ static void e1000_print_tx_hang(struct e1000_adapter *adapter)
 	unsigned int i = tx_ring->next_to_clean;
 	unsigned int eop = tx_ring->buffer_info[i].next_to_watch;
 	struct e1000_tx_desc *eop_desc = E1000_TX_DESC(*tx_ring, eop);
-	struct net_device *netdev = adapter->netdev;
 
 	/* detected Tx unit hang */
-	ndev_err(netdev,
-		 "Detected Tx Unit Hang:\n"
-		 "  TDH                  <%x>\n"
-		 "  TDT                  <%x>\n"
-		 "  next_to_use          <%x>\n"
-		 "  next_to_clean        <%x>\n"
-		 "buffer_info[next_to_clean]:\n"
-		 "  time_stamp           <%lx>\n"
-		 "  next_to_watch        <%x>\n"
-		 "  jiffies              <%lx>\n"
-		 "  next_to_watch.status <%x>\n",
-		 readl(adapter->hw.hw_addr + tx_ring->head),
-		 readl(adapter->hw.hw_addr + tx_ring->tail),
-		 tx_ring->next_to_use,
-		 tx_ring->next_to_clean,
-		 tx_ring->buffer_info[eop].time_stamp,
-		 eop,
-		 jiffies,
-		 eop_desc->upper.fields.status);
+	e_err("Detected Tx Unit Hang:\n"
+	      "  TDH                  <%x>\n"
+	      "  TDT                  <%x>\n"
+	      "  next_to_use          <%x>\n"
+	      "  next_to_clean        <%x>\n"
+	      "buffer_info[next_to_clean]:\n"
+	      "  time_stamp           <%lx>\n"
+	      "  next_to_watch        <%x>\n"
+	      "  jiffies              <%lx>\n"
+	      "  next_to_watch.status <%x>\n",
+	      readl(adapter->hw.hw_addr + tx_ring->head),
+	      readl(adapter->hw.hw_addr + tx_ring->tail),
+	      tx_ring->next_to_use,
+	      tx_ring->next_to_clean,
+	      tx_ring->buffer_info[eop].time_stamp,
+	      eop,
+	      jiffies,
+	      eop_desc->upper.fields.status);
 }
 
 /**
@@ -747,8 +745,8 @@ static bool e1000_clean_rx_irq_ps(struct e1000_adapter *adapter,
 		buffer_info->dma = 0;
 
 		if (!(staterr & E1000_RXD_STAT_EOP)) {
-			ndev_dbg(netdev, "%s: Packet Split buffers didn't pick "
-				 "up the full packet\n", netdev->name);
+			e_dbg("%s: Packet Split buffers didn't pick up the "
+			      "full packet\n", netdev->name);
 			dev_kfree_skb_irq(skb);
 			goto next_desc;
 		}
@@ -761,8 +759,8 @@ static bool e1000_clean_rx_irq_ps(struct e1000_adapter *adapter,
 		length = le16_to_cpu(rx_desc->wb.middle.length0);
 
 		if (!length) {
-			ndev_dbg(netdev, "%s: Last part of the packet spanning"
-				 " multiple descriptors\n", netdev->name);
+			e_dbg("%s: Last part of the packet spanning multiple "
+			      "descriptors\n", netdev->name);
 			dev_kfree_skb_irq(skb);
 			goto next_desc;
 		}
@@ -1011,7 +1009,7 @@ static bool e1000_clean_jumbo_rx_irq(struct e1000_adapter *adapter,
 
 		/* eth type trans needs skb->data to point to something */
 		if (!pskb_may_pull(skb, ETH_HLEN)) {
-			ndev_err(netdev, "pskb_may_pull failed.\n");
+			e_err("pskb_may_pull failed.\n");
 			dev_kfree_skb(skb);
 			goto next_desc;
 		}
@@ -1251,10 +1249,8 @@ static int e1000_request_irq(struct e1000_adapter *adapter)
 	err = request_irq(adapter->pdev->irq, handler, irq_flags, netdev->name,
 			  netdev);
 	if (err) {
-		ndev_err(netdev,
-		       "Unable to allocate %s interrupt (return: %d)\n",
-			adapter->flags & FLAG_MSI_ENABLED ? "MSI":"INTx",
-			err);
+		e_err("Unable to allocate %s interrupt (return: %d)\n",
+		      adapter->flags & FLAG_MSI_ENABLED ? "MSI":"INTx",	err);
 		if (adapter->flags & FLAG_MSI_ENABLED)
 			pci_disable_msi(adapter->pdev);
 	}
@@ -1395,8 +1391,7 @@ int e1000e_setup_tx_resources(struct e1000_adapter *adapter)
 	return 0;
 err:
 	vfree(tx_ring->buffer_info);
-	ndev_err(adapter->netdev,
-	"Unable to allocate memory for the transmit descriptor ring\n");
+	e_err("Unable to allocate memory for the transmit descriptor ring\n");
 	return err;
 }
 
@@ -1450,8 +1445,7 @@ err_pages:
 	}
 err:
 	vfree(rx_ring->buffer_info);
-	ndev_err(adapter->netdev,
-	"Unable to allocate memory for the transmit descriptor ring\n");
+	e_err("Unable to allocate memory for the transmit descriptor ring\n");
 	return err;
 }
 
@@ -2450,13 +2444,13 @@ void e1000e_reset(struct e1000_adapter *adapter)
 	 * For parts with AMT enabled, let the firmware know
 	 * that the network interface is in control
 	 */
-	if ((adapter->flags & FLAG_HAS_AMT) && e1000e_check_mng_mode(hw))
+	if (adapter->flags & FLAG_HAS_AMT)
 		e1000_get_hw_control(adapter);
 
 	ew32(WUC, 0);
 
 	if (mac->ops.init_hw(hw))
-		ndev_err(adapter->netdev, "Hardware Error\n");
+		e_err("Hardware Error\n");
 
 	e1000_update_mng_vlan(adapter);
 
@@ -2591,7 +2585,7 @@ static int __devinit e1000_sw_init(struct e1000_adapter *adapter)
 	return 0;
 
 err:
-	ndev_err(netdev, "Unable to allocate memory for queues\n");
+	e_err("Unable to allocate memory for queues\n");
 	kfree(adapter->rx_ring);
 	kfree(adapter->tx_ring);
 	return -ENOMEM;
@@ -2640,8 +2634,7 @@ static int e1000_open(struct net_device *netdev)
 	 * If AMT is enabled, let the firmware know that the network
 	 * interface is now open
 	 */
-	if ((adapter->flags & FLAG_HAS_AMT) &&
-	    e1000e_check_mng_mode(&adapter->hw))
+	if (adapter->flags & FLAG_HAS_AMT)
 		e1000_get_hw_control(adapter);
 
 	/*
@@ -2719,8 +2712,7 @@ static int e1000_close(struct net_device *netdev)
 	 * If AMT is enabled, let the firmware know that the network
 	 * interface is now closed
 	 */
-	if ((adapter->flags & FLAG_HAS_AMT) &&
-	    e1000e_check_mng_mode(&adapter->hw))
+	if (adapter->flags & FLAG_HAS_AMT)
 		e1000_release_hw_control(adapter);
 
 	return 0;
@@ -2917,8 +2909,7 @@ static void e1000_phy_read_status(struct e1000_adapter *adapter)
 		ret_val |= e1e_rphy(hw, PHY_1000T_STATUS, &phy->stat1000);
 		ret_val |= e1e_rphy(hw, PHY_EXT_STATUS, &phy->estatus);
 		if (ret_val)
-			ndev_warn(adapter->netdev,
-				  "Error reading PHY register\n");
+			e_warn("Error reading PHY register\n");
 	} else {
 		/*
 		 * Do not read PHY registers if link is not up
@@ -2943,18 +2934,16 @@ static void e1000_phy_read_status(struct e1000_adapter *adapter)
 static void e1000_print_link_info(struct e1000_adapter *adapter)
 {
 	struct e1000_hw *hw = &adapter->hw;
-	struct net_device *netdev = adapter->netdev;
 	u32 ctrl = er32(CTRL);
 
-	ndev_info(netdev,
-		"Link is Up %d Mbps %s, Flow Control: %s\n",
-		adapter->link_speed,
-		(adapter->link_duplex == FULL_DUPLEX) ?
-				"Full Duplex" : "Half Duplex",
-		((ctrl & E1000_CTRL_TFCE) && (ctrl & E1000_CTRL_RFCE)) ?
-				"RX/TX" :
-		((ctrl & E1000_CTRL_RFCE) ? "RX" :
-		((ctrl & E1000_CTRL_TFCE) ? "TX" : "None" )));
+	e_info("Link is Up %d Mbps %s, Flow Control: %s\n",
+	       adapter->link_speed,
+	       (adapter->link_duplex == FULL_DUPLEX) ?
+	                        "Full Duplex" : "Half Duplex",
+	       ((ctrl & E1000_CTRL_TFCE) && (ctrl & E1000_CTRL_RFCE)) ?
+	                        "RX/TX" :
+	       ((ctrl & E1000_CTRL_RFCE) ? "RX" :
+	       ((ctrl & E1000_CTRL_TFCE) ? "TX" : "None" )));
 }
 
 static bool e1000_has_link(struct e1000_adapter *adapter)
@@ -2994,8 +2983,7 @@ static bool e1000_has_link(struct e1000_adapter *adapter)
 	if ((ret_val == E1000_ERR_PHY) && (hw->phy.type == e1000_phy_igp_3) &&
 	    (er32(CTRL) & E1000_PHY_CTRL_GBE_DISABLE)) {
 		/* See e1000_kmrn_lock_loss_workaround_ich8lan() */
-		ndev_info(adapter->netdev,
-			  "Gigabit has been disabled, downgrading speed\n");
+		e_info("Gigabit has been disabled, downgrading speed\n");
 	}
 
 	return link_active;
@@ -3096,8 +3084,7 @@ static void e1000_watchdog_task(struct work_struct *work)
 				switch (adapter->link_speed) {
 				case SPEED_10:
 				case SPEED_100:
-					ndev_info(netdev,
-					"10/100 speed: disabling TSO\n");
+					e_info("10/100 speed: disabling TSO\n");
 					netdev->features &= ~NETIF_F_TSO;
 					netdev->features &= ~NETIF_F_TSO6;
 					break;
@@ -3130,7 +3117,7 @@ static void e1000_watchdog_task(struct work_struct *work)
 		if (netif_carrier_ok(netdev)) {
 			adapter->link_speed = 0;
 			adapter->link_duplex = 0;
-			ndev_info(netdev, "Link is Down\n");
+			e_info("Link is Down\n");
 			netif_carrier_off(netdev);
 			netif_tx_stop_all_queues(netdev);
 			if (!test_bit(__E1000_DOWN, &adapter->state))
@@ -3604,8 +3591,7 @@ static int e1000_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 
 			pull_size = min((unsigned int)4, skb->data_len);
 			if (!__pskb_pull_tail(skb, pull_size)) {
-				ndev_err(netdev,
-					 "__pskb_pull_tail failed.\n");
+				e_err("__pskb_pull_tail failed.\n");
 				dev_kfree_skb_any(skb);
 				return NETDEV_TX_OK;
 			}
@@ -3737,25 +3723,25 @@ static int e1000_change_mtu(struct net_device *netdev, int new_mtu)
 
 	if ((max_frame < ETH_ZLEN + ETH_FCS_LEN) ||
 	    (max_frame > MAX_JUMBO_FRAME_SIZE)) {
-		ndev_err(netdev, "Invalid MTU setting\n");
+		e_err("Invalid MTU setting\n");
 		return -EINVAL;
 	}
 
 	/* Jumbo frame size limits */
 	if (max_frame > ETH_FRAME_LEN + ETH_FCS_LEN) {
 		if (!(adapter->flags & FLAG_HAS_JUMBO_FRAMES)) {
-			ndev_err(netdev, "Jumbo Frames not supported.\n");
+			e_err("Jumbo Frames not supported.\n");
 			return -EINVAL;
 		}
 		if (adapter->hw.phy.type == e1000_phy_ife) {
-			ndev_err(netdev, "Jumbo Frames not supported.\n");
+			e_err("Jumbo Frames not supported.\n");
 			return -EINVAL;
 		}
 	}
 
 #define MAX_STD_JUMBO_FRAME_SIZE 9234
 	if (max_frame > MAX_STD_JUMBO_FRAME_SIZE) {
-		ndev_err(netdev, "MTU > 9216 not supported.\n");
+		e_err("MTU > 9216 not supported.\n");
 		return -EINVAL;
 	}
 
@@ -3792,8 +3778,7 @@ static int e1000_change_mtu(struct net_device *netdev, int new_mtu)
 		adapter->rx_buffer_len = ETH_FRAME_LEN + VLAN_HLEN
 					 + ETH_FCS_LEN;
 
-	ndev_info(netdev, "changing MTU from %d to %d\n",
-		netdev->mtu, new_mtu);
+	e_info("changing MTU from %d to %d\n", netdev->mtu, new_mtu);
 	netdev->mtu = new_mtu;
 
 	if (netif_running(netdev))
@@ -4006,10 +3991,7 @@ static int e1000_resume(struct pci_dev *pdev)
 	pci_restore_state(pdev);
 	e1000e_disable_l1aspm(pdev);
 
-	if (adapter->need_ioport)
-		err = pci_enable_device(pdev);
-	else
-		err = pci_enable_device_mem(pdev);
+	err = pci_enable_device_mem(pdev);
 	if (err) {
 		dev_err(&pdev->dev,
 			"Cannot enable PCI device from suspend\n");
@@ -4043,7 +4025,7 @@ static int e1000_resume(struct pci_dev *pdev)
 	 * is up.  For all other cases, let the f/w know that the h/w is now
 	 * under the control of the driver.
 	 */
-	if (!(adapter->flags & FLAG_HAS_AMT) || !e1000e_check_mng_mode(&adapter->hw))
+	if (!(adapter->flags & FLAG_HAS_AMT))
 		e1000_get_hw_control(adapter);
 
 	return 0;
@@ -4111,10 +4093,7 @@ static pci_ers_result_t e1000_io_slot_reset(struct pci_dev *pdev)
 	int err;
 
 	e1000e_disable_l1aspm(pdev);
-	if (adapter->need_ioport)
-		err = pci_enable_device(pdev);
-	else
-		err = pci_enable_device_mem(pdev);
+	err = pci_enable_device_mem(pdev);
 	if (err) {
 		dev_err(&pdev->dev,
 			"Cannot re-enable PCI device after reset.\n");
@@ -4162,8 +4141,7 @@ static void e1000_io_resume(struct pci_dev *pdev)
 	 * is up.  For all other cases, let the f/w know that the h/w is now
 	 * under the control of the driver.
 	 */
-	if (!(adapter->flags & FLAG_HAS_AMT) ||
-	    !e1000e_check_mng_mode(&adapter->hw))
+	if (!(adapter->flags & FLAG_HAS_AMT))
 		e1000_get_hw_control(adapter);
 
 }
@@ -4175,36 +4153,40 @@ static void e1000_print_device_info(struct e1000_adapter *adapter)
 	u32 pba_num;
 
 	/* print bus type/speed/width info */
-	ndev_info(netdev, "(PCI Express:2.5GB/s:%s) "
-		  "%02x:%02x:%02x:%02x:%02x:%02x\n",
-		  /* bus width */
-		 ((hw->bus.width == e1000_bus_width_pcie_x4) ? "Width x4" :
-		  "Width x1"),
-		  /* MAC address */
-		  netdev->dev_addr[0], netdev->dev_addr[1],
-		  netdev->dev_addr[2], netdev->dev_addr[3],
-		  netdev->dev_addr[4], netdev->dev_addr[5]);
-	ndev_info(netdev, "Intel(R) PRO/%s Network Connection\n",
-		  (hw->phy.type == e1000_phy_ife)
-		   ? "10/100" : "1000");
+	e_info("(PCI Express:2.5GB/s:%s) %02x:%02x:%02x:%02x:%02x:%02x\n",
+	       /* bus width */
+	       ((hw->bus.width == e1000_bus_width_pcie_x4) ? "Width x4" :
+	        "Width x1"),
+	       /* MAC address */
+	       netdev->dev_addr[0], netdev->dev_addr[1],
+	       netdev->dev_addr[2], netdev->dev_addr[3],
+	       netdev->dev_addr[4], netdev->dev_addr[5]);
+	e_info("Intel(R) PRO/%s Network Connection\n",
+	       (hw->phy.type == e1000_phy_ife) ? "10/100" : "1000");
 	e1000e_read_pba_num(hw, &pba_num);
-	ndev_info(netdev, "MAC: %d, PHY: %d, PBA No: %06x-%03x\n",
-		  hw->mac.type, hw->phy.type,
-		  (pba_num >> 8), (pba_num & 0xff));
+	e_info("MAC: %d, PHY: %d, PBA No: %06x-%03x\n",
+	       hw->mac.type, hw->phy.type, (pba_num >> 8), (pba_num & 0xff));
 }
 
-/**
- * e1000e_is_need_ioport - determine if an adapter needs ioport resources or not
- * @pdev: PCI device information struct
- *
- * Returns true if an adapters needs ioport resources
- **/
-static int e1000e_is_need_ioport(struct pci_dev *pdev)
+static void e1000_eeprom_checks(struct e1000_adapter *adapter)
 {
-	switch (pdev->device) {
-	/* Currently there are no adapters that need ioport resources */
-	default:
-		return false;
+	struct e1000_hw *hw = &adapter->hw;
+	int ret_val;
+	u16 buf = 0;
+
+	if (hw->mac.type != e1000_82573)
+		return;
+
+	ret_val = e1000_read_nvm(hw, NVM_INIT_CONTROL2_REG, 1, &buf);
+	if (!(le16_to_cpu(buf) & (1 << 0))) {
+		/* Deep Smart Power Down (DSPD) */
+		e_warn("Warning: detected DSPD enabled in EEPROM\n");
+	}
+
+	ret_val = e1000_read_nvm(hw, NVM_INIT_3GIO_3, 1, &buf);
+	if (le16_to_cpu(buf) & (3 << 2)) {
+		/* ASPM enable */
+		e_warn("Warning: detected ASPM enabled in EEPROM\n");
 	}
 }
 
@@ -4233,19 +4215,10 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
 	int i, err, pci_using_dac;
 	u16 eeprom_data = 0;
 	u16 eeprom_apme_mask = E1000_EEPROM_APME;
-	int bars, need_ioport;
 
 	e1000e_disable_l1aspm(pdev);
 
-	/* do not allocate ioport bars when not needed */
-	need_ioport = e1000e_is_need_ioport(pdev);
-	if (need_ioport) {
-		bars = pci_select_bars(pdev, IORESOURCE_MEM | IORESOURCE_IO);
-		err = pci_enable_device(pdev);
-	} else {
-		bars = pci_select_bars(pdev, IORESOURCE_MEM);
-		err = pci_enable_device_mem(pdev);
-	}
+	err = pci_enable_device_mem(pdev);
 	if (err)
 		return err;
 
@@ -4268,7 +4241,9 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
 		}
 	}
 
-	err = pci_request_selected_regions(pdev, bars, e1000e_driver_name);
+	err = pci_request_selected_regions(pdev,
+	                                  pci_select_bars(pdev, IORESOURCE_MEM),
+	                                  e1000e_driver_name);
 	if (err)
 		goto err_pci_reg;
 
@@ -4293,8 +4268,6 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
 	adapter->hw.adapter = adapter;
 	adapter->hw.mac.type = ei->mac;
 	adapter->msg_enable = (1 << NETIF_MSG_DRV | NETIF_MSG_PROBE) - 1;
-	adapter->bars = bars;
-	adapter->need_ioport = need_ioport;
 
 	mmio_start = pci_resource_start(pdev, 0);
 	mmio_len = pci_resource_len(pdev, 0);
@@ -4366,8 +4339,7 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
 	}
 
 	if (e1000_check_reset_block(&adapter->hw))
-		ndev_info(netdev,
-			  "PHY reset is blocked due to SOL/IDER session.\n");
+		e_info("PHY reset is blocked due to SOL/IDER session.\n");
 
 	netdev->features = NETIF_F_SG |
 			   NETIF_F_HW_CSUM |
@@ -4411,25 +4383,26 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
 		if (e1000_validate_nvm_checksum(&adapter->hw) >= 0)
 			break;
 		if (i == 2) {
-			ndev_err(netdev, "The NVM Checksum Is Not Valid\n");
+			e_err("The NVM Checksum Is Not Valid\n");
 			err = -EIO;
 			goto err_eeprom;
 		}
 	}
 
+	e1000_eeprom_checks(adapter);
+
 	/* copy the MAC address out of the NVM */
 	if (e1000e_read_mac_addr(&adapter->hw))
-		ndev_err(netdev, "NVM Read Error while reading MAC address\n");
+		e_err("NVM Read Error while reading MAC address\n");
 
 	memcpy(netdev->dev_addr, adapter->hw.mac.addr, netdev->addr_len);
 	memcpy(netdev->perm_addr, adapter->hw.mac.addr, netdev->addr_len);
 
 	if (!is_valid_ether_addr(netdev->perm_addr)) {
-		ndev_err(netdev, "Invalid MAC Address: "
-			 "%02x:%02x:%02x:%02x:%02x:%02x\n",
-			 netdev->perm_addr[0], netdev->perm_addr[1],
-			 netdev->perm_addr[2], netdev->perm_addr[3],
-			 netdev->perm_addr[4], netdev->perm_addr[5]);
+		e_err("Invalid MAC Address: %02x:%02x:%02x:%02x:%02x:%02x\n",
+		      netdev->perm_addr[0], netdev->perm_addr[1],
+		      netdev->perm_addr[2], netdev->perm_addr[3],
+		      netdev->perm_addr[4], netdev->perm_addr[5]);
 		err = -EIO;
 		goto err_eeprom;
 	}
@@ -4499,8 +4472,7 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
 	 * is up.  For all other cases, let the f/w know that the h/w is now
 	 * under the control of the driver.
 	 */
-	if (!(adapter->flags & FLAG_HAS_AMT) ||
-	    !e1000e_check_mng_mode(&adapter->hw))
+	if (!(adapter->flags & FLAG_HAS_AMT))
 		e1000_get_hw_control(adapter);
 
 	/* tell the stack to leave us alone until e1000_open() is called */
@@ -4517,24 +4489,25 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
 	return 0;
 
 err_register:
-err_hw_init:
-	e1000_release_hw_control(adapter);
+	if (!(adapter->flags & FLAG_HAS_AMT))
+		e1000_release_hw_control(adapter);
 err_eeprom:
 	if (!e1000_check_reset_block(&adapter->hw))
 		e1000_phy_hw_reset(&adapter->hw);
+err_hw_init:
 
-	if (adapter->hw.flash_address)
-		iounmap(adapter->hw.flash_address);
-
-err_flashmap:
 	kfree(adapter->tx_ring);
 	kfree(adapter->rx_ring);
 err_sw_init:
+	if (adapter->hw.flash_address)
+		iounmap(adapter->hw.flash_address);
+err_flashmap:
 	iounmap(adapter->hw.hw_addr);
 err_ioremap:
 	free_netdev(netdev);
 err_alloc_etherdev:
-	pci_release_selected_regions(pdev, bars);
+	pci_release_selected_regions(pdev,
+	                             pci_select_bars(pdev, IORESOURCE_MEM));
 err_pci_reg:
 err_dma:
 	pci_disable_device(pdev);
@@ -4582,7 +4555,8 @@ static void __devexit e1000_remove(struct pci_dev *pdev)
 	iounmap(adapter->hw.hw_addr);
 	if (adapter->hw.flash_address)
 		iounmap(adapter->hw.flash_address);
-	pci_release_selected_regions(pdev, adapter->bars);
+	pci_release_selected_regions(pdev,
+	                             pci_select_bars(pdev, IORESOURCE_MEM));
 
 	free_netdev(netdev);
 
diff --git a/drivers/net/e1000e/param.c b/drivers/net/e1000e/param.c
index a66b92e..8effc31 100644
--- a/drivers/net/e1000e/param.c
+++ b/drivers/net/e1000e/param.c
@@ -27,6 +27,7 @@
 *******************************************************************************/
 
 #include <linux/netdevice.h>
+#include <linux/pci.h>
 
 #include "e1000.h"
 
@@ -162,17 +163,16 @@ static int __devinit e1000_validate_option(unsigned int *value,
 	case enable_option:
 		switch (*value) {
 		case OPTION_ENABLED:
-			ndev_info(adapter->netdev, "%s Enabled\n", opt->name);
+			e_info("%s Enabled\n", opt->name);
 			return 0;
 		case OPTION_DISABLED:
-			ndev_info(adapter->netdev, "%s Disabled\n", opt->name);
+			e_info("%s Disabled\n", opt->name);
 			return 0;
 		}
 		break;
 	case range_option:
 		if (*value >= opt->arg.r.min && *value <= opt->arg.r.max) {
-			ndev_info(adapter->netdev,
-					"%s set to %i\n", opt->name, *value);
+			e_info("%s set to %i\n", opt->name, *value);
 			return 0;
 		}
 		break;
@@ -184,8 +184,7 @@ static int __devinit e1000_validate_option(unsigned int *value,
 			ent = &opt->arg.l.p[i];
 			if (*value == ent->i) {
 				if (ent->str[0] != '\0')
-					ndev_info(adapter->netdev, "%s\n",
-						  ent->str);
+					e_info("%s\n", ent->str);
 				return 0;
 			}
 		}
@@ -195,8 +194,8 @@ static int __devinit e1000_validate_option(unsigned int *value,
 		BUG();
 	}
 
-	ndev_info(adapter->netdev, "Invalid %s value specified (%i) %s\n",
-	       opt->name, *value, opt->err);
+	e_info("Invalid %s value specified (%i) %s\n", opt->name, *value,
+	       opt->err);
 	*value = opt->def;
 	return -1;
 }
@@ -213,13 +212,11 @@ static int __devinit e1000_validate_option(unsigned int *value,
 void __devinit e1000e_check_options(struct e1000_adapter *adapter)
 {
 	struct e1000_hw *hw = &adapter->hw;
-	struct net_device *netdev = adapter->netdev;
 	int bd = adapter->bd_number;
 
 	if (bd >= E1000_MAX_NIC) {
-		ndev_notice(netdev,
-		       "Warning: no configuration for board #%i\n", bd);
-		ndev_notice(netdev, "Using defaults for all values\n");
+		e_notice("Warning: no configuration for board #%i\n", bd);
+		e_notice("Using defaults for all values\n");
 	}
 
 	{ /* Transmit Interrupt Delay */
@@ -313,19 +310,15 @@ void __devinit e1000e_check_options(struct e1000_adapter *adapter)
 			adapter->itr = InterruptThrottleRate[bd];
 			switch (adapter->itr) {
 			case 0:
-				ndev_info(netdev, "%s turned off\n",
-					opt.name);
+				e_info("%s turned off\n", opt.name);
 				break;
 			case 1:
-				ndev_info(netdev,
-					  "%s set to dynamic mode\n",
-					  opt.name);
+				e_info("%s set to dynamic mode\n", opt.name);
 				adapter->itr_setting = adapter->itr;
 				adapter->itr = 20000;
 				break;
 			case 3:
-				ndev_info(netdev,
-					"%s set to dynamic conservative mode\n",
+				e_info("%s set to dynamic conservative mode\n",
 					opt.name);
 				adapter->itr_setting = adapter->itr;
 				adapter->itr = 20000;
diff --git a/drivers/net/eepro.c b/drivers/net/eepro.c
index 56f5049..1f11350 100644
--- a/drivers/net/eepro.c
+++ b/drivers/net/eepro.c
@@ -1283,14 +1283,6 @@ set_multicast_list(struct net_device *dev)
 
 	if (dev->flags&(IFF_ALLMULTI|IFF_PROMISC) || dev->mc_count > 63)
 	{
-		/*
-		 *	We must make the kernel realise we had to move
-		 *	into promisc mode or we start all out war on
-		 *	the cable. If it was a promisc request the
-		 *	flag is already set. If not we assert it.
-		 */
-		dev->flags|=IFF_PROMISC;
-
 		eepro_sw2bank2(ioaddr); /* be CAREFUL, BANK 2 now */
 		mode = inb(ioaddr + REG2);
 		outb(mode | PRMSC_Mode, ioaddr + REG2);
diff --git a/drivers/net/eth16i.c b/drivers/net/eth16i.c
index e3dd8b1..bee8b3f 100644
--- a/drivers/net/eth16i.c
+++ b/drivers/net/eth16i.c
@@ -1356,7 +1356,6 @@ static void eth16i_multicast(struct net_device *dev)
 
 	if(dev->mc_count || dev->flags&(IFF_ALLMULTI|IFF_PROMISC))
 	{
-		dev->flags|=IFF_PROMISC;	/* Must do this */
 		outb(3, ioaddr + RECEIVE_MODE_REG);
 	} else {
 		outb(2, ioaddr + RECEIVE_MODE_REG);
diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
index 01b38b0..053971e 100644
--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -77,26 +77,27 @@
  * Hardware access:
  */
 
-#define DEV_NEED_TIMERIRQ          0x00001  /* set the timer irq flag in the irq mask */
-#define DEV_NEED_LINKTIMER         0x00002  /* poll link settings. Relies on the timer irq */
-#define DEV_HAS_LARGEDESC          0x00004  /* device supports jumbo frames and needs packet format 2 */
-#define DEV_HAS_HIGH_DMA           0x00008  /* device supports 64bit dma */
-#define DEV_HAS_CHECKSUM           0x00010  /* device supports tx and rx checksum offloads */
-#define DEV_HAS_VLAN               0x00020  /* device supports vlan tagging and striping */
-#define DEV_HAS_MSI                0x00040  /* device supports MSI */
-#define DEV_HAS_MSI_X              0x00080  /* device supports MSI-X */
-#define DEV_HAS_POWER_CNTRL        0x00100  /* device supports power savings */
-#define DEV_HAS_STATISTICS_V1      0x00200  /* device supports hw statistics version 1 */
-#define DEV_HAS_STATISTICS_V2      0x00400  /* device supports hw statistics version 2 */
-#define DEV_HAS_TEST_EXTENDED      0x00800  /* device supports extended diagnostic test */
-#define DEV_HAS_MGMT_UNIT          0x01000  /* device supports management unit */
-#define DEV_HAS_CORRECT_MACADDR    0x02000  /* device supports correct mac address order */
-#define DEV_HAS_COLLISION_FIX      0x04000  /* device supports tx collision fix */
-#define DEV_HAS_PAUSEFRAME_TX_V1   0x08000  /* device supports tx pause frames version 1 */
-#define DEV_HAS_PAUSEFRAME_TX_V2   0x10000  /* device supports tx pause frames version 2 */
-#define DEV_HAS_PAUSEFRAME_TX_V3   0x20000  /* device supports tx pause frames version 3 */
-#define DEV_NEED_TX_LIMIT          0x40000  /* device needs to limit tx */
-#define DEV_HAS_GEAR_MODE          0x80000  /* device supports gear mode */
+#define DEV_NEED_TIMERIRQ          0x000001  /* set the timer irq flag in the irq mask */
+#define DEV_NEED_LINKTIMER         0x000002  /* poll link settings. Relies on the timer irq */
+#define DEV_HAS_LARGEDESC          0x000004  /* device supports jumbo frames and needs packet format 2 */
+#define DEV_HAS_HIGH_DMA           0x000008  /* device supports 64bit dma */
+#define DEV_HAS_CHECKSUM           0x000010  /* device supports tx and rx checksum offloads */
+#define DEV_HAS_VLAN               0x000020  /* device supports vlan tagging and striping */
+#define DEV_HAS_MSI                0x000040  /* device supports MSI */
+#define DEV_HAS_MSI_X              0x000080  /* device supports MSI-X */
+#define DEV_HAS_POWER_CNTRL        0x000100  /* device supports power savings */
+#define DEV_HAS_STATISTICS_V1      0x000200  /* device supports hw statistics version 1 */
+#define DEV_HAS_STATISTICS_V2      0x000400  /* device supports hw statistics version 2 */
+#define DEV_HAS_STATISTICS_V3      0x000800  /* device supports hw statistics version 3 */
+#define DEV_HAS_TEST_EXTENDED      0x001000  /* device supports extended diagnostic test */
+#define DEV_HAS_MGMT_UNIT          0x002000  /* device supports management unit */
+#define DEV_HAS_CORRECT_MACADDR    0x004000  /* device supports correct mac address order */
+#define DEV_HAS_COLLISION_FIX      0x008000  /* device supports tx collision fix */
+#define DEV_HAS_PAUSEFRAME_TX_V1   0x010000  /* device supports tx pause frames version 1 */
+#define DEV_HAS_PAUSEFRAME_TX_V2   0x020000  /* device supports tx pause frames version 2 */
+#define DEV_HAS_PAUSEFRAME_TX_V3   0x040000  /* device supports tx pause frames version 3 */
+#define DEV_NEED_TX_LIMIT          0x080000  /* device needs to limit tx */
+#define DEV_HAS_GEAR_MODE          0x100000  /* device supports gear mode */
 
 enum {
 	NvRegIrqStatus = 0x000,
@@ -248,6 +249,8 @@ enum {
 #define NVREG_TX_PAUSEFRAME_ENABLE_V1	0x01800010
 #define NVREG_TX_PAUSEFRAME_ENABLE_V2	0x056003f0
 #define NVREG_TX_PAUSEFRAME_ENABLE_V3	0x09f00880
+	NvRegTxPauseFrameLimit = 0x174,
+#define NVREG_TX_PAUSEFRAMELIMIT_ENABLE	0x00010000
 	NvRegMIIStatus = 0x180,
 #define NVREG_MIISTAT_ERROR		0x0001
 #define NVREG_MIISTAT_LINKCHANGE	0x0008
@@ -270,6 +273,9 @@ enum {
 #define NVREG_MIICTL_WRITE	0x00400
 #define NVREG_MIICTL_ADDRSHIFT	5
 	NvRegMIIData = 0x194,
+	NvRegTxUnicast = 0x1a0,
+	NvRegTxMulticast = 0x1a4,
+	NvRegTxBroadcast = 0x1a8,
 	NvRegWakeUpFlags = 0x200,
 #define NVREG_WAKEUPFLAGS_VAL		0x7770
 #define NVREG_WAKEUPFLAGS_BUSYSHIFT	24
@@ -402,6 +408,7 @@ union ring_type {
 #define NV_RX_FRAMINGERR	(1<<29)
 #define NV_RX_ERROR		(1<<30)
 #define NV_RX_AVAIL		(1<<31)
+#define NV_RX_ERROR_MASK	(NV_RX_ERROR1|NV_RX_ERROR2|NV_RX_ERROR3|NV_RX_ERROR4|NV_RX_CRCERR|NV_RX_OVERFLOW|NV_RX_FRAMINGERR)
 
 #define NV_RX2_CHECKSUMMASK	(0x1C000000)
 #define NV_RX2_CHECKSUM_IP	(0x10000000)
@@ -419,6 +426,7 @@ union ring_type {
 /* error and avail are the same for both */
 #define NV_RX2_ERROR		(1<<30)
 #define NV_RX2_AVAIL		(1<<31)
+#define NV_RX2_ERROR_MASK	(NV_RX2_ERROR1|NV_RX2_ERROR2|NV_RX2_ERROR3|NV_RX2_ERROR4|NV_RX2_CRCERR|NV_RX2_OVERFLOW|NV_RX2_FRAMINGERR)
 
 #define NV_RX3_VLAN_TAG_PRESENT (1<<16)
 #define NV_RX3_VLAN_TAG_MASK	(0x0000FFFF)
@@ -616,7 +624,12 @@ static const struct nv_ethtool_str nv_estats_str[] = {
 	{ "rx_bytes" },
 	{ "tx_pause" },
 	{ "rx_pause" },
-	{ "rx_drop_frame" }
+	{ "rx_drop_frame" },
+
+	/* version 3 stats */
+	{ "tx_unicast" },
+	{ "tx_multicast" },
+	{ "tx_broadcast" }
 };
 
 struct nv_ethtool_stats {
@@ -652,9 +665,15 @@ struct nv_ethtool_stats {
 	u64 tx_pause;
 	u64 rx_pause;
 	u64 rx_drop_frame;
+
+	/* version 3 stats */
+	u64 tx_unicast;
+	u64 tx_multicast;
+	u64 tx_broadcast;
 };
 
-#define NV_DEV_STATISTICS_V2_COUNT (sizeof(struct nv_ethtool_stats)/sizeof(u64))
+#define NV_DEV_STATISTICS_V3_COUNT (sizeof(struct nv_ethtool_stats)/sizeof(u64))
+#define NV_DEV_STATISTICS_V2_COUNT (NV_DEV_STATISTICS_V3_COUNT - 3)
 #define NV_DEV_STATISTICS_V1_COUNT (NV_DEV_STATISTICS_V2_COUNT - 6)
 
 /* diagnostics */
@@ -1628,6 +1647,12 @@ static void nv_get_hw_stats(struct net_device *dev)
 		np->estats.rx_pause += readl(base + NvRegRxPause);
 		np->estats.rx_drop_frame += readl(base + NvRegRxDropFrame);
 	}
+
+	if (np->driver_data & DEV_HAS_STATISTICS_V3) {
+		np->estats.tx_unicast += readl(base + NvRegTxUnicast);
+		np->estats.tx_multicast += readl(base + NvRegTxMulticast);
+		np->estats.tx_broadcast += readl(base + NvRegTxBroadcast);
+	}
 }
 
 /*
@@ -1641,7 +1666,7 @@ static struct net_device_stats *nv_get_stats(struct net_device *dev)
 	struct fe_priv *np = netdev_priv(dev);
 
 	/* If the nic supports hw counters then retrieve latest values */
-	if (np->driver_data & (DEV_HAS_STATISTICS_V1|DEV_HAS_STATISTICS_V2)) {
+	if (np->driver_data & (DEV_HAS_STATISTICS_V1|DEV_HAS_STATISTICS_V2|DEV_HAS_STATISTICS_V3)) {
 		nv_get_hw_stats(dev);
 
 		/* copy to net_device stats */
@@ -2632,7 +2657,7 @@ static int nv_rx_process(struct net_device *dev, int limit)
 			if (likely(flags & NV_RX_DESCRIPTORVALID)) {
 				len = flags & LEN_MASK_V1;
 				if (unlikely(flags & NV_RX_ERROR)) {
-					if (flags & NV_RX_ERROR4) {
+					if ((flags & NV_RX_ERROR_MASK) == NV_RX_ERROR4) {
 						len = nv_getlen(dev, skb->data, len);
 						if (len < 0) {
 							dev->stats.rx_errors++;
@@ -2641,7 +2666,7 @@ static int nv_rx_process(struct net_device *dev, int limit)
 						}
 					}
 					/* framing errors are soft errors */
-					else if (flags & NV_RX_FRAMINGERR) {
+					else if ((flags & NV_RX_ERROR_MASK) == NV_RX_FRAMINGERR) {
 						if (flags & NV_RX_SUBSTRACT1) {
 							len--;
 						}
@@ -2667,7 +2692,7 @@ static int nv_rx_process(struct net_device *dev, int limit)
 			if (likely(flags & NV_RX2_DESCRIPTORVALID)) {
 				len = flags & LEN_MASK_V2;
 				if (unlikely(flags & NV_RX2_ERROR)) {
-					if (flags & NV_RX2_ERROR4) {
+					if ((flags & NV_RX2_ERROR_MASK) == NV_RX2_ERROR4) {
 						len = nv_getlen(dev, skb->data, len);
 						if (len < 0) {
 							dev->stats.rx_errors++;
@@ -2676,7 +2701,7 @@ static int nv_rx_process(struct net_device *dev, int limit)
 						}
 					}
 					/* framing errors are soft errors */
-					else if (flags & NV_RX2_FRAMINGERR) {
+					else if ((flags & NV_RX2_ERROR_MASK) == NV_RX2_FRAMINGERR) {
 						if (flags & NV_RX2_SUBSTRACT1) {
 							len--;
 						}
@@ -2766,7 +2791,7 @@ static int nv_rx_process_optimized(struct net_device *dev, int limit)
 		if (likely(flags & NV_RX2_DESCRIPTORVALID)) {
 			len = flags & LEN_MASK_V2;
 			if (unlikely(flags & NV_RX2_ERROR)) {
-				if (flags & NV_RX2_ERROR4) {
+				if ((flags & NV_RX2_ERROR_MASK) == NV_RX2_ERROR4) {
 					len = nv_getlen(dev, skb->data, len);
 					if (len < 0) {
 						dev_kfree_skb(skb);
@@ -2774,7 +2799,7 @@ static int nv_rx_process_optimized(struct net_device *dev, int limit)
 					}
 				}
 				/* framing errors are soft errors */
-				else if (flags & NV_RX2_FRAMINGERR) {
+				else if ((flags & NV_RX2_ERROR_MASK) == NV_RX2_FRAMINGERR) {
 					if (flags & NV_RX2_SUBSTRACT1) {
 						len--;
 					}
@@ -3053,8 +3078,11 @@ static void nv_update_pause(struct net_device *dev, u32 pause_flags)
 			u32 pause_enable = NVREG_TX_PAUSEFRAME_ENABLE_V1;
 			if (np->driver_data & DEV_HAS_PAUSEFRAME_TX_V2)
 				pause_enable = NVREG_TX_PAUSEFRAME_ENABLE_V2;
-			if (np->driver_data & DEV_HAS_PAUSEFRAME_TX_V3)
+			if (np->driver_data & DEV_HAS_PAUSEFRAME_TX_V3) {
 				pause_enable = NVREG_TX_PAUSEFRAME_ENABLE_V3;
+				/* limit the number of tx pause frames to a default of 8 */
+				writel(readl(base + NvRegTxPauseFrameLimit)|NVREG_TX_PAUSEFRAMELIMIT_ENABLE, base + NvRegTxPauseFrameLimit);
+			}
 			writel(pause_enable,  base + NvRegTxPauseFrame);
 			writel(regmisc|NVREG_MISC1_PAUSE_TX, base + NvRegMisc1);
 			np->pause_flags |= NV_PAUSEFRAME_TX_ENABLE;
@@ -4740,6 +4768,8 @@ static int nv_get_sset_count(struct net_device *dev, int sset)
 			return NV_DEV_STATISTICS_V1_COUNT;
 		else if (np->driver_data & DEV_HAS_STATISTICS_V2)
 			return NV_DEV_STATISTICS_V2_COUNT;
+		else if (np->driver_data & DEV_HAS_STATISTICS_V3)
+			return NV_DEV_STATISTICS_V3_COUNT;
 		else
 			return 0;
 	default:
@@ -5324,7 +5354,7 @@ static int nv_open(struct net_device *dev)
 		mod_timer(&np->oom_kick, jiffies + OOM_REFILL);
 
 	/* start statistics timer */
-	if (np->driver_data & (DEV_HAS_STATISTICS_V1|DEV_HAS_STATISTICS_V2))
+	if (np->driver_data & (DEV_HAS_STATISTICS_V1|DEV_HAS_STATISTICS_V2|DEV_HAS_STATISTICS_V3))
 		mod_timer(&np->stats_poll,
 			round_jiffies(jiffies + STATS_INTERVAL));
 
@@ -5428,7 +5458,7 @@ static int __devinit nv_probe(struct pci_dev *pci_dev, const struct pci_device_i
 	if (err < 0)
 		goto out_disable;
 
-	if (id->driver_data & (DEV_HAS_VLAN|DEV_HAS_MSI_X|DEV_HAS_POWER_CNTRL|DEV_HAS_STATISTICS_V2))
+	if (id->driver_data & (DEV_HAS_VLAN|DEV_HAS_MSI_X|DEV_HAS_POWER_CNTRL|DEV_HAS_STATISTICS_V2|DEV_HAS_STATISTICS_V3))
 		np->register_size = NV_PCI_REGSZ_VER3;
 	else if (id->driver_data & DEV_HAS_STATISTICS_V1)
 		np->register_size = NV_PCI_REGSZ_VER2;
@@ -6083,35 +6113,35 @@ static struct pci_device_id pci_tbl[] = {
 	},
 	{	/* MCP77 Ethernet Controller */
 		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_32),
-		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_CHECKSUM|DEV_HAS_HIGH_DMA|DEV_HAS_MSI|DEV_HAS_POWER_CNTRL|DEV_HAS_PAUSEFRAME_TX_V2|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT|DEV_HAS_CORRECT_MACADDR|DEV_HAS_COLLISION_FIX|DEV_NEED_TX_LIMIT|DEV_HAS_GEAR_MODE,
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_CHECKSUM|DEV_HAS_HIGH_DMA|DEV_HAS_MSI|DEV_HAS_POWER_CNTRL|DEV_HAS_PAUSEFRAME_TX_V2|DEV_HAS_STATISTICS_V3|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT|DEV_HAS_CORRECT_MACADDR|DEV_HAS_COLLISION_FIX|DEV_NEED_TX_LIMIT|DEV_HAS_GEAR_MODE,
 	},
 	{	/* MCP77 Ethernet Controller */
 		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_33),
-		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_CHECKSUM|DEV_HAS_HIGH_DMA|DEV_HAS_MSI|DEV_HAS_POWER_CNTRL|DEV_HAS_PAUSEFRAME_TX_V2|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT|DEV_HAS_CORRECT_MACADDR|DEV_HAS_COLLISION_FIX|DEV_NEED_TX_LIMIT|DEV_HAS_GEAR_MODE,
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_CHECKSUM|DEV_HAS_HIGH_DMA|DEV_HAS_MSI|DEV_HAS_POWER_CNTRL|DEV_HAS_PAUSEFRAME_TX_V2|DEV_HAS_STATISTICS_V3|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT|DEV_HAS_CORRECT_MACADDR|DEV_HAS_COLLISION_FIX|DEV_NEED_TX_LIMIT|DEV_HAS_GEAR_MODE,
 	},
 	{	/* MCP77 Ethernet Controller */
 		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_34),
-		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_CHECKSUM|DEV_HAS_HIGH_DMA|DEV_HAS_MSI|DEV_HAS_POWER_CNTRL|DEV_HAS_PAUSEFRAME_TX_V2|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT|DEV_HAS_CORRECT_MACADDR|DEV_HAS_COLLISION_FIX|DEV_NEED_TX_LIMIT|DEV_HAS_GEAR_MODE,
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_CHECKSUM|DEV_HAS_HIGH_DMA|DEV_HAS_MSI|DEV_HAS_POWER_CNTRL|DEV_HAS_PAUSEFRAME_TX_V2|DEV_HAS_STATISTICS_V3|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT|DEV_HAS_CORRECT_MACADDR|DEV_HAS_COLLISION_FIX|DEV_NEED_TX_LIMIT|DEV_HAS_GEAR_MODE,
 	},
 	{	/* MCP77 Ethernet Controller */
 		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_35),
-		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_CHECKSUM|DEV_HAS_HIGH_DMA|DEV_HAS_MSI|DEV_HAS_POWER_CNTRL|DEV_HAS_PAUSEFRAME_TX_V2|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT|DEV_HAS_CORRECT_MACADDR|DEV_HAS_COLLISION_FIX|DEV_NEED_TX_LIMIT|DEV_HAS_GEAR_MODE,
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_CHECKSUM|DEV_HAS_HIGH_DMA|DEV_HAS_MSI|DEV_HAS_POWER_CNTRL|DEV_HAS_PAUSEFRAME_TX_V2|DEV_HAS_STATISTICS_V3|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT|DEV_HAS_CORRECT_MACADDR|DEV_HAS_COLLISION_FIX|DEV_NEED_TX_LIMIT|DEV_HAS_GEAR_MODE,
 	},
 	{	/* MCP79 Ethernet Controller */
 		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_36),
-		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_CHECKSUM|DEV_HAS_HIGH_DMA|DEV_HAS_MSI|DEV_HAS_POWER_CNTRL|DEV_HAS_PAUSEFRAME_TX_V3|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT|DEV_HAS_CORRECT_MACADDR|DEV_HAS_COLLISION_FIX|DEV_NEED_TX_LIMIT|DEV_HAS_GEAR_MODE,
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_LARGEDESC|DEV_HAS_CHECKSUM|DEV_HAS_HIGH_DMA|DEV_HAS_MSI|DEV_HAS_POWER_CNTRL|DEV_HAS_PAUSEFRAME_TX_V3|DEV_HAS_STATISTICS_V3|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT|DEV_HAS_CORRECT_MACADDR|DEV_HAS_COLLISION_FIX|DEV_NEED_TX_LIMIT|DEV_HAS_GEAR_MODE,
 	},
 	{	/* MCP79 Ethernet Controller */
 		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_37),
-		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_CHECKSUM|DEV_HAS_HIGH_DMA|DEV_HAS_MSI|DEV_HAS_POWER_CNTRL|DEV_HAS_PAUSEFRAME_TX_V3|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT|DEV_HAS_CORRECT_MACADDR|DEV_HAS_COLLISION_FIX|DEV_NEED_TX_LIMIT|DEV_HAS_GEAR_MODE,
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_LARGEDESC|DEV_HAS_CHECKSUM|DEV_HAS_HIGH_DMA|DEV_HAS_MSI|DEV_HAS_POWER_CNTRL|DEV_HAS_PAUSEFRAME_TX_V3|DEV_HAS_STATISTICS_V3|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT|DEV_HAS_CORRECT_MACADDR|DEV_HAS_COLLISION_FIX|DEV_NEED_TX_LIMIT|DEV_HAS_GEAR_MODE,
 	},
 	{	/* MCP79 Ethernet Controller */
 		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_38),
-		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_CHECKSUM|DEV_HAS_HIGH_DMA|DEV_HAS_MSI|DEV_HAS_POWER_CNTRL|DEV_HAS_PAUSEFRAME_TX_V3|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT|DEV_HAS_CORRECT_MACADDR|DEV_HAS_COLLISION_FIX|DEV_NEED_TX_LIMIT|DEV_HAS_GEAR_MODE,
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_LARGEDESC|DEV_HAS_CHECKSUM|DEV_HAS_HIGH_DMA|DEV_HAS_MSI|DEV_HAS_POWER_CNTRL|DEV_HAS_PAUSEFRAME_TX_V3|DEV_HAS_STATISTICS_V3|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT|DEV_HAS_CORRECT_MACADDR|DEV_HAS_COLLISION_FIX|DEV_NEED_TX_LIMIT|DEV_HAS_GEAR_MODE,
 	},
 	{	/* MCP79 Ethernet Controller */
 		PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NVENET_39),
-		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_CHECKSUM|DEV_HAS_HIGH_DMA|DEV_HAS_MSI|DEV_HAS_POWER_CNTRL|DEV_HAS_PAUSEFRAME_TX_V3|DEV_HAS_STATISTICS_V2|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT|DEV_HAS_CORRECT_MACADDR|DEV_HAS_COLLISION_FIX|DEV_NEED_TX_LIMIT|DEV_HAS_GEAR_MODE,
+		.driver_data = DEV_NEED_TIMERIRQ|DEV_NEED_LINKTIMER|DEV_HAS_LARGEDESC|DEV_HAS_CHECKSUM|DEV_HAS_HIGH_DMA|DEV_HAS_MSI|DEV_HAS_POWER_CNTRL|DEV_HAS_PAUSEFRAME_TX_V3|DEV_HAS_STATISTICS_V3|DEV_HAS_TEST_EXTENDED|DEV_HAS_MGMT_UNIT|DEV_HAS_CORRECT_MACADDR|DEV_HAS_COLLISION_FIX|DEV_NEED_TX_LIMIT|DEV_HAS_GEAR_MODE,
 	},
 	{0,},
 };
diff --git a/drivers/net/fs_enet/mac-fcc.c b/drivers/net/fs_enet/mac-fcc.c
index 0a97fc2..1c7ef81 100644
--- a/drivers/net/fs_enet/mac-fcc.c
+++ b/drivers/net/fs_enet/mac-fcc.c
@@ -126,7 +126,7 @@ out:
 #define FCC_NAPI_RX_EVENT_MSK	(FCC_ENET_RXF | FCC_ENET_RXB)
 #define FCC_RX_EVENT		(FCC_ENET_RXF)
 #define FCC_TX_EVENT		(FCC_ENET_TXB)
-#define FCC_ERR_EVENT_MSK	(FCC_ENET_TXE | FCC_ENET_BSY)
+#define FCC_ERR_EVENT_MSK	(FCC_ENET_TXE)
 
 static int setup_data(struct net_device *dev)
 {
diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
index b8394cf..ca6cf6e 100644
--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -414,9 +414,7 @@ static int gfar_suspend(struct platform_device *pdev, pm_message_t state)
 		spin_unlock(&priv->rxlock);
 		spin_unlock_irqrestore(&priv->txlock, flags);
 
-#ifdef CONFIG_GFAR_NAPI
 		napi_disable(&priv->napi);
-#endif
 
 		if (magic_packet) {
 			/* Enable interrupt on Magic Packet */
@@ -469,9 +467,7 @@ static int gfar_resume(struct platform_device *pdev)
 
 	netif_device_attach(dev);
 
-#ifdef CONFIG_GFAR_NAPI
 	napi_enable(&priv->napi);
-#endif
 
 	return 0;
 }
diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index 3249df5..b8e25c4 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -548,7 +548,7 @@ static int ax_xmit(struct sk_buff *skb, struct net_device *dev)
 		}
 
 		printk(KERN_ERR "mkiss: %s: transmit timed out, %s?\n", dev->name,
-		       (ax->tty->ops->chars_in_buffer(ax->tty) || ax->xleft) ?
+		       (tty_chars_in_buffer(ax->tty) || ax->xleft) ?
 		       "bad line quality" : "driver error");
 
 		ax->xleft = 0;
diff --git a/drivers/net/igb/e1000_82575.c b/drivers/net/igb/e1000_82575.c
index e098f23..bb823ac 100644
--- a/drivers/net/igb/e1000_82575.c
+++ b/drivers/net/igb/e1000_82575.c
@@ -850,7 +850,7 @@ void igb_update_mc_addr_list_82575(struct e1000_hw *hw,
 	for (; mc_addr_count > 0; mc_addr_count--) {
 		hash_value = igb_hash_mc_addr(hw, mc_addr_list);
 		hw_dbg("Hash value = 0x%03X\n", hash_value);
-		hw->mac.ops.mta_set(hw, hash_value);
+		igb_mta_set(hw, hash_value);
 		mc_addr_list += ETH_ALEN;
 	}
 }
@@ -1136,6 +1136,12 @@ static s32 igb_setup_fiber_serdes_link_82575(struct e1000_hw *hw)
 		       E1000_PCS_LCTL_FORCE_LINK;     /* Force Link */
 		hw_dbg("Configuring Forced Link; PCS_LCTL = 0x%08X\n", reg);
 	}
+
+	if (hw->mac.type == e1000_82576) {
+		reg |= E1000_PCS_LCTL_FORCE_FCTRL;
+		igb_force_mac_fc(hw);
+	}
+
 	wr32(E1000_PCS_LCTL, reg);
 
 	return 0;
@@ -1232,70 +1238,6 @@ out:
 }
 
 /**
- *  igb_translate_register_82576 - Translate the proper register offset
- *  @reg: e1000 register to be read
- *
- *  Registers in 82576 are located in different offsets than other adapters
- *  even though they function in the same manner.  This function takes in
- *  the name of the register to read and returns the correct offset for
- *  82576 silicon.
- **/
-u32 igb_translate_register_82576(u32 reg)
-{
-	/*
-	 * Some of the Kawela registers are located at different
-	 * offsets than they are in older adapters.
-	 * Despite the difference in location, the registers
-	 * function in the same manner.
-	 */
-	switch (reg) {
-	case E1000_TDBAL(0):
-		reg = 0x0E000;
-		break;
-	case E1000_TDBAH(0):
-		reg = 0x0E004;
-		break;
-	case E1000_TDLEN(0):
-		reg = 0x0E008;
-		break;
-	case E1000_TDH(0):
-		reg = 0x0E010;
-		break;
-	case E1000_TDT(0):
-		reg = 0x0E018;
-		break;
-	case E1000_TXDCTL(0):
-		reg = 0x0E028;
-		break;
-	case E1000_RDBAL(0):
-		reg = 0x0C000;
-		break;
-	case E1000_RDBAH(0):
-		reg = 0x0C004;
-		break;
-	case E1000_RDLEN(0):
-		reg = 0x0C008;
-		break;
-	case E1000_RDH(0):
-		reg = 0x0C010;
-		break;
-	case E1000_RDT(0):
-		reg = 0x0C018;
-		break;
-	case E1000_RXDCTL(0):
-		reg = 0x0C028;
-		break;
-	case E1000_SRRCTL(0):
-		reg = 0x0C00C;
-		break;
-	default:
-		break;
-	}
-
-	return reg;
-}
-
-/**
  *  igb_reset_init_script_82575 - Inits HW defaults after reset
  *  @hw: pointer to the HW structure
  *
diff --git a/drivers/net/igb/e1000_82575.h b/drivers/net/igb/e1000_82575.h
index 2f848e5..c1928b5 100644
--- a/drivers/net/igb/e1000_82575.h
+++ b/drivers/net/igb/e1000_82575.h
@@ -28,7 +28,6 @@
 #ifndef _E1000_82575_H_
 #define _E1000_82575_H_
 
-u32 igb_translate_register_82576(u32 reg);
 void igb_update_mc_addr_list_82575(struct e1000_hw*, u8*, u32, u32, u32);
 extern void igb_shutdown_fiber_serdes_link_82575(struct e1000_hw *hw);
 extern void igb_rx_fifo_flush_82575(struct e1000_hw *hw);
diff --git a/drivers/net/igb/e1000_defines.h b/drivers/net/igb/e1000_defines.h
index afdba3c..ce70068 100644
--- a/drivers/net/igb/e1000_defines.h
+++ b/drivers/net/igb/e1000_defines.h
@@ -257,6 +257,7 @@
 #define E1000_PCS_LCTL_FDV_FULL          8
 #define E1000_PCS_LCTL_FSD               0x10
 #define E1000_PCS_LCTL_FORCE_LINK        0x20
+#define E1000_PCS_LCTL_FORCE_FCTRL       0x80
 #define E1000_PCS_LCTL_AN_ENABLE         0x10000
 #define E1000_PCS_LCTL_AN_RESTART        0x20000
 #define E1000_PCS_LCTL_AN_TIMEOUT        0x40000
diff --git a/drivers/net/igb/e1000_hw.h b/drivers/net/igb/e1000_hw.h
index 19fa4ee..a65ccc3 100644
--- a/drivers/net/igb/e1000_hw.h
+++ b/drivers/net/igb/e1000_hw.h
@@ -420,7 +420,6 @@ struct e1000_mac_operations {
 	void (*rar_set)(struct e1000_hw *, u8 *, u32);
 	s32  (*read_mac_addr)(struct e1000_hw *);
 	s32  (*get_speed_and_duplex)(struct e1000_hw *, u16 *, u16 *);
-	void (*mta_set)(struct e1000_hw *, u32);
 };
 
 struct e1000_phy_operations {
diff --git a/drivers/net/igb/e1000_mac.c b/drivers/net/igb/e1000_mac.c
index 20408aa..e18747c 100644
--- a/drivers/net/igb/e1000_mac.c
+++ b/drivers/net/igb/e1000_mac.c
@@ -144,34 +144,6 @@ void igb_write_vfta(struct e1000_hw *hw, u32 offset, u32 value)
 }
 
 /**
- *  igb_init_rx_addrs - Initialize receive address's
- *  @hw: pointer to the HW structure
- *  @rar_count: receive address registers
- *
- *  Setups the receive address registers by setting the base receive address
- *  register to the devices MAC address and clearing all the other receive
- *  address registers to 0.
- **/
-void igb_init_rx_addrs(struct e1000_hw *hw, u16 rar_count)
-{
-	u32 i;
-
-	/* Setup the receive address */
-	hw_dbg("Programming MAC Address into RAR[0]\n");
-
-	hw->mac.ops.rar_set(hw, hw->mac.addr, 0);
-
-	/* Zero out the other (rar_entry_count - 1) receive addresses */
-	hw_dbg("Clearing RAR[1-%u]\n", rar_count-1);
-	for (i = 1; i < rar_count; i++) {
-		array_wr32(E1000_RA, (i << 1), 0);
-		wrfl();
-		array_wr32(E1000_RA, ((i << 1) + 1), 0);
-		wrfl();
-	}
-}
-
-/**
  *  igb_check_alt_mac_addr - Check for alternate MAC addr
  *  @hw: pointer to the HW structure
  *
@@ -271,7 +243,7 @@ void igb_rar_set(struct e1000_hw *hw, u8 *addr, u32 index)
  *  current value is read, the new bit is OR'd in and the new value is
  *  written back into the register.
  **/
-static void igb_mta_set(struct e1000_hw *hw, u32 hash_value)
+void igb_mta_set(struct e1000_hw *hw, u32 hash_value)
 {
 	u32 hash_bit, hash_reg, mta;
 
@@ -297,60 +269,6 @@ static void igb_mta_set(struct e1000_hw *hw, u32 hash_value)
 }
 
 /**
- *  igb_update_mc_addr_list - Update Multicast addresses
- *  @hw: pointer to the HW structure
- *  @mc_addr_list: array of multicast addresses to program
- *  @mc_addr_count: number of multicast addresses to program
- *  @rar_used_count: the first RAR register free to program
- *  @rar_count: total number of supported Receive Address Registers
- *
- *  Updates the Receive Address Registers and Multicast Table Array.
- *  The caller must have a packed mc_addr_list of multicast addresses.
- *  The parameter rar_count will usually be hw->mac.rar_entry_count
- *  unless there are workarounds that change this.
- **/
-void igb_update_mc_addr_list(struct e1000_hw *hw,
-			       u8 *mc_addr_list, u32 mc_addr_count,
-			       u32 rar_used_count, u32 rar_count)
-{
-	u32 hash_value;
-	u32 i;
-
-	/*
-	 * Load the first set of multicast addresses into the exact
-	 * filters (RAR).  If there are not enough to fill the RAR
-	 * array, clear the filters.
-	 */
-	for (i = rar_used_count; i < rar_count; i++) {
-		if (mc_addr_count) {
-			hw->mac.ops.rar_set(hw, mc_addr_list, i);
-			mc_addr_count--;
-			mc_addr_list += ETH_ALEN;
-		} else {
-			array_wr32(E1000_RA, i << 1, 0);
-			wrfl();
-			array_wr32(E1000_RA, (i << 1) + 1, 0);
-			wrfl();
-		}
-	}
-
-	/* Clear the old settings from the MTA */
-	hw_dbg("Clearing MTA\n");
-	for (i = 0; i < hw->mac.mta_reg_count; i++) {
-		array_wr32(E1000_MTA, i, 0);
-		wrfl();
-	}
-
-	/* Load any remaining multicast addresses into the hash table. */
-	for (; mc_addr_count > 0; mc_addr_count--) {
-		hash_value = igb_hash_mc_addr(hw, mc_addr_list);
-		hw_dbg("Hash value = 0x%03X\n", hash_value);
-		igb_mta_set(hw, hash_value);
-		mc_addr_list += ETH_ALEN;
-	}
-}
-
-/**
  *  igb_hash_mc_addr - Generate a multicast hash value
  *  @hw: pointer to the HW structure
  *  @mc_addr: pointer to a multicast address
diff --git a/drivers/net/igb/e1000_mac.h b/drivers/net/igb/e1000_mac.h
index dc2f8cc..cbee6af 100644
--- a/drivers/net/igb/e1000_mac.h
+++ b/drivers/net/igb/e1000_mac.h
@@ -51,9 +51,6 @@ s32  igb_get_speed_and_duplex_copper(struct e1000_hw *hw, u16 *speed,
 				       u16 *duplex);
 s32  igb_id_led_init(struct e1000_hw *hw);
 s32  igb_led_off(struct e1000_hw *hw);
-void igb_update_mc_addr_list(struct e1000_hw *hw,
-			       u8 *mc_addr_list, u32 mc_addr_count,
-			       u32 rar_used_count, u32 rar_count);
 s32  igb_setup_link(struct e1000_hw *hw);
 s32  igb_validate_mdi_setting(struct e1000_hw *hw);
 s32  igb_write_8bit_ctrl_reg(struct e1000_hw *hw, u32 reg,
@@ -62,7 +59,7 @@ s32  igb_write_8bit_ctrl_reg(struct e1000_hw *hw, u32 reg,
 void igb_clear_hw_cntrs_base(struct e1000_hw *hw);
 void igb_clear_vfta(struct e1000_hw *hw);
 void igb_config_collision_dist(struct e1000_hw *hw);
-void igb_init_rx_addrs(struct e1000_hw *hw, u16 rar_count);
+void igb_mta_set(struct e1000_hw *hw, u32 hash_value);
 void igb_put_hw_semaphore(struct e1000_hw *hw);
 void igb_rar_set(struct e1000_hw *hw, u8 *addr, u32 index);
 s32  igb_check_alt_mac_addr(struct e1000_hw *hw);
diff --git a/drivers/net/igb/e1000_regs.h b/drivers/net/igb/e1000_regs.h
index b95093d..95523af 100644
--- a/drivers/net/igb/e1000_regs.h
+++ b/drivers/net/igb/e1000_regs.h
@@ -262,9 +262,6 @@
 #define E1000_RETA(_i)  (0x05C00 + ((_i) * 4))
 #define E1000_RSSRK(_i) (0x05C80 + ((_i) * 4)) /* RSS Random Key - RW Array */
 
-#define E1000_REGISTER(a, reg) (((a)->mac.type < e1000_82576) \
-                               ? reg : e1000_translate_register_82576(reg))
-
 #define wr32(reg, value) (writel(value, hw->hw_addr + reg))
 #define rd32(reg) (readl(hw->hw_addr + reg))
 #define wrfl() ((void)rd32(E1000_STATUS))
diff --git a/drivers/net/igb/igb_main.c b/drivers/net/igb/igb_main.c
index b602c4d..8f66e15 100644
--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -311,7 +311,7 @@ static void igb_assign_vector(struct igb_adapter *adapter, int rx_queue,
 		array_wr32(E1000_MSIXBM(0), msix_vector, msixbm);
 		break;
 	case e1000_82576:
-		/* Kawela uses a table-based method for assigning vectors.
+		/* The 82576 uses a table-based method for assigning vectors.
 		   Each queue has a single entry in the table to which we write
 		   a vector number along with a "valid" bit.  Sadly, the layout
 		   of the table is somewhat counterintuitive. */
@@ -720,28 +720,6 @@ static void igb_get_hw_control(struct igb_adapter *adapter)
 			ctrl_ext | E1000_CTRL_EXT_DRV_LOAD);
 }
 
-static void igb_init_manageability(struct igb_adapter *adapter)
-{
-	struct e1000_hw *hw = &adapter->hw;
-
-	if (adapter->en_mng_pt) {
-		u32 manc2h = rd32(E1000_MANC2H);
-		u32 manc = rd32(E1000_MANC);
-
-		/* enable receiving management packets to the host */
-		/* this will probably generate destination unreachable messages
-		 * from the host OS, but the packets will be handled on SMBUS */
-		manc |= E1000_MANC_EN_MNG2HOST;
-#define E1000_MNG2HOST_PORT_623 (1 << 5)
-#define E1000_MNG2HOST_PORT_664 (1 << 6)
-		manc2h |= E1000_MNG2HOST_PORT_623;
-		manc2h |= E1000_MNG2HOST_PORT_664;
-		wr32(E1000_MANC2H, manc2h);
-
-		wr32(E1000_MANC, manc);
-	}
-}
-
 /**
  * igb_configure - configure the hardware for RX and TX
  * @adapter: private board structure
@@ -755,7 +733,6 @@ static void igb_configure(struct igb_adapter *adapter)
 	igb_set_multi(netdev);
 
 	igb_restore_vlan(adapter);
-	igb_init_manageability(adapter);
 
 	igb_configure_tx(adapter);
 	igb_setup_rctl(adapter);
@@ -1372,7 +1349,8 @@ static void __devexit igb_remove(struct pci_dev *pdev)
 
 	unregister_netdev(netdev);
 
-	if (!igb_check_reset_block(&adapter->hw))
+	if (adapter->hw.phy.ops.reset_phy &&
+	    !igb_check_reset_block(&adapter->hw))
 		adapter->hw.phy.ops.reset_phy(&adapter->hw);
 
 	igb_remove_device(&adapter->hw);
@@ -4523,8 +4501,6 @@ static void igb_io_resume(struct pci_dev *pdev)
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct igb_adapter *adapter = netdev_priv(netdev);
 
-	igb_init_manageability(adapter);
-
 	if (netif_running(netdev)) {
 		if (igb_up(adapter)) {
 			dev_err(&pdev->dev, "igb_up failed after reset\n");
diff --git a/drivers/net/lp486e.c b/drivers/net/lp486e.c
index 591a7e4..83fa9d8 100644
--- a/drivers/net/lp486e.c
+++ b/drivers/net/lp486e.c
@@ -1272,8 +1272,6 @@ static void set_multicast_list(struct net_device *dev) {
 			return;
 		}
 		if (dev->mc_count == 0 && !(dev->flags & (IFF_PROMISC | IFF_ALLMULTI))) {
-			if (dev->flags & IFF_ALLMULTI)
-				dev->flags |= IFF_PROMISC;
 			lp->i596_config[8] &= ~0x01;
 		} else {
 			lp->i596_config[8] |= 0x01;
diff --git a/drivers/net/meth.c b/drivers/net/meth.c
index 4cb364e..0a97c26 100644
--- a/drivers/net/meth.c
+++ b/drivers/net/meth.c
@@ -100,7 +100,7 @@ static inline void load_eaddr(struct net_device *dev)
 	DPRINTK("Loading MAC Address: %s\n", print_mac(mac, dev->dev_addr));
 	macaddr = 0;
 	for (i = 0; i < 6; i++)
-		macaddr |= dev->dev_addr[i] << ((5 - i) * 8);
+		macaddr |= (u64)dev->dev_addr[i] << ((5 - i) * 8);
 
 	mace->eth.mac_addr = macaddr;
 }
diff --git a/drivers/net/myri10ge/myri10ge.c b/drivers/net/myri10ge/myri10ge.c
index 3ab0e52..f1de38f 100644
--- a/drivers/net/myri10ge/myri10ge.c
+++ b/drivers/net/myri10ge/myri10ge.c
@@ -3699,6 +3699,7 @@ static int myri10ge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev_err(&pdev->dev, "Error %d setting DMA mask\n", status);
 		goto abort_with_netdev;
 	}
+	(void)pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
 	mgp->cmd = dma_alloc_coherent(&pdev->dev, sizeof(*mgp->cmd),
 				      &mgp->cmd_bus, GFP_KERNEL);
 	if (mgp->cmd == NULL)
diff --git a/drivers/net/myri10ge/myri10ge_mcp.h b/drivers/net/myri10ge/myri10ge_mcp.h
index fdbeeee..9937210 100644
--- a/drivers/net/myri10ge/myri10ge_mcp.h
+++ b/drivers/net/myri10ge/myri10ge_mcp.h
@@ -101,6 +101,8 @@ struct mcp_kreq_ether_recv {
 #define	MXGEFW_ETH_SEND_3	0x2c0000
 #define	MXGEFW_ETH_RECV_SMALL	0x300000
 #define	MXGEFW_ETH_RECV_BIG	0x340000
+#define	MXGEFW_ETH_SEND_GO	0x380000
+#define	MXGEFW_ETH_SEND_STOP	0x3C0000
 
 #define	MXGEFW_ETH_SEND(n)		(0x200000 + (((n) & 0x03) * 0x40000))
 #define	MXGEFW_ETH_SEND_OFFSET(n)	(MXGEFW_ETH_SEND(n) - MXGEFW_ETH_SEND_4)
@@ -120,6 +122,11 @@ enum myri10ge_mcp_cmd_type {
 	 * MXGEFW_CMD_RESET is issued */
 
 	MXGEFW_CMD_SET_INTRQ_DMA,
+	/* data0 = LSW of the host address
+	 * data1 = MSW of the host address
+	 * data2 = slice number if multiple slices are used
+	 */
+
 	MXGEFW_CMD_SET_BIG_BUFFER_SIZE,	/* in bytes, power of 2 */
 	MXGEFW_CMD_SET_SMALL_BUFFER_SIZE,	/* in bytes */
 
@@ -129,6 +136,8 @@ enum myri10ge_mcp_cmd_type {
 	MXGEFW_CMD_GET_SEND_OFFSET,
 	MXGEFW_CMD_GET_SMALL_RX_OFFSET,
 	MXGEFW_CMD_GET_BIG_RX_OFFSET,
+	/* data0 = slice number if multiple slices are used */
+
 	MXGEFW_CMD_GET_IRQ_ACK_OFFSET,
 	MXGEFW_CMD_GET_IRQ_DEASSERT_OFFSET,
 
@@ -200,7 +209,12 @@ enum myri10ge_mcp_cmd_type {
 	MXGEFW_CMD_SET_STATS_DMA_V2,
 	/* data0, data1 = bus addr,
 	 * data2 = sizeof(struct mcp_irq_data) from driver point of view, allows
-	 * adding new stuff to mcp_irq_data without changing the ABI */
+	 * adding new stuff to mcp_irq_data without changing the ABI
+	 *
+	 * If multiple slices are used, data2 contains both the size of the
+	 * structure (in the lower 16 bits) and the slice number
+	 * (in the upper 16 bits).
+	 */
 
 	MXGEFW_CMD_UNALIGNED_TEST,
 	/* same than DMA_TEST (same args) but abort with UNALIGNED on unaligned
@@ -222,13 +236,18 @@ enum myri10ge_mcp_cmd_type {
 	MXGEFW_CMD_GET_MAX_RSS_QUEUES,
 	MXGEFW_CMD_ENABLE_RSS_QUEUES,
 	/* data0 = number of slices n (0, 1, ..., n-1) to enable
-	 * data1 = interrupt mode.
-	 * 0=share one INTx/MSI, 1=use one MSI-X per queue.
+	 * data1 = interrupt mode | use of multiple transmit queues.
+	 * 0=share one INTx/MSI.
+	 * 1=use one MSI-X per queue.
 	 * If all queues share one interrupt, the driver must have set
 	 * RSS_SHARED_INTERRUPT_DMA before enabling queues.
+	 * 2=enable both receive and send queues.
+	 * Without this bit set, only one send queue (slice 0's send queue)
+	 * is enabled.  The receive queues are always enabled.
 	 */
-#define MXGEFW_SLICE_INTR_MODE_SHARED 0
-#define MXGEFW_SLICE_INTR_MODE_ONE_PER_SLICE 1
+#define MXGEFW_SLICE_INTR_MODE_SHARED          0x0
+#define MXGEFW_SLICE_INTR_MODE_ONE_PER_SLICE   0x1
+#define MXGEFW_SLICE_ENABLE_MULTIPLE_TX_QUEUES 0x2
 
 	MXGEFW_CMD_GET_RSS_SHARED_INTERRUPT_MASK_OFFSET,
 	MXGEFW_CMD_SET_RSS_SHARED_INTERRUPT_DMA,
@@ -250,10 +269,13 @@ enum myri10ge_mcp_cmd_type {
 	 * 2: TCP_IPV4        (required by RSS)
 	 * 3: IPV4 | TCP_IPV4 (required by RSS)
 	 * 4: source port
+	 * 5: source port + destination port
 	 */
 #define MXGEFW_RSS_HASH_TYPE_IPV4      0x1
 #define MXGEFW_RSS_HASH_TYPE_TCP_IPV4  0x2
 #define MXGEFW_RSS_HASH_TYPE_SRC_PORT  0x4
+#define MXGEFW_RSS_HASH_TYPE_SRC_DST_PORT 0x5
+#define MXGEFW_RSS_HASH_TYPE_MAX 0x5
 
 	MXGEFW_CMD_GET_MAX_TSO6_HDR_SIZE,
 	/* Return data = the max. size of the entire headers of a IPv6 TSO packet.
@@ -329,6 +351,20 @@ enum myri10ge_mcp_cmd_type {
 
 	MXGEFW_CMD_GET_DCA_OFFSET,
 	/* offset of dca control for WDMAs */
+
+	/* VMWare NetQueue commands */
+	MXGEFW_CMD_NETQ_GET_FILTERS_PER_QUEUE,
+	MXGEFW_CMD_NETQ_ADD_FILTER,
+	/* data0 = filter_id << 16 | queue << 8 | type */
+	/* data1 = MS4 of MAC Addr */
+	/* data2 = LS2_MAC << 16 | VLAN_tag */
+	MXGEFW_CMD_NETQ_DEL_FILTER,
+	/* data0 = filter_id */
+	MXGEFW_CMD_NETQ_QUERY1,
+	MXGEFW_CMD_NETQ_QUERY2,
+	MXGEFW_CMD_NETQ_QUERY3,
+	MXGEFW_CMD_NETQ_QUERY4,
+
 };
 
 enum myri10ge_mcp_cmd_status {
@@ -381,4 +417,10 @@ struct mcp_irq_data {
 	u8 valid;
 };
 
+/* definitions for NETQ filter type */
+#define MXGEFW_NETQ_FILTERTYPE_NONE 0
+#define MXGEFW_NETQ_FILTERTYPE_MACADDR 1
+#define MXGEFW_NETQ_FILTERTYPE_VLAN 2
+#define MXGEFW_NETQ_FILTERTYPE_VLANMACADDR 3
+
 #endif				/* __MYRI10GE_MCP_H__ */
diff --git a/drivers/net/myri10ge/myri10ge_mcp_gen_header.h b/drivers/net/myri10ge/myri10ge_mcp_gen_header.h
index 07d65c2..a8662ea 100644
--- a/drivers/net/myri10ge/myri10ge_mcp_gen_header.h
+++ b/drivers/net/myri10ge/myri10ge_mcp_gen_header.h
@@ -35,7 +35,7 @@ struct mcp_gen_header {
 	unsigned char mcp_index;
 	unsigned char disable_rabbit;
 	unsigned char unaligned_tlp;
-	unsigned char pad1;
+	unsigned char pcie_link_algo;
 	unsigned counters_addr;
 	unsigned copy_block_info;	/* for small mcps loaded with "lload -d" */
 	unsigned short handoff_id_major;	/* must be equal */
diff --git a/drivers/net/netxen/netxen_nic.h b/drivers/net/netxen/netxen_nic.h
index 8e73661..93a7b9b 100644
--- a/drivers/net/netxen/netxen_nic.h
+++ b/drivers/net/netxen/netxen_nic.h
@@ -508,6 +508,8 @@ typedef enum {
 	NETXEN_BRDTYPE_P3_10000_BASE_T = 0x0027,
 	NETXEN_BRDTYPE_P3_XG_LOM = 0x0028,
 	NETXEN_BRDTYPE_P3_4_GB_MM = 0x0029,
+	NETXEN_BRDTYPE_P3_10G_SFP_CT = 0x002a,
+	NETXEN_BRDTYPE_P3_10G_SFP_QT = 0x002b,
 	NETXEN_BRDTYPE_P3_10G_CX4 = 0x0031,
 	NETXEN_BRDTYPE_P3_10G_XFP = 0x0032
 
@@ -1170,6 +1172,36 @@ typedef struct {
 	nx_nic_intr_coalesce_data_t	irq;
 } nx_nic_intr_coalesce_t;
 
+#define NX_HOST_REQUEST		0x13
+#define NX_NIC_REQUEST		0x14
+
+#define NX_MAC_EVENT		0x1
+
+enum {
+	NX_NIC_H2C_OPCODE_START = 0,
+	NX_NIC_H2C_OPCODE_CONFIG_RSS,
+	NX_NIC_H2C_OPCODE_CONFIG_RSS_TBL,
+	NX_NIC_H2C_OPCODE_CONFIG_INTR_COALESCE,
+	NX_NIC_H2C_OPCODE_CONFIG_LED,
+	NX_NIC_H2C_OPCODE_CONFIG_PROMISCUOUS,
+	NX_NIC_H2C_OPCODE_CONFIG_L2_MAC,
+	NX_NIC_H2C_OPCODE_LRO_REQUEST,
+	NX_NIC_H2C_OPCODE_GET_SNMP_STATS,
+	NX_NIC_H2C_OPCODE_PROXY_START_REQUEST,
+	NX_NIC_H2C_OPCODE_PROXY_STOP_REQUEST,
+	NX_NIC_H2C_OPCODE_PROXY_SET_MTU,
+	NX_NIC_H2C_OPCODE_PROXY_SET_VPORT_MISS_MODE,
+	NX_H2P_OPCODE_GET_FINGER_PRINT_REQUEST,
+	NX_H2P_OPCODE_INSTALL_LICENSE_REQUEST,
+	NX_H2P_OPCODE_GET_LICENSE_CAPABILITY_REQUEST,
+	NX_NIC_H2C_OPCODE_GET_NET_STATS,
+	NX_NIC_H2C_OPCODE_LAST
+};
+
+#define VPORT_MISS_MODE_DROP		0 /* drop all unmatched */
+#define VPORT_MISS_MODE_ACCEPT_ALL	1 /* accept all packets */
+#define VPORT_MISS_MODE_ACCEPT_MULTI	2 /* accept unmatched multicast */
+
 typedef struct {
 	u64 qhdr;
 	u64 req_hdr;
@@ -1288,7 +1320,7 @@ struct netxen_adapter {
 	int (*disable_phy_interrupts) (struct netxen_adapter *);
 	int (*macaddr_set) (struct netxen_adapter *, netxen_ethernet_macaddr_t);
 	int (*set_mtu) (struct netxen_adapter *, int);
-	int (*set_promisc) (struct netxen_adapter *, netxen_niu_prom_mode_t);
+	int (*set_promisc) (struct netxen_adapter *, u32);
 	int (*phy_read) (struct netxen_adapter *, long reg, u32 *);
 	int (*phy_write) (struct netxen_adapter *, long reg, u32 val);
 	int (*init_port) (struct netxen_adapter *, int);
@@ -1465,9 +1497,10 @@ int netxen_process_cmd_ring(struct netxen_adapter *adapter);
 u32 netxen_process_rcv_ring(struct netxen_adapter *adapter, int ctx, int max);
 void netxen_p2_nic_set_multi(struct net_device *netdev);
 void netxen_p3_nic_set_multi(struct net_device *netdev);
+int netxen_p3_nic_set_promisc(struct netxen_adapter *adapter, u32);
 int netxen_config_intr_coalesce(struct netxen_adapter *adapter);
 
-u32 nx_fw_cmd_set_mtu(struct netxen_adapter *adapter, u32 mtu);
+int nx_fw_cmd_set_mtu(struct netxen_adapter *adapter, int mtu);
 int netxen_nic_change_mtu(struct net_device *netdev, int new_mtu);
 
 int netxen_nic_set_mac(struct net_device *netdev, void *p);
@@ -1502,7 +1535,9 @@ static const struct netxen_brdinfo netxen_boards[] = {
 	{NETXEN_BRDTYPE_P3_10G_SFP_PLUS, 2, "Dual XGb SFP+ LP"},
 	{NETXEN_BRDTYPE_P3_10000_BASE_T, 1, "XGB 10G BaseT LP"},
 	{NETXEN_BRDTYPE_P3_XG_LOM,  2, "Dual XGb LOM"},
-	{NETXEN_BRDTYPE_P3_4_GB_MM, 4, "Quad GB - March Madness"},
+	{NETXEN_BRDTYPE_P3_4_GB_MM, 4, "NX3031 Gigabit Ethernet"},
+	{NETXEN_BRDTYPE_P3_10G_SFP_CT, 2, "NX3031 10 Gigabit Ethernet"},
+	{NETXEN_BRDTYPE_P3_10G_SFP_QT, 2, "Quanta Dual XGb SFP+"},
 	{NETXEN_BRDTYPE_P3_10G_CX4, 2, "Reference Dual CX4 Option"},
 	{NETXEN_BRDTYPE_P3_10G_XFP, 1, "Reference Single XFP Option"}
 };
diff --git a/drivers/net/netxen/netxen_nic_ctx.c b/drivers/net/netxen/netxen_nic_ctx.c
index 64babc5..64b5164 100644
--- a/drivers/net/netxen/netxen_nic_ctx.c
+++ b/drivers/net/netxen/netxen_nic_ctx.c
@@ -145,8 +145,8 @@ netxen_issue_cmd(struct netxen_adapter *adapter,
 	return rcode;
 }
 
-u32
-nx_fw_cmd_set_mtu(struct netxen_adapter *adapter, u32 mtu)
+int
+nx_fw_cmd_set_mtu(struct netxen_adapter *adapter, int mtu)
 {
 	u32 rcode = NX_RCODE_SUCCESS;
 	struct netxen_recv_context *recv_ctx = &adapter->recv_ctx[0];
@@ -160,7 +160,10 @@ nx_fw_cmd_set_mtu(struct netxen_adapter *adapter, u32 mtu)
 				0,
 				NX_CDRP_CMD_SET_MTU);
 
-	return rcode;
+	if (rcode != NX_RCODE_SUCCESS)
+		return -EIO;
+
+	return 0;
 }
 
 static int
diff --git a/drivers/net/netxen/netxen_nic_ethtool.c b/drivers/net/netxen/netxen_nic_ethtool.c
index 48ee06b..4ad3e08 100644
--- a/drivers/net/netxen/netxen_nic_ethtool.c
+++ b/drivers/net/netxen/netxen_nic_ethtool.c
@@ -140,18 +140,33 @@ netxen_nic_get_settings(struct net_device *dev, struct ethtool_cmd *ecmd)
 		if (netif_running(dev)) {
 			ecmd->speed = adapter->link_speed;
 			ecmd->duplex = adapter->link_duplex;
-		} else
-			return -EIO;	/* link absent */
+			ecmd->autoneg = adapter->link_autoneg;
+		}
+
 	} else if (adapter->ahw.board_type == NETXEN_NIC_XGBE) {
-		ecmd->supported = (SUPPORTED_TP |
-				   SUPPORTED_1000baseT_Full |
-				   SUPPORTED_10000baseT_Full);
-		ecmd->advertising = (ADVERTISED_TP |
-				     ADVERTISED_1000baseT_Full |
-				     ADVERTISED_10000baseT_Full);
+		u32 val;
+
+		adapter->hw_read_wx(adapter, NETXEN_PORT_MODE_ADDR, &val, 4);
+		if (val == NETXEN_PORT_MODE_802_3_AP) {
+			ecmd->supported = SUPPORTED_1000baseT_Full;
+			ecmd->advertising = ADVERTISED_1000baseT_Full;
+		} else {
+			ecmd->supported = SUPPORTED_10000baseT_Full;
+			ecmd->advertising = ADVERTISED_10000baseT_Full;
+		}
+
 		ecmd->port = PORT_TP;
 
-		ecmd->speed = SPEED_10000;
+		if (NX_IS_REVISION_P3(adapter->ahw.revision_id)) {
+			u16 pcifn = adapter->ahw.pci_func;
+
+			adapter->hw_read_wx(adapter,
+				P3_LINK_SPEED_REG(pcifn), &val, 4);
+			ecmd->speed = P3_LINK_SPEED_MHZ *
+					P3_LINK_SPEED_VAL(pcifn, val);
+		} else
+			ecmd->speed = SPEED_10000;
+
 		ecmd->duplex = DUPLEX_FULL;
 		ecmd->autoneg = AUTONEG_DISABLE;
 	} else
@@ -192,6 +207,8 @@ netxen_nic_get_settings(struct net_device *dev, struct ethtool_cmd *ecmd)
 		break;
 	case NETXEN_BRDTYPE_P2_SB31_10G:
 	case NETXEN_BRDTYPE_P3_10G_SFP_PLUS:
+	case NETXEN_BRDTYPE_P3_10G_SFP_CT:
+	case NETXEN_BRDTYPE_P3_10G_SFP_QT:
 	case NETXEN_BRDTYPE_P3_10G_XFP:
 		ecmd->supported |= SUPPORTED_FIBRE;
 		ecmd->advertising |= ADVERTISED_FIBRE;
diff --git a/drivers/net/netxen/netxen_nic_hdr.h b/drivers/net/netxen/netxen_nic_hdr.h
index 3ce13e4..e8e8d73 100644
--- a/drivers/net/netxen/netxen_nic_hdr.h
+++ b/drivers/net/netxen/netxen_nic_hdr.h
@@ -724,6 +724,13 @@ enum {
 #define XG_LINK_STATE_P3(pcifn,val) \
 	(((val) >> ((pcifn) * 4)) & XG_LINK_STATE_P3_MASK)
 
+#define P3_LINK_SPEED_MHZ	100
+#define P3_LINK_SPEED_MASK	0xff
+#define P3_LINK_SPEED_REG(pcifn)	\
+	(CRB_PF_LINK_SPEED_1 + (((pcifn) / 4) * 4))
+#define P3_LINK_SPEED_VAL(pcifn, reg)	\
+	(((reg) >> (8 * ((pcifn) & 0x3))) & P3_LINK_SPEED_MASK)
+
 #define NETXEN_CAM_RAM_BASE	(NETXEN_CRB_CAM + 0x02000)
 #define NETXEN_CAM_RAM(reg)	(NETXEN_CAM_RAM_BASE + (reg))
 #define NETXEN_FW_VERSION_MAJOR (NETXEN_CAM_RAM(0x150))
@@ -836,9 +843,11 @@ enum {
 
 #define PCIE_SETUP_FUNCTION	(0x12040)
 #define PCIE_SETUP_FUNCTION2	(0x12048)
+#define PCIE_MISCCFG_RC         (0x1206c)
 #define PCIE_TGT_SPLIT_CHICKEN	(0x12080)
 #define PCIE_CHICKEN3		(0x120c8)
 
+#define ISR_INT_STATE_REG       (NETXEN_PCIX_PS_REG(PCIE_MISCCFG_RC))
 #define PCIE_MAX_MASTER_SPLIT	(0x14048)
 
 #define NETXEN_PORT_MODE_NONE		0
@@ -854,6 +863,7 @@ enum {
 #define NETXEN_CAM_RAM_DMA_WATCHDOG_CTRL		(0x14)
 
 #define	ISR_MSI_INT_TRIGGER(FUNC) (NETXEN_PCIX_PS_REG(PCIX_MSI_F(FUNC)))
+#define ISR_LEGACY_INT_TRIGGERED(VAL)	(((VAL) & 0x300) == 0x200)
 
 /*
  * PCI Interrupt Vector Values.
diff --git a/drivers/net/netxen/netxen_nic_hw.c b/drivers/net/netxen/netxen_nic_hw.c
index 96a3bc6..9aa20f9 100644
--- a/drivers/net/netxen/netxen_nic_hw.c
+++ b/drivers/net/netxen/netxen_nic_hw.c
@@ -285,14 +285,7 @@ static unsigned crb_hub_agt[64] =
 #define ADDR_IN_RANGE(addr, low, high)	\
 	(((addr) <= (high)) && ((addr) >= (low)))
 
-#define NETXEN_MAX_MTU		8000 + NETXEN_ENET_HEADER_SIZE + NETXEN_ETH_FCS_SIZE
-#define NETXEN_MIN_MTU		64
-#define NETXEN_ETH_FCS_SIZE     4
-#define NETXEN_ENET_HEADER_SIZE 14
 #define NETXEN_WINDOW_ONE 	0x2000000 /*CRB Window: bit 25 of CRB address */
-#define NETXEN_FIRMWARE_LEN 	((16 * 1024) / 4)
-#define NETXEN_NIU_HDRSIZE	(0x1 << 6)
-#define NETXEN_NIU_TLRSIZE	(0x1 << 5)
 
 #define NETXEN_NIC_ZERO_PAUSE_ADDR     0ULL
 #define NETXEN_NIC_UNIT_PAUSE_ADDR     0x200ULL
@@ -541,9 +534,6 @@ netxen_send_cmd_descs(struct netxen_adapter *adapter,
 	return 0;
 }
 
-#define NIC_REQUEST		0x14
-#define NETXEN_MAC_EVENT	0x1
-
 static int nx_p3_sre_macaddr_change(struct net_device *dev,
 		u8 *addr, unsigned op)
 {
@@ -553,8 +543,8 @@ static int nx_p3_sre_macaddr_change(struct net_device *dev,
 	int rv;
 
 	memset(&req, 0, sizeof(nx_nic_req_t));
-	req.qhdr |= (NIC_REQUEST << 23);
-	req.req_hdr |= NETXEN_MAC_EVENT;
+	req.qhdr |= (NX_NIC_REQUEST << 23);
+	req.req_hdr |= NX_MAC_EVENT;
 	req.req_hdr |= ((u64)adapter->portnum << 16);
 	mac_req.op = op;
 	memcpy(&mac_req.mac_addr, addr, 6);
@@ -575,31 +565,35 @@ void netxen_p3_nic_set_multi(struct net_device *netdev)
 	nx_mac_list_t *cur, *next, *del_list, *add_list = NULL;
 	struct dev_mc_list *mc_ptr;
 	u8 bcast_addr[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
-
-	adapter->set_promisc(adapter, NETXEN_NIU_PROMISC_MODE);
-
-	/*
-	 * Programming mac addresses will automaticly enabling L2 filtering.
-	 * HW will replace timestamp with L2 conid when L2 filtering is
-	 * enabled. This causes problem for LSA. Do not enabling L2 filtering
-	 * until that problem is fixed.
-	 */
-	if ((netdev->flags & IFF_PROMISC) ||
-			(netdev->mc_count > adapter->max_mc_count))
-		return;
+	u32 mode = VPORT_MISS_MODE_DROP;
 
 	del_list = adapter->mac_list;
 	adapter->mac_list = NULL;
 
 	nx_p3_nic_add_mac(adapter, netdev->dev_addr, &add_list, &del_list);
+	nx_p3_nic_add_mac(adapter, bcast_addr, &add_list, &del_list);
+
+	if (netdev->flags & IFF_PROMISC) {
+		mode = VPORT_MISS_MODE_ACCEPT_ALL;
+		goto send_fw_cmd;
+	}
+
+	if ((netdev->flags & IFF_ALLMULTI) ||
+			(netdev->mc_count > adapter->max_mc_count)) {
+		mode = VPORT_MISS_MODE_ACCEPT_MULTI;
+		goto send_fw_cmd;
+	}
+
 	if (netdev->mc_count > 0) {
-		nx_p3_nic_add_mac(adapter, bcast_addr, &add_list, &del_list);
 		for (mc_ptr = netdev->mc_list; mc_ptr;
 		     mc_ptr = mc_ptr->next) {
 			nx_p3_nic_add_mac(adapter, mc_ptr->dmi_addr,
 					  &add_list, &del_list);
 		}
 	}
+
+send_fw_cmd:
+	adapter->set_promisc(adapter, mode);
 	for (cur = del_list; cur;) {
 		nx_p3_sre_macaddr_change(netdev, cur->mac_addr, NETXEN_MAC_DEL);
 		next = cur->next;
@@ -615,6 +609,21 @@ void netxen_p3_nic_set_multi(struct net_device *netdev)
 	}
 }
 
+int netxen_p3_nic_set_promisc(struct netxen_adapter *adapter, u32 mode)
+{
+	nx_nic_req_t req;
+
+	memset(&req, 0, sizeof(nx_nic_req_t));
+
+	req.qhdr |= (NX_HOST_REQUEST << 23);
+	req.req_hdr |= NX_NIC_H2C_OPCODE_PROXY_SET_VPORT_MISS_MODE;
+	req.req_hdr |= ((u64)adapter->portnum << 16);
+	req.words[0] = cpu_to_le64(mode);
+
+	return netxen_send_cmd_descs(adapter,
+				(struct cmd_desc_type0 *)&req, 1);
+}
+
 #define	NETXEN_CONFIG_INTR_COALESCE	3
 
 /*
@@ -627,7 +636,7 @@ int netxen_config_intr_coalesce(struct netxen_adapter *adapter)
 
 	memset(&req, 0, sizeof(nx_nic_req_t));
 
-	req.qhdr |= (NIC_REQUEST << 23);
+	req.qhdr |= (NX_NIC_REQUEST << 23);
 	req.req_hdr |= NETXEN_CONFIG_INTR_COALESCE;
 	req.req_hdr |= ((u64)adapter->portnum << 16);
 
@@ -653,6 +662,7 @@ int netxen_nic_change_mtu(struct net_device *netdev, int mtu)
 {
 	struct netxen_adapter *adapter = netdev_priv(netdev);
 	int max_mtu;
+	int rc = 0;
 
 	if (NX_IS_REVISION_P3(adapter->ahw.revision_id))
 		max_mtu = P3_MAX_MTU;
@@ -666,16 +676,12 @@ int netxen_nic_change_mtu(struct net_device *netdev, int mtu)
 	}
 
 	if (adapter->set_mtu)
-		adapter->set_mtu(adapter, mtu);
-	netdev->mtu = mtu;
+		rc = adapter->set_mtu(adapter, mtu);
 
-	mtu += MTU_FUDGE_FACTOR;
-	if (NX_IS_REVISION_P3(adapter->ahw.revision_id))
-		nx_fw_cmd_set_mtu(adapter, mtu);
-	else if (adapter->set_mtu)
-		adapter->set_mtu(adapter, mtu);
+	if (!rc)
+		netdev->mtu = mtu;
 
-	return 0;
+	return rc;
 }
 
 int netxen_is_flash_supported(struct netxen_adapter *adapter)
@@ -1411,7 +1417,8 @@ static int netxen_nic_pci_mem_read_direct(struct netxen_adapter *adapter,
 		(netxen_nic_pci_is_same_window(adapter, off+size-1) == 0)) {
 		write_unlock_irqrestore(&adapter->adapter_lock, flags);
 		printk(KERN_ERR "%s out of bound pci memory access. "
-			"offset is 0x%llx\n", netxen_nic_driver_name, off);
+			"offset is 0x%llx\n", netxen_nic_driver_name,
+			(unsigned long long)off);
 		return -1;
 	}
 
@@ -1484,7 +1491,8 @@ netxen_nic_pci_mem_write_direct(struct netxen_adapter *adapter, u64 off,
 		(netxen_nic_pci_is_same_window(adapter, off+size-1) == 0)) {
 		write_unlock_irqrestore(&adapter->adapter_lock, flags);
 		printk(KERN_ERR "%s out of bound pci memory access. "
-			"offset is 0x%llx\n", netxen_nic_driver_name, off);
+			"offset is 0x%llx\n", netxen_nic_driver_name,
+			(unsigned long long)off);
 		return -1;
 	}
 
@@ -2016,6 +2024,8 @@ int netxen_nic_get_board_info(struct netxen_adapter *adapter)
 	case NETXEN_BRDTYPE_P3_10G_CX4_LP:
 	case NETXEN_BRDTYPE_P3_IMEZ:
 	case NETXEN_BRDTYPE_P3_10G_SFP_PLUS:
+	case NETXEN_BRDTYPE_P3_10G_SFP_CT:
+	case NETXEN_BRDTYPE_P3_10G_SFP_QT:
 	case NETXEN_BRDTYPE_P3_10G_XFP:
 	case NETXEN_BRDTYPE_P3_10000_BASE_T:
 
@@ -2034,6 +2044,7 @@ int netxen_nic_get_board_info(struct netxen_adapter *adapter)
 	default:
 		printk("%s: Unknown(%x)\n", netxen_nic_driver_name,
 		       boardinfo->board_type);
+		rv = -ENODEV;
 		break;
 	}
 
@@ -2044,6 +2055,7 @@ int netxen_nic_get_board_info(struct netxen_adapter *adapter)
 
 int netxen_nic_set_mtu_gb(struct netxen_adapter *adapter, int new_mtu)
 {
+	new_mtu += MTU_FUDGE_FACTOR;
 	netxen_nic_write_w0(adapter,
 		NETXEN_NIU_GB_MAX_FRAME_SIZE(adapter->physical_port),
 		new_mtu);
@@ -2052,7 +2064,7 @@ int netxen_nic_set_mtu_gb(struct netxen_adapter *adapter, int new_mtu)
 
 int netxen_nic_set_mtu_xgb(struct netxen_adapter *adapter, int new_mtu)
 {
-	new_mtu += NETXEN_NIU_HDRSIZE + NETXEN_NIU_TLRSIZE;
+	new_mtu += MTU_FUDGE_FACTOR;
 	if (adapter->physical_port == 0)
 		netxen_nic_write_w0(adapter, NETXEN_NIU_XGE_MAX_FRAME_SIZE,
 				new_mtu);
@@ -2074,12 +2086,22 @@ void netxen_nic_set_link_parameters(struct netxen_adapter *adapter)
 	__u32 status;
 	__u32 autoneg;
 	__u32 mode;
+	__u32 port_mode;
 
 	netxen_nic_read_w0(adapter, NETXEN_NIU_MODE, &mode);
 	if (netxen_get_niu_enable_ge(mode)) {	/* Gb 10/100/1000 Mbps mode */
+
+		adapter->hw_read_wx(adapter,
+				NETXEN_PORT_MODE_ADDR, &port_mode, 4);
+		if (port_mode == NETXEN_PORT_MODE_802_3_AP) {
+			adapter->link_speed   = SPEED_1000;
+			adapter->link_duplex  = DUPLEX_FULL;
+			adapter->link_autoneg = AUTONEG_DISABLE;
+			return;
+		}
+
 		if (adapter->phy_read
-		    && adapter->
-		    phy_read(adapter,
+		    && adapter->phy_read(adapter,
 			     NETXEN_NIU_GB_MII_MGMT_ADDR_PHY_STATUS,
 			     &status) == 0) {
 			if (netxen_get_phy_link(status)) {
@@ -2109,8 +2131,7 @@ void netxen_nic_set_link_parameters(struct netxen_adapter *adapter)
 					break;
 				}
 				if (adapter->phy_read
-				    && adapter->
-				    phy_read(adapter,
+				    && adapter->phy_read(adapter,
 					     NETXEN_NIU_GB_MII_MGMT_ADDR_AUTONEG,
 					     &autoneg) != 0)
 					adapter->link_autoneg = autoneg;
diff --git a/drivers/net/netxen/netxen_nic_hw.h b/drivers/net/netxen/netxen_nic_hw.h
index b8e0030..aae737d 100644
--- a/drivers/net/netxen/netxen_nic_hw.h
+++ b/drivers/net/netxen/netxen_nic_hw.h
@@ -419,12 +419,9 @@ typedef enum {
 #define netxen_get_niu_enable_ge(config_word)	\
 		_netxen_crb_get_bit(config_word, 1)
 
-/* Promiscous mode options (GbE mode only) */
-typedef enum {
-	NETXEN_NIU_PROMISC_MODE = 0,
-	NETXEN_NIU_NON_PROMISC_MODE,
-	NETXEN_NIU_ALLMULTI_MODE
-} netxen_niu_prom_mode_t;
+#define NETXEN_NIU_NON_PROMISC_MODE	0
+#define NETXEN_NIU_PROMISC_MODE		1
+#define NETXEN_NIU_ALLMULTI_MODE	2
 
 /*
  * NIU GB Drop CRC Register
@@ -471,9 +468,9 @@ typedef enum {
 
 /* Set promiscuous mode for a GbE interface */
 int netxen_niu_set_promiscuous_mode(struct netxen_adapter *adapter,
-				    netxen_niu_prom_mode_t mode);
+				    u32 mode);
 int netxen_niu_xg_set_promiscuous_mode(struct netxen_adapter *adapter,
-				       netxen_niu_prom_mode_t mode);
+				       u32 mode);
 
 /* set the MAC address for a given MAC */
 int netxen_niu_macaddr_set(struct netxen_adapter *adapter,
diff --git a/drivers/net/netxen/netxen_nic_init.c b/drivers/net/netxen/netxen_nic_init.c
index 01ab31b..519fc86 100644
--- a/drivers/net/netxen/netxen_nic_init.c
+++ b/drivers/net/netxen/netxen_nic_init.c
@@ -364,6 +364,11 @@ void netxen_initialize_adapter_ops(struct netxen_adapter *adapter)
 	default:
 		break;
 	}
+
+	if (NX_IS_REVISION_P3(adapter->ahw.revision_id)) {
+		adapter->set_mtu = nx_fw_cmd_set_mtu;
+		adapter->set_promisc = netxen_p3_nic_set_promisc;
+	}
 }
 
 /*
diff --git a/drivers/net/netxen/netxen_nic_main.c b/drivers/net/netxen/netxen_nic_main.c
index 91d209a..7615c71 100644
--- a/drivers/net/netxen/netxen_nic_main.c
+++ b/drivers/net/netxen/netxen_nic_main.c
@@ -166,7 +166,8 @@ static void netxen_nic_disable_int(struct netxen_adapter *adapter)
 	if (!NETXEN_IS_MSI_FAMILY(adapter)) {
 		do {
 			adapter->pci_write_immediate(adapter,
-					ISR_INT_TARGET_STATUS, 0xffffffff);
+					adapter->legacy_intr.tgt_status_reg,
+					0xffffffff);
 			mask = adapter->pci_read_immediate(adapter,
 					ISR_INT_VECTOR);
 			if (!(mask & 0x80))
@@ -175,7 +176,7 @@ static void netxen_nic_disable_int(struct netxen_adapter *adapter)
 		} while (--retries);
 
 		if (!retries) {
-			printk(KERN_NOTICE "%s: Failed to disable interrupt completely\n",
+			printk(KERN_NOTICE "%s: Failed to disable interrupt\n",
 					netxen_nic_driver_name);
 		}
 	} else {
@@ -190,8 +191,6 @@ static void netxen_nic_enable_int(struct netxen_adapter *adapter)
 {
 	u32 mask;
 
-	DPRINTK(1, INFO, "Entered ISR Enable \n");
-
 	if (adapter->intr_scheme != -1 &&
 		adapter->intr_scheme != INTR_SCHEME_PERPORT) {
 		switch (adapter->ahw.board_type) {
@@ -213,16 +212,13 @@ static void netxen_nic_enable_int(struct netxen_adapter *adapter)
 
 	if (!NETXEN_IS_MSI_FAMILY(adapter)) {
 		mask = 0xbff;
-		if (adapter->intr_scheme != -1 &&
-			adapter->intr_scheme != INTR_SCHEME_PERPORT) {
+		if (adapter->intr_scheme == INTR_SCHEME_PERPORT)
+			adapter->pci_write_immediate(adapter,
+				adapter->legacy_intr.tgt_mask_reg, mask);
+		else
 			adapter->pci_write_normalize(adapter,
 					CRB_INT_VECTOR, 0);
-		}
-		adapter->pci_write_immediate(adapter,
-				ISR_INT_TARGET_MASK, mask);
 	}
-
-	DPRINTK(1, INFO, "Done with enable Int\n");
 }
 
 static int nx_set_dma_mask(struct netxen_adapter *adapter, uint8_t revision_id)
@@ -284,6 +280,8 @@ static void netxen_check_options(struct netxen_adapter *adapter)
 	case NETXEN_BRDTYPE_P3_10G_CX4_LP:
 	case NETXEN_BRDTYPE_P3_IMEZ:
 	case NETXEN_BRDTYPE_P3_10G_SFP_PLUS:
+	case NETXEN_BRDTYPE_P3_10G_SFP_QT:
+	case NETXEN_BRDTYPE_P3_10G_SFP_CT:
 	case NETXEN_BRDTYPE_P3_10G_XFP:
 	case NETXEN_BRDTYPE_P3_10000_BASE_T:
 		adapter->msix_supported = !!use_msi_x;
@@ -301,6 +299,10 @@ static void netxen_check_options(struct netxen_adapter *adapter)
 	case NETXEN_BRDTYPE_P3_REF_QG:
 	case NETXEN_BRDTYPE_P3_4_GB:
 	case NETXEN_BRDTYPE_P3_4_GB_MM:
+		adapter->msix_supported = 0;
+		adapter->max_rx_desc_count = MAX_RCV_DESCRIPTORS_10G;
+		break;
+
 	case NETXEN_BRDTYPE_P2_SB35_4G:
 	case NETXEN_BRDTYPE_P2_SB31_2G:
 		adapter->msix_supported = 0;
@@ -700,13 +702,10 @@ netxen_nic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adapter->status   &= ~NETXEN_NETDEV_STATUS;
 	adapter->rx_csum = 1;
 	adapter->mc_enabled = 0;
-	if (NX_IS_REVISION_P3(revision_id)) {
+	if (NX_IS_REVISION_P3(revision_id))
 		adapter->max_mc_count = 38;
-		adapter->max_rds_rings = 2;
-	} else {
+	else
 		adapter->max_mc_count = 16;
-		adapter->max_rds_rings = 3;
-	}
 
 	netdev->open		   = netxen_nic_open;
 	netdev->stop		   = netxen_nic_close;
@@ -779,10 +778,6 @@ netxen_nic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		if (adapter->portnum == 0)
 			first_driver = 1;
 	}
-	adapter->crb_addr_cmd_producer = crb_cmd_producer[adapter->portnum];
-	adapter->crb_addr_cmd_consumer = crb_cmd_consumer[adapter->portnum];
-	netxen_nic_update_cmd_producer(adapter, 0);
-	netxen_nic_update_cmd_consumer(adapter, 0);
 
 	if (first_driver) {
 		first_boot = adapter->pci_read_normalize(adapter,
@@ -1053,6 +1048,11 @@ static int netxen_nic_open(struct net_device *netdev)
 			return -EIO;
 		}
 
+		if (adapter->fw_major < 4)
+			adapter->max_rds_rings = 3;
+		else
+			adapter->max_rds_rings = 2;
+
 		err = netxen_alloc_sw_resources(adapter);
 		if (err) {
 			printk(KERN_ERR "%s: Error in setting sw resources\n",
@@ -1074,10 +1074,10 @@ static int netxen_nic_open(struct net_device *netdev)
 				crb_cmd_producer[adapter->portnum];
 			adapter->crb_addr_cmd_consumer =
 				crb_cmd_consumer[adapter->portnum];
-		}
 
-		netxen_nic_update_cmd_producer(adapter, 0);
-		netxen_nic_update_cmd_consumer(adapter, 0);
+			netxen_nic_update_cmd_producer(adapter, 0);
+			netxen_nic_update_cmd_consumer(adapter, 0);
+		}
 
 		for (ctx = 0; ctx < MAX_RCV_CTX; ++ctx) {
 			for (ring = 0; ring < adapter->max_rds_rings; ring++)
@@ -1113,9 +1113,7 @@ static int netxen_nic_open(struct net_device *netdev)
 	netxen_nic_set_link_parameters(adapter);
 
 	netdev->set_multicast_list(netdev);
-	if (NX_IS_REVISION_P3(adapter->ahw.revision_id))
-		nx_fw_cmd_set_mtu(adapter, netdev->mtu);
-	else
+	if (adapter->set_mtu)
 		adapter->set_mtu(adapter, netdev->mtu);
 
 	mod_timer(&adapter->watchdog_timer, jiffies);
@@ -1410,20 +1408,17 @@ static void netxen_nic_handle_phy_intr(struct netxen_adapter *adapter)
 
 	port = adapter->physical_port;
 
-	if (adapter->ahw.board_type == NETXEN_NIC_GBE) {
-		val = adapter->pci_read_normalize(adapter, CRB_XG_STATE);
-		linkup = (val >> port) & 1;
+	if (NX_IS_REVISION_P3(adapter->ahw.revision_id)) {
+		val = adapter->pci_read_normalize(adapter, CRB_XG_STATE_P3);
+		val = XG_LINK_STATE_P3(adapter->ahw.pci_func, val);
+		linkup = (val == XG_LINK_UP_P3);
 	} else {
-		if (adapter->fw_major < 4) {
-			val = adapter->pci_read_normalize(adapter,
-					CRB_XG_STATE);
+		val = adapter->pci_read_normalize(adapter, CRB_XG_STATE);
+		if (adapter->ahw.board_type == NETXEN_NIC_GBE)
+			linkup = (val >> port) & 1;
+		else {
 			val = (val >> port*8) & 0xff;
 			linkup = (val == XG_LINK_UP);
-		} else {
-			val = adapter->pci_read_normalize(adapter,
-				CRB_XG_STATE_P3);
-			val = XG_LINK_STATE_P3(adapter->ahw.pci_func, val);
-			linkup = (val == XG_LINK_UP_P3);
 		}
 	}
 
@@ -1535,15 +1530,33 @@ static irqreturn_t netxen_intr(int irq, void *data)
 	struct netxen_adapter *adapter = data;
 	u32 our_int = 0;
 
-	our_int = adapter->pci_read_normalize(adapter, CRB_INT_VECTOR);
-	/* not our interrupt */
-	if ((our_int & (0x80 << adapter->portnum)) == 0)
+	u32 status = 0;
+
+	status = adapter->pci_read_immediate(adapter, ISR_INT_VECTOR);
+
+	if (!(status & adapter->legacy_intr.int_vec_bit))
 		return IRQ_NONE;
 
-	if (adapter->intr_scheme == INTR_SCHEME_PERPORT) {
-		/* claim interrupt */
-		adapter->pci_write_normalize(adapter, CRB_INT_VECTOR,
+	if (adapter->ahw.revision_id >= NX_P3_B1) {
+		/* check interrupt state machine, to be sure */
+		status = adapter->pci_read_immediate(adapter,
+				ISR_INT_STATE_REG);
+		if (!ISR_LEGACY_INT_TRIGGERED(status))
+			return IRQ_NONE;
+
+	} else if (NX_IS_REVISION_P2(adapter->ahw.revision_id)) {
+
+		our_int = adapter->pci_read_normalize(adapter, CRB_INT_VECTOR);
+		/* not our interrupt */
+		if ((our_int & (0x80 << adapter->portnum)) == 0)
+			return IRQ_NONE;
+
+		if (adapter->intr_scheme == INTR_SCHEME_PERPORT) {
+			/* claim interrupt */
+			adapter->pci_write_normalize(adapter,
+				CRB_INT_VECTOR,
 				our_int & ~((u32)(0x80 << adapter->portnum)));
+		}
 	}
 
 	netxen_handle_int(adapter);
diff --git a/drivers/net/netxen/netxen_nic_niu.c b/drivers/net/netxen/netxen_nic_niu.c
index 4cb8f4a..27f07f6 100644
--- a/drivers/net/netxen/netxen_nic_niu.c
+++ b/drivers/net/netxen/netxen_nic_niu.c
@@ -610,6 +610,9 @@ int netxen_niu_macaddr_set(struct netxen_adapter *adapter,
 	int i;
 	DECLARE_MAC_BUF(mac);
 
+	if (NX_IS_REVISION_P3(adapter->ahw.revision_id))
+		return 0;
+
 	for (i = 0; i < 10; i++) {
 		temp[0] = temp[1] = 0;
 		memcpy(temp + 2, addr, 2);
@@ -727,6 +730,9 @@ int netxen_niu_disable_gbe_port(struct netxen_adapter *adapter)
 	__u32 mac_cfg0;
 	u32 port = adapter->physical_port;
 
+	if (NX_IS_REVISION_P3(adapter->ahw.revision_id))
+		return 0;
+
 	if (port > NETXEN_NIU_MAX_GBE_PORTS)
 		return -EINVAL;
 	mac_cfg0 = 0;
@@ -743,6 +749,9 @@ int netxen_niu_disable_xg_port(struct netxen_adapter *adapter)
 	__u32 mac_cfg;
 	u32 port = adapter->physical_port;
 
+	if (NX_IS_REVISION_P3(adapter->ahw.revision_id))
+		return 0;
+
 	if (port > NETXEN_NIU_MAX_XG_PORTS)
 		return -EINVAL;
 
@@ -755,7 +764,7 @@ int netxen_niu_disable_xg_port(struct netxen_adapter *adapter)
 
 /* Set promiscuous mode for a GbE interface */
 int netxen_niu_set_promiscuous_mode(struct netxen_adapter *adapter,
-				    netxen_niu_prom_mode_t mode)
+		u32 mode)
 {
 	__u32 reg;
 	u32 port = adapter->physical_port;
@@ -819,6 +828,9 @@ int netxen_niu_xg_macaddr_set(struct netxen_adapter *adapter,
 	u8 temp[4];
 	u32 val;
 
+	if (NX_IS_REVISION_P3(adapter->ahw.revision_id))
+		return 0;
+
 	if ((phy < 0) || (phy > NETXEN_NIU_MAX_XG_PORTS))
 		return -EIO;
 
@@ -894,7 +906,7 @@ int netxen_niu_xg_macaddr_get(struct netxen_adapter *adapter,
 #endif  /*  0  */
 
 int netxen_niu_xg_set_promiscuous_mode(struct netxen_adapter *adapter,
-				       netxen_niu_prom_mode_t mode)
+		u32 mode)
 {
 	__u32 reg;
 	u32 port = adapter->physical_port;
diff --git a/drivers/net/netxen/netxen_nic_phan_reg.h b/drivers/net/netxen/netxen_nic_phan_reg.h
index 3bfa51b..83e5ee5 100644
--- a/drivers/net/netxen/netxen_nic_phan_reg.h
+++ b/drivers/net/netxen/netxen_nic_phan_reg.h
@@ -95,8 +95,8 @@
 #define CRB_HOST_STS_PROD           NETXEN_NIC_REG(0xdc)
 #define CRB_HOST_STS_CONS           NETXEN_NIC_REG(0xe0)
 #define CRB_PEG_CMD_PROD            NETXEN_NIC_REG(0xe4)
-#define CRB_PEG_CMD_CONS            NETXEN_NIC_REG(0xe8)
-#define CRB_HOST_BUFFER_PROD        NETXEN_NIC_REG(0xec)
+#define CRB_PF_LINK_SPEED_1         NETXEN_NIC_REG(0xe8)
+#define CRB_PF_LINK_SPEED_2         NETXEN_NIC_REG(0xec)
 #define CRB_HOST_BUFFER_CONS        NETXEN_NIC_REG(0xf0)
 #define CRB_JUMBO_BUFFER_PROD       NETXEN_NIC_REG(0xf4)
 #define CRB_JUMBO_BUFFER_CONS       NETXEN_NIC_REG(0xf8)
diff --git a/drivers/net/ni5010.c b/drivers/net/ni5010.c
index a20005c..8e0ca9f 100644
--- a/drivers/net/ni5010.c
+++ b/drivers/net/ni5010.c
@@ -648,7 +648,6 @@ static void ni5010_set_multicast_list(struct net_device *dev)
 	PRINTK2((KERN_DEBUG "%s: entering set_multicast_list\n", dev->name));
 
 	if (dev->flags&IFF_PROMISC || dev->flags&IFF_ALLMULTI || dev->mc_list) {
-		dev->flags |= IFF_PROMISC;
 		outb(RMD_PROMISC, EDLC_RMODE); /* Enable promiscuous mode */
 		PRINTK((KERN_DEBUG "%s: Entering promiscuous mode\n", dev->name));
 	} else {
diff --git a/drivers/net/ni52.c b/drivers/net/ni52.c
index a316dcc..b9a882d 100644
--- a/drivers/net/ni52.c
+++ b/drivers/net/ni52.c
@@ -621,7 +621,7 @@ static int init586(struct net_device *dev)
 		if (num_addrs > len) {
 			printk(KERN_ERR "%s: switching to promisc. mode\n",
 				dev->name);
-			dev->flags |= IFF_PROMISC;
+			writeb(0x01, &cfg_cmd->promisc);
 		}
 	}
 	if (dev->flags & IFF_PROMISC)
diff --git a/drivers/net/qla3xxx.c b/drivers/net/qla3xxx.c
index e82b37b..3cdd07c 100644
--- a/drivers/net/qla3xxx.c
+++ b/drivers/net/qla3xxx.c
@@ -38,7 +38,7 @@
 
 #define DRV_NAME  	"qla3xxx"
 #define DRV_STRING 	"QLogic ISP3XXX Network Driver"
-#define DRV_VERSION	"v2.03.00-k4"
+#define DRV_VERSION	"v2.03.00-k5"
 #define PFX		DRV_NAME " "
 
 static const char ql3xxx_driver_name[] = DRV_NAME;
@@ -3495,8 +3495,6 @@ static void ql_set_mac_info(struct ql3_adapter *qdev)
 	case ISP_CONTROL_FN0_NET:
 		qdev->mac_index = 0;
 		qdev->mac_ob_opcode = OUTBOUND_MAC_IOCB | func_number;
-		qdev->tcp_ob_opcode = OUTBOUND_TCP_IOCB | func_number;
-		qdev->update_ob_opcode = UPDATE_NCB_IOCB | func_number;
 		qdev->mb_bit_mask = FN0_MA_BITS_MASK;
 		qdev->PHYAddr = PORT0_PHY_ADDRESS;
 		if (port_status & PORT_STATUS_SM0)
@@ -3508,8 +3506,6 @@ static void ql_set_mac_info(struct ql3_adapter *qdev)
 	case ISP_CONTROL_FN1_NET:
 		qdev->mac_index = 1;
 		qdev->mac_ob_opcode = OUTBOUND_MAC_IOCB | func_number;
-		qdev->tcp_ob_opcode = OUTBOUND_TCP_IOCB | func_number;
-		qdev->update_ob_opcode = UPDATE_NCB_IOCB | func_number;
 		qdev->mb_bit_mask = FN1_MA_BITS_MASK;
 		qdev->PHYAddr = PORT1_PHY_ADDRESS;
 		if (port_status & PORT_STATUS_SM1)
@@ -3730,14 +3726,6 @@ static int ql3xxx_open(struct net_device *ndev)
 	return (ql_adapter_up(qdev));
 }
 
-static void ql3xxx_set_multicast_list(struct net_device *ndev)
-{
-	/*
-	 * We are manually parsing the list in the net_device structure.
-	 */
-	return;
-}
-
 static int ql3xxx_set_mac_address(struct net_device *ndev, void *p)
 {
 	struct ql3_adapter *qdev = (struct ql3_adapter *)netdev_priv(ndev);
@@ -4007,7 +3995,11 @@ static int __devinit ql3xxx_probe(struct pci_dev *pdev,
 	ndev->open = ql3xxx_open;
 	ndev->hard_start_xmit = ql3xxx_send;
 	ndev->stop = ql3xxx_close;
-	ndev->set_multicast_list = ql3xxx_set_multicast_list;
+	/* ndev->set_multicast_list
+	 * This device is one side of a two-function adapter
+	 * (NIC and iSCSI).  Promiscuous mode setting/clearing is
+	 * not allowed from the NIC side.
+	 */
 	SET_ETHTOOL_OPS(ndev, &ql3xxx_ethtool_ops);
 	ndev->set_mac_address = ql3xxx_set_mac_address;
 	ndev->tx_timeout = ql3xxx_tx_timeout;
@@ -4040,9 +4032,6 @@ static int __devinit ql3xxx_probe(struct pci_dev *pdev,
 
 	ndev->tx_queue_len = NUM_REQ_Q_ENTRIES;
 
-	/* Turn off support for multicasting */
-	ndev->flags &= ~IFF_MULTICAST;
-
 	/* Record PCI bus information. */
 	ql_get_board_info(qdev);
 
diff --git a/drivers/net/qla3xxx.h b/drivers/net/qla3xxx.h
index 58a086f..7113e71 100644
--- a/drivers/net/qla3xxx.h
+++ b/drivers/net/qla3xxx.h
@@ -14,24 +14,14 @@
 
 #define OPCODE_OB_MAC_IOCB_FN0          0x01
 #define OPCODE_OB_MAC_IOCB_FN2          0x21
-#define OPCODE_OB_TCP_IOCB_FN0          0x03
-#define OPCODE_OB_TCP_IOCB_FN2          0x23
-#define OPCODE_UPDATE_NCB_IOCB_FN0      0x00
-#define OPCODE_UPDATE_NCB_IOCB_FN2      0x20
 
-#define OPCODE_UPDATE_NCB_IOCB      0xF0
 #define OPCODE_IB_MAC_IOCB          0xF9
 #define OPCODE_IB_3032_MAC_IOCB     0x09
 #define OPCODE_IB_IP_IOCB           0xFA
 #define OPCODE_IB_3032_IP_IOCB      0x0A
-#define OPCODE_IB_TCP_IOCB          0xFB
-#define OPCODE_DUMP_PROTO_IOCB      0xFE
-#define OPCODE_BUFFER_ALERT_IOCB    0xFB
 
 #define OPCODE_FUNC_ID_MASK                 0x30
 #define OUTBOUND_MAC_IOCB                   0x01	/* plus function bits */
-#define OUTBOUND_TCP_IOCB                   0x03	/* plus function bits */
-#define UPDATE_NCB_IOCB                     0x00	/* plus function bits */
 
 #define FN0_MA_BITS_MASK    0x00
 #define FN1_MA_BITS_MASK    0x80
@@ -159,75 +149,6 @@ struct ob_ip_iocb_rsp {
 	__le32 reserved2;
 };
 
-struct ob_tcp_iocb_req {
-	u8 opcode;
-
-	u8 flags0;
-#define OB_TCP_IOCB_REQ_P       0x80
-#define OB_TCP_IOCB_REQ_CI      0x20
-#define OB_TCP_IOCB_REQ_H       0x10
-#define OB_TCP_IOCB_REQ_LN      0x08
-#define OB_TCP_IOCB_REQ_K       0x04
-#define OB_TCP_IOCB_REQ_D       0x02
-#define OB_TCP_IOCB_REQ_I       0x01
-
-	u8 flags1;
-#define OB_TCP_IOCB_REQ_OSM     0x40
-#define OB_TCP_IOCB_REQ_URG     0x20
-#define OB_TCP_IOCB_REQ_ACK     0x10
-#define OB_TCP_IOCB_REQ_PSH     0x08
-#define OB_TCP_IOCB_REQ_RST     0x04
-#define OB_TCP_IOCB_REQ_SYN     0x02
-#define OB_TCP_IOCB_REQ_FIN     0x01
-
-	u8 options_len;
-#define OB_TCP_IOCB_REQ_OMASK   0xF0
-#define OB_TCP_IOCB_REQ_SHIFT   4
-
-	__le32 transaction_id;
-	__le32 data_len;
-	__le32 hncb_ptr_low;
-	__le32 hncb_ptr_high;
-	__le32 buf_addr0_low;
-	__le32 buf_addr0_high;
-	__le32 buf_0_len;
-	__le32 buf_addr1_low;
-	__le32 buf_addr1_high;
-	__le32 buf_1_len;
-	__le32 buf_addr2_low;
-	__le32 buf_addr2_high;
-	__le32 buf_2_len;
-	__le32 time_stamp;
-	__le32 reserved1;
-};
-
-struct ob_tcp_iocb_rsp {
-	u8 opcode;
-
-	u8 flags0;
-#define OB_TCP_IOCB_RSP_C       0x20
-#define OB_TCP_IOCB_RSP_H       0x10
-#define OB_TCP_IOCB_RSP_LN      0x08
-#define OB_TCP_IOCB_RSP_K       0x04
-#define OB_TCP_IOCB_RSP_D       0x02
-#define OB_TCP_IOCB_RSP_I       0x01
-
-	u8 flags1;
-#define OB_TCP_IOCB_RSP_E       0x10
-#define OB_TCP_IOCB_RSP_W       0x08
-#define OB_TCP_IOCB_RSP_P       0x04
-#define OB_TCP_IOCB_RSP_T       0x02
-#define OB_TCP_IOCB_RSP_F       0x01
-
-	u8 state;
-#define OB_TCP_IOCB_RSP_SMASK   0xF0
-#define OB_TCP_IOCB_RSP_SHIFT   4
-
-	__le32 transaction_id;
-	__le32 local_ncb_ptr;
-	__le32 reserved0;
-};
-
 struct ib_ip_iocb_rsp {
 	u8 opcode;
 #define IB_IP_IOCB_RSP_3032_V   0x80
@@ -256,25 +177,6 @@ struct ib_ip_iocb_rsp {
 	__le32 ial_high;
 };
 
-struct ib_tcp_iocb_rsp {
-	u8 opcode;
-	u8 flags;
-#define IB_TCP_IOCB_RSP_P       0x80
-#define IB_TCP_IOCB_RSP_T       0x40
-#define IB_TCP_IOCB_RSP_D       0x20
-#define IB_TCP_IOCB_RSP_N       0x10
-#define IB_TCP_IOCB_RSP_IP      0x03
-#define IB_TCP_FLAG_MASK        0xf0
-#define IB_TCP_FLAG_IOCB_SYN    0x00
-
-#define TCP_IB_RSP_FLAGS(x) (x->flags & ~IB_TCP_FLAG_MASK)
-
-	__le16 length;
-	__le32 hncb_ref_num;
-	__le32 ial_low;
-	__le32 ial_high;
-};
-
 struct net_rsp_iocb {
 	u8 opcode;
 	u8 flags;
@@ -1266,20 +1168,13 @@ struct ql3_adapter {
 	u32 small_buf_release_cnt;
 	u32 small_buf_total_size;
 
-	/* ISR related, saves status for DPC. */
-	u32 control_status;
-
 	struct eeprom_data nvram_data;
-	struct timer_list ioctl_timer;
 	u32 port_link_state;
-	u32 last_rsp_offset;
 
 	/* 4022 specific */
 	u32 mac_index;		/* Driver's MAC number can be 0 or 1 for first and second networking functions respectively */
 	u32 PHYAddr;		/* Address of PHY 0x1e00 Port 0 and 0x1f00 Port 1 */
 	u32 mac_ob_opcode;	/* Opcode to use on mac transmission */
-	u32 tcp_ob_opcode;	/* Opcode to use on tcp transmission */
-	u32 update_ob_opcode;	/* Opcode to use for updating NCB */
 	u32 mb_bit_mask;	/* MA Bits mask to use on transmission */
 	u32 numPorts;
 	struct workqueue_struct *workqueue;
diff --git a/drivers/net/sh_eth.c b/drivers/net/sh_eth.c
index 6a06b95..25e62cf 100644
--- a/drivers/net/sh_eth.c
+++ b/drivers/net/sh_eth.c
@@ -34,6 +34,29 @@
 
 #include "sh_eth.h"
 
+/* CPU <-> EDMAC endian convert */
+static inline __u32 cpu_to_edmac(struct sh_eth_private *mdp, u32 x)
+{
+	switch (mdp->edmac_endian) {
+	case EDMAC_LITTLE_ENDIAN:
+		return cpu_to_le32(x);
+	case EDMAC_BIG_ENDIAN:
+		return cpu_to_be32(x);
+	}
+	return x;
+}
+
+static inline __u32 edmac_to_cpu(struct sh_eth_private *mdp, u32 x)
+{
+	switch (mdp->edmac_endian) {
+	case EDMAC_LITTLE_ENDIAN:
+		return le32_to_cpu(x);
+	case EDMAC_BIG_ENDIAN:
+		return be32_to_cpu(x);
+	}
+	return x;
+}
+
 /*
  * Program the hardware MAC address from dev->dev_addr.
  */
@@ -240,7 +263,7 @@ static void sh_eth_ring_format(struct net_device *ndev)
 		/* RX descriptor */
 		rxdesc = &mdp->rx_ring[i];
 		rxdesc->addr = (u32)skb->data & ~0x3UL;
-		rxdesc->status = cpu_to_le32(RD_RACT | RD_RFP);
+		rxdesc->status = cpu_to_edmac(mdp, RD_RACT | RD_RFP);
 
 		/* The size of the buffer is 16 byte boundary. */
 		rxdesc->buffer_length = (mdp->rx_buf_sz + 16) & ~0x0F;
@@ -262,7 +285,7 @@ static void sh_eth_ring_format(struct net_device *ndev)
 	mdp->dirty_rx = (u32) (i - RX_RING_SIZE);
 
 	/* Mark the last entry as wrapping the ring. */
-	rxdesc->status |= cpu_to_le32(RD_RDEL);
+	rxdesc->status |= cpu_to_edmac(mdp, RD_RDEL);
 
 	memset(mdp->tx_ring, 0, tx_ringsize);
 
@@ -270,10 +293,10 @@ static void sh_eth_ring_format(struct net_device *ndev)
 	for (i = 0; i < TX_RING_SIZE; i++) {
 		mdp->tx_skbuff[i] = NULL;
 		txdesc = &mdp->tx_ring[i];
-		txdesc->status = cpu_to_le32(TD_TFP);
+		txdesc->status = cpu_to_edmac(mdp, TD_TFP);
 		txdesc->buffer_length = 0;
 		if (i == 0) {
-			/* Rx descriptor address set */
+			/* Tx descriptor address set */
 			ctrl_outl((u32)txdesc, ioaddr + TDLAR);
 #if defined(CONFIG_CPU_SUBTYPE_SH7763)
 			ctrl_outl((u32)txdesc, ioaddr + TDFAR);
@@ -281,13 +304,13 @@ static void sh_eth_ring_format(struct net_device *ndev)
 		}
 	}
 
-	/* Rx descriptor address set */
+	/* Tx descriptor address set */
 #if defined(CONFIG_CPU_SUBTYPE_SH7763)
 	ctrl_outl((u32)txdesc, ioaddr + TDFXR);
 	ctrl_outl(0x1, ioaddr + TDFFR);
 #endif
 
-	txdesc->status |= cpu_to_le32(TD_TDLE);
+	txdesc->status |= cpu_to_edmac(mdp, TD_TDLE);
 }
 
 /* Get skb and descriptor buffer */
@@ -455,7 +478,7 @@ static int sh_eth_txfree(struct net_device *ndev)
 	for (; mdp->cur_tx - mdp->dirty_tx > 0; mdp->dirty_tx++) {
 		entry = mdp->dirty_tx % TX_RING_SIZE;
 		txdesc = &mdp->tx_ring[entry];
-		if (txdesc->status & cpu_to_le32(TD_TACT))
+		if (txdesc->status & cpu_to_edmac(mdp, TD_TACT))
 			break;
 		/* Free the original skb. */
 		if (mdp->tx_skbuff[entry]) {
@@ -463,9 +486,9 @@ static int sh_eth_txfree(struct net_device *ndev)
 			mdp->tx_skbuff[entry] = NULL;
 			freeNum++;
 		}
-		txdesc->status = cpu_to_le32(TD_TFP);
+		txdesc->status = cpu_to_edmac(mdp, TD_TFP);
 		if (entry >= TX_RING_SIZE - 1)
-			txdesc->status |= cpu_to_le32(TD_TDLE);
+			txdesc->status |= cpu_to_edmac(mdp, TD_TDLE);
 
 		mdp->stats.tx_packets++;
 		mdp->stats.tx_bytes += txdesc->buffer_length;
@@ -486,8 +509,8 @@ static int sh_eth_rx(struct net_device *ndev)
 	u32 desc_status, reserve = 0;
 
 	rxdesc = &mdp->rx_ring[entry];
-	while (!(rxdesc->status & cpu_to_le32(RD_RACT))) {
-		desc_status = le32_to_cpu(rxdesc->status);
+	while (!(rxdesc->status & cpu_to_edmac(mdp, RD_RACT))) {
+		desc_status = edmac_to_cpu(mdp, rxdesc->status);
 		pkt_len = rxdesc->frame_length;
 
 		if (--boguscnt < 0)
@@ -522,7 +545,7 @@ static int sh_eth_rx(struct net_device *ndev)
 			mdp->stats.rx_packets++;
 			mdp->stats.rx_bytes += pkt_len;
 		}
-		rxdesc->status |= cpu_to_le32(RD_RACT);
+		rxdesc->status |= cpu_to_edmac(mdp, RD_RACT);
 		entry = (++mdp->cur_rx) % RX_RING_SIZE;
 	}
 
@@ -552,10 +575,10 @@ static int sh_eth_rx(struct net_device *ndev)
 		}
 		if (entry >= RX_RING_SIZE - 1)
 			rxdesc->status |=
-				cpu_to_le32(RD_RACT | RD_RFP | RD_RDEL);
+				cpu_to_edmac(mdp, RD_RACT | RD_RFP | RD_RDEL);
 		else
 			rxdesc->status |=
-				cpu_to_le32(RD_RACT | RD_RFP);
+				cpu_to_edmac(mdp, RD_RACT | RD_RFP);
 	}
 
 	/* Restart Rx engine if stopped. */
@@ -931,9 +954,9 @@ static int sh_eth_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		txdesc->buffer_length = skb->len;
 
 	if (entry >= TX_RING_SIZE - 1)
-		txdesc->status |= cpu_to_le32(TD_TACT | TD_TDLE);
+		txdesc->status |= cpu_to_edmac(mdp, TD_TACT | TD_TDLE);
 	else
-		txdesc->status |= cpu_to_le32(TD_TACT);
+		txdesc->status |= cpu_to_edmac(mdp, TD_TACT);
 
 	mdp->cur_tx++;
 
@@ -1159,6 +1182,7 @@ static int sh_eth_drv_probe(struct platform_device *pdev)
 	struct resource *res;
 	struct net_device *ndev = NULL;
 	struct sh_eth_private *mdp;
+	struct sh_eth_plat_data *pd;
 
 	/* get base addr */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -1196,8 +1220,11 @@ static int sh_eth_drv_probe(struct platform_device *pdev)
 	mdp = netdev_priv(ndev);
 	spin_lock_init(&mdp->lock);
 
+	pd = (struct sh_eth_plat_data *)(pdev->dev.platform_data);
 	/* get PHY ID */
-	mdp->phy_id = (int)pdev->dev.platform_data;
+	mdp->phy_id = pd->phy;
+	/* EDMAC endian */
+	mdp->edmac_endian = pd->edmac_endian;
 
 	/* set function */
 	ndev->open = sh_eth_open;
@@ -1217,12 +1244,16 @@ static int sh_eth_drv_probe(struct platform_device *pdev)
 
 	/* First device only init */
 	if (!devno) {
+#if defined(ARSTR)
 		/* reset device */
 		ctrl_outl(ARSTR_ARSTR, ARSTR);
 		mdelay(1);
+#endif
 
+#if defined(SH_TSU_ADDR)
 		/* TSU init (Init only)*/
 		sh_eth_tsu_init(SH_TSU_ADDR);
+#endif
 	}
 
 	/* network device register */
@@ -1240,8 +1271,8 @@ static int sh_eth_drv_probe(struct platform_device *pdev)
 	       ndev->name, CARDNAME, (u32) ndev->base_addr);
 
 	for (i = 0; i < 5; i++)
-		printk(KERN_INFO "%02X:", ndev->dev_addr[i]);
-	printk(KERN_INFO "%02X, IRQ %d.\n", ndev->dev_addr[i], ndev->irq);
+		printk("%02X:", ndev->dev_addr[i]);
+	printk("%02X, IRQ %d.\n", ndev->dev_addr[i], ndev->irq);
 
 	platform_set_drvdata(pdev, ndev);
 
diff --git a/drivers/net/sh_eth.h b/drivers/net/sh_eth.h
index 45ad1b0..73bc718 100644
--- a/drivers/net/sh_eth.h
+++ b/drivers/net/sh_eth.h
@@ -30,6 +30,8 @@
 #include <linux/netdevice.h>
 #include <linux/phy.h>
 
+#include <asm/sh_eth.h>
+
 #define CARDNAME	"sh-eth"
 #define TX_TIMEOUT	(5*HZ)
 #define TX_RING_SIZE	64	/* Tx ring size */
@@ -143,10 +145,11 @@
 
 #else /* CONFIG_CPU_SUBTYPE_SH7763 */
 # define RX_OFFSET 2	/* skb offset */
+#ifndef CONFIG_CPU_SUBTYPE_SH7619
 /* Chip base address */
 # define SH_TSU_ADDR  0xA7000804
 # define ARSTR		  0xA7000800
-
+#endif
 /* Chip Registers */
 /* E-DMAC */
 # define EDMR	0x0000
@@ -384,7 +387,11 @@ enum FCFTR_BIT {
 	FCFTR_RFD1 = 0x00000002, FCFTR_RFD0 = 0x00000001,
 };
 #define FIFO_F_D_RFF	(FCFTR_RFF2|FCFTR_RFF1|FCFTR_RFF0)
+#ifndef CONFIG_CPU_SUBTYPE_SH7619
 #define FIFO_F_D_RFD	(FCFTR_RFD2|FCFTR_RFD1|FCFTR_RFD0)
+#else
+#define FIFO_F_D_RFD	(FCFTR_RFD0)
+#endif
 
 /* Transfer descriptor bit */
 enum TD_STS_BIT {
@@ -414,8 +421,10 @@ enum FELIC_MODE_BIT {
 #ifdef CONFIG_CPU_SUBTYPE_SH7763
 #define ECMR_CHG_DM	(ECMR_TRCCM | ECMR_RZPF | ECMR_ZPF |\
 			ECMR_PFR | ECMR_RXF | ECMR_TXF | ECMR_MCT)
+#elif CONFIG_CPU_SUBTYPE_SH7619
+#define ECMR_CHG_DM	(ECMR_ZPF | ECMR_PFR | ECMR_RXF | ECMR_TXF)
 #else
-#define ECMR_CHG_DM	(ECMR_ZPF | ECMR_PFR ECMR_RXF | ECMR_TXF | ECMR_MCT)
+#define ECMR_CHG_DM	(ECMR_ZPF | ECMR_PFR | ECMR_RXF | ECMR_TXF | ECMR_MCT)
 #endif
 
 /* ECSR */
@@ -485,7 +494,11 @@ enum RPADIR_BIT {
 
 /* FDR */
 enum FIFO_SIZE_BIT {
+#ifndef CONFIG_CPU_SUBTYPE_SH7619
 	FIFO_SIZE_T = 0x00000700, FIFO_SIZE_R = 0x00000007,
+#else
+	FIFO_SIZE_T = 0x00000100, FIFO_SIZE_R = 0x00000001,
+#endif
 };
 enum phy_offsets {
 	PHY_CTRL = 0, PHY_STAT = 1, PHY_IDT1 = 2, PHY_IDT2 = 3,
@@ -601,7 +614,7 @@ struct sh_eth_txdesc {
 #endif
 	u32 addr;		/* TD2 */
 	u32 pad1;		/* padding data */
-};
+} __attribute__((aligned(2), packed));
 
 /*
  * The sh ether Rx buffer descriptors.
@@ -618,7 +631,7 @@ struct sh_eth_rxdesc {
 #endif
 	u32 addr;		/* RD2 */
 	u32 pad0;		/* padding data */
-};
+} __attribute__((aligned(2), packed));
 
 struct sh_eth_private {
 	dma_addr_t rx_desc_dma;
@@ -633,6 +646,7 @@ struct sh_eth_private {
 	u32 cur_rx, dirty_rx;	/* Producer/consumer ring indices */
 	u32 cur_tx, dirty_tx;
 	u32 rx_buf_sz;		/* Based on MTU+slack. */
+	int edmac_endian;
 	/* MII transceiver section. */
 	u32 phy_id;					/* PHY ID */
 	struct mii_bus *mii_bus;	/* MDIO bus control */
diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
index 5257cf4..7d29edc 100644
--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -275,86 +275,6 @@ static void sky2_power_aux(struct sky2_hw *hw)
 			     PC_VAUX_ON | PC_VCC_OFF));
 }
 
-static void sky2_power_state(struct sky2_hw *hw, pci_power_t state)
-{
-	u16 power_control = sky2_pci_read16(hw, hw->pm_cap + PCI_PM_CTRL);
-	int pex = pci_find_capability(hw->pdev, PCI_CAP_ID_EXP);
-	u32 reg;
-
-	sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_ON);
-
-	switch (state) {
-	case PCI_D0:
-		break;
-
-	case PCI_D1:
-		power_control |= 1;
-		break;
-
-	case PCI_D2:
-		power_control |= 2;
-		break;
-
-	case PCI_D3hot:
-	case PCI_D3cold:
-		power_control |= 3;
-		if (hw->flags & SKY2_HW_ADV_POWER_CTL) {
-			/* additional power saving measurements */
-			reg = sky2_pci_read32(hw, PCI_DEV_REG4);
-
-			/* set gating core clock for LTSSM in L1 state */
-			reg |= P_PEX_LTSSM_STAT(P_PEX_LTSSM_L1_STAT) |
-				/* auto clock gated scheme controlled by CLKREQ */
-				P_ASPM_A1_MODE_SELECT |
-				/* enable Gate Root Core Clock */
-				P_CLK_GATE_ROOT_COR_ENA;
-
-			if (pex && (hw->flags & SKY2_HW_CLK_POWER)) {
-				/* enable Clock Power Management (CLKREQ) */
-				u16 ctrl = sky2_pci_read16(hw, pex + PCI_EXP_DEVCTL);
-
-				ctrl |= PCI_EXP_DEVCTL_AUX_PME;
-				sky2_pci_write16(hw, pex + PCI_EXP_DEVCTL, ctrl);
-			} else
-				/* force CLKREQ Enable in Our4 (A1b only) */
-				reg |= P_ASPM_FORCE_CLKREQ_ENA;
-
-			/* set Mask Register for Release/Gate Clock */
-			sky2_pci_write32(hw, PCI_DEV_REG5,
-					 P_REL_PCIE_EXIT_L1_ST | P_GAT_PCIE_ENTER_L1_ST |
-					 P_REL_PCIE_RX_EX_IDLE | P_GAT_PCIE_RX_EL_IDLE |
-					 P_REL_GPHY_LINK_UP | P_GAT_GPHY_LINK_DOWN);
-		} else
-			sky2_write8(hw, B28_Y2_ASF_STAT_CMD, Y2_ASF_CLK_HALT);
-
-		/* put CPU into reset state */
-		sky2_write8(hw,  B28_Y2_ASF_STAT_CMD, HCU_CCSR_ASF_RESET);
-		if (hw->chip_id == CHIP_ID_YUKON_SUPR && hw->chip_rev == CHIP_REV_YU_SU_A0)
-			/* put CPU into halt state */
-			sky2_write8(hw, B28_Y2_ASF_STAT_CMD, HCU_CCSR_ASF_HALTED);
-
-		if (pex && !(hw->flags & SKY2_HW_RAM_BUFFER)) {
-			reg = sky2_pci_read32(hw, PCI_DEV_REG1);
-			/* force to PCIe L1 */
-			reg |= PCI_FORCE_PEX_L1;
-			sky2_pci_write32(hw, PCI_DEV_REG1, reg);
-		}
-		break;
-
-	default:
-		dev_warn(&hw->pdev->dev, PFX "Invalid power state (%d) ",
-		       state);
-		return;
-	}
-
-	power_control |= PCI_PM_CTRL_PME_ENABLE;
-	/* Finally, set the new power state. */
-	sky2_pci_write32(hw, hw->pm_cap + PCI_PM_CTRL, power_control);
-
-	sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_OFF);
-	sky2_pci_read32(hw, B0_CTST);
-}
-
 static void sky2_gmac_reset(struct sky2_hw *hw, unsigned port)
 {
 	u16 reg;
@@ -709,6 +629,11 @@ static void sky2_phy_power_up(struct sky2_hw *hw, unsigned port)
 	sky2_pci_write32(hw, PCI_DEV_REG1, reg1);
 	sky2_write8(hw, B2_TST_CTRL1, TST_CFG_WRITE_OFF);
 	sky2_pci_read32(hw, PCI_DEV_REG1);
+
+	if (hw->chip_id == CHIP_ID_YUKON_FE)
+		gm_phy_write(hw, port, PHY_MARV_CTRL, PHY_CT_ANE);
+	else if (hw->flags & SKY2_HW_ADV_POWER_CTL)
+		sky2_write8(hw, SK_REG(port, GPHY_CTRL), GPC_RST_CLR);
 }
 
 static void sky2_phy_power_down(struct sky2_hw *hw, unsigned port)
@@ -2855,10 +2780,6 @@ static int __devinit sky2_init(struct sky2_hw *hw)
 		hw->flags = SKY2_HW_GIGABIT
 			| SKY2_HW_NEWER_PHY
 			| SKY2_HW_ADV_POWER_CTL;
-
-		/* check for Rev. A1 dev 4200 */
-		if (sky2_read16(hw, Q_ADDR(Q_XA1, Q_WM)) == 0)
-			hw->flags |= SKY2_HW_CLK_POWER;
 		break;
 
 	case CHIP_ID_YUKON_EX:
@@ -2914,12 +2835,6 @@ static int __devinit sky2_init(struct sky2_hw *hw)
 	if (hw->pmd_type == 'L' || hw->pmd_type == 'S' || hw->pmd_type == 'P')
 		hw->flags |= SKY2_HW_FIBRE_PHY;
 
-	hw->pm_cap = pci_find_capability(hw->pdev, PCI_CAP_ID_PM);
-	if (hw->pm_cap == 0) {
-		dev_err(&hw->pdev->dev, "cannot find PowerManagement capability\n");
-		return -EIO;
-	}
-
 	hw->ports = 1;
 	t8 = sky2_read8(hw, B2_Y2_HW_RES);
 	if ((t8 & CFG_DUAL_MAC_MSK) == CFG_DUAL_MAC_MSK) {
@@ -4512,7 +4427,7 @@ static int sky2_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	pci_save_state(pdev);
 	pci_enable_wake(pdev, pci_choose_state(pdev, state), wol);
-	sky2_power_state(hw, pci_choose_state(pdev, state));
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));
 
 	return 0;
 }
@@ -4525,7 +4440,9 @@ static int sky2_resume(struct pci_dev *pdev)
 	if (!hw)
 		return 0;
 
-	sky2_power_state(hw, PCI_D0);
+	err = pci_set_power_state(pdev, PCI_D0);
+	if (err)
+		goto out;
 
 	err = pci_restore_state(pdev);
 	if (err)
@@ -4595,7 +4512,7 @@ static void sky2_shutdown(struct pci_dev *pdev)
 	pci_enable_wake(pdev, PCI_D3cold, wol);
 
 	pci_disable_device(pdev);
-	sky2_power_state(hw, PCI_D3hot);
+	pci_set_power_state(pdev, PCI_D3hot);
 }
 
 static struct pci_driver sky2_driver = {
diff --git a/drivers/net/sky2.h b/drivers/net/sky2.h
index 4d9c4a1..92fb24b 100644
--- a/drivers/net/sky2.h
+++ b/drivers/net/sky2.h
@@ -2072,9 +2072,7 @@ struct sky2_hw {
 #define SKY2_HW_NEW_LE		0x00000020	/* new LSOv2 format */
 #define SKY2_HW_AUTO_TX_SUM	0x00000040	/* new IP decode for Tx */
 #define SKY2_HW_ADV_POWER_CTL	0x00000080	/* additional PHY power regs */
-#define SKY2_HW_CLK_POWER	0x00000100	/* clock power management */
 
-	int		     pm_cap;
 	u8	     	     chip_id;
 	u8		     chip_rev;
 	u8		     pmd_type;
diff --git a/drivers/net/sun3_82586.c b/drivers/net/sun3_82586.c
index 9b2a7f7..e531302 100644
--- a/drivers/net/sun3_82586.c
+++ b/drivers/net/sun3_82586.c
@@ -425,14 +425,11 @@ static int init586(struct net_device *dev)
 		int len = ((char *) p->iscp - (char *) ptr - 8) / 6;
 		if(num_addrs > len)	{
 			printk("%s: switching to promisc. mode\n",dev->name);
-			dev->flags|=IFF_PROMISC;
+			cfg_cmd->promisc = 1;
 		}
 	}
 	if(dev->flags&IFF_PROMISC)
-	{
-			 cfg_cmd->promisc=1;
-			 dev->flags|=IFF_PROMISC;
-	}
+		cfg_cmd->promisc = 1;
 	cfg_cmd->carr_coll	= 0x00;
 
 	p->scb->cbl_offset	= make16(cfg_cmd);
diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index b588c89..a84ba48 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -1285,6 +1285,21 @@ static void check_carrier(struct work_struct *work)
 	}
 }
 
+static int pegasus_blacklisted(struct usb_device *udev)
+{
+	struct usb_device_descriptor *udd = &udev->descriptor;
+
+	/* Special quirk to keep the driver from handling the Belkin Bluetooth
+	 * dongle which happens to have the same ID.
+	 */
+	if ((udd->idVendor == VENDOR_BELKIN && udd->idProduct == 0x0121) &&
+	    (udd->bDeviceClass == USB_CLASS_WIRELESS_CONTROLLER) &&
+	    (udd->bDeviceProtocol == 1))
+		return 1;
+
+	return 0;
+}
+
 static int pegasus_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
@@ -1296,6 +1311,12 @@ static int pegasus_probe(struct usb_interface *intf,
 	DECLARE_MAC_BUF(mac);
 
 	usb_get_dev(dev);
+
+	if (pegasus_blacklisted(dev)) {
+		res = -ENODEV;
+		goto out;
+	}
+
 	net = alloc_etherdev(sizeof(struct pegasus));
 	if (!net) {
 		dev_err(&intf->dev, "can't allocate %s\n", "device");
diff --git a/drivers/net/via-velocity.c b/drivers/net/via-velocity.c
index 370ce30..007c129 100644
--- a/drivers/net/via-velocity.c
+++ b/drivers/net/via-velocity.c
@@ -662,6 +662,10 @@ static void velocity_vlan_rx_kill_vid(struct net_device *dev, unsigned short vid
         spin_unlock_irq(&vptr->lock);
 }
 
+static void velocity_init_rx_ring_indexes(struct velocity_info *vptr)
+{
+	vptr->rx.dirty = vptr->rx.filled = vptr->rx.curr = 0;
+}
 
 /**
  *	velocity_rx_reset	-	handle a receive reset
@@ -677,16 +681,16 @@ static void velocity_rx_reset(struct velocity_info *vptr)
 	struct mac_regs __iomem * regs = vptr->mac_regs;
 	int i;
 
-	vptr->rd_dirty = vptr->rd_filled = vptr->rd_curr = 0;
+	velocity_init_rx_ring_indexes(vptr);
 
 	/*
 	 *	Init state, all RD entries belong to the NIC
 	 */
 	for (i = 0; i < vptr->options.numrx; ++i)
-		vptr->rd_ring[i].rdesc0.len |= OWNED_BY_NIC;
+		vptr->rx.ring[i].rdesc0.len |= OWNED_BY_NIC;
 
 	writew(vptr->options.numrx, &regs->RBRDU);
-	writel(vptr->rd_pool_dma, &regs->RDBaseLo);
+	writel(vptr->rx.pool_dma, &regs->RDBaseLo);
 	writew(0, &regs->RDIdx);
 	writew(vptr->options.numrx - 1, &regs->RDCSize);
 }
@@ -779,15 +783,15 @@ static void velocity_init_registers(struct velocity_info *vptr,
 
 		vptr->int_mask = INT_MASK_DEF;
 
-		writel(vptr->rd_pool_dma, &regs->RDBaseLo);
+		writel(vptr->rx.pool_dma, &regs->RDBaseLo);
 		writew(vptr->options.numrx - 1, &regs->RDCSize);
 		mac_rx_queue_run(regs);
 		mac_rx_queue_wake(regs);
 
 		writew(vptr->options.numtx - 1, &regs->TDCSize);
 
-		for (i = 0; i < vptr->num_txq; i++) {
-			writel(vptr->td_pool_dma[i], &regs->TDBaseLo[i]);
+		for (i = 0; i < vptr->tx.numq; i++) {
+			writel(vptr->tx.pool_dma[i], &regs->TDBaseLo[i]);
 			mac_tx_queue_run(regs, i);
 		}
 
@@ -1047,7 +1051,7 @@ static void __devinit velocity_init_info(struct pci_dev *pdev,
 
 	vptr->pdev = pdev;
 	vptr->chip_id = info->chip_id;
-	vptr->num_txq = info->txqueue;
+	vptr->tx.numq = info->txqueue;
 	vptr->multicast_limit = MCAM_SIZE;
 	spin_lock_init(&vptr->lock);
 	INIT_LIST_HEAD(&vptr->list);
@@ -1093,14 +1097,14 @@ static int __devinit velocity_get_pci_info(struct velocity_info *vptr, struct pc
 }
 
 /**
- *	velocity_init_rings	-	set up DMA rings
+ *	velocity_init_dma_rings	-	set up DMA rings
  *	@vptr: Velocity to set up
  *
  *	Allocate PCI mapped DMA rings for the receive and transmit layer
  *	to use.
  */
 
-static int velocity_init_rings(struct velocity_info *vptr)
+static int velocity_init_dma_rings(struct velocity_info *vptr)
 {
 	struct velocity_opt *opt = &vptr->options;
 	const unsigned int rx_ring_size = opt->numrx * sizeof(struct rx_desc);
@@ -1116,7 +1120,7 @@ static int velocity_init_rings(struct velocity_info *vptr)
 	 * pci_alloc_consistent() fulfills the requirement for 64 bytes
 	 * alignment
 	 */
-	pool = pci_alloc_consistent(pdev, tx_ring_size * vptr->num_txq +
+	pool = pci_alloc_consistent(pdev, tx_ring_size * vptr->tx.numq +
 				    rx_ring_size, &pool_dma);
 	if (!pool) {
 		dev_err(&pdev->dev, "%s : DMA memory allocation failed.\n",
@@ -1124,15 +1128,15 @@ static int velocity_init_rings(struct velocity_info *vptr)
 		return -ENOMEM;
 	}
 
-	vptr->rd_ring = pool;
-	vptr->rd_pool_dma = pool_dma;
+	vptr->rx.ring = pool;
+	vptr->rx.pool_dma = pool_dma;
 
 	pool += rx_ring_size;
 	pool_dma += rx_ring_size;
 
-	for (i = 0; i < vptr->num_txq; i++) {
-		vptr->td_rings[i] = pool;
-		vptr->td_pool_dma[i] = pool_dma;
+	for (i = 0; i < vptr->tx.numq; i++) {
+		vptr->tx.rings[i] = pool;
+		vptr->tx.pool_dma[i] = pool_dma;
 		pool += tx_ring_size;
 		pool_dma += tx_ring_size;
 	}
@@ -1141,18 +1145,18 @@ static int velocity_init_rings(struct velocity_info *vptr)
 }
 
 /**
- *	velocity_free_rings	-	free PCI ring pointers
+ *	velocity_free_dma_rings	-	free PCI ring pointers
  *	@vptr: Velocity to free from
  *
  *	Clean up the PCI ring buffers allocated to this velocity.
  */
 
-static void velocity_free_rings(struct velocity_info *vptr)
+static void velocity_free_dma_rings(struct velocity_info *vptr)
 {
 	const int size = vptr->options.numrx * sizeof(struct rx_desc) +
-		vptr->options.numtx * sizeof(struct tx_desc) * vptr->num_txq;
+		vptr->options.numtx * sizeof(struct tx_desc) * vptr->tx.numq;
 
-	pci_free_consistent(vptr->pdev, size, vptr->rd_ring, vptr->rd_pool_dma);
+	pci_free_consistent(vptr->pdev, size, vptr->rx.ring, vptr->rx.pool_dma);
 }
 
 static void velocity_give_many_rx_descs(struct velocity_info *vptr)
@@ -1164,44 +1168,44 @@ static void velocity_give_many_rx_descs(struct velocity_info *vptr)
 	 * RD number must be equal to 4X per hardware spec
 	 * (programming guide rev 1.20, p.13)
 	 */
-	if (vptr->rd_filled < 4)
+	if (vptr->rx.filled < 4)
 		return;
 
 	wmb();
 
-	unusable = vptr->rd_filled & 0x0003;
-	dirty = vptr->rd_dirty - unusable;
-	for (avail = vptr->rd_filled & 0xfffc; avail; avail--) {
+	unusable = vptr->rx.filled & 0x0003;
+	dirty = vptr->rx.dirty - unusable;
+	for (avail = vptr->rx.filled & 0xfffc; avail; avail--) {
 		dirty = (dirty > 0) ? dirty - 1 : vptr->options.numrx - 1;
-		vptr->rd_ring[dirty].rdesc0.len |= OWNED_BY_NIC;
+		vptr->rx.ring[dirty].rdesc0.len |= OWNED_BY_NIC;
 	}
 
-	writew(vptr->rd_filled & 0xfffc, &regs->RBRDU);
-	vptr->rd_filled = unusable;
+	writew(vptr->rx.filled & 0xfffc, &regs->RBRDU);
+	vptr->rx.filled = unusable;
 }
 
 static int velocity_rx_refill(struct velocity_info *vptr)
 {
-	int dirty = vptr->rd_dirty, done = 0;
+	int dirty = vptr->rx.dirty, done = 0;
 
 	do {
-		struct rx_desc *rd = vptr->rd_ring + dirty;
+		struct rx_desc *rd = vptr->rx.ring + dirty;
 
 		/* Fine for an all zero Rx desc at init time as well */
 		if (rd->rdesc0.len & OWNED_BY_NIC)
 			break;
 
-		if (!vptr->rd_info[dirty].skb) {
+		if (!vptr->rx.info[dirty].skb) {
 			if (velocity_alloc_rx_buf(vptr, dirty) < 0)
 				break;
 		}
 		done++;
 		dirty = (dirty < vptr->options.numrx - 1) ? dirty + 1 : 0;
-	} while (dirty != vptr->rd_curr);
+	} while (dirty != vptr->rx.curr);
 
 	if (done) {
-		vptr->rd_dirty = dirty;
-		vptr->rd_filled += done;
+		vptr->rx.dirty = dirty;
+		vptr->rx.filled += done;
 	}
 
 	return done;
@@ -1209,7 +1213,7 @@ static int velocity_rx_refill(struct velocity_info *vptr)
 
 static void velocity_set_rxbufsize(struct velocity_info *vptr, int mtu)
 {
-	vptr->rx_buf_sz = (mtu <= ETH_DATA_LEN) ? PKT_BUF_SZ : mtu + 32;
+	vptr->rx.buf_sz = (mtu <= ETH_DATA_LEN) ? PKT_BUF_SZ : mtu + 32;
 }
 
 /**
@@ -1224,12 +1228,12 @@ static int velocity_init_rd_ring(struct velocity_info *vptr)
 {
 	int ret = -ENOMEM;
 
-	vptr->rd_info = kcalloc(vptr->options.numrx,
+	vptr->rx.info = kcalloc(vptr->options.numrx,
 				sizeof(struct velocity_rd_info), GFP_KERNEL);
-	if (!vptr->rd_info)
+	if (!vptr->rx.info)
 		goto out;
 
-	vptr->rd_filled = vptr->rd_dirty = vptr->rd_curr = 0;
+	velocity_init_rx_ring_indexes(vptr);
 
 	if (velocity_rx_refill(vptr) != vptr->options.numrx) {
 		VELOCITY_PRT(MSG_LEVEL_ERR, KERN_ERR
@@ -1255,18 +1259,18 @@ static void velocity_free_rd_ring(struct velocity_info *vptr)
 {
 	int i;
 
-	if (vptr->rd_info == NULL)
+	if (vptr->rx.info == NULL)
 		return;
 
 	for (i = 0; i < vptr->options.numrx; i++) {
-		struct velocity_rd_info *rd_info = &(vptr->rd_info[i]);
-		struct rx_desc *rd = vptr->rd_ring + i;
+		struct velocity_rd_info *rd_info = &(vptr->rx.info[i]);
+		struct rx_desc *rd = vptr->rx.ring + i;
 
 		memset(rd, 0, sizeof(*rd));
 
 		if (!rd_info->skb)
 			continue;
-		pci_unmap_single(vptr->pdev, rd_info->skb_dma, vptr->rx_buf_sz,
+		pci_unmap_single(vptr->pdev, rd_info->skb_dma, vptr->rx.buf_sz,
 				 PCI_DMA_FROMDEVICE);
 		rd_info->skb_dma = (dma_addr_t) NULL;
 
@@ -1274,8 +1278,8 @@ static void velocity_free_rd_ring(struct velocity_info *vptr)
 		rd_info->skb = NULL;
 	}
 
-	kfree(vptr->rd_info);
-	vptr->rd_info = NULL;
+	kfree(vptr->rx.info);
+	vptr->rx.info = NULL;
 }
 
 /**
@@ -1293,19 +1297,19 @@ static int velocity_init_td_ring(struct velocity_info *vptr)
 	unsigned int j;
 
 	/* Init the TD ring entries */
-	for (j = 0; j < vptr->num_txq; j++) {
-		curr = vptr->td_pool_dma[j];
+	for (j = 0; j < vptr->tx.numq; j++) {
+		curr = vptr->tx.pool_dma[j];
 
-		vptr->td_infos[j] = kcalloc(vptr->options.numtx,
+		vptr->tx.infos[j] = kcalloc(vptr->options.numtx,
 					    sizeof(struct velocity_td_info),
 					    GFP_KERNEL);
-		if (!vptr->td_infos[j])	{
+		if (!vptr->tx.infos[j])	{
 			while(--j >= 0)
-				kfree(vptr->td_infos[j]);
+				kfree(vptr->tx.infos[j]);
 			return -ENOMEM;
 		}
 
-		vptr->td_tail[j] = vptr->td_curr[j] = vptr->td_used[j] = 0;
+		vptr->tx.tail[j] = vptr->tx.curr[j] = vptr->tx.used[j] = 0;
 	}
 	return 0;
 }
@@ -1317,7 +1321,7 @@ static int velocity_init_td_ring(struct velocity_info *vptr)
 static void velocity_free_td_ring_entry(struct velocity_info *vptr,
 							 int q, int n)
 {
-	struct velocity_td_info * td_info = &(vptr->td_infos[q][n]);
+	struct velocity_td_info * td_info = &(vptr->tx.infos[q][n]);
 	int i;
 
 	if (td_info == NULL)
@@ -1349,15 +1353,15 @@ static void velocity_free_td_ring(struct velocity_info *vptr)
 {
 	int i, j;
 
-	for (j = 0; j < vptr->num_txq; j++) {
-		if (vptr->td_infos[j] == NULL)
+	for (j = 0; j < vptr->tx.numq; j++) {
+		if (vptr->tx.infos[j] == NULL)
 			continue;
 		for (i = 0; i < vptr->options.numtx; i++) {
 			velocity_free_td_ring_entry(vptr, j, i);
 
 		}
-		kfree(vptr->td_infos[j]);
-		vptr->td_infos[j] = NULL;
+		kfree(vptr->tx.infos[j]);
+		vptr->tx.infos[j] = NULL;
 	}
 }
 
@@ -1374,13 +1378,13 @@ static void velocity_free_td_ring(struct velocity_info *vptr)
 static int velocity_rx_srv(struct velocity_info *vptr, int status)
 {
 	struct net_device_stats *stats = &vptr->stats;
-	int rd_curr = vptr->rd_curr;
+	int rd_curr = vptr->rx.curr;
 	int works = 0;
 
 	do {
-		struct rx_desc *rd = vptr->rd_ring + rd_curr;
+		struct rx_desc *rd = vptr->rx.ring + rd_curr;
 
-		if (!vptr->rd_info[rd_curr].skb)
+		if (!vptr->rx.info[rd_curr].skb)
 			break;
 
 		if (rd->rdesc0.len & OWNED_BY_NIC)
@@ -1412,7 +1416,7 @@ static int velocity_rx_srv(struct velocity_info *vptr, int status)
 			rd_curr = 0;
 	} while (++works <= 15);
 
-	vptr->rd_curr = rd_curr;
+	vptr->rx.curr = rd_curr;
 
 	if ((works > 0) && (velocity_rx_refill(vptr) > 0))
 		velocity_give_many_rx_descs(vptr);
@@ -1510,8 +1514,8 @@ static int velocity_receive_frame(struct velocity_info *vptr, int idx)
 {
 	void (*pci_action)(struct pci_dev *, dma_addr_t, size_t, int);
 	struct net_device_stats *stats = &vptr->stats;
-	struct velocity_rd_info *rd_info = &(vptr->rd_info[idx]);
-	struct rx_desc *rd = &(vptr->rd_ring[idx]);
+	struct velocity_rd_info *rd_info = &(vptr->rx.info[idx]);
+	struct rx_desc *rd = &(vptr->rx.ring[idx]);
 	int pkt_len = le16_to_cpu(rd->rdesc0.len) & 0x3fff;
 	struct sk_buff *skb;
 
@@ -1527,7 +1531,7 @@ static int velocity_receive_frame(struct velocity_info *vptr, int idx)
 	skb = rd_info->skb;
 
 	pci_dma_sync_single_for_cpu(vptr->pdev, rd_info->skb_dma,
-				    vptr->rx_buf_sz, PCI_DMA_FROMDEVICE);
+				    vptr->rx.buf_sz, PCI_DMA_FROMDEVICE);
 
 	/*
 	 *	Drop frame not meeting IEEE 802.3
@@ -1550,7 +1554,7 @@ static int velocity_receive_frame(struct velocity_info *vptr, int idx)
 		rd_info->skb = NULL;
 	}
 
-	pci_action(vptr->pdev, rd_info->skb_dma, vptr->rx_buf_sz,
+	pci_action(vptr->pdev, rd_info->skb_dma, vptr->rx.buf_sz,
 		   PCI_DMA_FROMDEVICE);
 
 	skb_put(skb, pkt_len - 4);
@@ -1580,10 +1584,10 @@ static int velocity_receive_frame(struct velocity_info *vptr, int idx)
 
 static int velocity_alloc_rx_buf(struct velocity_info *vptr, int idx)
 {
-	struct rx_desc *rd = &(vptr->rd_ring[idx]);
-	struct velocity_rd_info *rd_info = &(vptr->rd_info[idx]);
+	struct rx_desc *rd = &(vptr->rx.ring[idx]);
+	struct velocity_rd_info *rd_info = &(vptr->rx.info[idx]);
 
-	rd_info->skb = netdev_alloc_skb(vptr->dev, vptr->rx_buf_sz + 64);
+	rd_info->skb = dev_alloc_skb(vptr->rx.buf_sz + 64);
 	if (rd_info->skb == NULL)
 		return -ENOMEM;
 
@@ -1592,14 +1596,15 @@ static int velocity_alloc_rx_buf(struct velocity_info *vptr, int idx)
 	 *	64byte alignment.
 	 */
 	skb_reserve(rd_info->skb, (unsigned long) rd_info->skb->data & 63);
-	rd_info->skb_dma = pci_map_single(vptr->pdev, rd_info->skb->data, vptr->rx_buf_sz, PCI_DMA_FROMDEVICE);
+	rd_info->skb_dma = pci_map_single(vptr->pdev, rd_info->skb->data,
+					vptr->rx.buf_sz, PCI_DMA_FROMDEVICE);
 
 	/*
 	 *	Fill in the descriptor to match
- 	 */
+	 */
 
 	*((u32 *) & (rd->rdesc0)) = 0;
-	rd->size = cpu_to_le16(vptr->rx_buf_sz) | RX_INTEN;
+	rd->size = cpu_to_le16(vptr->rx.buf_sz) | RX_INTEN;
 	rd->pa_low = cpu_to_le32(rd_info->skb_dma);
 	rd->pa_high = 0;
 	return 0;
@@ -1625,15 +1630,15 @@ static int velocity_tx_srv(struct velocity_info *vptr, u32 status)
 	struct velocity_td_info *tdinfo;
 	struct net_device_stats *stats = &vptr->stats;
 
-	for (qnum = 0; qnum < vptr->num_txq; qnum++) {
-		for (idx = vptr->td_tail[qnum]; vptr->td_used[qnum] > 0;
+	for (qnum = 0; qnum < vptr->tx.numq; qnum++) {
+		for (idx = vptr->tx.tail[qnum]; vptr->tx.used[qnum] > 0;
 			idx = (idx + 1) % vptr->options.numtx) {
 
 			/*
 			 *	Get Tx Descriptor
 			 */
-			td = &(vptr->td_rings[qnum][idx]);
-			tdinfo = &(vptr->td_infos[qnum][idx]);
+			td = &(vptr->tx.rings[qnum][idx]);
+			tdinfo = &(vptr->tx.infos[qnum][idx]);
 
 			if (td->tdesc0.len & OWNED_BY_NIC)
 				break;
@@ -1657,9 +1662,9 @@ static int velocity_tx_srv(struct velocity_info *vptr, u32 status)
 				stats->tx_bytes += tdinfo->skb->len;
 			}
 			velocity_free_tx_buf(vptr, tdinfo);
-			vptr->td_used[qnum]--;
+			vptr->tx.used[qnum]--;
 		}
-		vptr->td_tail[qnum] = idx;
+		vptr->tx.tail[qnum] = idx;
 
 		if (AVAIL_TD(vptr, qnum) < 1) {
 			full = 1;
@@ -1846,6 +1851,40 @@ static void velocity_free_tx_buf(struct velocity_info *vptr, struct velocity_td_
 	tdinfo->skb = NULL;
 }
 
+static int velocity_init_rings(struct velocity_info *vptr, int mtu)
+{
+	int ret;
+
+	velocity_set_rxbufsize(vptr, mtu);
+
+	ret = velocity_init_dma_rings(vptr);
+	if (ret < 0)
+		goto out;
+
+	ret = velocity_init_rd_ring(vptr);
+	if (ret < 0)
+		goto err_free_dma_rings_0;
+
+	ret = velocity_init_td_ring(vptr);
+	if (ret < 0)
+		goto err_free_rd_ring_1;
+out:
+	return ret;
+
+err_free_rd_ring_1:
+	velocity_free_rd_ring(vptr);
+err_free_dma_rings_0:
+	velocity_free_dma_rings(vptr);
+	goto out;
+}
+
+static void velocity_free_rings(struct velocity_info *vptr)
+{
+	velocity_free_td_ring(vptr);
+	velocity_free_rd_ring(vptr);
+	velocity_free_dma_rings(vptr);
+}
+
 /**
  *	velocity_open		-	interface activation callback
  *	@dev: network layer device to open
@@ -1862,20 +1901,10 @@ static int velocity_open(struct net_device *dev)
 	struct velocity_info *vptr = netdev_priv(dev);
 	int ret;
 
-	velocity_set_rxbufsize(vptr, dev->mtu);
-
-	ret = velocity_init_rings(vptr);
+	ret = velocity_init_rings(vptr, dev->mtu);
 	if (ret < 0)
 		goto out;
 
-	ret = velocity_init_rd_ring(vptr);
-	if (ret < 0)
-		goto err_free_desc_rings;
-
-	ret = velocity_init_td_ring(vptr);
-	if (ret < 0)
-		goto err_free_rd_ring;
-
 	/* Ensure chip is running */
 	pci_set_power_state(vptr->pdev, PCI_D0);
 
@@ -1888,7 +1917,8 @@ static int velocity_open(struct net_device *dev)
 	if (ret < 0) {
 		/* Power down the chip */
 		pci_set_power_state(vptr->pdev, PCI_D3hot);
-		goto err_free_td_ring;
+		velocity_free_rings(vptr);
+		goto out;
 	}
 
 	mac_enable_int(vptr->mac_regs);
@@ -1896,14 +1926,6 @@ static int velocity_open(struct net_device *dev)
 	vptr->flags |= VELOCITY_FLAGS_OPENED;
 out:
 	return ret;
-
-err_free_td_ring:
-	velocity_free_td_ring(vptr);
-err_free_rd_ring:
-	velocity_free_rd_ring(vptr);
-err_free_desc_rings:
-	velocity_free_rings(vptr);
-	goto out;
 }
 
 /**
@@ -1919,50 +1941,72 @@ err_free_desc_rings:
 static int velocity_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct velocity_info *vptr = netdev_priv(dev);
-	unsigned long flags;
-	int oldmtu = dev->mtu;
 	int ret = 0;
 
 	if ((new_mtu < VELOCITY_MIN_MTU) || new_mtu > (VELOCITY_MAX_MTU)) {
 		VELOCITY_PRT(MSG_LEVEL_ERR, KERN_NOTICE "%s: Invalid MTU.\n",
 				vptr->dev->name);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_0;
 	}
 
 	if (!netif_running(dev)) {
 		dev->mtu = new_mtu;
-		return 0;
+		goto out_0;
 	}
 
-	if (new_mtu != oldmtu) {
+	if (dev->mtu != new_mtu) {
+		struct velocity_info *tmp_vptr;
+		unsigned long flags;
+		struct rx_info rx;
+		struct tx_info tx;
+
+		tmp_vptr = kzalloc(sizeof(*tmp_vptr), GFP_KERNEL);
+		if (!tmp_vptr) {
+			ret = -ENOMEM;
+			goto out_0;
+		}
+
+		tmp_vptr->dev = dev;
+		tmp_vptr->pdev = vptr->pdev;
+		tmp_vptr->options = vptr->options;
+		tmp_vptr->tx.numq = vptr->tx.numq;
+
+		ret = velocity_init_rings(tmp_vptr, new_mtu);
+		if (ret < 0)
+			goto out_free_tmp_vptr_1;
+
 		spin_lock_irqsave(&vptr->lock, flags);
 
 		netif_stop_queue(dev);
 		velocity_shutdown(vptr);
 
-		velocity_free_td_ring(vptr);
-		velocity_free_rd_ring(vptr);
+		rx = vptr->rx;
+		tx = vptr->tx;
 
-		dev->mtu = new_mtu;
+		vptr->rx = tmp_vptr->rx;
+		vptr->tx = tmp_vptr->tx;
 
-		velocity_set_rxbufsize(vptr, new_mtu);
+		tmp_vptr->rx = rx;
+		tmp_vptr->tx = tx;
 
-		ret = velocity_init_rd_ring(vptr);
-		if (ret < 0)
-			goto out_unlock;
+		dev->mtu = new_mtu;
 
-		ret = velocity_init_td_ring(vptr);
-		if (ret < 0)
-			goto out_unlock;
+		velocity_give_many_rx_descs(vptr);
 
 		velocity_init_registers(vptr, VELOCITY_INIT_COLD);
 
 		mac_enable_int(vptr->mac_regs);
 		netif_start_queue(dev);
-out_unlock:
+
 		spin_unlock_irqrestore(&vptr->lock, flags);
-	}
 
+		velocity_free_rings(tmp_vptr);
+
+out_free_tmp_vptr_1:
+		kfree(tmp_vptr);
+	}
+out_0:
 	return ret;
 }
 
@@ -2008,9 +2052,6 @@ static int velocity_close(struct net_device *dev)
 	/* Power down the chip */
 	pci_set_power_state(vptr->pdev, PCI_D3hot);
 
-	/* Free the resources */
-	velocity_free_td_ring(vptr);
-	velocity_free_rd_ring(vptr);
 	velocity_free_rings(vptr);
 
 	vptr->flags &= (~VELOCITY_FLAGS_OPENED);
@@ -2056,9 +2097,9 @@ static int velocity_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	spin_lock_irqsave(&vptr->lock, flags);
 
-	index = vptr->td_curr[qnum];
-	td_ptr = &(vptr->td_rings[qnum][index]);
-	tdinfo = &(vptr->td_infos[qnum][index]);
+	index = vptr->tx.curr[qnum];
+	td_ptr = &(vptr->tx.rings[qnum][index]);
+	tdinfo = &(vptr->tx.infos[qnum][index]);
 
 	td_ptr->tdesc1.TCR = TCR0_TIC;
 	td_ptr->td_buf[0].size &= ~TD_QUEUE;
@@ -2071,9 +2112,9 @@ static int velocity_xmit(struct sk_buff *skb, struct net_device *dev)
 			skb_copy_from_linear_data(skb, tdinfo->buf, skb->len);
 			tdinfo->skb_dma[0] = tdinfo->buf_dma;
 			td_ptr->tdesc0.len = len;
-			td_ptr->td_buf[0].pa_low = cpu_to_le32(tdinfo->skb_dma[0]);
-			td_ptr->td_buf[0].pa_high = 0;
-			td_ptr->td_buf[0].size = len;	/* queue is 0 anyway */
+			td_ptr->tx.buf[0].pa_low = cpu_to_le32(tdinfo->skb_dma[0]);
+			td_ptr->tx.buf[0].pa_high = 0;
+			td_ptr->tx.buf[0].size = len;	/* queue is 0 anyway */
 			tdinfo->nskb_dma = 1;
 		} else {
 			int i = 0;
@@ -2084,9 +2125,9 @@ static int velocity_xmit(struct sk_buff *skb, struct net_device *dev)
 			td_ptr->tdesc0.len = len;
 
 			/* FIXME: support 48bit DMA later */
-			td_ptr->td_buf[i].pa_low = cpu_to_le32(tdinfo->skb_dma);
-			td_ptr->td_buf[i].pa_high = 0;
-			td_ptr->td_buf[i].size = cpu_to_le16(skb_headlen(skb));
+			td_ptr->tx.buf[i].pa_low = cpu_to_le32(tdinfo->skb_dma);
+			td_ptr->tx.buf[i].pa_high = 0;
+			td_ptr->tx.buf[i].size = cpu_to_le16(skb_headlen(skb));
 
 			for (i = 0; i < nfrags; i++) {
 				skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
@@ -2094,9 +2135,9 @@ static int velocity_xmit(struct sk_buff *skb, struct net_device *dev)
 
 				tdinfo->skb_dma[i + 1] = pci_map_single(vptr->pdev, addr, frag->size, PCI_DMA_TODEVICE);
 
-				td_ptr->td_buf[i + 1].pa_low = cpu_to_le32(tdinfo->skb_dma[i + 1]);
-				td_ptr->td_buf[i + 1].pa_high = 0;
-				td_ptr->td_buf[i + 1].size = cpu_to_le16(frag->size);
+				td_ptr->tx.buf[i + 1].pa_low = cpu_to_le32(tdinfo->skb_dma[i + 1]);
+				td_ptr->tx.buf[i + 1].pa_high = 0;
+				td_ptr->tx.buf[i + 1].size = cpu_to_le16(frag->size);
 			}
 			tdinfo->nskb_dma = i - 1;
 		}
@@ -2142,13 +2183,13 @@ static int velocity_xmit(struct sk_buff *skb, struct net_device *dev)
 		if (prev < 0)
 			prev = vptr->options.numtx - 1;
 		td_ptr->tdesc0.len |= OWNED_BY_NIC;
-		vptr->td_used[qnum]++;
-		vptr->td_curr[qnum] = (index + 1) % vptr->options.numtx;
+		vptr->tx.used[qnum]++;
+		vptr->tx.curr[qnum] = (index + 1) % vptr->options.numtx;
 
 		if (AVAIL_TD(vptr, qnum) < 1)
 			netif_stop_queue(dev);
 
-		td_ptr = &(vptr->td_rings[qnum][prev]);
+		td_ptr = &(vptr->tx.rings[qnum][prev]);
 		td_ptr->td_buf[0].size |= TD_QUEUE;
 		mac_tx_queue_wake(vptr->mac_regs, qnum);
 	}
@@ -3405,8 +3446,8 @@ static int velocity_resume(struct pci_dev *pdev)
 
 	velocity_tx_srv(vptr, 0);
 
-	for (i = 0; i < vptr->num_txq; i++) {
-		if (vptr->td_used[i]) {
+	for (i = 0; i < vptr->tx.numq; i++) {
+		if (vptr->tx.used[i]) {
 			mac_tx_queue_wake(vptr->mac_regs, i);
 		}
 	}
diff --git a/drivers/net/via-velocity.h b/drivers/net/via-velocity.h
index 8644614..1b95b04 100644
--- a/drivers/net/via-velocity.h
+++ b/drivers/net/via-velocity.h
@@ -1494,6 +1494,10 @@ struct velocity_opt {
 	u32 flags;
 };
 
+#define AVAIL_TD(p,q)   ((p)->options.numtx-((p)->tx.used[(q)]))
+
+#define GET_RD_BY_IDX(vptr, idx)   (vptr->rd_ring[idx])
+
 struct velocity_info {
 	struct list_head list;
 
@@ -1501,9 +1505,6 @@ struct velocity_info {
 	struct net_device *dev;
 	struct net_device_stats stats;
 
-	dma_addr_t rd_pool_dma;
-	dma_addr_t td_pool_dma[TX_QUEUE_NO];
-
 	struct vlan_group    *vlgrp;
 	u8 ip_addr[4];
 	enum chip_type chip_id;
@@ -1512,25 +1513,29 @@ struct velocity_info {
 	unsigned long memaddr;
 	unsigned long ioaddr;
 
-	u8 rev_id;
-
-#define AVAIL_TD(p,q)   ((p)->options.numtx-((p)->td_used[(q)]))
+	struct tx_info {
+		int numq;
+
+		/* FIXME: the locality of the data seems rather poor. */
+		int used[TX_QUEUE_NO];
+		int curr[TX_QUEUE_NO];
+		int tail[TX_QUEUE_NO];
+		struct tx_desc *rings[TX_QUEUE_NO];
+		struct velocity_td_info *infos[TX_QUEUE_NO];
+		dma_addr_t pool_dma[TX_QUEUE_NO];
+	} tx;
+
+	struct rx_info {
+		int buf_sz;
+
+		int dirty;
+		int curr;
+		u32 filled;
+		struct rx_desc *ring;
+		struct velocity_rd_info *info;	/* It's an array */
+		dma_addr_t pool_dma;
+	} rx;
 
-	int num_txq;
-
-	volatile int td_used[TX_QUEUE_NO];
-	int td_curr[TX_QUEUE_NO];
-	int td_tail[TX_QUEUE_NO];
-	struct tx_desc *td_rings[TX_QUEUE_NO];
-	struct velocity_td_info *td_infos[TX_QUEUE_NO];
-
-	int rd_curr;
-	int rd_dirty;
-	u32 rd_filled;
-	struct rx_desc *rd_ring;
-	struct velocity_rd_info *rd_info;	/* It's an array */
-
-#define GET_RD_BY_IDX(vptr, idx)   (vptr->rd_ring[idx])
 	u32 mib_counter[MAX_HW_MIB_COUNTER];
 	struct velocity_opt options;
 
@@ -1538,7 +1543,6 @@ struct velocity_info {
 
 	u32 flags;
 
-	int rx_buf_sz;
 	u32 mii_status;
 	u32 phy_id;
 	int multicast_limit;
@@ -1554,8 +1558,8 @@ struct velocity_info {
 	struct velocity_context context;
 
 	u32 ticks;
-	u32 rx_bytes;
 
+	u8 rev_id;
 };
 
 /**
diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index 846be60..2ae2ec4 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -25,7 +25,7 @@ if WAN
 # There is no way to detect a comtrol sv11 - force it modular for now.
 config HOSTESS_SV11
 	tristate "Comtrol Hostess SV-11 support"
-	depends on ISA && m && ISA_DMA_API && INET
+	depends on ISA && m && ISA_DMA_API && INET && HDLC
 	help
 	  Driver for Comtrol Hostess SV-11 network card which
 	  operates on low speed synchronous serial links at up to
@@ -37,7 +37,7 @@ config HOSTESS_SV11
 # The COSA/SRP driver has not been tested as non-modular yet.
 config COSA
 	tristate "COSA/SRP sync serial boards support"
-	depends on ISA && m && ISA_DMA_API
+	depends on ISA && m && ISA_DMA_API && HDLC
 	---help---
 	  Driver for COSA and SRP synchronous serial boards.
 
@@ -61,7 +61,7 @@ config COSA
 #
 config LANMEDIA
 	tristate "LanMedia Corp. SSI/V.35, T1/E1, HSSI, T3 boards"
-	depends on PCI && VIRT_TO_BUS
+	depends on PCI && VIRT_TO_BUS && HDLC
 	---help---
 	  Driver for the following Lan Media family of serial boards:
 
@@ -78,9 +78,8 @@ config LANMEDIA
 	  - LMC 5245 board connects directly to a T3 circuit saving the
 	  additional external hardware.
 
-	  To change setting such as syncPPP vs Cisco HDLC or clock source you
-	  will need lmcctl.  It is available at <ftp://ftp.lanmedia.com/>
-	  (broken link).
+	  To change setting such as clock source you will need lmcctl.
+	  It is available at <ftp://ftp.lanmedia.com/> (broken link).
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called lmc.
@@ -88,7 +87,7 @@ config LANMEDIA
 # There is no way to detect a Sealevel board. Force it modular
 config SEALEVEL_4021
 	tristate "Sealevel Systems 4021 support"
-	depends on ISA && m && ISA_DMA_API && INET
+	depends on ISA && m && ISA_DMA_API && INET && HDLC
 	help
 	  This is a driver for the Sealevel Systems ACB 56 serial I/O adapter.
 
@@ -154,8 +153,6 @@ config HDLC_PPP
 	help
 	  Generic HDLC driver supporting PPP over WAN connections.
 
-	  It will be replaced by new PPP implementation in Linux 2.6.26.
-
 	  If unsure, say N.
 
 config HDLC_X25
diff --git a/drivers/net/wan/Makefile b/drivers/net/wan/Makefile
index d61fef3..1025496 100644
--- a/drivers/net/wan/Makefile
+++ b/drivers/net/wan/Makefile
@@ -21,12 +21,11 @@ pc300-y				:= pc300_drv.o
 pc300-$(CONFIG_PC300_MLPPP)	+= pc300_tty.o
 pc300-objs			:= $(pc300-y)
 
-obj-$(CONFIG_HOSTESS_SV11)	+= z85230.o	syncppp.o	hostess_sv11.o
-obj-$(CONFIG_SEALEVEL_4021)	+= z85230.o	syncppp.o	sealevel.o
-obj-$(CONFIG_COSA)		+=		syncppp.o	cosa.o
-obj-$(CONFIG_FARSYNC)		+=		syncppp.o	farsync.o
-obj-$(CONFIG_DSCC4)             +=				dscc4.o
-obj-$(CONFIG_LANMEDIA)		+=		syncppp.o
+obj-$(CONFIG_HOSTESS_SV11)	+= z85230.o	hostess_sv11.o
+obj-$(CONFIG_SEALEVEL_4021)	+= z85230.o	sealevel.o
+obj-$(CONFIG_COSA)		+= cosa.o
+obj-$(CONFIG_FARSYNC)		+= farsync.o
+obj-$(CONFIG_DSCC4)             += dscc4.o
 obj-$(CONFIG_X25_ASY)		+= x25_asy.o
 
 obj-$(CONFIG_LANMEDIA)		+= lmc/
diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index f7d3349..f140515 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -2,6 +2,7 @@
 
 /*
  *  Copyright (C) 1995-1997  Jan "Yenya" Kasprzak <kas@fi.muni.cz>
+ *  Generic HDLC port Copyright (C) 2008 Krzysztof Halasa <khc@pm.waw.pl>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -54,7 +55,7 @@
  *
  * The Linux driver (unlike the present *BSD drivers :-) can work even
  * for the COSA and SRP in one computer and allows each channel to work
- * in one of the three modes (character device, Cisco HDLC, Sync PPP).
+ * in one of the two modes (character or network device).
  *
  * AUTHOR
  *
@@ -72,12 +73,6 @@
  * The Comtrol Hostess SV11 driver by Alan Cox
  * The Sync PPP/Cisco HDLC layer (syncppp.c) ported to Linux by Alan Cox
  */
-/*
- *     5/25/1999 : Marcelo Tosatti <marcelo@conectiva.com.br>
- *             fixed a deadlock in cosa_sppp_open
- */
-
-/* ---------- Headers, macros, data structures ---------- */
 
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -86,6 +81,7 @@
 #include <linux/fs.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
+#include <linux/hdlc.h>
 #include <linux/errno.h>
 #include <linux/ioport.h>
 #include <linux/netdevice.h>
@@ -93,14 +89,12 @@
 #include <linux/mutex.h>
 #include <linux/device.h>
 #include <linux/smp_lock.h>
-
-#undef COSA_SLOW_IO	/* for testing purposes only */
-
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/byteorder.h>
 
-#include <net/syncppp.h>
+#undef COSA_SLOW_IO	/* for testing purposes only */
+
 #include "cosa.h"
 
 /* Maximum length of the identification string. */
@@ -112,7 +106,6 @@
 /* Per-channel data structure */
 
 struct channel_data {
-	void *if_ptr;	/* General purpose pointer (used by SPPP) */
 	int usage;	/* Usage count; >0 for chrdev, -1 for netdev */
 	int num;	/* Number of the channel */
 	struct cosa_data *cosa;	/* Pointer to the per-card structure */
@@ -136,10 +129,9 @@ struct channel_data {
 	wait_queue_head_t txwaitq, rxwaitq;
 	int tx_status, rx_status;
 
-	/* SPPP/HDLC device parts */
-	struct ppp_device pppdev;
+	/* generic HDLC device parts */
+	struct net_device *netdev;
 	struct sk_buff *rx_skb, *tx_skb;
-	struct net_device_stats stats;
 };
 
 /* cosa->firmware_status bits */
@@ -281,21 +273,19 @@ static int cosa_start_tx(struct channel_data *channel, char *buf, int size);
 static void cosa_kick(struct cosa_data *cosa);
 static int cosa_dma_able(struct channel_data *chan, char *buf, int data);
 
-/* SPPP/HDLC stuff */
-static void sppp_channel_init(struct channel_data *chan);
-static void sppp_channel_delete(struct channel_data *chan);
-static int cosa_sppp_open(struct net_device *d);
-static int cosa_sppp_close(struct net_device *d);
-static void cosa_sppp_timeout(struct net_device *d);
-static int cosa_sppp_tx(struct sk_buff *skb, struct net_device *d);
-static char *sppp_setup_rx(struct channel_data *channel, int size);
-static int sppp_rx_done(struct channel_data *channel);
-static int sppp_tx_done(struct channel_data *channel, int size);
-static int cosa_sppp_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
-static struct net_device_stats *cosa_net_stats(struct net_device *dev);
+/* Network device stuff */
+static int cosa_net_attach(struct net_device *dev, unsigned short encoding,
+			   unsigned short parity);
+static int cosa_net_open(struct net_device *d);
+static int cosa_net_close(struct net_device *d);
+static void cosa_net_timeout(struct net_device *d);
+static int cosa_net_tx(struct sk_buff *skb, struct net_device *d);
+static char *cosa_net_setup_rx(struct channel_data *channel, int size);
+static int cosa_net_rx_done(struct channel_data *channel);
+static int cosa_net_tx_done(struct channel_data *channel, int size);
+static int cosa_net_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
 
 /* Character device */
-static void chardev_channel_init(struct channel_data *chan);
 static char *chrdev_setup_rx(struct channel_data *channel, int size);
 static int chrdev_rx_done(struct channel_data *channel);
 static int chrdev_tx_done(struct channel_data *channel, int size);
@@ -357,17 +347,17 @@ static void debug_status_in(struct cosa_data *cosa, int status);
 static void debug_status_out(struct cosa_data *cosa, int status);
 #endif
 
-
+static inline struct channel_data* dev_to_chan(struct net_device *dev)
+{
+	return (struct channel_data *)dev_to_hdlc(dev)->priv;
+}
+
 /* ---------- Initialization stuff ---------- */
 
 static int __init cosa_init(void)
 {
 	int i, err = 0;
 
-	printk(KERN_INFO "cosa v1.08 (c) 1997-2000 Jan Kasprzak <kas@fi.muni.cz>\n");
-#ifdef CONFIG_SMP
-	printk(KERN_INFO "cosa: SMP found. Please mail any success/failure reports to the author.\n");
-#endif
 	if (cosa_major > 0) {
 		if (register_chrdev(cosa_major, "cosa", &cosa_fops)) {
 			printk(KERN_WARNING "cosa: unable to get major %d\n",
@@ -402,7 +392,7 @@ static int __init cosa_init(void)
 				      NULL, "cosa%d", i);
 	err = 0;
 	goto out;
-	
+
 out_chrdev:
 	unregister_chrdev(cosa_major, "cosa");
 out:
@@ -414,43 +404,29 @@ static void __exit cosa_exit(void)
 {
 	struct cosa_data *cosa;
 	int i;
-	printk(KERN_INFO "Unloading the cosa module\n");
 
-	for (i=0; i<nr_cards; i++)
+	for (i = 0; i < nr_cards; i++)
 		device_destroy(cosa_class, MKDEV(cosa_major, i));
 	class_destroy(cosa_class);
-	for (cosa=cosa_cards; nr_cards--; cosa++) {
+
+	for (cosa = cosa_cards; nr_cards--; cosa++) {
 		/* Clean up the per-channel data */
-		for (i=0; i<cosa->nchannels; i++) {
+		for (i = 0; i < cosa->nchannels; i++) {
 			/* Chardev driver has no alloc'd per-channel data */
-			sppp_channel_delete(cosa->chan+i);
+			unregister_hdlc_device(cosa->chan[i].netdev);
+			free_netdev(cosa->chan[i].netdev);
 		}
 		/* Clean up the per-card data */
 		kfree(cosa->chan);
 		kfree(cosa->bouncebuf);
 		free_irq(cosa->irq, cosa);
 		free_dma(cosa->dma);
-		release_region(cosa->datareg,is_8bit(cosa)?2:4);
+		release_region(cosa->datareg, is_8bit(cosa) ? 2 : 4);
 	}
 	unregister_chrdev(cosa_major, "cosa");
 }
 module_exit(cosa_exit);
 
-/*
- * This function should register all the net devices needed for the
- * single channel.
- */
-static __inline__ void channel_init(struct channel_data *chan)
-{
-	sprintf(chan->name, "cosa%dc%d", chan->cosa->num, chan->num);
-
-	/* Initialize the chardev data structures */
-	chardev_channel_init(chan);
-
-	/* Register the sppp interface */
-	sppp_channel_init(chan);
-}
-	
 static int cosa_probe(int base, int irq, int dma)
 {
 	struct cosa_data *cosa = cosa_cards+nr_cards;
@@ -576,13 +552,43 @@ static int cosa_probe(int base, int irq, int dma)
 	/* Initialize the per-channel data */
 	cosa->chan = kcalloc(cosa->nchannels, sizeof(struct channel_data), GFP_KERNEL);
 	if (!cosa->chan) {
-	        err = -ENOMEM;
+		err = -ENOMEM;
 		goto err_out3;
 	}
-	for (i=0; i<cosa->nchannels; i++) {
-		cosa->chan[i].cosa = cosa;
-		cosa->chan[i].num = i;
-		channel_init(cosa->chan+i);
+
+	for (i = 0; i < cosa->nchannels; i++) {
+		struct channel_data *chan = &cosa->chan[i];
+
+		chan->cosa = cosa;
+		chan->num = i;
+		sprintf(chan->name, "cosa%dc%d", chan->cosa->num, i);
+
+		/* Initialize the chardev data structures */
+		mutex_init(&chan->rlock);
+		init_MUTEX(&chan->wsem);
+
+		/* Register the network interface */
+		if (!(chan->netdev = alloc_hdlcdev(chan))) {
+			printk(KERN_WARNING "%s: alloc_hdlcdev failed.\n",
+			       chan->name);
+			goto err_hdlcdev;
+		}
+		dev_to_hdlc(chan->netdev)->attach = cosa_net_attach;
+		dev_to_hdlc(chan->netdev)->xmit = cosa_net_tx;
+		chan->netdev->open = cosa_net_open;
+		chan->netdev->stop = cosa_net_close;
+		chan->netdev->do_ioctl = cosa_net_ioctl;
+		chan->netdev->tx_timeout = cosa_net_timeout;
+		chan->netdev->watchdog_timeo = TX_TIMEOUT;
+		chan->netdev->base_addr = chan->cosa->datareg;
+		chan->netdev->irq = chan->cosa->irq;
+		chan->netdev->dma = chan->cosa->dma;
+		if (register_hdlc_device(chan->netdev)) {
+			printk(KERN_WARNING "%s: register_hdlc_device()"
+			       " failed.\n", chan->netdev->name);
+			free_netdev(chan->netdev);
+			goto err_hdlcdev;
+		}
 	}
 
 	printk (KERN_INFO "cosa%d: %s (%s at 0x%x irq %d dma %d), %d channels\n",
@@ -590,13 +596,20 @@ static int cosa_probe(int base, int irq, int dma)
 		cosa->datareg, cosa->irq, cosa->dma, cosa->nchannels);
 
 	return nr_cards++;
+
+err_hdlcdev:
+	while (i-- > 0) {
+		unregister_hdlc_device(cosa->chan[i].netdev);
+		free_netdev(cosa->chan[i].netdev);
+	}
+	kfree(cosa->chan);
 err_out3:
 	kfree(cosa->bouncebuf);
 err_out2:
 	free_dma(cosa->dma);
 err_out1:
 	free_irq(cosa->irq, cosa);
-err_out:	
+err_out:
 	release_region(cosa->datareg,is_8bit(cosa)?2:4);
 	printk(KERN_NOTICE "cosa%d: allocating resources failed\n",
 	       cosa->num);
@@ -604,54 +617,19 @@ err_out:
 }
 
 
-/*---------- SPPP/HDLC netdevice ---------- */
+/*---------- network device ---------- */
 
-static void cosa_setup(struct net_device *d)
+static int cosa_net_attach(struct net_device *dev, unsigned short encoding,
+			   unsigned short parity)
 {
-	d->open = cosa_sppp_open;
-	d->stop = cosa_sppp_close;
-	d->hard_start_xmit = cosa_sppp_tx;
-	d->do_ioctl = cosa_sppp_ioctl;
-	d->get_stats = cosa_net_stats;
-	d->tx_timeout = cosa_sppp_timeout;
-	d->watchdog_timeo = TX_TIMEOUT;
-}
-
-static void sppp_channel_init(struct channel_data *chan)
-{
-	struct net_device *d;
-	chan->if_ptr = &chan->pppdev;
-	d = alloc_netdev(0, chan->name, cosa_setup);
-	if (!d) {
-		printk(KERN_WARNING "%s: alloc_netdev failed.\n", chan->name);
-		return;
-	}
-	chan->pppdev.dev = d;
-	d->base_addr = chan->cosa->datareg;
-	d->irq = chan->cosa->irq;
-	d->dma = chan->cosa->dma;
-	d->ml_priv = chan;
-	sppp_attach(&chan->pppdev);
-	if (register_netdev(d)) {
-		printk(KERN_WARNING "%s: register_netdev failed.\n", d->name);
-		sppp_detach(d);
-		free_netdev(d);
-		chan->pppdev.dev = NULL;
-		return;
-	}
-}
-
-static void sppp_channel_delete(struct channel_data *chan)
-{
-	unregister_netdev(chan->pppdev.dev);
-	sppp_detach(chan->pppdev.dev);
-	free_netdev(chan->pppdev.dev);
-	chan->pppdev.dev = NULL;
+	if (encoding == ENCODING_NRZ && parity == PARITY_CRC16_PR1_CCITT)
+		return 0;
+	return -EINVAL;
 }
 
-static int cosa_sppp_open(struct net_device *d)
+static int cosa_net_open(struct net_device *dev)
 {
-	struct channel_data *chan = d->ml_priv;
+	struct channel_data *chan = dev_to_chan(dev);
 	int err;
 	unsigned long flags;
 
@@ -662,36 +640,35 @@ static int cosa_sppp_open(struct net_device *d)
 	}
 	spin_lock_irqsave(&chan->cosa->lock, flags);
 	if (chan->usage != 0) {
-		printk(KERN_WARNING "%s: sppp_open called with usage count %d\n",
-			chan->name, chan->usage);
+		printk(KERN_WARNING "%s: cosa_net_open called with usage count"
+		       " %d\n", chan->name, chan->usage);
 		spin_unlock_irqrestore(&chan->cosa->lock, flags);
 		return -EBUSY;
 	}
-	chan->setup_rx = sppp_setup_rx;
-	chan->tx_done = sppp_tx_done;
-	chan->rx_done = sppp_rx_done;
-	chan->usage=-1;
+	chan->setup_rx = cosa_net_setup_rx;
+	chan->tx_done = cosa_net_tx_done;
+	chan->rx_done = cosa_net_rx_done;
+	chan->usage = -1;
 	chan->cosa->usage++;
 	spin_unlock_irqrestore(&chan->cosa->lock, flags);
 
-	err = sppp_open(d);
+	err = hdlc_open(dev);
 	if (err) {
 		spin_lock_irqsave(&chan->cosa->lock, flags);
-		chan->usage=0;
+		chan->usage = 0;
 		chan->cosa->usage--;
-		
 		spin_unlock_irqrestore(&chan->cosa->lock, flags);
 		return err;
 	}
 
-	netif_start_queue(d);
+	netif_start_queue(dev);
 	cosa_enable_rx(chan);
 	return 0;
 }
 
-static int cosa_sppp_tx(struct sk_buff *skb, struct net_device *dev)
+static int cosa_net_tx(struct sk_buff *skb, struct net_device *dev)
 {
-	struct channel_data *chan = dev->ml_priv;
+	struct channel_data *chan = dev_to_chan(dev);
 
 	netif_stop_queue(dev);
 
@@ -700,16 +677,16 @@ static int cosa_sppp_tx(struct sk_buff *skb, struct net_device *dev)
 	return 0;
 }
 
-static void cosa_sppp_timeout(struct net_device *dev)
+static void cosa_net_timeout(struct net_device *dev)
 {
-	struct channel_data *chan = dev->ml_priv;
+	struct channel_data *chan = dev_to_chan(dev);
 
 	if (test_bit(RXBIT, &chan->cosa->rxtx)) {
-		chan->stats.rx_errors++;
-		chan->stats.rx_missed_errors++;
+		chan->netdev->stats.rx_errors++;
+		chan->netdev->stats.rx_missed_errors++;
 	} else {
-		chan->stats.tx_errors++;
-		chan->stats.tx_aborted_errors++;
+		chan->netdev->stats.tx_errors++;
+		chan->netdev->stats.tx_aborted_errors++;
 	}
 	cosa_kick(chan->cosa);
 	if (chan->tx_skb) {
@@ -719,13 +696,13 @@ static void cosa_sppp_timeout(struct net_device *dev)
 	netif_wake_queue(dev);
 }
 
-static int cosa_sppp_close(struct net_device *d)
+static int cosa_net_close(struct net_device *dev)
 {
-	struct channel_data *chan = d->ml_priv;
+	struct channel_data *chan = dev_to_chan(dev);
 	unsigned long flags;
 
-	netif_stop_queue(d);
-	sppp_close(d);
+	netif_stop_queue(dev);
+	hdlc_close(dev);
 	cosa_disable_rx(chan);
 	spin_lock_irqsave(&chan->cosa->lock, flags);
 	if (chan->rx_skb) {
@@ -736,13 +713,13 @@ static int cosa_sppp_close(struct net_device *d)
 		kfree_skb(chan->tx_skb);
 		chan->tx_skb = NULL;
 	}
-	chan->usage=0;
+	chan->usage = 0;
 	chan->cosa->usage--;
 	spin_unlock_irqrestore(&chan->cosa->lock, flags);
 	return 0;
 }
 
-static char *sppp_setup_rx(struct channel_data *chan, int size)
+static char *cosa_net_setup_rx(struct channel_data *chan, int size)
 {
 	/*
 	 * We can safely fall back to non-dma-able memory, because we have
@@ -754,66 +731,53 @@ static char *sppp_setup_rx(struct channel_data *chan, int size)
 	if (chan->rx_skb == NULL) {
 		printk(KERN_NOTICE "%s: Memory squeeze, dropping packet\n",
 			chan->name);
-		chan->stats.rx_dropped++;
+		chan->netdev->stats.rx_dropped++;
 		return NULL;
 	}
-	chan->pppdev.dev->trans_start = jiffies;
+	chan->netdev->trans_start = jiffies;
 	return skb_put(chan->rx_skb, size);
 }
 
-static int sppp_rx_done(struct channel_data *chan)
+static int cosa_net_rx_done(struct channel_data *chan)
 {
 	if (!chan->rx_skb) {
 		printk(KERN_WARNING "%s: rx_done with empty skb!\n",
 			chan->name);
-		chan->stats.rx_errors++;
-		chan->stats.rx_frame_errors++;
+		chan->netdev->stats.rx_errors++;
+		chan->netdev->stats.rx_frame_errors++;
 		return 0;
 	}
-	chan->rx_skb->protocol = htons(ETH_P_WAN_PPP);
-	chan->rx_skb->dev = chan->pppdev.dev;
+	chan->rx_skb->protocol = hdlc_type_trans(chan->rx_skb, chan->netdev);
+	chan->rx_skb->dev = chan->netdev;
 	skb_reset_mac_header(chan->rx_skb);
-	chan->stats.rx_packets++;
-	chan->stats.rx_bytes += chan->cosa->rxsize;
+	chan->netdev->stats.rx_packets++;
+	chan->netdev->stats.rx_bytes += chan->cosa->rxsize;
 	netif_rx(chan->rx_skb);
 	chan->rx_skb = NULL;
-	chan->pppdev.dev->last_rx = jiffies;
+	chan->netdev->last_rx = jiffies;
 	return 0;
 }
 
 /* ARGSUSED */
-static int sppp_tx_done(struct channel_data *chan, int size)
+static int cosa_net_tx_done(struct channel_data *chan, int size)
 {
 	if (!chan->tx_skb) {
 		printk(KERN_WARNING "%s: tx_done with empty skb!\n",
 			chan->name);
-		chan->stats.tx_errors++;
-		chan->stats.tx_aborted_errors++;
+		chan->netdev->stats.tx_errors++;
+		chan->netdev->stats.tx_aborted_errors++;
 		return 1;
 	}
 	dev_kfree_skb_irq(chan->tx_skb);
 	chan->tx_skb = NULL;
-	chan->stats.tx_packets++;
-	chan->stats.tx_bytes += size;
-	netif_wake_queue(chan->pppdev.dev);
+	chan->netdev->stats.tx_packets++;
+	chan->netdev->stats.tx_bytes += size;
+	netif_wake_queue(chan->netdev);
 	return 1;
 }
 
-static struct net_device_stats *cosa_net_stats(struct net_device *dev)
-{
-	struct channel_data *chan = dev->ml_priv;
-	return &chan->stats;
-}
-
-
 /*---------- Character device ---------- */
 
-static void chardev_channel_init(struct channel_data *chan)
-{
-	mutex_init(&chan->rlock);
-	init_MUTEX(&chan->wsem);
-}
-
 static ssize_t cosa_read(struct file *file,
 	char __user *buf, size_t count, loff_t *ppos)
 {
@@ -1223,16 +1187,15 @@ static int cosa_ioctl_common(struct cosa_data *cosa,
 	return -ENOIOCTLCMD;
 }
 
-static int cosa_sppp_ioctl(struct net_device *dev, struct ifreq *ifr,
-	int cmd)
+static int cosa_net_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
 	int rv;
-	struct channel_data *chan = dev->ml_priv;
-	rv = cosa_ioctl_common(chan->cosa, chan, cmd, (unsigned long)ifr->ifr_data);
-	if (rv == -ENOIOCTLCMD) {
-		return sppp_do_ioctl(dev, ifr, cmd);
-	}
-	return rv;
+	struct channel_data *chan = dev_to_chan(dev);
+	rv = cosa_ioctl_common(chan->cosa, chan, cmd,
+			       (unsigned long)ifr->ifr_data);
+	if (rv != -ENOIOCTLCMD)
+		return rv;
+	return hdlc_ioctl(dev, ifr, cmd);
 }
 
 static int cosa_chardev_ioctl(struct inode *inode, struct file *file,
diff --git a/drivers/net/wan/dscc4.c b/drivers/net/wan/dscc4.c
index 50ef5b4..f5d55ad 100644
--- a/drivers/net/wan/dscc4.c
+++ b/drivers/net/wan/dscc4.c
@@ -103,7 +103,6 @@
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/delay.h>
-#include <net/syncppp.h>
 #include <linux/hdlc.h>
 #include <linux/mutex.h>
 
diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index 754f008..9557ad0 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -47,10 +47,7 @@ MODULE_LICENSE("GPL");
 /*      Default parameters for the link
  */
 #define FST_TX_QUEUE_LEN        100	/* At 8Mbps a longer queue length is
-					 * useful, the syncppp module forces
-					 * this down assuming a slower line I
-					 * guess.
-					 */
+					 * useful */
 #define FST_TXQ_DEPTH           16	/* This one is for the buffering
 					 * of frames on the way down to the card
 					 * so that we can keep the card busy
diff --git a/drivers/net/wan/farsync.h b/drivers/net/wan/farsync.h
index d871daf..6b27e7c 100644
--- a/drivers/net/wan/farsync.h
+++ b/drivers/net/wan/farsync.h
@@ -54,9 +54,6 @@
 
 
 /*      Ioctl call command values
- *
- *      The first three private ioctls are used by the sync-PPP module,
- *      allowing a little room for expansion we start our numbering at 10.
  */
 #define FSTWRITE        (SIOCDEVPRIVATE+10)
 #define FSTCPURESET     (SIOCDEVPRIVATE+11)
@@ -202,9 +199,6 @@ struct fstioc_info {
 #define J1              7
 
 /* "proto" */
-#define FST_HDLC        1               /* Cisco compatible HDLC */
-#define FST_PPP         2               /* Sync PPP */
-#define FST_MONITOR     3               /* Monitor only (raw packet reception) */
 #define FST_RAW         4               /* Two way raw packets */
 #define FST_GEN_HDLC    5               /* Using "Generic HDLC" module */
 
diff --git a/drivers/net/wan/hdlc.c b/drivers/net/wan/hdlc.c
index e3a5364..1f2a140 100644
--- a/drivers/net/wan/hdlc.c
+++ b/drivers/net/wan/hdlc.c
@@ -22,20 +22,19 @@
  * - proto->start() and stop() are called with spin_lock_irq held.
  */
 
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/poll.h>
 #include <linux/errno.h>
+#include <linux/hdlc.h>
 #include <linux/if_arp.h>
+#include <linux/inetdevice.h>
 #include <linux/init.h>
-#include <linux/skbuff.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/notifier.h>
 #include <linux/pkt_sched.h>
-#include <linux/inetdevice.h>
-#include <linux/lapb.h>
+#include <linux/poll.h>
 #include <linux/rtnetlink.h>
-#include <linux/notifier.h>
-#include <linux/hdlc.h>
+#include <linux/skbuff.h>
+#include <linux/slab.h>
 #include <net/net_namespace.h>
 
 
@@ -109,7 +108,7 @@ static int hdlc_device_event(struct notifier_block *this, unsigned long event,
 
 	if (dev->get_stats != hdlc_get_stats)
 		return NOTIFY_DONE; /* not an HDLC device */
- 
+
 	if (event != NETDEV_CHANGE)
 		return NOTIFY_DONE; /* Only interrested in carrier changes */
 
@@ -357,7 +356,7 @@ static struct packet_type hdlc_packet_type = {
 
 
 static struct notifier_block hdlc_notifier = {
-        .notifier_call = hdlc_device_event,
+	.notifier_call = hdlc_device_event,
 };
 
 
@@ -367,8 +366,8 @@ static int __init hdlc_module_init(void)
 
 	printk(KERN_INFO "%s\n", version);
 	if ((result = register_netdevice_notifier(&hdlc_notifier)) != 0)
-                return result;
-        dev_add_pack(&hdlc_packet_type);
+		return result;
+	dev_add_pack(&hdlc_packet_type);
 	return 0;
 }
 
diff --git a/drivers/net/wan/hdlc_cisco.c b/drivers/net/wan/hdlc_cisco.c
index 849819c..44e64b1 100644
--- a/drivers/net/wan/hdlc_cisco.c
+++ b/drivers/net/wan/hdlc_cisco.c
@@ -9,19 +9,18 @@
  * as published by the Free Software Foundation.
  */
 
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/poll.h>
 #include <linux/errno.h>
+#include <linux/hdlc.h>
 #include <linux/if_arp.h>
+#include <linux/inetdevice.h>
 #include <linux/init.h>
-#include <linux/skbuff.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/pkt_sched.h>
-#include <linux/inetdevice.h>
-#include <linux/lapb.h>
+#include <linux/poll.h>
 #include <linux/rtnetlink.h>
-#include <linux/hdlc.h>
+#include <linux/skbuff.h>
+#include <linux/slab.h>
 
 #undef DEBUG_HARD_HEADER
 
@@ -68,9 +67,9 @@ struct cisco_state {
 static int cisco_ioctl(struct net_device *dev, struct ifreq *ifr);
 
 
-static inline struct cisco_state * state(hdlc_device *hdlc)
+static inline struct cisco_state* state(hdlc_device *hdlc)
 {
-	return(struct cisco_state *)(hdlc->state);
+	return (struct cisco_state *)hdlc->state;
 }
 
 
@@ -172,7 +171,7 @@ static int cisco_rx(struct sk_buff *skb)
 	    data->address != CISCO_UNICAST)
 		goto rx_error;
 
-	switch(ntohs(data->protocol)) {
+	switch (ntohs(data->protocol)) {
 	case CISCO_SYS_INFO:
 		/* Packet is not needed, drop it. */
 		dev_kfree_skb_any(skb);
@@ -336,7 +335,7 @@ static struct hdlc_proto proto = {
 static const struct header_ops cisco_header_ops = {
 	.create = cisco_hard_header,
 };
- 
+
 static int cisco_ioctl(struct net_device *dev, struct ifreq *ifr)
 {
 	cisco_proto __user *cisco_s = ifr->ifr_settings.ifs_ifsu.cisco;
@@ -359,10 +358,10 @@ static int cisco_ioctl(struct net_device *dev, struct ifreq *ifr)
 		return 0;
 
 	case IF_PROTO_CISCO:
-		if(!capable(CAP_NET_ADMIN))
+		if (!capable(CAP_NET_ADMIN))
 			return -EPERM;
 
-		if(dev->flags & IFF_UP)
+		if (dev->flags & IFF_UP)
 			return -EBUSY;
 
 		if (copy_from_user(&new_settings, cisco_s, size))
@@ -372,7 +371,7 @@ static int cisco_ioctl(struct net_device *dev, struct ifreq *ifr)
 		    new_settings.timeout < 2)
 			return -EINVAL;
 
-		result=hdlc->attach(dev, ENCODING_NRZ,PARITY_CRC16_PR1_CCITT);
+		result = hdlc->attach(dev, ENCODING_NRZ,PARITY_CRC16_PR1_CCITT);
 		if (result)
 			return result;
 
diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 62e93da..d3d5055 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -33,20 +33,19 @@
 
 */
 
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/poll.h>
 #include <linux/errno.h>
+#include <linux/etherdevice.h>
+#include <linux/hdlc.h>
 #include <linux/if_arp.h>
+#include <linux/inetdevice.h>
 #include <linux/init.h>
-#include <linux/skbuff.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/pkt_sched.h>
-#include <linux/inetdevice.h>
-#include <linux/lapb.h>
+#include <linux/poll.h>
 #include <linux/rtnetlink.h>
-#include <linux/etherdevice.h>
-#include <linux/hdlc.h>
+#include <linux/skbuff.h>
+#include <linux/slab.h>
 
 #undef DEBUG_PKT
 #undef DEBUG_ECN
@@ -96,7 +95,7 @@ typedef struct {
 	unsigned ea1:	1;
 	unsigned cr:	1;
 	unsigned dlcih:	6;
-  
+
 	unsigned ea2:	1;
 	unsigned de:	1;
 	unsigned becn:	1;
diff --git a/drivers/net/wan/hdlc_ppp.c b/drivers/net/wan/hdlc_ppp.c
index 0030833..4efe9e6 100644
--- a/drivers/net/wan/hdlc_ppp.c
+++ b/drivers/net/wan/hdlc_ppp.c
@@ -9,19 +9,18 @@
  * as published by the Free Software Foundation.
  */
 
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/poll.h>
 #include <linux/errno.h>
+#include <linux/hdlc.h>
 #include <linux/if_arp.h>
+#include <linux/inetdevice.h>
 #include <linux/init.h>
-#include <linux/skbuff.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/pkt_sched.h>
-#include <linux/inetdevice.h>
-#include <linux/lapb.h>
+#include <linux/poll.h>
 #include <linux/rtnetlink.h>
-#include <linux/hdlc.h>
+#include <linux/skbuff.h>
+#include <linux/slab.h>
 #include <net/syncppp.h>
 
 struct ppp_state {
diff --git a/drivers/net/wan/hdlc_raw.c b/drivers/net/wan/hdlc_raw.c
index bbbb819..8612311 100644
--- a/drivers/net/wan/hdlc_raw.c
+++ b/drivers/net/wan/hdlc_raw.c
@@ -9,19 +9,18 @@
  * as published by the Free Software Foundation.
  */
 
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/poll.h>
 #include <linux/errno.h>
+#include <linux/hdlc.h>
 #include <linux/if_arp.h>
+#include <linux/inetdevice.h>
 #include <linux/init.h>
-#include <linux/skbuff.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/pkt_sched.h>
-#include <linux/inetdevice.h>
-#include <linux/lapb.h>
+#include <linux/poll.h>
 #include <linux/rtnetlink.h>
-#include <linux/hdlc.h>
+#include <linux/skbuff.h>
+#include <linux/slab.h>
 
 
 static int raw_ioctl(struct net_device *dev, struct ifreq *ifr);
diff --git a/drivers/net/wan/hdlc_raw_eth.c b/drivers/net/wan/hdlc_raw_eth.c
index 26dee60..a13fc32 100644
--- a/drivers/net/wan/hdlc_raw_eth.c
+++ b/drivers/net/wan/hdlc_raw_eth.c
@@ -9,20 +9,19 @@
  * as published by the Free Software Foundation.
  */
 
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/poll.h>
 #include <linux/errno.h>
+#include <linux/etherdevice.h>
+#include <linux/hdlc.h>
 #include <linux/if_arp.h>
+#include <linux/inetdevice.h>
 #include <linux/init.h>
-#include <linux/skbuff.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/pkt_sched.h>
-#include <linux/inetdevice.h>
-#include <linux/lapb.h>
+#include <linux/poll.h>
 #include <linux/rtnetlink.h>
-#include <linux/etherdevice.h>
-#include <linux/hdlc.h>
+#include <linux/skbuff.h>
+#include <linux/slab.h>
 
 static int raw_eth_ioctl(struct net_device *dev, struct ifreq *ifr);
 
diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
index e808720..8b7e5d2 100644
--- a/drivers/net/wan/hdlc_x25.c
+++ b/drivers/net/wan/hdlc_x25.c
@@ -9,20 +9,19 @@
  * as published by the Free Software Foundation.
  */
 
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/poll.h>
 #include <linux/errno.h>
+#include <linux/hdlc.h>
 #include <linux/if_arp.h>
-#include <linux/init.h>
-#include <linux/skbuff.h>
-#include <linux/pkt_sched.h>
 #include <linux/inetdevice.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
 #include <linux/lapb.h>
+#include <linux/module.h>
+#include <linux/pkt_sched.h>
+#include <linux/poll.h>
 #include <linux/rtnetlink.h>
-#include <linux/hdlc.h>
-
+#include <linux/skbuff.h>
+#include <linux/slab.h>
 #include <net/x25device.h>
 
 static int x25_ioctl(struct net_device *dev, struct ifreq *ifr);
diff --git a/drivers/net/wan/hostess_sv11.c b/drivers/net/wan/hostess_sv11.c
index f3065d3..e299313 100644
--- a/drivers/net/wan/hostess_sv11.c
+++ b/drivers/net/wan/hostess_sv11.c
@@ -16,6 +16,8 @@
  *	touching control registers.
  *
  *	Port B isnt wired (why - beats me)
+ *
+ *	Generic HDLC port Copyright (C) 2008 Krzysztof Halasa <khc@pm.waw.pl>
  */
 
 #include <linux/module.h>
@@ -26,6 +28,7 @@
 #include <linux/netdevice.h>
 #include <linux/if_arp.h>
 #include <linux/delay.h>
+#include <linux/hdlc.h>
 #include <linux/ioport.h>
 #include <net/arp.h>
 
@@ -33,34 +36,31 @@
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/byteorder.h>
-#include <net/syncppp.h>
 #include "z85230.h"
 
 static int dma;
 
-struct sv11_device
-{
-	void *if_ptr;	/* General purpose pointer (used by SPPP) */
-	struct z8530_dev sync;
-	struct ppp_device netdev;
-};
-
 /*
  *	Network driver support routines
  */
 
+static inline struct z8530_dev* dev_to_sv(struct net_device *dev)
+{
+	return (struct z8530_dev *)dev_to_hdlc(dev)->priv;
+}
+
 /*
- *	Frame receive. Simple for our card as we do sync ppp and there
+ *	Frame receive. Simple for our card as we do HDLC and there
  *	is no funny garbage involved
  */
- 
+
 static void hostess_input(struct z8530_channel *c, struct sk_buff *skb)
 {
 	/* Drop the CRC - it's not a good idea to try and negotiate it ;) */
-	skb_trim(skb, skb->len-2);
-	skb->protocol=__constant_htons(ETH_P_WAN_PPP);
+	skb_trim(skb, skb->len - 2);
+	skb->protocol = hdlc_type_trans(skb, c->netdevice);
 	skb_reset_mac_header(skb);
-	skb->dev=c->netdevice;
+	skb->dev = c->netdevice;
 	/*
 	 *	Send it to the PPP layer. We don't have time to process
 	 *	it right now.
@@ -68,56 +68,51 @@ static void hostess_input(struct z8530_channel *c, struct sk_buff *skb)
 	netif_rx(skb);
 	c->netdevice->last_rx = jiffies;
 }
- 
+
 /*
  *	We've been placed in the UP state
- */ 
- 
+ */
+
 static int hostess_open(struct net_device *d)
 {
-	struct sv11_device *sv11=d->ml_priv;
+	struct z8530_dev *sv11 = dev_to_sv(d);
 	int err = -1;
-	
+
 	/*
 	 *	Link layer up
 	 */
-	switch(dma)
-	{
+	switch (dma) {
 		case 0:
-			err=z8530_sync_open(d, &sv11->sync.chanA);
+			err = z8530_sync_open(d, &sv11->chanA);
 			break;
 		case 1:
-			err=z8530_sync_dma_open(d, &sv11->sync.chanA);
+			err = z8530_sync_dma_open(d, &sv11->chanA);
 			break;
 		case 2:
-			err=z8530_sync_txdma_open(d, &sv11->sync.chanA);
+			err = z8530_sync_txdma_open(d, &sv11->chanA);
 			break;
 	}
-	
-	if(err)
+
+	if (err)
 		return err;
-	/*
-	 *	Begin PPP
-	 */
-	err=sppp_open(d);
-	if(err)
-	{
-		switch(dma)
-		{
+
+	err = hdlc_open(d);
+	if (err) {
+		switch (dma) {
 			case 0:
-				z8530_sync_close(d, &sv11->sync.chanA);
+				z8530_sync_close(d, &sv11->chanA);
 				break;
 			case 1:
-				z8530_sync_dma_close(d, &sv11->sync.chanA);
+				z8530_sync_dma_close(d, &sv11->chanA);
 				break;
 			case 2:
-				z8530_sync_txdma_close(d, &sv11->sync.chanA);
+				z8530_sync_txdma_close(d, &sv11->chanA);
 				break;
-		}				
+		}
 		return err;
 	}
-	sv11->sync.chanA.rx_function=hostess_input;
-	
+	sv11->chanA.rx_function = hostess_input;
+
 	/*
 	 *	Go go go
 	 */
@@ -128,30 +123,24 @@ static int hostess_open(struct net_device *d)
 
 static int hostess_close(struct net_device *d)
 {
-	struct sv11_device *sv11=d->ml_priv;
+	struct z8530_dev *sv11 = dev_to_sv(d);
 	/*
 	 *	Discard new frames
 	 */
-	sv11->sync.chanA.rx_function=z8530_null_rx;
-	/*
-	 *	PPP off
-	 */
-	sppp_close(d);
-	/*
-	 *	Link layer down
-	 */
+	sv11->chanA.rx_function = z8530_null_rx;
+
+	hdlc_close(d);
 	netif_stop_queue(d);
-		
-	switch(dma)
-	{
+
+	switch (dma) {
 		case 0:
-			z8530_sync_close(d, &sv11->sync.chanA);
+			z8530_sync_close(d, &sv11->chanA);
 			break;
 		case 1:
-			z8530_sync_dma_close(d, &sv11->sync.chanA);
+			z8530_sync_dma_close(d, &sv11->chanA);
 			break;
 		case 2:
-			z8530_sync_txdma_close(d, &sv11->sync.chanA);
+			z8530_sync_txdma_close(d, &sv11->chanA);
 			break;
 	}
 	return 0;
@@ -159,232 +148,174 @@ static int hostess_close(struct net_device *d)
 
 static int hostess_ioctl(struct net_device *d, struct ifreq *ifr, int cmd)
 {
-	/* struct sv11_device *sv11=d->ml_priv;
-	   z8530_ioctl(d,&sv11->sync.chanA,ifr,cmd) */
-	return sppp_do_ioctl(d, ifr,cmd);
-}
-
-static struct net_device_stats *hostess_get_stats(struct net_device *d)
-{
-	struct sv11_device *sv11=d->ml_priv;
-	if(sv11)
-		return z8530_get_stats(&sv11->sync.chanA);
-	else
-		return NULL;
+	/* struct z8530_dev *sv11=dev_to_sv(d);
+	   z8530_ioctl(d,&sv11->chanA,ifr,cmd) */
+	return hdlc_ioctl(d, ifr, cmd);
 }
 
 /*
- *	Passed PPP frames, fire them downwind.
+ *	Passed network frames, fire them downwind.
  */
- 
+
 static int hostess_queue_xmit(struct sk_buff *skb, struct net_device *d)
 {
-	struct sv11_device *sv11=d->ml_priv;
-	return z8530_queue_xmit(&sv11->sync.chanA, skb);
+	return z8530_queue_xmit(&dev_to_sv(d)->chanA, skb);
 }
 
-static int hostess_neigh_setup(struct neighbour *n)
+static int hostess_attach(struct net_device *dev, unsigned short encoding,
+			  unsigned short parity)
 {
-	if (n->nud_state == NUD_NONE) {
-		n->ops = &arp_broken_ops;
-		n->output = n->ops->output;
-	}
-	return 0;
-}
-
-static int hostess_neigh_setup_dev(struct net_device *dev, struct neigh_parms *p)
-{
-	if (p->tbl->family == AF_INET) {
-		p->neigh_setup = hostess_neigh_setup;
-		p->ucast_probes = 0;
-		p->mcast_probes = 0;
-	}
-	return 0;
-}
-
-static void sv11_setup(struct net_device *dev)
-{	
-	dev->open = hostess_open;
-	dev->stop = hostess_close;
-	dev->hard_start_xmit = hostess_queue_xmit;
-	dev->get_stats = hostess_get_stats;
-	dev->do_ioctl = hostess_ioctl;
-	dev->neigh_setup = hostess_neigh_setup_dev;
+	if (encoding == ENCODING_NRZ && parity == PARITY_CRC16_PR1_CCITT)
+		return 0;
+	return -EINVAL;
 }
 
 /*
  *	Description block for a Comtrol Hostess SV11 card
  */
- 
-static struct sv11_device *sv11_init(int iobase, int irq)
+
+static struct z8530_dev *sv11_init(int iobase, int irq)
 {
-	struct z8530_dev *dev;
-	struct sv11_device *sv;
-	
+	struct z8530_dev *sv;
+	struct net_device *netdev;
 	/*
 	 *	Get the needed I/O space
 	 */
-	 
-	if(!request_region(iobase, 8, "Comtrol SV11"))
-	{	
-		printk(KERN_WARNING "hostess: I/O 0x%X already in use.\n", iobase);
+
+	if (!request_region(iobase, 8, "Comtrol SV11")) {
+		printk(KERN_WARNING "hostess: I/O 0x%X already in use.\n",
+		       iobase);
 		return NULL;
 	}
-	
-	sv = kzalloc(sizeof(struct sv11_device), GFP_KERNEL);
-	if(!sv)
-		goto fail3;
-			
-	sv->if_ptr=&sv->netdev;
-	
-	sv->netdev.dev = alloc_netdev(0, "hdlc%d", sv11_setup);
-	if(!sv->netdev.dev)
-		goto fail2;
-
-	dev=&sv->sync;
-	
+
+	sv = kzalloc(sizeof(struct z8530_dev), GFP_KERNEL);
+	if (!sv)
+		goto err_kzalloc;
+
 	/*
 	 *	Stuff in the I/O addressing
 	 */
-	 
-	dev->active = 0;
-	
-	dev->chanA.ctrlio=iobase+1;
-	dev->chanA.dataio=iobase+3;
-	dev->chanB.ctrlio=-1;
-	dev->chanB.dataio=-1;
-	dev->chanA.irqs=&z8530_nop;
-	dev->chanB.irqs=&z8530_nop;
-	
-	outb(0, iobase+4);		/* DMA off */
-	
+
+	sv->active = 0;
+
+	sv->chanA.ctrlio = iobase + 1;
+	sv->chanA.dataio = iobase + 3;
+	sv->chanB.ctrlio = -1;
+	sv->chanB.dataio = -1;
+	sv->chanA.irqs = &z8530_nop;
+	sv->chanB.irqs = &z8530_nop;
+
+	outb(0, iobase + 4);		/* DMA off */
+
 	/* We want a fast IRQ for this device. Actually we'd like an even faster
 	   IRQ ;) - This is one driver RtLinux is made for */
-	   
-	if(request_irq(irq, &z8530_interrupt, IRQF_DISABLED, "Hostess SV11", dev)<0)
-	{
+
+	if (request_irq(irq, &z8530_interrupt, IRQF_DISABLED,
+			"Hostess SV11", sv) < 0) {
 		printk(KERN_WARNING "hostess: IRQ %d already in use.\n", irq);
-		goto fail1;
+		goto err_irq;
 	}
-	
-	dev->irq=irq;
-	dev->chanA.private=sv;
-	dev->chanA.netdevice=sv->netdev.dev;
-	dev->chanA.dev=dev;
-	dev->chanB.dev=dev;
-	
-	if(dma)
-	{
+
+	sv->irq = irq;
+	sv->chanA.private = sv;
+	sv->chanA.dev = sv;
+	sv->chanB.dev = sv;
+
+	if (dma) {
 		/*
 		 *	You can have DMA off or 1 and 3 thats the lot
 		 *	on the Comtrol.
 		 */
-		dev->chanA.txdma=3;
-		dev->chanA.rxdma=1;
-		outb(0x03|0x08, iobase+4);		/* DMA on */
-		if(request_dma(dev->chanA.txdma, "Hostess SV/11 (TX)")!=0)
-			goto fail;
-			
-		if(dma==1)
-		{
-			if(request_dma(dev->chanA.rxdma, "Hostess SV/11 (RX)")!=0)
-				goto dmafail;
-		}
+		sv->chanA.txdma = 3;
+		sv->chanA.rxdma = 1;
+		outb(0x03 | 0x08, iobase + 4);		/* DMA on */
+		if (request_dma(sv->chanA.txdma, "Hostess SV/11 (TX)"))
+			goto err_txdma;
+
+		if (dma == 1)
+			if (request_dma(sv->chanA.rxdma, "Hostess SV/11 (RX)"))
+				goto err_rxdma;
 	}
 
 	/* Kill our private IRQ line the hostess can end up chattering
 	   until the configuration is set */
 	disable_irq(irq);
-		
+
 	/*
 	 *	Begin normal initialise
 	 */
-	 
-	if(z8530_init(dev)!=0)
-	{
+
+	if (z8530_init(sv)) {
 		printk(KERN_ERR "Z8530 series device not found.\n");
 		enable_irq(irq);
-		goto dmafail2;
+		goto free_dma;
 	}
-	z8530_channel_load(&dev->chanB, z8530_dead_port);
-	if(dev->type==Z85C30)
-		z8530_channel_load(&dev->chanA, z8530_hdlc_kilostream);
+	z8530_channel_load(&sv->chanB, z8530_dead_port);
+	if (sv->type == Z85C30)
+		z8530_channel_load(&sv->chanA, z8530_hdlc_kilostream);
 	else
-		z8530_channel_load(&dev->chanA, z8530_hdlc_kilostream_85230);
-	
+		z8530_channel_load(&sv->chanA, z8530_hdlc_kilostream_85230);
+
 	enable_irq(irq);
-	
 
 	/*
 	 *	Now we can take the IRQ
 	 */
-	if(dev_alloc_name(dev->chanA.netdevice,"hdlc%d")>=0)
-	{
-		struct net_device *d=dev->chanA.netdevice;
 
-		/* 
-		 *	Initialise the PPP components
-		 */
-		d->ml_priv = sv;
-		sppp_attach(&sv->netdev);
-		
-		/*
-		 *	Local fields
-		 */	
-		
-		d->base_addr = iobase;
-		d->irq = irq;
-		
-		if(register_netdev(d))
-		{
-			printk(KERN_ERR "%s: unable to register device.\n",
-				d->name);
-			sppp_detach(d);
-			goto dmafail2;
-		}
+	sv->chanA.netdevice = netdev = alloc_hdlcdev(sv);
+	if (!netdev)
+		goto free_dma;
 
-		z8530_describe(dev, "I/O", iobase);
-		dev->active=1;
-		return sv;	
+	dev_to_hdlc(netdev)->attach = hostess_attach;
+	dev_to_hdlc(netdev)->xmit = hostess_queue_xmit;
+	netdev->open = hostess_open;
+	netdev->stop = hostess_close;
+	netdev->do_ioctl = hostess_ioctl;
+	netdev->base_addr = iobase;
+	netdev->irq = irq;
+
+	if (register_hdlc_device(netdev)) {
+		printk(KERN_ERR "hostess: unable to register HDLC device.\n");
+		free_netdev(netdev);
+		goto free_dma;
 	}
-dmafail2:
-	if(dma==1)
-		free_dma(dev->chanA.rxdma);
-dmafail:
-	if(dma)
-		free_dma(dev->chanA.txdma);
-fail:
-	free_irq(irq, dev);
-fail1:
-	free_netdev(sv->netdev.dev);
-fail2:
+
+	z8530_describe(sv, "I/O", iobase);
+	sv->active = 1;
+	return sv;
+
+free_dma:
+	if (dma == 1)
+		free_dma(sv->chanA.rxdma);
+err_rxdma:
+	if (dma)
+		free_dma(sv->chanA.txdma);
+err_txdma:
+	free_irq(irq, sv);
+err_irq:
 	kfree(sv);
-fail3:
-	release_region(iobase,8);
+err_kzalloc:
+	release_region(iobase, 8);
 	return NULL;
 }
 
-static void sv11_shutdown(struct sv11_device *dev)
+static void sv11_shutdown(struct z8530_dev *dev)
 {
-	sppp_detach(dev->netdev.dev);
-	unregister_netdev(dev->netdev.dev);
-	z8530_shutdown(&dev->sync);
-	free_irq(dev->sync.irq, dev);
-	if(dma)
-	{
-		if(dma==1)
-			free_dma(dev->sync.chanA.rxdma);
-		free_dma(dev->sync.chanA.txdma);
+	unregister_hdlc_device(dev->chanA.netdevice);
+	z8530_shutdown(dev);
+	free_irq(dev->irq, dev);
+	if (dma) {
+		if (dma == 1)
+			free_dma(dev->chanA.rxdma);
+		free_dma(dev->chanA.txdma);
 	}
-	release_region(dev->sync.chanA.ctrlio-1, 8);
-	free_netdev(dev->netdev.dev);
+	release_region(dev->chanA.ctrlio - 1, 8);
+	free_netdev(dev->chanA.netdevice);
 	kfree(dev);
 }
 
-#ifdef MODULE
-
-static int io=0x200;
-static int irq=9;
+static int io = 0x200;
+static int irq = 9;
 
 module_param(io, int, 0);
 MODULE_PARM_DESC(io, "The I/O base of the Comtrol Hostess SV11 card");
@@ -397,22 +328,17 @@ MODULE_AUTHOR("Alan Cox");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Modular driver for the Comtrol Hostess SV11");
 
-static struct sv11_device *sv11_unit;
+static struct z8530_dev *sv11_unit;
 
 int init_module(void)
 {
-	printk(KERN_INFO "SV-11 Z85230 Synchronous Driver v 0.03.\n");
-	printk(KERN_INFO "(c) Copyright 2001, Red Hat Inc.\n");	
-	if((sv11_unit=sv11_init(io,irq))==NULL)
+	if ((sv11_unit = sv11_init(io, irq)) == NULL)
 		return -ENODEV;
 	return 0;
 }
 
 void cleanup_module(void)
 {
-	if(sv11_unit)
+	if (sv11_unit)
 		sv11_shutdown(sv11_unit);
 }
-
-#endif
-
diff --git a/drivers/net/wan/lmc/lmc.h b/drivers/net/wan/lmc/lmc.h
index 882e58c..4ced7ac 100644
--- a/drivers/net/wan/lmc/lmc.h
+++ b/drivers/net/wan/lmc/lmc.h
@@ -11,12 +11,12 @@ unsigned lmc_mii_readreg(lmc_softc_t * const sc, unsigned
       			  devaddr, unsigned regno);
 void lmc_mii_writereg(lmc_softc_t * const sc, unsigned devaddr,
 			       unsigned regno, unsigned data);
-void lmc_led_on(lmc_softc_t * const, u_int32_t);
-void lmc_led_off(lmc_softc_t * const, u_int32_t);
+void lmc_led_on(lmc_softc_t * const, u32);
+void lmc_led_off(lmc_softc_t * const, u32);
 unsigned lmc_mii_readreg(lmc_softc_t * const, unsigned, unsigned);
 void lmc_mii_writereg(lmc_softc_t * const, unsigned, unsigned, unsigned);
-void lmc_gpio_mkinput(lmc_softc_t * const sc, u_int32_t bits);
-void lmc_gpio_mkoutput(lmc_softc_t * const sc, u_int32_t bits);
+void lmc_gpio_mkinput(lmc_softc_t * const sc, u32 bits);
+void lmc_gpio_mkoutput(lmc_softc_t * const sc, u32 bits);
 
 int lmc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
 
@@ -26,8 +26,7 @@ extern lmc_media_t lmc_t1_media;
 extern lmc_media_t lmc_hssi_media;
 
 #ifdef _DBG_EVENTLOG
-static void lmcEventLog( u_int32_t EventNum, u_int32_t arg2, u_int32_t arg3 );
+static void lmcEventLog(u32 EventNum, u32 arg2, u32 arg3);
 #endif
 
 #endif
-
diff --git a/drivers/net/wan/lmc/lmc_debug.c b/drivers/net/wan/lmc/lmc_debug.c
index 3b94352..15049d7 100644
--- a/drivers/net/wan/lmc/lmc_debug.c
+++ b/drivers/net/wan/lmc/lmc_debug.c
@@ -1,4 +1,3 @@
-
 #include <linux/types.h>
 #include <linux/netdevice.h>
 #include <linux/interrupt.h>
@@ -48,10 +47,10 @@ void lmcConsoleLog(char *type, unsigned char *ucData, int iLen)
 #endif
 
 #ifdef DEBUG
-u_int32_t lmcEventLogIndex = 0;
-u_int32_t lmcEventLogBuf[LMC_EVENTLOGSIZE * LMC_EVENTLOGARGS];
+u32 lmcEventLogIndex;
+u32 lmcEventLogBuf[LMC_EVENTLOGSIZE * LMC_EVENTLOGARGS];
 
-void lmcEventLog (u_int32_t EventNum, u_int32_t arg2, u_int32_t arg3)
+void lmcEventLog(u32 EventNum, u32 arg2, u32 arg3)
 {
   lmcEventLogBuf[lmcEventLogIndex++] = EventNum;
   lmcEventLogBuf[lmcEventLogIndex++] = arg2;
diff --git a/drivers/net/wan/lmc/lmc_debug.h b/drivers/net/wan/lmc/lmc_debug.h
index cf35638..2d46f12 100644
--- a/drivers/net/wan/lmc/lmc_debug.h
+++ b/drivers/net/wan/lmc/lmc_debug.h
@@ -38,15 +38,15 @@
 
 
 #ifdef DEBUG
-extern u_int32_t lmcEventLogIndex;
-extern u_int32_t lmcEventLogBuf[LMC_EVENTLOGSIZE * LMC_EVENTLOGARGS];
+extern u32 lmcEventLogIndex;
+extern u32 lmcEventLogBuf[LMC_EVENTLOGSIZE * LMC_EVENTLOGARGS];
 #define LMC_EVENT_LOG(x, y, z) lmcEventLog((x), (y), (z))
 #else
 #define LMC_EVENT_LOG(x,y,z)
 #endif /* end ifdef _DBG_EVENTLOG */
 
 void lmcConsoleLog(char *type, unsigned char *ucData, int iLen);
-void lmcEventLog (u_int32_t EventNum, u_int32_t arg2, u_int32_t arg3);
+void lmcEventLog(u32 EventNum, u32 arg2, u32 arg3);
 void lmc_trace(struct net_device *dev, char *msg);
 
 #endif
diff --git a/drivers/net/wan/lmc/lmc_ioctl.h b/drivers/net/wan/lmc/lmc_ioctl.h
index 57dd861..72fb113 100644
--- a/drivers/net/wan/lmc/lmc_ioctl.h
+++ b/drivers/net/wan/lmc/lmc_ioctl.h
@@ -61,7 +61,7 @@
 /*
  * IFTYPE defines
  */
-#define LMC_PPP         1               /* use sppp interface */
+#define LMC_PPP         1               /* use generic HDLC interface */
 #define LMC_NET         2               /* use direct net interface */
 #define LMC_RAW         3               /* use direct net interface */
 
diff --git a/drivers/net/wan/lmc/lmc_main.c b/drivers/net/wan/lmc/lmc_main.c
index 62133ce..f80640f 100644
--- a/drivers/net/wan/lmc/lmc_main.c
+++ b/drivers/net/wan/lmc/lmc_main.c
@@ -1,6 +1,7 @@
  /*
   * Copyright (c) 1997-2000 LAN Media Corporation (LMC)
   * All rights reserved.  www.lanmedia.com
+  * Generic HDLC port Copyright (C) 2008 Krzysztof Halasa <khc@pm.waw.pl>
   *
   * This code is written by:
   * Andrew Stanley-Jones (asj@cban.com)
@@ -36,8 +37,6 @@
   *
   */
 
-/* $Id: lmc_main.c,v 1.36 2000/04/11 05:25:25 asj Exp $ */
-
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
@@ -49,6 +48,7 @@
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
+#include <linux/hdlc.h>
 #include <linux/init.h>
 #include <linux/in.h>
 #include <linux/if_arp.h>
@@ -57,9 +57,6 @@
 #include <linux/skbuff.h>
 #include <linux/inet.h>
 #include <linux/bitops.h>
-
-#include <net/syncppp.h>
-
 #include <asm/processor.h>             /* Processor type for cache alignment. */
 #include <asm/io.h>
 #include <asm/dma.h>
@@ -78,8 +75,6 @@
 #include "lmc_debug.h"
 #include "lmc_proto.h"
 
-static int lmc_first_load = 0;
-
 static int LMC_PKT_BUF_SZ = 1542;
 
 static struct pci_device_id lmc_pci_tbl[] = {
@@ -91,11 +86,10 @@ static struct pci_device_id lmc_pci_tbl[] = {
 };
 
 MODULE_DEVICE_TABLE(pci, lmc_pci_tbl);
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 
 
 static int lmc_start_xmit(struct sk_buff *skb, struct net_device *dev);
-static int lmc_start_xmit(struct sk_buff *skb, struct net_device *dev);
 static int lmc_rx (struct net_device *dev);
 static int lmc_open(struct net_device *dev);
 static int lmc_close(struct net_device *dev);
@@ -114,20 +108,14 @@ static void lmc_driver_timeout(struct net_device *dev);
  * linux reserves 16 device specific IOCTLs.  We call them
  * LMCIOC* to control various bits of our world.
  */
-int lmc_ioctl (struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
+int lmc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
 {
-    lmc_softc_t *sc;
+    lmc_softc_t *sc = dev_to_sc(dev);
     lmc_ctl_t ctl;
-    int ret;
-    u_int16_t regVal;
+    int ret = -EOPNOTSUPP;
+    u16 regVal;
     unsigned long flags;
 
-    struct sppp *sp;
-
-    ret = -EOPNOTSUPP;
-
-    sc = dev->priv;
-
     lmc_trace(dev, "lmc_ioctl in");
 
     /*
@@ -149,7 +137,6 @@ int lmc_ioctl (struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
         break;
 
     case LMCIOCSINFO: /*fold01*/
-        sp = &((struct ppp_device *) dev)->sppp;
         if (!capable(CAP_NET_ADMIN)) {
             ret = -EPERM;
             break;
@@ -175,25 +162,20 @@ int lmc_ioctl (struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
 		sc->TxDescriptControlInit &= ~LMC_TDES_ADD_CRC_DISABLE;
         }
 
-        if (ctl.keepalive_onoff == LMC_CTL_OFF)
-            sp->pp_flags &= ~PP_KEEPALIVE;	/* Turn off */
-        else
-            sp->pp_flags |= PP_KEEPALIVE;	/* Turn on */
-
         ret = 0;
         break;
 
     case LMCIOCIFTYPE: /*fold01*/
         {
-            u_int16_t	old_type = sc->if_type;
-            u_int16_t	new_type;
+	    u16 old_type = sc->if_type;
+	    u16	new_type;
 
 	    if (!capable(CAP_NET_ADMIN)) {
 		ret = -EPERM;
 		break;
 	    }
 
-	    if (copy_from_user(&new_type, ifr->ifr_data, sizeof(u_int16_t))) {
+	    if (copy_from_user(&new_type, ifr->ifr_data, sizeof(u16))) {
 		ret = -EFAULT;
 		break;
 	    }
@@ -206,15 +188,11 @@ int lmc_ioctl (struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
             }
             
             lmc_proto_close(sc);
-            lmc_proto_detach(sc);
 
             sc->if_type = new_type;
-//            lmc_proto_init(sc);
             lmc_proto_attach(sc);
-            lmc_proto_open(sc);
-
-	    ret = 0 ;
-	    break ;
+	    ret = lmc_proto_open(sc);
+	    break;
 	}
 
     case LMCIOCGETXINFO: /*fold01*/
@@ -241,51 +219,53 @@ int lmc_ioctl (struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
 
         break;
 
-    case LMCIOCGETLMCSTATS: /*fold01*/
-        if (sc->lmc_cardtype == LMC_CARDTYPE_T1){
-            lmc_mii_writereg (sc, 0, 17, T1FRAMER_FERR_LSB);
-            sc->stats.framingBitErrorCount +=
-                lmc_mii_readreg (sc, 0, 18) & 0xff;
-            lmc_mii_writereg (sc, 0, 17, T1FRAMER_FERR_MSB);
-            sc->stats.framingBitErrorCount +=
-                (lmc_mii_readreg (sc, 0, 18) & 0xff) << 8;
-            lmc_mii_writereg (sc, 0, 17, T1FRAMER_LCV_LSB);
-            sc->stats.lineCodeViolationCount +=
-                lmc_mii_readreg (sc, 0, 18) & 0xff;
-            lmc_mii_writereg (sc, 0, 17, T1FRAMER_LCV_MSB);
-            sc->stats.lineCodeViolationCount +=
-                (lmc_mii_readreg (sc, 0, 18) & 0xff) << 8;
-            lmc_mii_writereg (sc, 0, 17, T1FRAMER_AERR);
-            regVal = lmc_mii_readreg (sc, 0, 18) & 0xff;
-
-            sc->stats.lossOfFrameCount +=
-                (regVal & T1FRAMER_LOF_MASK) >> 4;
-            sc->stats.changeOfFrameAlignmentCount +=
-                (regVal & T1FRAMER_COFA_MASK) >> 2;
-            sc->stats.severelyErroredFrameCount +=
-                regVal & T1FRAMER_SEF_MASK;
-        }
-
-        if (copy_to_user(ifr->ifr_data, &sc->stats,
-                         sizeof (struct lmc_statistics)))
-		ret = -EFAULT;
-	else
-		ret = 0;
-        break;
+    case LMCIOCGETLMCSTATS:
+	    if (sc->lmc_cardtype == LMC_CARDTYPE_T1) {
+		    lmc_mii_writereg(sc, 0, 17, T1FRAMER_FERR_LSB);
+		    sc->extra_stats.framingBitErrorCount +=
+			    lmc_mii_readreg(sc, 0, 18) & 0xff;
+		    lmc_mii_writereg(sc, 0, 17, T1FRAMER_FERR_MSB);
+		    sc->extra_stats.framingBitErrorCount +=
+			    (lmc_mii_readreg(sc, 0, 18) & 0xff) << 8;
+		    lmc_mii_writereg(sc, 0, 17, T1FRAMER_LCV_LSB);
+		    sc->extra_stats.lineCodeViolationCount +=
+			    lmc_mii_readreg(sc, 0, 18) & 0xff;
+		    lmc_mii_writereg(sc, 0, 17, T1FRAMER_LCV_MSB);
+		    sc->extra_stats.lineCodeViolationCount +=
+			    (lmc_mii_readreg(sc, 0, 18) & 0xff) << 8;
+		    lmc_mii_writereg(sc, 0, 17, T1FRAMER_AERR);
+		    regVal = lmc_mii_readreg(sc, 0, 18) & 0xff;
+
+		    sc->extra_stats.lossOfFrameCount +=
+			    (regVal & T1FRAMER_LOF_MASK) >> 4;
+		    sc->extra_stats.changeOfFrameAlignmentCount +=
+			    (regVal & T1FRAMER_COFA_MASK) >> 2;
+		    sc->extra_stats.severelyErroredFrameCount +=
+			    regVal & T1FRAMER_SEF_MASK;
+	    }
+	    if (copy_to_user(ifr->ifr_data, &sc->lmc_device->stats,
+			     sizeof(sc->lmc_device->stats)) ||
+		copy_to_user(ifr->ifr_data + sizeof(sc->lmc_device->stats),
+			     &sc->extra_stats, sizeof(sc->extra_stats)))
+		    ret = -EFAULT;
+	    else
+		    ret = 0;
+	    break;
 
-    case LMCIOCCLEARLMCSTATS: /*fold01*/
-        if (!capable(CAP_NET_ADMIN)){
-            ret = -EPERM;
-            break;
-        }
+    case LMCIOCCLEARLMCSTATS:
+	    if (!capable(CAP_NET_ADMIN)) {
+		    ret = -EPERM;
+		    break;
+	    }
 
-        memset (&sc->stats, 0, sizeof (struct lmc_statistics));
-        sc->stats.check = STATCHECK;
-        sc->stats.version_size = (DRIVER_VERSION << 16) +
-            sizeof (struct lmc_statistics);
-        sc->stats.lmc_cardtype = sc->lmc_cardtype;
-        ret = 0;
-        break;
+	    memset(&sc->lmc_device->stats, 0, sizeof(sc->lmc_device->stats));
+	    memset(&sc->extra_stats, 0, sizeof(sc->extra_stats));
+	    sc->extra_stats.check = STATCHECK;
+	    sc->extra_stats.version_size = (DRIVER_VERSION << 16) +
+		    sizeof(sc->lmc_device->stats) + sizeof(sc->extra_stats);
+	    sc->extra_stats.lmc_cardtype = sc->lmc_cardtype;
+	    ret = 0;
+	    break;
 
     case LMCIOCSETCIRCUIT: /*fold01*/
         if (!capable(CAP_NET_ADMIN)){
@@ -330,7 +310,8 @@ int lmc_ioctl (struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
 		ret = -EFAULT;
 		break;
 	}
-        if (copy_to_user(ifr->ifr_data + sizeof (u32), lmcEventLogBuf, sizeof (lmcEventLogBuf)))
+	if (copy_to_user(ifr->ifr_data + sizeof(u32), lmcEventLogBuf,
+			 sizeof(lmcEventLogBuf)))
 		ret = -EFAULT;
 	else
 		ret = 0;
@@ -641,14 +622,12 @@ int lmc_ioctl (struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
 /* the watchdog process that cruises around */
 static void lmc_watchdog (unsigned long data) /*fold00*/
 {
-    struct net_device *dev = (struct net_device *) data;
-    lmc_softc_t *sc;
+    struct net_device *dev = (struct net_device *)data;
+    lmc_softc_t *sc = dev_to_sc(dev);
     int link_status;
-    u_int32_t ticks;
+    u32 ticks;
     unsigned long flags;
 
-    sc = dev->priv;
-
     lmc_trace(dev, "lmc_watchdog in");
 
     spin_lock_irqsave(&sc->lmc_lock, flags);
@@ -677,22 +656,22 @@ static void lmc_watchdog (unsigned long data) /*fold00*/
      * check for a transmit interrupt timeout
      * Has the packet xmt vs xmt serviced threshold been exceeded */
     if (sc->lmc_taint_tx == sc->lastlmc_taint_tx &&
-        sc->stats.tx_packets > sc->lasttx_packets &&
-        sc->tx_TimeoutInd == 0)
+	sc->lmc_device->stats.tx_packets > sc->lasttx_packets &&
+	sc->tx_TimeoutInd == 0)
     {
 
         /* wait for the watchdog to come around again */
         sc->tx_TimeoutInd = 1;
     }
     else if (sc->lmc_taint_tx == sc->lastlmc_taint_tx &&
-             sc->stats.tx_packets > sc->lasttx_packets &&
-             sc->tx_TimeoutInd)
+	     sc->lmc_device->stats.tx_packets > sc->lasttx_packets &&
+	     sc->tx_TimeoutInd)
     {
 
         LMC_EVENT_LOG(LMC_EVENT_XMTINTTMO, LMC_CSR_READ (sc, csr_status), 0);
 
         sc->tx_TimeoutDisplay = 1;
-        sc->stats.tx_TimeoutCnt++;
+	sc->extra_stats.tx_TimeoutCnt++;
 
         /* DEC chip is stuck, hit it with a RESET!!!! */
         lmc_running_reset (dev);
@@ -712,13 +691,11 @@ static void lmc_watchdog (unsigned long data) /*fold00*/
         /* reset the transmit timeout detection flag */
         sc->tx_TimeoutInd = 0;
         sc->lastlmc_taint_tx = sc->lmc_taint_tx;
-        sc->lasttx_packets = sc->stats.tx_packets;
-    }
-    else
-    {
+	sc->lasttx_packets = sc->lmc_device->stats.tx_packets;
+    } else {
         sc->tx_TimeoutInd = 0;
         sc->lastlmc_taint_tx = sc->lmc_taint_tx;
-        sc->lasttx_packets = sc->stats.tx_packets;
+	sc->lasttx_packets = sc->lmc_device->stats.tx_packets;
     }
 
     /* --- end time out check ----------------------------------- */
@@ -748,19 +725,7 @@ static void lmc_watchdog (unsigned long data) /*fold00*/
          sc->last_link_status = 1;
          /* lmc_reset (sc); Again why reset??? */
 
-         /* Inform the world that link protocol is back up. */
 	 netif_carrier_on(dev);
-
-         /* Now we have to tell the syncppp that we had an outage
-          * and that it should deal.  Calling sppp_reopen here
-          * should do the trick, but we may have to call sppp_close
-          * when the link goes down, and call sppp_open here.
-          * Subject to more testing.
-          * --bbraun
-          */
-
-         lmc_proto_reopen(sc);
-
      }
 
     /* Call media specific watchdog functions */
@@ -816,114 +781,93 @@ kick_timer:
 
 }
 
-static void lmc_setup(struct net_device * const dev) /*fold00*/
+static int lmc_attach(struct net_device *dev, unsigned short encoding,
+		      unsigned short parity)
 {
-    lmc_trace(dev, "lmc_setup in");
-
-    dev->type = ARPHRD_HDLC;
-    dev->hard_start_xmit = lmc_start_xmit;
-    dev->open = lmc_open;
-    dev->stop = lmc_close;
-    dev->get_stats = lmc_get_stats;
-    dev->do_ioctl = lmc_ioctl;
-    dev->tx_timeout = lmc_driver_timeout;
-    dev->watchdog_timeo = (HZ); /* 1 second */
-    
-    lmc_trace(dev, "lmc_setup out");
+	if (encoding == ENCODING_NRZ && parity == PARITY_CRC16_PR1_CCITT)
+		return 0;
+	return -EINVAL;
 }
 
-
 static int __devinit lmc_init_one(struct pci_dev *pdev,
 				  const struct pci_device_id *ent)
 {
-    struct net_device *dev;
-    lmc_softc_t *sc;
-    u16 subdevice;
-    u_int16_t AdapModelNum;
-    int err = -ENOMEM;
-    static int cards_found;
-#ifndef GCOM
-    /* We name by type not by vendor */
-    static const char lmcname[] = "hdlc%d";
-#else
-    /* 
-     * GCOM uses LMC vendor name so that clients can know which card
-     * to attach to.
-     */
-    static const char lmcname[] = "lmc%d";
-#endif
-
-
-    /*
-     * Allocate our own device structure
-     */
-    dev = alloc_netdev(sizeof(lmc_softc_t), lmcname, lmc_setup);
-    if (!dev) {
-        printk (KERN_ERR "lmc:alloc_netdev for device failed\n");
-	goto out1;
-    }
- 
-    lmc_trace(dev, "lmc_init_one in");
-
-    err = pci_enable_device(pdev);
-    if (err) {
-	    printk(KERN_ERR "lmc: pci enable failed:%d\n", err);
-	    goto out2;
-    }
-    
-    if (pci_request_regions(pdev, "lmc")) {
-	    printk(KERN_ERR "lmc: pci_request_region failed\n");
-	    err = -EIO;
-	    goto out3;
-    }
-
-    pci_set_drvdata(pdev, dev);
-
-    if(lmc_first_load == 0){
-        printk(KERN_INFO "Lan Media Corporation WAN Driver Version %d.%d.%d\n",
-	       DRIVER_MAJOR_VERSION, DRIVER_MINOR_VERSION,DRIVER_SUB_VERSION);
-        lmc_first_load = 1;
-    }
-    
-    sc = dev->priv;
-    sc->lmc_device = dev;
-    sc->name = dev->name;
-
-    /* Initialize the sppp layer */
-    /* An ioctl can cause a subsequent detach for raw frame interface */
-    dev->ml_priv = sc;
-    sc->if_type = LMC_PPP;
-    sc->check = 0xBEAFCAFE;
-    dev->base_addr = pci_resource_start(pdev, 0);
-    dev->irq = pdev->irq;
-
-    SET_NETDEV_DEV(dev, &pdev->dev);
-
-    /*
-     * This will get the protocol layer ready and do any 1 time init's
-     * Must have a valid sc and dev structure
-     */
-    lmc_proto_init(sc);
-
-    lmc_proto_attach(sc);
+	lmc_softc_t *sc;
+	struct net_device *dev;
+	u16 subdevice;
+	u16 AdapModelNum;
+	int err;
+	static int cards_found;
+
+	/* lmc_trace(dev, "lmc_init_one in"); */
+
+	err = pci_enable_device(pdev);
+	if (err) {
+		printk(KERN_ERR "lmc: pci enable failed: %d\n", err);
+		return err;
+	}
 
-    /*
-     * Why were we changing this???
-     dev->tx_queue_len = 100;
-     */
+	err = pci_request_regions(pdev, "lmc");
+	if (err) {
+		printk(KERN_ERR "lmc: pci_request_region failed\n");
+		goto err_req_io;
+	}
 
-    /* Init the spin lock so can call it latter */
+	/*
+	 * Allocate our own device structure
+	 */
+	sc = kzalloc(sizeof(lmc_softc_t), GFP_KERNEL);
+	if (!sc) {
+		err = -ENOMEM;
+		goto err_kzalloc;
+	}
 
-    spin_lock_init(&sc->lmc_lock);
-    pci_set_master(pdev);
+	dev = alloc_hdlcdev(sc);
+	if (!dev) {
+		printk(KERN_ERR "lmc:alloc_netdev for device failed\n");
+		goto err_hdlcdev;
+	}
 
-    printk ("%s: detected at %lx, irq %d\n", dev->name,
-	    dev->base_addr, dev->irq);
 
-    if (register_netdev (dev) != 0) {
-        printk (KERN_ERR "%s: register_netdev failed.\n", dev->name);
-	goto out4;
-    }
+	dev->type = ARPHRD_HDLC;
+	dev_to_hdlc(dev)->xmit = lmc_start_xmit;
+	dev_to_hdlc(dev)->attach = lmc_attach;
+	dev->open = lmc_open;
+	dev->stop = lmc_close;
+	dev->get_stats = lmc_get_stats;
+	dev->do_ioctl = lmc_ioctl;
+	dev->tx_timeout = lmc_driver_timeout;
+	dev->watchdog_timeo = HZ; /* 1 second */
+	dev->tx_queue_len = 100;
+	sc->lmc_device = dev;
+	sc->name = dev->name;
+	sc->if_type = LMC_PPP;
+	sc->check = 0xBEAFCAFE;
+	dev->base_addr = pci_resource_start(pdev, 0);
+	dev->irq = pdev->irq;
+	pci_set_drvdata(pdev, dev);
+	SET_NETDEV_DEV(dev, &pdev->dev);
+
+	/*
+	 * This will get the protocol layer ready and do any 1 time init's
+	 * Must have a valid sc and dev structure
+	 */
+	lmc_proto_attach(sc);
+
+	/* Init the spin lock so can call it latter */
+
+	spin_lock_init(&sc->lmc_lock);
+	pci_set_master(pdev);
+
+	printk(KERN_INFO "%s: detected at %lx, irq %d\n", dev->name,
+	       dev->base_addr, dev->irq);
+
+	err = register_hdlc_device(dev);
+	if (err) {
+		printk(KERN_ERR "%s: register_netdev failed.\n", dev->name);
+		free_netdev(dev);
+		goto err_hdlcdev;
+	}
 
     sc->lmc_cardtype = LMC_CARDTYPE_UNKNOWN;
     sc->lmc_timing = LMC_CTL_CLOCK_SOURCE_EXT;
@@ -939,27 +883,27 @@ static int __devinit lmc_init_one(struct pci_dev *pdev,
 
     switch (subdevice) {
     case PCI_DEVICE_ID_LMC_HSSI:
-        printk ("%s: LMC HSSI\n", dev->name);
+	printk(KERN_INFO "%s: LMC HSSI\n", dev->name);
         sc->lmc_cardtype = LMC_CARDTYPE_HSSI;
         sc->lmc_media = &lmc_hssi_media;
         break;
     case PCI_DEVICE_ID_LMC_DS3:
-        printk ("%s: LMC DS3\n", dev->name);
+	printk(KERN_INFO "%s: LMC DS3\n", dev->name);
         sc->lmc_cardtype = LMC_CARDTYPE_DS3;
         sc->lmc_media = &lmc_ds3_media;
         break;
     case PCI_DEVICE_ID_LMC_SSI:
-        printk ("%s: LMC SSI\n", dev->name);
+	printk(KERN_INFO "%s: LMC SSI\n", dev->name);
         sc->lmc_cardtype = LMC_CARDTYPE_SSI;
         sc->lmc_media = &lmc_ssi_media;
         break;
     case PCI_DEVICE_ID_LMC_T1:
-        printk ("%s: LMC T1\n", dev->name);
+	printk(KERN_INFO "%s: LMC T1\n", dev->name);
         sc->lmc_cardtype = LMC_CARDTYPE_T1;
         sc->lmc_media = &lmc_t1_media;
         break;
     default:
-        printk (KERN_WARNING "%s: LMC UNKOWN CARD!\n", dev->name);
+	printk(KERN_WARNING "%s: LMC UNKOWN CARD!\n", dev->name);
         break;
     }
 
@@ -977,32 +921,28 @@ static int __devinit lmc_init_one(struct pci_dev *pdev,
      */
     AdapModelNum = (lmc_mii_readreg (sc, 0, 3) & 0x3f0) >> 4;
 
-    if ((AdapModelNum == LMC_ADAP_T1
-         && subdevice == PCI_DEVICE_ID_LMC_T1) ||	/* detect LMC1200 */
-        (AdapModelNum == LMC_ADAP_SSI
-         && subdevice == PCI_DEVICE_ID_LMC_SSI) ||	/* detect LMC1000 */
-        (AdapModelNum == LMC_ADAP_DS3
-         && subdevice == PCI_DEVICE_ID_LMC_DS3) ||	/* detect LMC5245 */
-        (AdapModelNum == LMC_ADAP_HSSI
-         && subdevice == PCI_DEVICE_ID_LMC_HSSI))
-    {				/* detect LMC5200 */
+    if ((AdapModelNum != LMC_ADAP_T1 || /* detect LMC1200 */
+	 subdevice != PCI_DEVICE_ID_LMC_T1) &&
+	(AdapModelNum != LMC_ADAP_SSI || /* detect LMC1000 */
+	 subdevice != PCI_DEVICE_ID_LMC_SSI) &&
+	(AdapModelNum != LMC_ADAP_DS3 || /* detect LMC5245 */
+	 subdevice != PCI_DEVICE_ID_LMC_DS3) &&
+	(AdapModelNum != LMC_ADAP_HSSI || /* detect LMC5200 */
+	 subdevice != PCI_DEVICE_ID_LMC_HSSI))
+	    printk(KERN_WARNING "%s: Model number (%d) miscompare for PCI"
+		   " Subsystem ID = 0x%04x\n",
+		   dev->name, AdapModelNum, subdevice);
 
-    }
-    else {
-        printk ("%s: Model number (%d) miscompare for PCI Subsystem ID = 0x%04x\n",
-                dev->name, AdapModelNum, subdevice);
-//        return (NULL);
-    }
     /*
      * reset clock
      */
     LMC_CSR_WRITE (sc, csr_gp_timer, 0xFFFFFFFFUL);
 
     sc->board_idx = cards_found++;
-    sc->stats.check = STATCHECK;
-    sc->stats.version_size = (DRIVER_VERSION << 16) +
-        sizeof (struct lmc_statistics);
-    sc->stats.lmc_cardtype = sc->lmc_cardtype;
+    sc->extra_stats.check = STATCHECK;
+    sc->extra_stats.version_size = (DRIVER_VERSION << 16) +
+	    sizeof(sc->lmc_device->stats) + sizeof(sc->extra_stats);
+    sc->extra_stats.lmc_cardtype = sc->lmc_cardtype;
 
     sc->lmc_ok = 0;
     sc->last_link_status = 0;
@@ -1010,58 +950,51 @@ static int __devinit lmc_init_one(struct pci_dev *pdev,
     lmc_trace(dev, "lmc_init_one out");
     return 0;
 
- out4:
-    lmc_proto_detach(sc);
- out3:
-    if (pdev) {
-	    pci_release_regions(pdev);
-	    pci_set_drvdata(pdev, NULL);
-    }
- out2:
-    free_netdev(dev);
- out1:
-    return err;
+err_hdlcdev:
+	pci_set_drvdata(pdev, NULL);
+	kfree(sc);
+err_kzalloc:
+	pci_release_regions(pdev);
+err_req_io:
+	pci_disable_device(pdev);
+	return err;
 }
 
 /*
  * Called from pci when removing module.
  */
-static void __devexit lmc_remove_one (struct pci_dev *pdev)
+static void __devexit lmc_remove_one(struct pci_dev *pdev)
 {
-    struct net_device *dev = pci_get_drvdata(pdev);
-    
-    if (dev) {
-	    lmc_softc_t *sc = dev->priv;
-	    
-	    printk("%s: removing...\n", dev->name);
-	    lmc_proto_detach(sc);
-	    unregister_netdev(dev);
-	    free_netdev(dev);
-	    pci_release_regions(pdev);
-	    pci_disable_device(pdev);
-	    pci_set_drvdata(pdev, NULL);
-    }
+	struct net_device *dev = pci_get_drvdata(pdev);
+
+	if (dev) {
+		printk(KERN_DEBUG "%s: removing...\n", dev->name);
+		unregister_hdlc_device(dev);
+		free_netdev(dev);
+		pci_release_regions(pdev);
+		pci_disable_device(pdev);
+		pci_set_drvdata(pdev, NULL);
+	}
 }
 
 /* After this is called, packets can be sent.
  * Does not initialize the addresses
  */
-static int lmc_open (struct net_device *dev) /*fold00*/
+static int lmc_open(struct net_device *dev)
 {
-    lmc_softc_t *sc = dev->priv;
+    lmc_softc_t *sc = dev_to_sc(dev);
+    int err;
 
     lmc_trace(dev, "lmc_open in");
 
     lmc_led_on(sc, LMC_DS3_LED0);
 
-    lmc_dec_reset (sc);
-    lmc_reset (sc);
-
-    LMC_EVENT_LOG(LMC_EVENT_RESET1, LMC_CSR_READ (sc, csr_status), 0);
-    LMC_EVENT_LOG(LMC_EVENT_RESET2,
-                  lmc_mii_readreg (sc, 0, 16),
-                  lmc_mii_readreg (sc, 0, 17));
+    lmc_dec_reset(sc);
+    lmc_reset(sc);
 
+    LMC_EVENT_LOG(LMC_EVENT_RESET1, LMC_CSR_READ(sc, csr_status), 0);
+    LMC_EVENT_LOG(LMC_EVENT_RESET2, lmc_mii_readreg(sc, 0, 16),
+		  lmc_mii_readreg(sc, 0, 17));
 
     if (sc->lmc_ok){
         lmc_trace(dev, "lmc_open lmc_ok out");
@@ -1106,14 +1039,14 @@ static int lmc_open (struct net_device *dev) /*fold00*/
 
     /* dev->flags |= IFF_UP; */
 
-    lmc_proto_open(sc);
+    if ((err = lmc_proto_open(sc)) != 0)
+	    return err;
 
     dev->do_ioctl = lmc_ioctl;
 
 
     netif_start_queue(dev);
-    
-    sc->stats.tx_tbusy0++ ;
+    sc->extra_stats.tx_tbusy0++;
 
     /*
      * select what interrupts we want to get
@@ -1165,8 +1098,7 @@ static int lmc_open (struct net_device *dev) /*fold00*/
 
 static void lmc_running_reset (struct net_device *dev) /*fold00*/
 {
-
-    lmc_softc_t *sc = (lmc_softc_t *) dev->priv;
+    lmc_softc_t *sc = dev_to_sc(dev);
 
     lmc_trace(dev, "lmc_runnig_reset in");
 
@@ -1184,7 +1116,7 @@ static void lmc_running_reset (struct net_device *dev) /*fold00*/
     netif_wake_queue(dev);
 
     sc->lmc_txfull = 0;
-    sc->stats.tx_tbusy0++ ;
+    sc->extra_stats.tx_tbusy0++;
 
     sc->lmc_intrmask = TULIP_DEFAULT_INTR_MASK;
     LMC_CSR_WRITE (sc, csr_intr, sc->lmc_intrmask);
@@ -1200,14 +1132,13 @@ static void lmc_running_reset (struct net_device *dev) /*fold00*/
  * This disables the timer for the watchdog and keepalives,
  * and disables the irq for dev.
  */
-static int lmc_close (struct net_device *dev) /*fold00*/
+static int lmc_close(struct net_device *dev)
 {
     /* not calling release_region() as we should */
-    lmc_softc_t *sc;
+    lmc_softc_t *sc = dev_to_sc(dev);
 
     lmc_trace(dev, "lmc_close in");
-    
-    sc = dev->priv;
+
     sc->lmc_ok = 0;
     sc->lmc_media->set_link_status (sc, 0);
     del_timer (&sc->timer);
@@ -1215,7 +1146,7 @@ static int lmc_close (struct net_device *dev) /*fold00*/
     lmc_ifdown (dev);
 
     lmc_trace(dev, "lmc_close out");
-    
+
     return 0;
 }
 
@@ -1223,16 +1154,16 @@ static int lmc_close (struct net_device *dev) /*fold00*/
 /* When the interface goes down, this is called */
 static int lmc_ifdown (struct net_device *dev) /*fold00*/
 {
-    lmc_softc_t *sc = dev->priv;
+    lmc_softc_t *sc = dev_to_sc(dev);
     u32 csr6;
     int i;
 
     lmc_trace(dev, "lmc_ifdown in");
-    
+
     /* Don't let anything else go on right now */
     //    dev->start = 0;
     netif_stop_queue(dev);
-    sc->stats.tx_tbusy1++ ;
+    sc->extra_stats.tx_tbusy1++;
 
     /* stop interrupts */
     /* Clear the interrupt mask */
@@ -1244,8 +1175,8 @@ static int lmc_ifdown (struct net_device *dev) /*fold00*/
     csr6 &= ~LMC_DEC_SR;		/* Turn off the Receive bit */
     LMC_CSR_WRITE (sc, csr_command, csr6);
 
-    sc->stats.rx_missed_errors +=
-        LMC_CSR_READ (sc, csr_missed_frames) & 0xffff;
+    sc->lmc_device->stats.rx_missed_errors +=
+	    LMC_CSR_READ(sc, csr_missed_frames) & 0xffff;
 
     /* release the interrupt */
     if(sc->got_irq == 1){
@@ -1276,7 +1207,7 @@ static int lmc_ifdown (struct net_device *dev) /*fold00*/
     lmc_led_off (sc, LMC_MII16_LED_ALL);
 
     netif_wake_queue(dev);
-    sc->stats.tx_tbusy0++ ;
+    sc->extra_stats.tx_tbusy0++;
 
     lmc_trace(dev, "lmc_ifdown out");
 
@@ -1289,7 +1220,7 @@ static int lmc_ifdown (struct net_device *dev) /*fold00*/
 static irqreturn_t lmc_interrupt (int irq, void *dev_instance) /*fold00*/
 {
     struct net_device *dev = (struct net_device *) dev_instance;
-    lmc_softc_t *sc;
+    lmc_softc_t *sc = dev_to_sc(dev);
     u32 csr;
     int i;
     s32 stat;
@@ -1300,8 +1231,6 @@ static irqreturn_t lmc_interrupt (int irq, void *dev_instance) /*fold00*/
 
     lmc_trace(dev, "lmc_interrupt in");
 
-    sc = dev->priv;
-    
     spin_lock(&sc->lmc_lock);
 
     /*
@@ -1354,7 +1283,7 @@ static irqreturn_t lmc_interrupt (int irq, void *dev_instance) /*fold00*/
 
 	    int		n_compl = 0 ;
             /* reset the transmit timeout detection flag -baz */
-            sc->stats.tx_NoCompleteCnt = 0;
+	    sc->extra_stats.tx_NoCompleteCnt = 0;
 
             badtx = sc->lmc_taint_tx;
             i = badtx % LMC_TXDESCS;
@@ -1378,27 +1307,25 @@ static irqreturn_t lmc_interrupt (int irq, void *dev_instance) /*fold00*/
                 if (sc->lmc_txq[i] == NULL)
                     continue;
 
-                /*
-                 * Check the total error summary to look for any errors
-                 */
-                if (stat & 0x8000) {
-                    sc->stats.tx_errors++;
-                    if (stat & 0x4104)
-                        sc->stats.tx_aborted_errors++;
-                    if (stat & 0x0C00)
-                        sc->stats.tx_carrier_errors++;
-                    if (stat & 0x0200)
-                        sc->stats.tx_window_errors++;
-                    if (stat & 0x0002)
-                        sc->stats.tx_fifo_errors++;
-                }
-                else {
-                    
-                    sc->stats.tx_bytes += sc->lmc_txring[i].length & 0x7ff;
-                    
-                    sc->stats.tx_packets++;
+		/*
+		 * Check the total error summary to look for any errors
+		 */
+		if (stat & 0x8000) {
+			sc->lmc_device->stats.tx_errors++;
+			if (stat & 0x4104)
+				sc->lmc_device->stats.tx_aborted_errors++;
+			if (stat & 0x0C00)
+				sc->lmc_device->stats.tx_carrier_errors++;
+			if (stat & 0x0200)
+				sc->lmc_device->stats.tx_window_errors++;
+			if (stat & 0x0002)
+				sc->lmc_device->stats.tx_fifo_errors++;
+		} else {
+			sc->lmc_device->stats.tx_bytes += sc->lmc_txring[i].length & 0x7ff;
+
+			sc->lmc_device->stats.tx_packets++;
                 }
-                
+
                 //                dev_kfree_skb(sc->lmc_txq[i]);
                 dev_kfree_skb_irq(sc->lmc_txq[i]);
                 sc->lmc_txq[i] = NULL;
@@ -1415,13 +1342,13 @@ static irqreturn_t lmc_interrupt (int irq, void *dev_instance) /*fold00*/
             LMC_EVENT_LOG(LMC_EVENT_TBUSY0, n_compl, 0);
             sc->lmc_txfull = 0;
             netif_wake_queue(dev);
-            sc->stats.tx_tbusy0++ ;
+	    sc->extra_stats.tx_tbusy0++;
 
 
 #ifdef DEBUG
-            sc->stats.dirtyTx = badtx;
-            sc->stats.lmc_next_tx = sc->lmc_next_tx;
-            sc->stats.lmc_txfull = sc->lmc_txfull;
+	    sc->extra_stats.dirtyTx = badtx;
+	    sc->extra_stats.lmc_next_tx = sc->lmc_next_tx;
+	    sc->extra_stats.lmc_txfull = sc->lmc_txfull;
 #endif
             sc->lmc_taint_tx = badtx;
 
@@ -1476,9 +1403,9 @@ lmc_int_fail_out:
     return IRQ_RETVAL(handled);
 }
 
-static int lmc_start_xmit (struct sk_buff *skb, struct net_device *dev) /*fold00*/
+static int lmc_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-    lmc_softc_t *sc;
+    lmc_softc_t *sc = dev_to_sc(dev);
     u32 flag;
     int entry;
     int ret = 0;
@@ -1486,8 +1413,6 @@ static int lmc_start_xmit (struct sk_buff *skb, struct net_device *dev) /*fold00
 
     lmc_trace(dev, "lmc_start_xmit in");
 
-    sc = dev->priv;
-
     spin_lock_irqsave(&sc->lmc_lock, flags);
 
     /* normal path, tbusy known to be zero */
@@ -1532,8 +1457,8 @@ static int lmc_start_xmit (struct sk_buff *skb, struct net_device *dev) /*fold00
     if (sc->lmc_next_tx - sc->lmc_taint_tx >= LMC_TXDESCS - 1)
     {				/* ring full, go busy */
         sc->lmc_txfull = 1;
-        netif_stop_queue(dev);
-        sc->stats.tx_tbusy1++ ;
+	netif_stop_queue(dev);
+	sc->extra_stats.tx_tbusy1++;
         LMC_EVENT_LOG(LMC_EVENT_TBUSY1, entry, 0);
     }
 #endif
@@ -1550,7 +1475,7 @@ static int lmc_start_xmit (struct sk_buff *skb, struct net_device *dev) /*fold00
      * the watchdog timer handler. -baz
      */
 
-    sc->stats.tx_NoCompleteCnt++;
+    sc->extra_stats.tx_NoCompleteCnt++;
     sc->lmc_next_tx++;
 
     /* give ownership to the chip */
@@ -1569,9 +1494,9 @@ static int lmc_start_xmit (struct sk_buff *skb, struct net_device *dev) /*fold00
 }
 
 
-static int lmc_rx (struct net_device *dev) /*fold00*/
+static int lmc_rx(struct net_device *dev)
 {
-    lmc_softc_t *sc;
+    lmc_softc_t *sc = dev_to_sc(dev);
     int i;
     int rx_work_limit = LMC_RXDESCS;
     unsigned int next_rx;
@@ -1583,8 +1508,6 @@ static int lmc_rx (struct net_device *dev) /*fold00*/
 
     lmc_trace(dev, "lmc_rx in");
 
-    sc = dev->priv;
-
     lmc_led_on(sc, LMC_DS3_LED3);
 
     rxIntLoopCnt = 0;		/* debug -baz */
@@ -1597,39 +1520,38 @@ static int lmc_rx (struct net_device *dev) /*fold00*/
         rxIntLoopCnt++;		/* debug -baz */
         len = ((stat & LMC_RDES_FRAME_LENGTH) >> RDES_FRAME_LENGTH_BIT_NUMBER);
         if ((stat & 0x0300) != 0x0300) {  /* Check first segment and last segment */
-            if ((stat & 0x0000ffff) != 0x7fff) {
-                /* Oversized frame */
-                sc->stats.rx_length_errors++;
-                goto skip_packet;
-            }
-        }
-
-        if(stat & 0x00000008){ /* Catch a dribbling bit error */
-            sc->stats.rx_errors++;
-            sc->stats.rx_frame_errors++;
-            goto skip_packet;
-        }
+		if ((stat & 0x0000ffff) != 0x7fff) {
+			/* Oversized frame */
+			sc->lmc_device->stats.rx_length_errors++;
+			goto skip_packet;
+		}
+	}
 
+	if (stat & 0x00000008) { /* Catch a dribbling bit error */
+		sc->lmc_device->stats.rx_errors++;
+		sc->lmc_device->stats.rx_frame_errors++;
+		goto skip_packet;
+	}
 
-        if(stat & 0x00000004){ /* Catch a CRC error by the Xilinx */
-            sc->stats.rx_errors++;
-            sc->stats.rx_crc_errors++;
-            goto skip_packet;
-        }
 
+	if (stat & 0x00000004) { /* Catch a CRC error by the Xilinx */
+		sc->lmc_device->stats.rx_errors++;
+		sc->lmc_device->stats.rx_crc_errors++;
+		goto skip_packet;
+	}
 
-        if (len > LMC_PKT_BUF_SZ){
-            sc->stats.rx_length_errors++;
-            localLengthErrCnt++;
-            goto skip_packet;
-        }
+	if (len > LMC_PKT_BUF_SZ) {
+		sc->lmc_device->stats.rx_length_errors++;
+		localLengthErrCnt++;
+		goto skip_packet;
+	}
 
-        if (len < sc->lmc_crcSize + 2) {
-            sc->stats.rx_length_errors++;
-            sc->stats.rx_SmallPktCnt++;
-            localLengthErrCnt++;
-            goto skip_packet;
-        }
+	if (len < sc->lmc_crcSize + 2) {
+		sc->lmc_device->stats.rx_length_errors++;
+		sc->extra_stats.rx_SmallPktCnt++;
+		localLengthErrCnt++;
+		goto skip_packet;
+	}
 
         if(stat & 0x00004000){
             printk(KERN_WARNING "%s: Receiver descriptor error, receiver out of sync?\n", dev->name);
@@ -1656,8 +1578,8 @@ static int lmc_rx (struct net_device *dev) /*fold00*/
         }
         
         dev->last_rx = jiffies;
-        sc->stats.rx_packets++;
-        sc->stats.rx_bytes += len;
+	sc->lmc_device->stats.rx_packets++;
+	sc->lmc_device->stats.rx_bytes += len;
 
         LMC_CONSOLE_LOG("recv", skb->data, len);
 
@@ -1679,7 +1601,6 @@ static int lmc_rx (struct net_device *dev) /*fold00*/
 
             skb_put (skb, len);
             skb->protocol = lmc_proto_type(sc, skb);
-            skb->protocol = htons(ETH_P_WAN_PPP);
             skb_reset_mac_header(skb);
             /* skb_reset_network_header(skb); */
             skb->dev = dev;
@@ -1704,7 +1625,7 @@ static int lmc_rx (struct net_device *dev) /*fold00*/
                  * in which care we'll try to allocate the buffer
                  * again.  (once a second)
                  */
-                sc->stats.rx_BuffAllocErr++;
+		sc->extra_stats.rx_BuffAllocErr++;
                 LMC_EVENT_LOG(LMC_EVENT_RCVINT, stat, len);
                 sc->failed_recv_alloc = 1;
                 goto skip_out_of_mem;
@@ -1739,16 +1660,14 @@ static int lmc_rx (struct net_device *dev) /*fold00*/
      * descriptors with bogus packets
      *
     if (localLengthErrCnt > LMC_RXDESCS - 3) {
-        sc->stats.rx_BadPktSurgeCnt++;
-        LMC_EVENT_LOG(LMC_EVENT_BADPKTSURGE,
-                      localLengthErrCnt,
-                      sc->stats.rx_BadPktSurgeCnt);
+	sc->extra_stats.rx_BadPktSurgeCnt++;
+	LMC_EVENT_LOG(LMC_EVENT_BADPKTSURGE, localLengthErrCnt,
+		      sc->extra_stats.rx_BadPktSurgeCnt);
     } */
 
     /* save max count of receive descriptors serviced */
-    if (rxIntLoopCnt > sc->stats.rxIntLoopCnt) {
-        sc->stats.rxIntLoopCnt = rxIntLoopCnt;	/* debug -baz */
-    }
+    if (rxIntLoopCnt > sc->extra_stats.rxIntLoopCnt)
+	    sc->extra_stats.rxIntLoopCnt = rxIntLoopCnt; /* debug -baz */
 
 #ifdef DEBUG
     if (rxIntLoopCnt == 0)
@@ -1775,23 +1694,22 @@ skip_out_of_mem:
     return 0;
 }
 
-static struct net_device_stats *lmc_get_stats (struct net_device *dev) /*fold00*/
+static struct net_device_stats *lmc_get_stats(struct net_device *dev)
 {
-    lmc_softc_t *sc = dev->priv;
+    lmc_softc_t *sc = dev_to_sc(dev);
     unsigned long flags;
 
     lmc_trace(dev, "lmc_get_stats in");
 
-
     spin_lock_irqsave(&sc->lmc_lock, flags);
 
-    sc->stats.rx_missed_errors += LMC_CSR_READ (sc, csr_missed_frames) & 0xffff;
+    sc->lmc_device->stats.rx_missed_errors += LMC_CSR_READ(sc, csr_missed_frames) & 0xffff;
 
     spin_unlock_irqrestore(&sc->lmc_lock, flags);
 
     lmc_trace(dev, "lmc_get_stats out");
 
-    return (struct net_device_stats *) &sc->stats;
+    return &sc->lmc_device->stats;
 }
 
 static struct pci_driver lmc_driver = {
@@ -1970,7 +1888,7 @@ static void lmc_softreset (lmc_softc_t * const sc) /*fold00*/
     {
         if (sc->lmc_txq[i] != NULL){		/* have buffer */
             dev_kfree_skb(sc->lmc_txq[i]);	/* free it */
-            sc->stats.tx_dropped++;      /* We just dropped a packet */
+	    sc->lmc_device->stats.tx_dropped++;	/* We just dropped a packet */
         }
         sc->lmc_txq[i] = NULL;
         sc->lmc_txring[i].status = 0x00000000;
@@ -1982,7 +1900,7 @@ static void lmc_softreset (lmc_softc_t * const sc) /*fold00*/
     lmc_trace(sc->lmc_device, "lmc_softreset out");
 }
 
-void lmc_gpio_mkinput(lmc_softc_t * const sc, u_int32_t bits) /*fold00*/
+void lmc_gpio_mkinput(lmc_softc_t * const sc, u32 bits) /*fold00*/
 {
     lmc_trace(sc->lmc_device, "lmc_gpio_mkinput in");
     sc->lmc_gpio_io &= ~bits;
@@ -1990,7 +1908,7 @@ void lmc_gpio_mkinput(lmc_softc_t * const sc, u_int32_t bits) /*fold00*/
     lmc_trace(sc->lmc_device, "lmc_gpio_mkinput out");
 }
 
-void lmc_gpio_mkoutput(lmc_softc_t * const sc, u_int32_t bits) /*fold00*/
+void lmc_gpio_mkoutput(lmc_softc_t * const sc, u32 bits) /*fold00*/
 {
     lmc_trace(sc->lmc_device, "lmc_gpio_mkoutput in");
     sc->lmc_gpio_io |= bits;
@@ -1998,7 +1916,7 @@ void lmc_gpio_mkoutput(lmc_softc_t * const sc, u_int32_t bits) /*fold00*/
     lmc_trace(sc->lmc_device, "lmc_gpio_mkoutput out");
 }
 
-void lmc_led_on(lmc_softc_t * const sc, u_int32_t led) /*fold00*/
+void lmc_led_on(lmc_softc_t * const sc, u32 led) /*fold00*/
 {
     lmc_trace(sc->lmc_device, "lmc_led_on in");
     if((~sc->lmc_miireg16) & led){ /* Already on! */
@@ -2011,7 +1929,7 @@ void lmc_led_on(lmc_softc_t * const sc, u_int32_t led) /*fold00*/
     lmc_trace(sc->lmc_device, "lmc_led_on out");
 }
 
-void lmc_led_off(lmc_softc_t * const sc, u_int32_t led) /*fold00*/
+void lmc_led_off(lmc_softc_t * const sc, u32 led) /*fold00*/
 {
     lmc_trace(sc->lmc_device, "lmc_led_off in");
     if(sc->lmc_miireg16 & led){ /* Already set don't do anything */
@@ -2061,13 +1979,13 @@ static void lmc_reset(lmc_softc_t * const sc) /*fold00*/
      */
     sc->lmc_media->init(sc);
 
-    sc->stats.resetCount++;
+    sc->extra_stats.resetCount++;
     lmc_trace(sc->lmc_device, "lmc_reset out");
 }
 
 static void lmc_dec_reset(lmc_softc_t * const sc) /*fold00*/
 {
-    u_int32_t val;
+    u32 val;
     lmc_trace(sc->lmc_device, "lmc_dec_reset in");
 
     /*
@@ -2151,23 +2069,21 @@ static void lmc_initcsrs(lmc_softc_t * const sc, lmc_csrptr_t csr_base, /*fold00
     lmc_trace(sc->lmc_device, "lmc_initcsrs out");
 }
 
-static void lmc_driver_timeout(struct net_device *dev) { /*fold00*/
-    lmc_softc_t *sc;
+static void lmc_driver_timeout(struct net_device *dev)
+{
+    lmc_softc_t *sc = dev_to_sc(dev);
     u32 csr6;
     unsigned long flags;
 
     lmc_trace(dev, "lmc_driver_timeout in");
 
-    sc = dev->priv;
-
     spin_lock_irqsave(&sc->lmc_lock, flags);
 
     printk("%s: Xmitter busy|\n", dev->name);
 
-    sc->stats.tx_tbusy_calls++ ;
-    if (jiffies - dev->trans_start < TX_TIMEOUT) {
-        goto bug_out;
-    }
+    sc->extra_stats.tx_tbusy_calls++;
+    if (jiffies - dev->trans_start < TX_TIMEOUT)
+	    goto bug_out;
 
     /*
      * Chip seems to have locked up
@@ -2178,7 +2094,7 @@ static void lmc_driver_timeout(struct net_device *dev) { /*fold00*/
 
     LMC_EVENT_LOG(LMC_EVENT_XMTPRCTMO,
                   LMC_CSR_READ (sc, csr_status),
-                  sc->stats.tx_ProcTimeout);
+		  sc->extra_stats.tx_ProcTimeout);
 
     lmc_running_reset (dev);
 
@@ -2195,8 +2111,8 @@ static void lmc_driver_timeout(struct net_device *dev) { /*fold00*/
     /* immediate transmit */
     LMC_CSR_WRITE (sc, csr_txpoll, 0);
 
-    sc->stats.tx_errors++;
-    sc->stats.tx_ProcTimeout++;	/* -baz */
+    sc->lmc_device->stats.tx_errors++;
+    sc->extra_stats.tx_ProcTimeout++; /* -baz */
 
     dev->trans_start = jiffies;
 
diff --git a/drivers/net/wan/lmc/lmc_media.c b/drivers/net/wan/lmc/lmc_media.c
index 8aa461c..f327674 100644
--- a/drivers/net/wan/lmc/lmc_media.c
+++ b/drivers/net/wan/lmc/lmc_media.c
@@ -16,8 +16,6 @@
 #include <linux/inet.h>
 #include <linux/bitops.h>
 
-#include <net/syncppp.h>
-
 #include <asm/processor.h>             /* Processor type for cache alignment. */
 #include <asm/io.h>
 #include <asm/dma.h>
@@ -95,8 +93,7 @@ static void lmc_dummy_set_1 (lmc_softc_t * const, int);
 static void lmc_dummy_set2_1 (lmc_softc_t * const, lmc_ctl_t *);
 
 static inline void write_av9110_bit (lmc_softc_t *, int);
-static void write_av9110 (lmc_softc_t *, u_int32_t, u_int32_t, u_int32_t,
-			  u_int32_t, u_int32_t);
+static void write_av9110(lmc_softc_t *, u32, u32, u32, u32, u32);
 
 lmc_media_t lmc_ds3_media = {
   lmc_ds3_init,			/* special media init stuff */
@@ -427,7 +424,7 @@ lmc_ds3_set_scram (lmc_softc_t * const sc, int ie)
 static int
 lmc_ds3_get_link_status (lmc_softc_t * const sc)
 {
-    u_int16_t link_status, link_status_11;
+    u16 link_status, link_status_11;
     int ret = 1;
 
     lmc_mii_writereg (sc, 0, 17, 7);
@@ -449,7 +446,7 @@ lmc_ds3_get_link_status (lmc_softc_t * const sc)
         (link_status & LMC_FRAMER_REG0_OOFS)){
         ret = 0;
         if(sc->last_led_err[3] != 1){
-            u16 r1;
+	    u16 r1;
             lmc_mii_writereg (sc, 0, 17, 01); /* Turn on Xbit error as our cisco does */
             r1 = lmc_mii_readreg (sc, 0, 18);
             r1 &= 0xfe;
@@ -462,7 +459,7 @@ lmc_ds3_get_link_status (lmc_softc_t * const sc)
     else {
         lmc_led_off(sc, LMC_DS3_LED3);	/* turn on red LED */
         if(sc->last_led_err[3] == 1){
-            u16 r1;
+	    u16 r1;
             lmc_mii_writereg (sc, 0, 17, 01); /* Turn off Xbit error */
             r1 = lmc_mii_readreg (sc, 0, 18);
             r1 |= 0x01;
@@ -540,20 +537,19 @@ lmc_ds3_watchdog (lmc_softc_t * const sc)
  *  SSI methods
  */
 
-static void
-lmc_ssi_init (lmc_softc_t * const sc)
+static void lmc_ssi_init(lmc_softc_t * const sc)
 {
-  u_int16_t mii17;
-  int cable;
+	u16 mii17;
+	int cable;
 
-  sc->ictl.cardtype = LMC_CTL_CARDTYPE_LMC1000;
+	sc->ictl.cardtype = LMC_CTL_CARDTYPE_LMC1000;
 
-  mii17 = lmc_mii_readreg (sc, 0, 17);
+	mii17 = lmc_mii_readreg(sc, 0, 17);
 
-  cable = (mii17 & LMC_MII17_SSI_CABLE_MASK) >> LMC_MII17_SSI_CABLE_SHIFT;
-  sc->ictl.cable_type = cable;
+	cable = (mii17 & LMC_MII17_SSI_CABLE_MASK) >> LMC_MII17_SSI_CABLE_SHIFT;
+	sc->ictl.cable_type = cable;
 
-  lmc_gpio_mkoutput (sc, LMC_GEP_SSI_TXCLOCK);
+	lmc_gpio_mkoutput(sc, LMC_GEP_SSI_TXCLOCK);
 }
 
 static void
@@ -681,11 +677,11 @@ lmc_ssi_set_speed (lmc_softc_t * const sc, lmc_ctl_t * ctl)
 static int
 lmc_ssi_get_link_status (lmc_softc_t * const sc)
 {
-  u_int16_t link_status;
-  u_int32_t ticks;
+  u16 link_status;
+  u32 ticks;
   int ret = 1;
   int hw_hdsk = 1;
-  
+
   /*
    * missing CTS?  Hmm.  If we require CTS on, we may never get the
    * link to come up, so omit it in this test.
@@ -720,9 +716,9 @@ lmc_ssi_get_link_status (lmc_softc_t * const sc)
   }
   else if (ticks == 0 ) {				/* no clock found ? */
       ret = 0;
-      if(sc->last_led_err[3] != 1){
-          sc->stats.tx_lossOfClockCnt++;
-          printk(KERN_WARNING "%s: Lost Clock, Link Down\n", sc->name);
+      if (sc->last_led_err[3] != 1) {
+	      sc->extra_stats.tx_lossOfClockCnt++;
+	      printk(KERN_WARNING "%s: Lost Clock, Link Down\n", sc->name);
       }
       sc->last_led_err[3] = 1;
       lmc_led_on (sc, LMC_MII16_LED3);	/* turn ON red LED */
@@ -838,9 +834,7 @@ write_av9110_bit (lmc_softc_t * sc, int c)
   LMC_CSR_WRITE (sc, csr_gp, sc->lmc_gpio);
 }
 
-static void
-write_av9110 (lmc_softc_t * sc, u_int32_t n, u_int32_t m, u_int32_t v,
-	      u_int32_t x, u_int32_t r)
+static void write_av9110(lmc_softc_t *sc, u32 n, u32 m, u32 v, u32 x, u32 r)
 {
   int i;
 
@@ -887,19 +881,13 @@ write_av9110 (lmc_softc_t * sc, u_int32_t n, u_int32_t m, u_int32_t v,
 		     | LMC_GEP_SSI_GENERATOR));
 }
 
-static void
-lmc_ssi_watchdog (lmc_softc_t * const sc)
+static void lmc_ssi_watchdog(lmc_softc_t * const sc)
 {
-  u_int16_t mii17 = lmc_mii_readreg (sc, 0, 17);
-  if (((mii17 >> 3) & 7) == 7)
-    {
-      lmc_led_off (sc, LMC_MII16_LED2);
-    }
-  else
-    {
-      lmc_led_on (sc, LMC_MII16_LED2);
-    }
-
+	u16 mii17 = lmc_mii_readreg(sc, 0, 17);
+	if (((mii17 >> 3) & 7) == 7)
+		lmc_led_off(sc, LMC_MII16_LED2);
+	else
+		lmc_led_on(sc, LMC_MII16_LED2);
 }
 
 /*
@@ -929,7 +917,7 @@ lmc_t1_read (lmc_softc_t * const sc, int a)
 static void
 lmc_t1_init (lmc_softc_t * const sc)
 {
-  u_int16_t mii16;
+  u16 mii16;
   int i;
 
   sc->ictl.cardtype = LMC_CTL_CARDTYPE_LMC1200;
@@ -1028,7 +1016,7 @@ lmc_t1_set_status (lmc_softc_t * const sc, lmc_ctl_t * ctl)
  */ static int
 lmc_t1_get_link_status (lmc_softc_t * const sc)
 {
-    u_int16_t link_status;
+    u16 link_status;
     int ret = 1;
 
   /* LMC5245 (DS3) & LMC1200 (DS1) LED definitions
diff --git a/drivers/net/wan/lmc/lmc_proto.c b/drivers/net/wan/lmc/lmc_proto.c
index 8531575..be9877f 100644
--- a/drivers/net/wan/lmc/lmc_proto.c
+++ b/drivers/net/wan/lmc/lmc_proto.c
@@ -36,9 +36,6 @@
 #include <linux/workqueue.h>
 #include <linux/proc_fs.h>
 #include <linux/bitops.h>
-
-#include <net/syncppp.h>
-
 #include <asm/processor.h>             /* Processor type for cache alignment. */
 #include <asm/io.h>
 #include <asm/dma.h>
@@ -50,48 +47,6 @@
 #include "lmc_ioctl.h"
 #include "lmc_proto.h"
 
-/*
- * The compile-time variable SPPPSTUP causes the module to be
- * compiled without referencing any of the sync ppp routines.
- */
-#ifdef SPPPSTUB
-#define SPPP_detach(d)	(void)0
-#define SPPP_open(d)	0
-#define SPPP_reopen(d)	(void)0
-#define SPPP_close(d)	(void)0
-#define SPPP_attach(d)	(void)0
-#define SPPP_do_ioctl(d,i,c)	-EOPNOTSUPP
-#else
-#define SPPP_attach(x)	sppp_attach((x)->pd)
-#define SPPP_detach(x)	sppp_detach((x)->pd->dev)
-#define SPPP_open(x)	sppp_open((x)->pd->dev)
-#define SPPP_reopen(x)	sppp_reopen((x)->pd->dev)
-#define SPPP_close(x)	sppp_close((x)->pd->dev)
-#define SPPP_do_ioctl(x, y, z)	sppp_do_ioctl((x)->pd->dev, (y), (z))
-#endif
-
-// init
-void lmc_proto_init(lmc_softc_t *sc) /*FOLD00*/
-{
-    lmc_trace(sc->lmc_device, "lmc_proto_init in");
-    switch(sc->if_type){
-    case LMC_PPP:
-        sc->pd = kmalloc(sizeof(struct ppp_device), GFP_KERNEL);
-	if (!sc->pd) {
-		printk("lmc_proto_init(): kmalloc failure!\n");
-		return;
-	}
-        sc->pd->dev = sc->lmc_device;
-        sc->if_ptr = sc->pd;
-        break;
-    case LMC_RAW:
-        break;
-    default:
-        break;
-    }
-    lmc_trace(sc->lmc_device, "lmc_proto_init out");
-}
-
 // attach
 void lmc_proto_attach(lmc_softc_t *sc) /*FOLD00*/
 {
@@ -100,7 +55,6 @@ void lmc_proto_attach(lmc_softc_t *sc) /*FOLD00*/
     case LMC_PPP:
         {
             struct net_device *dev = sc->lmc_device;
-            SPPP_attach(sc);
             dev->do_ioctl = lmc_ioctl;
         }
         break;
@@ -108,7 +62,7 @@ void lmc_proto_attach(lmc_softc_t *sc) /*FOLD00*/
         {
             struct net_device *dev = sc->lmc_device;
             /*
-             * They set a few basics because they don't use sync_ppp
+	     * They set a few basics because they don't use HDLC
              */
             dev->flags |= IFF_POINTOPOINT;
 
@@ -124,88 +78,39 @@ void lmc_proto_attach(lmc_softc_t *sc) /*FOLD00*/
     lmc_trace(sc->lmc_device, "lmc_proto_attach out");
 }
 
-// detach
-void lmc_proto_detach(lmc_softc_t *sc) /*FOLD00*/
+int lmc_proto_ioctl(lmc_softc_t *sc, struct ifreq *ifr, int cmd)
 {
-    switch(sc->if_type){
-    case LMC_PPP:
-        SPPP_detach(sc);
-        break;
-    case LMC_RAW: /* Tell someone we're detaching? */
-        break;
-    default:
-        break;
-    }
-
+	lmc_trace(sc->lmc_device, "lmc_proto_ioctl");
+	if (sc->if_type == LMC_PPP)
+		return hdlc_ioctl(sc->lmc_device, ifr, cmd);
+	return -EOPNOTSUPP;
 }
 
-// reopen
-void lmc_proto_reopen(lmc_softc_t *sc) /*FOLD00*/
+int lmc_proto_open(lmc_softc_t *sc)
 {
-    lmc_trace(sc->lmc_device, "lmc_proto_reopen in");
-    switch(sc->if_type){
-    case LMC_PPP:
-        SPPP_reopen(sc);
-        break;
-    case LMC_RAW: /* Reset the interface after being down, prerape to receive packets again */
-        break;
-    default:
-        break;
-    }
-    lmc_trace(sc->lmc_device, "lmc_proto_reopen out");
-}
+	int ret = 0;
 
+	lmc_trace(sc->lmc_device, "lmc_proto_open in");
 
-// ioctl
-int lmc_proto_ioctl(lmc_softc_t *sc, struct ifreq *ifr, int cmd) /*FOLD00*/
-{
-    lmc_trace(sc->lmc_device, "lmc_proto_ioctl out");
-    switch(sc->if_type){
-    case LMC_PPP:
-        return SPPP_do_ioctl (sc, ifr, cmd);
-        break;
-    default:
-        return -EOPNOTSUPP;
-        break;
-    }
-    lmc_trace(sc->lmc_device, "lmc_proto_ioctl out");
+	if (sc->if_type == LMC_PPP) {
+		ret = hdlc_open(sc->lmc_device);
+		if (ret < 0)
+			printk(KERN_WARNING "%s: HDLC open failed: %d\n",
+			       sc->name, ret);
+	}
+
+	lmc_trace(sc->lmc_device, "lmc_proto_open out");
+	return ret;
 }
 
-// open
-void lmc_proto_open(lmc_softc_t *sc) /*FOLD00*/
+void lmc_proto_close(lmc_softc_t *sc)
 {
-    int ret;
+	lmc_trace(sc->lmc_device, "lmc_proto_close in");
 
-    lmc_trace(sc->lmc_device, "lmc_proto_open in");
-    switch(sc->if_type){
-    case LMC_PPP:
-        ret = SPPP_open(sc);
-        if(ret < 0)
-            printk("%s: syncPPP open failed: %d\n", sc->name, ret);
-        break;
-    case LMC_RAW: /* We're about to start getting packets! */
-        break;
-    default:
-        break;
-    }
-    lmc_trace(sc->lmc_device, "lmc_proto_open out");
-}
-
-// close
+	if (sc->if_type == LMC_PPP)
+		hdlc_close(sc->lmc_device);
 
-void lmc_proto_close(lmc_softc_t *sc) /*FOLD00*/
-{
-    lmc_trace(sc->lmc_device, "lmc_proto_close in");
-    switch(sc->if_type){
-    case LMC_PPP:
-        SPPP_close(sc);
-        break;
-    case LMC_RAW: /* Interface going down */
-        break;
-    default:
-        break;
-    }
-    lmc_trace(sc->lmc_device, "lmc_proto_close out");
+	lmc_trace(sc->lmc_device, "lmc_proto_close out");
 }
 
 __be16 lmc_proto_type(lmc_softc_t *sc, struct sk_buff *skb) /*FOLD00*/
@@ -213,8 +118,8 @@ __be16 lmc_proto_type(lmc_softc_t *sc, struct sk_buff *skb) /*FOLD00*/
     lmc_trace(sc->lmc_device, "lmc_proto_type in");
     switch(sc->if_type){
     case LMC_PPP:
-        return htons(ETH_P_WAN_PPP);
-        break;
+	    return hdlc_type_trans(skb, sc->lmc_device);
+	    break;
     case LMC_NET:
         return htons(ETH_P_802_2);
         break;
@@ -245,4 +150,3 @@ void lmc_proto_netif(lmc_softc_t *sc, struct sk_buff *skb) /*FOLD00*/
     }
     lmc_trace(sc->lmc_device, "lmc_proto_netif out");
 }
-
diff --git a/drivers/net/wan/lmc/lmc_proto.h b/drivers/net/wan/lmc/lmc_proto.h
index ccaa69e..662148c 100644
--- a/drivers/net/wan/lmc/lmc_proto.h
+++ b/drivers/net/wan/lmc/lmc_proto.h
@@ -1,16 +1,18 @@
 #ifndef _LMC_PROTO_H_
 #define _LMC_PROTO_H_
 
-void lmc_proto_init(lmc_softc_t *sc);
+#include <linux/hdlc.h>
+
 void lmc_proto_attach(lmc_softc_t *sc);
-void lmc_proto_detach(lmc_softc_t *sc);
-void lmc_proto_reopen(lmc_softc_t *sc);
 int lmc_proto_ioctl(lmc_softc_t *sc, struct ifreq *ifr, int cmd);
-void lmc_proto_open(lmc_softc_t *sc);
+int lmc_proto_open(lmc_softc_t *sc);
 void lmc_proto_close(lmc_softc_t *sc);
 __be16 lmc_proto_type(lmc_softc_t *sc, struct sk_buff *skb);
 void lmc_proto_netif(lmc_softc_t *sc, struct sk_buff *skb);
-int lmc_skb_rawpackets(char *buf, char **start, off_t offset, int len, int unused);
 
-#endif
+static inline lmc_softc_t* dev_to_sc(struct net_device *dev)
+{
+	return (lmc_softc_t *)dev_to_hdlc(dev)->priv;
+}
 
+#endif
diff --git a/drivers/net/wan/lmc/lmc_var.h b/drivers/net/wan/lmc/lmc_var.h
index 6d003a3..65d0197 100644
--- a/drivers/net/wan/lmc/lmc_var.h
+++ b/drivers/net/wan/lmc/lmc_var.h
@@ -1,8 +1,6 @@
 #ifndef _LMC_VAR_H_
 #define _LMC_VAR_H_
 
-/* $Id: lmc_var.h,v 1.17 2000/04/06 12:16:47 asj Exp $ */
-
  /*
   * Copyright (c) 1997-2000 LAN Media Corporation (LMC)
   * All rights reserved.  www.lanmedia.com
@@ -19,23 +17,6 @@
 
 #include <linux/timer.h>
 
-#ifndef __KERNEL__
-typedef signed char s8;
-typedef unsigned char u8;
-
-typedef signed short s16;
-typedef unsigned short u16;
-
-typedef signed int s32;
-typedef unsigned int u32;
-
-typedef signed long long s64;
-typedef unsigned long long u64;
-
-#define BITS_PER_LONG 32 
-
-#endif
-
 /*
  * basic definitions used in lmc include files
  */
@@ -45,9 +26,6 @@ typedef struct lmc___media lmc_media_t;
 typedef struct lmc___ctl lmc_ctl_t;
 
 #define lmc_csrptr_t    unsigned long
-#define u_int16_t	u16
-#define u_int8_t	u8
-#define tulip_uint32_t	u32
 
 #define LMC_REG_RANGE 0x80
 
@@ -122,45 +100,45 @@ struct lmc_regfile_t {
  *  used to define bits in the second tulip_desc_t field (length)
  *  for the transmit descriptor -baz */
 
-#define LMC_TDES_FIRST_BUFFER_SIZE       ((u_int32_t)(0x000007FF))
-#define LMC_TDES_SECOND_BUFFER_SIZE      ((u_int32_t)(0x003FF800))
-#define LMC_TDES_HASH_FILTERING          ((u_int32_t)(0x00400000))
-#define LMC_TDES_DISABLE_PADDING         ((u_int32_t)(0x00800000))
-#define LMC_TDES_SECOND_ADDR_CHAINED     ((u_int32_t)(0x01000000))
-#define LMC_TDES_END_OF_RING             ((u_int32_t)(0x02000000))
-#define LMC_TDES_ADD_CRC_DISABLE         ((u_int32_t)(0x04000000))
-#define LMC_TDES_SETUP_PACKET            ((u_int32_t)(0x08000000))
-#define LMC_TDES_INVERSE_FILTERING       ((u_int32_t)(0x10000000))
-#define LMC_TDES_FIRST_SEGMENT           ((u_int32_t)(0x20000000))
-#define LMC_TDES_LAST_SEGMENT            ((u_int32_t)(0x40000000))
-#define LMC_TDES_INTERRUPT_ON_COMPLETION ((u_int32_t)(0x80000000))
+#define LMC_TDES_FIRST_BUFFER_SIZE       ((u32)(0x000007FF))
+#define LMC_TDES_SECOND_BUFFER_SIZE      ((u32)(0x003FF800))
+#define LMC_TDES_HASH_FILTERING          ((u32)(0x00400000))
+#define LMC_TDES_DISABLE_PADDING         ((u32)(0x00800000))
+#define LMC_TDES_SECOND_ADDR_CHAINED     ((u32)(0x01000000))
+#define LMC_TDES_END_OF_RING             ((u32)(0x02000000))
+#define LMC_TDES_ADD_CRC_DISABLE         ((u32)(0x04000000))
+#define LMC_TDES_SETUP_PACKET            ((u32)(0x08000000))
+#define LMC_TDES_INVERSE_FILTERING       ((u32)(0x10000000))
+#define LMC_TDES_FIRST_SEGMENT           ((u32)(0x20000000))
+#define LMC_TDES_LAST_SEGMENT            ((u32)(0x40000000))
+#define LMC_TDES_INTERRUPT_ON_COMPLETION ((u32)(0x80000000))
 
 #define TDES_SECOND_BUFFER_SIZE_BIT_NUMBER  11
 #define TDES_COLLISION_COUNT_BIT_NUMBER     3
 
 /* Constants for the RCV descriptor RDES */
 
-#define LMC_RDES_OVERFLOW             ((u_int32_t)(0x00000001))
-#define LMC_RDES_CRC_ERROR            ((u_int32_t)(0x00000002))
-#define LMC_RDES_DRIBBLING_BIT            ((u_int32_t)(0x00000004))
-#define LMC_RDES_REPORT_ON_MII_ERR    ((u_int32_t)(0x00000008))
-#define LMC_RDES_RCV_WATCHDOG_TIMEOUT ((u_int32_t)(0x00000010))
-#define LMC_RDES_FRAME_TYPE           ((u_int32_t)(0x00000020))
-#define LMC_RDES_COLLISION_SEEN       ((u_int32_t)(0x00000040))
-#define LMC_RDES_FRAME_TOO_LONG       ((u_int32_t)(0x00000080))
-#define LMC_RDES_LAST_DESCRIPTOR      ((u_int32_t)(0x00000100))
-#define LMC_RDES_FIRST_DESCRIPTOR     ((u_int32_t)(0x00000200))
-#define LMC_RDES_MULTICAST_FRAME      ((u_int32_t)(0x00000400))
-#define LMC_RDES_RUNT_FRAME           ((u_int32_t)(0x00000800))
-#define LMC_RDES_DATA_TYPE            ((u_int32_t)(0x00003000))
-#define LMC_RDES_LENGTH_ERROR         ((u_int32_t)(0x00004000))
-#define LMC_RDES_ERROR_SUMMARY        ((u_int32_t)(0x00008000))
-#define LMC_RDES_FRAME_LENGTH         ((u_int32_t)(0x3FFF0000))
-#define LMC_RDES_OWN_BIT              ((u_int32_t)(0x80000000))
+#define LMC_RDES_OVERFLOW             ((u32)(0x00000001))
+#define LMC_RDES_CRC_ERROR            ((u32)(0x00000002))
+#define LMC_RDES_DRIBBLING_BIT        ((u32)(0x00000004))
+#define LMC_RDES_REPORT_ON_MII_ERR    ((u32)(0x00000008))
+#define LMC_RDES_RCV_WATCHDOG_TIMEOUT ((u32)(0x00000010))
+#define LMC_RDES_FRAME_TYPE           ((u32)(0x00000020))
+#define LMC_RDES_COLLISION_SEEN       ((u32)(0x00000040))
+#define LMC_RDES_FRAME_TOO_LONG       ((u32)(0x00000080))
+#define LMC_RDES_LAST_DESCRIPTOR      ((u32)(0x00000100))
+#define LMC_RDES_FIRST_DESCRIPTOR     ((u32)(0x00000200))
+#define LMC_RDES_MULTICAST_FRAME      ((u32)(0x00000400))
+#define LMC_RDES_RUNT_FRAME           ((u32)(0x00000800))
+#define LMC_RDES_DATA_TYPE            ((u32)(0x00003000))
+#define LMC_RDES_LENGTH_ERROR         ((u32)(0x00004000))
+#define LMC_RDES_ERROR_SUMMARY        ((u32)(0x00008000))
+#define LMC_RDES_FRAME_LENGTH         ((u32)(0x3FFF0000))
+#define LMC_RDES_OWN_BIT              ((u32)(0x80000000))
 
 #define RDES_FRAME_LENGTH_BIT_NUMBER       16
 
-#define LMC_RDES_ERROR_MASK ( (u_int32_t)( \
+#define LMC_RDES_ERROR_MASK ( (u32)( \
 	  LMC_RDES_OVERFLOW \
 	| LMC_RDES_DRIBBLING_BIT \
 	| LMC_RDES_REPORT_ON_MII_ERR \
@@ -172,32 +150,32 @@ struct lmc_regfile_t {
  */
 
 typedef struct {
-	u_int32_t	n;
-	u_int32_t	m;
-	u_int32_t	v;
-	u_int32_t	x;
-	u_int32_t	r;
-	u_int32_t	f;
-	u_int32_t	exact;
+	u32	n;
+	u32	m;
+	u32	v;
+	u32	x;
+	u32	r;
+	u32	f;
+	u32	exact;
 } lmc_av9110_t;
 
 /*
  * Common structure passed to the ioctl code.
  */
 struct lmc___ctl {
-	u_int32_t	cardtype;
-	u_int32_t	clock_source;		/* HSSI, T1 */
-	u_int32_t	clock_rate;		/* T1 */
-	u_int32_t	crc_length;
-	u_int32_t	cable_length;		/* DS3 */
-	u_int32_t	scrambler_onoff;	/* DS3 */
-	u_int32_t	cable_type;		/* T1 */
-	u_int32_t	keepalive_onoff;	/* protocol */
-	u_int32_t	ticks;			/* ticks/sec */
+	u32	cardtype;
+	u32	clock_source;		/* HSSI, T1 */
+	u32	clock_rate;		/* T1 */
+	u32	crc_length;
+	u32	cable_length;		/* DS3 */
+	u32	scrambler_onoff;	/* DS3 */
+	u32	cable_type;		/* T1 */
+	u32	keepalive_onoff;	/* protocol */
+	u32	ticks;			/* ticks/sec */
 	union {
 		lmc_av9110_t	ssi;
 	} cardspec;
-	u_int32_t       circuit_type;   /* T1 or E1 */
+	u32       circuit_type;   /* T1 or E1 */
 };
 
 
@@ -244,108 +222,69 @@ struct lmc___media {
 
 #define STATCHECK     0xBEEFCAFE
 
-/*  Included in this structure are first
- *   - standard net_device_stats
- *   - some other counters used for debug and driver performance
- *  evaluation -baz
- */
-struct lmc_statistics
+struct lmc_extra_statistics
 {
-        unsigned long     rx_packets;             /* total packets received       */
-        unsigned long     tx_packets;             /* total packets transmitted    */
-	unsigned long     rx_bytes;
-        unsigned long     tx_bytes;
-        
-        unsigned long     rx_errors;              /* bad packets received         */
-        unsigned long     tx_errors;              /* packet transmit problems     */
-        unsigned long     rx_dropped;             /* no space in linux buffers    */
-        unsigned long     tx_dropped;             /* no space available in linux  */
-        unsigned long     multicast;              /* multicast packets received   */
-        unsigned long     collisions;
-
-        /* detailed rx_errors: */
-        unsigned long     rx_length_errors;
-        unsigned long     rx_over_errors;         /* receiver ring buff overflow  */
-        unsigned long     rx_crc_errors;          /* recved pkt with crc error    */
-        unsigned long     rx_frame_errors;        /* recv'd frame alignment error */
-        unsigned long     rx_fifo_errors;         /* recv'r fifo overrun          */
-        unsigned long     rx_missed_errors;       /* receiver missed packet       */
-
-        /* detailed tx_errors */
-        unsigned long     tx_aborted_errors;
-        unsigned long     tx_carrier_errors;
-        unsigned long     tx_fifo_errors;
-        unsigned long     tx_heartbeat_errors;
-        unsigned long     tx_window_errors;
-
-        /* for cslip etc */
-        unsigned long rx_compressed;
-        unsigned long tx_compressed;
-
-        /* -------------------------------------
-         * Custom stats & counters follow -baz */
-        u_int32_t       version_size;
-        u_int32_t       lmc_cardtype;
-
-        u_int32_t       tx_ProcTimeout;
-        u_int32_t       tx_IntTimeout;
-        u_int32_t       tx_NoCompleteCnt;
-        u_int32_t       tx_MaxXmtsB4Int;
-        u_int32_t       tx_TimeoutCnt;
-        u_int32_t       tx_OutOfSyncPtr;
-        u_int32_t       tx_tbusy0;
-        u_int32_t       tx_tbusy1;
-        u_int32_t       tx_tbusy_calls;
-        u_int32_t       resetCount;
-        u_int32_t       lmc_txfull;
-        u_int32_t       tbusy;
-        u_int32_t       dirtyTx;
-        u_int32_t       lmc_next_tx;
-        u_int32_t       otherTypeCnt;
-        u_int32_t       lastType;
-        u_int32_t       lastTypeOK;
-        u_int32_t       txLoopCnt;
-        u_int32_t       usedXmtDescripCnt;
-        u_int32_t       txIndexCnt;
-        u_int32_t       rxIntLoopCnt;
-
-        u_int32_t       rx_SmallPktCnt;
-        u_int32_t       rx_BadPktSurgeCnt;
-        u_int32_t       rx_BuffAllocErr;
-        u_int32_t       tx_lossOfClockCnt;
-
-        /* T1 error counters */
-        u_int32_t       framingBitErrorCount;
-        u_int32_t       lineCodeViolationCount;
-
-        u_int32_t       lossOfFrameCount;
-        u_int32_t       changeOfFrameAlignmentCount;
-        u_int32_t       severelyErroredFrameCount;
-
-        u_int32_t       check;
+	u32       version_size;
+	u32       lmc_cardtype;
+
+	u32       tx_ProcTimeout;
+	u32       tx_IntTimeout;
+	u32       tx_NoCompleteCnt;
+	u32       tx_MaxXmtsB4Int;
+	u32       tx_TimeoutCnt;
+	u32       tx_OutOfSyncPtr;
+	u32       tx_tbusy0;
+	u32       tx_tbusy1;
+	u32       tx_tbusy_calls;
+	u32       resetCount;
+	u32       lmc_txfull;
+	u32       tbusy;
+	u32       dirtyTx;
+	u32       lmc_next_tx;
+	u32       otherTypeCnt;
+	u32       lastType;
+	u32       lastTypeOK;
+	u32       txLoopCnt;
+	u32       usedXmtDescripCnt;
+	u32       txIndexCnt;
+	u32       rxIntLoopCnt;
+
+	u32       rx_SmallPktCnt;
+	u32       rx_BadPktSurgeCnt;
+	u32       rx_BuffAllocErr;
+	u32       tx_lossOfClockCnt;
+
+	/* T1 error counters */
+	u32       framingBitErrorCount;
+	u32       lineCodeViolationCount;
+
+	u32       lossOfFrameCount;
+	u32       changeOfFrameAlignmentCount;
+	u32       severelyErroredFrameCount;
+
+	u32       check;
 };
 
-
 typedef struct lmc_xinfo {
-        u_int32_t       Magic0;                         /* BEEFCAFE */
+	u32       Magic0;                         /* BEEFCAFE */
 
-        u_int32_t       PciCardType;
-        u_int32_t       PciSlotNumber;          /* PCI slot number       */
+	u32       PciCardType;
+	u32       PciSlotNumber;          /* PCI slot number       */
 
-        u_int16_t       DriverMajorVersion;
-        u_int16_t       DriverMinorVersion;
-        u_int16_t       DriverSubVersion;
+	u16	       DriverMajorVersion;
+	u16	       DriverMinorVersion;
+	u16	       DriverSubVersion;
 
-        u_int16_t       XilinxRevisionNumber;
-        u_int16_t       MaxFrameSize;
+	u16	       XilinxRevisionNumber;
+	u16	       MaxFrameSize;
 
-        u_int16_t       t1_alarm1_status;
-        u_int16_t       t1_alarm2_status;
+	u16     	  t1_alarm1_status;
+	u16       	t1_alarm2_status;
 
-        int                     link_status;
-        u_int32_t       mii_reg16;
+	int             link_status;
+	u32       mii_reg16;
 
-        u_int32_t       Magic1;                         /* DEADBEEF */
+	u32       Magic1;                         /* DEADBEEF */
 } LMC_XINFO;
 
 
@@ -353,23 +292,22 @@ typedef struct lmc_xinfo {
  * forward decl
  */
 struct lmc___softc {
-        void *if_ptr;   /* General purpose pointer (used by SPPP) */
 	char                   *name;
 	u8			board_idx;
-	struct lmc_statistics   stats;
-	struct net_device          *lmc_device;
+	struct lmc_extra_statistics extra_stats;
+	struct net_device      *lmc_device;
 
 	int                     hang, rxdesc, bad_packet, some_counter;
-	u_int32_t               txgo;
+	u32  	         	txgo;
 	struct lmc_regfile_t	lmc_csrs;
-	volatile u_int32_t	lmc_txtick;
-	volatile u_int32_t	lmc_rxtick;
-	u_int32_t		lmc_flags;
-	u_int32_t		lmc_intrmask;	/* our copy of csr_intr */
-	u_int32_t		lmc_cmdmode;	/* our copy of csr_cmdmode */
-	u_int32_t		lmc_busmode;	/* our copy of csr_busmode */
-	u_int32_t		lmc_gpio_io;	/* state of in/out settings */
-	u_int32_t		lmc_gpio;	/* state of outputs */
+	volatile u32		lmc_txtick;
+	volatile u32		lmc_rxtick;
+	u32			lmc_flags;
+	u32			lmc_intrmask;	/* our copy of csr_intr */
+	u32			lmc_cmdmode;	/* our copy of csr_cmdmode */
+	u32			lmc_busmode;	/* our copy of csr_busmode */
+	u32			lmc_gpio_io;	/* state of in/out settings */
+	u32			lmc_gpio;	/* state of outputs */
 	struct sk_buff*		lmc_txq[LMC_TXDESCS];
 	struct sk_buff*		lmc_rxq[LMC_RXDESCS];
 	volatile
@@ -381,42 +319,41 @@ struct lmc___softc {
 	unsigned int		lmc_taint_tx, lmc_taint_rx;
 	int			lmc_tx_start, lmc_txfull;
 	int			lmc_txbusy;
-	u_int16_t		lmc_miireg16;
+	u16			lmc_miireg16;
 	int			lmc_ok;
 	int			last_link_status;
 	int			lmc_cardtype;
-	u_int32_t               last_frameerr;
+	u32               	last_frameerr;
 	lmc_media_t	       *lmc_media;
 	struct timer_list	timer;
 	lmc_ctl_t		ictl;
-	u_int32_t		TxDescriptControlInit;  
+	u32			TxDescriptControlInit;
 
 	int                     tx_TimeoutInd; /* additional driver state */
 	int                     tx_TimeoutDisplay;
 	unsigned int		lastlmc_taint_tx;
 	int                     lasttx_packets;
-	u_int32_t		tx_clockState;
-	u_int32_t		lmc_crcSize;
-	LMC_XINFO		lmc_xinfo; 
+	u32			tx_clockState;
+	u32			lmc_crcSize;
+	LMC_XINFO		lmc_xinfo;
 	char                    lmc_yel, lmc_blue, lmc_red; /* for T1 and DS3 */
-        char                    lmc_timing; /* for HSSI and SSI */
-        int                     got_irq;
+	char                    lmc_timing; /* for HSSI and SSI */
+	int                     got_irq;
 
-        char                    last_led_err[4];
+	char                    last_led_err[4];
 
-        u32                     last_int;
-        u32                     num_int;
+	u32                     last_int;
+	u32                     num_int;
 
 	spinlock_t              lmc_lock;
-        u_int16_t               if_type;       /* PPP or NET */
-        struct ppp_device       *pd;
+	u16			if_type;       /* HDLC/PPP or NET */
 
-        /* Failure cases */
-        u8                       failed_ring;
-        u8                       failed_recv_alloc;
+	/* Failure cases */
+	u8			failed_ring;
+	u8			failed_recv_alloc;
 
-        /* Structure check */
-        u32                     check;
+	/* Structure check */
+	u32                     check;
 };
 
 #define LMC_PCI_TIME 1
@@ -512,8 +449,8 @@ struct lmc___softc {
   | TULIP_STS_TXUNDERFLOW\
   | TULIP_STS_RXSTOPPED )
 
-#define DESC_OWNED_BY_SYSTEM   ((u_int32_t)(0x00000000))
-#define DESC_OWNED_BY_DC21X4   ((u_int32_t)(0x80000000))
+#define DESC_OWNED_BY_SYSTEM   ((u32)(0x00000000))
+#define DESC_OWNED_BY_DC21X4   ((u32)(0x80000000))
 
 #ifndef TULIP_CMD_RECEIVEALL
 #define TULIP_CMD_RECEIVEALL 0x40000000L
@@ -525,46 +462,9 @@ struct lmc___softc {
 #define LMC_ADAP_SSI            4
 #define LMC_ADAP_T1             5
 
-#define HDLC_HDR_LEN  4
-#define HDLC_ADDR_LEN 1
-#define HDLC_SLARP    0x8035
 #define LMC_MTU 1500
-#define SLARP_LINECHECK 2
 
 #define LMC_CRC_LEN_16 2  /* 16-bit CRC */
 #define LMC_CRC_LEN_32 4
 
-#ifdef LMC_HDLC
-/* definition of an hdlc header. */
-struct hdlc_hdr
-{
-	u8  address;
-	u8  control;
-	u16 type;
-};
-
-/* definition of a slarp header. */
-struct slarp
-{
-	long code;
-	union sl
-	{
-		struct
-		{
-			ulong address;
-			ulong mask;
-			ushort unused;
-		} add;
-		struct
-		{
-			ulong mysequence;
-			ulong yoursequence;
-			ushort reliability;
-			ulong time;
-		} chk;
-	} t;
-};
-#endif /* LMC_HDLC */
-
-
 #endif /* _LMC_VAR_H_ */
diff --git a/drivers/net/wan/pc300.h b/drivers/net/wan/pc300.h
index 63e9fcf..2e4f84f 100644
--- a/drivers/net/wan/pc300.h
+++ b/drivers/net/wan/pc300.h
@@ -100,31 +100,14 @@
 #define	_PC300_H
 
 #include <linux/hdlc.h>
-#include <net/syncppp.h>
 #include "hd64572.h"
 #include "pc300-falc-lh.h"
 
-#ifndef CY_TYPES
-#define CY_TYPES
-typedef	__u64	ucdouble;	/* 64 bits, unsigned */
-typedef	__u32	uclong;		/* 32 bits, unsigned */
-typedef	__u16	ucshort;	/* 16 bits, unsigned */
-typedef	__u8	ucchar;		/* 8 bits, unsigned */
-#endif /* CY_TYPES */
+#define PC300_PROTO_MLPPP 1
 
-#define PC300_PROTO_MLPPP 1		
-
-#define PC300_KERNEL	"2.4.x"	/* Kernel supported by this driver */
-
-#define	PC300_DEVNAME	"hdlc"	/* Dev. name base (for hdlc0, hdlc1, etc.) */
-#define PC300_MAXINDEX	100	/* Max dev. name index (the '0' in hdlc0) */
-
-#define	PC300_MAXCARDS	4	/* Max number of cards per system */
 #define	PC300_MAXCHAN	2	/* Number of channels per card */
 
-#define	PC300_PLX_WIN	0x80    /* PLX control window size (128b) */
 #define	PC300_RAMSIZE	0x40000 /* RAM window size (256Kb) */
-#define	PC300_SCASIZE	0x400   /* SCA window size (1Kb) */
 #define	PC300_FALCSIZE	0x400	/* FALC window size (1Kb) */
 
 #define PC300_OSC_CLOCK	24576000
@@ -160,26 +143,14 @@ typedef	__u8	ucchar;		/* 8 bits, unsigned */
  * Memory access functions/macros      *
  * (required to support Alpha systems) *
  ***************************************/
-#ifdef __KERNEL__
-#define cpc_writeb(port,val)	{writeb((ucchar)(val),(port)); mb();}
+#define cpc_writeb(port,val)	{writeb((u8)(val),(port)); mb();}
 #define cpc_writew(port,val)	{writew((ushort)(val),(port)); mb();}
-#define cpc_writel(port,val)	{writel((uclong)(val),(port)); mb();}
+#define cpc_writel(port,val)	{writel((u32)(val),(port)); mb();}
 
 #define cpc_readb(port)		readb(port)
 #define cpc_readw(port)		readw(port)
 #define cpc_readl(port)		readl(port)
 
-#else /* __KERNEL__ */
-#define cpc_writeb(port,val)	(*(volatile ucchar *)(port) = (ucchar)(val))
-#define cpc_writew(port,val)	(*(volatile ucshort *)(port) = (ucshort)(val))
-#define cpc_writel(port,val)	(*(volatile uclong *)(port) = (uclong)(val))
-
-#define cpc_readb(port)		(*(volatile ucchar *)(port))
-#define cpc_readw(port)		(*(volatile ucshort *)(port))
-#define cpc_readl(port)		(*(volatile uclong *)(port))
-
-#endif /* __KERNEL__ */
-
 /****** Data Structures *****************************************************/
 
 /*
@@ -188,15 +159,15 @@ typedef	__u8	ucchar;		/* 8 bits, unsigned */
  *      (memory mapped).
  */
 struct RUNTIME_9050 {
-	uclong	loc_addr_range[4];	/* 00-0Ch : Local Address Ranges */
-	uclong	loc_rom_range;		/* 10h : Local ROM Range */
-	uclong	loc_addr_base[4];	/* 14-20h : Local Address Base Addrs */
-	uclong	loc_rom_base;		/* 24h : Local ROM Base */
-	uclong	loc_bus_descr[4];	/* 28-34h : Local Bus Descriptors */
-	uclong	rom_bus_descr;		/* 38h : ROM Bus Descriptor */
-	uclong	cs_base[4];		/* 3C-48h : Chip Select Base Addrs */
-	uclong	intr_ctrl_stat;		/* 4Ch : Interrupt Control/Status */
-	uclong	init_ctrl;		/* 50h : EEPROM ctrl, Init Ctrl, etc */
+	u32 loc_addr_range[4];	/* 00-0Ch : Local Address Ranges */
+	u32 loc_rom_range;	/* 10h : Local ROM Range */
+	u32 loc_addr_base[4];	/* 14-20h : Local Address Base Addrs */
+	u32 loc_rom_base;	/* 24h : Local ROM Base */
+	u32 loc_bus_descr[4];	/* 28-34h : Local Bus Descriptors */
+	u32 rom_bus_descr;	/* 38h : ROM Bus Descriptor */
+	u32 cs_base[4];		/* 3C-48h : Chip Select Base Addrs */
+	u32 intr_ctrl_stat;	/* 4Ch : Interrupt Control/Status */
+	u32 init_ctrl;		/* 50h : EEPROM ctrl, Init Ctrl, etc */
 };
 
 #define PLX_9050_LINT1_ENABLE	0x01
@@ -240,66 +211,66 @@ struct RUNTIME_9050 {
 #define PC300_FALC_MAXLOOP	0x0000ffff	/* for falc_issue_cmd() */
 
 typedef struct falc {
-	ucchar sync;		/* If true FALC is synchronized */
-	ucchar active;		/* if TRUE then already active */
-	ucchar loop_active;	/* if TRUE a line loopback UP was received */
-	ucchar loop_gen;	/* if TRUE a line loopback UP was issued */
+	u8 sync;	/* If true FALC is synchronized */
+	u8 active;	/* if TRUE then already active */
+	u8 loop_active;	/* if TRUE a line loopback UP was received */
+	u8 loop_gen;	/* if TRUE a line loopback UP was issued */
 
-	ucchar num_channels;
-	ucchar offset;		/* 1 for T1, 0 for E1 */
-	ucchar full_bandwidth;
+	u8 num_channels;
+	u8 offset;	/* 1 for T1, 0 for E1 */
+	u8 full_bandwidth;
 
-	ucchar xmb_cause;
-	ucchar multiframe_mode;
+	u8 xmb_cause;
+	u8 multiframe_mode;
 
 	/* Statistics */
-	ucshort pden;	/* Pulse Density violation count */
-	ucshort los;	/* Loss of Signal count */
-	ucshort losr;	/* Loss of Signal recovery count */
-	ucshort lfa;	/* Loss of frame alignment count */
-	ucshort farec;	/* Frame Alignment Recovery count */
-	ucshort lmfa;	/* Loss of multiframe alignment count */
-	ucshort ais;	/* Remote Alarm indication Signal count */
-	ucshort sec;	/* One-second timer */
-	ucshort es;	/* Errored second */
-	ucshort rai;	/* remote alarm received */
-	ucshort bec;
-	ucshort fec;
-	ucshort cvc;
-	ucshort cec;
-	ucshort ebc;
+	u16 pden;	/* Pulse Density violation count */
+	u16 los;	/* Loss of Signal count */
+	u16 losr;	/* Loss of Signal recovery count */
+	u16 lfa;	/* Loss of frame alignment count */
+	u16 farec;	/* Frame Alignment Recovery count */
+	u16 lmfa;	/* Loss of multiframe alignment count */
+	u16 ais;	/* Remote Alarm indication Signal count */
+	u16 sec;	/* One-second timer */
+	u16 es;		/* Errored second */
+	u16 rai;	/* remote alarm received */
+	u16 bec;
+	u16 fec;
+	u16 cvc;
+	u16 cec;
+	u16 ebc;
 
 	/* Status */
-	ucchar red_alarm;
-	ucchar blue_alarm;
-	ucchar loss_fa;
-	ucchar yellow_alarm;
-	ucchar loss_mfa;
-	ucchar prbs;
+	u8 red_alarm;
+	u8 blue_alarm;
+	u8 loss_fa;
+	u8 yellow_alarm;
+	u8 loss_mfa;
+	u8 prbs;
 } falc_t;
 
 typedef struct falc_status {
-	ucchar sync;  /* If true FALC is synchronized */
-	ucchar red_alarm;
-	ucchar blue_alarm;
-	ucchar loss_fa;
-	ucchar yellow_alarm;
-	ucchar loss_mfa;
-	ucchar prbs;
+	u8 sync;	/* If true FALC is synchronized */
+	u8 red_alarm;
+	u8 blue_alarm;
+	u8 loss_fa;
+	u8 yellow_alarm;
+	u8 loss_mfa;
+	u8 prbs;
 } falc_status_t;
 
 typedef struct rsv_x21_status {
-	ucchar dcd;
-	ucchar dsr;
-	ucchar cts;
-	ucchar rts;
-	ucchar dtr;
+	u8 dcd;
+	u8 dsr;
+	u8 cts;
+	u8 rts;
+	u8 dtr;
 } rsv_x21_status_t;
 
 typedef struct pc300stats {
 	int hw_type;
-	uclong line_on;
-	uclong line_off;
+	u32 line_on;
+	u32 line_off;
 	struct net_device_stats gen_stats;
 	falc_t te_stats;
 } pc300stats_t;
@@ -317,28 +288,19 @@ typedef struct pc300loopback {
 
 typedef struct pc300patterntst {
 	char patrntst_on;       /* 0 - off; 1 - on; 2 - read num_errors */
-	ucshort num_errors;
+	u16 num_errors;
 } pc300patterntst_t;
 
 typedef struct pc300dev {
-	void *if_ptr;		/* General purpose pointer */
 	struct pc300ch *chan;
-	ucchar trace_on;
-	uclong line_on;		/* DCD(X.21, RSV) / sync(TE) change counters */
-	uclong line_off;
-#ifdef __KERNEL__
+	u8 trace_on;
+	u32 line_on;		/* DCD(X.21, RSV) / sync(TE) change counters */
+	u32 line_off;
 	char name[16];
 	struct net_device *dev;
-
-	void *private;
-	struct sk_buff *tx_skb;
-	union {	/* This union has all the protocol-specific structures */
-		struct ppp_device pppdev;
-	}ifu;
 #ifdef CONFIG_PC300_MLPPP
 	void *cpc_tty;	/* information to PC300 TTY driver */
 #endif
-#endif /* __KERNEL__ */
 }pc300dev_t;
 
 typedef struct pc300hw {
@@ -346,43 +308,42 @@ typedef struct pc300hw {
 	int bus;		/* Bus (PCI, PMC, etc.) */
 	int nchan;		/* number of channels */
 	int irq;		/* interrupt request level */
-	uclong clock;		/* Board clock */
-	ucchar cpld_id;		/* CPLD ID (TE only) */
-	ucshort cpld_reg1;	/* CPLD reg 1 (TE only) */
-	ucshort cpld_reg2;	/* CPLD reg 2 (TE only) */
-	ucshort gpioc_reg;	/* PLX GPIOC reg */
-	ucshort intctl_reg;	/* PLX Int Ctrl/Status reg */
-	uclong iophys;		/* PLX registers I/O base */
-	uclong iosize;		/* PLX registers I/O size */
-	uclong plxphys;		/* PLX registers MMIO base (physical) */
+	u32 clock;		/* Board clock */
+	u8 cpld_id;		/* CPLD ID (TE only) */
+	u16 cpld_reg1;		/* CPLD reg 1 (TE only) */
+	u16 cpld_reg2;		/* CPLD reg 2 (TE only) */
+	u16 gpioc_reg;		/* PLX GPIOC reg */
+	u16 intctl_reg;		/* PLX Int Ctrl/Status reg */
+	u32 iophys;		/* PLX registers I/O base */
+	u32 iosize;		/* PLX registers I/O size */
+	u32 plxphys;		/* PLX registers MMIO base (physical) */
 	void __iomem * plxbase;	/* PLX registers MMIO base (virtual) */
-	uclong plxsize;		/* PLX registers MMIO size */
-	uclong scaphys;		/* SCA registers MMIO base (physical) */
+	u32 plxsize;		/* PLX registers MMIO size */
+	u32 scaphys;		/* SCA registers MMIO base (physical) */
 	void __iomem * scabase;	/* SCA registers MMIO base (virtual) */
-	uclong scasize;		/* SCA registers MMIO size */
-	uclong ramphys;		/* On-board RAM MMIO base (physical) */
+	u32 scasize;		/* SCA registers MMIO size */
+	u32 ramphys;		/* On-board RAM MMIO base (physical) */
 	void __iomem * rambase;	/* On-board RAM MMIO base (virtual) */
-	uclong alloc_ramsize;	/* RAM MMIO size allocated by the PCI bridge */
-	uclong ramsize;		/* On-board RAM MMIO size */
-	uclong falcphys;	/* FALC registers MMIO base (physical) */
+	u32 alloc_ramsize;	/* RAM MMIO size allocated by the PCI bridge */
+	u32 ramsize;		/* On-board RAM MMIO size */
+	u32 falcphys;		/* FALC registers MMIO base (physical) */
 	void __iomem * falcbase;/* FALC registers MMIO base (virtual) */
-	uclong falcsize;	/* FALC registers MMIO size */
+	u32 falcsize;		/* FALC registers MMIO size */
 } pc300hw_t;
 
 typedef struct pc300chconf {
-	sync_serial_settings	phys_settings;	/* Clock type/rate (in bps), 
+	sync_serial_settings	phys_settings;	/* Clock type/rate (in bps),
 						   loopback mode */
 	raw_hdlc_proto		proto_settings;	/* Encoding, parity (CRC) */
-	uclong media;		/* HW media (RS232, V.35, etc.) */
-	uclong proto;		/* Protocol (PPP, X.25, etc.) */
-	ucchar monitor;		/* Monitor mode (0 = off, !0 = on) */
+	u32 media;		/* HW media (RS232, V.35, etc.) */
+	u32 proto;		/* Protocol (PPP, X.25, etc.) */
 
 	/* TE-specific parameters */
-	ucchar lcode;		/* Line Code (AMI, B8ZS, etc.) */
-	ucchar fr_mode;		/* Frame Mode (ESF, D4, etc.) */
-	ucchar lbo;		/* Line Build Out */
-	ucchar rx_sens;		/* Rx Sensitivity (long- or short-haul) */
-	uclong tslot_bitmap;	/* bit[i]=1  =>  timeslot _i_ is active */
+	u8 lcode;		/* Line Code (AMI, B8ZS, etc.) */
+	u8 fr_mode;		/* Frame Mode (ESF, D4, etc.) */
+	u8 lbo;			/* Line Build Out */
+	u8 rx_sens;		/* Rx Sensitivity (long- or short-haul) */
+	u32 tslot_bitmap;	/* bit[i]=1  =>  timeslot _i_ is active */
 } pc300chconf_t;
 
 typedef struct pc300ch {
@@ -390,20 +351,18 @@ typedef struct pc300ch {
 	int channel;
 	pc300dev_t d;
 	pc300chconf_t conf;
-	ucchar tx_first_bd;	/* First TX DMA block descr. w/ data */
-	ucchar tx_next_bd;	/* Next free TX DMA block descriptor */
-	ucchar rx_first_bd;	/* First free RX DMA block descriptor */
-	ucchar rx_last_bd;	/* Last free RX DMA block descriptor */
-	ucchar nfree_tx_bd;	/* Number of free TX DMA block descriptors */
-	falc_t falc;		/* FALC structure (TE only) */
+	u8 tx_first_bd;	/* First TX DMA block descr. w/ data */
+	u8 tx_next_bd;	/* Next free TX DMA block descriptor */
+	u8 rx_first_bd;	/* First free RX DMA block descriptor */
+	u8 rx_last_bd;	/* Last free RX DMA block descriptor */
+	u8 nfree_tx_bd;	/* Number of free TX DMA block descriptors */
+	falc_t falc;	/* FALC structure (TE only) */
 } pc300ch_t;
 
 typedef struct pc300 {
 	pc300hw_t hw;			/* hardware config. */
 	pc300ch_t chan[PC300_MAXCHAN];
-#ifdef __KERNEL__
 	spinlock_t card_lock;
-#endif /* __KERNEL__ */
 } pc300_t;
 
 typedef struct pc300conf {
@@ -471,12 +430,7 @@ enum pc300_loopback_cmds {
 #define PC300_TX_QUEUE_LEN	100
 #define	PC300_DEF_MTU		1600
 
-#ifdef __KERNEL__
 /* Function Prototypes */
-void tx_dma_start(pc300_t *, int);
 int cpc_open(struct net_device *dev);
-int cpc_set_media(hdlc_device *, int);
-#endif /* __KERNEL__ */
 
 #endif	/* _PC300_H */
-
diff --git a/drivers/net/wan/pc300_drv.c b/drivers/net/wan/pc300_drv.c
index 3341705..d0a8d1e 100644
--- a/drivers/net/wan/pc300_drv.c
+++ b/drivers/net/wan/pc300_drv.c
@@ -227,8 +227,6 @@ static char rcsid[] =
 #include <linux/netdevice.h>
 #include <linux/spinlock.h>
 #include <linux/if.h>
-
-#include <net/syncppp.h>
 #include <net/arp.h>
 
 #include <asm/io.h>
@@ -285,8 +283,8 @@ static void rx_dma_buf_init(pc300_t *, int);
 static void tx_dma_buf_check(pc300_t *, int);
 static void rx_dma_buf_check(pc300_t *, int);
 static irqreturn_t cpc_intr(int, void *);
-static int clock_rate_calc(uclong, uclong, int *);
-static uclong detect_ram(pc300_t *);
+static int clock_rate_calc(u32, u32, int *);
+static u32 detect_ram(pc300_t *);
 static void plx_init(pc300_t *);
 static void cpc_trace(struct net_device *, struct sk_buff *, char);
 static int cpc_attach(struct net_device *, unsigned short, unsigned short);
@@ -311,10 +309,10 @@ static void tx_dma_buf_pt_init(pc300_t * card, int ch)
 			               + DMA_TX_BD_BASE + ch_factor * sizeof(pcsca_bd_t));
 
 	for (i = 0; i < N_DMA_TX_BUF; i++, ptdescr++) {
-		cpc_writel(&ptdescr->next, (uclong) (DMA_TX_BD_BASE +
+		cpc_writel(&ptdescr->next, (u32)(DMA_TX_BD_BASE +
 			(ch_factor + ((i + 1) & (N_DMA_TX_BUF - 1))) * sizeof(pcsca_bd_t)));
-		cpc_writel(&ptdescr->ptbuf, 
-						(uclong) (DMA_TX_BASE + (ch_factor + i) * BD_DEF_LEN));
+		cpc_writel(&ptdescr->ptbuf,
+			   (u32)(DMA_TX_BASE + (ch_factor + i) * BD_DEF_LEN));
 	}
 }
 
@@ -341,10 +339,10 @@ static void rx_dma_buf_pt_init(pc300_t * card, int ch)
 				       + DMA_RX_BD_BASE + ch_factor * sizeof(pcsca_bd_t));
 
 	for (i = 0; i < N_DMA_RX_BUF; i++, ptdescr++) {
-		cpc_writel(&ptdescr->next, (uclong) (DMA_RX_BD_BASE +
-	     	(ch_factor + ((i + 1) & (N_DMA_RX_BUF - 1))) * sizeof(pcsca_bd_t)));
+		cpc_writel(&ptdescr->next, (u32)(DMA_RX_BD_BASE +
+			(ch_factor + ((i + 1) & (N_DMA_RX_BUF - 1))) * sizeof(pcsca_bd_t)));
 		cpc_writel(&ptdescr->ptbuf,
-			   (uclong) (DMA_RX_BASE + (ch_factor + i) * BD_DEF_LEN));
+			   (u32)(DMA_RX_BASE + (ch_factor + i) * BD_DEF_LEN));
 	}
 }
 
@@ -367,8 +365,8 @@ static void tx_dma_buf_check(pc300_t * card, int ch)
 {
 	volatile pcsca_bd_t __iomem *ptdescr;
 	int i;
-	ucshort first_bd = card->chan[ch].tx_first_bd;
-	ucshort next_bd = card->chan[ch].tx_next_bd;
+	u16 first_bd = card->chan[ch].tx_first_bd;
+	u16 next_bd = card->chan[ch].tx_next_bd;
 
 	printk("#CH%d: f_bd = %d(0x%08zx), n_bd = %d(0x%08zx)\n", ch,
 	       first_bd, TX_BD_ADDR(ch, first_bd),
@@ -392,9 +390,9 @@ static void tx1_dma_buf_check(pc300_t * card, int ch)
 {
 	volatile pcsca_bd_t __iomem *ptdescr;
 	int i;
-	ucshort first_bd = card->chan[ch].tx_first_bd;
-	ucshort next_bd = card->chan[ch].tx_next_bd;
-	uclong scabase = card->hw.scabase;
+	u16 first_bd = card->chan[ch].tx_first_bd;
+	u16 next_bd = card->chan[ch].tx_next_bd;
+	u32 scabase = card->hw.scabase;
 
 	printk ("\nnfree_tx_bd = %d \n", card->chan[ch].nfree_tx_bd);
 	printk("#CH%d: f_bd = %d(0x%08x), n_bd = %d(0x%08x)\n", ch,
@@ -413,13 +411,13 @@ static void tx1_dma_buf_check(pc300_t * card, int ch)
 	printk("\n");
 }
 #endif
-			 
+
 static void rx_dma_buf_check(pc300_t * card, int ch)
 {
 	volatile pcsca_bd_t __iomem *ptdescr;
 	int i;
-	ucshort first_bd = card->chan[ch].rx_first_bd;
-	ucshort last_bd = card->chan[ch].rx_last_bd;
+	u16 first_bd = card->chan[ch].rx_first_bd;
+	u16 last_bd = card->chan[ch].rx_last_bd;
 	int ch_factor;
 
 	ch_factor = ch * N_DMA_RX_BUF;
@@ -440,9 +438,9 @@ static void rx_dma_buf_check(pc300_t * card, int ch)
 static int dma_get_rx_frame_size(pc300_t * card, int ch)
 {
 	volatile pcsca_bd_t __iomem *ptdescr;
-	ucshort first_bd = card->chan[ch].rx_first_bd;
+	u16 first_bd = card->chan[ch].rx_first_bd;
 	int rcvd = 0;
-	volatile ucchar status;
+	volatile u8 status;
 
 	ptdescr = (card->hw.rambase + RX_BD_ADDR(ch, first_bd));
 	while ((status = cpc_readb(&ptdescr->status)) & DST_OSB) {
@@ -462,12 +460,12 @@ static int dma_get_rx_frame_size(pc300_t * card, int ch)
  * dma_buf_write: writes a frame to the Tx DMA buffers
  * NOTE: this function writes one frame at a time.
  */
-static int dma_buf_write(pc300_t * card, int ch, ucchar * ptdata, int len)
+static int dma_buf_write(pc300_t *card, int ch, u8 *ptdata, int len)
 {
 	int i, nchar;
 	volatile pcsca_bd_t __iomem *ptdescr;
 	int tosend = len;
-	ucchar nbuf = ((len - 1) / BD_DEF_LEN) + 1;
+	u8 nbuf = ((len - 1) / BD_DEF_LEN) + 1;
 
 	if (nbuf >= card->chan[ch].nfree_tx_bd) {
 		return -ENOMEM;
@@ -509,7 +507,7 @@ static int dma_buf_read(pc300_t * card, int ch, struct sk_buff *skb)
 	pc300ch_t *chan = (pc300ch_t *) & card->chan[ch];
 	volatile pcsca_bd_t __iomem *ptdescr;
 	int rcvd = 0;
-	volatile ucchar status;
+	volatile u8 status;
 
 	ptdescr = (card->hw.rambase +
 				  RX_BD_ADDR(ch, chan->rx_first_bd));
@@ -563,8 +561,8 @@ static int dma_buf_read(pc300_t * card, int ch, struct sk_buff *skb)
 static void tx_dma_stop(pc300_t * card, int ch)
 {
 	void __iomem *scabase = card->hw.scabase;
-	ucchar drr_ena_bit = 1 << (5 + 2 * ch);
-	ucchar drr_rst_bit = 1 << (1 + 2 * ch);
+	u8 drr_ena_bit = 1 << (5 + 2 * ch);
+	u8 drr_rst_bit = 1 << (1 + 2 * ch);
 
 	/* Disable DMA */
 	cpc_writeb(scabase + DRR, drr_ena_bit);
@@ -574,8 +572,8 @@ static void tx_dma_stop(pc300_t * card, int ch)
 static void rx_dma_stop(pc300_t * card, int ch)
 {
 	void __iomem *scabase = card->hw.scabase;
-	ucchar drr_ena_bit = 1 << (4 + 2 * ch);
-	ucchar drr_rst_bit = 1 << (2 * ch);
+	u8 drr_ena_bit = 1 << (4 + 2 * ch);
+	u8 drr_rst_bit = 1 << (2 * ch);
 
 	/* Disable DMA */
 	cpc_writeb(scabase + DRR, drr_ena_bit);
@@ -607,7 +605,7 @@ static void rx_dma_start(pc300_t * card, int ch)
 /*************************/
 /***   FALC Routines   ***/
 /*************************/
-static void falc_issue_cmd(pc300_t * card, int ch, ucchar cmd)
+static void falc_issue_cmd(pc300_t *card, int ch, u8 cmd)
 {
 	void __iomem *falcbase = card->hw.falcbase;
 	unsigned long i = 0;
@@ -675,7 +673,7 @@ static void falc_intr_enable(pc300_t * card, int ch)
 static void falc_open_timeslot(pc300_t * card, int ch, int timeslot)
 {
 	void __iomem *falcbase = card->hw.falcbase;
-	ucchar tshf = card->chan[ch].falc.offset;
+	u8 tshf = card->chan[ch].falc.offset;
 
 	cpc_writeb(falcbase + F_REG((ICB1 + (timeslot - tshf) / 8), ch),
 		   cpc_readb(falcbase + F_REG((ICB1 + (timeslot - tshf) / 8), ch)) & 
@@ -691,7 +689,7 @@ static void falc_open_timeslot(pc300_t * card, int ch, int timeslot)
 static void falc_close_timeslot(pc300_t * card, int ch, int timeslot)
 {
 	void __iomem *falcbase = card->hw.falcbase;
-	ucchar tshf = card->chan[ch].falc.offset;
+	u8 tshf = card->chan[ch].falc.offset;
 
 	cpc_writeb(falcbase + F_REG((ICB1 + (timeslot - tshf) / 8), ch),
 		   cpc_readb(falcbase + F_REG((ICB1 + (timeslot - tshf) / 8), ch)) | 
@@ -812,7 +810,7 @@ static void falc_init_t1(pc300_t * card, int ch)
 	pc300chconf_t *conf = (pc300chconf_t *) & chan->conf;
 	falc_t *pfalc = (falc_t *) & chan->falc;
 	void __iomem *falcbase = card->hw.falcbase;
-	ucchar dja = (ch ? (LIM2_DJA2 | LIM2_DJA1) : 0);
+	u8 dja = (ch ? (LIM2_DJA2 | LIM2_DJA1) : 0);
 
 	/* Switch to T1 mode (PCM 24) */
 	cpc_writeb(falcbase + F_REG(FMR1, ch), FMR1_PMOD);
@@ -981,7 +979,7 @@ static void falc_init_e1(pc300_t * card, int ch)
 	pc300chconf_t *conf = (pc300chconf_t *) & chan->conf;
 	falc_t *pfalc = (falc_t *) & chan->falc;
 	void __iomem *falcbase = card->hw.falcbase;
-	ucchar dja = (ch ? (LIM2_DJA2 | LIM2_DJA1) : 0);
+	u8 dja = (ch ? (LIM2_DJA2 | LIM2_DJA1) : 0);
 
 	/* Switch to E1 mode (PCM 30) */
 	cpc_writeb(falcbase + F_REG(FMR1, ch),
@@ -1187,7 +1185,7 @@ static void te_config(pc300_t * card, int ch)
 	pc300chconf_t *conf = (pc300chconf_t *) & chan->conf;
 	falc_t *pfalc = (falc_t *) & chan->falc;
 	void __iomem *falcbase = card->hw.falcbase;
-	ucchar dummy;
+	u8 dummy;
 	unsigned long flags;
 
 	memset(pfalc, 0, sizeof(falc_t));
@@ -1403,7 +1401,7 @@ static void falc_update_stats(pc300_t * card, int ch)
 	pc300chconf_t *conf = (pc300chconf_t *) & chan->conf;
 	falc_t *pfalc = (falc_t *) & chan->falc;
 	void __iomem *falcbase = card->hw.falcbase;
-	ucshort counter;
+	u16 counter;
 
 	counter = cpc_readb(falcbase + F_REG(FECL, ch));
 	counter |= cpc_readb(falcbase + F_REG(FECH, ch)) << 8;
@@ -1729,7 +1727,7 @@ static void falc_pattern_test(pc300_t * card, int ch, unsigned int activate)
  * Description:	This routine returns the bit error counter value
  *----------------------------------------------------------------------------
  */
-static ucshort falc_pattern_test_error(pc300_t * card, int ch)
+static u16 falc_pattern_test_error(pc300_t * card, int ch)
 {
 	pc300ch_t *chan = (pc300ch_t *) & card->chan[ch];
 	falc_t *pfalc = (falc_t *) & chan->falc;
@@ -1776,7 +1774,7 @@ static void cpc_tx_timeout(struct net_device *dev)
 	pc300_t *card = (pc300_t *) chan->card;
 	int ch = chan->channel;
 	unsigned long flags;
-	ucchar ilar;
+	u8 ilar;
 
 	dev->stats.tx_errors++;
 	dev->stats.tx_aborted_errors++;
@@ -1807,11 +1805,7 @@ static int cpc_queue_xmit(struct sk_buff *skb, struct net_device *dev)
 	int i;
 #endif
 
-	if (chan->conf.monitor) {
-		/* In monitor mode no Tx is done: ignore packet */
-		dev_kfree_skb(skb);
-		return 0;
-	} else if (!netif_carrier_ok(dev)) {
+	if (!netif_carrier_ok(dev)) {
 		/* DCD must be OFF: drop packet */
 		dev_kfree_skb(skb);
 		dev->stats.tx_errors++;
@@ -1836,7 +1830,7 @@ static int cpc_queue_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	/* Write buffer to DMA buffers */
-	if (dma_buf_write(card, ch, (ucchar *) skb->data, skb->len) != 0) {
+	if (dma_buf_write(card, ch, (u8 *)skb->data, skb->len) != 0) {
 //		printk("%s: write error. Dropping TX packet.\n", dev->name);
 		netif_stop_queue(dev);
 		dev_kfree_skb(skb);
@@ -2001,7 +1995,7 @@ static void sca_tx_intr(pc300dev_t *dev)
 static void sca_intr(pc300_t * card)
 {
 	void __iomem *scabase = card->hw.scabase;
-	volatile uclong status;
+	volatile u32 status;
 	int ch;
 	int intr_count = 0;
 	unsigned char dsr_rx;
@@ -2016,7 +2010,7 @@ static void sca_intr(pc300_t * card)
 
 	    /**** Reception ****/
 			if (status & IR0_DRX((IR0_DMIA | IR0_DMIB), ch)) {
-				ucchar drx_stat = cpc_readb(scabase + DSR_RX(ch));
+				u8 drx_stat = cpc_readb(scabase + DSR_RX(ch));
 
 				/* Clear RX interrupts */
 				cpc_writeb(scabase + DSR_RX(ch), drx_stat | DSR_DWE);
@@ -2090,7 +2084,7 @@ static void sca_intr(pc300_t * card)
 
 	    /**** Transmission ****/
 			if (status & IR0_DTX((IR0_EFT | IR0_DMIA | IR0_DMIB), ch)) {
-				ucchar dtx_stat = cpc_readb(scabase + DSR_TX(ch));
+				u8 dtx_stat = cpc_readb(scabase + DSR_TX(ch));
 
 				/* Clear TX interrupts */
 				cpc_writeb(scabase + DSR_TX(ch), dtx_stat | DSR_DWE);
@@ -2134,7 +2128,7 @@ static void sca_intr(pc300_t * card)
 
 	    /**** MSCI ****/
 			if (status & IR0_M(IR0_RXINTA, ch)) {
-				ucchar st1 = cpc_readb(scabase + M_REG(ST1, ch));
+				u8 st1 = cpc_readb(scabase + M_REG(ST1, ch));
 
 				/* Clear MSCI interrupts */
 				cpc_writeb(scabase + M_REG(ST1, ch), st1);
@@ -2176,7 +2170,7 @@ static void sca_intr(pc300_t * card)
 	}
 }
 
-static void falc_t1_loop_detection(pc300_t * card, int ch, ucchar frs1)
+static void falc_t1_loop_detection(pc300_t *card, int ch, u8 frs1)
 {
 	pc300ch_t *chan = (pc300ch_t *) & card->chan[ch];
 	falc_t *pfalc = (falc_t *) & chan->falc;
@@ -2201,7 +2195,7 @@ static void falc_t1_loop_detection(pc300_t * card, int ch, ucchar frs1)
 	}
 }
 
-static void falc_e1_loop_detection(pc300_t * card, int ch, ucchar rsp)
+static void falc_e1_loop_detection(pc300_t *card, int ch, u8 rsp)
 {
 	pc300ch_t *chan = (pc300ch_t *) & card->chan[ch];
 	falc_t *pfalc = (falc_t *) & chan->falc;
@@ -2231,8 +2225,8 @@ static void falc_t1_intr(pc300_t * card, int ch)
 	pc300ch_t *chan = (pc300ch_t *) & card->chan[ch];
 	falc_t *pfalc = (falc_t *) & chan->falc;
 	void __iomem *falcbase = card->hw.falcbase;
-	ucchar isr0, isr3, gis;
-	ucchar dummy;
+	u8 isr0, isr3, gis;
+	u8 dummy;
 
 	while ((gis = cpc_readb(falcbase + F_REG(GIS, ch))) != 0) {
 		if (gis & GIS_ISR0) {
@@ -2278,8 +2272,8 @@ static void falc_e1_intr(pc300_t * card, int ch)
 	pc300ch_t *chan = (pc300ch_t *) & card->chan[ch];
 	falc_t *pfalc = (falc_t *) & chan->falc;
 	void __iomem *falcbase = card->hw.falcbase;
-	ucchar isr1, isr2, isr3, gis, rsp;
-	ucchar dummy;
+	u8 isr1, isr2, isr3, gis, rsp;
+	u8 dummy;
 
 	while ((gis = cpc_readb(falcbase + F_REG(GIS, ch))) != 0) {
 		rsp = cpc_readb(falcbase + F_REG(RSP, ch));
@@ -2361,7 +2355,7 @@ static void falc_intr(pc300_t * card)
 static irqreturn_t cpc_intr(int irq, void *dev_id)
 {
 	pc300_t *card = dev_id;
-	volatile ucchar plx_status;
+	volatile u8 plx_status;
 
 	if (!card) {
 #ifdef PC300_DEBUG_INTR
@@ -2400,7 +2394,7 @@ static irqreturn_t cpc_intr(int irq, void *dev_id)
 
 static void cpc_sca_status(pc300_t * card, int ch)
 {
-	ucchar ilar;
+	u8 ilar;
 	void __iomem *scabase = card->hw.scabase;
 	unsigned long flags;
 
@@ -2818,7 +2812,7 @@ static int cpc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	}
 }
 
-static int clock_rate_calc(uclong rate, uclong clock, int *br_io)
+static int clock_rate_calc(u32 rate, u32 clock, int *br_io)
 {
 	int br, tc;
 	int br_pwr, error;
@@ -2855,12 +2849,12 @@ static int ch_config(pc300dev_t * d)
 	void __iomem *scabase = card->hw.scabase;
 	void __iomem *plxbase = card->hw.plxbase;
 	int ch = chan->channel;
-	uclong clkrate = chan->conf.phys_settings.clock_rate;
-	uclong clktype = chan->conf.phys_settings.clock_type;
-	ucshort encoding = chan->conf.proto_settings.encoding;
-	ucshort parity = chan->conf.proto_settings.parity;   
-	ucchar md0, md2;
-    
+	u32 clkrate = chan->conf.phys_settings.clock_rate;
+	u32 clktype = chan->conf.phys_settings.clock_type;
+	u16 encoding = chan->conf.proto_settings.encoding;
+	u16 parity = chan->conf.proto_settings.parity;
+	u8 md0, md2;
+
 	/* Reset the channel */
 	cpc_writeb(scabase + M_REG(CMD, ch), CMD_CH_RST);
 
@@ -3152,19 +3146,10 @@ int cpc_open(struct net_device *dev)
 	printk("pc300: cpc_open");
 #endif
 
-#ifdef FIXME
-	if (hdlc->proto.id == IF_PROTO_PPP) {
-		d->if_ptr = &hdlc->state.ppp.pppdev;
-	}
-#endif
-
 	result = hdlc_open(dev);
-	if (/* FIXME hdlc->proto.id == IF_PROTO_PPP*/ 0) {
-		dev->priv = d;
-	}
-	if (result) {
+
+	if (result)
 		return result;
-	}
 
 	sprintf(ifr.ifr_name, "%s", dev->name);
 	result = cpc_opench(d);
@@ -3197,9 +3182,7 @@ static int cpc_close(struct net_device *dev)
 	CPC_UNLOCK(card, flags);
 
 	hdlc_close(dev);
-	if (/* FIXME hdlc->proto.id == IF_PROTO_PPP*/ 0) {
-		d->if_ptr = NULL;
-	}
+
 #ifdef CONFIG_PC300_MLPPP
 	if (chan->conf.proto == PC300_PROTO_MLPPP) {
 		cpc_tty_unregister_service(d);
@@ -3210,16 +3193,16 @@ static int cpc_close(struct net_device *dev)
 	return 0;
 }
 
-static uclong detect_ram(pc300_t * card)
+static u32 detect_ram(pc300_t * card)
 {
-	uclong i;
-	ucchar data;
+	u32 i;
+	u8 data;
 	void __iomem *rambase = card->hw.rambase;
 
 	card->hw.ramsize = PC300_RAMSIZE;
 	/* Let's find out how much RAM is present on this board */
 	for (i = 0; i < card->hw.ramsize; i++) {
-		data = (ucchar) (i & 0xff);
+		data = (u8)(i & 0xff);
 		cpc_writeb(rambase + i, data);
 		if (cpc_readb(rambase + i) != data) {
 			break;
@@ -3296,7 +3279,7 @@ static void cpc_init_card(pc300_t * card)
 	cpc_writeb(card->hw.scabase + DMER, 0x80);
 
 	if (card->hw.type == PC300_TE) {
-		ucchar reg1;
+		u8 reg1;
 
 		/* Check CPLD version */
 		reg1 = cpc_readb(card->hw.falcbase + CPLD_REG1);
@@ -3360,7 +3343,6 @@ static void cpc_init_card(pc300_t * card)
 		chan->nfree_tx_bd = N_DMA_TX_BUF;
 
 		d->chan = chan;
-		d->tx_skb = NULL;
 		d->trace_on = 0;
 		d->line_on = 0;
 		d->line_off = 0;
@@ -3431,7 +3413,7 @@ cpc_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int first_time = 1;
 	int err, eeprom_outdated = 0;
-	ucshort device_id;
+	u16 device_id;
 	pc300_t *card;
 
 	if (first_time) {
diff --git a/drivers/net/wan/sealevel.c b/drivers/net/wan/sealevel.c
index 44a89df..c023584 100644
--- a/drivers/net/wan/sealevel.c
+++ b/drivers/net/wan/sealevel.c
@@ -8,6 +8,7 @@
  *
  *	(c) Copyright 1999, 2001 Alan Cox
  *	(c) Copyright 2001 Red Hat Inc.
+ *	Generic HDLC port Copyright (C) 2008 Krzysztof Halasa <khc@pm.waw.pl>
  *
  */
 
@@ -19,6 +20,7 @@
 #include <linux/netdevice.h>
 #include <linux/if_arp.h>
 #include <linux/delay.h>
+#include <linux/hdlc.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <net/arp.h>
@@ -27,22 +29,19 @@
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/byteorder.h>
-#include <net/syncppp.h>
 #include "z85230.h"
 
 
 struct slvl_device
 {
-	void *if_ptr;	/* General purpose pointer (used by SPPP) */
 	struct z8530_channel *chan;
-	struct ppp_device pppdev;
 	int channel;
 };
 
 
 struct slvl_board
 {
-	struct slvl_device *dev[2];
+	struct slvl_device dev[2];
 	struct z8530_dev board;
 	int iobase;
 };
@@ -51,72 +50,69 @@ struct slvl_board
  *	Network driver support routines
  */
 
+static inline struct slvl_device* dev_to_chan(struct net_device *dev)
+{
+	return (struct slvl_device *)dev_to_hdlc(dev)->priv;
+}
+
 /*
- *	Frame receive. Simple for our card as we do sync ppp and there
+ *	Frame receive. Simple for our card as we do HDLC and there
  *	is no funny garbage involved
  */
- 
+
 static void sealevel_input(struct z8530_channel *c, struct sk_buff *skb)
 {
 	/* Drop the CRC - it's not a good idea to try and negotiate it ;) */
-	skb_trim(skb, skb->len-2);
-	skb->protocol=htons(ETH_P_WAN_PPP);
+	skb_trim(skb, skb->len - 2);
+	skb->protocol = hdlc_type_trans(skb, c->netdevice);
 	skb_reset_mac_header(skb);
-	skb->dev=c->netdevice;
-	/*
-	 *	Send it to the PPP layer. We don't have time to process
-	 *	it right now.
-	 */
+	skb->dev = c->netdevice;
 	netif_rx(skb);
 	c->netdevice->last_rx = jiffies;
 }
- 
+
 /*
  *	We've been placed in the UP state
- */ 
- 
+ */
+
 static int sealevel_open(struct net_device *d)
 {
-	struct slvl_device *slvl=d->priv;
+	struct slvl_device *slvl = dev_to_chan(d);
 	int err = -1;
 	int unit = slvl->channel;
-	
+
 	/*
-	 *	Link layer up. 
+	 *	Link layer up.
 	 */
 
-	switch(unit)
+	switch (unit)
 	{
 		case 0:
-			err=z8530_sync_dma_open(d, slvl->chan);
+			err = z8530_sync_dma_open(d, slvl->chan);
 			break;
 		case 1:
-			err=z8530_sync_open(d, slvl->chan);
+			err = z8530_sync_open(d, slvl->chan);
 			break;
 	}
-	
-	if(err)
+
+	if (err)
 		return err;
-	/*
-	 *	Begin PPP
-	 */
-	err=sppp_open(d);
-	if(err)
-	{
-		switch(unit)
-		{
+
+	err = hdlc_open(d);
+	if (err) {
+		switch (unit) {
 			case 0:
 				z8530_sync_dma_close(d, slvl->chan);
 				break;
 			case 1:
 				z8530_sync_close(d, slvl->chan);
 				break;
-		}				
+		}
 		return err;
 	}
-	
-	slvl->chan->rx_function=sealevel_input;
-	
+
+	slvl->chan->rx_function = sealevel_input;
+
 	/*
 	 *	Go go go
 	 */
@@ -126,26 +122,19 @@ static int sealevel_open(struct net_device *d)
 
 static int sealevel_close(struct net_device *d)
 {
-	struct slvl_device *slvl=d->priv;
+	struct slvl_device *slvl = dev_to_chan(d);
 	int unit = slvl->channel;
-	
+
 	/*
 	 *	Discard new frames
 	 */
-	
-	slvl->chan->rx_function=z8530_null_rx;
-		
-	/*
-	 *	PPP off
-	 */
-	sppp_close(d);
-	/*
-	 *	Link layer down
-	 */
 
+	slvl->chan->rx_function = z8530_null_rx;
+
+	hdlc_close(d);
 	netif_stop_queue(d);
-		
-	switch(unit)
+
+	switch (unit)
 	{
 		case 0:
 			z8530_sync_dma_close(d, slvl->chan);
@@ -159,210 +148,153 @@ static int sealevel_close(struct net_device *d)
 
 static int sealevel_ioctl(struct net_device *d, struct ifreq *ifr, int cmd)
 {
-	/* struct slvl_device *slvl=d->priv;
+	/* struct slvl_device *slvl=dev_to_chan(d);
 	   z8530_ioctl(d,&slvl->sync.chanA,ifr,cmd) */
-	return sppp_do_ioctl(d, ifr,cmd);
-}
-
-static struct net_device_stats *sealevel_get_stats(struct net_device *d)
-{
-	struct slvl_device *slvl=d->priv;
-	if(slvl)
-		return z8530_get_stats(slvl->chan);
-	else
-		return NULL;
+	return hdlc_ioctl(d, ifr, cmd);
 }
 
 /*
- *	Passed PPP frames, fire them downwind.
+ *	Passed network frames, fire them downwind.
  */
- 
+
 static int sealevel_queue_xmit(struct sk_buff *skb, struct net_device *d)
 {
-	struct slvl_device *slvl=d->priv;
-	return z8530_queue_xmit(slvl->chan, skb);
+	return z8530_queue_xmit(dev_to_chan(d)->chan, skb);
 }
 
-static int sealevel_neigh_setup(struct neighbour *n)
+static int sealevel_attach(struct net_device *dev, unsigned short encoding,
+			   unsigned short parity)
 {
-	if (n->nud_state == NUD_NONE) {
-		n->ops = &arp_broken_ops;
-		n->output = n->ops->output;
-	}
-	return 0;
+	if (encoding == ENCODING_NRZ && parity == PARITY_CRC16_PR1_CCITT)
+		return 0;
+	return -EINVAL;
 }
 
-static int sealevel_neigh_setup_dev(struct net_device *dev, struct neigh_parms *p)
+static int slvl_setup(struct slvl_device *sv, int iobase, int irq)
 {
-	if (p->tbl->family == AF_INET) {
-		p->neigh_setup = sealevel_neigh_setup;
-		p->ucast_probes = 0;
-		p->mcast_probes = 0;
+	struct net_device *dev = alloc_hdlcdev(sv);
+	if (!dev)
+		return -1;
+
+	dev_to_hdlc(dev)->attach = sealevel_attach;
+	dev_to_hdlc(dev)->xmit = sealevel_queue_xmit;
+	dev->open = sealevel_open;
+	dev->stop = sealevel_close;
+	dev->do_ioctl = sealevel_ioctl;
+	dev->base_addr = iobase;
+	dev->irq = irq;
+
+	if (register_hdlc_device(dev)) {
+		printk(KERN_ERR "sealevel: unable to register HDLC device\n");
+		free_netdev(dev);
+		return -1;
 	}
-	return 0;
-}
 
-static int sealevel_attach(struct net_device *dev)
-{
-	struct slvl_device *sv = dev->priv;
-	sppp_attach(&sv->pppdev);
+	sv->chan->netdevice = dev;
 	return 0;
 }
 
-static void sealevel_detach(struct net_device *dev)
-{
-	sppp_detach(dev);
-}
-		
-static void slvl_setup(struct net_device *d)
-{
-	d->open = sealevel_open;
-	d->stop = sealevel_close;
-	d->init = sealevel_attach;
-	d->uninit = sealevel_detach;
-	d->hard_start_xmit = sealevel_queue_xmit;
-	d->get_stats = sealevel_get_stats;
-	d->set_multicast_list = NULL;
-	d->do_ioctl = sealevel_ioctl;
-	d->neigh_setup = sealevel_neigh_setup_dev;
-	d->set_mac_address = NULL;
-
-}
-
-static inline struct slvl_device *slvl_alloc(int iobase, int irq)
-{
-	struct net_device *d;
-	struct slvl_device *sv;
-
-	d = alloc_netdev(sizeof(struct slvl_device), "hdlc%d",
-			 slvl_setup);
-
-	if (!d) 
-		return NULL;
-
-	sv = d->priv;
-	d->ml_priv = sv;
-	sv->if_ptr = &sv->pppdev;
-	sv->pppdev.dev = d;
-	d->base_addr = iobase;
-	d->irq = irq;
-		
-	return sv;
-}
-
 
 /*
  *	Allocate and setup Sealevel board.
  */
- 
-static __init struct slvl_board *slvl_init(int iobase, int irq, 
+
+static __init struct slvl_board *slvl_init(int iobase, int irq,
 					   int txdma, int rxdma, int slow)
 {
 	struct z8530_dev *dev;
 	struct slvl_board *b;
-	
+
 	/*
 	 *	Get the needed I/O space
 	 */
 
-	if(!request_region(iobase, 8, "Sealevel 4021")) 
-	{	
-		printk(KERN_WARNING "sealevel: I/O 0x%X already in use.\n", iobase);
+	if (!request_region(iobase, 8, "Sealevel 4021")) {
+		printk(KERN_WARNING "sealevel: I/O 0x%X already in use.\n",
+		       iobase);
 		return NULL;
 	}
-	
-	b = kzalloc(sizeof(struct slvl_board), GFP_KERNEL);
-	if(!b)
-		goto fail3;
 
-	if (!(b->dev[0]= slvl_alloc(iobase, irq)))
-		goto fail2;
+	b = kzalloc(sizeof(struct slvl_board), GFP_KERNEL);
+	if (!b)
+		goto err_kzalloc;
 
-	b->dev[0]->chan = &b->board.chanA;	
-	b->dev[0]->channel = 0;
-	
-	if (!(b->dev[1] = slvl_alloc(iobase, irq)))
-		goto fail1_0;
+	b->dev[0].chan = &b->board.chanA;
+	b->dev[0].channel = 0;
 
-	b->dev[1]->chan = &b->board.chanB;
-	b->dev[1]->channel = 1;
+	b->dev[1].chan = &b->board.chanB;
+	b->dev[1].channel = 1;
 
 	dev = &b->board;
-	
+
 	/*
 	 *	Stuff in the I/O addressing
 	 */
-	 
+
 	dev->active = 0;
 
 	b->iobase = iobase;
-	
+
 	/*
 	 *	Select 8530 delays for the old board
 	 */
-	 
-	if(slow)
+
+	if (slow)
 		iobase |= Z8530_PORT_SLEEP;
-		
-	dev->chanA.ctrlio=iobase+1;
-	dev->chanA.dataio=iobase;
-	dev->chanB.ctrlio=iobase+3;
-	dev->chanB.dataio=iobase+2;
-	
-	dev->chanA.irqs=&z8530_nop;
-	dev->chanB.irqs=&z8530_nop;
-	
+
+	dev->chanA.ctrlio = iobase + 1;
+	dev->chanA.dataio = iobase;
+	dev->chanB.ctrlio = iobase + 3;
+	dev->chanB.dataio = iobase + 2;
+
+	dev->chanA.irqs = &z8530_nop;
+	dev->chanB.irqs = &z8530_nop;
+
 	/*
 	 *	Assert DTR enable DMA
 	 */
-	 
-	outb(3|(1<<7), b->iobase+4);	
-	
+
+	outb(3 | (1 << 7), b->iobase + 4);
+
 
 	/* We want a fast IRQ for this device. Actually we'd like an even faster
 	   IRQ ;) - This is one driver RtLinux is made for */
-   
-	if(request_irq(irq, &z8530_interrupt, IRQF_DISABLED, "SeaLevel", dev)<0)
-	{
+
+	if (request_irq(irq, &z8530_interrupt, IRQF_DISABLED,
+			"SeaLevel", dev) < 0) {
 		printk(KERN_WARNING "sealevel: IRQ %d already in use.\n", irq);
-		goto fail1_1;
+		goto err_request_irq;
 	}
-	
-	dev->irq=irq;
-	dev->chanA.private=&b->dev[0];
-	dev->chanB.private=&b->dev[1];
-	dev->chanA.netdevice=b->dev[0]->pppdev.dev;
-	dev->chanB.netdevice=b->dev[1]->pppdev.dev;
-	dev->chanA.dev=dev;
-	dev->chanB.dev=dev;
-
-	dev->chanA.txdma=3;
-	dev->chanA.rxdma=1;
-	if(request_dma(dev->chanA.txdma, "SeaLevel (TX)")!=0)
-		goto fail;
-		
-	if(request_dma(dev->chanA.rxdma, "SeaLevel (RX)")!=0)
-		goto dmafail;
-	
+
+	dev->irq = irq;
+	dev->chanA.private = &b->dev[0];
+	dev->chanB.private = &b->dev[1];
+	dev->chanA.dev = dev;
+	dev->chanB.dev = dev;
+
+	dev->chanA.txdma = 3;
+	dev->chanA.rxdma = 1;
+	if (request_dma(dev->chanA.txdma, "SeaLevel (TX)"))
+		goto err_dma_tx;
+
+	if (request_dma(dev->chanA.rxdma, "SeaLevel (RX)"))
+		goto err_dma_rx;
+
 	disable_irq(irq);
-		
+
 	/*
 	 *	Begin normal initialise
 	 */
-	 
-	if(z8530_init(dev)!=0)
-	{
+
+	if (z8530_init(dev) != 0) {
 		printk(KERN_ERR "Z8530 series device not found.\n");
 		enable_irq(irq);
-		goto dmafail2;
+		goto free_hw;
 	}
-	if(dev->type==Z85C30)
-	{
+	if (dev->type == Z85C30) {
 		z8530_channel_load(&dev->chanA, z8530_hdlc_kilostream);
 		z8530_channel_load(&dev->chanB, z8530_hdlc_kilostream);
-	}
-	else
-	{
+	} else {
 		z8530_channel_load(&dev->chanA, z8530_hdlc_kilostream_85230);
 		z8530_channel_load(&dev->chanB, z8530_hdlc_kilostream_85230);
 	}
@@ -370,36 +302,31 @@ static __init struct slvl_board *slvl_init(int iobase, int irq,
 	/*
 	 *	Now we can take the IRQ
 	 */
-	
+
 	enable_irq(irq);
 
-	if (register_netdev(b->dev[0]->pppdev.dev)) 
-		goto dmafail2;
-		
-	if (register_netdev(b->dev[1]->pppdev.dev)) 
-		goto fail_unit;
+	if (slvl_setup(&b->dev[0], iobase, irq))
+		goto free_hw;
+	if (slvl_setup(&b->dev[1], iobase, irq))
+		goto free_netdev0;
 
 	z8530_describe(dev, "I/O", iobase);
-	dev->active=1;
+	dev->active = 1;
 	return b;
 
-fail_unit:
-	unregister_netdev(b->dev[0]->pppdev.dev);
-	
-dmafail2:
+free_netdev0:
+	unregister_hdlc_device(b->dev[0].chan->netdevice);
+	free_netdev(b->dev[0].chan->netdevice);
+free_hw:
 	free_dma(dev->chanA.rxdma);
-dmafail:
+err_dma_rx:
 	free_dma(dev->chanA.txdma);
-fail:
+err_dma_tx:
 	free_irq(irq, dev);
-fail1_1:
-	free_netdev(b->dev[1]->pppdev.dev);
-fail1_0:
-	free_netdev(b->dev[0]->pppdev.dev);
-fail2:
+err_request_irq:
 	kfree(b);
-fail3:
-	release_region(iobase,8);
+err_kzalloc:
+	release_region(iobase, 8);
 	return NULL;
 }
 
@@ -408,14 +335,14 @@ static void __exit slvl_shutdown(struct slvl_board *b)
 	int u;
 
 	z8530_shutdown(&b->board);
-	
-	for(u=0; u<2; u++)
+
+	for (u = 0; u < 2; u++)
 	{
-		struct net_device *d = b->dev[u]->pppdev.dev;
-		unregister_netdev(d);
+		struct net_device *d = b->dev[u].chan->netdevice;
+		unregister_hdlc_device(d);
 		free_netdev(d);
 	}
-	
+
 	free_irq(b->board.irq, &b->board);
 	free_dma(b->board.chanA.rxdma);
 	free_dma(b->board.chanA.txdma);
@@ -451,10 +378,6 @@ static struct slvl_board *slvl_unit;
 
 static int __init slvl_init_module(void)
 {
-#ifdef MODULE
-	printk(KERN_INFO "SeaLevel Z85230 Synchronous Driver v 0.02.\n");
-	printk(KERN_INFO "(c) Copyright 1998, Building Number Three Ltd.\n");
-#endif
 	slvl_unit = slvl_init(io, irq, txdma, rxdma, slow);
 
 	return slvl_unit ? 0 : -ENODEV;
diff --git a/drivers/net/wan/syncppp.c b/drivers/net/wan/syncppp.c
index 29b4b94..327d585 100644
--- a/drivers/net/wan/syncppp.c
+++ b/drivers/net/wan/syncppp.c
@@ -230,13 +230,6 @@ static void sppp_input (struct net_device *dev, struct sk_buff *skb)
 	skb->dev=dev;
 	skb_reset_mac_header(skb);
 
-	if (dev->flags & IFF_RUNNING)
-	{
-		/* Count received bytes, add FCS and one flag */
-		sp->ibytes+= skb->len + 3;
-		sp->ipkts++;
-	}
-
 	if (!pskb_may_pull(skb, PPP_HEADER_LEN)) {
 		/* Too small packet, drop it. */
 		if (sp->pp_flags & PP_DEBUG)
@@ -832,7 +825,6 @@ static void sppp_cp_send (struct sppp *sp, u16 proto, u8 type,
 			sppp_print_bytes ((u8*) (lh+1), len);
 		printk (">\n");
 	}
-	sp->obytes += skb->len;
 	/* Control is high priority so it doesn't get queued behind data */
 	skb->priority=TC_PRIO_CONTROL;
 	skb->dev = dev;
@@ -875,7 +867,6 @@ static void sppp_cisco_send (struct sppp *sp, int type, u32 par1, u32 par2)
 		printk (KERN_WARNING "%s: cisco output: <%xh %xh %xh %xh %xh-%xh>\n",
 			dev->name,  ntohl (ch->type), ch->par1,
 			ch->par2, ch->rel, ch->time0, ch->time1);
-	sp->obytes += skb->len;
 	skb->priority=TC_PRIO_CONTROL;
 	skb->dev = dev;
 	skb_queue_tail(&tx_queue, skb);
diff --git a/drivers/net/wan/z85230.c b/drivers/net/wan/z85230.c
index 98ef400..243bd8d 100644
--- a/drivers/net/wan/z85230.c
+++ b/drivers/net/wan/z85230.c
@@ -43,6 +43,7 @@
 #include <linux/netdevice.h>
 #include <linux/if_arp.h>
 #include <linux/delay.h>
+#include <linux/hdlc.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <asm/dma.h>
@@ -51,7 +52,6 @@
 #define RT_UNLOCK
 #include <linux/spinlock.h>
 
-#include <net/syncppp.h>
 #include "z85230.h"
 
 
@@ -440,51 +440,46 @@ static void z8530_tx(struct z8530_channel *c)
  *	A status event occurred in PIO synchronous mode. There are several
  *	reasons the chip will bother us here. A transmit underrun means we
  *	failed to feed the chip fast enough and just broke a packet. A DCD
- *	change is a line up or down. We communicate that back to the protocol
- *	layer for synchronous PPP to renegotiate.
+ *	change is a line up or down.
  */
 
 static void z8530_status(struct z8530_channel *chan)
 {
 	u8 status, altered;
 
-	status=read_zsreg(chan, R0);
-	altered=chan->status^status;
-	
-	chan->status=status;
-	
-	if(status&TxEOM)
-	{
+	status = read_zsreg(chan, R0);
+	altered = chan->status ^ status;
+
+	chan->status = status;
+
+	if (status & TxEOM) {
 /*		printk("%s: Tx underrun.\n", chan->dev->name); */
-		chan->stats.tx_fifo_errors++;
+		chan->netdevice->stats.tx_fifo_errors++;
 		write_zsctrl(chan, ERR_RES);
 		z8530_tx_done(chan);
 	}
-		
-	if(altered&chan->dcdcheck)
+
+	if (altered & chan->dcdcheck)
 	{
-		if(status&chan->dcdcheck)
-		{
+		if (status & chan->dcdcheck) {
 			printk(KERN_INFO "%s: DCD raised\n", chan->dev->name);
-			write_zsreg(chan, R3, chan->regs[3]|RxENABLE);
-			if(chan->netdevice &&
-			    ((chan->netdevice->type == ARPHRD_HDLC) ||
-			    (chan->netdevice->type == ARPHRD_PPP)))
-				sppp_reopen(chan->netdevice);
-		}
-		else
-		{
+			write_zsreg(chan, R3, chan->regs[3] | RxENABLE);
+			if (chan->netdevice)
+				netif_carrier_on(chan->netdevice);
+		} else {
 			printk(KERN_INFO "%s: DCD lost\n", chan->dev->name);
-			write_zsreg(chan, R3, chan->regs[3]&~RxENABLE);
+			write_zsreg(chan, R3, chan->regs[3] & ~RxENABLE);
 			z8530_flush_fifo(chan);
+			if (chan->netdevice)
+				netif_carrier_off(chan->netdevice);
 		}
-		
-	}	
+
+	}
 	write_zsctrl(chan, RES_EXT_INT);
 	write_zsctrl(chan, RES_H_IUS);
 }
 
-struct z8530_irqhandler z8530_sync=
+struct z8530_irqhandler z8530_sync =
 {
 	z8530_rx,
 	z8530_tx,
@@ -556,8 +551,7 @@ static void z8530_dma_tx(struct z8530_channel *chan)
  *	
  *	A status event occurred on the Z8530. We receive these for two reasons
  *	when in DMA mode. Firstly if we finished a packet transfer we get one
- *	and kick the next packet out. Secondly we may see a DCD change and
- *	have to poke the protocol layer.
+ *	and kick the next packet out. Secondly we may see a DCD change.
  *
  */
  
@@ -586,24 +580,21 @@ static void z8530_dma_status(struct z8530_channel *chan)
 		}
 	}
 
-	if(altered&chan->dcdcheck)
+	if (altered & chan->dcdcheck)
 	{
-		if(status&chan->dcdcheck)
-		{
+		if (status & chan->dcdcheck) {
 			printk(KERN_INFO "%s: DCD raised\n", chan->dev->name);
-			write_zsreg(chan, R3, chan->regs[3]|RxENABLE);
-			if(chan->netdevice &&
-			    ((chan->netdevice->type == ARPHRD_HDLC) ||
-			    (chan->netdevice->type == ARPHRD_PPP)))
-				sppp_reopen(chan->netdevice);
-		}
-		else
-		{
+			write_zsreg(chan, R3, chan->regs[3] | RxENABLE);
+			if (chan->netdevice)
+				netif_carrier_on(chan->netdevice);
+		} else {
 			printk(KERN_INFO "%s:DCD lost\n", chan->dev->name);
-			write_zsreg(chan, R3, chan->regs[3]&~RxENABLE);
+			write_zsreg(chan, R3, chan->regs[3] & ~RxENABLE);
 			z8530_flush_fifo(chan);
+			if (chan->netdevice)
+				netif_carrier_off(chan->netdevice);
 		}
-	}	
+	}
 
 	write_zsctrl(chan, RES_EXT_INT);
 	write_zsctrl(chan, RES_H_IUS);
@@ -1459,10 +1450,10 @@ static void z8530_tx_begin(struct z8530_channel *c)
 			/*
 			 *	Check if we crapped out.
 			 */
-			if(get_dma_residue(c->txdma))
+			if (get_dma_residue(c->txdma))
 			{
-				c->stats.tx_dropped++;
-				c->stats.tx_fifo_errors++;
+				c->netdevice->stats.tx_dropped++;
+				c->netdevice->stats.tx_fifo_errors++;
 			}
 			release_dma_lock(flags);
 		}
@@ -1534,21 +1525,21 @@ static void z8530_tx_begin(struct z8530_channel *c)
  *	packet. This code is fairly timing sensitive.
  *
  *	Called with the register lock held.
- */ 
- 
+ */
+
 static void z8530_tx_done(struct z8530_channel *c)
 {
 	struct sk_buff *skb;
 
 	/* Actually this can happen.*/
-	if(c->tx_skb==NULL)
+	if (c->tx_skb == NULL)
 		return;
 
-	skb=c->tx_skb;
-	c->tx_skb=NULL;
+	skb = c->tx_skb;
+	c->tx_skb = NULL;
 	z8530_tx_begin(c);
-	c->stats.tx_packets++;
-	c->stats.tx_bytes+=skb->len;
+	c->netdevice->stats.tx_packets++;
+	c->netdevice->stats.tx_bytes += skb->len;
 	dev_kfree_skb_irq(skb);
 }
 
@@ -1558,7 +1549,7 @@ static void z8530_tx_done(struct z8530_channel *c)
  *	@skb: The buffer
  *
  *	We point the receive handler at this function when idle. Instead
- *	of syncppp processing the frames we get to throw them away.
+ *	of processing the frames we get to throw them away.
  */
  
 void z8530_null_rx(struct z8530_channel *c, struct sk_buff *skb)
@@ -1635,10 +1626,11 @@ static void z8530_rx_done(struct z8530_channel *c)
 		else
 			/* Can't occur as we dont reenable the DMA irq until
 			   after the flip is done */
-			printk(KERN_WARNING "%s: DMA flip overrun!\n", c->netdevice->name);
-			
+			printk(KERN_WARNING "%s: DMA flip overrun!\n",
+			       c->netdevice->name);
+
 		release_dma_lock(flags);
-		
+
 		/*
 		 *	Shove the old buffer into an sk_buff. We can't DMA
 		 *	directly into one on a PC - it might be above the 16Mb
@@ -1646,27 +1638,23 @@ static void z8530_rx_done(struct z8530_channel *c)
 		 *	can avoid the copy. Optimisation 2 - make the memcpy
 		 *	a copychecksum.
 		 */
-		 
-		skb=dev_alloc_skb(ct);
-		if(skb==NULL)
-		{
-			c->stats.rx_dropped++;
-			printk(KERN_WARNING "%s: Memory squeeze.\n", c->netdevice->name);
-		}
-		else
-		{
+
+		skb = dev_alloc_skb(ct);
+		if (skb == NULL) {
+			c->netdevice->stats.rx_dropped++;
+			printk(KERN_WARNING "%s: Memory squeeze.\n",
+			       c->netdevice->name);
+		} else {
 			skb_put(skb, ct);
 			skb_copy_to_linear_data(skb, rxb, ct);
-			c->stats.rx_packets++;
-			c->stats.rx_bytes+=ct;
+			c->netdevice->stats.rx_packets++;
+			c->netdevice->stats.rx_bytes += ct;
 		}
-		c->dma_ready=1;
-	}
-	else
-	{
-		RT_LOCK;	
-		skb=c->skb;
-		
+		c->dma_ready = 1;
+	} else {
+		RT_LOCK;
+		skb = c->skb;
+
 		/*
 		 *	The game we play for non DMA is similar. We want to
 		 *	get the controller set up for the next packet as fast
@@ -1677,48 +1665,39 @@ static void z8530_rx_done(struct z8530_channel *c)
 		 *	if you build a system where the sync irq isnt blocked
 		 *	by the kernel IRQ disable then you need only block the
 		 *	sync IRQ for the RT_LOCK area.
-		 *	
+		 *
 		 */
 		ct=c->count;
-		
+
 		c->skb = c->skb2;
 		c->count = 0;
 		c->max = c->mtu;
-		if(c->skb)
-		{
+		if (c->skb) {
 			c->dptr = c->skb->data;
 			c->max = c->mtu;
-		}
-		else
-		{
-			c->count= 0;
+		} else {
+			c->count = 0;
 			c->max = 0;
 		}
 		RT_UNLOCK;
 
 		c->skb2 = dev_alloc_skb(c->mtu);
-		if(c->skb2==NULL)
+		if (c->skb2 == NULL)
 			printk(KERN_WARNING "%s: memory squeeze.\n",
-				c->netdevice->name);
+			       c->netdevice->name);
 		else
-		{
-			skb_put(c->skb2,c->mtu);
-		}
-		c->stats.rx_packets++;
-		c->stats.rx_bytes+=ct;
-		
+			skb_put(c->skb2, c->mtu);
+		c->netdevice->stats.rx_packets++;
+		c->netdevice->stats.rx_bytes += ct;
 	}
 	/*
 	 *	If we received a frame we must now process it.
 	 */
-	if(skb)
-	{
+	if (skb) {
 		skb_trim(skb, ct);
-		c->rx_function(c,skb);
-	}
-	else
-	{
-		c->stats.rx_dropped++;
+		c->rx_function(c, skb);
+	} else {
+		c->netdevice->stats.rx_dropped++;
 		printk(KERN_ERR "%s: Lost a frame\n", c->netdevice->name);
 	}
 }
@@ -1730,7 +1709,7 @@ static void z8530_rx_done(struct z8530_channel *c)
  *	Returns true if the buffer cross a DMA boundary on a PC. The poor
  *	thing can only DMA within a 64K block not across the edges of it.
  */
- 
+
 static inline int spans_boundary(struct sk_buff *skb)
 {
 	unsigned long a=(unsigned long)skb->data;
@@ -1799,24 +1778,6 @@ int z8530_queue_xmit(struct z8530_channel *c, struct sk_buff *skb)
 
 EXPORT_SYMBOL(z8530_queue_xmit);
 
-/**
- *	z8530_get_stats - Get network statistics
- *	@c: The channel to use
- *
- *	Get the statistics block. We keep the statistics in software as
- *	the chip doesn't do it for us.
- *
- *	Locking is ignored here - we could lock for a copy but its
- *	not likely to be that big an issue
- */
- 
-struct net_device_stats *z8530_get_stats(struct z8530_channel *c)
-{
-	return &c->stats;
-}
-
-EXPORT_SYMBOL(z8530_get_stats);
-
 /*
  *	Module support
  */
diff --git a/drivers/net/wan/z85230.h b/drivers/net/wan/z85230.h
index 158aea7..4f37239 100644
--- a/drivers/net/wan/z85230.h
+++ b/drivers/net/wan/z85230.h
@@ -325,7 +325,6 @@ struct z8530_channel
 
 	void		*private;	/* For our owner */
 	struct net_device	*netdevice;	/* Network layer device */
-	struct net_device_stats stats;	/* Network layer statistics */
 
 	/*
 	 *	Async features
@@ -366,13 +365,13 @@ struct z8530_channel
 	unsigned char		tx_active; /* character is being xmitted */
 	unsigned char		tx_stopped; /* output is suspended */
 
-	spinlock_t		*lock;	  /* Devicr lock */
-};	
+	spinlock_t		*lock;	  /* Device lock */
+};
 
 /*
  *	Each Z853x0 device.
- */	
- 
+ */
+
 struct z8530_dev
 {
 	char *name;	/* Device instance name */
@@ -408,7 +407,6 @@ extern int z8530_sync_txdma_open(struct net_device *, struct z8530_channel *);
 extern int z8530_sync_txdma_close(struct net_device *, struct z8530_channel *);
 extern int z8530_channel_load(struct z8530_channel *, u8 *);
 extern int z8530_queue_xmit(struct z8530_channel *c, struct sk_buff *skb);
-extern struct net_device_stats *z8530_get_stats(struct z8530_channel *c);
 extern void z8530_null_rx(struct z8530_channel *c, struct sk_buff *skb);
 
 
diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index b047306..1ebcafe 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -1998,13 +1998,6 @@ __orinoco_set_multicast_list(struct net_device *dev)
 		else
 			priv->mc_count = mc_count;
 	}
-
-	/* Since we can set the promiscuous flag when it wasn't asked
-	   for, make sure the net_device knows about it. */
-	if (priv->promiscuous)
-		dev->flags |= IFF_PROMISC;
-	else
-		dev->flags &= ~IFF_PROMISC;
 }
 
 /* This must be called from user context, without locks held - use
diff --git a/drivers/net/wireless/wavelan.c b/drivers/net/wireless/wavelan.c
index 49ae970..136220b 100644
--- a/drivers/net/wireless/wavelan.c
+++ b/drivers/net/wireless/wavelan.c
@@ -1409,9 +1409,6 @@ static void wavelan_set_multicast_list(struct net_device * dev)
 			lp->mc_count = 0;
 
 			wv_82586_reconfig(dev);
-
-			/* Tell the kernel that we are doing a really bad job. */
-			dev->flags |= IFF_PROMISC;
 		}
 	} else
 		/* Are there multicast addresses to send? */
diff --git a/drivers/net/wireless/wavelan_cs.c b/drivers/net/wireless/wavelan_cs.c
index b584c0e..00a3559 100644
--- a/drivers/net/wireless/wavelan_cs.c
+++ b/drivers/net/wireless/wavelan_cs.c
@@ -1412,9 +1412,6 @@ wavelan_set_multicast_list(struct net_device *	dev)
 	  lp->mc_count = 0;
 
 	  wv_82593_reconfig(dev);
-
-	  /* Tell the kernel that we are doing a really bad job... */
-	  dev->flags |= IFF_PROMISC;
 	}
     }
   else
@@ -1433,9 +1430,6 @@ wavelan_set_multicast_list(struct net_device *	dev)
 	    lp->mc_count = 0;
 
 	    wv_82593_reconfig(dev);
-
-	    /* Tell the kernel that we are doing a really bad job... */
-	    dev->flags |= IFF_ALLMULTI;
 	  }
       }
     else
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 902bbe7..c749bdb 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -329,7 +329,7 @@ static int xennet_open(struct net_device *dev)
 	}
 	spin_unlock_bh(&np->rx_lock);
 
-	xennet_maybe_wake_tx(dev);
+	netif_start_queue(dev);
 
 	return 0;
 }
diff --git a/include/linux/dm9000.h b/include/linux/dm9000.h
index fc82446..c30879c 100644
--- a/include/linux/dm9000.h
+++ b/include/linux/dm9000.h
@@ -27,6 +27,7 @@
 
 struct dm9000_plat_data {
 	unsigned int	flags;
+	unsigned char	dev_addr[6];
 
 	/* allow replacement IO routines */
 
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 8bb5e87..b4b038b 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -27,9 +27,24 @@ struct ethtool_cmd {
 	__u8	autoneg;	/* Enable or disable autonegotiation */
 	__u32	maxtxpkt;	/* Tx pkts before generating tx int */
 	__u32	maxrxpkt;	/* Rx pkts before generating rx int */
-	__u32	reserved[4];
+	__u16	speed_hi;
+	__u16	reserved2;
+	__u32	reserved[3];
 };
 
+static inline void ethtool_cmd_speed_set(struct ethtool_cmd *ep,
+						__u32 speed)
+{
+
+	ep->speed = (__u16)speed;
+	ep->speed_hi = (__u16)(speed >> 16);
+}
+
+static inline __u32 ethtool_cmd_speed(struct ethtool_cmd *ep)
+{
+	return (ep->speed_hi << 16) | ep->speed;
+}
+
 #define ETHTOOL_BUSINFO_LEN	32
 /* these strings are set to whatever the driver author decides... */
 struct ethtool_drvinfo {
diff --git a/include/net/syncppp.h b/include/net/syncppp.h
index e43f407..9e306f7 100644
--- a/include/net/syncppp.h
+++ b/include/net/syncppp.h
@@ -43,8 +43,6 @@ struct sppp
 	u32		pp_rseq;	/* remote sequence number */
 	struct slcp	lcp;		/* LCP params */
 	struct sipcp	ipcp;		/* IPCP params */
-	u32		ibytes,obytes;	/* Bytes in/out */
-	u32		ipkts,opkts;	/* Packets in/out */
 	struct timer_list	pp_timer;
 	struct net_device	*pp_if;
 	char		pp_link_state;	/* Link status */
diff --git a/net/core/dev.c b/net/core/dev.c
index 01993ad..600bb23 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1939,22 +1939,6 @@ int netif_rx_ni(struct sk_buff *skb)
 
 EXPORT_SYMBOL(netif_rx_ni);
 
-static inline struct net_device *skb_bond(struct sk_buff *skb)
-{
-	struct net_device *dev = skb->dev;
-
-	if (dev->master) {
-		if (skb_bond_should_drop(skb)) {
-			kfree_skb(skb);
-			return NULL;
-		}
-		skb->dev = dev->master;
-	}
-
-	return dev;
-}
-
-
 static void net_tx_action(struct softirq_action *h)
 {
 	struct softnet_data *sd = &__get_cpu_var(softnet_data);
@@ -2181,6 +2165,7 @@ int netif_receive_skb(struct sk_buff *skb)
 {
 	struct packet_type *ptype, *pt_prev;
 	struct net_device *orig_dev;
+	struct net_device *null_or_orig;
 	int ret = NET_RX_DROP;
 	__be16 type;
 
@@ -2194,10 +2179,14 @@ int netif_receive_skb(struct sk_buff *skb)
 	if (!skb->iif)
 		skb->iif = skb->dev->ifindex;
 
-	orig_dev = skb_bond(skb);
-
-	if (!orig_dev)
-		return NET_RX_DROP;
+	null_or_orig = NULL;
+	orig_dev = skb->dev;
+	if (orig_dev->master) {
+		if (skb_bond_should_drop(skb))
+			null_or_orig = orig_dev; /* deliver only exact match */
+		else
+			skb->dev = orig_dev->master;
+	}
 
 	__get_cpu_var(netdev_rx_stat).total++;
 
@@ -2221,7 +2210,8 @@ int netif_receive_skb(struct sk_buff *skb)
 #endif
 
 	list_for_each_entry_rcu(ptype, &ptype_all, list) {
-		if (!ptype->dev || ptype->dev == skb->dev) {
+		if (ptype->dev == null_or_orig || ptype->dev == skb->dev ||
+		    ptype->dev == orig_dev) {
 			if (pt_prev)
 				ret = deliver_skb(skb, pt_prev, orig_dev);
 			pt_prev = ptype;
@@ -2246,7 +2236,8 @@ ncls:
 	list_for_each_entry_rcu(ptype,
 			&ptype_base[ntohs(type) & PTYPE_HASH_MASK], list) {
 		if (ptype->type == type &&
-		    (!ptype->dev || ptype->dev == skb->dev)) {
+		    (ptype->dev == null_or_orig || ptype->dev == skb->dev ||
+		     ptype->dev == orig_dev)) {
 			if (pt_prev)
 				ret = deliver_skb(skb, pt_prev, orig_dev);
 			pt_prev = ptype;
diff --git a/net/wanrouter/wanmain.c b/net/wanrouter/wanmain.c
index b210a88..7f07152 100644
--- a/net/wanrouter/wanmain.c
+++ b/net/wanrouter/wanmain.c
@@ -57,7 +57,6 @@
 #include <linux/vmalloc.h>	/* vmalloc, vfree */
 #include <asm/uaccess.h>        /* copy_to/from_user */
 #include <linux/init.h>         /* __initfunc et al. */
-#include <net/syncppp.h>
 
 #define KMEM_SAFETYZONE 8
 
@@ -567,9 +566,6 @@ static int wanrouter_device_new_if(struct wan_device *wandev,
 {
 	wanif_conf_t *cnf;
 	struct net_device *dev = NULL;
-#ifdef CONFIG_WANPIPE_MULTPPP
-	struct ppp_device *pppdev=NULL;
-#endif
 	int err;
 
 	if ((wandev->state == WAN_UNCONFIGURED) || (wandev->new_if == NULL))
@@ -588,25 +584,10 @@ static int wanrouter_device_new_if(struct wan_device *wandev,
 		goto out;
 
 	if (cnf->config_id == WANCONFIG_MPPP) {
-#ifdef CONFIG_WANPIPE_MULTPPP
-		pppdev = kzalloc(sizeof(struct ppp_device), GFP_KERNEL);
-		err = -ENOBUFS;
-		if (pppdev == NULL)
-			goto out;
-		pppdev->dev = kzalloc(sizeof(struct net_device), GFP_KERNEL);
-		if (pppdev->dev == NULL) {
-			kfree(pppdev);
-			err = -ENOBUFS;
-			goto out;
-		}
-		err = wandev->new_if(wandev, (struct net_device *)pppdev, cnf);
-		dev = pppdev->dev;
-#else
 		printk(KERN_INFO "%s: Wanpipe Mulit-Port PPP support has not been compiled in!\n",
 				wandev->name);
 		err = -EPROTONOSUPPORT;
 		goto out;
-#endif
 	} else {
 		dev = kzalloc(sizeof(struct net_device), GFP_KERNEL);
 		err = -ENOBUFS;
@@ -661,17 +642,9 @@ static int wanrouter_device_new_if(struct wan_device *wandev,
 	kfree(dev->priv);
 	dev->priv = NULL;
 
-#ifdef CONFIG_WANPIPE_MULTPPP
-	if (cnf->config_id == WANCONFIG_MPPP)
-		kfree(pppdev);
-	else
-		kfree(dev);
-#else
 	/* Sync PPP is disabled */
 	if (cnf->config_id != WANCONFIG_MPPP)
 		kfree(dev);
-#endif
-
 out:
 	kfree(cnf);
 	return err;
