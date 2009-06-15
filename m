Return-Path: <linux-kernel-owner+w=401wt.eu-S1755709AbZFOMFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbZFOMFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 08:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbZFOMFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 08:05:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49487
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750908AbZFOMEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 08:04:49 -0400
Date: Mon, 15 Jun 2009 05:04:49 -0700 (PDT)
Message-Id: <20090615.050449.144947903.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n5FC6D54011759


These are the networking updates for the 2.6.31 merge window.

Highlights:

1) RFKILL rewrite from Johannes Berg.

2) IPV6 stateless autoconfig support for ISATAP, from Sascha Hlusiak.

3) New 802.15.4 protocol stack

4) Namespace support for PIM-SM protocol(s), from Tom Goff.

5) All drivers are now converted to net_device_ops, so the compatibility
   code can be completely removed.  A large swath of the final conversions,
   as well as the compat code removal change itself, are from Alexander
   Beregalov.

6) New network drivers: TI DaVinci EMAC, Blackfin SIR IrDA,
   SJA1000 CAN, wl12xx.

7) Sanitization of MDIO clause 45 definitions, from Ben Hutchings.

8) Kill off remaining BUS_ID_SIZE references in the networking.

9) Passive OS fingerprint netfilter match by Evgeniy Polyakov.

10) of_mdio infrastructure from Grant Likely.

11) Numerous GRO optimizations and enhancements from Herbert Xu.

12) More SKB list abstraction work so we can eventually move it
    over to use list_head like the rest of the kernel instead of
    our custom crap.

Please pull, thanks a lot!

The following changes since commit 45e3e1935e2857c54783291107d33323b3ef33c8:
  Linus Torvalds (1):
        Merge branch 'master' of git://git.kernel.org/.../sam/kbuild-next

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-next-2.6.git master

Abhijeet Kolekar (27):
      iwl3945: use iwl_mac_conf_tx
      iwl3945: use iwl_bss_info_changed
      iwl3945: use iwl_mac_beacon_update
      iwlwifi: add commit_rxon lib
      iwl3945: delay mode setting
      iwlwifi: add station management ops
      iwl3945: replace station function with station ops
      iwlwifi: use station management ops
      iwl3945/iwlwifi: unify add_station function
      iwl3945: use iwl_get_sta_id from iwlwifi
      iwlwifi: add set_rxon_chain op
      iwl3945: use iwl_set_mode in 3945
      iwl3945: use iwl_mac_add_interface from iwlwifi
      iwl3945: use iwl_mac_remove_interface from iwlwifi
      iwl3945: use iwl_mac_config from iwlwifi
      iwlwifi: add config_ap lib op
      iwl3945: use iwl_mac_config_interface from iwlwifi
      iwl3945: use iwl_mac_get_tx_stats from iwlwifi
      iwl3945: use iwl_mac_reset_tsf from iwlwifi
      iwl3945: add debugfs to 3945
      iwl3945: calculate debugfs isr statistics
      iwlwifi: remove radio disable parameter.
      iwl3945: fix lock dependency
      iwl3945: read rev id in nic config
      iwl3945: improve 3945 leds
      iwl3945: port allow skb allocation in tasklet patch
      iwl3945/iwlwifi: fix led bug when SW rfkill

Ajit Khaparde (1):
      be2net: changes for checksum and segmentation offload

Alan Jenkins (3):
      rfkill: remove set_global_sw_state
      sony-laptop: no need to unblock rfkill on load
      rfkill: don't impose global states on resume (just restore the previous states)

Alban Browaeys (1):
      rt2x00: Style fix for interval defines

Alexander Beregalov (50):
      drivers/net: replace BUG() with BUG_ON() if possible
      ipw2x00: remove old compat_net_dev_ops code
      usbnet: remove old compat_net_dev_ops code
      8390(p): remove old compat_net_dev_ops code
      bmac: convert to net_device_ops
      cpmac: convert to net_device_ops
      dm9000: convert to net_device_ops
      hplance: convert to net_device_ops
      ibmveth: convert to net_device_ops
      irda/au1k_ir: convert to net_device_ops
      irda/pxaficp_ir: convert to net_device_ops
      irda/sa1100_ir: convert to net_device_ops
      iseries_veth: convert to net_device_ops
      ixp2000/ixpdev: convert to net_device_ops
      jazzsonic: convert to net_device_ops
      korina: convert to net_device_ops
      lib82596: convert to net_device_ops
      mace: convert to net_device_ops
      macmace: convert to net_device_ops
      meth: convert to net_device_ops
      mipsnet: convert to net_device_ops
      mvme147: convert to net_device_ops
      netx-eth: convert to net_device_ops
      pasemi_mac: convert to net_device_ops
      pci-skeleton: convert to net_device_ops
      rionet: convert to net_device_ops
      sb1250-mac: convert to net_device_ops
      sgiseeq: convert to net_device_ops
      smc911x: convert to net_device_ops
      sun3lance: convert to net_device_ops
      irda: include etherdevice.h for eth_*() functions
      wan/pc300_drv: convert to net_device_ops
      iseries_veth: fix build breakage
      sa1100_ir: fix build breakage
      8390p: fix build breakage
      vxge: fix possible NULL dereference in vxge-traffic.c
      vxge: use max() instead of VXGE_HW_SET_LEVEL
      lasi_82596: fix printk format warning
      ar9170: fix build when !CONFIG_PM
      de620: fix forgotten semicolon
      de600: convert PRINTK() to pr_debug()
      de620: convert PRINTK() to pr_debug() and cleanup
      mac89x0: remove PRINTK()
      skfddi: convert PRINTK() to pr_debug()
      Staging: agnx: switch config_interface to bss_info_changed
      net: remove COMPAT_NET_DEV_OPS
      3c50x: convert printk() to pr_<foo>()
      3c5xx: convert printk() to pr_<foo>()
      8139*: convert printk() to pr_<foo>()
      cfg80211: errno.h: define ERFKILL

Alexander Duyck (20):
      igb: always use adapter->itr as EITR value
      igb: reconfigure mailbox timeout logic
      igb: make rxcsum configuration seperate from multiqueue
      igb/ixgbe: remove unecessary checks for CHECKSUM_UNNECESSARY
      ixgbe: enable HW RSC for 82599
      igbvf: cleanup flags and allow for rx checksum to be disabled
      igb/igbvf: set rx csum always enabled in hw, disable via sw
      pci: update 82576 sr-iov quirk with latest device IDs
      ixgbe: make q_vectors dynamic to reduce netdev size
      ixgbe: skb_record_rx_queue should record rx queue instead of vector
      ixgbe: remove ixgbe_napi_add/del_all references
      ixgbe: always set header length in SRRCTL
      ixgbe: set queue0 for srrctl configuration correctly for DCB
      ixgbe: set max desc to prevent total RSC packet size of 64K
      igb: do not re-register DCA requester on device reset
      ixgbe: only register DCA requester once
      igb/e1000e: update PSSR_MDIX value to reflect correct bit
      ixgbe: use rx_buffer_info->dma instead of nr_frags to determine skb unmap
      ixgbe: move v_idx into q_vector and use as index only
      ixgbe: move tx processing into NAPI context

Alexandre Becholey (1):
      rt73usb: fix for master mode

Alexey Dobriyan (2):
      netns 1/2: don't get/put old netns on CLONE_NEWNET
      netns 2/2: extract net_create()

Amit Kumar Salecha (1):
      netxen: enable GRO support

Anant Gole (1):
      net: Add TI DaVinci EMAC driver

Andre Detsch (1):
      e100: Fix napi_enable BUG_ON when recovering from EEH error

Andreas Eversberg (12):
      mISDN: Add watchdog functionality to hfcmulti driver
      mISDN: DSP now uses ring buffer for echo canceler
      mISDN: Echo canceler now gets delay information from hardware
      mISDN: Fixed missing spin lock on pipeline process
      mISDN: Added layer-1-hold feature
      mISDN: Fix DTMF locking bug issue
      mISDN: Hardware acceleration is now possible in conjunction with audio recording
      mISDN: Fix TEI and SAPI handling
      mISDN: Add "sapi" information to debug messages
      mISDN: Add PCI ID for Junghanns 8S card
      mISDN: Fix DTMF detection enable/disable
      mISDN: Added PCI ID for new Junghanns.net Single E1 cards.

Andreas Mohr (2):
      e100: add non-MII PHY support
      mISDN: Free hfcpci IRQ if init was not successful

Andrew Gallatin (1):
      myri10ge: fix compile error

Andrew Morton (2):
      net/rfkill/rfkill.c: fix build with CONFIG_RFKILL_LEDS=n
      drivers/net/82596.c: suppress warnings

Andr√© Goddard Rosa (1):
      usbnet: ratelimit warning messages invoked from callback handler

Andy Grover (4):
      RDS: Correct some iw references in rdma_transport.c
      RDS: Fix ordering in a conditional
      RDS: Establish connection before parsing CMSGs
      RDS: use get_user_pages_fast()

Anna Neal (1):
      libertas: increase spi driver thread priority

Arnaldo Carvalho de Melo (3):
      inet_diag: Remove dup assignments
      net: Make inet_twsk_put similar to sock_put
      mISDN: Use kernel_{send,recv}msg instead of open coding

Ayaz Abdulla (4):
      forcedeth: add clock gating feature <resend>
      forcedeth: remove device id macros
      forcedeth: addition of new mcp89 device id
      removal of forcedeth device ids

Ben Hutchings (24):
      ethtool: Add port type PORT_OTHER
      mdio: Add register definitions for MDIO (clause 45)
      mdio: Add generic MDIO (clause 45) support functions
      sfc: Use generic MDIO functions and definitions
      chelsio: Use generic MDIO definitions and mdio_mii_ioctl()
      cxgb3: Use generic MDIO definitions and mdio_mii_ioctl()
      ixgbe: Use generic MDIO definitions and functions
      ixgb: Use generic MDIO definitions
      s2io: Use generic MDIO definitions
      mii: Simplify mii_resolve_flowctrl_fdx()
      mii: Add mii_advertise_flowctrl()
      mdio: Add mdio45_ethtool_spauseparam_an()
      sfc: Use generic MDIO flow control auto-negotiation functions
      ethtool/mdio: Report MDIO mode support and link partner advertising
      ethtool/mdio: Support backplane mode negotiation
      mii: Rewrite mii_ethtool_gset() to report mdio_support and lp_advertising
      mdio: Add 10GBASE-T SNR register definition
      mdio: Add XENPAK LASI register definitions
      sfc: Use generic XENPAK register definitions
      sfc: Remove lro module parameter
      chelsio: Use generic XENPAK LASI register definitions
      cxgb3: Use generic XENPAK LASI register definitions
      mdio: Expose 10GBASE-T MDI-X status via ethtool
      sfc: Expose 100/1000BASE-T MDI-X status via ethtool

Bing Zhao (7):
      libertas: support mesh for various firmware versions
      libertas: add support for Marvell SD8688 chip
      libertas: define macros for SDIO model numbers
      libertas: get SD8688 rx length with one CMD52
      libertas: implement function init/shutdown commands for SD8688
      libertas: read SD8688 firmware status from new register
      libertas: improve function init/shutdown handling for SD8688

Bob Copeland (22):
      ath5k: reduce exported channel list
      ath9k: separate ath9k specific code from ath9k_regd_get_ctl()
      ath9k: pass regd structure directly to regulatory functions
      atheros: introduce ath module containing common ath5k/ath9k/ar9170 code
      ath: move more setup code into ath_regd_init
      ath5k: use regulatory infrastructure
      ath5k: add support for Fukato Datacask Jupiter LEDs
      ath5k: fix initvals errors
      ath5k: use tasklet_hi_schedule for beacon queue
      ath5k: use bool for modparams
      ath5k: use rx hw descriptor pointer for self-linked check
      ath5k: manipulate rxlink and descriptor address under rxbuf lock
      ath5k: correct interrupt storm warning
      ath5k: use ctl settings based on current regdomain
      wl12xx: correct printk format warnings
      ath5k: update beacons in AP mode
      ath5k: avoid and warn on potential infinite loop
      ath5k: remove conf->beacon_int usage
      nl80211: use GFP_ATOMIC for michael mic failure message
      ath5k: disable beacon interrupt when interface is down
      mac80211: fix minstrel single-rate memory corruption
      ath5k: minor rfkill cleanup

Breno Leitao (2):
      ixgbe: Return PCI_ERS_RESULT_DISCONNECT when bus is disabled
      bnx2: no need to check before vfreeing

Brian Haley (2):
      IPv6: Add 'autoconf' and 'disable_ipv6' module parameters
      IPv6: Print error value when skb allocation fails

Brice Goglin (9):
      myri10ge: force stats update in ethtool gstats
      myri10ge: allow per-board firmware overriding
      myri10ge: add MODULE_DEVICE_TABLE
      myri10ge: fix tx ring size in ethtool -g
      myri10ge: allow LRO to be enabled via ethtool
      myri10ge: update version to 1.5.0-1.415
      myri10ge: fix the invokation of lro_flush_all
      myri10ge: drop myri10ge_lro module parameter
      myri10ge: Add support for vlan_features

Bruce Allan (7):
      e1000e: enable CRC stripping by default
      e1000e: do not attempt to disable smart powerdown if not supported
      e1000e: correct flow control thresholds
      e1000e: specify max supported frame size in adapter struct
      e1000e: add support for 82577/82578 GbE LOM parts
      e1000e: workaround a Tx hang on 82577/82578
      e1000e: bump the version number

Chaitanya Lala (1):
      e1000e: Expose MDI-X status via ethtool change

Chaithrika U S (1):
      TI DaVinci EMAC: Remove print_mac, DECLARE_MAC_BUF

Chris Friesen (1):
      ipv4: teach ipconfig about the MTU option in DHCP

Chris Wright (1):
      cfg80211: remove superfluous !last_request check in reg_device_remove()

Christian Lamparter (30):
      ar9170: fix hang on stop
      p54: clean up p54.h's struct p54_common
      p54: more SoftLED updates
      p54: add beacon filtering support
      Make ar9170 use common ath reg code
      p54: utilize all available key slots for decryption offload
      p54: remove obsolet signal quality calculation
      ath: add module information
      p54: remove module_ stubs
      p54: deactivate broken powersave function (part 2)
      p54: fix ps-poll delivery in ap mode
      mac80211: set CLEAR_PS for pspolled frames
      ar9170: rework rxstream code
      ar9170: handle otus' A-MPDU density definitions
      ar9170: uncomment powermgt case handle
      p54usb: remove some dead code
      p54usb: rework driver for resume
      ar9170usb: reset device on resume
      ar9170: fix beacon plcp settings
      ar9170: update hardware definitions
      ar9170: 40mhz fixes
      ar9170: introduce functions for MAC programming
      ar9170: use bitop macros for tx filter flags
      ar9170: kill duplicated HT feature flag
      ar9170: fix LED power state handling
      ar9170: fix lockdep warning on hibernate
      ar9170usb: more minor fixes
      ar9170: cancel led worker properly on exit
      ar9170: remove deprecated code
      ar9170: xmit code revamp

Cindy H Kao (2):
      wimax/i2400m: when bootstrap fails, reinitialize the bootrom
      wimax/i2400m: use -EL3RST to indicate device reset instead of -ERESTARTSYS

Cliff Cai (1):
      wireless: libertas: fix unaligned accesses

Dan Carpenter (2):
      ERR_PTR() dereference in net/rds/iw.c
      ERR_PTR() dereference in net/rds/ib.c

Dan Williams (5):
      libertas: simplify and clean up association/start/join setup
      libertas: restyle Marvell & IEEE TLV structure names
      libertas: convert CMD_802_11_AUTHENTICATE to a direct command
      libertas: convert CMD_802_11_ASSOCIATE to a direct command
      libertas: fix WPA adhoc network creation

Daniel C Halperin (2):
      iwlwifi: do not set dual_stream_ant_msk for 3 streams
      iwlwifi: check triple_stream_basic_rates in iwl_full_rxon_required

Daniel Mack (1):
      net: smsc911x: add power management functions

Daniel Wagner (1):
      mac80211_hwsim: Group radios

Dave Graham (1):
      e1000e: Fixes possible phy corrupton on 82571 designs.

David Kilroy (2):
      cfg80211: mark ops as pointer to const
      cfg80211: mark wiphy->privid as pointer to const

David S. Miller (62):
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      Revert "vxge: use max() instead of VXGE_HW_SET_LEVEL"
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      net: Avoid modulus in skb_tx_hash() for forwarding case.
      net: Add missing rculist.h include to netdevice.h
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      net: Fix arg to trace_napi_poll() in netpoll.
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      net: Remove bogus reference to BUS_ID_SIZE in sysfs code.
      ixp4xx_eth: Remove references to BUS_ID_SIZE.
      cpmac: Remove references to BUS_ID_SIZE, use MII_BUS_ID_SIZE.
      sh_eth: Remove references to BUS_ID_SIZE, use MII_BUS_ID_SIZE instead.
      nl80211: Eliminate reference to BUS_ID_SIZE.
      phy: Eliminate references to BUS_ID_SIZE.
      appletalk: Add proper locking around IPDDP routing table.
      aoe: Remove superfluous clearing of skb fields in new_skb().
      wavelan: Remove bogus debugging on skb->next being non-NULL.
      p54: Use SKB list handling helpers instead of by-hand code.
      rtl8187: Remove pointless check in rtl8187_rx_cb().
      atm: Use SKB queue and list helpers instead of doing it by-hand.
      decnet: Use SKB queue and list helpers instead of doing it by-hand.
      econet: Use SKB queue and list helpers instead of doing it by-hand.
      tcp: Use SKB queue and list helpers instead of doing it by-hand.
      irda: Use SKB queue and list helpers instead of doing it by-hand.
      llc: Kill outdated and incorrect comment.
      Merge branch 'linux-2.6.31.y' of git://git.kernel.org/.../inaky/wimax
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'net-next' of git://git.kernel.org/.../vxy/lksctp-dev
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      bluetooth: Kill skb_frags_no(), unused.
      skbuff: Add frag list abstraction interfaces.
      netdevice.h: Use frag list abstraction interfaces.
      appletalk: Use frag list abstraction interfaces.
      datagram: Use frag list abstraction interfaces.
      net/core/dev.c: Use frag list abstraction interfaces.
      net/core/skbuff.c: Use frag list abstraction interfaces.
      net/core/user_dma.c: Use frag list abstraction interfaces.
      ipv4: Use frag list abstraction interfaces.
      ipv6: Use frag list abstraction interfaces.
      netfilter: Use frag list abstraction interfaces.
      phonet: Use frag list abstraction interfaces.
      sctp: Use frag list abstraction interfaces.
      xfrm: Use frag list abstraction interfaces.
      be2net: Remove unnecessary frag list traversing.
      netfilter: Fix extra semi-colon in skb_walk_frags() changes.
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      ieee802154: Use '%Zu' printf format for size_t.
      Merge branch 'master' of git://git.kernel.org/.../holtmann/bluetooth-next-2.6
      Merge branch 'linux-2.6.31.y' of git://git.kernel.org/.../inaky/wimax
      Merge branch 'master' of git://git.kernel.org/.../kaber/nf-next-2.6
      Merge branch 'master' of git://git.kernel.org/.../kaber/nf-next-2.6
      Merge branch 'for-next' of git://git.kernel.org/.../sameo/irda-2.6
      Merge branch 'master' of master.kernel.org:/.../torvalds/linux-2.6

David Woodhouse (2):
      tun: add IFF_TUN_EXCL flag to avoid opening a persistent device.
      tun: add tun_flags, owner, group attributes in sysfs

Dhananjay Phadke (21):
      netxen: code cleanup
      netxen: refactor netxen_adapter
      netxen: refactor transmit code
      netxen: defer firmware handshake
      netxen: async link event handling
      netxen: allocate status rings dynamically
      netxen: annotate register access functions
      netxen: sanitize function names
      netxen: enable rss for NX2031
      netxen: cache align register map table
      netxen: fix link event handling
      netxen: refactor netxen_recv_context struct
      netxen: fix firmware download
      netxen: fix race in tx ring acccess
      netxen: fix mac list management
      netxen: fix bonding support
      netxen: cache msi register offset
      netxen: fix irq tear down and msix leak.
      netxen: disable msi-x for NC512m adapter
      netxen: trivial register access cleanup
      netxen: fix msi irq setup

Dirk Brandewie (4):
      wimax/i2400m: Change d_printf() level for secure boot messages
      wimax/i2400m/sdio: Implement I2400M_RT_BUS reset type
      wimax/i2400m: move boot time poke table out of common driver
      wimax/i2400m/sdio: Add device specific poke table.

Divy Le Ray (8):
      cxgb3: set phy's mdio dev before the phy init sequence
      cxgb: set phy's mdio dev before the phy init sequence
      cxgb3: move away from LLTX
      cxgb3: Add Aeluros 2020 phy support
      cxgb3: add support for the Aquantia 10G-BT phy
      cxgb3: Update FW to 7.4.0
      cxgb3: minor aq100x phy fixes
      cxgb3: remove __GFP_NOFAIL usage

Don Skidmore (6):
      ixgbe: fix IXGBE_MTQC values
      ixgbe: add support for addition VT_CTL defines
      ixgbe: add define to support 82599 64 IVAR registers
      ixgbe: Use pci_wake_from_d3() instead of multiple pci_enable_wake()
      ixgbe: fix failing to log fan failures
      ixgbe: fix 82598 SFP initialization after driver load.

Emil Medve (1):
      mv643xx_eth: Remove a stale PPC_MULTIPLATFORM

Eric Dumazet (36):
      net: remove superfluous call to synchronize_net()
      loopback: packet drops accounting
      net: netif_tx_queue_stopped too expensive
      tcp: tcp_prequeue() cleanup
      tcp: tcp_prequeue() can use keyed wakeups
      bnx2: bnx2_tx_int() optimizations
      net: tx scalability works : trans_start
      net: add tx_packets/tx_bytes/tx_dropped counters in struct netdev_queue
      vlan: use struct netdev_queue counters instead of dev->stats
      net: release dst entry in dev_hard_start_xmit()
      ppp: unset IFF_XMIT_DST_RELEASE in ppp_setup()
      sch_teql: Use net_device internal stats
      net: txq_trans_update() helper
      atl1: use netdev->stats
      net: ALIGN/PTR_ALIGN cleanup in alloc_netdev_mq()/netdev_priv()
      net: use netdev stats in b44, sundance, via-rhine and via-velocity
      net: net/core/sock.c cleanup
      net: dont update dev->trans_start in 10GB drivers
      net: dont update dev->trans_start
      net: unset IFF_XMIT_DST_RELEASE in ipip_tunnel_setup()
      atm: unset IFF_XMIT_DST_RELEASE in clip_setup()
      net: unset IFF_XMIT_DST_RELEASE in ipgre_tunnel_setup()
      veth: dont release skb->dst in veth_xmit()
      net: unset IFF_XMIT_DST_RELEASE for qeth and ipoib
      net: ipv4/ip_sockglue.c cleanups
      net: add _skb_dst opaque field
      net: skb->rtable accessor
      net: skb->dst accessors
      net: skb cleanup
      net: num_dma_maps is not used
      net: skb_shared_info optimization
      net: dev_addr_init() fix
      r8169: use dev_kfree_skb() instead of dev_kfree_skb_irq()
      net: No more expensive sock_hold()/sock_put() on each tx
      net: ntohs() misuse
      net: use a deferred timer in rt_check_expire

Eric W. Biederman (10):
      syscall: Implement a convinience function restart_syscall
      net-sysfs: Use rtnl_trylock in sysfs methods.
      net: FIX ipv6_forward sysctl restart
      net: Fix devinet_sysctl_forward
      net: Fix bridgeing sysfs handling of rtnl_lock
      net: Fix ipoib rtnl_lock sysfs deadlock.
      net: FIX bonding sysfs rtnl_lock deadlock
      syscall: Sort out syscall_restart name clash.
      af_packet: Teach to listen for multiple unicast addresses.
      tun: Fix unregister race

Evgeniy Polyakov (2):
      netfilter: x_tables: added hook number into match extension parameter structure.
      netfilter: passive OS fingerprint xtables match

FUJITA Tomonori (1):
      net: replace dma_sync_single with dma_sync_single_for_cpu

Fabio Estevam (1):
      fec: Add FEC support for MX35 processor

Fabio Rossi (1):
      ath5k: fix interpolation with equal power levels

Figo.zhang (4):
      net pkgen.c:fix no need for check
      vxge: No need for check vfree() pointer.
      tehuti: No need check vfree() pointer.
      netxen: No need to check vfree() pointer.

Finn Thain (1):
      mac8390: use printk MAC address format

Florian Fainelli (5):
      r6040: check for absent PHY
      r6040: bump version to 0.23 and date to 05May2009
      r6040: check and update media status
      korina: periodically poll the media
      cpmac: remove unused variable.

Florian Westphal (4):
      syncookies: remove last_synq_overflow from struct tcp_sock
      netfilter: xt_NFQUEUE: use NFPROTO_UNSPEC
      netfilter: xt_NFQUEUE: queue balancing support
      netfilter: ipt_MASQUERADE: remove redundant rwlock

Frank Seidel (2):
      mISDN: Reduce stack size in dsp_cmx_send()
      mISDN: Add allocation of recvbuf[1500] at run time to reduce stack size

Gabor Juhos (2):
      ath9k: uninline ath9k_io{read,write}32 routines
      ath9k: remove redundant AR9285 checks

Gabriel Paubert (1):
      net: Remove obsolete MV64360 config option

Geert Uytterhoeven (1):
      wireless: WL12XX should depend on GENERIC_HARDIRQS

Graf Yang (1):
      netdev: bfin_mac: add Blackfin MII bus to platform bus to allow DSA access

Graff Yang (1):
      irda: new Blackfin on-chip SIR IrDA driver

Grant Likely (14):
      of: add of_parse_phandle() helper for parsing phandle properties
      phylib: rework to prepare for OF registration of PHYs
      phylib: add *_direct() variants of phy_connect and phy_attach functions
      openfirmware: Add OF phylib support code
      net: Rework mpc5200 fec driver to use of_mdio infrastructure.
      net: rework fsl_pq_mdio driver to use of_mdio infrastructure
      net: Rework gianfar driver to use of_mdio infrastructure.
      net: Rework pasemi_mac driver to use of_mdio infrastructure
      net: Rework ucc_geth driver to use of_mdio infrastructure
      powerpc/82xx: Rework Embedded Planet ep8248e platform to use of_mdio
      net: Rework fs_enet driver to use of_mdio infrastructure
      net: add Xilinx ll_temac device driver
      net: fix fsl_pq_mdio driver to use module_init()
      net: Fix ucc_geth.c handling of fixed-link w/o phy-connection-type property.

Greg Kroah-Hartman (3):
      net: remove driver_data direct access of struct device
      net: remove driver_data direct access of struct device from more drivers
      Wireless: remove driver_data direct access of struct device

Gustavo F. Padovan (3):
      Bluetooth: Use macros for L2CAP channel identifiers
      Bluetooth: Use macro for L2CAP hint mask on receiving config request
      Bluetooth: Fix errors and warnings in L2CAP reported by checkpatch.pl

G√°bor Stefanik (7):
      rtl8187: Remove the "8187B chip detected" message when probing RTL8187B cards
      mac80211: Fix handling of retry count of NO_ACK frames in minstrel
      mac80211: Fix handling of retry count of NO_ACK frames in PID
      iwlwifi: Fix handling of retry count of NO_ACK frames in iwl-{3945|agn}-rs
      ath9k: Fix handling of retry count of NO_ACK frames
      mac80211: Warn if the rate controller requests retries for a NO_ACK frame
      zd1211rw: Replace ZD_CS_MULTICAST with ZD_CS_NO_ACK

Haiying Wang (3):
      net/phy/marvell: update m88e1111 support for SGMII mode
      fsl_pq_mido: Set the first UCC as the mii management interface master
      net/ucc_geth: Add SGMII support for UEC GETH driver

Hauke Mehrtens (1):
      p54usb: Fixes compile error with CONFIG_PM=n

Hendrik Brueckner (7):
      af_iucv: sync sk shutdown flag if iucv path is quiesced
      af_iucv: add sockopt() to enable/disable use of IPRM_DATA msgs
      af_iucv: Support data in IUCV msg parameter lists (IPRMDATA)
      af_iucv: Modify iucv msg target class using control msghdr
      af_iucv: Provide new socket type SOCK_SEQPACKET
      af_iucv: cleanup and refactor recvmsg() EFAULT handling
      af_iucv: New socket option for setting IUCV MSGLIMITs

Herbert Xu (26):
      gro: New frags interface to avoid copying shinfo
      gro: Fix handling of headers that extend over the tail
      gro: Fix COMPLETE checksum handling
      tcp: Unexport TCPv6 GRO functions
      skbuff: Move new code into __copy_skb_header
      skbuff: Copy csum instead of csum_start/csum_offset
      gro: Open-code frags copy in skb_gro_receive
      gro: Inline skb_gro_header and cache frag0 virtual address
      gro: Localise offset/headlen in skb_gro_offset
      gro: Only use skb_gro_header for completely non-linear packets
      tcp: Optimise GRO port comparisons
      tcp: Remove unnecessary window comparisons for GRO
      tcp: Optimise len/mss comparison
      gro: Optimise length comparison in skb_gro_header
      gro: Avoid unnecessary comparison after skb_gro_header
      ipv4: Use 32-bit loads for ID and length in GRO
      gro: Open-code final pskb_may_pull
      gro: Nasty optimisations for page frags in skb_gro_receive
      gro: Store shinfo in local variable in skb_gro_receive
      tcp: Do not check flush when comparing options for GRO
      gso: Stop fraglists from escaping
      tun: Only wake up writers
      virtio_net: Set correct gso->hdr_len
      tun: Optimise handling of bogus gso->hdr_len
      net: Ensure partial checksum offset is inside the skb head
      virtio_net: Fix IP alignment on non-mergeable RX path

Huang Weiyi (3):
      RDS: remove unused #include <version.h>
      cfg80211: remove duplicated #include
      nl80211: remove duplicated #include

Ilpo J√§rvinen (2):
      tcp: extend ECN sysctl to allow server-side only ECN
      tcp: fix loop in ofo handling code and reduce its complexity

Inaky Perez-Gonzalez (24):
      wimax/i2400m: generate fake source MAC address with random_ether_addr()
      wimax/i2400m: trace commands sent from user space on the "echo" pipe
      wimax/i2400m: allow kernel commands to device to be logged too
      wimax/i2400m: factor out 'state report's TLV handling to a function
      wimax/i2400m: remove redundant readiness checks from i2400m_report_tlv_*()
      wimax: document why wimax_msg_*() operations can be used in any state
      wimax/i2400m: sdio: set the block size before enabling the function
      wimax/i2400m: usb: fix device reset on autosuspend while not yet idle
      wimax: a new API call was added, increment minor protocol version number
      wimax/i2400m: introduce module parameter to disable entering power save
      wimax/i2400m: don't call netif_start_queue() in _tx_msg_sent()
      wimax/i2400m: i2400m's work queue should be initialized before RX support
      wimax/i2400m: i2400m_schedule_work() doesn't need i2400m->work_queue
      wimax/i2400m: rename misleading I2400M_PL_PAD to I2400M_PL_ALIGN
      wimax/i2400m: fix panic/warnings caused by missed check on empty TX message
      wimax/i2400m: fix panic due to missed corner cases on tail_room calculation
      wimax/i2400m: don't reset device on i2400m_dev_shutdown()
      wimax/i2400m: fix oops when the TX FIFO fills up due to a missing check
      wimax/i2400m: if a device reboot happens during probe, handle it
      wimax/i2400m: Allow bus-specific driver to specify retry count
      wimax/i2400m: don't reset device when bootrom init retries are exceeded
      wimax/i2400m/sdio: Move all the RX code to a unified, IRQ based receive routine
      wimax: fix warning caused by not checking retval of rfkill_set_hw_state()
      wimax: fix gcc warnings in sh4 when calling BUG()

Ivo van Doorn (15):
      rt2x00: Move Move pci_dev specific access to rt2x00pci
      rt2x00: Fix Sparse warning
      rt2x00: Move iv_len into tx descriptor data
      rt2x00: Add support for L2 padding during TX/RX
      rt2x00: Implement support for 802.11n
      rt2x00: Implement support for rt2800usb
      rt2x00: Add new USB ID for rt2800usb
      rt2x00: Synchronize initialization with rt2870 driver
      rt2x00: Simplify rt2x00_check_rev
      rt2x00: Fix chipset detection for rt73usb
      rt2x00: Add USB ID for rt2800usb
      rt2x00: Add new rt2800usb USB ID's for Sweex
      rt2x00: Remove usage of IEEE80211_CONF_CHANGE_BEACON_INTERVAL
      rt2x00: Add new rt2800usb USB ID's
      rt2x00: Remove last usage of beacon_int from ieee80211_config

Jan Engelhardt (11):
      netfilter: xtables: use NFPROTO_ for xt_proto_init callsites
      netfilter: queue: use NFPROTO_ for queue callsites
      netfilter: xtables: use NFPROTO_ in standard targets
      netfilter: xtables: remove redundant casts
      netfilter: xtables: fix const inconsistency
      netfilter: xtables: consolidate open-coded logic
      netfilter: xtables: reduce indent level by one
      netfilter: xtables: remove some goto
      netfilter: xtables: remove another level of indent
      netfilter: xtables: consolidate comefrom debug cast access
      netfilter: xtables: print hook name instead of mask

Jan Kasprzak (1):
      netfilter: nf_ct_icmp: keep the ICMP ct entries longer

Jarek Poplawski (5):
      pkt_sched: gen_estimator: Fix signed integers right-shifts.
      pkt_sched: Use PSCHED_SHIFT in PSCHED time conversion
      pkt_sched: Change PSCHED_SHIFT from 10 to 6
      ipv4: Fix fib_trie rebalancing
      pkt_sched: Rename PSCHED_US2NS and PSCHED_NS2US

Jean Delvare (2):
      sfc: Don't specify unexistent IRQ
      r8169: Use a different default for each family

Jean-Mickael Guerin (1):
      sctp: fix sack_timeout sysctl min and max types

Jeff Hansen (3):
      ath9k: Reset SC_OP_TSF_RESET flag after stuck beacon
      ath9k: Combine legacy and 11n rc statistics
      ath9k: Add "debug" file to debugfs

Jeff Kirsher (1):
      igb: add RQDPC (Receive Queue Drop Packet Count) register macro

Jesper Dangaard Brouer (7):
      igb: Implement reading of reg RQDPC (Receive Queue Drop Packet Count)
      igb: Record host memory receive overflow in net_stats
      8021q: Vlan driver should use rcu_barrier() on unload instead of syncronize_net()
      nfnetlink_queue: Use rcu_barrier() on module unload.
      can: af_can.c use rcu_barrier() on module unload.
      sctp: protocol.c call rcu_barrier() on unload.
      sunrpc/auth_gss: Call rcu_barrier() on module unload.

Jesse Brandeburg (12):
      ixgbe: fix link down initial state
      ixgb: fix link down initial state
      igb: fix link down inital state
      e1000e: indicate link down at load
      e1000: init link state correctly
      e1000/e1000e/igb/ixgb: do not use netif_wake_queue un-necessarily
      sctp: add feature bit for SCTP offload in hardware
      igb: Enable SCTP checksum offloading
      ixgbe: enable hardware offload for sctp
      e1000/e1000e/igb/ixgb: don't txhang after link down
      ixgbe: Cleanup feature setup code to make the code more readable
      ixgbe: Re-adjust ring layouts to have better cacheline efficiency

Jianjun Kong (1):
      rtl8139: unify the struct's name

Jie Yang (1):
      atl1c: disable L1/L0s when link detected

Jiri Pirko (13):
      bonding: use ethtool for link checking first
      bonding: ignore updelay param when there is no active slave
      ne2k-pci: use dev->addr_len instead of "6"
      net: introduce a list of device addresses dev_addr_list (v6)
      bonding: get rid of CONFIG_PROC_FS ifdefs
      net: check retval of dev_addr_init()
      net: remove needless (now buggy) & from dev->dev_addr
      net: remove needless (now buggy) & from dev->dev_addr (part2)
      bridge: avoid an extra space in br_fdb_update()
      net: correct a comment for the final #endif
      bonding: allow bond in mode balance-alb to work properly in bridge -try4.3
      bonding: use bond_is_lb() when it's appropriate
      net: convert unicast addr list

Jiri Slaby (2):
      ath5k: 5211, don't crypt every protected frame
      ath5k: Enable AP mode

Joakim Tjernlund (1):
      ucc_geth: Move freeing of TX packets to NAPI context

Joe Perches (3):
      drivers/net: Convert #ifdef DEBUG printk(KERN_DEBUG to pr_debug(
      atl1c_main.c: add wait_for_idle routine
      x_tables: Convert printk to pr_err

Johann Baudy (1):
      net: TX_RING and packet mmap

Johannes Berg (113):
      nl80211: validate some input better
      rfkill: remove deprecated state constants
      rfkill: remove user_claim stuff
      rfkill-input: remove unused code
      mac80211: move ieee80211_enable_ht function to mlme.c
      cfg80211: introduce scan IE limit attribute
      mac80211: pass all probe request IEs to driver
      mac80211: include HT capabilities in probe request
      cfg80211: add cipher capabilities
      mac80211: re-upload keys only after telling driver about association
      mac80211: update injection documentation
      cfg80211: convert mutex assert to macro
      mac80211: add hardware restart function
      mac80211: improve powersave implementation
      mac80211: disable powersave if pm_qos asks for low latency
      mac80211: implement beacon filtering in software
      mac80211: enable PS by default
      mac80211: document powersaving/beacon filter future
      nl80211: send wiphy along with netdev
      cfg80211/mac80211: move wext SIWMLME into cfg80211
      cfg80211/nl80211: add IBSS API
      mac80211: convert to cfg80211 IBSS API
      cfg80211: clean up includes
      rndis_wlan: remove nickname support
      ar9170: support HT receive and channel config
      cfg80211: clear WEXT SSID when clearing IBSS
      cfg80211: mark all WEXT handlers _GPL
      mac80211: validate TIM IE length (redux)
      iwlwifi: rename PROBE_OPTION_MAX_API1 to PROBE_OPTION_MAX_3945
      iwlwifi: improve scan support
      iwlwifi: support truly passive scanning
      mac80211: fix IBSS code to not sleep while atomic
      rndis_wlan: make some symbols static
      mac80211: fix variable truncation on 32-bit
      mac80211: remove IEEE80211_CONF_CHANGE_DYNPS_TIMEOUT
      nl80211: allow configuring IBSS beacon interval
      mac80211: calculate maximum sleep interval
      mac80211: fix various problems in ibss code
      mac80211: fix PS vs. scan race
      mac80211: rename max_sleep_interval to max_sleep_period
      mac80211: internally clear failed scans properly
      mac80211: fix scan races and rework scanning
      mac80211: clean up beacon interval settings
      mac80211: unify config_interface and bss_info_changed
      mac80211: add driver ops wrappers
      mac80211_hwsim: fix bogus warning
      mac80211: fix probe response processing
      mac80211: tell driver when idle
      mac80211: report operating frequency rather than current
      mac80211: fix scan channel race
      mac80211: set default QoS values according to spec
      cfg80211: fix wext iw_freq parsing
      iwlwifi: make iwl_set_rate static
      mac80211: improve scan timing
      mac80211: move HT operation mode BSS info
      mac80211: properly track HT operation_mode
      mac80211: remove ieee80211_ht_bss_info
      iwlwifi: do proper hw restart
      iwlwifi: fix PS disable status race
      iwlwifi: clean up PS code
      cfg80211: constify key mac address in ops
      cfg80211: put wext data into substructure
      cfg80211: disallow interfering with stations on non-AP
      wext: fix get_wireless_stats locking
      cfg80211: implement wext key handling
      nl80211: improve station flags handling
      wext: remove seq_start/stop sparse annotations
      mac80211: respond to beacon loss report only once
      mac80211: split out and decrease probe wait time
      mac80211: don't connect to IBSS network with different privacy
      mac80211: IBSS supported rate fixes
      mac80211: make noack test available
      mac80211: move channel switch code
      mac80211: cancel/restart all timers across suspend/resume
      b43/legacy: fix beacon change processing
      cfg80211: allow wext to remove keys that don't exist
      mac80211: fix kernel-doc
      mac80211: don't try to do anything on unchanged genIE
      mac80211: fix parameter confusion when finding IBSS
      mac80211: fix managed mode BSSID handling
      wext: remove atomic requirement for wireless stats
      mac80211: fix probe response wait timing
      mac80211: correct probe wait time
      mac80211: deprecate conf.beacon_int properly
      cfg80211: validate AID of stations being added
      nl80211: bounce scan request back to userspace
      cfg80211: use key size constants
      mac80211: fix transposed min/max CW values
      cfg80211: disallow interfering with stations on non-AP (part 2)
      net: introduce pre-up netdev notifier
      mac80211_hwsim: remove deprecated radio_enabled
      rfkill: rewrite
      rfkill: create useful userspace interface
      cfg80211: move txpower wext from mac80211
      rfkill: add function to query state
      cfg80211: add rfkill support
      iwm: port to new cfg80211 rfkill
      rfkill: always init poll delayed work
      rfkill: document /dev/rfkill
      cfg80211: fix Kconfig for users of cfg80211
      wimax: depend on rfkill properly
      rfkill: include err.h
      iwlwifi: port to cfg80211 rfkill
      ar9170: interpret firmware debug commands
      rfkill: print events when input handler is disabled/enabled
      b43/legacy: port to cfg80211 rfkill
      rfkill: remove input Kconfig
      sony: fix rfkill code
      mac80211: do not pass PS frames out of mac80211 again
      mac80211: don't use master netdev name
      mac80211: clean up return value of __ieee80211_parse_tx_radiotap
      mac80211: disable PS while probing AP
      cfg80211: fix rfkill locking problem

John Dykstra (5):
      pcnet32: Remove redundant set of skb->dev
      pcnet32: Remove pointless memory barriers
      Network Drop Monitor: Fix skb_kill_datagram
      tcp: tcp_prequeue() can use keyed wakeups
      net core: Some interface flags not returned by SIOCGIFFLAGS

John W. Linville (8):
      rndis_wlan: initiate cfg80211 conversion
      rndis_wlan: convert get/set mode to cfg80211
      libertas: fix warning about %zd:
      rndis_wlan: select CFG80211 in Kconfig
      libertas: fix format warning
      wireless: remove some (bogus?) 'may be used uninitialized' warnings
      p54: correct merge damage from "p54: more SoftLED updates"
      ath5k: avoid leaking mutex in ath5k_config

Jouni Malinen (34):
      nl80211: Require auth type for NL80211_CMD_AUTHENTICATE
      nl80211: Generate deauth/disassoc event for locally generated frames
      nl80211: Add Michael MIC failure event
      mac80211: Report rejected association to user space SME
      mac80211: Allow scan to be requested in AP mode
      nl80211: Add set/get for frag/rts threshold and retry limits
      nl80211: Add event for authentication/association timeout
      nl80211: Send timeout event on failed direct probe
      mac80211: Use a shared function to release frames from RX reorder buf
      mac80211: Add a timeout for frames in the RX reorder buffer
      mac80211: Comment the order of HT RX reorder handler vs. RX handlers
      mac80211: Update SA Query transaction id length
      nl80211 : Add support for configuring MFP
      mac80211: Drop unencrypted frames based on key setup
      mac80211: MFP - Drop unprotected Action frames prior key setup
      mac80211: Robust Action frame categories for MFP
      nl80211: Validate MFP flag type when parsing STA flags
      nl80211: Add IEEE 802.1X PAE control for station mode
      nl80211: Add RSC configuration for new keys
      mac80211: Cancel pending probereq poll on beacon RX
      ath9k: Fix a check for multicast address for virtual wiphy
      ath9k: Clean up RX processing a bit
      ath9k: Fix PS mode operation to receive buffered broadcast/multicast frames
      nl80211: Validate NL80211_ATTR_KEY_SEQ length
      ath9k: Wake up for TX in mac80211 timeout=0 sleep mode
      ath9k: Do not try to calibrate radio when in sleep mode
      ath9k: Use TSFOOR interrupt to trigger TSF sync with next Beacon
      ath9k: Wake up for RX filter changes
      ath9k: Set PM field in frame control when in PS mode
      mac80211: PS processing for every Beacon with our AID in TIM
      mac80211: Do not override AID in the duration field
      ath9k: Optimize TBTT/DTIM calculation for timers
      ath9k: Update Beacon timers based on timestamp from the AP
      ath9k: Add sanity check for beacon_int in adhoc/mesh case

Jozsef Kadlecsik (1):
      netfilter: nf_ct_tcp: TCP simultaneous open support

Julia Lawall (1):
      drivers/net: use dev_get_drvdata

Jussi Kivilinna (13):
      cfg80211: add cfg80211_inform_bss
      rndis_wlan: change quality level scale
      rndis_wlan: convert get range to cfg80211
      rndis_wlan: convert scan to cfg80211
      rndis_wlan: fix initialization order for workqueue&workers
      rndis_wlan: free priv correctly when rndis_wext_bind fails
      rndis_wlan: fix support for bcm4320a
      rndis_wlan: remove CAP_SUPPORT_TXPOWER/OID_802_11_TX_POWER_LEVEL code
      rndis_wlan: explain bits used in key setup code.
      rndis_wlan: split add_wpa_key from rndis_iw_set_encode_ext
      rndis_wlan: do not try to restore wpa keys using add_wep_key()
      rndis_wlan: cleanup: capitalize enum labels
      rndis_wlan: cleanup: rename all rndis_wext* objects to rndis_wlan*

Kalle Valo (1):
      wl12xx: add driver

Karsten Keil (7):
      mISDN: Fix skb leak in error cases
      mISDN: Add XHFC support for embedded Speech-Design board to hfcmulti
      mISDN: Cleanup debug messages
      ISDN:Fix DMA alloc for hfcpci
      mISDN: Fix overlapping data access
      mISDN: Do not disable IRQ in ph_data_ind()
      mISDN: cleanup mISDNhw.h

Ken Kawasaki (1):
      3c589_cs: add cis(firmware) of 3Com multifunction pcmcia card

Kevin Hao (1):
      net/ucc_geth: allow to set mac address on running device

Klaus-Dieter Wacket (1):
      qeth: Clear SBALF15 in any case for output buffers.

Kumar Gala (2):
      fs_enet: Remove dead code
      gianfar: Use memset instead of cacheable_memzero

Kyle McMartin (1):
      MAINTAINERS: rds list is moderated

Larry Finger (6):
      kaweth: Clean up code
      b43legacy: Do not select HW_RANDOM
      rfkill: Fix broken rfkill LED in 2.6.30-rc1
      b43legacy: Fixes for beaconing
      b43legacy: Clean up beacon IRQ
      rtl8187: Implement TX/RX blink for LED

Laszlo Attila Toth (1):
      netfilter: xt_socket: added new revision of the 'socket' match supporting flags

Lennert Buytenhek (4):
      mv643xx_eth: fix variable shadowing sparse warning
      mv643xx_eth: count handling a link event as one unit of napi work
      mv643xx_eth: minor register definition cleanup
      mv643xx_eth: rework receive skb cache alignment

Li Zefan (1):
      cls_cgroup: remove unneeded cgroup_lock

Luis R. Rodriguez (33):
      ath9k: Update maintainers for ath9k
      atheros: put atheros wireless drivers into ath/
      ath: space cleanup
      ath5k: sparse fix ath5k_led_on needs to be static
      cfg80211: respect API on orig_flags on channel for beacon hint
      cfg80211: add netlink channel put helper
      cfg80211: send regulatory beacon hint events to userspace
      atheros: fix propagation of bad EEPROM on regulatory init
      cfg80211: make nl80211_send_mlme_timeout() static
      mac80211: Fix sparse warning for ssid_len on ieee80211_sta_config_auth()
      ath9k: make private driver rate tables const
      cfg80211: Process regulatory max bandwidth checks for HT40
      wireless: rename IEEE80211_CHAN_NO_FAT_* to HT40-/+
      mac80211: check if HT40+/- is allowed before sending assoc
      cfg80211: check allowed channel type upon userspace requests
      mac80211/cfg80211: move wiphy specific debugfs entries to cfg80211
      cfg80211: add debugfs HT40 allow map
      cfg80211: return immediately if num reg rules > NL80211_MAX_SUPP_REG_RULES
      cfg80211: cleanup return calls on nl80211_set_reg()
      cfg80211: fix in nl80211_set_reg()
      ath9k: fix custom regulatory call position
      ath9k: set max default eirp to 20 dBm
      cfg80211: warn when wiphy_apply_custom_regulatory() does nothing
      mac80211: handle -EALREADY on cfg80211 op assoc req
      ar9170: add support for 1-stage firmware
      ar9170: add AVM FRITZ devices
      cfg80211: fix for duplicate userspace replies
      ath: make regulatory parsing more verbose on debug
      cfg80211: make ieee80211_get_mesh_hdrlen() static
      mac80211: extend sta kdoc - explain when they are added
      mac80211: removed unused variable in ieee80211_tx()
      cfg80211: fix for duplicate response for driver reg request
      mac80211: disable moving between PS modes during scan

Maciej W. Rozycki (1):
      declance: Restore tx descriptor ring locking

Magnus Damm (1):
      smsc911x: add fifo byteswap support V2

Mallikarjuna R Chilakala (2):
      ixgbe: Fix 82599 adapter link flickering issues
      ixgbe: ethtool support to change advertised link modes of 82599 adapters

Marcel Holtmann (10):
      Bluetooth: Remove unnecessary variable initialization
      Bluetooth: Add basic constants for L2CAP ERTM support and use them
      Bluetooth: Remove pointless endian conversion helpers
      Bluetooth: Use only MISC_DYNAMIC_MINOR for virtual driver
      Bluetooth: Use wait_event_interruptible for virtual driver
      Bluetooth: Remove BKL from open callback of virtual driver
      Bluetooth: Remove unused and unneeded support in virtual driver
      Bluetooth: Add native RFKILL soft-switch support for all devices
      Bluetooth: Fix Kconfig issue with RFKILL integration
      Bluetooth: Fix issue with uninitialized nsh.type in DTL-1 driver

Marek Vasut (1):
      Add support for CF8381 WiFi card.

Masakazu Mokuno (1):
      net/ps3: Update maintainer

Mateusz Mandera (1):
      8390p: Get rid of init_module/cleanup_module

Matt Carlson (7):
      tg3: Allow screaming interrupt detection
      tg3: Handle NVRAM absent cases
      tg3: Prevent send BD corruption
      tg3: Allow 5761 WOL and LED fixes to 5761S too
      tg3: Limit CLKREQ fix to A[01] of 57780 asic rev
      tg3: Restore LAA sooner in shutdown sequence
      tg3: Update version to 3.99

Matthias Ludwig (1):
      smsc911x: fix calculation of res_size for ioremap

Matthieu CASTET (2):
      b43: Fix possible unaligned u32 access
      mac80211 : fix unaligned rx skb

Max Filippov (12):
      p54spi: mask value read from SPI_ADRS_DMA_WRITE_CTRL in p54spi_wait_bit
      p54spi: fix p54spi_upload_firmware
      p54spi: fix p54spi_tx_frame DMA transfer initiation and skb cleanup
      p54spi: compensate firmware alignment bug in p54spi_rx
      p54spi: get rid of busy-wait loops
      p54: call p54_wake_free_queues on every p54_free_skb and p54_rx_frame_sent
      p54spi: fix incorrect access sequence to DMA_WRITE_CTRL in p54spi_spi_write_dma
      p54spi: cosmetic fixes: use even byte count in SPI write; drop unused interrupt status read
      p54spi: return status of p54spi_wakeup
      p54spi: always call p54spi_sleep in p54spi_tx_frame if p54spi_wakeup succeeded
      p54spi: use firmware/DMA bug workaround that work under hight load in p54spi_rx
      p54spi: drop test for FW_STATE_RESET in p54spi_work

Michael Buesch (5):
      b43: Do not "select" HW_RANDOM
      b43: Remove unnecessary MMIO in interrupt hotpath
      cfg80211: Remove unnecessary ksize() call
      cfg80211: Use the correct IE buffer pointer
      b43: Add fw capabilities

Michael Hennerich (2):
      netdev: bfin_mac: drop useless IRQF_SHARED from Blackfin EMAC interrupt
      netdev: bfin_mac: fix performance issue found by netperf

Michael S. Tsirkin (3):
      net: skb_copy_datagram_const_iovec()
      tun: fix tun_chr_aio_read so that aio works
      tun: fix tun_chr_aio_write so that aio works

Micha≈Ç Miros≈Çaw (7):
      genetlink: Introduce genl_register_family_with_ops()
      irda: Use genl_register_family_with_ops()
      tipc: Use genl_register_family_with_ops()
      ipvs: Use genl_register_family_with_ops()
      netlabel: Use genl_register_family_with_ops()
      wireless: Use genl_register_family_with_ops()
      bridge: Simplify interface for ATM LANE

Mike Frysinger (2):
      netdev: smsc911x: allow building on Blackfin systems
      netdev: smsc911x: add missing __devexit_p() usage

Mike Travis (1):
      sfc: modify allocation error message

Mohamed Abbas (12):
      iwlagn: Sync rxon active with changes
      iwlcore: fix channel display in debugfs
      iwlcore: Fix stay in table function.
      iwlwifi: allow config if device not ready
      iwlagn: improve rate scale table search
      iwlcore: register locks
      iwlcore: support ICT interrupt
      iwlcore: Allow skb allocation from tasklet.
      iwlcore: Add support for periodic RX interrupt
      iwlcore: Set rb_timeout to 0x10 for devices with ICT
      iwlagn: co-exist with AMT
      iwlagn: delay ict interrupt.

Neil Horman (3):
      snmp: add missing counters for RFC 4293
      drop_monitor: Update netlink protocol to include netlink attribute header in alert message
      dropmon: add ability to detect when hardware dropsrxpackets

Nelson, Shannon (3):
      ixgbe: Interrupt management update for 82599
      ixgbe: Clear out stray tx work on link down
      ixgbe: Typecase '1' for 64 bit shift

Nick Kossifidis (6):
      ath5k: Allow user/driver to set txpower
      ath5k: Read Spur channels from EEPROM
      ath5k: Put remaining EEPROM data on ee struct
      ath5k: Beaconing fixes
      ath5k: Implement antenna control
      ath5k: Add Spur filter support on newer chips

Nivedita Singhvi (1):
      ipv4: New multicast-all socket option

PJ Waskiewicz (6):
      ixgbe: Enable another bit for flow control operation
      ixgbe: Don't return error in flow control configuration if FC is off
      ixgbe: Move PHY ops initialization to centralize bus accesses
      ixgbe: Remove unnecessary PHY reset, properly identify multispeed fiber modules
      ixgbe: Update the usage of orig_autoc to be more consistent
      ixgbe: Add FCoE Storage MAC Address support

Pablo Neira Ayuso (15):
      net: use NLMSG_DEFAULT_SIZE in nlmsg_new() allocations
      netfilter: conntrack: add support for DCCP handshake sequence to ctnetlink
      netfilter: nfnetlink: cleanup for nfnetlink_rcv_msg() function
      netfilter: ctnetlink: remove nowait parameter from *fill_info()
      netfilter: ctnetlink: rename tuple() by nf_ct_tuple() macro definition
      netfilter: ctnetlink: use nlmsg_* helper function to build messages
      netfilter: ctnetlink: cleanup message-size calculation
      netfilter: conntrack: don't report events on module removal
      netfilter: conntrack: remove events flags from userspace exposed file
      netfilter: conntrack: simplify event caching system
      netfilter: conntrack: replace notify chain by function pointer
      netfilter: conntrack: move event caching to conntrack extension infrastructure
      netfilter: conntrack: move helper destruction to nf_ct_helper_destroy()
      list_nulls: add hlist_nulls_add_head and hlist_nulls_del
      netfilter: conntrack: optional reliable conntrack event delivery

Paride Legovini (1):
      Add LED support for AR5BXB6 IBM Thinkpad PCIe adapters

Patrick McHardy (17):
      net: factor out ethtool invocation of vlan/macvlan drivers
      Merge branch 'master' of git://dev.medozas.de/linux
      netfilter: nf_conntrack: use per-conntrack locks for protocol data
      Merge branch 'master' of git://git.kernel.org/.../davem/net-next-2.6
      netfilter: nf_ct_tcp: fix up build after merge
      netfilter: ip_tables: fix build error
      net: fix network driver ndo_start_xmit() return values (part 1)
      net: fix network drivers ndo_start_xmit() return values (part 2)
      net: fix network drivers ndo_start_xmit() return values (part 3)
      net: fix network drivers ndo_start_xmit() return values (part 4)
      net: fix network drivers ndo_start_xmit() return values (part 5)
      net: fix network drivers ndo_start_xmit() return values (part 6)
      net: fix network drivers ndo_start_xmit() return values (part 7)
      net: fix network drivers ndo_start_xmit() return values (part 8)
      net: use symbolic values for ndo_start_xmit() return codes
      netfilter: nf_log: fix sleeping function called from invalid context
      netfilter: nf_conntrack: use mod_timer_pending() for conntrack refresh

Paulius Zaleckas (2):
      wimax: Add netlink interface to get device state
      hso: convert dev_alloc_skb() to netdev_alloc_skb()

Pavel Roskin (2):
      ath5k: fix scanning in AR2424
      cfg80211: fix compile error with CONFIG_CFG80211_DEBUGFS

Peter Holik (2):
      export usbnet_get_ethernet_addr from usbnet and fixed cdc_ether.c
      usb driver for intellon int51x1 based PLC like devolo dlan duo

Peter Korsgaard (2):
      dm9601: trivial comment fixes
      smsc95xx: strip ethernet fcs (crc) on receive path

Peter P Waskiewicz Jr (21):
      ixgbe: Update get_physical_layer() calls, plus a version bump
      ixgbe: Set Priority Flow Control low water threshhold for DCB
      ixgbe: Allow link flow control in DCB mode for 82599 adapters
      ixgbe: When in DCB mode with PFC enabled, show LFC is disabled
      ixgbe: Don't reset the hardware when switching between LFC and PFC
      ixgbe: Add generic XAUI support to 82599
      ixgbe: Increase the driver version number
      ixgbe: Add semaphore access for PHY initialization for 82599
      ixgbe: Change Direct Attach Twinax cable detection for SFP+ NICs
      ixgbe: Remove device ID 0x10d8
      ixgbe: Fix build warning
      ixgbe: Enable ACPI WoL capabilities for 82599
      ixgbe: Change the 82599 PHY DSP restart logic
      ixgbe: Add ethtool offline test support
      ixgbe: Harden the 82599 multispeed fiber autotry mechanism
      ixgbe: Add a second feature flags variable, move HW RSC capability there
      ixgbe: Add hardware defines for Flow Director for 82599
      ixgbe: Add Flow Director init and modify functions for 82599
      ixgbe: Enable Flow Director hashing in 82599
      ixgbe: Add FW detection and warning for 82599 SFP+ adapters
      ixgbe: Increase the driver version number

Rafael J. Wysocki (1):
      NET/r8169: Rework suspend and resume

Rami Rosen (8):
      ipv4: remove unused member in fib_table.
      ipv4: remove unused macro (FIB_RES_RESET) from ip_fib.h.
      ipv4: remove an unused parameter from configure method of fib_rules_ops.
      ipv4: cleanup - remove two unused parameters from fib_semantic_match().
      ipv4: cleanup: remove unnecessary include.
      net: Remove unused parameter from fill method in fib_rules_ops.
      iwlwifi: avoid build warning in iwl-core.
      ipv4: remove ip_mc_drop_socket() declaration from af_inet.c.

Randy Dunlap (2):
      iwmc3200wifi: fix printk format
      ieee802154: fix kconfig bool/tristate muckup

Reinette Chatre (6):
      iwlwifi: change check triggering device restart after rfkill change
      iwlagn: disable PS support for iwlagn
      iwlwifi: more descriptive unsupported hardware message
      iwlwifi: fix merge error
      iwlwifi: fix otp access init
      iwlwifi: fix comment describing disable_11n

Riccardo Ghetta (4):
      sis190: fix for x86_64 (bug 11509)
      sis190: better message on unknown PHY
      sis190: add new phy found on asus F5Sr laptop
      sis190: fix gigabit negotiation

Richard Genoud (1):
      Remove duplicate slow protocol define in bond_3ad.h

Richard R¬ö√∂jfors (1):
      netdev: Added KS8842 driver

Risto Suominen (1):
      de2104x: support for systems lacking cache coherence

Roel Kluin (5):
      ar9170: wrong test on outlen in ar9170_usb_exec_cmd() ?
      mISDN: get_free_devid() failure ignored
      atl1c: WAKE_MCAST tested twice, not WAKE_UCAST
      drivers/isdn/i4l/isdn_tty.c: fix check for array overindexing
      irda: smsc wait count reaches -1

Ron Mercer (15):
      qlge: Fix firmware event handler loop.
      qlge: Fix bug in firmware event handler.
      qlge: Fix bug in MTU setting process.
      qlge: Fix timeout on indexed register wait.
      qlge: Fix timeout on firmware mailbox commands.
      qlge: Add support for retrieving firmware version.
      qlge: Remove netif_set_gso_max_size() call.
      qlge: Drop inbound error frames.
      qlge: Drop inbound frames > MTU.
      qlge: Add support for using alternate MAC address.
      qlge: Add support for varied pcie function numbers.
      qlge: Add set TX csum ethtool op.
      qlge: bugfix: Get rid of errant spin_unlock().
      qlge: Relax alignment on TX harware queue.
      qlge: Allow RX buf rings to be > than 4096 bytes.

R√©mi Denis-Courmont (4):
      Phonet: fix accounting race between gprs_writeable() and gprs_xmit()
      f_phonet: dev_kfree_skb instead of dev_kfree_skb_any in TX callback
      f_phonet: no need to check for carrier - scheduler does it internally
      usb: gadget: f_phonet: fix memory allocation sizes

Saeed Bishara (1):
      mv643xx_eth: only unmask RX and TX_END interrupts for available queues

Samuel Ortiz (4):
      iwmc3200wifi: fix fragmentation threshold setting
      iwmc3200wifi: shrink calibration lmac name
      wireless/p54: prepare for FIRMWARE_NAME_MAX removal
      irda: add git tree to MAINTAINERS file

Sascha Hauer (11):
      fec: switch to writel/readl
      fec: do not typedef struct types
      fec: remove unnecessary cast
      fec: Codingstyle cleanups
      fec: refactor set_multicast_list() to make it more readable
      fec: refactor init function
      fec: align receive packets
      fec: remove debugging printks
      fec: switch to net_device_ops
      FEC Buffer rework
      fec: call fec_restart() in fec_open()

Sascha Hlusiak (5):
      sit: Fail to create tunnel, if it already exists
      sit: strictly restrict incoming traffic to tunnel link device
      sit: ipip6_tunnel_del_prl: return err
      addrconf: refuse isatap eui64 for INADDR_ANY
      sit: stateless autoconf for isatap

Sathya Perla (5):
      be2net: Use cancel_delayed_work_sync instead of cancel_delayed_work()
      be2net: fix netdev stats rx_errors and rx_dropped
      be2net: Fix rx stats updation in non-lro path
      be2net: Fix early reset of rx-completion
      be2net: Fix be_tx_q_clean() being called on freed queues

Sebastian Andrzej Siewior (2):
      net/libertas: make SPI interface big endian aware
      net/libertas: remove GPIO-CS handling in SPI interface code

Senthil Balasubramanian (1):
      mac80211: Initialize RX's last received sequence number

Sergey Lapin (5):
      Add constants for the ieee 802.15.4 stack
      net: add IEEE 802.15.4 socket family implementation
      net: add NL802154 interface for configuration of 802.15.4 devices
      ieee802154: add documentation about our stack
      ieee802154: add simple HardMAC driver sample

Shan Wei (1):
      tcp:fix the code indent

Simon Arlott (1):
      cxacru: Fix negative dB output

Simon Horman (1):
      e1000e: Call e1000e_config_collision_dist() after TCTL has been set

Sonic Zhang (1):
      netdev: bfin_mac: fix malformed UDP packet transmission when polling with KGDB

Sridhar Samudrala (3):
      net: Fix skb_copy_datagram_from_iovec() to pass the right offset
      net: Fix memcpy_toiovecend() to use the right offset
      tun: Fix copy/paste error in tun_get_user

Stanislaw Gruszka (2):
      bnx2x: free workqueue when driver fail to register
      bnx2x: do not return negative number of received packages

Stefan Weil (1):
      cpmac: prevent fatal exception in cpmac_end_xmit

Stefano Brivio (1):
      b43legacy: Remove unnecessary MMIO in interrupt hotpath

Stephen Hemminger (12):
      netns: remove leftover debugging message
      netns: simplify net_ns_init
      bonding: fix multiple module load problem
      bonding: bond_create always called with default parameters
      bonding: initialize before registration
      bonding: remove bonding read/write semaphore
      bonding: fix destructor
      bonding: fix style issues
      bonding: elminate bad refcount code
      bonding: network device names are case sensative
      bonding: use is_zero_ether_addr
      bonding: initialization rework

Stephen Rothwell (1):
      net/ibmveth: fix panic in probe

Steve Wise (3):
      RDS/IW+IB: Set recv ring low water mark to 1/2 full.
      RDS/IW+IB: Set the RDS_LL_SEND_FULL bit when we're throttled.
      RDS/IW+IB: Allow max credit advertise window.

Steven Luo (1):
      ath9k: reset after PCI FATAL/PERR interrupts

Steven Whitehouse (1):
      decnet: Use data ready call back, rather than hand coding it

Sujith (28):
      ath9k: Remove a few unused flags
      ath9k: Remove redundant chainmask check
      ath9k: Cleanup debug messages
      ath9k: Change return value of ath9k_hw_fill_cap_info
      ath9k: Remove redundant variable for Interrupt Mitigation
      ath9k: Avoid unneeded casts
      ath9k: Cleanup buffer status handling
      ath9k: Remove a couple of unused variables in descriptor handling
      ath9k: Remove unused structures
      ath9k: Check for root debugfs file
      ath9k: Remove TIM from the interrupt mask
      ath9k: Remove the useless do..while loops
      ath9k: Initialize values when setting up the queue parameters
      ath9k: Trivial fix to handle AMPDU params properly
      ath9k: Clean Interrupt handling routine
      ath9k: Determine number of streams from HT capabilities
      ath9k: Fix bug in determining HT40 mode
      ath9k: Handle ASPM properly for RFKILL
      ath9k: Fix memleak on TX DMA failure
      ath9k: Fix bug in scan termination
      ath9k: Remove unused channel flags
      ath9k: Fix bug in checking HT flag
      ath9k: Fix bug in determining calibration support
      ath9k: Initialize ANI timers
      ath9k: Cleanup calibration interface
      ath9k: Use a consistent naming convention
      ath9k: Fix bug in calibration initialization
      ath9k: Remove CHANNEL_CW_INT handling in ath9k_hw_calibrate

Tadashi Abe (1):
      irda-usb: suspend/resume support

Tanli Chang (1):
      niu: Add support for C10NEM

Thomas Petazzoni (1):
      macb: Add support of the netpoll API

Tilman Schmidt (13):
      ISDN: update Documentation/isdn/00-INDEX
      gigaset: remove obsolete references to m10x state table
      gigaset: fix possible oops in error handling
      gigaset: skip unnecessary hex formatting
      gigaset: fix error return code
      gigaset: documentation update
      gigaset: move up Kconfig inclusion point
      gigaset: remove UNDOCREQ config option
      gigaset: remove unused structure member rcvbytes
      isdn: rename capi_ctr_reseted() to capi_ctr_down()
      isdn: kerneldoc for capiutil.c
      isdn: prevent NULL ptr Oops in capi_cmsg2str()
      isdn: extend INTERFACE.CAPI document

Timo Teras (1):
      neigh: fix state transition INCOMPLETE->FAILED via Netlink request

Timo Ter√§s (1):
      ipv4: update ARPD help text

Tobias Doerffel (1):
      ath5k: added cfg80211 based rfkill support

Tobias Klauser (2):
      ath5k: Storage class should be before const qualifier
      s2io: Remove private boolean definitions

Tom Goff (1):
      PIM-SM: namespace changes

Tomas Winkler (4):
      iwlwifi: replace test_and_set_bit by set_bit in clear stations function
      iwlwifi: drop struct iwl3945_hw_key
      iwlwifi: drop iwl3945_tid_data
      iwlwifi: unify station management

Tony Breeds (1):
      ixgbe: Be explict with what we are !'ing in ixgbe_sfp_config_module_task()

Ursula Braun (6):
      iucv: provide second per-cpu IUCV command parameter block
      af_iucv: Fix merge.
      qeth: avoid crash after detach of replugged device
      ctcm: avoid crash in ctcm_remove_device
      qeth: support z/VM VSWITCH Port Isolation
      qeth: omit upstream checksumming for HiperSockets

Vasanthakumar Thiagarajan (10):
      mac80211: Don't access managed mode bits in non-managed mode
      ath9k: Remove bogus break after return
      ath9k: Cleanup ineffective return values
      ath9k: Print hw reset failure status as signed int
      ath9k: Remove unused parameters which are passed to ath_beacon_config_X()
      ath9k: cleanup beacon parameters configuration
      ath9k: Move PS wakeup/restore calls from isr to tasklet
      ath9k: Fix write callback of 'debug' which configures debug mask
      mac80211: Fix the way ADDBA request count being modified
      ath9k: Fix tx stuck when connected to aggr disabled HT AP

Vasu Dev (2):
      fcoe: consolidates netdev related config and cleanup for spma mode
      fcoe: adds spma mode support

Vivek Natarajan (2):
      ath9k: No need to abort Rx path when autosleep is enabled.
      ath9k: Disable autosleep feature for AR9285 based chipsets.

Vlad Yasevich (1):
      sctp: support non-blocking version of the new sctp_connectx() API

Vladislav Zolotarov (4):
      bnx2x: FW 4.8.53.0
      bnx2x: Separated FW from the source.
      bnx2x: Removed blob file
      bnx2x: driver version 1.48.105-1

Waskiewicz Jr, Peter P (2):
      ixgbe: Disallow SFP 1G modules in the SFP+ cages for 82598 and 82599
      ixgbe: Add SAN MAC address to the RAR, return the address to DCB

Wei Yongjun (11):
      rds: use kmem_cache_zalloc instead of kmem_cache_alloc/memset
      at76c50x-usb: remove pointless conditional before kfree_skb()
      wireless: fix to set dev->broadcast correctly
      sctp: fix error cause codes of ADD-IP extension
      sctp: fix report unrecognized parameter in ACSONF-ACK
      sctp: fix the error code when ASCONF is received with invalid address
      sctp: fix a typo in net/sctp/sm_statetable.c
      sctp: fix to only enable IPv6 address support on PF_INET6 socket
      sctp: fix panic when T2-shutdown timer expire on removed transport
      sctp: fix panic when T4-rto timer expire on removed transport
      sctp: fix to choose alternate destination when retransmit ASCONF chunk

Wey-Yi Guy (19):
      iwlwifi: merge and better support of suspend/resume for iwlagn and iwl3945
      iwlwifi: adding triple stream rate support for MIMO3
      iwlwifi: adding MIMO3 support in rate scaling
      iwlwifi: add debug messages when start aggregation queue
      iwlwifi: Display decoded rate/mcs information
      iwlwifi: adding interrupt counter in debugfs for debugging
      iwlwifi: clean up unused NL80211_IFTYPE_MONITOR for Monitor mode
      iwlwifi: "is_fat" bit in rate scale match RXON flag
      iwlwifi: use #define instead of hard coded value
      iwlagn: show current rate scale data in debugfs
      iwlwifi: show qos AC parameters
      iwlwifi: default WMM AC parameters
      iwlwifi: add Greenfield support for 11n
      iwlwifi: Temperature sensor voltage reading for 5150
      iwlwifi: support NVM access (EEPROM/OTP)
      iwlwifi: report the rate index as an MCS rate number
      iwlwifi: support "pure 40MHz" in RXON command
      iwlwifi: check for valid band for channel info
      iwlwifi: add value and range define for link quality command

Wolfgang Grandegger (11):
      can: Documentation for the CAN device driver interface
      can: Update MAINTAINERS and CREDITS file
      can: CAN Network device driver and Netlink interface
      can: Driver for the SJA1000 CAN controller
      can: SJA1000 generic platform bus driver
      can: SJA1000 driver for EMS PCI cards
      The patch adds support for the PCI cards: PCIcan and PCIcanx (1, 2 or 4 channel) from Kvaser (http://www.kvaser.com).
      can: some fixes and cleanups to the initial device driver interface
      can: sja1000: stop misusing member base_addr of struct net_device
      can: sja1000: generic OF platform bus driver
      can: sja1000_of_platform: fix build problems with printk format

Yevgeny Petrilin (11):
      mlx4_en: Removed redundant stride variable
      mlx4_en: Fix partial rings feature
      mlx4_en: Giving interface name in debug messages
      mlx4_en: Moved all module parameters handling to en_main.c
      mlx4_en renamed en_params.c to en_ethtool.c
      mlx4_en: Work with part of the ports.
      mlx4_en: Coalescing target is equal for all mtu's
      mlx4_en: multiqueue support
      mlx4_en: Added vlan_features support
      mlx4_en: Updated driver version
      mlx4: FIX error flow when initializing EQ table

Yi Zou (13):
      ixgbe: Enable L2 header split in 82599
      ixgbe: Add FCoE feature register defines to 82599
      ixgbe: Add FCoE feature header to 82599
      ixgbe: Add FCoE feature code to 82599
      ixgbe: Add infrastructure code for FCoE large send offload to 82599
      ixgbe: Implement FCoE Tx side offload features in base driver of 82599
      ixgbe: Add infrastructure code for FCoE large receive offload to 82599
      ixgbe: Implement FCoE Rx side large receive offload feature to 82599
      ixgbe: Add FCoE related statistics to 82599
      ixgbe: Add RING_F_FCOE for FCoE feature in 82599
      ixgbe: Enable FCoE redirection table feature in 82599
      ixgbe: Enable jumbo frame for FCoE feature in 82599
      ixgbe: Include offloaded FCoE data into total rx/tx statistics for 82599

Yoshihiro Shimoda (5):
      net: sh_eth: fix cache coherency issue
      net: sh_eth: fix TX/RX descriptor not set physical memory
      net: sh_eth: fix receive desciptor loop
      net: sh_eth: CPU dependency code collect to "struct sh_eth_cpu_data"
      net: sh_eth: Add support SH7724

Zhu Yi (3):
      wireless: move some utility functions from mac80211 to cfg80211
      iwmc3200wifi: Add new Intel Wireless Multicomm 802.11 driver
      iwmc3200wifi: fix link error when CFG80211 is not selected

andrey@cozybit.com (1):
      libertas: fix GSPI card event handling

fran√ßois romieu (2):
      r8169: remove useless struct member
      r8169: allow true forced mode setting

gouji-new (1):
      ixgbe: Proposed PARCH PCIE legacy I/O port free intel 10Gb NIC driver

roel kluin (1):
      pasemi_mac: mac_to_intf() error not noticed

sg.tweak@gmail.com (1):
      drivers/net/macvlan.c: fix cloning of tagged VLAN interfaces

 CREDITS                                            |    4 +
 Documentation/DocBook/mac80211.tmpl                |    1 -
 Documentation/feature-removal-schedule.txt         |    7 +
 Documentation/isdn/00-INDEX                        |   29 +-
 Documentation/isdn/INTERFACE.CAPI                  |   94 +-
 Documentation/isdn/README.gigaset                  |   42 +-
 Documentation/networking/can.txt                   |  235 +-
 Documentation/networking/ieee802154.txt            |   76 +
 Documentation/networking/ip-sysctl.txt             |   18 +-
 Documentation/networking/ipv6.txt                  |   37 +
 Documentation/networking/mac80211-injection.txt    |   28 +-
 Documentation/networking/operstates.txt            |    3 -
 Documentation/networking/packet_mmap.txt           |  140 +-
 Documentation/powerpc/dts-bindings/can/sja1000.txt |   53 +
 Documentation/rfkill.txt                           |  607 +-
 MAINTAINERS                                        |   38 +-
 arch/alpha/include/asm/errno.h                     |    2 +
 arch/arm/kernel/signal.c                           |    6 +-
 arch/arm/mach-pxa/tosa-bt.c                        |   30 +-
 arch/arm/mach-pxa/tosa.c                           |    1 -
 arch/avr32/kernel/signal.c                         |    4 +-
 arch/mips/include/asm/errno.h                      |    2 +
 arch/parisc/include/asm/errno.h                    |    1 +
 arch/powerpc/include/asm/qe.h                      |    2 +
 arch/powerpc/platforms/82xx/ep8248e.c              |    9 +-
 arch/powerpc/platforms/pasemi/gpio_mdio.c          |   32 +-
 arch/sparc/include/asm/errno.h                     |    2 +
 drivers/Makefile                                   |    1 +
 drivers/block/aoe/aoecmd.c                         |    7 -
 drivers/bluetooth/dtl1_cs.c                        |    2 +
 drivers/bluetooth/hci_vhci.c                       |   90 +-
 drivers/ieee802154/Kconfig                         |   22 +
 drivers/ieee802154/Makefile                        |    3 +
 drivers/ieee802154/fakehard.c                      |  270 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |   10 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   31 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c     |   10 +-
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c          |    6 +-
 drivers/isdn/Kconfig                               |    2 +
 drivers/isdn/capi/capiutil.c                       |   67 +-
 drivers/isdn/capi/kcapi.c                          |    8 +-
 drivers/isdn/gigaset/Kconfig                       |    8 +-
 drivers/isdn/gigaset/asyncdata.c                   |    5 +-
 drivers/isdn/gigaset/common.c                      |   12 +-
 drivers/isdn/gigaset/ev-layer.c                    |    4 +-
 drivers/isdn/gigaset/gigaset.h                     |    5 +-
 drivers/isdn/gigaset/i4l.c                         |   12 +-
 drivers/isdn/gigaset/interface.c                   |    3 +-
 drivers/isdn/gigaset/isocdata.c                    |    4 +
 drivers/isdn/gigaset/proc.c                        |    2 +-
 drivers/isdn/gigaset/usb-gigaset.c                 |   62 +-
 drivers/isdn/hardware/avm/b1.c                     |    2 +-
 drivers/isdn/hardware/avm/b1dma.c                  |    2 +-
 drivers/isdn/hardware/avm/c4.c                     |    4 +-
 drivers/isdn/hardware/avm/t1isa.c                  |    2 +-
 drivers/isdn/hardware/mISDN/Kconfig                |   11 +-
 drivers/isdn/hardware/mISDN/hfc_multi.h            |   47 +-
 drivers/isdn/hardware/mISDN/hfc_multi_8xx.h        |  167 +
 drivers/isdn/hardware/mISDN/hfcmulti.c             |  614 +-
 drivers/isdn/hardware/mISDN/hfcpci.c               |  105 +-
 drivers/isdn/hardware/mISDN/hfcsusb.c              |    4 +-
 drivers/isdn/hisax/hfc_pci.c                       |   41 +-
 drivers/isdn/hisax/hisax.h                         |    2 +-
 drivers/isdn/hysdn/hycapi.c                        |    4 +-
 drivers/isdn/i4l/Kconfig                           |    2 -
 drivers/isdn/i4l/isdn_net.c                        |    6 +-
 drivers/isdn/i4l/isdn_tty.c                        |    2 +-
 drivers/isdn/mISDN/core.c                          |    8 +-
 drivers/isdn/mISDN/dsp.h                           |   19 +-
 drivers/isdn/mISDN/dsp_audio.c                     |    5 +-
 drivers/isdn/mISDN/dsp_cmx.c                       |  115 +-
 drivers/isdn/mISDN/dsp_core.c                      |   72 +-
 drivers/isdn/mISDN/dsp_dtmf.c                      |    3 +
 drivers/isdn/mISDN/dsp_ecdis.h                     |    2 +-
 drivers/isdn/mISDN/dsp_pipeline.c                  |   16 +-
 drivers/isdn/mISDN/dsp_tones.c                     |   23 +-
 drivers/isdn/mISDN/hwchannel.c                     |    4 +-
 drivers/isdn/mISDN/l1oip.h                         |    2 +-
 drivers/isdn/mISDN/l1oip_codec.c                   |    1 +
 drivers/isdn/mISDN/l1oip_core.c                    |   71 +-
 drivers/isdn/mISDN/layer2.c                        |   37 +-
 drivers/isdn/mISDN/layer2.h                        |    2 +-
 drivers/isdn/mISDN/socket.c                        |   45 +-
 drivers/isdn/mISDN/tei.c                           |  102 +-
 drivers/isdn/mISDN/timerdev.c                      |    2 +-
 drivers/message/fusion/mptlan.c                    |    4 +-
 drivers/misc/sgi-xp/xpnet.c                        |    3 +-
 drivers/net/3c501.c                                |   65 +-
 drivers/net/3c503.c                                |   36 +-
 drivers/net/3c505.c                                |  217 +-
 drivers/net/3c507.c                                |   55 +-
 drivers/net/3c509.c                                |   76 +-
 drivers/net/3c515.c                                |  126 +-
 drivers/net/3c523.c                                |   91 +-
 drivers/net/3c527.c                                |   48 +-
 drivers/net/3c59x.c                                |  216 +-
 drivers/net/7990.c                                 |    2 +-
 drivers/net/8139cp.c                               |   34 +-
 drivers/net/8139too.c                              |  210 +-
 drivers/net/82596.c                                |   14 +-
 drivers/net/8390.c                                 |   10 +-
 drivers/net/8390p.c                                |   19 +-
 drivers/net/Kconfig                                |   57 +-
 drivers/net/Makefile                               |    6 +
 drivers/net/a2065.c                                |    2 +-
 drivers/net/acenic.c                               |    1 -
 drivers/net/appletalk/ipddp.c                      |   43 +-
 drivers/net/arm/at91_ether.c                       |    2 +-
 drivers/net/arm/ep93xx_eth.c                       |    4 +-
 drivers/net/arm/ether3.c                           |    2 +-
 drivers/net/arm/ixp4xx_eth.c                       |    8 +-
 drivers/net/atl1c/atl1c_ethtool.c                  |    2 +-
 drivers/net/atl1c/atl1c_main.c                     |   73 +-
 drivers/net/atl1e/atl1e.h                          |    1 -
 drivers/net/atl1e/atl1e_main.c                     |   15 +-
 drivers/net/atlx/atl1.c                            |   10 +-
 drivers/net/au1000_eth.c                           |    2 +-
 drivers/net/b44.c                                  |    4 +-
 drivers/net/b44.h                                  |    1 -
 drivers/net/benet/be_main.c                        |  159 +-
 drivers/net/bfin_mac.c                             |  235 +-
 drivers/net/bmac.c                                 |   16 +-
 drivers/net/bnx2.c                                 |   44 +-
 drivers/net/bnx2.h                                 |    2 +
 drivers/net/bnx2x.h                                |   15 +
 drivers/net/bnx2x_fw_file_hdr.h                    |   37 +
 drivers/net/bnx2x_init.h                           |  605 +-
 drivers/net/bnx2x_init_ops.h                       |  442 +
 drivers/net/bnx2x_init_values.h                    |16322 --------------------
 drivers/net/bnx2x_main.c                           |  359 +-
 drivers/net/bonding/bond_3ad.c                     |    5 +-
 drivers/net/bonding/bond_3ad.h                     |    4 +-
 drivers/net/bonding/bond_main.c                    |  826 +-
 drivers/net/bonding/bond_sysfs.c                   |  463 +-
 drivers/net/bonding/bonding.h                      |   10 +-
 drivers/net/can/Kconfig                            |   62 +
 drivers/net/can/Makefile                           |    7 +
 drivers/net/can/dev.c                              |  657 +
 drivers/net/can/sja1000/Makefile                   |   11 +
 drivers/net/can/sja1000/ems_pci.c                  |  320 +
 drivers/net/can/sja1000/kvaser_pci.c               |  412 +
 drivers/net/can/sja1000/sja1000.c                  |  637 +
 drivers/net/can/sja1000/sja1000.h                  |  181 +
 drivers/net/can/sja1000/sja1000_of_platform.c      |  235 +
 drivers/net/can/sja1000/sja1000_platform.c         |  165 +
 drivers/net/cassini.c                              |    2 +-
 drivers/net/chelsio/common.h                       |    2 +-
 drivers/net/chelsio/cphy.h                         |   51 +-
 drivers/net/chelsio/cxgb2.c                        |   36 +-
 drivers/net/chelsio/mv88e1xxx.c                    |    5 +-
 drivers/net/chelsio/mv88x201x.c                    |   50 +-
 drivers/net/chelsio/my3126.c                       |   14 +-
 drivers/net/chelsio/sge.c                          |    5 +-
 drivers/net/chelsio/subr.c                         |   46 +-
 drivers/net/cpmac.c                                |   33 +-
 drivers/net/cs89x0.c                               |    2 +-
 drivers/net/cxgb3/Makefile                         |    2 +-
 drivers/net/cxgb3/adapter.h                        |    4 +-
 drivers/net/cxgb3/ael1002.c                        |  958 +-
 drivers/net/cxgb3/aq100x.c                         |  355 +
 drivers/net/cxgb3/common.h                         |   67 +-
 drivers/net/cxgb3/cxgb3_main.c                     |  152 +-
 drivers/net/cxgb3/cxgb3_offload.c                  |   27 +-
 drivers/net/cxgb3/cxgb3_offload.h                  |    3 +
 drivers/net/cxgb3/sge.c                            |   71 +-
 drivers/net/cxgb3/t3_hw.c                          |   89 +-
 drivers/net/cxgb3/version.h                        |    4 +-
 drivers/net/cxgb3/vsc8211.c                        |   70 +-
 drivers/net/davinci_emac.c                         | 2830 ++++
 drivers/net/de600.c                                |   25 +-
 drivers/net/de620.c                                |   63 +-
 drivers/net/declance.c                             |    5 +
 drivers/net/defxx.c                                |    2 +-
 drivers/net/depca.c                                |    8 +-
 drivers/net/dl2k.c                                 |    8 +-
 drivers/net/dm9000.c                               |   32 +-
 drivers/net/e100.c                                 |  201 +-
 drivers/net/e1000/e1000_main.c                     |   44 +-
 drivers/net/e1000e/82571.c                         |   99 +-
 drivers/net/e1000e/defines.h                       |   25 +
 drivers/net/e1000e/e1000.h                         |   61 +
 drivers/net/e1000e/es2lan.c                        |    3 +
 drivers/net/e1000e/ethtool.c                       |   46 +-
 drivers/net/e1000e/hw.h                            |   20 +-
 drivers/net/e1000e/ich8lan.c                       |  448 +-
 drivers/net/e1000e/lib.c                           |   38 +
 drivers/net/e1000e/netdev.c                        |  280 +-
 drivers/net/e1000e/param.c                         |    2 +
 drivers/net/e1000e/phy.c                           |  699 +-
 drivers/net/ehea/ehea_main.c                       |    8 +-
 drivers/net/enic/enic_main.c                       |    2 -
 drivers/net/eql.c                                  |    1 +
 drivers/net/ethoc.c                                |    6 +-
 drivers/net/ewrk3.c                                |    2 +-
 drivers/net/fec.c                                  |  901 +-
 drivers/net/fec.h                                  |  127 +-
 drivers/net/fec_mpc52xx.c                          |  180 +-
 drivers/net/fec_mpc52xx_phy.c                      |   26 +-
 drivers/net/forcedeth.c                            |  240 +-
 drivers/net/fs_enet/fs_enet-main.c                 |  108 +-
 drivers/net/fs_enet/fs_enet.h                      |    5 -
 drivers/net/fs_enet/mac-fec.c                      |   34 -
 drivers/net/fs_enet/mii-bitbang.c                  |   29 +-
 drivers/net/fs_enet/mii-fec.c                      |   32 +-
 drivers/net/fsl_pq_mdio.c                          |   59 +-
 drivers/net/gianfar.c                              |  112 +-
 drivers/net/gianfar.h                              |    4 +-
 drivers/net/hamachi.c                              |    5 +-
 drivers/net/hamradio/baycom_epp.c                  |    2 +-
 drivers/net/hamradio/bpqether.c                    |    4 +-
 drivers/net/hamradio/hdlcdrv.c                     |    2 +-
 drivers/net/hamradio/mkiss.c                       |    4 +-
 drivers/net/hp100.c                                |    4 +-
 drivers/net/hplance.c                              |   21 +-
 drivers/net/ibm_newemac/core.c                     |    2 +-
 drivers/net/ibmlana.c                              |    5 +-
 drivers/net/ibmveth.c                              |   40 +-
 drivers/net/ifb.c                                  |    1 +
 drivers/net/igb/e1000_82575.h                      |    1 +
 drivers/net/igb/e1000_defines.h                    |    3 +-
 drivers/net/igb/e1000_mbx.c                        |    8 +-
 drivers/net/igb/e1000_phy.h                        |    2 +-
 drivers/net/igb/e1000_regs.h                       |    1 +
 drivers/net/igb/igb.h                              |   15 +-
 drivers/net/igb/igb_ethtool.c                      |   37 +-
 drivers/net/igb/igb_main.c                         |  148 +-
 drivers/net/igbvf/ethtool.c                        |   36 +-
 drivers/net/igbvf/igbvf.h                          |    6 +-
 drivers/net/igbvf/netdev.c                         |   23 +-
 drivers/net/ioc3-eth.c                             |    2 +-
 drivers/net/irda/Kconfig                           |   45 +
 drivers/net/irda/Makefile                          |    1 +
 drivers/net/irda/au1k_ir.c                         |   22 +-
 drivers/net/irda/bfin_sir.c                        |  820 +
 drivers/net/irda/bfin_sir.h                        |  148 +
 drivers/net/irda/donauboe.c                        |    8 +-
 drivers/net/irda/irda-usb.c                        |   44 +-
 drivers/net/irda/kingsun-sir.c                     |    5 +-
 drivers/net/irda/ks959-sir.c                       |    5 +-
 drivers/net/irda/ksdazzle-sir.c                    |    5 +-
 drivers/net/irda/mcs7780.c                         |    6 +-
 drivers/net/irda/pxaficp_ir.c                      |   16 +-
 drivers/net/irda/sa1100_ir.c                       |   18 +-
 drivers/net/irda/sir_dev.c                         |    2 +-
 drivers/net/irda/smsc-ircc2.c                      |    2 +-
 drivers/net/iseries_veth.c                         |   17 +-
 drivers/net/ixgb/ixgb_hw.c                         |   20 +-
 drivers/net/ixgb/ixgb_hw.h                         |   14 +-
 drivers/net/ixgb/ixgb_main.c                       |   20 +-
 drivers/net/ixgb/ixgb_osdep.h                      |    2 +-
 drivers/net/ixgbe/Makefile                         |    2 +
 drivers/net/ixgbe/ixgbe.h                          |  161 +-
 drivers/net/ixgbe/ixgbe_82598.c                    |  330 +-
 drivers/net/ixgbe/ixgbe_82599.c                    | 1489 ++-
 drivers/net/ixgbe/ixgbe_common.c                   |  316 +-
 drivers/net/ixgbe/ixgbe_common.h                   |    8 +-
 drivers/net/ixgbe/ixgbe_dcb_82598.c                |    4 +
 drivers/net/ixgbe/ixgbe_dcb_82599.c                |    2 +-
 drivers/net/ixgbe/ixgbe_dcb_nl.c                   |  119 +-
 drivers/net/ixgbe/ixgbe_ethtool.c                  |  961 ++-
 drivers/net/ixgbe/ixgbe_fcoe.c                     |  556 +
 drivers/net/ixgbe/ixgbe_fcoe.h                     |   67 +
 drivers/net/ixgbe/ixgbe_main.c                     | 1708 ++-
 drivers/net/ixgbe/ixgbe_phy.c                      |  166 +-
 drivers/net/ixgbe/ixgbe_phy.h                      |    5 +-
 drivers/net/ixgbe/ixgbe_type.h                     |  333 +-
 drivers/net/ixp2000/ixpdev.c                       |   19 +-
 drivers/net/jazzsonic.c                            |   19 +-
 drivers/net/jme.c                                  |    1 -
 drivers/net/korina.c                               |   39 +-
 drivers/net/ks8842.c                               |  732 +
 drivers/net/lasi_82596.c                           |    6 +-
 drivers/net/lib82596.c                             |   23 +-
 drivers/net/lib8390.c                              |    2 +-
 drivers/net/ll_temac.h                             |  374 +
 drivers/net/ll_temac_main.c                        |  969 ++
 drivers/net/ll_temac_mdio.c                        |  120 +
 drivers/net/loopback.c                             |   22 +-
 drivers/net/mac8390.c                              |   19 +-
 drivers/net/mac89x0.c                              |    4 +-
 drivers/net/macb.c                                 |   20 +-
 drivers/net/mace.c                                 |   18 +-
 drivers/net/macmace.c                              |   18 +-
 drivers/net/macvlan.c                              |   35 +-
 drivers/net/mdio.c                                 |  431 +
 drivers/net/meth.c                                 |   28 +-
 drivers/net/mii.c                                  |   91 +-
 drivers/net/mipsnet.c                              |   15 +-
 drivers/net/mlx4/Makefile                          |    2 +-
 drivers/net/mlx4/en_cq.c                           |    3 +
 drivers/net/mlx4/{en_params.c => en_ethtool.c}     |   67 +-
 drivers/net/mlx4/en_main.c                         |   68 +-
 drivers/net/mlx4/en_netdev.c                       |  199 +-
 drivers/net/mlx4/en_rx.c                           |  139 +-
 drivers/net/mlx4/en_tx.c                           |  112 +-
 drivers/net/mlx4/eq.c                              |    4 +-
 drivers/net/mlx4/mlx4_en.h                         |   49 +-
 drivers/net/mlx4/mr.c                              |    7 +-
 drivers/net/mv643xx_eth.c                          |   98 +-
 drivers/net/mvme147.c                              |   17 +-
 drivers/net/myri10ge/myri10ge.c                    |   70 +-
 drivers/net/myri_sbus.c                            |    2 +-
 drivers/net/ne2k-pci.c                             |    2 +-
 drivers/net/ne3210.c                               |    4 +-
 drivers/net/netx-eth.c                             |   17 +-
 drivers/net/netxen/netxen_nic.h                    |  624 +-
 drivers/net/netxen/netxen_nic_ctx.c                |  241 +-
 drivers/net/netxen/netxen_nic_ethtool.c            |  106 +-
 drivers/net/netxen/netxen_nic_hdr.h                |    8 -
 drivers/net/netxen/netxen_nic_hw.c                 |  737 +-
 drivers/net/netxen/netxen_nic_hw.h                 |   76 +-
 drivers/net/netxen/netxen_nic_init.c               |  541 +-
 drivers/net/netxen/netxen_nic_main.c               |  411 +-
 drivers/net/netxen/netxen_nic_niu.c                |  341 +-
 drivers/net/netxen/netxen_nic_phan_reg.h           |   27 +-
 drivers/net/ni65.c                                 |    2 +-
 drivers/net/niu.c                                  |   66 +-
 drivers/net/ns83820.c                              |   10 +-
 drivers/net/pasemi_mac.c                           |   58 +-
 drivers/net/pasemi_mac.h                           |    1 -
 drivers/net/pci-skeleton.c                         |   19 +-
 drivers/net/pcmcia/3c574_cs.c                      |    2 +-
 drivers/net/pcmcia/3c589_cs.c                      |    4 +-
 drivers/net/pcmcia/axnet_cs.c                      |    2 +-
 drivers/net/pcmcia/fmvj18x_cs.c                    |    2 +-
 drivers/net/pcmcia/smc91c92_cs.c                   |    2 +-
 drivers/net/pcmcia/xirc2ps_cs.c                    |    2 +-
 drivers/net/pcnet32.c                              |    5 +-
 drivers/net/phy/marvell.c                          |    1 +
 drivers/net/phy/mdio_bus.c                         |   29 +-
 drivers/net/phy/phy_device.c                       |  163 +-
 drivers/net/plip.c                                 |    6 +-
 drivers/net/ppp_generic.c                          |    1 +
 drivers/net/pppol2tp.c                             |   14 +-
 drivers/net/qla3xxx.c                              |    1 -
 drivers/net/qlge/qlge.h                            |   31 +-
 drivers/net/qlge/qlge_ethtool.c                    |    6 +-
 drivers/net/qlge/qlge_main.c                       |  134 +-
 drivers/net/qlge/qlge_mpi.c                        |   58 +-
 drivers/net/r6040.c                                |   18 +-
 drivers/net/r8169.c                                |  218 +-
 drivers/net/rionet.c                               |   14 +-
 drivers/net/rrunner.c                              |    2 +-
 drivers/net/s2io-regs.h                            |    5 -
 drivers/net/s2io.c                                 |   44 +-
 drivers/net/s2io.h                                 |    9 -
 drivers/net/sb1250-mac.c                           |   37 +-
 drivers/net/sfc/Kconfig                            |    2 +-
 drivers/net/sfc/boards.c                           |    2 -
 drivers/net/sfc/efx.c                              |   29 +-
 drivers/net/sfc/ethtool.c                          |   19 +-
 drivers/net/sfc/falcon.c                           |  137 +-
 drivers/net/sfc/falcon_hwdefs.h                    |    3 -
 drivers/net/sfc/falcon_xmac.c                      |    2 +-
 drivers/net/sfc/mdio_10g.c                         |  385 +-
 drivers/net/sfc/mdio_10g.h                         |  282 +-
 drivers/net/sfc/net_driver.h                       |   34 +-
 drivers/net/sfc/rx.c                               |   26 +-
 drivers/net/sfc/selftest.c                         |   22 +-
 drivers/net/sfc/selftest.h                         |    2 +-
 drivers/net/sfc/sfe4001.c                          |    3 -
 drivers/net/sfc/tenxpress.c                        |  251 +-
 drivers/net/sfc/tx.c                               |    7 -
 drivers/net/sfc/xenpack.h                          |   62 -
 drivers/net/sfc/xfp_phy.c                          |   55 +-
 drivers/net/sgiseeq.c                              |   18 +-
 drivers/net/sh_eth.c                               |  499 +-
 drivers/net/sh_eth.h                               |  278 +-
 drivers/net/sis190.c                               |   59 +-
 drivers/net/sis900.c                               |    2 +-
 drivers/net/skfp/skfddi.c                          |  158 +-
 drivers/net/skge.c                                 |    2 -
 drivers/net/sky2.c                                 |    1 -
 drivers/net/smc-mca.c                              |    4 +-
 drivers/net/smc911x.c                              |   23 +-
 drivers/net/smc9194.c                              |    2 +-
 drivers/net/smsc911x.c                             |   63 +-
 drivers/net/sonic.c                                |    2 +-
 drivers/net/starfire.c                             |    2 +-
 drivers/net/sun3_82586.c                           |    2 +-
 drivers/net/sun3lance.c                            |   21 +-
 drivers/net/sundance.c                             |   53 +-
 drivers/net/sunhme.c                               |    2 +-
 drivers/net/tc35815.c                              |   13 +-
 drivers/net/tehuti.c                               |   14 +-
 drivers/net/tg3.c                                  |  107 +-
 drivers/net/tg3.h                                  |    6 +
 drivers/net/tlan.c                                 |    2 +-
 drivers/net/tokenring/3c359.c                      |    2 +-
 drivers/net/tokenring/lanstreamer.c                |    2 +-
 drivers/net/tokenring/olympic.c                    |    2 +-
 drivers/net/tokenring/smctr.c                      |    2 +-
 drivers/net/tokenring/tms380tr.c                   |    2 +-
 drivers/net/tulip/Kconfig                          |   12 +
 drivers/net/tulip/de2104x.c                        |   15 +-
 drivers/net/tulip/de4x5.c                          |   12 +-
 drivers/net/tulip/dmfe.c                           |    2 +-
 drivers/net/tulip/uli526x.c                        |    2 +-
 drivers/net/tulip/winbond-840.c                    |    3 +-
 drivers/net/tun.c                                  |  110 +-
 drivers/net/ucc_geth.c                             |  187 +-
 drivers/net/ucc_geth.h                             |   31 +-
 drivers/net/usb/Kconfig                            |    8 +
 drivers/net/usb/Makefile                           |    1 +
 drivers/net/usb/cdc_ether.c                        |   33 +-
 drivers/net/usb/dm9601.c                           |   12 +-
 drivers/net/usb/hso.c                              |   53 +-
 drivers/net/usb/int51x1.c                          |  253 +
 drivers/net/usb/kaweth.c                           |   33 +-
 drivers/net/usb/rtl8150.c                          |    9 +-
 drivers/net/usb/smsc95xx.c                         |    4 +-
 drivers/net/usb/usbnet.c                           |   37 +-
 drivers/net/veth.c                                 |    2 -
 drivers/net/via-rhine.c                            |   58 +-
 drivers/net/via-velocity.c                         |   22 +-
 drivers/net/via-velocity.h                         |    1 -
 drivers/net/virtio_net.c                           |   24 +-
 drivers/net/vxge/vxge-config.c                     |   12 +-
 drivers/net/vxge/vxge-main.c                       |    6 +-
 drivers/net/vxge/vxge-traffic.c                    |    4 +-
 drivers/net/wan/cycx_x25.c                         |    6 +-
 drivers/net/wan/dlci.c                             |    6 +-
 drivers/net/wan/hdlc_fr.c                          |    1 +
 drivers/net/wan/ixp4xx_hss.c                       |    4 +-
 drivers/net/wan/pc300_drv.c                        |   20 +-
 drivers/net/wan/sbni.c                             |    2 +-
 drivers/net/wan/wanxl.c                            |    2 +-
 drivers/net/wimax/i2400m/control.c                 |  124 +-
 drivers/net/wimax/i2400m/driver.c                  |   45 +-
 drivers/net/wimax/i2400m/fw.c                      |   58 +-
 drivers/net/wimax/i2400m/i2400m-sdio.h             |    9 +
 drivers/net/wimax/i2400m/i2400m.h                  |   48 +
 drivers/net/wimax/i2400m/netdev.c                  |    4 +-
 drivers/net/wimax/i2400m/op-rfkill.c               |    4 +-
 drivers/net/wimax/i2400m/rx.c                      |   10 +-
 drivers/net/wimax/i2400m/sdio-fw.c                 |  109 +-
 drivers/net/wimax/i2400m/sdio-rx.c                 |   47 +-
 drivers/net/wimax/i2400m/sdio.c                    |   68 +-
 drivers/net/wimax/i2400m/tx.c                      |   75 +-
 drivers/net/wimax/i2400m/usb.c                     |    5 +-
 drivers/net/wireless/Kconfig                       |   20 +-
 drivers/net/wireless/Makefile                      |    8 +-
 drivers/net/wireless/adm8211.c                     |   14 +-
 drivers/net/wireless/airo.c                        |    9 +-
 drivers/net/wireless/arlan-main.c                  |    2 +-
 drivers/net/wireless/at76c50x-usb.c                |   19 +-
 drivers/net/wireless/ath/Kconfig                   |    8 +
 drivers/net/wireless/ath/Makefile                  |    6 +
 drivers/net/wireless/{ => ath}/ar9170/Kconfig      |    1 +
 drivers/net/wireless/{ => ath}/ar9170/Makefile     |    0
 drivers/net/wireless/{ => ath}/ar9170/ar9170.h     |   76 +-
 drivers/net/wireless/{ => ath}/ar9170/cmd.c        |    0
 drivers/net/wireless/{ => ath}/ar9170/cmd.h        |    0
 drivers/net/wireless/{ => ath}/ar9170/eeprom.h     |    0
 drivers/net/wireless/{ => ath}/ar9170/hw.h         |   23 +-
 drivers/net/wireless/{ => ath}/ar9170/led.c        |   17 +-
 drivers/net/wireless/{ => ath}/ar9170/mac.c        |   86 +-
 drivers/net/wireless/{ => ath}/ar9170/main.c       | 1411 ++-
 drivers/net/wireless/{ => ath}/ar9170/phy.c        |    6 +-
 drivers/net/wireless/{ => ath}/ar9170/usb.c        |  195 +-
 drivers/net/wireless/{ => ath}/ar9170/usb.h        |   11 +-
 drivers/net/wireless/{ => ath}/ath5k/Kconfig       |    1 +
 drivers/net/wireless/{ => ath}/ath5k/Makefile      |    1 +
 drivers/net/wireless/{ => ath}/ath5k/ath5k.h       |   46 +-
 drivers/net/wireless/{ => ath}/ath5k/attach.c      |    1 -
 drivers/net/wireless/{ => ath}/ath5k/base.c        |  347 +-
 drivers/net/wireless/{ => ath}/ath5k/base.h        |   13 +-
 drivers/net/wireless/{ => ath}/ath5k/caps.c        |    0
 drivers/net/wireless/{ => ath}/ath5k/debug.c       |    0
 drivers/net/wireless/{ => ath}/ath5k/debug.h       |    0
 drivers/net/wireless/{ => ath}/ath5k/desc.c        |    0
 drivers/net/wireless/{ => ath}/ath5k/desc.h        |    0
 drivers/net/wireless/{ => ath}/ath5k/dma.c         |    2 -
 drivers/net/wireless/{ => ath}/ath5k/eeprom.c      |   73 +-
 drivers/net/wireless/{ => ath}/ath5k/eeprom.h      |   46 +-
 drivers/net/wireless/{ => ath}/ath5k/gpio.c        |    0
 drivers/net/wireless/{ => ath}/ath5k/initvals.c    |    8 +-
 drivers/net/wireless/{ => ath}/ath5k/led.c         |   10 +-
 drivers/net/wireless/{ => ath}/ath5k/pcu.c         |   10 +-
 drivers/net/wireless/{ => ath}/ath5k/phy.c         |  496 +-
 drivers/net/wireless/{ => ath}/ath5k/qcu.c         |    7 +-
 drivers/net/wireless/{ => ath}/ath5k/reg.h         |    9 +-
 drivers/net/wireless/{ => ath}/ath5k/reset.c       |   92 +-
 drivers/net/wireless/{ => ath}/ath5k/rfbuffer.h    |    0
 drivers/net/wireless/{ => ath}/ath5k/rfgain.h      |    0
 drivers/net/wireless/ath/ath5k/rfkill.c            |  121 +
 drivers/net/wireless/{ => ath}/ath9k/Kconfig       |    1 +
 drivers/net/wireless/{ => ath}/ath9k/Makefile      |    1 -
 drivers/net/wireless/{ => ath}/ath9k/ahb.c         |    0
 drivers/net/wireless/{ => ath}/ath9k/ani.c         |    8 +-
 drivers/net/wireless/{ => ath}/ath9k/ani.h         |    0
 drivers/net/wireless/{ => ath}/ath9k/ath9k.h       |  122 +-
 drivers/net/wireless/{ => ath}/ath9k/beacon.c      |  133 +-
 drivers/net/wireless/{ => ath}/ath9k/calib.c       |  129 +-
 drivers/net/wireless/{ => ath}/ath9k/calib.h       |   33 +-
 drivers/net/wireless/{ => ath}/ath9k/debug.c       |  158 +-
 drivers/net/wireless/{ => ath}/ath9k/debug.h       |   35 +-
 drivers/net/wireless/{ => ath}/ath9k/eeprom.c      |   75 +-
 drivers/net/wireless/{ => ath}/ath9k/eeprom.h      |    4 +-
 drivers/net/wireless/{ => ath}/ath9k/hw.c          |  269 +-
 drivers/net/wireless/{ => ath}/ath9k/hw.h          |   95 +-
 drivers/net/wireless/{ => ath}/ath9k/initvals.h    |    0
 drivers/net/wireless/{ => ath}/ath9k/mac.c         |   63 +-
 drivers/net/wireless/{ => ath}/ath9k/mac.h         |    0
 drivers/net/wireless/{ => ath}/ath9k/main.c        |  780 +-
 drivers/net/wireless/{ => ath}/ath9k/pci.c         |   15 -
 drivers/net/wireless/{ => ath}/ath9k/phy.c         |   11 +-
 drivers/net/wireless/{ => ath}/ath9k/phy.h         |    5 +-
 drivers/net/wireless/{ => ath}/ath9k/rc.c          |   96 +-
 drivers/net/wireless/{ => ath}/ath9k/rc.h          |    4 -
 drivers/net/wireless/{ => ath}/ath9k/recv.c        |  279 +-
 drivers/net/wireless/{ => ath}/ath9k/reg.h         |    0
 drivers/net/wireless/{ => ath}/ath9k/virtual.c     |    0
 drivers/net/wireless/{ => ath}/ath9k/xmit.c        |   87 +-
 drivers/net/wireless/ath/main.c                    |   22 +
 drivers/net/wireless/{ath9k => ath}/regd.c         |  276 +-
 drivers/net/wireless/{ath9k => ath}/regd.h         |   40 +-
 drivers/net/wireless/{ath9k => ath}/regd_common.h  |    0
 drivers/net/wireless/atmel.c                       |    2 +-
 drivers/net/wireless/atmel_cs.c                    |    2 +-
 drivers/net/wireless/b43/Kconfig                   |    9 +-
 drivers/net/wireless/b43/Makefile                  |    2 +-
 drivers/net/wireless/b43/b43.h                     |   25 +-
 drivers/net/wireless/b43/dma.c                     |    2 +-
 drivers/net/wireless/b43/leds.c                    |    9 +-
 drivers/net/wireless/b43/main.c                    |  232 +-
 drivers/net/wireless/b43/main.h                    |    1 -
 drivers/net/wireless/b43/phy_a.c                   |    4 +-
 drivers/net/wireless/b43/phy_common.c              |   17 +-
 drivers/net/wireless/b43/phy_common.h              |    6 +-
 drivers/net/wireless/b43/phy_g.c                   |    4 +-
 drivers/net/wireless/b43/phy_lp.c                  |    2 +-
 drivers/net/wireless/b43/phy_n.c                   |    2 +-
 drivers/net/wireless/b43/pio.c                     |    2 +-
 drivers/net/wireless/b43/rfkill.c                  |  171 +-
 drivers/net/wireless/b43/rfkill.h                  |   47 +-
 drivers/net/wireless/b43/xmit.c                    |    5 +-
 drivers/net/wireless/b43legacy/Kconfig             |   10 +-
 drivers/net/wireless/b43legacy/Makefile            |    2 +-
 drivers/net/wireless/b43legacy/b43legacy.h         |   15 +-
 drivers/net/wireless/b43legacy/leds.c              |   10 +-
 drivers/net/wireless/b43legacy/main.c              |  346 +-
 drivers/net/wireless/b43legacy/pio.c               |    2 +-
 drivers/net/wireless/b43legacy/rfkill.c            |  173 +-
 drivers/net/wireless/b43legacy/rfkill.h            |   54 +-
 drivers/net/wireless/b43legacy/xmit.c              |    2 +-
 drivers/net/wireless/b43legacy/xmit.h              |    4 +-
 drivers/net/wireless/hostap/hostap_80211_tx.c      |    2 +-
 drivers/net/wireless/hostap/hostap_hw.c            |    2 +-
 drivers/net/wireless/hostap/hostap_plx.c           |    2 +-
 drivers/net/wireless/ipw2x00/ipw2100.c             |    8 +-
 drivers/net/wireless/ipw2x00/ipw2200.c             |   57 +-
 drivers/net/wireless/ipw2x00/libipw_module.c       |    4 -
 drivers/net/wireless/ipw2x00/libipw_tx.c           |    2 +-
 drivers/net/wireless/iwlwifi/Kconfig               |    5 -
 drivers/net/wireless/iwlwifi/Makefile              |    1 -
 drivers/net/wireless/iwlwifi/iwl-3945-led.c        |   66 +-
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c         |   16 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c            |  412 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h            |   13 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c            |   95 +-
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h         |   12 +
 drivers/net/wireless/iwlwifi/iwl-5000.c            |  175 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c          |  593 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h          |   27 +
 drivers/net/wireless/iwlwifi/iwl-agn.c             | 1273 +--
 drivers/net/wireless/iwlwifi/iwl-calib.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h        |   35 +-
 drivers/net/wireless/iwlwifi/iwl-core.c            | 1189 ++-
 drivers/net/wireless/iwlwifi/iwl-core.h            |  107 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h             |   22 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h           |    3 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c         |  193 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h             |   69 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c          |  153 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h          |    4 +
 drivers/net/wireless/iwlwifi/iwl-io.h              |  253 +-
 drivers/net/wireless/iwlwifi/iwl-led.c             |    4 -
 drivers/net/wireless/iwlwifi/iwl-power.c           |  233 +-
 drivers/net/wireless/iwlwifi/iwl-power.h           |   39 +-
 drivers/net/wireless/iwlwifi/iwl-rfkill.c          |  145 -
 drivers/net/wireless/iwlwifi/iwl-rfkill.h          |   48 -
 drivers/net/wireless/iwlwifi/iwl-rx.c              |   70 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c            |  214 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c             |   47 +-
 drivers/net/wireless/iwlwifi/iwl-sta.h             |    7 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c              |   29 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c        | 1451 +--
 drivers/net/wireless/iwmc3200wifi/Kconfig          |   23 +
 drivers/net/wireless/iwmc3200wifi/Makefile         |    5 +
 drivers/net/wireless/iwmc3200wifi/bus.h            |   57 +
 drivers/net/wireless/iwmc3200wifi/cfg80211.c       |  409 +
 drivers/net/wireless/iwmc3200wifi/cfg80211.h       |   31 +
 drivers/net/wireless/iwmc3200wifi/commands.c       |  920 ++
 drivers/net/wireless/iwmc3200wifi/commands.h       |  419 +
 drivers/net/wireless/iwmc3200wifi/debug.h          |  124 +
 drivers/net/wireless/iwmc3200wifi/debugfs.c        |  453 +
 drivers/net/wireless/iwmc3200wifi/eeprom.c         |  187 +
 drivers/net/wireless/iwmc3200wifi/eeprom.h         |  114 +
 drivers/net/wireless/iwmc3200wifi/fw.c             |  388 +
 drivers/net/wireless/iwmc3200wifi/fw.h             |  100 +
 drivers/net/wireless/iwmc3200wifi/hal.c            |  464 +
 drivers/net/wireless/iwmc3200wifi/hal.h            |  236 +
 drivers/net/wireless/iwmc3200wifi/iwm.h            |  346 +
 drivers/net/wireless/iwmc3200wifi/lmac.h           |  457 +
 drivers/net/wireless/iwmc3200wifi/main.c           |  680 +
 drivers/net/wireless/iwmc3200wifi/netdev.c         |  162 +
 drivers/net/wireless/iwmc3200wifi/rx.c             | 1431 ++
 drivers/net/wireless/iwmc3200wifi/rx.h             |   60 +
 drivers/net/wireless/iwmc3200wifi/sdio.c           |  516 +
 drivers/net/wireless/iwmc3200wifi/sdio.h           |   67 +
 drivers/net/wireless/iwmc3200wifi/tx.c             |  492 +
 drivers/net/wireless/iwmc3200wifi/umac.h           |  744 +
 drivers/net/wireless/iwmc3200wifi/wext.c           |  723 +
 drivers/net/wireless/libertas/11d.c                |   26 +-
 drivers/net/wireless/libertas/11d.h                |   29 +-
 drivers/net/wireless/libertas/assoc.c              |  758 +-
 drivers/net/wireless/libertas/assoc.h              |   13 -
 drivers/net/wireless/libertas/cmd.c                |   42 +-
 drivers/net/wireless/libertas/cmdresp.c            |   17 +-
 drivers/net/wireless/libertas/debugfs.c            |    8 +-
 drivers/net/wireless/libertas/defs.h               |   21 +
 drivers/net/wireless/libertas/dev.h                |    9 +-
 drivers/net/wireless/libertas/host.h               |    5 +-
 drivers/net/wireless/libertas/hostcmd.h            |   69 +-
 drivers/net/wireless/libertas/if_cs.c              |   34 +-
 drivers/net/wireless/libertas/if_sdio.c            |  176 +-
 drivers/net/wireless/libertas/if_sdio.h            |   10 +
 drivers/net/wireless/libertas/if_spi.c             |  139 +-
 drivers/net/wireless/libertas/if_usb.c             |    3 +-
 drivers/net/wireless/libertas/main.c               |   44 +-
 drivers/net/wireless/libertas/rx.c                 |   48 +-
 drivers/net/wireless/libertas/scan.c               |   63 +-
 drivers/net/wireless/libertas/tx.c                 |    8 +-
 drivers/net/wireless/libertas/types.h              |  152 +-
 drivers/net/wireless/libertas_tf/if_usb.c          |    3 +-
 drivers/net/wireless/libertas_tf/main.c            |   56 +-
 drivers/net/wireless/mac80211_hwsim.c              |  105 +-
 drivers/net/wireless/mwl8k.c                       |   20 +-
 drivers/net/wireless/p54/p54.h                     |   74 +-
 drivers/net/wireless/p54/p54common.c               |  348 +-
 drivers/net/wireless/p54/p54spi.c                  |  175 +-
 drivers/net/wireless/p54/p54usb.c                  |  314 +-
 drivers/net/wireless/p54/p54usb.h                  |   16 +-
 drivers/net/wireless/prism54/islpci_eth.c          |    8 +-
 drivers/net/wireless/ray_cs.c                      |    8 +-
 drivers/net/wireless/rndis_wlan.c                  | 1106 +-
 drivers/net/wireless/rt2x00/Kconfig                |   17 +
 drivers/net/wireless/rt2x00/Makefile               |    2 +
 drivers/net/wireless/rt2x00/rt2400pci.c            |   35 +-
 drivers/net/wireless/rt2x00/rt2500pci.c            |   35 +-
 drivers/net/wireless/rt2x00/rt2500usb.c            |   22 +-
 drivers/net/wireless/rt2x00/rt2800usb.c            | 3078 ++++
 drivers/net/wireless/rt2x00/rt2800usb.h            | 1945 +++
 drivers/net/wireless/rt2x00/rt2x00.h               |   57 +-
 drivers/net/wireless/rt2x00/rt2x00config.c         |    9 +
 drivers/net/wireless/rt2x00/rt2x00crypto.c         |   89 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |  134 +-
 drivers/net/wireless/rt2x00/rt2x00ht.c             |   69 +
 drivers/net/wireless/rt2x00/rt2x00lib.h            |   65 +-
 drivers/net/wireless/rt2x00/rt2x00link.c           |    2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |   88 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c            |   16 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c          |   48 +-
 drivers/net/wireless/rt2x00/rt2x00queue.h          |   53 +-
 drivers/net/wireless/rt2x00/rt61pci.c              |   38 +-
 drivers/net/wireless/rt2x00/rt61pci.h              |    6 -
 drivers/net/wireless/rt2x00/rt73usb.c              |   34 +-
 drivers/net/wireless/rtl818x/Makefile              |    2 +-
 drivers/net/wireless/rtl818x/rtl8180_dev.c         |   33 +-
 drivers/net/wireless/rtl818x/rtl8187.h             |    7 +
 drivers/net/wireless/rtl818x/rtl8187_dev.c         |   76 +-
 drivers/net/wireless/rtl818x/rtl8187_leds.c        |  218 +
 drivers/net/wireless/rtl818x/rtl8187_leds.h        |   57 +
 drivers/net/wireless/strip.c                       |    4 +-
 drivers/net/wireless/wavelan.c                     |   10 +-
 drivers/net/wireless/wavelan_cs.c                  |    5 -
 drivers/net/wireless/wl12xx/Kconfig                |   11 +
 drivers/net/wireless/wl12xx/Makefile               |    4 +
 drivers/net/wireless/wl12xx/acx.c                  |  689 +
 drivers/net/wireless/wl12xx/acx.h                  | 1245 ++
 drivers/net/wireless/wl12xx/boot.c                 |  295 +
 drivers/net/wireless/wl12xx/boot.h                 |   40 +
 drivers/net/wireless/wl12xx/cmd.c                  |  353 +
 drivers/net/wireless/wl12xx/cmd.h                  |  265 +
 drivers/net/wireless/wl12xx/debugfs.c              |  508 +
 drivers/net/wireless/wl12xx/debugfs.h              |   33 +
 drivers/net/wireless/wl12xx/event.c                |  127 +
 drivers/net/wireless/wl12xx/event.h                |  121 +
 drivers/net/wireless/wl12xx/init.c                 |  200 +
 drivers/net/wireless/wl12xx/init.h                 |   40 +
 drivers/net/wireless/wl12xx/main.c                 | 1358 ++
 drivers/net/wireless/wl12xx/ps.c                   |  151 +
 drivers/net/wireless/wl12xx/ps.h                   |   36 +
 drivers/net/wireless/wl12xx/reg.h                  |  745 +
 drivers/net/wireless/wl12xx/rx.c                   |  208 +
 drivers/net/wireless/wl12xx/rx.h                   |  122 +
 drivers/net/wireless/wl12xx/spi.c                  |  358 +
 drivers/net/wireless/wl12xx/spi.h                  |  109 +
 drivers/net/wireless/wl12xx/tx.c                   |  557 +
 drivers/net/wireless/wl12xx/tx.h                   |  215 +
 drivers/net/wireless/wl12xx/wl1251.c               |  709 +
 drivers/net/wireless/wl12xx/wl1251.h               |  165 +
 drivers/net/wireless/wl12xx/wl12xx.h               |  409 +
 drivers/net/wireless/wl12xx/wl12xx_80211.h         |  156 +
 drivers/net/wireless/wl3501_cs.c                   |    1 +
 drivers/net/wireless/zd1201.c                      |    8 +-
 drivers/net/wireless/zd1211rw/zd_mac.c             |   86 +-
 drivers/net/wireless/zd1211rw/zd_mac.h             |    2 +-
 drivers/net/yellowfin.c                            |    3 +-
 drivers/of/Kconfig                                 |    6 +
 drivers/of/Makefile                                |    1 +
 drivers/of/base.c                                  |   24 +
 drivers/of/of_mdio.c                               |  139 +
 drivers/pci/quirks.c                               |    2 +
 drivers/platform/x86/Kconfig                       |   14 +-
 drivers/platform/x86/acer-wmi.c                    |   52 +-
 drivers/platform/x86/dell-laptop.c                 |  101 +-
 drivers/platform/x86/eeepc-laptop.c                |   99 +-
 drivers/platform/x86/hp-wmi.c                      |  102 +-
 drivers/platform/x86/sony-laptop.c                 |  193 +-
 drivers/platform/x86/thinkpad_acpi.c               |  876 +-
 drivers/platform/x86/toshiba_acpi.c                |  160 +-
 drivers/s390/net/claw.c                            |    6 -
 drivers/s390/net/ctcm_main.c                       |    6 +-
 drivers/s390/net/netiucv.c                         |    4 +-
 drivers/s390/net/qeth_core_main.c                  |    7 +-
 drivers/s390/net/qeth_core_mpc.c                   |    2 +
 drivers/s390/net/qeth_core_mpc.h                   |    2 +
 drivers/s390/net/qeth_l2_main.c                    |   36 +-
 drivers/s390/net/qeth_l3_main.c                    |   33 +-
 drivers/scsi/fcoe/fcoe.c                           |  197 +-
 drivers/scsi/fcoe/libfcoe.c                        |   10 +-
 drivers/serial/serial_cs.c                         |   22 +-
 drivers/staging/agnx/pci.c                         |   15 +-
 drivers/staging/at76_usb/at76_usb.c                |    7 +-
 drivers/staging/et131x/et131x_netdev.c             |    4 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c |    2 +-
 drivers/staging/wlan-ng/p80211netdev.c             |    8 +-
 drivers/usb/gadget/f_phonet.c                      |   21 +-
 drivers/usb/gadget/u_ether.c                       |    2 +-
 firmware/Makefile                                  |    5 +-
 firmware/WHENCE                                    |   42 +-
 firmware/bnx2x-e1-4.8.53.0.fw.ihex                 |10364 +++++++++++++
 firmware/bnx2x-e1h-4.8.53.0.fw.ihex                |12028 +++++++++++++++
 firmware/cis/3CCFEM556.cis.ihex                    |   13 +
 firmware/cis/3CXEM556.cis.ihex                     |   13 +
 firmware/cxgb3/t3fw-7.1.0.bin.ihex                 | 1885 ---
 firmware/cxgb3/t3fw-7.4.0.bin.ihex                 | 1917 +++
 include/asm-generic/errno.h                        |    2 +
 include/linux/Kbuild                               |    1 +
 include/linux/can/Kbuild                           |    1 +
 include/linux/can/dev.h                            |   70 +
 include/linux/can/netlink.h                        |  113 +
 include/linux/can/platform/sja1000.h               |   35 +
 include/linux/etherdevice.h                        |   27 +
 include/linux/ethtool.h                            |   23 +-
 include/linux/fs_enet_pd.h                         |    6 +-
 include/linux/ieee80211.h                          |   61 +-
 include/linux/if.h                                 |    3 +
 include/linux/if_arp.h                             |    2 +
 include/linux/if_ether.h                           |    1 +
 include/linux/if_packet.h                          |   21 +-
 include/linux/if_tun.h                             |    1 +
 include/linux/if_tunnel.h                          |    2 +-
 include/linux/if_vlan.h                            |    6 +-
 include/linux/in.h                                 |    1 +
 include/linux/ipv6.h                               |    6 +
 include/linux/isdn/capilli.h                       |    2 +-
 include/linux/list_nulls.h                         |   18 +
 include/linux/mISDNdsp.h                           |    4 +-
 include/linux/mISDNhw.h                            |   12 +-
 include/linux/mISDNif.h                            |   19 +-
 include/linux/mdio.h                               |  356 +
 include/linux/mii.h                                |   34 +-
 include/linux/mmc/sdio_ids.h                       |    2 +
 include/linux/net_dropmon.h                        |    8 +
 include/linux/netdevice.h                          |  232 +-
 include/linux/netfilter/Kbuild                     |    1 +
 include/linux/netfilter/nf_conntrack_common.h      |   69 -
 include/linux/netfilter/nf_conntrack_tcp.h         |    3 +-
 include/linux/netfilter/nfnetlink.h                |    5 +-
 include/linux/netfilter/nfnetlink_conntrack.h      |    1 +
 include/linux/netfilter/x_tables.h                 |    6 +-
 include/linux/netfilter/xt_NFQUEUE.h               |    5 +
 include/linux/netfilter/xt_osf.h                   |  133 +
 include/linux/netfilter/xt_socket.h                |   12 +
 include/linux/nl80211.h                            |  178 +-
 include/linux/nl802154.h                           |  119 +
 include/linux/notifier.h                           |    1 +
 include/linux/of.h                                 |    3 +
 include/linux/of_mdio.h                            |   22 +
 include/linux/pci_ids.h                            |   42 +-
 include/linux/phy.h                                |   10 +-
 include/linux/rfkill.h                             |  387 +-
 include/linux/sched.h                              |    6 +
 include/linux/sctp.h                               |   20 +-
 include/linux/skbuff.h                             |   64 +-
 include/linux/smsc911x.h                           |   10 +
 include/linux/snmp.h                               |   10 +-
 include/linux/socket.h                             |   11 +-
 include/linux/spi/libertas_spi.h                   |    3 -
 include/linux/spi/wl12xx.h                         |   31 +
 include/linux/tcp.h                                |    4 +-
 include/linux/usb/usbnet.h                         |    1 +
 include/linux/wimax.h                              |    7 +-
 include/linux/wimax/i2400m.h                       |    2 +-
 include/net/bluetooth/bluetooth.h                  |   15 -
 include/net/bluetooth/hci_core.h                   |    2 +
 include/net/bluetooth/l2cap.h                      |   71 +-
 include/net/cfg80211.h                             | 1059 ++-
 include/net/dst.h                                  |   12 +-
 include/net/fib_rules.h                            |    2 -
 include/net/genetlink.h                            |    2 +
 include/net/ieee802154/af_ieee802154.h             |   60 +
 include/net/ieee802154/mac_def.h                   |  160 +
 include/net/ieee802154/netdevice.h                 |  115 +
 include/net/ieee802154/nl802154.h                  |   41 +
 include/net/inet6_hashtables.h                     |    2 +-
 include/net/inet_hashtables.h                      |    2 +-
 include/net/inet_sock.h                            |    3 +-
 include/net/ip.h                                   |    3 +
 include/net/ip6_route.h                            |    2 +-
 include/net/ip_fib.h                               |    3 -
 include/net/ipip.h                                 |    7 +
 include/net/ipv6.h                                 |   15 +-
 include/net/iucv/af_iucv.h                         |    9 +
 include/net/mac80211.h                             |  264 +-
 include/net/netfilter/ipv4/nf_conntrack_icmp.h     |   11 -
 include/net/netfilter/ipv6/nf_conntrack_icmpv6.h   |    7 -
 include/net/netfilter/nf_conntrack.h               |   11 +-
 include/net/netfilter/nf_conntrack_ecache.h        |  206 +-
 include/net/netfilter/nf_conntrack_extend.h        |    2 +
 include/net/netfilter/nf_conntrack_helper.h        |    2 +
 include/net/netfilter/nf_conntrack_l4proto.h       |    4 +-
 include/net/netlink.h                              |    9 +
 include/net/netns/conntrack.h                      |    7 +-
 include/net/pkt_sched.h                            |   11 +-
 include/net/regulatory.h                           |  101 +
 include/net/route.h                                |    2 +-
 include/net/sctp/structs.h                         |    6 +-
 include/net/sctp/user.h                            |    2 +
 include/net/snmp.h                                 |   19 +-
 include/net/sock.h                                 |    6 +-
 include/net/tcp.h                                  |   59 +-
 include/net/wimax.h                                |    8 +-
 include/net/wireless.h                             |  472 -
 include/net/xfrm.h                                 |    4 +-
 include/scsi/libfcoe.h                             |    2 +
 include/trace/events/napi.h                        |   11 +
 net/802/fddi.c                                     |    4 -
 net/802/hippi.c                                    |    5 -
 net/8021q/vlan.c                                   |    6 +-
 net/8021q/vlan_core.c                              |    4 +-
 net/8021q/vlan_dev.c                               |   49 +-
 net/8021q/vlanproc.c                               |    3 +-
 net/Kconfig                                        |    1 +
 net/Makefile                                       |    1 +
 net/appletalk/ddp.c                                |   31 +-
 net/appletalk/dev.c                                |   11 -
 net/atm/br2684.c                                   |   28 +-
 net/atm/clip.c                                     |   42 +-
 net/atm/lec.c                                      |   20 +-
 net/bluetooth/Kconfig                              |    3 +-
 net/bluetooth/cmtp/capi.c                          |    2 +-
 net/bluetooth/hci_core.c                           |   41 +-
 net/bluetooth/l2cap.c                              |  117 +-
 net/bluetooth/rfcomm/core.c                        |   12 +-
 net/bridge/br.c                                    |   10 +-
 net/bridge/br_fdb.c                                |   45 +-
 net/bridge/br_netfilter.c                          |   33 +-
 net/bridge/br_private.h                            |   12 +-
 net/bridge/br_sysfs_br.c                           |    3 +-
 net/bridge/br_sysfs_if.c                           |    3 +-
 net/bridge/netfilter/ebtables.c                    |   18 +-
 net/can/af_can.c                                   |    2 +
 net/core/datagram.c                                |  241 +-
 net/core/dev.c                                     |  688 +-
 net/core/drop_monitor.c                            |  137 +-
 net/core/fib_rules.c                               |    4 +-
 net/core/gen_estimator.c                           |    4 +-
 net/core/iovec.c                                   |   33 +-
 net/core/neighbour.c                               |   57 +-
 net/core/net-sysfs.c                               |    9 +-
 net/core/net-traces.c                              |    3 +
 net/core/net_namespace.c                           |   54 +-
 net/core/netpoll.c                                 |    7 +-
 net/core/pktgen.c                                  |    7 +-
 net/core/skb_dma_map.c                             |   13 +-
 net/core/skbuff.c                                  |  307 +-
 net/core/sock.c                                    |  135 +-
 net/core/stream.c                                  |    3 +-
 net/core/user_dma.c                                |   46 +-
 net/dccp/ipv4.c                                    |   10 +-
 net/dccp/ipv6.c                                    |    8 +-
 net/dccp/output.c                                  |    2 +-
 net/decnet/af_decnet.c                             |   25 +-
 net/decnet/dn_neigh.c                              |    8 +-
 net/decnet/dn_nsp_in.c                             |   17 +-
 net/decnet/dn_nsp_out.c                            |   14 +-
 net/decnet/dn_route.c                              |   25 +-
 net/decnet/dn_rules.c                              |    4 +-
 net/dsa/slave.c                                    |   10 +-
 net/econet/af_econet.c                             |   18 +-
 net/ethernet/eth.c                                 |    5 -
 net/ieee802154/Kconfig                             |   12 +
 net/ieee802154/Makefile                            |    5 +
 net/ieee802154/af802154.h                          |   36 +
 net/ieee802154/af_ieee802154.c                     |  372 +
 net/ieee802154/dgram.c                             |  394 +
 net/ieee802154/netlink.c                           |  523 +
 net/ieee802154/nl_policy.c                         |   52 +
 net/ieee802154/raw.c                               |  254 +
 net/ipv4/Kconfig                                   |   35 +-
 net/ipv4/af_inet.c                                 |   25 +-
 net/ipv4/arp.c                                     |    6 +-
 net/ipv4/devinet.c                                 |    3 +-
 net/ipv4/fib_frontend.c                            |    1 -
 net/ipv4/fib_hash.c                                |    1 -
 net/ipv4/fib_lookup.h                              |    3 +-
 net/ipv4/fib_rules.c                               |    4 +-
 net/ipv4/fib_semantics.c                           |    3 +-
 net/ipv4/fib_trie.c                                |   50 +-
 net/ipv4/icmp.c                                    |   20 +-
 net/ipv4/igmp.c                                    |    8 +-
 net/ipv4/inet_diag.c                               |    2 -
 net/ipv4/inet_timewait_sock.c                      |   23 +-
 net/ipv4/ip_forward.c                              |    6 +-
 net/ipv4/ip_fragment.c                             |    6 +-
 net/ipv4/ip_gre.c                                  |   28 +-
 net/ipv4/ip_input.c                                |   21 +-
 net/ipv4/ip_options.c                              |   18 +-
 net/ipv4/ip_output.c                               |   49 +-
 net/ipv4/ip_sockglue.c                             |   86 +-
 net/ipv4/ipconfig.c                                |   41 +-
 net/ipv4/ipip.c                                    |   16 +-
 net/ipv4/ipmr.c                                    |   48 +-
 net/ipv4/netfilter.c                               |   28 +-
 net/ipv4/netfilter/arp_tables.c                    |  117 +-
 net/ipv4/netfilter/ip_queue.c                      |    2 +-
 net/ipv4/netfilter/ip_tables.c                     |  172 +-
 net/ipv4/netfilter/ipt_MASQUERADE.c                |   14 +-
 net/ipv4/netfilter/ipt_REJECT.c                    |    7 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c       |   17 +-
 net/ipv4/netfilter/nf_nat_helper.c                 |    4 +-
 net/ipv4/netfilter/nf_nat_proto_sctp.c             |    5 +-
 net/ipv4/netfilter/nf_nat_standalone.c             |    7 +-
 net/ipv4/proc.c                                    |   10 +-
 net/ipv4/raw.c                                     |    2 +-
 net/ipv4/route.c                                   |   54 +-
 net/ipv4/syncookies.c                              |    5 +-
 net/ipv4/tcp.c                                     |   47 +-
 net/ipv4/tcp_input.c                               |  100 +-
 net/ipv4/tcp_ipv4.c                                |   12 +-
 net/ipv4/tcp_output.c                              |    4 +-
 net/ipv4/udp.c                                     |    4 +-
 net/ipv4/xfrm4_input.c                             |    2 +-
 net/ipv4/xfrm4_mode_tunnel.c                       |    4 +-
 net/ipv4/xfrm4_output.c                            |    6 +-
 net/ipv6/addrconf.c                                |   87 +-
 net/ipv6/af_inet6.c                                |   35 +-
 net/ipv6/exthdrs.c                                 |   40 +-
 net/ipv6/fib6_rules.c                              |    4 +-
 net/ipv6/inet6_connection_sock.c                   |    2 +-
 net/ipv6/ip6_input.c                               |   15 +-
 net/ipv6/ip6_output.c                              |   74 +-
 net/ipv6/ip6_tunnel.c                              |   30 +-
 net/ipv6/ip6mr.c                                   |   33 +-
 net/ipv6/mcast.c                                   |   34 +-
 net/ipv6/ndisc.c                                   |   17 +-
 net/ipv6/netfilter.c                               |   16 +-
 net/ipv6/netfilter/ip6_queue.c                     |    2 +-
 net/ipv6/netfilter/ip6_tables.c                    |  170 +-
 net/ipv6/netfilter/ip6t_REJECT.c                   |    2 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c     |   17 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c            |    4 +-
 net/ipv6/proc.c                                    |   10 +-
 net/ipv6/raw.c                                     |    4 +-
 net/ipv6/reassembly.c                              |   26 +-
 net/ipv6/route.c                                   |   12 +-
 net/ipv6/sit.c                                     |  118 +-
 net/ipv6/syncookies.c                              |    4 +-
 net/ipv6/tcp_ipv6.c                                |   17 +-
 net/ipv6/udp.c                                     |    7 +-
 net/ipv6/xfrm6_mode_tunnel.c                       |    4 +-
 net/ipv6/xfrm6_output.c                            |    4 +-
 net/irda/irlap_frame.c                             |   18 +-
 net/irda/irnetlink.c                               |   19 +-
 net/iucv/af_iucv.c                                 |  408 +-
 net/iucv/iucv.c                                    |   43 +-
 net/llc/af_llc.c                                   |    2 +-
 net/llc/llc_conn.c                                 |    4 -
 net/mac80211/Kconfig                               |   21 +-
 net/mac80211/agg-rx.c                              |   19 +-
 net/mac80211/agg-tx.c                              |   19 +-
 net/mac80211/cfg.c                                 |  213 +-
 net/mac80211/debugfs.c                             |   74 +-
 net/mac80211/driver-ops.h                          |  191 +
 net/mac80211/event.c                               |   17 +-
 net/mac80211/ht.c                                  |   84 -
 net/mac80211/ibss.c                                |  501 +-
 net/mac80211/ieee80211_i.h                         |  156 +-
 net/mac80211/iface.c                               |  117 +-
 net/mac80211/key.c                                 |   29 +-
 net/mac80211/key.h                                 |    3 +-
 net/mac80211/main.c                                |  368 +-
 net/mac80211/mesh.c                                |   46 +-
 net/mac80211/mesh.h                                |   16 +-
 net/mac80211/mesh_hwmp.c                           |    8 +-
 net/mac80211/mesh_plink.c                          |   21 +
 net/mac80211/mlme.c                                |  790 +-
 net/mac80211/pm.c                                  |  182 +-
 net/mac80211/rc80211_minstrel.c                    |   10 +-
 net/mac80211/rc80211_pid_algo.c                    |    8 +-
 net/mac80211/rx.c                                  |  319 +-
 net/mac80211/scan.c                                |  436 +-
 net/mac80211/spectmgmt.c                           |  103 +-
 net/mac80211/sta_info.c                            |  112 +-
 net/mac80211/sta_info.h                            |    7 +-
 net/mac80211/tkip.c                                |    6 +-
 net/mac80211/tx.c                                  |   72 +-
 net/mac80211/util.c                                |  451 +-
 net/mac80211/wext.c                                |  637 +-
 net/mac80211/wme.c                                 |   34 +-
 net/mac80211/wpa.c                                 |    2 +-
 net/netfilter/Kconfig                              |   13 +
 net/netfilter/Makefile                             |    1 +
 net/netfilter/ipvs/ip_vs_ctl.c                     |   18 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |   48 +-
 net/netfilter/nf_conntrack_core.c                  |  162 +-
 net/netfilter/nf_conntrack_ecache.c                |  264 +-
 net/netfilter/nf_conntrack_ftp.c                   |    2 -
 net/netfilter/nf_conntrack_helper.c                |   14 +
 net/netfilter/nf_conntrack_netbios_ns.c            |    2 +-
 net/netfilter/nf_conntrack_netlink.c               |  329 +-
 net/netfilter/nf_conntrack_proto_dccp.c            |   31 +-
 net/netfilter/nf_conntrack_proto_gre.c             |    5 +-
 net/netfilter/nf_conntrack_proto_sctp.c            |   27 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |  140 +-
 net/netfilter/nf_log.c                             |    6 +-
 net/netfilter/nf_queue.c                           |    4 +-
 net/netfilter/nfnetlink.c                          |   28 +-
 net/netfilter/nfnetlink_queue.c                    |    4 +-
 net/netfilter/x_tables.c                           |   54 +-
 net/netfilter/xt_NFQUEUE.c                         |   93 +-
 net/netfilter/xt_TCPMSS.c                          |    6 +-
 net/netfilter/xt_osf.c                             |  428 +
 net/netfilter/xt_policy.c                          |    2 +-
 net/netfilter/xt_realm.c                           |    2 +-
 net/netfilter/xt_socket.c                          |   63 +-
 net/netlabel/netlabel_cipso_v4.c                   |   16 +-
 net/netlabel/netlabel_mgmt.c                       |   16 +-
 net/netlabel/netlabel_unlabeled.c                  |   16 +-
 net/netlink/genetlink.c                            |   46 +
 net/packet/af_packet.c                             |  604 +-
 net/phonet/pep-gprs.c                              |    9 +-
 net/phonet/pep.c                                   |    4 +-
 net/rds/af_rds.c                                   |    1 -
 net/rds/connection.c                               |    4 +-
 net/rds/ib.c                                       |    4 +-
 net/rds/ib.h                                       |    2 +-
 net/rds/ib_recv.c                                  |    2 +-
 net/rds/ib_ring.c                                  |    2 +-
 net/rds/ib_send.c                                  |   10 +-
 net/rds/info.c                                     |    5 +-
 net/rds/iw.c                                       |    4 +-
 net/rds/iw.h                                       |    2 +-
 net/rds/iw_recv.c                                  |    2 +-
 net/rds/iw_ring.c                                  |    2 +-
 net/rds/iw_send.c                                  |   10 +-
 net/rds/rdma.c                                     |    7 +-
 net/rds/rdma_transport.c                           |   12 +-
 net/rds/rds.h                                      |    2 +-
 net/rds/send.c                                     |   10 +-
 net/rfkill/Kconfig                                 |   21 +-
 net/rfkill/Makefile                                |    5 +-
 net/rfkill/core.c                                  | 1205 ++
 net/rfkill/input.c                                 |  342 +
 net/rfkill/rfkill-input.c                          |  459 -
 net/rfkill/rfkill.c                                |  882 --
 net/rfkill/{rfkill-input.h => rfkill.h}            |   10 +-
 net/rose/rose_dev.c                                |    2 +-
 net/sched/cls_cgroup.c                             |    6 -
 net/sched/cls_flow.c                               |    8 +-
 net/sched/cls_route.c                              |    2 +-
 net/sched/em_meta.c                                |    8 +-
 net/sched/sch_api.c                                |    4 +-
 net/sched/sch_cbq.c                                |    4 +-
 net/sched/sch_generic.c                            |   40 +-
 net/sched/sch_hfsc.c                               |    8 +-
 net/sched/sch_sfq.c                                |    2 +-
 net/sched/sch_teql.c                               |   26 +-
 net/sctp/associola.c                               |   64 +-
 net/sctp/input.c                                   |    4 +-
 net/sctp/output.c                                  |   23 +-
 net/sctp/protocol.c                                |   10 +-
 net/sctp/sm_make_chunk.c                           |   16 +-
 net/sctp/sm_sideeffect.c                           |    8 +-
 net/sctp/sm_statefuns.c                            |   14 +-
 net/sctp/sm_statetable.c                           |    2 +-
 net/sctp/socket.c                                  |   48 +-
 net/sctp/sysctl.c                                  |    6 +-
 net/sctp/ulpevent.c                                |    7 +-
 net/sunrpc/auth_gss/auth_gss.c                     |    1 +
 net/sunrpc/xprtsock.c                              |    2 +-
 net/tipc/eth_media.c                               |    2 +-
 net/tipc/netlink.c                                 |   38 +-
 net/wimax/Kconfig                                  |   15 +-
 net/wimax/Makefile                                 |    1 +
 net/wimax/debug-levels.h                           |    1 +
 net/wimax/debugfs.c                                |    1 +
 net/wimax/op-msg.c                                 |   17 +-
 net/wimax/op-rfkill.c                              |  125 +-
 net/wimax/op-state-get.c                           |   86 +
 net/wimax/stack.c                                  |    5 +-
 net/wireless/Kconfig                               |   11 +-
 net/wireless/Makefile                              |    3 +-
 net/wireless/core.c                                |  148 +-
 net/wireless/core.h                                |   42 +-
 net/wireless/debugfs.c                             |  131 +
 net/wireless/debugfs.h                             |   14 +
 net/wireless/ibss.c                                |  369 +
 net/wireless/mlme.c                                |   50 +-
 net/wireless/nl80211.c                             |  923 +-
 net/wireless/nl80211.h                             |   32 +-
 net/wireless/reg.c                                 |  274 +-
 net/wireless/scan.c                                |   66 +-
 net/wireless/util.c                                |  370 +-
 net/wireless/wext-compat.c                         |  600 +-
 net/wireless/wext.c                                |   48 +-
 net/xfrm/xfrm_algo.c                               |   41 +-
 net/xfrm/xfrm_input.c                              |    3 +-
 net/xfrm/xfrm_output.c                             |   21 +-
 net/xfrm/xfrm_policy.c                             |    8 +-
 security/selinux/hooks.c                           |    2 +-
 security/selinux/xfrm.c                            |    2 +-
 1136 files changed, 106189 insertions(+), 47576 deletions(-)
 create mode 100644 Documentation/networking/ieee802154.txt
 create mode 100644 Documentation/powerpc/dts-bindings/can/sja1000.txt
 create mode 100644 drivers/ieee802154/Kconfig
 create mode 100644 drivers/ieee802154/Makefile
 create mode 100644 drivers/ieee802154/fakehard.c
 create mode 100644 drivers/isdn/hardware/mISDN/hfc_multi_8xx.h
 create mode 100644 drivers/net/bnx2x_fw_file_hdr.h
 create mode 100644 drivers/net/bnx2x_init_ops.h
 delete mode 100644 drivers/net/bnx2x_init_values.h
 create mode 100644 drivers/net/can/dev.c
 create mode 100644 drivers/net/can/sja1000/Makefile
 create mode 100644 drivers/net/can/sja1000/ems_pci.c
 create mode 100644 drivers/net/can/sja1000/kvaser_pci.c
 create mode 100644 drivers/net/can/sja1000/sja1000.c
 create mode 100644 drivers/net/can/sja1000/sja1000.h
 create mode 100644 drivers/net/can/sja1000/sja1000_of_platform.c
 create mode 100644 drivers/net/can/sja1000/sja1000_platform.c
 create mode 100644 drivers/net/cxgb3/aq100x.c
 create mode 100644 drivers/net/davinci_emac.c
 create mode 100644 drivers/net/irda/bfin_sir.c
 create mode 100644 drivers/net/irda/bfin_sir.h
 create mode 100644 drivers/net/ixgbe/ixgbe_fcoe.c
 create mode 100644 drivers/net/ixgbe/ixgbe_fcoe.h
 create mode 100644 drivers/net/ks8842.c
 create mode 100644 drivers/net/ll_temac.h
 create mode 100644 drivers/net/ll_temac_main.c
 create mode 100644 drivers/net/ll_temac_mdio.c
 create mode 100644 drivers/net/mdio.c
 rename drivers/net/mlx4/{en_params.c => en_ethtool.c} (86%)
 delete mode 100644 drivers/net/sfc/xenpack.h
 create mode 100644 drivers/net/usb/int51x1.c
 create mode 100644 drivers/net/wireless/ath/Kconfig
 create mode 100644 drivers/net/wireless/ath/Makefile
 rename drivers/net/wireless/{ => ath}/ar9170/Kconfig (96%)
 rename drivers/net/wireless/{ => ath}/ar9170/Makefile (100%)
 rename drivers/net/wireless/{ => ath}/ar9170/ar9170.h (75%)
 rename drivers/net/wireless/{ => ath}/ar9170/cmd.c (100%)
 rename drivers/net/wireless/{ => ath}/ar9170/cmd.h (100%)
 rename drivers/net/wireless/{ => ath}/ar9170/eeprom.h (100%)
 rename drivers/net/wireless/{ => ath}/ar9170/hw.h (96%)
 rename drivers/net/wireless/{ => ath}/ar9170/led.c (94%)
 rename drivers/net/wireless/{ => ath}/ar9170/mac.c (86%)
 rename drivers/net/wireless/{ => ath}/ar9170/main.c (55%)
 rename drivers/net/wireless/{ => ath}/ar9170/phy.c (99%)
 rename drivers/net/wireless/{ => ath}/ar9170/usb.c (83%)
 rename drivers/net/wireless/{ => ath}/ar9170/usb.h (92%)
 rename drivers/net/wireless/{ => ath}/ath5k/Kconfig (98%)
 rename drivers/net/wireless/{ => ath}/ath5k/Makefile (93%)
 rename drivers/net/wireless/{ => ath}/ath5k/ath5k.h (97%)
 rename drivers/net/wireless/{ => ath}/ath5k/attach.c (99%)
 rename drivers/net/wireless/{ => ath}/ath5k/base.c (93%)
 rename drivers/net/wireless/{ => ath}/ath5k/base.h (96%)
 rename drivers/net/wireless/{ => ath}/ath5k/caps.c (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/debug.c (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/debug.h (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/desc.c (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/desc.h (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/dma.c (99%)
 rename drivers/net/wireless/{ => ath}/ath5k/eeprom.c (96%)
 rename drivers/net/wireless/{ => ath}/ath5k/eeprom.h (94%)
 rename drivers/net/wireless/{ => ath}/ath5k/gpio.c (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/initvals.c (99%)
 rename drivers/net/wireless/{ => ath}/ath5k/led.c (94%)
 rename drivers/net/wireless/{ => ath}/ath5k/pcu.c (99%)
 rename drivers/net/wireless/{ => ath}/ath5k/phy.c (83%)
 rename drivers/net/wireless/{ => ath}/ath5k/qcu.c (98%)
 rename drivers/net/wireless/{ => ath}/ath5k/reg.h (99%)
 rename drivers/net/wireless/{ => ath}/ath5k/reset.c (95%)
 rename drivers/net/wireless/{ => ath}/ath5k/rfbuffer.h (100%)
 rename drivers/net/wireless/{ => ath}/ath5k/rfgain.h (100%)
 create mode 100644 drivers/net/wireless/ath/ath5k/rfkill.c
 rename drivers/net/wireless/{ => ath}/ath9k/Kconfig (97%)
 rename drivers/net/wireless/{ => ath}/ath9k/Makefile (96%)
 rename drivers/net/wireless/{ => ath}/ath9k/ahb.c (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/ani.c (99%)
 rename drivers/net/wireless/{ => ath}/ath9k/ani.h (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/ath9k.h (88%)
 rename drivers/net/wireless/{ => ath}/ath9k/beacon.c (90%)
 rename drivers/net/wireless/{ => ath}/ath9k/calib.c (90%)
 rename drivers/net/wireless/{ => ath}/ath9k/calib.h (81%)
 rename drivers/net/wireless/{ => ath}/ath9k/debug.c (87%)
 rename drivers/net/wireless/{ => ath}/ath9k/debug.h (84%)
 rename drivers/net/wireless/{ => ath}/ath9k/eeprom.c (98%)
 rename drivers/net/wireless/{ => ath}/ath9k/eeprom.h (99%)
 rename drivers/net/wireless/{ => ath}/ath9k/hw.c (95%)
 rename drivers/net/wireless/{ => ath}/ath9k/hw.h (87%)
 rename drivers/net/wireless/{ => ath}/ath9k/initvals.h (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/mac.c (93%)
 rename drivers/net/wireless/{ => ath}/ath9k/mac.h (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/main.c (87%)
 rename drivers/net/wireless/{ => ath}/ath9k/pci.c (93%)
 rename drivers/net/wireless/{ => ath}/ath9k/phy.c (98%)
 rename drivers/net/wireless/{ => ath}/ath9k/phy.h (99%)
 rename drivers/net/wireless/{ => ath}/ath9k/rc.c (95%)
 rename drivers/net/wireless/{ => ath}/ath9k/rc.h (98%)
 rename drivers/net/wireless/{ => ath}/ath9k/recv.c (75%)
 rename drivers/net/wireless/{ => ath}/ath9k/reg.h (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/virtual.c (100%)
 rename drivers/net/wireless/{ => ath}/ath9k/xmit.c (97%)
 create mode 100644 drivers/net/wireless/ath/main.c
 rename drivers/net/wireless/{ath9k => ath}/regd.c (61%)
 rename drivers/net/wireless/{ath9k => ath}/regd.h (85%)
 rename drivers/net/wireless/{ath9k => ath}/regd_common.h (100%)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-rfkill.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-rfkill.h
 create mode 100644 drivers/net/wireless/iwmc3200wifi/Kconfig
 create mode 100644 drivers/net/wireless/iwmc3200wifi/Makefile
 create mode 100644 drivers/net/wireless/iwmc3200wifi/bus.h
 create mode 100644 drivers/net/wireless/iwmc3200wifi/cfg80211.c
 create mode 100644 drivers/net/wireless/iwmc3200wifi/cfg80211.h
 create mode 100644 drivers/net/wireless/iwmc3200wifi/commands.c
 create mode 100644 drivers/net/wireless/iwmc3200wifi/commands.h
 create mode 100644 drivers/net/wireless/iwmc3200wifi/debug.h
 create mode 100644 drivers/net/wireless/iwmc3200wifi/debugfs.c
 create mode 100644 drivers/net/wireless/iwmc3200wifi/eeprom.c
 create mode 100644 drivers/net/wireless/iwmc3200wifi/eeprom.h
 create mode 100644 drivers/net/wireless/iwmc3200wifi/fw.c
 create mode 100644 drivers/net/wireless/iwmc3200wifi/fw.h
 create mode 100644 drivers/net/wireless/iwmc3200wifi/hal.c
 create mode 100644 drivers/net/wireless/iwmc3200wifi/hal.h
 create mode 100644 drivers/net/wireless/iwmc3200wifi/iwm.h
 create mode 100644 drivers/net/wireless/iwmc3200wifi/lmac.h
 create mode 100644 drivers/net/wireless/iwmc3200wifi/main.c
 create mode 100644 drivers/net/wireless/iwmc3200wifi/netdev.c
 create mode 100644 drivers/net/wireless/iwmc3200wifi/rx.c
 create mode 100644 drivers/net/wireless/iwmc3200wifi/rx.h
 create mode 100644 drivers/net/wireless/iwmc3200wifi/sdio.c
 create mode 100644 drivers/net/wireless/iwmc3200wifi/sdio.h
 create mode 100644 drivers/net/wireless/iwmc3200wifi/tx.c
 create mode 100644 drivers/net/wireless/iwmc3200wifi/umac.h
 create mode 100644 drivers/net/wireless/iwmc3200wifi/wext.c
 create mode 100644 drivers/net/wireless/rt2x00/rt2800usb.c
 create mode 100644 drivers/net/wireless/rt2x00/rt2800usb.h
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00ht.c
 create mode 100644 drivers/net/wireless/rtl818x/rtl8187_leds.c
 create mode 100644 drivers/net/wireless/rtl818x/rtl8187_leds.h
 create mode 100644 drivers/net/wireless/wl12xx/Kconfig
 create mode 100644 drivers/net/wireless/wl12xx/Makefile
 create mode 100644 drivers/net/wireless/wl12xx/acx.c
 create mode 100644 drivers/net/wireless/wl12xx/acx.h
 create mode 100644 drivers/net/wireless/wl12xx/boot.c
 create mode 100644 drivers/net/wireless/wl12xx/boot.h
 create mode 100644 drivers/net/wireless/wl12xx/cmd.c
 create mode 100644 drivers/net/wireless/wl12xx/cmd.h
 create mode 100644 drivers/net/wireless/wl12xx/debugfs.c
 create mode 100644 drivers/net/wireless/wl12xx/debugfs.h
 create mode 100644 drivers/net/wireless/wl12xx/event.c
 create mode 100644 drivers/net/wireless/wl12xx/event.h
 create mode 100644 drivers/net/wireless/wl12xx/init.c
 create mode 100644 drivers/net/wireless/wl12xx/init.h
 create mode 100644 drivers/net/wireless/wl12xx/main.c
 create mode 100644 drivers/net/wireless/wl12xx/ps.c
 create mode 100644 drivers/net/wireless/wl12xx/ps.h
 create mode 100644 drivers/net/wireless/wl12xx/reg.h
 create mode 100644 drivers/net/wireless/wl12xx/rx.c
 create mode 100644 drivers/net/wireless/wl12xx/rx.h
 create mode 100644 drivers/net/wireless/wl12xx/spi.c
 create mode 100644 drivers/net/wireless/wl12xx/spi.h
 create mode 100644 drivers/net/wireless/wl12xx/tx.c
 create mode 100644 drivers/net/wireless/wl12xx/tx.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1251.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1251.h
 create mode 100644 drivers/net/wireless/wl12xx/wl12xx.h
 create mode 100644 drivers/net/wireless/wl12xx/wl12xx_80211.h
 create mode 100644 drivers/of/of_mdio.c
 create mode 100644 firmware/bnx2x-e1-4.8.53.0.fw.ihex
 create mode 100644 firmware/bnx2x-e1h-4.8.53.0.fw.ihex
 create mode 100644 firmware/cis/3CCFEM556.cis.ihex
 create mode 100644 firmware/cis/3CXEM556.cis.ihex
 delete mode 100644 firmware/cxgb3/t3fw-7.1.0.bin.ihex
 create mode 100644 firmware/cxgb3/t3fw-7.4.0.bin.ihex
 create mode 100644 include/linux/can/dev.h
 create mode 100644 include/linux/can/netlink.h
 create mode 100644 include/linux/can/platform/sja1000.h
 create mode 100644 include/linux/mdio.h
 create mode 100644 include/linux/netfilter/xt_osf.h
 create mode 100644 include/linux/netfilter/xt_socket.h
 create mode 100644 include/linux/nl802154.h
 create mode 100644 include/linux/of_mdio.h
 create mode 100644 include/linux/spi/wl12xx.h
 create mode 100644 include/net/ieee802154/af_ieee802154.h
 create mode 100644 include/net/ieee802154/mac_def.h
 create mode 100644 include/net/ieee802154/netdevice.h
 create mode 100644 include/net/ieee802154/nl802154.h
 delete mode 100644 include/net/netfilter/ipv4/nf_conntrack_icmp.h
 create mode 100644 include/net/regulatory.h
 delete mode 100644 include/net/wireless.h
 create mode 100644 include/trace/events/napi.h
 create mode 100644 net/ieee802154/Kconfig
 create mode 100644 net/ieee802154/Makefile
 create mode 100644 net/ieee802154/af802154.h
 create mode 100644 net/ieee802154/af_ieee802154.c
 create mode 100644 net/ieee802154/dgram.c
 create mode 100644 net/ieee802154/netlink.c
 create mode 100644 net/ieee802154/nl_policy.c
 create mode 100644 net/ieee802154/raw.c
 create mode 100644 net/mac80211/driver-ops.h
 create mode 100644 net/netfilter/xt_osf.c
 create mode 100644 net/rfkill/core.c
 create mode 100644 net/rfkill/input.c
 delete mode 100644 net/rfkill/rfkill-input.c
 delete mode 100644 net/rfkill/rfkill.c
 rename net/rfkill/{rfkill-input.h => rfkill.h} (60%)
 create mode 100644 net/wimax/op-state-get.c
 create mode 100644 net/wireless/debugfs.c
 create mode 100644 net/wireless/debugfs.h
 create mode 100644 net/wireless/ibss.c
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
