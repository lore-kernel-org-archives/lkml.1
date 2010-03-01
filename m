Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301Ab0CAHFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 02:05:34 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38597
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733Ab0CAHFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 02:05:18 -0500
Date: Sun, 28 Feb 2010 23:05:35 -0800 (PST)
Message-Id: <20100228.230535.123985162.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o2176RmE025295


Here we have the usual smattering of driver updates, but outside of
that the highlights are:

1) Preliminary IGMP snooping support for the bridging layer, from
   Herbert Xu.

2) Support ipsec tunnels in network namespaces, from Alexey Dobriyan.

3) Better MSG_TRUNC support for DCCP sockets, from Gerrit Renker.

4) Proper CONFIG_COMPAT support for bridging netfilter.  From Florian
   Westphal.

5) Major ISDN CAPI layer cleanups from Jan Kiszka.

6) Abstraction of unicast and multicast device list accesses by Jiri
   Pirko.

7) Add and use seq_file helpers for iterating over an hlist in the
   networking.  From Li Zefan.

8) Netfilter conntrack "zones" support from Patrick McHardy.

9) Support for taking advantage of n-tuple filters in networking
   cards.  From Peter Waskiewicz.

10) Several locking changes from Stephen Hemminger, including a couple
    rwlock --> spinlock conversions, and changing AF_PACKET socket
    handling over to RCU.

11) Convert several drivers to use %pM for MAC address printing.
    From hartleys.

12) Avoid emitting empty events when flushing IPSEC tables, from
    Jamal Hadi Salim.

13) Work towards more consistent networking driver log messages.
    From Joe Perches.

Please pull, thanks a lot!

The following changes since commit 30ff056c42c665b9ea535d8515890857ae382540:
  Linus Torvalds (1):
        Merge branch 'x86-uv-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-next-2.6.git master

Abhijeet Kolekar (4):
      iwlwifi: enable DC calibration
      iwlwifi: cleanup return values
      iwlwifi: indicate calib version for 6050 series
      iwlwifi: increase command buffer size

Ajit Khaparde (14):
      bonding: Remove net_device_stats from bonding struct
      be2net: remove unused pci device id
      be2net: bug fix for flashing the BladeEngine3 ASIC
      be2net: bug fix in be_change_mtu
      be2net: minor code optimizations
      be2net: fix to limit max vlans supported in certain skews
      be2net: change the driver description
      be2net: remove ASIC generation number from Kconfig
      be2net: bug fix in be_read_eeprom
      net: bug fix for vlan + gro issue
      be2net: update copyright dates
      be2net: Maintain tx and rx counters in driver
      be2net: Bump the driver version number
      MAINTAINERS: Add two maintainers for be2net driver

Alban Browaeys (4):
      rt2x00 : bail out of regbusy_read if device is removed.
      rt2x00 : modify padding location.
      rt2x00 : avoid timestamp for monitor injected frame.
      rt2x00 : trim the skb after having the l2pad removed.

Alexander Beregalov (1):
      eepro: fix netdev_mc_count conversion

Alexander Duyck (4):
      igb: add support for device reset interrupt
      igb: remove unecessary q_vector declarations and remove itr_shift
      igb: Allocate rings seperately instead of as a block
      pci: add support for 82576NS serdes to existing SR-IOV quirk

Alexey Dobriyan (38):
      drivers/net/: use DEFINE_PCI_DEVICE_TABLE()
      netfilter: nfnetlink: netns support
      netfilter: ctnetlink: netns support
      proc_fops: convert drivers/isdn/ to seq_file
      net: spread __net_init, __net_exit
      netfilter: xt_connlimit: netns support
      netfilter: netns: #ifdef ->iptable_security, ->ip6table_security
      netfilter: xt_hashlimit: simplify seqfile code
      netfilter: xtables: add struct xt_mtchk_param::net
      netfilter: xtables: add struct xt_mtdtor_param::net
      netfilter: xt_recent: netns support
      netfilter: xt_hashlimit: netns support
      netfiltr: ipt_CLUSTERIP: simplify seq_file codeA
      netdev: remove certain HAVE_ macros
      neigh: simplify seq_file code
      net: constify MIB name tables
      icmp: move icmp_err_convert[] to .rodata
      netdev: remove HAVE_ leftovers
      netns xfrm: fixup xfrm6_tunnel error propagation
      netns xfrm: xfrm6_tunnel in netns
      netns xfrm: ipcomp support
      netns xfrm: ipcomp6 support
      netfilter: xtables: CONFIG_COMPAT redux
      net: CONFIG_COMPAT redux
      netfilter: xtables: consistent struct compat_xt_counters definition
      netfilter: xtables: symmetric COMPAT_XT_ALIGN definition
      netfilter: xtables: fix mangle tables
      netfilter: nf_conntrack: elegantly simplify nf_ct_exp_net()
      netfilter: don't use INIT_RCU_HEAD()
      gre: fix netns vs proto registration ordering
      tunnels: fix netns vs proto registration ordering
      net: remove INIT_RCU_HEAD() usage
      net: use kasprintf() for socket cache names
      ipv6: remove stale MIB definitions
      ipv6: use standard lists for FIB walks
      ipv6: drop unused "dev" arg of icmpv6_send()
      const: struct nla_policy
      netfilter: nfnetlink_log: fix silly refcount leak

Allan Stephens (1):
      tipc: Clean up configuration file

Amerigo Wang (1):
      tipc: use kconfig to limit numeric ranges

Amit Kucheria (2):
      fec: Add LAN8700 phy support
      fec: Add ARCH_MX5 as a dependency

Amit Kumar Salecha (16):
      netxen: minor suspend resume fixes
      netxen: fix tx timeout recovery
      netxen: support pci error handlers
      netxen: fix unified fw size check
      netxen: fix endianness read mac address
      netxen: fix endianness intr coalesce
      netxen: fix license header
      netxen: fix sparse warning
      qlcnic: Qlogic ethernet driver for CNA devices
      NET: Add Qlogic ethernet driver for CNA devices
      qlcnic: use DEFINE_PCI_DEVICE_TABLE
      qlcnic: add ethernet identifier in board info
      qlcnic: clear device reset state after fw recovery
      qlcnic: protect resoruce cleanup by rtnl lock
      qlcnic: add interrupt diagnostic test
      qlcnic: add loopback diagnostic test

Anatolij Gustschin (3):
      fs_enet: use dev_xxx instead of printk
      fs_enet: Add support for MPC512x to fs_enet driver
      fs_enet: add FEC TX buffer alignment workaround for MPC5121

Andreas Mohr (4):
      MCS7830 USB-Ether: add Rx error support
      MCS7830 USB-Ether: Spelling corrections
      MCS7830 USB-Ether: change register define
      MCS7830 USB-Ether: resume _with_ working link, via .reset_resume support

Andreas Petlund (3):
      net: TCP thin-stream detection
      net: TCP thin linear timeouts
      net: TCP thin dupack

Andres Salomon (1):
      mac80211: make rate_control_alloc static

Andriy Tkachuk (3):
      mac80211: Account HT Control field in Data frame hdrlen according to 802.11n-2009
      lib80211: Cosmetics - make room for MIC/CRC near the actual calculation
      lib80211: Introduce TKIP_HDR_LEN define for code clarity

Andy Gospodarek (2):
      bonding: allow arp_ip_targets on separate vlans to use arp validation
      fix bonding: allow arp_ip_targets on separate vlans to use arp validation

Andy Shevchenko (1):
      isdn: remove ishexdigit() in regard to isxdigit()

Arnd Bergmann (7):
      net: maintain namespace isolation between vlan and real device
      macvlan: allow multiple driver backends
      net: macvtap driver
      net/macvtap: fix reference counting
      macvtap: rework object lifetime rules
      net/macvtap: add vhost support
      macvtap: add GSO/csum offload support

Atsushi Nemoto (2):
      isa-skelton: Remove a wrong netif_wake_queue() call
      tc35815: Fix double locking on NAPI

Ben Hutchings (8):
      sfc: Update MCDI protocol definitions
      sfc: Replace PHY MDIO test with an 'alive' test
      sfc: Implement NVRAM selftest for SFC9000 family
      sfc: Remove declarations of nonexistent functions
      sfc: Fix some incorrect or redundant comments
      sfc: Do not include unneeded headers
      net: Fix first line of kernel-doc for a few functions
      ethtool: Don't flush n-tuple list from ethtool_reset()

Ben M Cahill (2):
      iwlwifi: Add chain noise scaling factor
      iwlwifi: Add chain_noise support for 6050

Benjamin Li (1):
      bnx2: Flush the register writes which setup the MSI-X table

Benoit PAPILLAULT (1):
      rt2x00: Disable RX aggregation for rt2800usb

Benoit Papillault (5):
      rt2x00: Fix rt2800usb RX frame format and as such L2PAD
      mac80211: Fixed netif_tx_wake_all_queues in IBSS mode
      mac80211: removed useless code in IBSS management
      mac80211: Fixed a bug in IBSS merge
      mac80211: Added a new debugfs file for reading channel_type

Bob Copeland (4):
      mac80211: pid: replace open-coded msecs_to_jiffies
      ath5k: dont use external sleep clock in AP mode
      ath5k: fix setup for CAB queue
      ath5k: use correct packet type when transmitting

Breno Leitao (2):
      qlge: removing unreachable block of code
      qlge: Code clean up

Brian Haley (1):
      doc: document IPv6 parameters

Brice Goglin (1):
      myri10ge: optimize 4k-boundary check when stocking rx pages

Bruce Allan (3):
      e1000e: use alternate MAC address on ESB2 if available
      e1000e: provide MAC-family-specific function to set LAN ID
      e1000e: genericize the update multicast address list

Catalin(ux) M. BOIE (1):
      IPVS: Allow boot time change of hash size

Chrissie Caulfield (1):
      Orphan DECnet

Christian Lamparter (10):
      ar9170: remove dead definitions
      ar9170: improve network latency
      ar9170: remove redundant frame flags
      ar9170: small misc changes
      ar9170: fix AC_VIDEO txop parameter
      mac80211: fix ampdu_action tx_start ssn
      p54pci: handle dma mapping errors
      p54pci: move tx cleanup into tasklet
      p54pci: revise tx locking
      ath: fix WARN_ON with Polish (Poland) Contry code

Christian Pellegrin (2):
      can: Proper ctrlmode handling for CAN devices
      can: mcp251x: Move to threaded interrupts instead of workqueues.

Christoph Egger (2):
      Remove config option B43_LEGACY_RFKILL completely
      ipv4: obsolete config in kernel source (IP_ROUTE_PERVASIVE)

Colin Ian King (1):
      wireless: hostap, fix oops due to early probing interrupt

Dan Carpenter (1):
      Bluetooth: Add missing kfree() on error path in Atheros driver

Daniel Borkmann (1):
      netpoll: allow execution of multiple rx_hooks per interface

Daniel Halperin (2):
      iwlwifi: fix throughput degradation in aggregation mode
      iwlwifi: optimize power saving

Darren Jenkins (2):
      hardware/mISDN/mISDNinfineon.c: bail out of loop on error
      drivers/net/wireless/p54/txrx.c Fix off by one error

David S. Miller (35):
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      ipv4: Use less conflicting local var name in change_nexthops() loop macro.
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      net: Unexport napi_gro_flush().
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      ariadne: Fix build.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      e1000e: Fix namespace conflicts wrt. e1000_has_link
      packet: Kill CONFIG_PACKET_MMAP.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of ssh://master.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      ethtool: Fix includes build break
      mac80211: Fix error introduced in netdev_mc_count() changes.
      niu: Refinements to kernel logging.
      Merge branch 'master' of git://git.kernel.org/.../kaber/nf-next-2.6
      sparc64: Kill bogus ip_tables.h include.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      xfrm: Revert false event eliding commits.
      net: Make GRETH driver depend on SPARC.
      Merge branch 'master' of git://git.kernel.org/.../kaber/nf-next-2.6
      Merge branch 'master' of git://git.kernel.org/.../kaber/nf-next-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      Revert "ethtool: Add n-tuple string length to drvinfo and return it"
      Merge branch 'master' of git://git.kernel.org/.../kaber/nf-next-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      bridge: Make IGMP snooping depend upon BRIDGE.
      Merge branch 'master' of git://git.kernel.org/.../holtmann/bluetooth-next-2.6
      Merge branch 'master' of /home/davem/src/GIT/linux-2.6/

Deepak Saxena (1):
      Add Station and AdHoc mode support to libertas_tf

Divy Le Ray (3):
      cxgb3: add memory barriers
      cxgb3: FIx VLAN over Jumbo frames
      cxgb3: fix link flap

Eddie Wai (2):
      cnic: Finetune iSCSI connection set up.
      cnic: Finetune iSCSI connection reset.

Einar Lueck (1):
      qeth: default BLKT values for new OSA/3 hardware

Emese Revfy (1):
      iwlwifi: Constify struct iwl_ops

Eric Dumazet (4):
      xfrm: avoid spinlock in get_acqseq()
      ethtool: reduce stack usage
      xt_hashlimit: fix locking
      netfilter: nf_queue: fix NF_STOLEN skb leak

Eric Leblond (1):
      netfilter: nfnetlink_queue: simplify warning message

Eric W. Biederman (3):
      net ipv4: Decouple ipv4 interface parameters from binary sysctl numbers
      net neigh: Decouple per interface neighbour table controls from binary sysctls
      scm: Only support SCM_RIGHTS on unix domain sockets.

FUJITA Tomonori (1):
      mlx4: replace the dma_sync_single_range_for_cpu/device API

Felix Fietkau (19):
      mac80211: use nullfunc frames for 4-addr sta detection
      mac80211: allow station updates on ap interfaces for vlan stations
      mac80211: do not transmit frames on unconfigured 4-addr vlan interfaces
      mac80211: force use_short_slot=true for 5GHz
      ath9k: cleanup slot time and ack/cts timeout handling
      ath9k: implement coverage class support
      mac80211: fix WMM AC default for non-QoS data frames
      ath9k: fix RTS/CTS handling
      mac80211: fix rx data handling for non-data frames on multiple vifs
      ath9k: improve max rate retry handling
      mac80211: fix WARN_ON in the new work code
      mac80211: fix sta lookup for received action frames on an AP VLAN
      mac80211: fix monitor mode tx radiotap header handling
      mac80211: fix sta lookup with AP VLAN interfaces and injected frames
      ath9k: add a workaround for ack timeout issues
      ath9k: fix rate control fallback rate selection
      ath9k: fix beacon timer restart after a card reset
      ath9k: disable RIFS search for AR91xx based chips
      skbuff: align sk_buff::cb to 64 bit and close some potential holes

Flavio Leitner (1):
      igmp: fix ip_mc_sf_allow race [v5]

Florian Westphal (11):
      netfilter: fix build failure with CONNTRACK=y NAT=n
      netfilter: ebtables: abort if next_offset is too small
      netfilter: ebtables: avoid explicit XT_ALIGN() in match/targets
      netfilter: CONFIG_COMPAT: allow delta to exceed 32767
      netfilter: ebtables: split do_replace into two functions
      netfilter: ebtables: split copy_everything_to_user into two functions
      netfilter: ebtables: split update_counters into two functions
      netfilter: ebtables: add CONFIG_COMPAT support
      netfilter: ebtables: try native set/getsockopt handlers, too
      netfilter: ebt_limit: add CONFIG_COMPAT support
      netfilter: ebtables: mark: add CONFIG_COMPAT support

Frederic Leroy (1):
      staging: rtl8192su: fix compile error from wireless-testing commit

Geert Uytterhoeven (1):
      mac8390: Fix build breakage

Gerrit Renker (3):
      dccp: allow probing of CCID-array length
      dccp: support for passing MSG_TRUNC
      udp: remove redundant variable

Gertjan van Wingerde (16):
      rt2x00: Further L2 padding fixes.
      rt2x00: Remove SKBDESC_L2_PADDED flag.
      rt2x00: Reorganize L2 padding inserting function.
      rt2x00: Only remove L2 padding in received frames if there is payload.
      rt2x00: Fix trimming of L2 padded frames.
      rt2x00: Fix checks for rt2800 SOC support.
      rt2x00: Let rt2800lib check CONFIG_RT2X00_LIB_USB instead of CONFIG_RT2800USB
      rt2x00: convert RT2800PCI_PCI and RT2800PCI_SOC Kconfig symbols to booleans.
      rt2x00: Cleanup chip handling helper functions.
      rt2x00: RF3052 is a valid RF chipset for USB devices as well.
      rt2x00: Unify rt2800 WPDMA ready waiting functions.
      rt2x00: Make rt2800_init_led static and don't export it.
      rt2x00: Introduce SoC interface type.
      rt2x00: Reorganize RT chipset setting for PCI/SOC devices.
      rt2x00: rework RT chipset and revision determination for PCI an SOC devices.
      rt2x00: rt2800 - Make rt30xx and rt35xx chipsets configurable.

Giuseppe CAVALLARO (13):
      stmmac: use MII_BUS_ID_SIZE instead of BUS_ID_SIZE
      stmmac: convert unicast addr list to list_head
      stmmac: add the new Header file for stmmac platform data
      stmmac: rewiew platform data
      stmmac: perform hw bus configuration
      stmmac: do not call fix_mac_speed if NULL
      stmmac: reorganise class operations.
      stmmac: move the dma out from the main
      stmmac: rename mac100 as dwmac100 and fix spare coding style
      stmmac: rename the gmac as dwmac1000 and split core and dma parts
      stmmac: include netdevice.h into the common.h header
      stmmac: improve Kconfig help
      stmmac: update the driver's module version

Giuseppe Cavallaro (2):
      phy: SMSC device Energy Detect power-down mode
      stmmac: fix 'lenght' typo in comments and code

Greg Rose (20):
      ixgbevf: Macros, data structures, useful defines and registers
      ixgbevf: 82599 Virtual Function core functions and header
      ixgbevf: Mailbox communication
      ixgbevf: Driver main and ethool interface module and main header
      ixgbevf: Driver Makefile
      ixgbevf: Kconfig, Makefile and Documentation
      ixgbe: Mailbox header and code module
      ixgbe: Add SR-IOV register, structure and bit defines
      ixgbe: Add SR-IOV specific features
      ixgbe: Add SR-IOV specific modules to driver Makefile
      ixgbe: Add SR-IOV feature enablement code
      ixgbe: Add SR-IOV features to main module
      ixgbe: Fix ethtool diag test for VT mode operation
      ixgbe: Set the correct pool when VLANs are added in SR-IOV mode.
      ixgbe: Remove unused emulation MAC storage from the per VF data structure.
      ixgbe: Allow the VF driver to be loaded before the PF driver
      ixgbe: Improve reset coordination between the PF and the VF
      ixgbevf: Take action when the PF notifies the VF it is resetting.
      ixgbevf: Fix panics in the VF driver
      ixgbevf: Tell network stack to stop tx when the VF detects PF reset

Guido Barzini (1):
      sfc: Survive ISR0=0 bug in the shared IRQ case

H Hartley Sweeten (17):
      drivers/net/lib82596.c: use %pM to shown MAC address
      drivers/net/igbvf/netdev.c: use %pM to shown MAC address
      drivers/net/usb/rtl8150.c: use %pM to shown MAC address
      drivers/net/via-velocity.c: use %pM to shown MAC address
      drivers/net/xilinx_emaclite.c: use %pM to shown MAC address
      drivers/s390/net/qeth_l2_main.c: use %pM to shown MAC address
      drivers/net/usb/catc.c: use %pM to shown MAC address
      drivers/net/sunvnet.c: use %pM to shown MAC address
      drivers/net/smc911x.c: use %pM to shown MAC address
      drivers/net/octeon/octeon_mgmt.c: use %pM to shown MAC address
      drivers/net/r8169.c: use %pM to shown MAC address
      Subject: drivers/net/sh_eth.c: use %pM to shown MAC address
      drivers/infiniband/hw/cxgb3/iwch_cm.c: use %pM to show MAC address
      drivers/message/i2o/i2o_proc.c: use %pM to show MAC address
      ep93xx_eth.c general cleanup
      iwl-debugfs.c: remove unnecessary casts of void *
      net/core/sock.c: quiet sparse noise

Hagen Paul Pfeifer (1):
      sched: add head drop fifo queue

Hamish Guthrie (3):
      ps3_gelic_wireless: Remove PS3 gelic legacy wpa support
      ps3_gelic_wireless: fix directed ssid scan
      ps3_gelic_wireless: Remove superfluous debug info

Hauke Mehrtens (5):
      b43legacy: fix typo in ifdef comment
      rtl8187: fix typo in ifdef comment
      ssb: fix typo in ifdef comment
      b44: Set PHY address to NO_PHY if reset fails.
      b44: use netdev_alloc_skb instead of dev_alloc_skb

Helmut Schaa (1):
      mac80211: use listen interval 5 as default

Henry Zhangh (1):
      iwlwifi: Fix A band scanning when associated

Herbert Xu (14):
      bridge: Remove unused age_list
      bridge: Do br_pass_frame_up after other ports
      bridge: Allow tail-call on br_pass_frame_up
      bridge: Avoid unnecessary clone on forward path
      bridge: Use BR_INPUT_SKB_CB on xmit path
      bridge: Split may_deliver/deliver_clone out of br_flood
      bridge: Add core IGMP snooping support
      bridge: Add multicast forwarding functions
      bridge: Add multicast start/stop hooks
      bridge: Add multicast data-path hooks
      bridge: Add multicast_router sysfs entries
      bridge: Add multicast_snooping sysfs toggle
      bridge: Add hash elasticity/max sysfs entries
      bridge: Add multicast count/interval sysfs entries

Holger Schurig (10):
      libertas: use priv->mesh_tlv instead of priv->mesh_fw_ver
      libertas: remove mesh_autostart_enabled and sync_channel
      libertas: move mesh-related definitions into mesh.h
      libertas: decouple mesh and rtap
      libertas: move mesh SSID initialization into mesh.c
      libertas: add access functions for mesh open/connect status
      libertas: make mesh configurable
      libertas: remove priv->capability
      libertas: remove priv->ratebitmap
      libertas: don't retry commands

Jamal Hadi Salim (11):
      pfkey: fix SA and SP flush sequence
      xfrm: Flushing empty SAD generates false events
      xfrm: Flushing empty SPD generates false events
      xfrm: introduce basic mark infrastructure
      xfrm: SA lookups signature with mark
      xfrm: SA lookups with mark
      xfrm: SP lookups signature with mark
      xfrm: SP lookups with mark
      xfrm: Allow user space config of SAD mark
      xfrm: Allow user space manipulation of SPD mark
      xfrm: clone mark when cloning policy

Jan Engelhardt (20):
      netfilter: xt_recent: save 8 bytes per htable
      netfilter: xtables: do not grab random bytes at __init
      netfilter: xtables: obtain random bytes earlier, in checkentry
      netfilter: xtables: compact table hook functions (1/2)
      netfilter: xtables: compact table hook functions (2/2)
      netfilter: xtables: use xt_table for hook instantiation
      netfilter: xtables: generate initial table on-demand
      netfilter: xt_recent: inform user when hitcount is too large
      netfilter: iptables: remove unused function arguments
      netfilter: reduce NF_HOOK by one argument
      netfilter: get rid of the grossness in netfilter.h
      netfilter: xtables: print details on size mismatch
      netfilter: xtables: constify args in compat copying functions
      netfilter: xtables: add const qualifiers
      netfilter: xtables: replace XT_ENTRY_ITERATE macro
      netfilter: xtables: optimize call flow around xt_entry_foreach
      netfilter: xtables: replace XT_MATCH_ITERATE macro
      netfilter: xtables: optimize call flow around xt_ematch_foreach
      netfilter: xtables: reduce arguments to translate_table
      netfilter: xtables: restore indentation

Jan Kiszka (41):
      CAPI: Fix leaks in capifs_new_ncci
      CAPI: Sanitize capifs API
      CAPI: Eliminate capifs_root variable
      CAPI: Pin capifs instead of mounting it
      CAPI: Reduce chattiness during module loading/removal
      CAPI: Call a controller 'controller', not 'card'
      CAPI: Convert capi drivers rwlock into mutex
      CAPI: Rework capi_ctr_ready/down
      CAPI: Rework controller state notifier
      CAPI: Rework locking of controller data structures
      CAPI: Rework application locking
      CAPI: Reduce #ifdef mess around CONFIG_ISDN_CAPI_MIDDLEWARE
      CAPI: Convert capidev_list_lock into a mutex
      CAPI: Clean up capi_open/release
      CAPI: Rework locking of capidev members
      CAPI: Use non-atomic allocation during NCCI setup
      CAPI: Fix racy capi_read
      CAPI: Switch NCCI list to standard doubly linked list
      CAPI: Switch capiminor list to array
      CAPI: Clean up capinc_tty_init/exit
      CAPI: Dynamically register minor devices
      CAPI: Use dynamic major for NCCI TTYs by default
      CAPI: Use kref on capiminor
      CAPI: Establish install/cleanup handlers for capiminor TTYs
      CAPI: Use tty_port to keep track of capiminor's tty
      CAPI: Drop remaining NULL checks on tty->driver_data
      CAPI: Issue synchronous hangup on capincci_free_minor
      CAPI: Drop obsolete nccip from capiminor struct
      CAPI: Clean up capiminors_lock
      CAPI: Drop atomic ttyopencount
      CAPI: Drop handle_minor_recv from capinc_tty_write
      CAPI: Rework capiminor RX handler
      CAPI: Rename datahandle_queue -> ackqueue_entry
      CAPI: Use atomics for capiminor's datahandle and msgid
      CAPI: Drop capiminor's unused inbytes counter
      CAPI: Fix locking around capiminor's output queue and drop workaround_lock
      CAPI: Clean up capiminor_*_ack
      CAPI: Drop return value of handle_minor_send
      CAPI: Drop special controller lookup from capi20_put_message
      CAPI: Schedule capifs for removal
      CAPI: Remove experimental tag from middleware feature

Jarek Poplawski (1):
      sky2: Fix TX_MAP_PAGE misspelling

Jean-Fran√ßois Moine (1):
      p54usb: Add the USB ID for Belkin (Accton) FD7050E ver 1010ec

Jeff Garzik (2):
      net: Delete isa-skeleton net driver
      ethtool: do not set some flags, if others failed

Jeff Kirsher (1):
      ixgbevf: Fix IPv6 GSO type checks

Jeff Mahoney (1):
      ipg: Remove device claimed by dl2k from pci id table

Jesper Dangaard Brouer (2):
      net: RFC3069, private VLAN proxy arp support
      net: Make it easier to parse /proc/net/dev contents.

Jesse Brandeburg (1):
      ixgbe: Allocate driver resources per NUMA node

Jiri Pirko (35):
      net: use helpers to access uc list V2
      net: use helpers to access mc list V2
      libphy: add phy_find_first function
      net: 8139cp: convert to use mc helpers
      net: 8139too: convert to use mc helpers
      net: dm9601: convert to use mc helpers
      net: e1000e: convert to use mc helpers
      net: use netdev_mc_count and netdev_mc_empty when appropriate
      macb: straighten out macb_mii_probe function
      cassini: convert to use netdev_for_each_mc_addr
      net: convert multiple drivers to use netdev_for_each_mc_addr
      cxgb3: convert to use netdev_for_each_addr
      chelsio: convert to use netdev_for_each_mc_addr
      depca: remove forgotten needless inicialization
      3c5xx: use netdev_mc_* helpers
      smsc911x: convert to use netdev_for_each_mc_addr
      net: convert multiple drivers to use netdev_for_each_mc_addr, part2
      tulip: convert to use netdev_for_each_mc_addr
      net/usb: convert to use netdev_for_each_mc_addr
      staging: convert to use netdev_for_each_mc_addr
      tokenring: convert to use netdev_for_each_mc_addr
      net/pcmcia: convert to use netdev_for_each_mc_addr
      net/arm: convert to use netdev_for_each_mc_addr
      net: convert multiple drivers to use netdev_for_each_mc_addr, part3
      e1000: convert to use netdev_for_each_mc_addr
      net: convert multiple drivers to use netdev_for_each_mc_addr, part4
      e1000: correct wrong coding style for "else"
      net: convert multiple drivers to use netdev_for_each_mc_addr, part5 V2
      net: convert multiple drivers to use netdev_for_each_mc_addr, part6
      octeon: convert to use netdev_for_each_mc_addr
      af_packet: do not accept mc address smaller then dev->addr_len in packet_mc_add()
      net: add addr len check to dev_mc_add
      infiniband: convert to use netdev_for_each_mc_addr
      ipoib: returned back addrlen check for mc addresses
      wireless: convert to use netdev_for_each_mc_addr

Jiri Slaby (3):
      NET: ipv6, remove unnecessary check
      NET: irda, remove unnecessary checks
      isdn: mISDN, don't compile unused stuff

Jochen Friedrich (2):
      ssb: fix interrupt assignment
      b44: Ratelimit timeout error message.

Joe Perches (88):
      iwmc3200wifi: Avoid an offset calculation for each management frame.
      drivers/net/mac8390.c: Indent case labels
      drivers/net/mac8390.c: Remove useless memcpy casting
      drivers/net/mac8390.c: Convert printk(KERN_<level> to pr_<level>(
      drivers/net/mac8390.c: Checkpatch cleanups
      drivers/net/mac8390.c: Add mac8390_init function
      lib/vsprintf.c: Add %pMF to format FDDI bit reversed MAC addresses
      net/ipv6/tcp_ipv6.c: Use compressed IPv6 address
      lib: Kill bit-reversed FDDI MAC output case, it's bogus.
      netfilter: nf_nat_ftp: remove (*mangle[]) array and functions, use %pI4
      ipvs: use standardized format in sprintf
      netfilter: xt_osf: change %pi4 to %pI4
      net/mac80211/mlme.c: Remove unnecessary semicolons
      lib/vsprintf.c: Add IPV4 options %pI4[hnbl] for host, network, big and little endian
      drivers/net/tlan: Remove TRUE/FALSE defines, use bool
      net/atm: Convert printk to pr_<level>
      net/atm/addr.c: Convert include <asm to include <linux
      net/atm/atm_misc.c: checkpatch cleanups
      net/atm/atm_sysfs.c: checkpatch cleanups
      net/atm/br2684.c: checkpatch cleanups
      net/atm/clip.c: checkpatch cleanups
      net/atm/common.c: checkpatch cleanups
      net/atm/ioctl.c: checkpatch cleanups
      net/atm/lec.c: checkpatch cleanups
      net/atm/mpc.c: checkpatch cleanups
      net/atm/mpoa_caches.c: checkpatch cleanups
      net/atm/mpoa_proc.c: checkpatch cleanups
      net/atm/pppoatm.c: checkpatch cleanups
      net/atm/proc.c: checkpatch cleanups
      net/atm/pvc.c: checkpatch cleanups
      net/atm/raw.c: checkpatch cleanups
      net/atm/resources.c: checkpatch cleanups
      net/atm/signaling.c: checkpatch cleanups
      net/atm/svc.c: checkpatch cleanups
      net/atm/lec.c: Add __lec_arp_check_expire and other cleanups
      net/atm: Cleanup dprint/ddprintk #defines and uses
      tulip_core: Use dev_<level> and pr_<level>
      tulip/21142.c: Use dev_<level> and pr_<level>
      tulip/de2104x.c: Use dev_<level> and pr_<level>
      tulip/dmfe.c: Use dev_<level> and pr_<level>
      tulip/eeprom.c: Use dev_<level> and pr_<level>
      tulip/interrupt.c: Use dev_<level> and pr_<level>
      tulip/media.c: Use dev_<level> and pr_<level>
      tulip/pnic.c: Use dev_<level> and pr_<level>
      tulip/pnic2.c: Use dev_<level> and pr_<level>
      tulip/timer.c: Use dev_<level> and pr_<level>
      tulip/uli526x.c: Use dev_<level> and pr_<level>
      tulip/winbond-840.c: Use dev_<level> and pr_<level>
      tulip/xircom_cb.c: Use dev_<level> and pr_<level>
      drivers/net/amd8111e.c: Fix continuation line formats
      net/rds: remove uses of NIPQUAD, use %pI4
      drivers/net/davinci_emac.c: Fix continuation line formats
      netdevice.h: Add netdev_printk helpers like dev_printk
      drivers/net/atl1e: Use netdev_printk helpers
      include/linux/netdevice.h: Add netif_printk helpers
      drivers/net/r8196.c: Use netif_printk macros
      drivers/net/jme: Use netif_printk helpers
      drivers/net/qlge: Use netif_printk helpers
      drivers/net/skge.c: Use netif_printk macros
      niu: Use pr_<level>, netdev_<level> and netif_<level> macros
      drivers/net/ixgb: Use netif_printk macros
      drivers/net/sky2: Convert to use netif_printk macros
      drivers/net/tehuti.c: Use (pr|netdev|netif)_<levels> macro helpers
      drivers/net/tehuti.c: Hoist assigns out of ifs
      drivers/net/tehuti.c: trivial checkpatch cleanups
      drivers/net/pcnet32.c: Use (pr|netdev|netif)_<levels> macro helpers
      drivers/net/pcnet32.c: Checkpatch cleaning
      ipv6.h: reassembly: replace calculated magic number with multiplication
      usbnet: Convert dev(dbg|err|warn|info) macros to netdev_<level>
      drivers/net/usb: Use netif_<level> logging facilities
      drivers/net/8139cp.c: Use (pr|netdev|netif)_<level> macro helpers
      drivers/net/8139too.c: Use (pr|netdev|netif)_<level> macro helpers
      drivers/net/b44.c: Use (pr|netdev|netif)_<level> macro helpers
      drivers/net/bnx2.c: Use (pr|netdev|netif)_<level> macro helpers
      drivers/net/bnx2x: Use (pr|netdev|netif)_<level> macro helpers
      drivers/net/cassini.c: Use (pr|netdev|netif)_<level> macro helpers
      drivers/net/cnic.c: Use (pr|netdev)_<level> macro helpers
      drivers/net/pci-skeleton.c: Use (pr|netdev|netif)_<level> macro helpers
      drivers/net/skge.c: Use (pr|netdev)_<level> macro helpers
      drivers/net/skge.c: Use (pr|netdev)_<level> macro helpers
      drivers/net/sky2.c: Use (pr|netdev)_<level> macro helpers
      drivers/net/yellowfin.c: Use (pr|netdev)_<level> macro helpers
      drivers/net/tehuti.c: Reapply use DEFINE_PCI_DEVICE_TABLE()
      drivers/net/tg3.c: Use (pr|netdev)_<level> macro helpers
      drivers/net/sis190.c: Use (pr|netdev|netif)_<level> macro helpers
      drivers/net/typhoon.c: Use (pr|netdev)_<level> macro helpers
      drivers/net/chelsio: Use pr_<level>, netif_msg_<type>
      drivers/net/myri10ge: Use pr_<level> and netdev_<level>

Johann Felix Soden (1):
      Bluetooth: Fix out of scope variable access in hci_sock_cmsg()

Johannes Berg (66):
      mac80211: make station management completely depend on vif
      mac80211: reduce reliance on netdev
      mac80211: trace interface name
      mac80211: enable spatial multiplexing powersave
      mac80211_hwsim: implement ampdu action
      mac80211: allow disabling 40MHz on 2.4GHz
      cfg80211: avoid sending spurious deauth to userspace
      mac80211: dont try to use existing sta for AP
      mac80211: disallow fixing bitrates with hw rate control
      iwlwifi: use new mac80211 SMPS
      mac80211: add ieee80211_sdata_running
      mac80211: introduce flush operation
      mac80211: let cfg80211 manage auth state
      mac80211: generalise management work a bit
      mac80211: generalise work handling
      mac80211: rewrite a few work messages
      mac80211: refactor association
      mac80211: split up and insert custom IEs correctly
      mac80211: proper bss private data handling
      mac80211: support remain-on-channel command
      mac80211: make off-channel work generic
      mac80211/cfg80211: add station events
      mac80211: remove struct ieee80211_if_init_conf
      mac80211: remove requeue from work
      mac80211: fix a few work bugs
      mac80211: fix return from ieee80211_assoc_success
      mac80211: remove unused type argument
      mac80211: move and rename misc tx handler
      mac80211: clear TX control on filtered frames
      mac80211: remove useless setting of IEEE80211_TX_INTFL_DONT_ENCRYPT
      mac80211: move control.hw_key assignment
      mac80211: re-enable re-transmission of filtered frames
      cfg80211: rcu-ify rdev and wdev
      mac80211: pass vif and station to update_tkip_key
      cfg80211: export multiple MAC addresses in sysfs
      mac80211: add missing key check
      iwlwifi: is no longer experimental
      iwlwifi: reorder device setup
      iwlwifi: clean up debugfs code
      iwlwifi: fix sparse warning
      iwlwifi: check endianness annotations by default
      mac80211: fix sw crypto
      mac80211: track work started through callbacks
      mac80211: fill jiffies/vif on filtered frames
      cfg80211: export cfg80211_find_ie
      mac80211: wait for beacon before enabling powersave
      iwlwifi: fix locking in iwl_mac_add_interface
      iwlwifi: no need to test iw_mode in power saving
      iwlagn: simplify ucode loading
      iwlwifi: remove bg_up work
      iwlwifi: remove unused work structs
      iwlwifi: fix typo in IWL_CCK_RATES_MASK
      mac80211_hwsim: add fake hw scan handler
      wireless: update radiotap parser
      mac80211: don't probe if we have probe response
      mac80211: allow station add/remove to sleep
      mac80211: fix bss_conf.dtim_period
      mac80211: fix deauth race
      mac80211: fix netdev rename
      mac80211: reject unhandled action frames
      mac80211: split ieee80211_drop_unencrypted
      ar9170: convert to new station add/remove callbacks
      p54: convert to new station add/remove callbacks
      mac80211_hwsim: convert to new station add/remove callbacks
      ath9k: convert to new station add/remove callbacks
      mwl8k: convert to new station add/remove callbacks

John Fastabend (4):
      ixgbe: only process one ixgbe_watchdog_task at a time.
      ixgbe: do not stop tx queues in ixgbe_set_tso
      ixgbe: Do not allocate too many netdev txqueues
      ixgbe: move TC_PRIO_CONTROL check into ixgbe_select_queue()

John Linn (1):
      net: emaclite: adding MDIO and phy lib support

John W. Linville (26):
      wireless: report reasonable bitrate for MCS rates through wext
      wireless: support internal statically compiled regulatory database
      wireless: fix comments in genregdb.awk
      Merge git://git.kernel.org/.../linville/wireless-2.6
      wireless: remove CONFIG_WIRELESS_OLD_REGULATORY
      rtl8180: remove priv->mode
      rtl8187: remove priv->mode
      Merge git://git.kernel.org/.../linville/wireless-2.6
      mac80211: fix typo added by "mac80211: fix propagation of failed..."
      Merge git://git.kernel.org/.../linville/wireless-2.6
      wireless: fix build breakage when CONFIG_CFG80211_REG_DEBUG not set
      Merge git://git.kernel.org/.../linville/wireless-2.6
      Revert "iwmc3200wifi: fix array out-of-boundary access"
      Merge git://git.kernel.org/.../linville/wireless-2.6
      libertas/assoc.c: rearrange some strange line breaks
      mac80211: avoid NULL ptr deref when using WEP
      libertas: add comment re: v10 firmware key handling
      rtl8180: implement get_tsf op for mac80211
      cfg80211: fix wext-compat for setting rate to 'auto'
      ps3_gelic_wireless: fix format warning
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      Merge branch 'wireless-next-2.6' of git://git.kernel.org/.../iwlwifi/iwlwifi-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      Merge branch 'wireless-2.6' of git://git.kernel.org/.../iwlwifi/iwlwifi-2.6
      Merge branch 'wireless-next-2.6' of git://git.kernel.org/.../iwlwifi/iwlwifi-2.6
      netdevice.h: check for CONFIG_WLAN instead of CONFIG_WLAN_80211

Jouni Malinen (11):
      mac80211_hwsim: Check all local addresses for TX Ack status
      mac80211: Generalize off-channel operation helpers from scan code
      cfg80211: add remain-on-channel command
      mac80211: No need to include WEXT headers here
      mac80211: Select lowest rate based on basic rate set in AP mode
      cfg80211/mac80211: Use more generic bitrate mask for rate control
      nl80211: New command for setting TX rate mask for rate control
      cfg80211: Store IEs from both Beacon and Probe Response frames
      nl80211: Allow association to change channels during reassociation
      cfg80211/mac80211: allow registering for and sending action frames
      ath9k: Use the Beacon TX rate from mac80211

Juha Leppanen (1):
      wl1271: fix timeout in wl1271_top_reg_read

Julia Lawall (4):
      drivers/net/cxgb3: Use kzalloc for allocating only one thing
      netfilter: SNMP NAT: correct the size argument to kzalloc
      drivers/net: Eliminate useless code
      net/sctp: Eliminate useless code

Jussi Kivilinna (2):
      rndis_wlan: move copy of module parameters to separate function
      rndis_wlan: copy module parameters for bcm4320a devices too

Juuso Oikarinen (27):
      wl1271: Configure smart-reflex paramter values.
      wl1271: Remove smart reflex ACX
      wl1271: Use slow rates for association messages
      wl1271: Fix event acknowledging functionality
      wl1271: prevent power save entry while not associated
      wl1271: Implement chipset boot retry
      wl1271: Add pre-power-on sleep
      wl1271: Remove beacon-loss-ind from PSM entry failure handling
      wl1271: Add rudimentary ad-hoc support
      wl1271: Change rates configured for templates
      wl1271: Fix supported rate management
      wl1271: Change booleans in struct wl1271 into a flags bitmask
      wl1271: Add support for acx_pm_config
      wl1271: Check vif for NULL when indicating beacon-loss
      wl1271: Prevent performing "join" before association
      wl1271: Fix PSM entry
      wl1271: Fix channel changing code
      wl1271: Add SSID configuration for JOIN in ad-hoc
      wl1271: Use NVS INI file configuration
      wl1271: Retrieve device mac address from the nvs file
      wl1271: Fix random MAC address setting
      wl1271: Optimized RX path packet retrieval
      wl1271: Fix key-remove error
      wl1271: Fix WEP key handling
      wl1271: Fix ad-hoc SSID update
      wl1271: Fix beacon filter table configuration
      mac80211: fix direct probe loop on ieee80211_work_purge

Kalle Valo (53):
      wl1251: add tx queue status to debugfs
      wl1251: print a debug message when tx_queue is full
      wl1251: fix error handling in wl1251_op_config()
      wl1251: reduce ELP wakeup timeout
      wl1251: simplify ELP wakeup time calculation
      wl1251: use __dev_alloc_skb() on RX
      wl1251: implement acx_ac_cfg to configure hardware queues
      wl1251: implement wl1251_acx_tid_cfg()
      wl1251: implement WMM
      wl1251: update tx_hdr when aliging skb in tx
      wl1251: enable WMM
      mac80211: remove payload alignment warning
      mac80211: annotate sleeping driver ops
      mac80211: fix a warning related to pointer conversion to u64 cookie
      mac80211: fix ieee80211_change_mac() to use struct sockaddr
      mac80211: add functions to create PS Poll and Nullfunc templates
      mac80211: use PS Poll and Nullfunc templates when sending such frames
      wl1251: get PS Poll and Nullfunc templates from mac80211
      mac80211: create Probe Request template
      mac80211: use Probe Request template when sending a direct scan
      wl1251: cleanup scanning code
      wl1251: get probe request template from mac80211
      wl1251: use mac80211 provided channel parameters in scanning
      wl1251: fix sleep related error paths in wl1251_op_bss_info_changed()
      mac80211: add U-APSD client support
      mac80211: add debugfs interface for U-APSD queue configuration
      mac80211: create tx handler for dynamic ps
      mac80211: check uapsd state for dynamic power save
      ieee80211: add struct ieee80211_hdr_qos
      wl1251: create qos null data template
      wl1251: add U-APSD support
      mac80211: fix mac80211.h documentation warnings
      mac80211: improve powersave documentation
      mac80211: fix tx select key null pointer crash with hostapd
      mac80211: fix update_tkip_key() documentation about the context
      wl1251: fix txop unit
      adm821: remove get_tx_stats() mac80211 op
      mwl8k: remove get_tx_stats() mac80211 op
      ar9170: remove get_tx_stats() mac80211 op
      ath5k: remove get_tx_stats() mac80211 op
      b43: remove get_tx_stats() mac80211 op
      b43legacy: remove get_tx_stats() mac80211 op
      iwlwifi: remove get_tx_stats() mac80211 op
      p54: remove get_tx_stats() mac80211 op
      rt2x00: remove get_tx_stats() mac80211 op
      mac80211: remove get_tx_stats() driver op
      nl80211: add power save commands
      wl1271: modify wl1271_acx_ac_cfg() to use function parameters
      wl1271: modify wl1271_acx_tid_cfg() to use function parameters
      wl1271: implement WMM
      wl1271: wakeup chip in op_conf_tx()
      wl1271: add testmode support
      MAINTAINERS: update Kalle's email address

Ken Kawasaki (2):
      axnet_cs: remove unnecessary spin_unlock_irqrestore
      axnet_cs: add new id

Kenichi HORIO (1):
      rt73usb: add WLI-U2-H54HP

Krishna Kumar (5):
      tcp: Remove check in __tcp_push_pending_frames
      tcp: Remove unrequired operations in tcp_push()
      tcp: Slightly optimize tcp_sendmsg
      net: release dst entry while cache-hot for GSO case too
      net: Optimize non-gso test checks

Kristoffer Glembo (1):
      net: Add Aeroflex Gaisler 10/100/1G Ethernet MAC driver

Kuninori Morimoto (1):
      net/irda: sh_sir: Add SuperH IrDA driver

Larry Finger (7):
      rtl8180: Remove usage of deprecated 'qual'
      b43: Allow PIO mode to be selected at module load
      Staging: r8187se: Fix compile error from wireless-testing commit 7044cc56
      b43: N PHY: Fix compilation after removal of typdef b43_c32
      rtl8187: Add callback for get_tsf
      b43/b43legacy: Wake queues in wireless_core_start
      ssb: Add PCI ID 0x4322 to PHU handling

Lennart Sorensen (1):
      ppp_generic.c severly whitespace damanged by 9c705260feea6ae329bc6b6d5f6d2ef0227eda0a

Lennert Buytenhek (56):
      mwl8k: firmware command code cleanup
      mwl8k: hw is never NULL in mwl8k_set_radio_preamble()
      mwl8k: get rid of the AMSDU check in the transmit path
      mwl8k: inline qos field manipulation functions
      mwl8k: initialize the mwl8k_info_tbl table using the MWL* enums
      mwl8k: add 2.4GHz channels 12, 13 and 14
      mwl8k: get rid of the struct mwl8k_firmware abstraction
      mwl8k: do rx/tx ring initialisation after loading firmware
      mwl8k: fix up AP vs. STA firmware image receive descriptor handling
      mwl8k: remove unused mwl8k_vif::priv
      mwl8k: remove duplicate local per-vif copy of ieee80211_bss_conf
      mwl8k: update version number to 0.11
      mwl8k: bail out if there is no AP firmware image support for this chip
      mwl8k: prevent freeing free IRQ if ieee80211_register_hw() fails
      mwl8k: make the tx ring drain status messages somewhat more friendly
      mwl8k: move struct peer_capability_info to its only user
      mwl8k: handle station database update for AP's sta entry via ->sta_notify()
      mwl8k: remove mwl8k_vif::bssid, which is now useless
      mwl8k: move ->peer_id from mwl8k_vif to mwl8k_sta
      mwl8k: honor peer rate set
      mwl8k: fix changed flags handling in mwl8k_bss_info_changed()
      mwl8k: add support for 88w8363 in STA mode
      mwl8k: allow setting HT channels
      mwl8k: pass in HT capabilities and rates when associating
      mwl8k: trivial rx-only ampdu implementation
      mwl8k: pass GET_HW_SPEC capability bitmask up the stack
      mwl8k: minor cleanups
      mwl8k: undo transmit queue 0/1 swapping in mwl8k_cmd_set_edca_params()
      mwl8k: bump the transmit wait timeout to 5 seconds
      mwl8k: simplify mwl8k_cmd_use_fixed_rate()
      mwl8k: add the AP version of USE_FIXED_RATE
      mwl8k: implement AP firmware station database maintenance
      mwl8k: correctly set the mac_type field for AP SET_MAC_ADDR
      mwl8k: basic AP interface support
      mwl8k: allow limiting the amount of transmit reclaim done
      mwl8k: keep TX_DONE interrupt masked while transmit reclaim is running
      mwl8k: move receive processing to tasklet
      mac80211: flush workqueue before calling driver ->stop() method
      mwl8k: update MODULE_FIRMWARE tags
      mwl8k: remove (mostly) write-only variable priv->current_channel
      mwl8k: don't call SET_AID if we're not associated
      mwl8k: simplify sequence number assignment
      mwl8k: add another 88w8366 PCI ID
      mwl8k: rename 2.4 GHz band/channels/rates related variables from FOO to FOO_24
      mwl8k: move responsibility for initialising wiphy bands to GET_HW_SPEC
      mwl8k: add 5 GHz band channels and rates
      mwl8k: properly set receive status rate index on 5 GHz receive
      mwl8k: handle 5 GHz legacy rate bitmaps in firmware commands
      mwl8k: allow selecting 5 GHz channels
      mwl8k: use firmware capability field to decide which bands to register
      mwl8k: convert the priv->vif pointer to a list of vifs
      mwl8k: prepare for posting per-vif firmware commands
      mwl8k: post per-vif firmware commands as per-vif commands
      mwl8k: enable multi-BSS AP operation
      mwl8k: update version number (to 0.12) and copyright
      MAINTAINERS: update mwl8k maintenance status

Li Zefan (13):
      seq_file: Add helpers for iteration over a hlist
      net: add a wrapper sk_entry()
      net: x25: use seq_hlist_foo() helpers
      net: rose: use seq_hlist_foo() helpers
      net: packet: use seq_hlist_foo() helpers
      net: netrom: use seq_hlist_foo() helpers
      net: ax25: use seq_hlist_foo() helpers
      net: appletalk: use seq_hlist_foo() helpers
      net: af_key: use seq_hlist_foo() helpers
      net: x25: use seq_list_foo() helpers
      net: irda: use seq_list_foo() helpers
      net: ipx: use seq_list_foo() helpers
      net: atm: use seq_list_foo() helpers

Linus Torvalds (1):
      b43: fall back gracefully to PIO mode after fatal DMA errors

Liu Yu-B13201 (4):
      dts/mpc8569mds: Cleanup tbi phy to support rtbi
      mpc8569mds: Add bscr setting for rtbi mode
      ucc_geth: update the tbi-phy setting
      phy: add RTBI mode for m88e1111

Luca Verdesca (1):
      ath5k: adding LED support for AR5BXB63 cards

Luciano Coelho (18):
      wl1271: updated radio parameters structure for newer firmwares
      wl1271: updated general parameters structure for newer firmwares
      wl1271: update radio and general parameters values
      wl1271: added radio parameters configuration values newer firmwares
      wl1271: use join command with dummy BSSID
      wl1271: remove workaround for disconnection
      wl1271: limit TX power to 25dBm for every channel
      wl1271: check result code from the join command
      wl1271: set null data template when BSSID is known
      wl1271: use the correct macro when setting the basic rates
      wl1271: implement dco itrim parameters setting
      wl1271: fix one typo in the rx_rssi_and_proc_compens values
      wl1271: add gpio_power file in debugfs to power the chip on and off
      wl1271: upload only the first 468 bytes from the NVS file
      wl1271: some new configuration values according to new reference
      wl1271: use channel 1 when configuring the data path
      wl1271: add most of the normal initialization commands to PLT mode
      wl1271: skip 3 unused bytes from the NVS

Luis R. Rodriguez (19):
      ath9k_hw: remove unused ath9k_hw_devname() and ath9k_hw_probe()
      ath9k: add MCS rate index back to debufs rcstat
      mac80211: make debugfs mcs set entry reflect 16 bits
      mac80211: parse the HT capabilities info through debugfs
      mac80211: only bother printing highest data rate on debugfs if its set
      cfg80211: add a regulatory debug print
      ath9k: re-enable ps by default for new single chip families
      cfg80211: add debug print when we drop a bogus country IE
      cfg80211: process the max power on a country IE
      cfg80211: Fix country IE parsing for single channel triplets
      cfg80211: fix 2 GHz subband calculation for country IEs
      wl1271: remove unused flags
      cfg80211: Ingore country IEs with a zero set of number of channels
      cfg80211: make regulatory_hint_11d() band specific
      ath9k: make tx power config changes take effect immediatley
      cfg80211: avoid flushing the global workqueue for core reg hints
      cfg80211: add regulatory hint disconnect support
      ath9k: add support for 802.11n bonded out AR2427
      atl1c: Add support for Atheros AR8152 and AR8152

Luk√°≈° Turek (5):
      nl80211: Add new WIPHY attribute COVERAGE_CLASS
      mac80211: Add new callback set_coverage_class
      ath5k: Fix functions for getting/setting slot time
      ath5k: Reimplement clock rate to usec conversion
      ath5k: Implement mac80211 callback set_coverage_class

Mallikarjuna R Chilakala (1):
      ixgbe: Fix DMA mapping/unmapping issues when HWRSC is enabled on IOMMU enabled kernels

Marc Kleine-Budde (1):
      can/netlink: add CAN_CTRLMODE_ONE_SHOT

Marcel Holtmann (4):
      Bluetooth: Convert controller hdev->type to hdev->bus
      Bluetooth: Convert inquiry cache to use debugfs instead of sysfs
      Bluetooth: Convert Marvell driver to use per adapter debugfs
      Bluetooth: Add controller types for BR/EDR and 802.11 AMP

Masatake YAMATO (1):
      netlink: Adding inode field to /proc/net/netlink

Matt Carlson (38):
      tg3: Enable PLL PD when CLKREQ disabled for 5717A0
      tg3: Improve internal resource allocations
      tg3: Add 5717 serdes phy ID
      tg3: Abort phy init for 5717 serdes devices
      tg3: Fix 5717 and 57765 memory selftests
      tg3: Supply a nicaddr for 57765 jumbo RCB
      tg3: Fix tx mailbox initialization
      tg3: Turn off the debug UART for 57765
      tg3: Bypass power source switching for 57765
      tg3: Add 57765 phy ID and enable devices.
      tg3: Give MSI-X vec 1 rx backlog space
      tg3: Prevent rx producer ring overruns
      tg3: Unwedge stuck MSI-X vectors
      tg3: Fix 57765 A0 bootcode race condition
      tg3: Turn off multiple DMA reads for 5717
      tg3: Reset phy during bringup when using phylib
      tg3: Fix napi assignments in loopback test
      tg3: Fix AC131 loopback test errors for 5785
      tg3: Update driver version to 3.107
      tg3: Enforce DMA mapping / skb assignment ordering
      tg3: Make 57791 and 57795 10/100 only
      tg3: Add support for 2 new selfboot formats
      tg3: Allow phylib flowctrl changes anytime
      tg3: Add more partno entries for fallback path
      tg3: Rename TG3_FLG3_RGMII_STD_IBND_DISABLE
      tg3: Reduce indent level of tg3_rx_prodring_alloc
      tg3: Discover phy address once
      tg3: Reformat SSID to phy ID table
      tg3: Rename tg3 phy ID preprocessor definitions
      tg3: Push phylib definitions to phylib
      tg3: Update version to 3.108
      pci: Add PCI LRDT tag size and section size
      pci: Add large and small resource data type code
      pci: Add helper to find a VPD resource data type
      pci: Add VPD information field helper functions
      pci: Add helper to search for VPD keywords
      bnx2: Remove now useless VPD code
      tg3: Remove now useless VPD code

Michael Buesch (1):
      b43: Workaround circular locking in hw-tkip key update callback

Michael Chan (11):
      bnx2: Refine statistics code.
      bnx2: Save statistics during reset.
      bnx2: Check BNX2_FLAG_USING_MSIX flag when setting up MSIX.
      bnx2: Need to call cnic_setup_cnic_irq_info() after MTU change.
      bnx2: Adjust flow control water marks.
      bnx2: Allow user-specified multiple advertisement speed values.
      bnx2: Update firmwares and update version to 2.0.8.
      cnic: Fix panic in cnic_iscsi_nl_msg_recv() when device is down.
      cnic: Simplify route checking during iSCSI connection.
      cnic: Use union for the status blocks of different devices.
      cnic: Update version to 2.1.1.

Michael S. Tsirkin (10):
      tun: export underlying socket
      mm: export use_mm/unuse_mm to modules
      vhost_net: a kernel-level virtio server
      vhost: fix TUN=m VHOST_NET=y
      vhost-net: switch to smp barriers
      net: export attach/detach filter routines
      tun: socket filter support
      vhost: logging thinko fix
      vhost: initialize log eventfd context pointer
      vhost: fix get_user_pages_fast error handling

Mike Frysinger (1):
      netdev: bfin_mac: drop experimental markings on RMII support

Mike McCormack (7):
      sky2: Refactor sky2_get_regs into two functions
      sky2: Lock transmit queue while disabling device
      sky2: Factor out code to calculate packet sizes
      sky2: Allocate initial skbs in sky2_alloc_buffers
      sky2: Refactor sky2_up into two functions
      sky2: Refactor sky2_down into two functions
      sky2: Avoid down and up during sky2_reset

Milton Miller (1):
      ixgbe: prevent speculative processing of descriptors before ready

Ming Lei (2):
      mac80211: fix memory leak in ieee80211_send_probe_req
      ath9k: fix keycache leak in split tkip case

M√°rton N√©meth (2):
      8139too: make PCI device ids constant
      Bluetooth: Make USB device id constant

Nick Nunley (18):
      e1000: Report link status in ethtool when interface is down
      e1000: call pci_save_state after pci_restore_state
      igb: add support for wake-on-link
      igb: Report link status in ethtool when interface is down
      igb: ignore EEPROM APME check when shutting down serdes link
      igb: Power down link when interface is down
      igb: call pci_save_state after pci_restore_state
      igb: remove adaptive IFS from driver
      igb: cap interrupts at 20K per queue when in itr mode 3
      igb: only support SRRCTL_DROP_EN when using multiple queues
      igb: only read phy specific stats if in internal phy mode
      igb: inline igb_maybe_stop_tx
      igb: move gso_segs into buffer_info structure
      igb: minor type cleanups
      igb: remove unused vmolr value
      igb: use igb_free_q_vectors to cleanup failure in igb_alloc_q_vectors
      igb: change descriptor control thresholds
      igb: update tx DMA mapping error handling

Octavian Purdila (11):
      llc: use dev_hard_header
      llc: add support for LLC_OPT_PKTINFO
      llc: add support for SO_BINDTODEVICE
      llc: convert the socket list to RCU locking
      llc: optimize multicast delivery
      llc: use a device based hash table to speed up multicast delivery
      llc: replace the socket list with a local address based hash
      llc: convert llc_sap_list to RCU
      llc: fix SAP reference counting w.r.t. socket handling
      tcp: account SYN-ACK timeouts & retransmissions
      ipv4: allow warming up the ARP cache with request type gratuitous ARP

Oliver Hartkopp (3):
      can: Speed up CAN frame receiption by using ml_priv
      can: Unify droping of invalid tx skbs and netdev stats
      can: deny filterlist access on non-CAN interfaces

PJ Waskiewicz (1):
      ixgbe: Make descriptor ring allocations NUMA-aware

Pablo Neira Ayuso (1):
      netfilter: ctnetlink: fix creation of conntrack with helpers

Patrick McHardy (32):
      ipv4: ip_fragment: fix unbalanced rcu_read_unlock()
      netfilter: xt_hashlimit: fix race condition and simplify locking
      netfilter: ctnetlink: only assign helpers for matching protocols
      netfilter: add struct net * to target parameters
      netfilter: nf_conntrack: split up IPCT_STATUS event
      netfilter: ctnetlink: support selective event delivery
      netfilter: nf_conntrack: support conntrack templates
      netfilter: xtables: add CT target
      Merge branch 'master' of /repos/git/net-next-2.6
      netfilter: ctnetlink: add missing netlink attribute policies
      Merge branch 'master' of git://dev.medozas.de/linux
      netfilter: ctnetlink: dump expectation helper name
      netfilter: nf_conntrack: show helper and class in /proc/net/nf_conntrack_expect
      netfilter: nf_conntrack_sip: fix ct_sip_parse_request() REGISTER request parsing
      netfilter: nf_conntrack_sip: pass data offset to NAT functions
      netfilter: nf_conntrack_sip: add TCP support
      netfilter: nf_nat: support mangling a single TCP packet multiple times
      netfilter: nf_nat_sip: add TCP support
      netfilter: nf_conntrack_sip: add T.38 FAX support
      ipv6: fib: fix crash when changing large fib while dumping it
      netfilter: nf_conntrack: pass template to l4proto ->error() handler
      netfilter: nf_conntrack: add support for "conntrack zones"
      netfilter: ctnetlink: add zone support
      Merge branch 'ebt_config_compat_v4' of git://git.breakpoint.cc/fw/nf-next-2.6
      netfilter: nf_defrag_ipv4: fix compilation error with NF_CONNTRACK=n
      netfilter: restore POST_ROUTING hook in NF_HOOK_COND
      netfilter: nf_conntrack_reasm: properly handle packets fragmented into a single fragment
      rtnetlink: ignore NETDEV_PRE_UP notifier in rtnetlink_event()
      rtnetlink: handle rtnl_link netlink notifications manually
      dev: support deferring device flag change notifications
      rtnetlink: support specifying device flags on device creation
      bonding: fix device leak on error in bond_create()

Patrick Mullaney (1):
      macvlan: add GRO bit to features mask

Patrick Rabau (1):
      bnx2: Fix bug when saving statistics.

Pavel Cheblakov (1):
      can: add support for CAN interface cards based on the PLX90xx PCI bridge

Pavel Emelyanov (1):
      ipmr: remove useless checks from ipmr_device_event

Pavel Roskin (7):
      ath: make gcc check format arguments of ath_print(), fix all misuses
      ath9k: allocate string buffer in read_file_dma() by kmalloc()
      mac80211: reduce stack usage in sta_ht_capa_read()
      mac80211: reduce stack usage in sta_agg_status_read()
      ath9k: fix access to freed data on unload
      mwl8k: disable softirqs when accessing sta_notify_list
      Introduce PCMCIA_DEVICE_PROD_ID3

Peter Huewe (1):
      Bluetooth: Add __init/__exit macros to Marvell SDIO driver

Peter P Waskiewicz Jr (1):
      ethtool: Introduce n-tuple filter programming support

Peter Waskiewicz (6):
      ixgbe: Add support for the new ethtool n-tuple programming interface
      ixgbe: Bump driver version up
      ethtool: Fix filter addition when caching n-tuple filters
      ethtool: Move n-tuple capability check into set_flags
      ixgbe: Cleanup incorrect header comments
      ethtool: Add n-tuple string length to drvinfo and return it

Rafa≈Ç Mi≈Çecki (67):
      b43: LP-PHY: note and explain specs inconsistency
      b43: use standard fls for finding the most significant bit
      b43: add new SSB's core id for BCM4328
      b43: N-PHY: clean table init, check PHY rev
      b43: N-PHY: add shared memory offsets definitions
      b43: N-PHY: add needed struct definitions
      b43: N-PHY: add missing register definitions
      b43: N-PHY: add global variables to b43_phy_n struct
      b43: N-PHY: add various tables
      b43: N-PHY: update init code to match current specs
      b43: N-PHY: update CCA reset
      b43: N-PHY: split RSSI calibration into 2 functions (rev2, rev3)
      b43: N-PHY: add clip detection reading/writing and some classifier function
      b43: N-PHY: implement RSSI selection and offset scaling
      b43: N-PHY: add RSSI polling and setting 2055 (radio) VCM
      b43: N-PHY: RSSI calibration for rev < 3
      b43: N-PHY: implement PA overriding (RF control related)
      b43: N-PHY: add RSSI calibration restore
      b43: N-PHY: add function than forces (not) staying in carrier search
      b43: N-PHY: implement RX IQ coeffs
      b43: N-PHY: implement workaround for TX IQ
      b43: N-PHY: implement restoring general configuration
      b43: N-PHY: implement RX IQ estimation
      b43: N-PHY: implement calculating RX IQ comp
      b43: N-PHY: implement getting TX gains
      b43: N-PHY: add TX LP FBW (TX filter 40 related)
      b43: N-PHY: add RX radio cores calibration
      b43: N-PHY: update TX calibration ladder
      b43: N-PHY: implement calculating IQ gain params
      b43: N-PHY: add huge calculating TX IQ LO
      b43: N-PHY: add RX IQ calibrationi for rev < 3
      b43: N-PHY: implement TX power control coef setup
      b43: N-PHY: drop unused definition, uncomment needed call
      b43: N-PHY: implement RX PHY cleanup and setup
      b43: N-PHY: implement TX PHY cleanup and setup
      b43: N-PHY: implement MIMO config update
      b43: N-PHY: implement stopping playback
      b43: N-PHY: implement chain selection
      b43: N-PHY: move RF sequence declarations top, add missing calls
      b43: N-PHY: store seq mode for proper restoring (follow specs)
      b43: N-PHY: add writing one element tables
      b43: N-PHY: implement and add multi-dimensional table writing
      b43: N-PHY: implement and add reading one element tables
      b43: N-PHY: implement and add multi-dimensional table reading
      b43: N-PHY: silence warnings, add missing call
      b43: check band width
      b43: N-PHY: implement overriding RF control
      b43: N-PHY: add running samples
      b43: N-PHY: add setting power amplifier filters
      b43: N-PHY: add TX tone
      b43: N-PHY: fix one bit off in parsing RF Ctrl Override arguments
      b43: make cordic common (LP-PHY and N-PHY need it)
      b43: update cordic code to match current specs
      b43: N-PHY: use cordic to generate samples
      b43: N-PHY: update general workarounds
      b43: N-PHY: add workarounds for gain control
      b43: N-PHY: split RSSI selection into two per-PHY-revision functions
      b43: N-PHY: add RSSI selection for newer PHYs
      b43: N-PHY: fix Cal TX IQ LO for newer PHYs
      b43: N-PHY: add TX radio setup for newer PHYs
      b43: N-PHY: implement setting RF sequence
      b43: N-PHY: implement overriding RF control intc
      b43: N-PHY: prepare code for reapplying TX cal coeffs
      b43: N-PHY: save calibration for further restore
      b43: N-PHY: partly implement SPUR workaround
      b43: N-PHY: load generated samples
      b43: N-PHY: handle allocation fail in samples generation

Randy Dunlap (2):
      libertas/if_spi: needs linux/semaphore.h
      wireless: airo_cs build fixes

Reinette Chatre (10):
      iwlwifi: update copyright year to 2010
      iwlwifi: cleanup station adding code
      iwlwifi: make broadcast station addition generic
      iwlwifi: cleanup spectrum measurement command support
      iwlwifi: iwl_power_update_mode always hold mutex
      iwlwifi: fix scan race
      iwlwifi: reset card during probe
      iwl3945: remove STATUS macros from header
      iwlwifi: enable serialization of synchronous commands
      Revert "iwlwifi: Monitor and recover the aggregation TX flow failure"

Riccardo Ghetta (1):
      SiS190/191 half-duplex initialization fix

Rob Herring (1):
      fec: fix uninitialized rx buffer usage

Robert Hancock (1):
      r8169: enable 64-bit DMA by default for PCI Express devices (v2)

Roel Kluin (2):
      hisax: timeout off by one in waitrecmsg()
      mISDN: positive error return should be negative in mode_hfcmulti()

Roland Dreier (1):
      ethtool: Use explicit designated initializers for .cmd

Ron Mercer (17):
      qlge: Turn on RX header split based on platform.
      qlge: Add RX frame handlers for non-split frames.
      qlge: Add napi gro frags interface.
      qlge: Add data for firmware dump.
      qlge: Add basic firmware dump.
      qlge: Add probe regs to firmware dump.
      qlge: Add RAM dump to firmware dump.
      qlge: Add alternate function's reg dump to fw dump.
      qlge: Add serdes reg blocks dump to firmware dump.
      qlge: Add xgmac reg blocks to firwmare dump.
      qlge: Add module param to force firmware core dump.
      qlge: Move reset from eeh io_resume to slot_reset.
      qlge: Add check for eeh failure when closing device.
      qlge: Add watchdog timer.
      qlge: Fix dropping of large non-TCP/UDP frames.
      qlge: Fix bonding mac address bug.
      qlge: Fix occasional loopback test failure.

R√©mi Denis-Courmont (3):
      Phonet: zero-copy aligned GPRS RX
      Phonet: zero-copy GPRS TX
      Phonet: reject unsupported sendmsg/recvmsg flags

Samir Bellabes (1):
      genetlink: optimize ctrl_dumpfamily()

Samuel Ortiz (2):
      libertas: Set/clear WPA keys before the WEP ones
      iwlwifi: Send broadcast probe request only when asked to

Sarveshwar Bandi (3):
      be2net: implements ethtool function to read eeprom data.
      be2net: ethtool self test reorganization.
      be2net: Add link test to list of ethtool self tests.

Sathya Perla (6):
      be2net: implement EEH pci error recovery handlers
      be2net: a mini optimization in rx_compl_process() code
      be2net: don't rearm mcc cq when device is not open
      be2net: fix rx-path to ignore a flush completion
      be2net: implement pci shutdown handler
      be2net: free tx buffers when completions never arrive

Scott Feldman (6):
      enic: Bug fix: use safe queue shutdown in dev->stop
      enic: Bug fix: try harder to fill Rx ring on skb allocation failures
      enic: minimize pkt filter updates to firmware
      enic: Bug fix: align desc ring sizes to 32 descs
      enic: feature add: add ethtool -c/C support
      enic: whitespace cleanup; #define cleanup; more verbose err msg

Senthil Balasubramanian (2):
      ath9k: configure the beacon only if the STA is associated
      ath9k: Enable TIM timer interrupt only when needed.

Shan Wei (4):
      netfilter: nf_conntrack_ipv6: delete the redundant macro definitions
      IPv6: reassembly: replace magic number with macro definitions
      IP: Send an ICMP "Fragment Reassembly Timeout" message when enabling connection track
      IPv6: Delete redundant counter of IPSTATS_MIB_REASMFAILS

Shimada Hirofumi (1):
      p54usb: Add usbid for Corega CG-WLUSB2GT.

Shirley Ma (3):
      virtio: Add ability to detach unused buffers from vrings
      virtio_net: Defer skb allocation in receive path Date: Wed, 13 Jan 2010 12:53:38 -0800
      virtio_net: remove send queue

Simon Arlott (1):
      netfilter: xt_TCPMSS: SYN packets are allowed to contain data

Simon Horman (2):
      greth: fall through to common return statement on error
      IPVS: ip_vs_lblcr: use list headA

Simon Kagstrom (1):
      via-velocity: Enable scatter/gather IO by default

Sridhar Samudrala (2):
      packet: Add GSO/csum offload support.
      vhost-net: restart tx poll on sk_sndbuf full

Sriram (1):
      can:ti_hecc: Add pm hook-up

Sriramakrishnan (1):
      can: ti hecc module : add platform specific initialization callback.

Stanislaw Gruszka (2):
      airo: fix setting zero length WEP key
      iwlwifi: use dma_alloc_coherent

Stefan Seyfried (2):
      ar9170usb: add Sphairon Homelink 1202 USB ID
      zd1211rw: improve ejecting of fake CDROM

Stephen Coe (1):
      Bluetooth: Add SCO fallback for unsupported feature error

Stephen Hemminger (4):
      tcp: Generalized TTL Security Mechanism
      sky2: Flow control frames recorded as dropped packets
      IPv6: convert mc_lock to spinlock
      AF_UNIX: update locking comment

Stephen Rothwell (1):
      net: merge fixup for qlge_main

Steve Hodgson (3):
      sfc: Handle firmware assertion failure while resetting
      sfc: Enable autonegotiated flow-control by default if supported
      sfc: Add some missing bits to register self-test masks

Steven J. Magnani (2):
      ll_temac: Add support for V2 LLTEMAC core
      ll_temac: Fix MAC address configuration from userland

Sucheta Chakraborty (1):
      qlcnic: support LED blink for device identification

Sujith (12):
      ath9k: Clarify Interrupt mitigation
      ath9k: Remove ANI lock
      ath9k: Fix TX poll routine
      ath9k: Add a new file for GPIO
      ath9k: Add new file init.c
      ath9k: Cleanup Powersave flags
      ath9k: Cleanup init/deinit routines
      ath9k: Fix queue handling
      ath9k: Add debugfs file for RX errors
      ath9k: Fix monitor mode handling
      ath9k: Fix panic on driver load
      mac80211: Deny TX BA session requests during disassociation

Teemu Paasikivi (4):
      wl1271: Moved common IO functions from wl271_spi.c to wl1271_io.c
      wl1271: Renamed IO functions
      wl1271: Added IO reset and init functions
      wl1271: Added alloc and free hw functions

Tejun Heo (2):
      percpu: add __percpu sparse annotations to net
      percpu: add __percpu sparse annotations to net drivers

Thadeu Lima de Souza Cascardo (3):
      trivial: remove duplicated "from" in CAN USB EMS Kconfig help
      can: ems_usb: removed duplicated code setting local echo support
      nl80211: does not allow NEW_STATION and DEL_STATION for mesh

Tilman Schmidt (4):
      isdn: fix a few Kconfig imperfections
      gigaset: small documentation improvement
      bas_gigaset: collapse CR/LF at end of AT response
      gigaset: reduce syslog clutter

Tim Gardner (4):
      b43: Declare at least one real firmware file using MODULE_FIRMWARE.
      b43legacy: Declare all possible ucodeX.fw files
      netfilter: xt_recent: fix buffer overflow
      netfilter: xt_recent: fix false match

Tobias Klauser (1):
      ethoc: Use resource_size

Tomas Winkler (3):
      iwmc3200top: clean up fw_download
      iwmc3200top: cleanup log messages
      iwmc3200top: simplify imwct_tx

Trieu 'Andrew' Nguyen (3):
      iwlwifi: Tune radio to prevent unexpected behavior
      iwlwifi: Adjusting PLCP error threshold for 1000 NIC
      iwlwifi: Monitor and recover the aggregation TX flow failure

Tristram Ha (3):
      net: Micrel KSZ8841/2 PCI Ethernet driver
      net: Kconfig change for KSZ884X driver
      net: Makefile change for KSZ884X driver

Ulrich Weber (2):
      ipv6: Remove IPV6_ADDR_RESERVED
      ipv6: Use 1280 as min MTU for ipv6 forwarding

Ursula Braun (2):
      qeth: HiperSockets Network Traffic Analyzer
      qeth: avoid recovery during device online setting

Uwe Kleine-K√∂nig (1):
      net: move am79c961's probe function to .devinit.text

Vasanthakumar (1):
      mac80211: Don't call rate control when HW handles it

Vasanthakumar Thiagarajan (1):
      ath9k: Fix wifi disconnection when collocated bt scan is active

Venkata Mohan Reddy (1):
      ipvs: SCTP Trasport Loadbalancing Support

Vivek Natarajan (4):
      ath9k: Handle full sleep in ps_restore.
      mac80211: Reset dynamic ps timer in Rx path.
      mac80211: Retry null data frame for power save.
      ath9k: Enable IEEE80211_HW_REPORTS_TX_ACK_STATUS flag for ath9k.

Vladislav Zolotarov (8):
      bnx2x: Properly release allocated MSI-X/MSI vectors
      bnx2x: clean up in case of error in bnx2x_init_hw()
      bnx2x: Do not allow enabling LRO if disable_tpa=1
      bnx2x: fix in 57710 self-test
      bnx2x: FW 5.2.13
      bnx2x: Use firmware 5.2.13
      bnx2x: version number and date
      bnx2x: Tx barriers and locks

Wey-Yi Guy (35):
      iwlwifi: log CT_CARD_DISABLED flag
      iwlwifi: dump "Control and Status Register" when detect uCode HW/SW error
      iwlwifi: add continuous uCode event log capability
      iwlwifi: on-screen event log dump
      iwlwifi: remove extra error msg on sensitivity calibration
      iwlwifi: add IEEE80211_AMPDU_TX_OPERATIONAL
      iwlwifi: ucode statistics data structure update
      iwlwifi: remove obsoleted host command
      iwlwifi: fix bug in tx byte count table
      iwlwifi: fix clear statistics counter command
      iwlwifi: format and show statistics counter from uCode
      iwlwifi: add num_of_sos_stats to statistics counter
      iwlwifi: correct return code for log_event
      iwlwifi: set interrupt coalescing timer range and default
      iwlwifi: software w/a for h/w bug cause Rx bit get clear
      iwlwifi: display flowhandler register when sw error or on-demand
      iwlwifi: remove extra statistics request from debugfs
      iwlwifi: configure missed beacon threshold
      iwlwifi: add function to reset/tune radio if needed
      iwlwifi: Logic to control how frequent radio should be reset if needed
      iwlwifi: bit field description for BT Config command
      iwlwifi: module parameter to enable/disable bt co-exist
      iwlwifi: sysassert identifier change
      iwlwifi: update sensitivity calibration data for 6x00 series
      iwlwifi: update sensitivity calibration data for 5x00 series
      iwlwifi: update sensitivity calibration data for 1000 series
      mac80211: tear down all agg queues when restart/reconfig hw
      iwlwifi: clear all tx queues when firmware ready
      iwlwifi: multiple force reset mode
      iwlwifi: add debug function to reset/reload radio/firmware
      iwlwifi: check for aggregation frame and queue
      iwlwifi: remove unused op-code in PHY Calibration command
      iwlwifi: clear all the stop_queue flag after load firmware
      iwlwifi: separated time check for different type of force reset
      iwlwifi: add debugfs to monitor force reset parameters

Williams, Mitch A (6):
      pci: Add SR-IOV convenience functions and macros
      if_link: Add SR-IOV configuration methods
      net: Add netdev ops for SR-IOV configuration
      rtnetlink: Add VF config code to rtnetlink
      igb: support for VF configuration tools
      rtnetlink: clean up SR-IOV config interface

Wolfgang Grandegger (5):
      can: mscan: fix improper return if dlc < 8 in start_xmit function
      can: mscan-mpc5xxx: add support for the MPC512x processor
      powerpc/mpc5xxx: add OF platform binding doc for FSL MSCAN devices
      can: mscan-mpc5xxx: fix broken support for the MPC5200
      can: netlink support for bus-error reporting and counters

Yegor Yefremov (1):
      KS8695: Don't call netif_carrier_off() from ndo_stop()

Zhu Yi (4):
      wireless: add ieee80211_amsdu_to_8023s
      iwmc3200wifi: rx aggregation support
      iwlwifi: remove linux/utsrelease.h dependency
      mac80211: quit addba_resp_timer if Tx BA session is torn down

andrew hendry (2):
      X25: Fix x25_create errors for bad protocol and ENOBUFS
      X25: Dont let x25_bind use addresses containing characters

gregor kowski (1):
      mac80211 : fix a race with update_tkip_key

hartleys (15):
      drivers/atm/nicstar.c: use %pM to show MAC address
      drivers/net/ixgbe/ixgbe_common.c: use %pM to show MAC address
      drivers/atm/idt77252.c: use %pM to show MAC address
      drivers/firmware/iscsi_ibft.c: use %pM to show MAC address
      drivers/atm/fore200e.c: use %pM to show MAC address
      drivers/atm/lanai.c: use %pM to show MAC address
      drivers/media/dvb/dvb-core/dvb_net.c: use %pM to show MAC address
      drivers/net/vxge/vxge-main.c: use %pM to show MAC address
      drivers/net/atl1c/atl1c_main.c: use %pM to show MAC address
      drivers/net/wimax/i2400m/fw.c: use %pM to show MAC address
      drivers/net/atl1e/atl1e_main.c: use %pM to show MAC address
      drivers/net/qlge/qlge_main.c: use %pM to show MAC address
      drivers/net/wimax/i2400m/driver.c: use %pM to show MAC address
      drivers/net/defxx.c: use %pMF to show MAC address
      drivers/net/skfp/skfddi.c: use %pMF to show MAC address

jamal (6):
      xfrm: validate attributes
      xfrm: use proper kernel types
      xfrm: Flushing empty SAD generates false events
      xfrm: Flushing empty SPD generates false events
      xfrm: avoid spinlock in get_acqseq() used by xfrm user
      xfrm: Introduce LINUX_MIB_XFRMFWDHDRERROR

kirjanov@gmail.com (5):
      mv643xx_eth: fix missing validate_addr hook
      smsc911x: replace manual phy lookup.
      greth: some driver cleanups
      sis190: handle DMA mapping errors
      greth: convert to netdev_tx_t

laurent chavey (1):
      net: Add rtnetlink init_rcvwnd to set the TCP initial receive window

stephen hemminger (15):
      sky2: hand receive DMA mapping failures
      sky2: resume clocks
      sky2: disable ASF on Yukon Supreme
      sky2: receive checksum refactoring
      IPv6: keep permanent addresses on admin down
      IPv6: remove trivial nested _bh suffix
      sky2: fix sparse warning
      sky2: WoL changes
      sky2: dont enable PME legacy mode
      sky2: jumbo packet changes
      sky2: version 1.27
      seq_file: add RCU versions of new hlist/list iterators (v3)
      packet: convert socket list to RCU (v3)
      af_key: locking change
      netdev: use list_first_entry macro

 Documentation/DocBook/mac80211.tmpl                |    3 +-
 Documentation/feature-removal-schedule.txt         |   31 +-
 Documentation/isdn/INTERFACE.CAPI                  |    9 +-
 Documentation/isdn/README.gigaset                  |   10 +-
 Documentation/kernel-parameters.txt                |   10 +
 Documentation/networking/dccp.txt                  |    6 +-
 Documentation/networking/ip-sysctl.txt             |   58 +-
 Documentation/networking/ixgbevf.txt               |   90 +
 Documentation/networking/packet_mmap.txt           |    8 +-
 Documentation/networking/regulatory.txt            |   24 +
 Documentation/networking/tcp-thin.txt              |   47 +
 Documentation/powerpc/dts-bindings/fsl/can.txt     |   53 +
 Documentation/powerpc/dts-bindings/fsl/mpc5200.txt |    9 +-
 MAINTAINERS                                        |   30 +-
 arch/ia64/kvm/Kconfig                              |    1 +
 arch/powerpc/boot/dts/mpc8569mds.dts               |   47 +-
 arch/powerpc/configs/ppc64_defconfig               |    1 -
 arch/powerpc/configs/ps3_defconfig                 |    1 -
 arch/powerpc/kvm/Kconfig                           |    1 +
 arch/powerpc/platforms/85xx/mpc85xx_mds.c          |   24 +
 arch/s390/kvm/Kconfig                              |    1 +
 arch/sparc/kernel/sys_sparc32.c                    |    1 -
 arch/x86/kvm/Kconfig                               |    1 +
 arch/xtensa/platforms/iss/network.c                |    2 +-
 drivers/Makefile                                   |    1 +
 drivers/atm/fore200e.c                             |   11 +-
 drivers/atm/idt77252.c                             |    5 +-
 drivers/atm/lanai.c                                |   14 +-
 drivers/atm/nicstar.c                              |    4 +-
 drivers/bluetooth/ath3k.c                          |    2 +
 drivers/bluetooth/bcm203x.c                        |    2 +-
 drivers/bluetooth/bfusb.c                          |    2 +-
 drivers/bluetooth/bluecard_cs.c                    |    2 +-
 drivers/bluetooth/bpa10x.c                         |    2 +-
 drivers/bluetooth/bt3c_cs.c                        |    2 +-
 drivers/bluetooth/btmrvl_debugfs.c                 |   14 +-
 drivers/bluetooth/btmrvl_main.c                    |    2 +-
 drivers/bluetooth/btmrvl_sdio.c                    |    4 +-
 drivers/bluetooth/btsdio.c                         |    2 +-
 drivers/bluetooth/btuart_cs.c                      |    2 +-
 drivers/bluetooth/btusb.c                          |    2 +-
 drivers/bluetooth/dtl1_cs.c                        |    2 +-
 drivers/bluetooth/hci_ldisc.c                      |    2 +-
 drivers/bluetooth/hci_vhci.c                       |    2 +-
 drivers/firmware/iscsi_ibft.c                      |    6 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c              |   11 +-
 drivers/infiniband/hw/nes/nes_nic.c                |   85 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c     |    2 +-
 drivers/isdn/Kconfig                               |   43 +-
 drivers/isdn/capi/Kconfig                          |   16 +-
 drivers/isdn/capi/capi.c                           | 1203 +-
 drivers/isdn/capi/capidrv.c                        |  103 +-
 drivers/isdn/capi/capifs.c                         |  126 +-
 drivers/isdn/capi/capifs.h                         |   21 +-
 drivers/isdn/capi/kcapi.c                          |  817 +-
 drivers/isdn/capi/kcapi.h                          |   13 +-
 drivers/isdn/capi/kcapi_proc.c                     |   41 +-
 drivers/isdn/gigaset/asyncdata.c                   |    6 +-
 drivers/isdn/gigaset/bas-gigaset.c                 |   18 +-
 drivers/isdn/gigaset/capi.c                        |  106 +-
 drivers/isdn/gigaset/common.c                      |   49 +-
 drivers/isdn/gigaset/ev-layer.c                    |   63 +-
 drivers/isdn/gigaset/gigaset.h                     |   11 +-
 drivers/isdn/gigaset/i4l.c                         |   52 +-
 drivers/isdn/gigaset/interface.c                   |   12 +-
 drivers/isdn/gigaset/isocdata.c                    |   44 +-
 drivers/isdn/gigaset/proc.c                        |    2 -
 drivers/isdn/gigaset/usb-gigaset.c                 |    2 +-
 drivers/isdn/hardware/avm/avmcard.h                |    6 +-
 drivers/isdn/hardware/avm/b1.c                     |   54 +-
 drivers/isdn/hardware/avm/b1dma.c                  |   71 +-
 drivers/isdn/hardware/avm/b1isa.c                  |    2 +-
 drivers/isdn/hardware/avm/b1pci.c                  |    4 +-
 drivers/isdn/hardware/avm/b1pcmcia.c               |    2 +-
 drivers/isdn/hardware/avm/c4.c                     |   53 +-
 drivers/isdn/hardware/avm/t1isa.c                  |    2 +-
 drivers/isdn/hardware/avm/t1pci.c                  |    2 +-
 drivers/isdn/hardware/eicon/capimain.c             |   40 +-
 drivers/isdn/hardware/eicon/diva_didd.c            |   45 +-
 drivers/isdn/hardware/eicon/divasi.c               |   48 +-
 drivers/isdn/hardware/eicon/divasproc.c            |  198 +-
 drivers/isdn/hardware/mISDN/hfcmulti.c             |    2 +-
 drivers/isdn/hardware/mISDN/mISDNinfineon.c        |    1 +
 drivers/isdn/hardware/mISDN/w6692.c                |    2 +
 drivers/isdn/hisax/isar.c                          |    2 +-
 drivers/isdn/hysdn/hycapi.c                        |   56 +-
 drivers/isdn/i4l/Kconfig                           |    7 -
 drivers/media/dvb/dvb-core/dvb_net.c               |   14 +-
 drivers/message/i2o/i2o_proc.c                     |   11 +-
 drivers/misc/iwmc3200top/fw-download.c             |   50 +-
 drivers/misc/iwmc3200top/iwmc3200top.h             |    4 +-
 drivers/misc/iwmc3200top/log.h                     |   31 +-
 drivers/misc/iwmc3200top/main.c                    |   59 +-
 drivers/net/3c501.c                                |    2 +-
 drivers/net/3c505.c                                |   13 +-
 drivers/net/3c509.c                                |   10 +-
 drivers/net/3c515.c                                |    2 +-
 drivers/net/3c523.c                                |   13 +-
 drivers/net/3c527.c                                |   17 +-
 drivers/net/3c59x.c                                |    4 +-
 drivers/net/7990.c                                 |    6 +-
 drivers/net/8139cp.c                               |   81 +-
 drivers/net/8139too.c                              |  196 +-
 drivers/net/82596.c                                |   15 +-
 drivers/net/Kconfig                                |   82 +-
 drivers/net/Makefile                               |    5 +
 drivers/net/a2065.c                                |    6 +-
 drivers/net/acenic.c                               |    4 +-
 drivers/net/amd8111e.c                             |   21 +-
 drivers/net/amd8111e.h                             |    1 -
 drivers/net/appletalk/ltpc.c                       |    1 -
 drivers/net/arcnet/com20020-pci.c                  |    2 +-
 drivers/net/ariadne.c                              |    4 +-
 drivers/net/arm/am79c961a.c                        |   12 +-
 drivers/net/arm/at91_ether.c                       |    9 +-
 drivers/net/arm/ep93xx_eth.c                       |  140 +-
 drivers/net/arm/ether3.c                           |    2 +-
 drivers/net/arm/ixp4xx_eth.c                       |   13 +-
 drivers/net/arm/ks8695net.c                        |   23 +-
 drivers/net/arm/w90p910_ether.c                    |    8 +-
 drivers/net/at1700.c                               |    8 +-
 drivers/net/atarilance.c                           |    2 +-
 drivers/net/atl1c/atl1c.h                          |   11 +-
 drivers/net/atl1c/atl1c_ethtool.c                  |    2 +-
 drivers/net/atl1c/atl1c_hw.c                       |   83 +-
 drivers/net/atl1c/atl1c_hw.h                       |    5 +
 drivers/net/atl1c/atl1c_main.c                     |  126 +-
 drivers/net/atl1e/atl1e_hw.c                       |   23 +-
 drivers/net/atl1e/atl1e_main.c                     |  160 +-
 drivers/net/atl1e/atl1e_param.c                    |   35 +-
 drivers/net/atlx/atl1.c                            |    2 +-
 drivers/net/atlx/atl2.c                            |    4 +-
 drivers/net/atlx/atlx.c                            |    2 +-
 drivers/net/atp.c                                  |    9 +-
 drivers/net/au1000_eth.c                           |    7 +-
 drivers/net/b44.c                                  |   94 +-
 drivers/net/bcm63xx_enet.c                         |   15 +-
 drivers/net/benet/Kconfig                          |    4 +-
 drivers/net/benet/be.h                             |   19 +-
 drivers/net/benet/be_cmds.c                        |   94 +-
 drivers/net/benet/be_cmds.h                        |   27 +-
 drivers/net/benet/be_ethtool.c                     |   65 +-
 drivers/net/benet/be_hw.h                          |  121 +-
 drivers/net/benet/be_main.c                        |  495 +-
 drivers/net/bfin_mac.c                             |    8 +-
 drivers/net/bmac.c                                 |   13 +-
 drivers/net/bnx2.c                                 |  410 +-
 drivers/net/bnx2.h                                 |    3 +-
 drivers/net/bnx2x.h                                |   53 +-
 drivers/net/bnx2x_fw_defs.h                        |    7 +-
 drivers/net/bnx2x_hsi.h                            |   10 +-
 drivers/net/bnx2x_init_ops.h                       |   13 +-
 drivers/net/bnx2x_link.c                           |   21 +-
 drivers/net/bnx2x_main.c                           |  284 +-
 drivers/net/bonding/bond_main.c                    |   27 +-
 drivers/net/bonding/bonding.h                      |    1 -
 drivers/net/can/at91_can.c                         |    4 +
 drivers/net/can/bfin_can.c                         |    4 +
 drivers/net/can/dev.c                              |    8 +
 drivers/net/can/mcp251x.c                          |  426 +-
 drivers/net/can/mscan/Kconfig                      |    7 +-
 drivers/net/can/mscan/mpc5xxx_can.c                |  248 +-
 drivers/net/can/mscan/mscan.c                      |   58 +-
 drivers/net/can/mscan/mscan.h                      |   86 +-
 drivers/net/can/sja1000/Kconfig                    |   12 +
 drivers/net/can/sja1000/Makefile                   |    1 +
 drivers/net/can/sja1000/ems_pci.c                  |    2 +-
 drivers/net/can/sja1000/kvaser_pci.c               |    2 +-
 drivers/net/can/sja1000/plx_pci.c                  |  472 +
 drivers/net/can/sja1000/sja1000.c                  |   27 +-
 drivers/net/can/ti_hecc.c                          |   73 +-
 drivers/net/can/usb/Kconfig                        |    2 +-
 drivers/net/can/usb/ems_usb.c                      |    6 +-
 drivers/net/can/vcan.c                             |   12 +-
 drivers/net/cassini.c                              |  437 +-
 drivers/net/chelsio/common.h                       |   44 +-
 drivers/net/chelsio/cxgb2.c                        |   20 +-
 drivers/net/chelsio/espi.c                         |    4 +-
 drivers/net/chelsio/pm3393.c                       |   22 +-
 drivers/net/chelsio/sge.c                          |   12 +-
 drivers/net/chelsio/subr.c                         |   34 +-
 drivers/net/chelsio/vsc7326.c                      |   24 +-
 drivers/net/cnic.c                                 |  206 +-
 drivers/net/cnic.h                                 |   13 +-
 drivers/net/cnic_defs.h                            |    2 +-
 drivers/net/cnic_if.h                              |    6 +-
 drivers/net/cpmac.c                                |    4 +-
 drivers/net/cris/eth_v10.c                         |    8 +-
 drivers/net/cs89x0.c                               |    2 +-
 drivers/net/cxgb3/common.h                         |   28 +-
 drivers/net/cxgb3/cxgb3_main.c                     |   10 +-
 drivers/net/cxgb3/cxgb3_offload.c                  |    2 +-
 drivers/net/cxgb3/sge.c                            |   16 +-
 drivers/net/cxgb3/t3_hw.c                          |    3 +-
 drivers/net/cxgb3/xgmac.c                          |   18 +-
 drivers/net/davinci_emac.c                         |   12 +-
 drivers/net/de620.c                                |    2 +-
 drivers/net/declance.c                             |    6 +-
 drivers/net/defxx.c                                |   24 +-
 drivers/net/depca.c                                |    5 +-
 drivers/net/dl2k.c                                 |    9 +-
 drivers/net/dl2k.h                                 |    2 +-
 drivers/net/dm9000.c                               |    5 +-
 drivers/net/e100.c                                 |   18 +-
 drivers/net/e1000/e1000.h                          |    1 +
 drivers/net/e1000/e1000_ethtool.c                  |   19 +-
 drivers/net/e1000/e1000_main.c                     |   46 +-
 drivers/net/e1000e/82571.c                         |   68 +-
 drivers/net/e1000e/defines.h                       |    2 +
 drivers/net/e1000e/e1000.h                         |   19 +-
 drivers/net/e1000e/es2lan.c                        |   32 +-
 drivers/net/e1000e/ethtool.c                       |    2 +-
 drivers/net/e1000e/hw.h                            |   12 +-
 drivers/net/e1000e/ich8lan.c                       |    1 +
 drivers/net/e1000e/lib.c                           |  230 +-
 drivers/net/e1000e/netdev.c                        |   45 +-
 drivers/net/eepro.c                                |   21 +-
 drivers/net/eexpress.c                             |   22 +-
 drivers/net/ehea/ehea_main.c                       |    9 +-
 drivers/net/enc28j60.c                             |    2 +-
 drivers/net/enic/enic.h                            |    5 +-
 drivers/net/enic/enic_main.c                       |  208 +-
 drivers/net/enic/enic_res.c                        |   16 +-
 drivers/net/enic/vnic_dev.c                        |    1 -
 drivers/net/enic/vnic_enet.h                       |    5 +
 drivers/net/enic/vnic_intr.c                       |    8 +-
 drivers/net/enic/vnic_intr.h                       |    3 +
 drivers/net/enic/vnic_nic.h                        |   12 +-
 drivers/net/epic100.c                              |    9 +-
 drivers/net/eth16i.c                               |    2 +-
 drivers/net/ethoc.c                                |   14 +-
 drivers/net/ewrk3.c                                |    5 +-
 drivers/net/fealnx.c                               |    8 +-
 drivers/net/fec.c                                  |   84 +-
 drivers/net/fec_mpc52xx.c                          |    5 +-
 drivers/net/forcedeth.c                            |    8 +-
 drivers/net/fs_enet/Kconfig                        |   10 +-
 drivers/net/fs_enet/fs_enet-main.c                 |   93 +-
 drivers/net/fs_enet/fs_enet.h                      |   49 +-
 drivers/net/fs_enet/mac-fcc.c                      |    9 +-
 drivers/net/fs_enet/mac-fec.c                      |   62 +-
 drivers/net/fs_enet/mac-scc.c                      |   13 +-
 drivers/net/fs_enet/mii-fec.c                      |    4 +-
 drivers/net/gianfar.c                              |    4 +-
 drivers/net/greth.c                                | 1634 +++
 drivers/net/greth.h                                |  143 +
 drivers/net/hamachi.c                              |   13 +-
 drivers/net/hp100.c                                |   13 +-
 drivers/net/ibm_newemac/core.c                     |    8 +-
 drivers/net/ibmlana.c                              |    2 +-
 drivers/net/ibmveth.c                              |    8 +-
 drivers/net/igb/e1000_82575.c                      |   65 +-
 drivers/net/igb/e1000_82575.h                      |    5 +
 drivers/net/igb/e1000_defines.h                    |    7 +-
 drivers/net/igb/e1000_hw.h                         |    7 -
 drivers/net/igb/e1000_mac.c                        |   70 -
 drivers/net/igb/e1000_mac.h                        |    2 -
 drivers/net/igb/e1000_phy.c                        |   35 +
 drivers/net/igb/e1000_phy.h                        |    2 +
 drivers/net/igb/e1000_regs.h                       |    1 +
 drivers/net/igb/igb.h                              |   16 +-
 drivers/net/igb/igb_ethtool.c                      |   93 +-
 drivers/net/igb/igb_main.c                         |  414 +-
 drivers/net/igbvf/netdev.c                         |   31 +-
 drivers/net/ioc3-eth.c                             |   11 +-
 drivers/net/ipg.c                                  |   13 +-
 drivers/net/irda/Kconfig                           |   10 +
 drivers/net/irda/Makefile                          |    1 +
 drivers/net/irda/donauboe.c                        |    2 +-
 drivers/net/irda/sh_sir.c                          |  823 ++
 drivers/net/irda/via-ircc.c                        |    2 +-
 drivers/net/irda/vlsi_ir.c                         |    2 +-
 drivers/net/isa-skeleton.c                         |  718 --
 drivers/net/iseries_veth.c                         |    8 +-
 drivers/net/ixgb/ixgb.h                            |   11 +-
 drivers/net/ixgb/ixgb_main.c                       |  104 +-
 drivers/net/ixgbe/Makefile                         |    3 +-
 drivers/net/ixgbe/ixgbe.h                          |   54 +-
 drivers/net/ixgbe/ixgbe_82599.c                    |  233 +-
 drivers/net/ixgbe/ixgbe_common.c                   |   19 +-
 drivers/net/ixgbe/ixgbe_common.h                   |    2 +-
 drivers/net/ixgbe/ixgbe_ethtool.c                  |  195 +-
 drivers/net/ixgbe/ixgbe_fcoe.c                     |    4 +-
 drivers/net/ixgbe/ixgbe_main.c                     |  676 +-
 drivers/net/ixgbe/ixgbe_mbx.c                      |  479 +
 drivers/net/ixgbe/ixgbe_mbx.h                      |   96 +
 drivers/net/ixgbe/ixgbe_sriov.c                    |  362 +
 drivers/net/ixgbe/ixgbe_sriov.h                    |   47 +
 drivers/net/ixgbe/ixgbe_type.h                     |   66 +-
 drivers/net/ixgbevf/Makefile                       |   38 +
 drivers/net/ixgbevf/defines.h                      |  292 +
 drivers/net/ixgbevf/ethtool.c                      |  716 ++
 drivers/net/ixgbevf/ixgbevf.h                      |  318 +
 drivers/net/ixgbevf/ixgbevf_main.c                 | 3578 ++++++
 drivers/net/ixgbevf/mbx.c                          |  341 +
 drivers/net/ixgbevf/mbx.h                          |  100 +
 drivers/net/ixgbevf/regs.h                         |   85 +
 drivers/net/ixgbevf/vf.c                           |  387 +
 drivers/net/ixgbevf/vf.h                           |  168 +
 drivers/net/jme.c                                  |   62 +-
 drivers/net/jme.h                                  |   41 +-
 drivers/net/korina.c                               |   10 +-
 drivers/net/ks8851.c                               |    7 +-
 drivers/net/ks8851_mll.c                           |    7 +-
 drivers/net/ksz884x.c                              | 7335 +++++++++++
 drivers/net/lance.c                                |    2 +-
 drivers/net/lib82596.c                             |   21 +-
 drivers/net/lib8390.c                              |   15 +-
 drivers/net/ll_temac_main.c                        |   25 +-
 drivers/net/loopback.c                             |   16 +-
 drivers/net/lp486e.c                               |   16 +-
 drivers/net/mac8390.c                              |  632 +-
 drivers/net/mac89x0.c                              |    4 +-
 drivers/net/macb.c                                 |   38 +-
 drivers/net/mace.c                                 |   11 +-
 drivers/net/macmace.c                              |   12 +-
 drivers/net/macvlan.c                              |  117 +-
 drivers/net/macvtap.c                              |  803 ++
 drivers/net/meth.c                                 |    3 -
 drivers/net/mlx4/en_rx.c                           |    8 +-
 drivers/net/mlx4/main.c                            |    2 +-
 drivers/net/mv643xx_eth.c                          |    6 +-
 drivers/net/myri10ge/myri10ge.c                    |  198 +-
 drivers/net/myri_sbus.c                            |    6 +-
 drivers/net/natsemi.c                              |    8 +-
 drivers/net/ne2k-pci.c                             |    2 +-
 drivers/net/netxen/Makefile                        |    2 +-
 drivers/net/netxen/netxen_nic.h                    |    8 +-
 drivers/net/netxen/netxen_nic_ctx.c                |    2 +-
 drivers/net/netxen/netxen_nic_ethtool.c            |    2 +-
 drivers/net/netxen/netxen_nic_hdr.h                |    5 +-
 drivers/net/netxen/netxen_nic_hw.c                 |   46 +-
 drivers/net/netxen/netxen_nic_hw.h                 |    2 +-
 drivers/net/netxen/netxen_nic_init.c               |    5 +-
 drivers/net/netxen/netxen_nic_main.c               |  213 +-
 drivers/net/ni5010.c                               |    3 +-
 drivers/net/ni52.c                                 |   10 +-
 drivers/net/ni65.c                                 |    2 +-
 drivers/net/niu.c                                  |  699 +-
 drivers/net/ns83820.c                              |    4 +-
 drivers/net/octeon/octeon_mgmt.c                   |   18 +-
 drivers/net/pasemi_mac.c                           |    2 +-
 drivers/net/pci-skeleton.c                         | 1029 +-
 drivers/net/pcmcia/3c574_cs.c                      |    2 +-
 drivers/net/pcmcia/3c589_cs.c                      |    2 +-
 drivers/net/pcmcia/axnet_cs.c                      |   11 +-
 drivers/net/pcmcia/fmvj18x_cs.c                    |   10 +-
 drivers/net/pcmcia/nmclan_cs.c                     |   18 +-
 drivers/net/pcmcia/smc91c92_cs.c                   |   35 +-
 drivers/net/pcmcia/xirc2ps_cs.c                    |   88 +-
 drivers/net/pcnet32.c                              |  507 +-
 drivers/net/phy/broadcom.c                         |    5 +-
 drivers/net/phy/marvell.c                          |   38 +
 drivers/net/phy/phy_device.c                       |   16 +
 drivers/net/phy/smsc.c                             |   21 +-
 drivers/net/ppp_generic.c                          |  122 +-
 drivers/net/ps3_gelic_net.c                        |    4 +-
 drivers/net/ps3_gelic_wireless.c                   |  149 +-
 drivers/net/qla3xxx.c                              |    3 +-
 drivers/net/qlcnic/Makefile                        |    8 +
 drivers/net/qlcnic/qlcnic.h                        | 1126 ++
 drivers/net/qlcnic/qlcnic_ctx.c                    |  534 +
 drivers/net/qlcnic/qlcnic_ethtool.c                | 1015 ++
 drivers/net/qlcnic/qlcnic_hdr.h                    |  937 ++
 drivers/net/qlcnic/qlcnic_hw.c                     | 1274 ++
 drivers/net/qlcnic/qlcnic_init.c                   | 1541 +++
 drivers/net/qlcnic/qlcnic_main.c                   | 2720 +++++
 drivers/net/qlge/qlge.h                            |  446 +-
 drivers/net/qlge/qlge_dbg.c                        | 1183 ++-
 drivers/net/qlge/qlge_ethtool.c                    |   56 +-
 drivers/net/qlge/qlge_main.c                       | 1189 ++-
 drivers/net/qlge/qlge_mpi.c                        |  340 +-
 drivers/net/r6040.c                                |   37 +-
 drivers/net/r8169.c                                |  166 +-
 drivers/net/rrunner.c                              |    2 +-
 drivers/net/s2io.c                                 |   13 +-
 drivers/net/sb1250-mac.c                           |    6 +-
 drivers/net/sc92031.c                              |    6 +-
 drivers/net/sfc/efx.c                              |    8 +-
 drivers/net/sfc/efx.h                              |    2 -
 drivers/net/sfc/ethtool.c                          |   10 +-
 drivers/net/sfc/falcon.c                           |    6 +-
 drivers/net/sfc/mcdi.c                             |  109 +-
 drivers/net/sfc/mcdi.h                             |    1 +
 drivers/net/sfc/mcdi_pcol.h                        |  202 +-
 drivers/net/sfc/mcdi_phy.c                         |   36 +-
 drivers/net/sfc/mdio_10g.c                         |   24 +
 drivers/net/sfc/mdio_10g.h                         |    3 +
 drivers/net/sfc/net_driver.h                       |   17 +-
 drivers/net/sfc/nic.c                              |   13 +-
 drivers/net/sfc/qt202x_phy.c                       |    1 +
 drivers/net/sfc/selftest.c                         |   42 +-
 drivers/net/sfc/selftest.h                         |    4 +-
 drivers/net/sfc/siena.c                            |   16 +-
 drivers/net/sfc/tenxpress.c                        |    2 +
 drivers/net/sgiseeq.c                              |    2 +-
 drivers/net/sh_eth.c                               |   10 +-
 drivers/net/sis190.c                               |  198 +-
 drivers/net/sis900.c                               |    9 +-
 drivers/net/skfp/skfddi.c                          |   35 +-
 drivers/net/skge.c                                 |  218 +-
 drivers/net/sky2.c                                 |  726 +-
 drivers/net/sky2.h                                 |   10 +-
 drivers/net/smc911x.c                              |   14 +-
 drivers/net/smc9194.c                              |   12 +-
 drivers/net/smc91x.c                               |   11 +-
 drivers/net/smsc911x.c                             |   53 +-
 drivers/net/smsc9420.c                             |    9 +-
 drivers/net/sonic.c                                |   13 +-
 drivers/net/spider_net.c                           |    4 +-
 drivers/net/starfire.c                             |   13 +-
 drivers/net/stmmac/Kconfig                         |    8 +-
 drivers/net/stmmac/Makefile                        |    5 +-
 drivers/net/stmmac/common.h                        |  279 +-
 drivers/net/stmmac/descs.h                         |    4 +-
 drivers/net/stmmac/{mac100.c => dwmac100.c}        |  212 +-
 drivers/net/stmmac/{mac100.h => dwmac100.h}        |    0
 drivers/net/stmmac/{gmac.h => dwmac1000.h}         |   18 +-
 drivers/net/stmmac/dwmac1000_core.c                |  243 +
 drivers/net/stmmac/{gmac.c => dwmac1000_dma.c}     |  351 +-
 drivers/net/stmmac/dwmac_dma.h                     |  107 +
 drivers/net/stmmac/dwmac_lib.c                     |  263 +
 drivers/net/stmmac/stmmac.h                        |   28 +-
 drivers/net/stmmac/stmmac_ethtool.c                |   11 +-
 drivers/net/stmmac/stmmac_main.c                   |  436 +-
 drivers/net/stmmac/stmmac_mdio.c                   |   11 +-
 drivers/net/sun3_82586.c                           |   10 +-
 drivers/net/sun3lance.c                            |    2 +-
 drivers/net/sunbmac.c                              |    7 +-
 drivers/net/sundance.c                             |    9 +-
 drivers/net/sungem.c                               |   14 +-
 drivers/net/sunhme.c                               |   26 +-
 drivers/net/sunlance.c                             |    6 +-
 drivers/net/sunqe.c                                |   11 +-
 drivers/net/sunvnet.c                              |    7 +-
 drivers/net/tc35815.c                              |   27 +-
 drivers/net/tehuti.c                               |  159 +-
 drivers/net/tehuti.h                               |   30 +-
 drivers/net/tg3.c                                  |  965 +-
 drivers/net/tg3.h                                  |  162 +-
 drivers/net/tlan.c                                 |   37 +-
 drivers/net/tlan.h                                 |    3 -
 drivers/net/tokenring/3c359.c                      |    7 +-
 drivers/net/tokenring/abyss.c                      |    2 +-
 drivers/net/tokenring/ibmtr.c                      |    4 +-
 drivers/net/tokenring/lanstreamer.c                |    6 +-
 drivers/net/tokenring/olympic.c                    |    7 +-
 drivers/net/tokenring/tms380tr.c                   |    8 +-
 drivers/net/tokenring/tmspci.c                     |    2 +-
 drivers/net/tsi108_eth.c                           |   22 +-
 drivers/net/tulip/21142.c                          |   76 +-
 drivers/net/tulip/de2104x.c                        |  163 +-
 drivers/net/tulip/de4x5.c                          |   16 +-
 drivers/net/tulip/dmfe.c                           |  103 +-
 drivers/net/tulip/eeprom.c                         |   47 +-
 drivers/net/tulip/interrupt.c                      |  100 +-
 drivers/net/tulip/media.c                          |   74 +-
 drivers/net/tulip/pnic.c                           |   33 +-
 drivers/net/tulip/pnic2.c                          |   59 +-
 drivers/net/tulip/timer.c                          |   52 +-
 drivers/net/tulip/tulip_core.c                     |  187 +-
 drivers/net/tulip/uli526x.c                        |   64 +-
 drivers/net/tulip/winbond-840.c                    |  186 +-
 drivers/net/tulip/xircom_cb.c                      |   46 +-
 drivers/net/tun.c                                  |  127 +-
 drivers/net/typhoon.c                              |  253 +-
 drivers/net/ucc_geth.c                             |   29 +-
 drivers/net/usb/asix.c                             |  117 +-
 drivers/net/usb/catc.c                             |    9 +-
 drivers/net/usb/cdc_eem.c                          |   10 +-
 drivers/net/usb/cdc_ether.c                        |   22 +-
 drivers/net/usb/dm9601.c                           |   59 +-
 drivers/net/usb/int51x1.c                          |   17 +-
 drivers/net/usb/kaweth.c                           |    2 +-
 drivers/net/usb/mcs7830.c                          |  256 +-
 drivers/net/usb/net1080.c                          |  109 +-
 drivers/net/usb/pegasus.c                          |  172 +-
 drivers/net/usb/rndis_host.c                       |   24 +-
 drivers/net/usb/rtl8150.c                          |    9 +-
 drivers/net/usb/smsc95xx.c                         |  245 +-
 drivers/net/usb/usbnet.c                           |  238 +-
 drivers/net/veth.c                                 |   19 +-
 drivers/net/via-rhine.c                            |    9 +-
 drivers/net/via-velocity.c                         |   16 +-
 drivers/net/virtio_net.c                           |  473 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |   19 +-
 drivers/net/vxge/vxge-main.c                       |   16 +-
 drivers/net/wan/dscc4.c                            |    2 +-
 drivers/net/wan/farsync.c                          |    2 +-
 drivers/net/wan/lmc/lmc_main.c                     |    2 +-
 drivers/net/wan/pc300_drv.c                        |    2 +-
 drivers/net/wan/pc300too.c                         |    2 +-
 drivers/net/wan/pci200syn.c                        |    2 +-
 drivers/net/wan/wanxl.c                            |    2 +-
 drivers/net/wimax/i2400m/driver.c                  |   17 +-
 drivers/net/wimax/i2400m/fw.c                      |   11 +-
 drivers/net/wireless/Kconfig                       |    1 +
 drivers/net/wireless/adm8211.c                     |   27 +-
 drivers/net/wireless/airo.c                        |   39 +-
 drivers/net/wireless/at76c50x-usb.c                |    6 +-
 drivers/net/wireless/ath/ar9170/ar9170.h           |   17 +-
 drivers/net/wireless/ath/ar9170/hw.h               |    1 +
 drivers/net/wireless/ath/ar9170/mac.c              |    2 +-
 drivers/net/wireless/ath/ar9170/main.c             |  193 +-
 drivers/net/wireless/ath/ar9170/usb.c              |    2 +
 drivers/net/wireless/ath/ath.h                     |    1 -
 drivers/net/wireless/ath/ath5k/ath5k.h             |   27 +-
 drivers/net/wireless/ath/ath5k/base.c              |  108 +-
 drivers/net/wireless/ath/ath5k/base.h              |    1 -
 drivers/net/wireless/ath/ath5k/led.c               |    2 +
 drivers/net/wireless/ath/ath5k/pcu.c               |  121 +-
 drivers/net/wireless/ath/ath5k/qcu.c               |   25 +-
 drivers/net/wireless/ath/ath5k/reset.c             |   14 +-
 drivers/net/wireless/ath/ath9k/Makefile            |    2 +
 drivers/net/wireless/ath/ath9k/ahb.c               |   31 +-
 drivers/net/wireless/ath/ath9k/ath9k.h             |   80 +-
 drivers/net/wireless/ath/ath9k/beacon.c            |   30 +-
 drivers/net/wireless/ath/ath9k/btcoex.h            |    2 +
 drivers/net/wireless/ath/ath9k/debug.c             |  199 +-
 drivers/net/wireless/ath/ath9k/debug.h             |   32 +
 drivers/net/wireless/ath/ath9k/gpio.c              |  442 +
 drivers/net/wireless/ath/ath9k/hw.c                |  178 +-
 drivers/net/wireless/ath/ath9k/hw.h                |   10 +-
 drivers/net/wireless/ath/ath9k/init.c              |  863 ++
 drivers/net/wireless/ath/ath9k/mac.h               |   34 +
 drivers/net/wireless/ath/ath9k/main.c              | 1451 +--
 drivers/net/wireless/ath/ath9k/pci.c               |   75 +-
 drivers/net/wireless/ath/ath9k/phy.h               |    3 +
 drivers/net/wireless/ath/ath9k/rc.c                |   27 +-
 drivers/net/wireless/ath/ath9k/rc.h                |    4 +
 drivers/net/wireless/ath/ath9k/recv.c              |   40 +-
 drivers/net/wireless/ath/ath9k/reg.h               |    6 +-
 drivers/net/wireless/ath/ath9k/virtual.c           |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |   62 +-
 drivers/net/wireless/ath/debug.h                   |    8 +-
 drivers/net/wireless/ath/regd.c                    |    5 +-
 drivers/net/wireless/atmel_pci.c                   |    2 +-
 drivers/net/wireless/b43/Kconfig                   |    6 +-
 drivers/net/wireless/b43/Makefile                  |    2 +-
 drivers/net/wireless/b43/b43.h                     |   20 +-
 drivers/net/wireless/b43/dma.c                     |   19 -
 drivers/net/wireless/b43/dma.h                     |    5 -
 drivers/net/wireless/b43/main.c                    |   98 +-
 drivers/net/wireless/b43/phy_common.c              |   45 +
 drivers/net/wireless/b43/phy_common.h              |   10 +
 drivers/net/wireless/b43/phy_lp.c                  |   76 +-
 drivers/net/wireless/b43/phy_n.c                   | 3033 +++++-
 drivers/net/wireless/b43/phy_n.h                   |   98 +-
 drivers/net/wireless/b43/pio.c                     |   17 -
 drivers/net/wireless/b43/pio.h                     |   45 -
 drivers/net/wireless/b43/tables_nphy.c             |  744 ++-
 drivers/net/wireless/b43/tables_nphy.h             |  100 +-
 drivers/net/wireless/b43legacy/dma.c               |   20 -
 drivers/net/wireless/b43legacy/dma.h               |   10 -
 drivers/net/wireless/b43legacy/leds.h              |    2 +-
 drivers/net/wireless/b43legacy/main.c              |   61 +-
 drivers/net/wireless/b43legacy/pio.c               |   13 -
 drivers/net/wireless/b43legacy/pio.h               |   11 -
 drivers/net/wireless/hostap/hostap_cs.c            |   17 +-
 drivers/net/wireless/hostap/hostap_hw.c            |    9 +
 drivers/net/wireless/hostap/hostap_pci.c           |    2 +-
 drivers/net/wireless/hostap/hostap_plx.c           |    2 +-
 drivers/net/wireless/ipw2x00/ipw2100.c             |    2 +-
 drivers/net/wireless/ipw2x00/ipw2200.c             |    2 +-
 drivers/net/wireless/iwlwifi/Kconfig               |   14 +-
 drivers/net/wireless/iwlwifi/Makefile              |    3 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c            |   84 +-
 drivers/net/wireless/iwlwifi/iwl-3945-fh.h         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-3945-led.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945-led.h        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c            |   25 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h            |   25 +-
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c            |   14 +-
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c            |  125 +-
 drivers/net/wireless/iwlwifi/iwl-6000-hw.h         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c            |  116 +-
 drivers/net/wireless/iwlwifi/iwl-agn-led.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-led.h         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c          |   17 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c             |  354 +-
 drivers/net/wireless/iwlwifi/iwl-calib.c           |   11 +-
 drivers/net/wireless/iwlwifi/iwl-calib.h           |    4 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h        |   68 +-
 drivers/net/wireless/iwlwifi/iwl-core.c            |  388 +-
 drivers/net/wireless/iwlwifi/iwl-core.h            |   55 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h             |    6 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h           |   60 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c         | 1461 ++-
 drivers/net/wireless/iwlwifi/iwl-dev.h             |   97 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.c        |    2 +
 drivers/net/wireless/iwlwifi/iwl-devtrace.h        |   44 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.c          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-fh.h              |   23 +-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c            |   17 +-
 drivers/net/wireless/iwlwifi/iwl-helpers.h         |    9 +-
 drivers/net/wireless/iwlwifi/iwl-io.h              |    2 +-
 drivers/net/wireless/iwlwifi/iwl-led.c             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-led.h             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-power.c           |    9 +-
 drivers/net/wireless/iwlwifi/iwl-power.h           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h            |    4 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c              |  136 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c            |  258 +-
 drivers/net/wireless/iwlwifi/iwl-spectrum.c        |  198 -
 drivers/net/wireless/iwlwifi/iwl-spectrum.h        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c             |  150 +-
 drivers/net/wireless/iwlwifi/iwl-sta.h             |    3 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c              |   77 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c        |  197 +-
 drivers/net/wireless/iwmc3200wifi/iwm.h            |    2 +-
 drivers/net/wireless/iwmc3200wifi/rx.c             |   71 +-
 drivers/net/wireless/libertas/Kconfig              |    6 +
 drivers/net/wireless/libertas/Makefile             |    2 +-
 drivers/net/wireless/libertas/assoc.c              |   95 +-
 drivers/net/wireless/libertas/cmd.c                |   22 +-
 drivers/net/wireless/libertas/cmd.h                |   12 -
 drivers/net/wireless/libertas/cmdresp.c            |   21 +-
 drivers/net/wireless/libertas/defs.h               |    7 -
 drivers/net/wireless/libertas/dev.h                |    8 +-
 drivers/net/wireless/libertas/ethtool.c            |    2 +
 drivers/net/wireless/libertas/if_spi.c             |    1 +
 drivers/net/wireless/libertas/main.c               |   81 +-
 drivers/net/wireless/libertas/mesh.c               |   29 +-
 drivers/net/wireless/libertas/mesh.h               |   32 +
 drivers/net/wireless/libertas/scan.c               |    2 +-
 drivers/net/wireless/libertas/tx.c                 |    2 +-
 drivers/net/wireless/libertas/wext.c               |   26 +-
 drivers/net/wireless/libertas_tf/main.c            |   13 +-
 drivers/net/wireless/mac80211_hwsim.c              |  198 +-
 drivers/net/wireless/mwl8k.c                       | 2084 ++--
 drivers/net/wireless/orinoco/hw.c                  |   22 +-
 drivers/net/wireless/orinoco/hw.h                  |    2 +-
 drivers/net/wireless/orinoco/main.c                |    7 +-
 drivers/net/wireless/orinoco/orinoco_cs.c          |    9 +-
 drivers/net/wireless/orinoco/orinoco_nortel.c      |    2 +-
 drivers/net/wireless/orinoco/orinoco_pci.c         |    2 +-
 drivers/net/wireless/orinoco/orinoco_plx.c         |    2 +-
 drivers/net/wireless/orinoco/orinoco_tmd.c         |    2 +-
 drivers/net/wireless/p54/main.c                    |   51 +-
 drivers/net/wireless/p54/p54.h                     |    8 +-
 drivers/net/wireless/p54/p54pci.c                  |   76 +-
 drivers/net/wireless/p54/p54pci.h                  |    6 +-
 drivers/net/wireless/p54/p54usb.c                  |    2 +
 drivers/net/wireless/p54/txrx.c                    |    4 +-
 drivers/net/wireless/prism54/islpci_hotplug.c      |    2 +-
 drivers/net/wireless/ray_cs.c                      |   10 +-
 drivers/net/wireless/rndis_wlan.c                  |  388 +-
 drivers/net/wireless/rt2x00/Kconfig                |   71 +-
 drivers/net/wireless/rt2x00/rt2400pci.c            |   12 +-
 drivers/net/wireless/rt2x00/rt2400pci.h            |    1 +
 drivers/net/wireless/rt2x00/rt2500pci.c            |   48 +-
 drivers/net/wireless/rt2x00/rt2500pci.h            |    1 +
 drivers/net/wireless/rt2x00/rt2500usb.c            |   39 +-
 drivers/net/wireless/rt2x00/rt2800.h               |   14 +-
 drivers/net/wireless/rt2x00/rt2800lib.c            |  203 +-
 drivers/net/wireless/rt2x00/rt2800lib.h            |    3 +-
 drivers/net/wireless/rt2x00/rt2800pci.c            |  104 +-
 drivers/net/wireless/rt2x00/rt2800usb.c            |  373 +-
 drivers/net/wireless/rt2x00/rt2800usb.h            |   90 +-
 drivers/net/wireless/rt2x00/rt2x00.h               |   96 +-
 drivers/net/wireless/rt2x00/rt2x00debug.c          |    4 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |   10 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |   42 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c            |   10 +-
 drivers/net/wireless/rt2x00/rt2x00pci.h            |    1 +
 drivers/net/wireless/rt2x00/rt2x00queue.c          |   79 +-
 drivers/net/wireless/rt2x00/rt2x00queue.h          |    5 +-
 drivers/net/wireless/rt2x00/rt2x00soc.c            |   11 +-
 drivers/net/wireless/rt2x00/rt2x00soc.h            |   10 +-
 drivers/net/wireless/rt2x00/rt61pci.c              |   46 +-
 drivers/net/wireless/rt2x00/rt61pci.h              |    9 +
 drivers/net/wireless/rt2x00/rt73usb.c              |   41 +-
 drivers/net/wireless/rt2x00/rt73usb.h              |    2 +
 drivers/net/wireless/rtl818x/rtl8180.h             |    1 -
 drivers/net/wireless/rtl818x/rtl8180_dev.c         |   37 +-
 drivers/net/wireless/rtl818x/rtl8187.h             |    2 +-
 drivers/net/wireless/rtl818x/rtl8187_dev.c         |   26 +-
 drivers/net/wireless/rtl818x/rtl8187_leds.c        |    6 +-
 drivers/net/wireless/rtl818x/rtl8187_leds.h        |    2 +-
 drivers/net/wireless/wl12xx/Makefile               |    4 +-
 drivers/net/wireless/wl12xx/wl1251.h               |    4 +-
 drivers/net/wireless/wl12xx/wl1251_acx.c           |   69 +
 drivers/net/wireless/wl12xx/wl1251_acx.h           |   87 +
 drivers/net/wireless/wl12xx/wl1251_cmd.c           |   83 +
 drivers/net/wireless/wl12xx/wl1251_cmd.h           |   22 +-
 drivers/net/wireless/wl12xx/wl1251_debugfs.c       |   23 +
 drivers/net/wireless/wl12xx/wl1251_init.c          |    5 +
 drivers/net/wireless/wl12xx/wl1251_init.h          |   47 +
 drivers/net/wireless/wl12xx/wl1251_main.c          |  375 +-
 drivers/net/wireless/wl12xx/wl1251_ps.c            |    9 +-
 drivers/net/wireless/wl12xx/wl1251_rx.c            |    2 +-
 drivers/net/wireless/wl12xx/wl1251_tx.c            |    9 +-
 drivers/net/wireless/wl12xx/wl1251_tx.h            |   17 +
 drivers/net/wireless/wl12xx/wl1271.h               |   67 +-
 drivers/net/wireless/wl12xx/wl1271_acx.c           |  196 +-
 drivers/net/wireless/wl12xx/wl1271_acx.h           |   50 +-
 drivers/net/wireless/wl12xx/wl1271_boot.c          |  102 +-
 drivers/net/wireless/wl12xx/wl1271_cmd.c           |  137 +-
 drivers/net/wireless/wl12xx/wl1271_cmd.h           |   67 +-
 drivers/net/wireless/wl12xx/wl1271_conf.h          |  174 +-
 drivers/net/wireless/wl12xx/wl1271_debugfs.c       |   62 +
 drivers/net/wireless/wl12xx/wl1271_event.c         |   68 +-
 drivers/net/wireless/wl12xx/wl1271_event.h         |    2 +-
 drivers/net/wireless/wl12xx/wl1271_init.c          |   50 +-
 drivers/net/wireless/wl12xx/wl1271_init.h          |    4 +
 drivers/net/wireless/wl12xx/wl1271_io.c            |  213 +
 drivers/net/wireless/wl12xx/wl1271_io.h            |   68 +
 drivers/net/wireless/wl12xx/wl1271_main.c          |  823 +-
 drivers/net/wireless/wl12xx/wl1271_ps.c            |   37 +-
 drivers/net/wireless/wl12xx/wl1271_ps.h            |    3 +-
 drivers/net/wireless/wl12xx/wl1271_reg.h           |   99 -
 drivers/net/wireless/wl12xx/wl1271_rx.c            |   11 +-
 drivers/net/wireless/wl12xx/wl1271_spi.c           |  158 -
 drivers/net/wireless/wl12xx/wl1271_spi.h           |   30 -
 drivers/net/wireless/wl12xx/wl1271_testmode.c      |  283 +
 drivers/net/wireless/wl12xx/wl1271_testmode.h      |   31 +
 drivers/net/wireless/wl12xx/wl1271_tx.c            |   71 +-
 drivers/net/wireless/wl12xx/wl1271_tx.h            |   36 +
 drivers/net/wireless/zd1201.c                      |   14 +-
 drivers/net/wireless/zd1211rw/zd_mac.c             |   10 +-
 drivers/net/wireless/zd1211rw/zd_usb.c             |   14 +-
 drivers/net/xilinx_emaclite.c                      |  384 +-
 drivers/net/yellowfin.c                            |  173 +-
 drivers/net/znet.c                                 |    3 +-
 drivers/pci/Makefile                               |    2 +-
 drivers/pci/iov.c                                  |   15 +
 drivers/pci/quirks.c                               |    1 +
 drivers/pci/vpd.c                                  |   61 +
 drivers/s390/net/qeth_core.h                       |    5 +-
 drivers/s390/net/qeth_core_main.c                  |  169 +-
 drivers/s390/net/qeth_core_mpc.h                   |   44 +-
 drivers/s390/net/qeth_core_sys.c                   |   14 +-
 drivers/s390/net/qeth_l2_main.c                    |   30 +-
 drivers/s390/net/qeth_l3.h                         |    2 +
 drivers/s390/net/qeth_l3_main.c                    |  176 +-
 drivers/s390/net/qeth_l3_sys.c                     |   56 +
 drivers/ssb/driver_chipcommon_pmu.c                |    7 +
 drivers/ssb/driver_mipscore.c                      |    5 +-
 drivers/ssb/ssb_private.h                          |    4 +-
 drivers/staging/arlan/arlan-main.c                 |   25 +-
 drivers/staging/et131x/et131x_netdev.c             |   19 +-
 drivers/staging/netwave/netwave_cs.c               |    8 +-
 drivers/staging/octeon/ethernet.c                  |    2 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211.h    |    9 -
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |   24 +-
 drivers/staging/rtl8187se/r8180_core.c             |    4 +-
 drivers/staging/rtl8192su/ieee80211/ieee80211.h    |   12 +-
 .../staging/rtl8192su/ieee80211/ieee80211_r8192s.h |    2 +-
 drivers/staging/rtl8192su/ieee80211/ieee80211_rx.c |   18 +-
 .../rtl8192su/ieee80211/ieee80211_softmac.c        |   38 +-
 .../staging/rtl8192su/ieee80211/rtl819x_BAProc.c   |    4 +-
 drivers/staging/rtl8192su/r8192U_core.c            |    4 +-
 drivers/staging/slicoss/slicoss.c                  |   16 +-
 drivers/staging/vt6655/device_main.c               |    8 +-
 drivers/staging/vt6656/main_usb.c                  |    8 +-
 drivers/staging/wavelan/wavelan.c                  |   14 +-
 drivers/staging/wavelan/wavelan_cs.c               |   20 +-
 drivers/staging/wlags49_h2/wl_netdev.c             |   30 +-
 drivers/vhost/Kconfig                              |   11 +
 drivers/vhost/Makefile                             |    2 +
 drivers/vhost/net.c                                |  669 +
 drivers/vhost/vhost.c                              | 1104 ++
 drivers/vhost/vhost.h                              |  161 +
 firmware/Makefile                                  |   10 +-
 firmware/WHENCE                                    |    6 +-
 firmware/bnx2/bnx2-mips-06-5.0.0.j3.fw.ihex        | 5841 ---------
 firmware/bnx2/bnx2-mips-06-5.0.0.j6.fw.ihex        | 5908 +++++++++
 ....0.j3.fw.ihex => bnx2-mips-09-5.0.0.j9.fw.ihex} | 4519 ++++----
 firmware/bnx2/bnx2-rv2p-09-5.0.0.j10.fw.ihex       |  462 +
 firmware/bnx2/bnx2-rv2p-09-5.0.0.j3.fw.ihex        |  462 -
 firmware/bnx2/bnx2-rv2p-09ax-5.0.0.j10.fw.ihex     |  499 +
 firmware/bnx2/bnx2-rv2p-09ax-5.0.0.j3.fw.ihex      |  498 -
 firmware/bnx2x-e1-5.2.13.0.fw.ihex                 |10191 ++++++++++++++++
 firmware/bnx2x-e1h-5.2.13.0.fw.ihex                |12849 ++++++++++++++++++++
 fs/seq_file.c                                      |  130 +-
 include/linux/Kbuild                               |    1 +
 include/linux/brcmphy.h                            |   11 +
 include/linux/can/dev.h                            |   18 +
 include/linux/can/netlink.h                        |   17 +-
 include/linux/can/platform/ti_hecc.h               |    8 +-
 include/linux/ethtool.h                            |   51 +
 include/linux/icmpv6.h                             |    3 +-
 include/linux/ieee80211.h                          |  108 +-
 include/linux/if_link.h                            |   30 +
 include/linux/if_macvlan.h                         |   84 +
 include/linux/if_packet.h                          |    1 +
 include/linux/if_tun.h                             |   17 +
 include/linux/igmp.h                               |    2 +
 include/linux/in.h                                 |    2 +
 include/linux/inetdevice.h                         |   43 +-
 include/linux/isdn/capilli.h                       |    8 +-
 include/linux/kernelcapi.h                         |   17 +-
 include/linux/llc.h                                |    7 +
 include/linux/miscdevice.h                         |    1 +
 include/linux/net.h                                |    4 +
 include/linux/netdevice.h                          |  186 +-
 include/linux/netfilter.h                          |   63 +-
 include/linux/netfilter/Kbuild                     |    1 +
 include/linux/netfilter/nf_conntrack_common.h      |   22 +
 include/linux/netfilter/nf_conntrack_sip.h         |   19 +-
 include/linux/netfilter/nfnetlink.h                |    8 +-
 include/linux/netfilter/nfnetlink_conntrack.h      |    2 +
 include/linux/netfilter/x_tables.h                 |   70 +-
 include/linux/netfilter/xt_CT.h                    |   17 +
 include/linux/netfilter_arp/arp_tables.h           |   11 +-
 include/linux/netfilter_bridge/ebtables.h          |    2 +-
 include/linux/netfilter_ipv4/ip_tables.h           |   18 +-
 include/linux/netfilter_ipv6/ip6_tables.h          |   17 +-
 include/linux/netpoll.h                            |   11 +-
 include/linux/nl80211.h                            |  145 +-
 include/linux/pci.h                                |   99 +
 include/linux/phy.h                                |    1 +
 include/linux/rculist.h                            |    5 +
 include/linux/rtnetlink.h                          |    2 +
 include/linux/seq_file.h                           |   18 +
 include/linux/skbuff.h                             |   17 +-
 include/linux/snmp.h                               |    1 +
 include/linux/stmmac.h                             |   53 +
 include/linux/sysctl.h                             |    4 -
 include/linux/tcp.h                                |    7 +-
 include/linux/usb/usbnet.h                         |   21 -
 include/linux/vhost.h                              |  130 +
 include/linux/xfrm.h                               |   12 +-
 include/net/bluetooth/hci.h                        |    6 +-
 include/net/bluetooth/hci_core.h                   |    5 +-
 include/net/cfg80211.h                             |  287 +-
 include/net/dst.h                                  |    2 -
 include/net/icmp.h                                 |    2 +-
 include/net/ieee80211_radiotap.h                   |    4 +
 include/net/if_inet6.h                             |    2 +-
 include/net/inet_sock.h                            |    4 +-
 include/net/ip.h                                   |    9 +-
 include/net/ip6_fib.h                              |    4 +-
 include/net/ip_vs.h                                |   38 +-
 include/net/ipcomp.h                               |    2 +-
 include/net/ipv6.h                                 |    8 +-
 include/net/llc.h                                  |   39 +-
 include/net/llc_conn.h                             |    2 +
 include/net/mac80211.h                             |  386 +-
 include/net/neighbour.h                            |    3 +-
 include/net/net_namespace.h                        |    2 +
 include/net/netfilter/nf_conntrack.h               |   12 +-
 include/net/netfilter/nf_conntrack_core.h          |    3 +-
 include/net/netfilter/nf_conntrack_ecache.h        |   58 +-
 include/net/netfilter/nf_conntrack_expect.h        |   16 +-
 include/net/netfilter/nf_conntrack_extend.h        |    2 +
 include/net/netfilter/nf_conntrack_helper.h        |    8 +-
 include/net/netfilter/nf_conntrack_l4proto.h       |    4 +-
 include/net/netfilter/nf_conntrack_zones.h         |   25 +
 include/net/netfilter/nf_nat_helper.h              |   32 +-
 include/net/netlink.h                              |    2 +-
 include/net/netns/conntrack.h                      |    2 +-
 include/net/netns/core.h                           |    2 +-
 include/net/netns/ipv4.h                           |    2 +
 include/net/netns/ipv6.h                           |    2 +
 include/net/netns/packet.h                         |    4 +-
 include/net/phonet/pep.h                           |    3 +
 include/net/pkt_sched.h                            |    1 +
 include/net/regulatory.h                           |    1 +
 include/net/request_sock.h                         |    2 +
 include/net/route.h                                |    2 +-
 include/net/rtnetlink.h                            |    2 +
 include/net/sch_generic.h                          |   19 +
 include/net/snmp.h                                 |   14 +-
 include/net/sock.h                                 |   17 +-
 include/net/tcp.h                                  |   36 +-
 include/net/xfrm.h                                 |   82 +-
 include/pcmcia/device_id.h                         |    5 +
 kernel/taskstats.c                                 |    6 +-
 lib/vsprintf.c                                     |   48 +-
 mm/mmu_context.c                                   |    3 +
 net/8021q/vlan.c                                   |    4 +-
 net/8021q/vlan.h                                   |    2 +-
 net/8021q/vlan_core.c                              |    2 +
 net/8021q/vlan_dev.c                               |    9 +-
 net/8021q/vlanproc.c                               |    2 +-
 net/appletalk/atalk_proc.c                         |   30 +-
 net/atm/addr.c                                     |    2 +-
 net/atm/atm_misc.c                                 |   40 +-
 net/atm/atm_sysfs.c                                |   27 +-
 net/atm/br2684.c                                   |   90 +-
 net/atm/clip.c                                     |   86 +-
 net/atm/common.c                                   |  386 +-
 net/atm/ioctl.c                                    |  196 +-
 net/atm/lec.c                                      |  599 +-
 net/atm/mpc.c                                      |  540 +-
 net/atm/mpoa_caches.c                              |  190 +-
 net/atm/mpoa_proc.c                                |   89 +-
 net/atm/pppoatm.c                                  |   28 +-
 net/atm/proc.c                                     |   83 +-
 net/atm/pvc.c                                      |   43 +-
 net/atm/raw.c                                      |   26 +-
 net/atm/resources.c                                |  418 +-
 net/atm/signaling.c                                |  219 +-
 net/atm/svc.c                                      |  258 +-
 net/ax25/af_ax25.c                                 |   18 +-
 net/ax25/ax25_uid.c                                |   25 +-
 net/bluetooth/bnep/netdev.c                        |    6 +-
 net/bluetooth/cmtp/capi.c                          |   37 +-
 net/bluetooth/hci_core.c                           |   12 +-
 net/bluetooth/hci_event.c                          |    1 +
 net/bluetooth/hci_sock.c                           |    4 +-
 net/bluetooth/hci_sysfs.c                          |  122 +-
 net/bridge/Kconfig                                 |   13 +
 net/bridge/Makefile                                |    2 +
 net/bridge/br_device.c                             |   23 +-
 net/bridge/br_forward.c                            |  150 +-
 net/bridge/br_if.c                                 |    8 +-
 net/bridge/br_input.c                              |   39 +-
 net/bridge/br_multicast.c                          | 1304 ++
 net/bridge/br_private.h                            |  169 +-
 net/bridge/br_stp.c                                |    2 +
 net/bridge/br_stp_if.c                             |    1 +
 net/bridge/br_sysfs_br.c                           |  281 +
 net/bridge/br_sysfs_if.c                           |   18 +
 net/bridge/netfilter/ebt_802_3.c                   |    2 +-
 net/bridge/netfilter/ebt_arp.c                     |    2 +-
 net/bridge/netfilter/ebt_arpreply.c                |    2 +-
 net/bridge/netfilter/ebt_dnat.c                    |    2 +-
 net/bridge/netfilter/ebt_ip.c                      |    2 +-
 net/bridge/netfilter/ebt_ip6.c                     |    2 +-
 net/bridge/netfilter/ebt_limit.c                   |   18 +-
 net/bridge/netfilter/ebt_log.c                     |    2 +-
 net/bridge/netfilter/ebt_mark.c                    |   33 +-
 net/bridge/netfilter/ebt_mark_m.c                  |   39 +-
 net/bridge/netfilter/ebt_nflog.c                   |    2 +-
 net/bridge/netfilter/ebt_pkttype.c                 |    2 +-
 net/bridge/netfilter/ebt_redirect.c                |    2 +-
 net/bridge/netfilter/ebt_snat.c                    |    2 +-
 net/bridge/netfilter/ebt_stp.c                     |    2 +-
 net/bridge/netfilter/ebt_ulog.c                    |    2 +-
 net/bridge/netfilter/ebt_vlan.c                    |    2 +-
 net/bridge/netfilter/ebtable_broute.c              |    2 +-
 net/bridge/netfilter/ebtable_filter.c              |    2 +-
 net/bridge/netfilter/ebtable_nat.c                 |    2 +-
 net/bridge/netfilter/ebtables.c                    | 1241 ++-
 net/can/af_can.c                                   |  124 +-
 net/can/af_can.h                                   |    4 +-
 net/can/proc.c                                     |   93 +-
 net/core/dev.c                                     |  284 +-
 net/core/dev_mcast.c                               |    2 +
 net/core/drop_monitor.c                            |    1 -
 net/core/ethtool.c                                 |  386 +-
 net/core/fib_rules.c                               |    2 +-
 net/core/filter.c                                  |    2 +
 net/core/neighbour.c                               |   18 +-
 net/core/netpoll.c                                 |  169 +-
 net/core/pktgen.c                                  |    3 +-
 net/core/rtnetlink.c                               |  127 +-
 net/core/scm.c                                     |    2 +
 net/core/sock.c                                    |   16 +-
 net/dcb/dcbnl.c                                    |   16 +-
 net/dccp/ccid.c                                    |    9 +-
 net/dccp/ipv4.c                                    |    4 +-
 net/dccp/ipv6.c                                    |    4 +-
 net/dccp/proto.c                                   |    7 +-
 net/ethernet/eth.c                                 |    6 +-
 net/ipv4/af_inet.c                                 |   46 +-
 net/ipv4/ah4.c                                     |    2 +-
 net/ipv4/arp.c                                     |   58 +-
 net/ipv4/devinet.c                                 |   30 +-
 net/ipv4/esp4.c                                    |    2 +-
 net/ipv4/fib_frontend.c                            |    4 +-
 net/ipv4/fib_semantics.c                           |   80 +-
 net/ipv4/icmp.c                                    |    2 +-
 net/ipv4/igmp.c                                    |   87 +-
 net/ipv4/inet_connection_sock.c                    |    2 +
 net/ipv4/ip_fragment.c                             |   39 +-
 net/ipv4/ip_gre.c                                  |   25 +-
 net/ipv4/ip_sockglue.c                             |   14 +-
 net/ipv4/ipcomp.c                                  |   11 +-
 net/ipv4/ipip.c                                    |   20 +-
 net/ipv4/ipmr.c                                    |    3 -
 net/ipv4/netfilter/arp_tables.c                    |  386 +-
 net/ipv4/netfilter/arptable_filter.c               |   95 +-
 net/ipv4/netfilter/ip_tables.c                     |  557 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c                 |   14 +-
 net/ipv4/netfilter/ipt_ULOG.c                      |    4 +-
 net/ipv4/netfilter/iptable_filter.c                |  124 +-
 net/ipv4/netfilter/iptable_mangle.c                |  166 +-
 net/ipv4/netfilter/iptable_raw.c                   |   96 +-
 net/ipv4/netfilter/iptable_security.c              |  117 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c     |    3 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c       |   11 +-
 net/ipv4/netfilter/nf_defrag_ipv4.c                |   19 +-
 net/ipv4/netfilter/nf_nat_core.c                   |   24 +-
 net/ipv4/netfilter/nf_nat_ftp.c                    |  105 +-
 net/ipv4/netfilter/nf_nat_helper.c                 |   39 +-
 net/ipv4/netfilter/nf_nat_pptp.c                   |    3 +-
 net/ipv4/netfilter/nf_nat_rule.c                   |   41 +-
 net/ipv4/netfilter/nf_nat_sip.c                    |  154 +-
 net/ipv4/netfilter/nf_nat_snmp_basic.c             |   31 +-
 net/ipv4/proc.c                                    |   32 +-
 net/ipv4/route.c                                   |    9 +-
 net/ipv4/syncookies.c                              |    3 +-
 net/ipv4/sysctl_net_ipv4.c                         |   14 +
 net/ipv4/tcp.c                                     |   65 +-
 net/ipv4/tcp_input.c                               |   12 +
 net/ipv4/tcp_ipv4.c                                |   25 +-
 net/ipv4/tcp_output.c                              |   22 +-
 net/ipv4/tcp_timer.c                               |   27 +-
 net/ipv4/udp.c                                     |   19 +-
 net/ipv4/udplite.c                                 |    4 +-
 net/ipv6/addrconf.c                                |   94 +-
 net/ipv6/addrconf_core.c                           |    2 +-
 net/ipv6/af_inet6.c                                |   32 +-
 net/ipv6/ah6.c                                     |    2 +-
 net/ipv6/anycast.c                                 |    2 +-
 net/ipv6/esp6.c                                    |    2 +-
 net/ipv6/exthdrs.c                                 |    2 +-
 net/ipv6/fib6_rules.c                              |    4 +-
 net/ipv6/icmp.c                                    |   12 +-
 net/ipv6/ip6_fib.c                                 |   52 +-
 net/ipv6/ip6_flowlabel.c                           |    9 +-
 net/ipv6/ip6_input.c                               |    3 +-
 net/ipv6/ip6_output.c                              |   21 +-
 net/ipv6/ip6_tunnel.c                              |   43 +-
 net/ipv6/ipcomp6.c                                 |   15 +-
 net/ipv6/mcast.c                                   |   32 +-
 net/ipv6/mip6.c                                    |    2 +-
 net/ipv6/ndisc.c                                   |    7 +-
 net/ipv6/netfilter/ip6_tables.c                    |  559 +-
 net/ipv6/netfilter/ip6t_REJECT.c                   |    2 +-
 net/ipv6/netfilter/ip6table_filter.c               |  113 +-
 net/ipv6/netfilter/ip6table_mangle.c               |  141 +-
 net/ipv6/netfilter/ip6table_raw.c                  |   86 +-
 net/ipv6/netfilter/ip6table_security.c             |  109 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c     |   14 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c     |   11 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c            |   15 +-
 net/ipv6/proc.c                                    |   39 +-
 net/ipv6/raw.c                                     |    4 +-
 net/ipv6/reassembly.c                              |   27 +-
 net/ipv6/route.c                                   |   12 +-
 net/ipv6/sit.c                                     |   25 +-
 net/ipv6/syncookies.c                              |    3 +-
 net/ipv6/sysctl_net_ipv6.c                         |    4 +-
 net/ipv6/tcp_ipv6.c                                |   22 +-
 net/ipv6/tunnel6.c                                 |    4 +-
 net/ipv6/udp.c                                     |   22 +-
 net/ipv6/udplite.c                                 |    4 +-
 net/ipv6/xfrm6_input.c                             |    2 +-
 net/ipv6/xfrm6_output.c                            |    2 +-
 net/ipv6/xfrm6_tunnel.c                            |  194 +-
 net/ipx/ipx_proc.c                                 |   90 +-
 net/irda/ircomm/ircomm_tty.c                       |    6 -
 net/irda/irlan/irlan_common.c                      |   28 +-
 net/irda/irlan/irlan_eth.c                         |    5 +-
 net/irda/irnetlink.c                               |    2 +-
 net/key/af_key.c                                   |  160 +-
 net/llc/af_llc.c                                   |   64 +-
 net/llc/llc_conn.c                                 |  143 +-
 net/llc/llc_core.c                                 |   53 +-
 net/llc/llc_output.c                               |   45 +-
 net/llc/llc_proc.c                                 |   69 +-
 net/llc/llc_sap.c                                  |  111 +-
 net/mac80211/Kconfig                               |   12 -
 net/mac80211/Makefile                              |    4 +-
 net/mac80211/agg-rx.c                              |   15 +-
 net/mac80211/agg-tx.c                              |   38 +-
 net/mac80211/cfg.c                                 |  198 +-
 net/mac80211/debugfs.c                             |  127 +
 net/mac80211/debugfs_key.c                         |    2 +-
 net/mac80211/debugfs_netdev.c                      |  212 +-
 net/mac80211/debugfs_netdev.h                      |    9 +-
 net/mac80211/debugfs_sta.c                         |   88 +-
 net/mac80211/driver-ops.h                          |  169 +-
 net/mac80211/driver-trace.h                        |  174 +-
 net/mac80211/ht.c                                  |   53 +-
 net/mac80211/ibss.c                                |  125 +-
 net/mac80211/ieee80211_i.h                         |  215 +-
 net/mac80211/iface.c                               |  108 +-
 net/mac80211/key.c                                 |   10 +-
 net/mac80211/key.h                                 |    8 +-
 net/mac80211/main.c                                |   74 +-
 net/mac80211/mesh.c                                |    6 +-
 net/mac80211/mesh_hwmp.c                           |   20 +-
 net/mac80211/mesh_pathtbl.c                        |    6 +-
 net/mac80211/mesh_plink.c                          |   23 +-
 net/mac80211/mlme.c                                | 1317 +--
 net/mac80211/offchannel.c                          |  170 +
 net/mac80211/pm.c                                  |   18 +-
 net/mac80211/rate.c                                |   90 +-
 net/mac80211/rate.h                                |   14 +-
 net/mac80211/rc80211_pid_algo.c                    |    8 +-
 net/mac80211/rx.c                                  |  473 +-
 net/mac80211/scan.c                                |  249 +-
 net/mac80211/spectmgmt.c                           |    4 +-
 net/mac80211/sta_info.c                            |  777 +-
 net/mac80211/sta_info.h                            |   68 +-
 net/mac80211/status.c                              |  107 +-
 net/mac80211/tkip.c                                |   47 +-
 net/mac80211/tx.c                                  |  376 +-
 net/mac80211/util.c                                |  319 +-
 net/mac80211/wep.c                                 |   17 +-
 net/mac80211/wme.c                                 |    2 +-
 net/mac80211/work.c                                | 1100 ++
 net/mac80211/wpa.c                                 |   57 +-
 net/netfilter/Kconfig                              |   25 +
 net/netfilter/Makefile                             |    1 +
 net/netfilter/ipvs/Kconfig                         |   11 +
 net/netfilter/ipvs/Makefile                        |    1 +
 net/netfilter/ipvs/ip_vs_conn.c                    |   42 +-
 net/netfilter/ipvs/ip_vs_core.c                    |   67 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |   13 +-
 net/netfilter/ipvs/ip_vs_ftp.c                     |    2 +-
 net/netfilter/ipvs/ip_vs_lblcr.c                   |   44 +-
 net/netfilter/ipvs/ip_vs_proto.c                   |    3 +
 net/netfilter/ipvs/ip_vs_proto_sctp.c              | 1183 ++
 net/netfilter/ipvs/ip_vs_sync.c                    |   14 +
 net/netfilter/ipvs/ip_vs_xmit.c                    |   10 +-
 net/netfilter/nf_conntrack_core.c                  |  164 +-
 net/netfilter/nf_conntrack_expect.c                |   31 +-
 net/netfilter/nf_conntrack_extend.c                |    1 -
 net/netfilter/nf_conntrack_h323_main.c             |    3 +-
 net/netfilter/nf_conntrack_helper.c                |   44 +-
 net/netfilter/nf_conntrack_netlink.c               |  230 +-
 net/netfilter/nf_conntrack_pptp.c                  |   14 +-
 net/netfilter/nf_conntrack_proto_dccp.c            |    5 +-
 net/netfilter/nf_conntrack_proto_gre.c             |    2 +-
 net/netfilter/nf_conntrack_proto_sctp.c            |    2 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |    4 +-
 net/netfilter/nf_conntrack_proto_udp.c             |    6 +-
 net/netfilter/nf_conntrack_proto_udplite.c         |    4 +-
 net/netfilter/nf_conntrack_sip.c                   |  330 +-
 net/netfilter/nf_conntrack_standalone.c            |    6 +
 net/netfilter/nf_queue.c                           |    2 +-
 net/netfilter/nfnetlink.c                          |   65 +-
 net/netfilter/nfnetlink_log.c                      |    5 +-
 net/netfilter/nfnetlink_queue.c                    |    7 +-
 net/netfilter/x_tables.c                           |   80 +-
 net/netfilter/xt_CT.c                              |  164 +
 net/netfilter/xt_NFQUEUE.c                         |    6 +-
 net/netfilter/xt_RATEEST.c                         |    7 +-
 net/netfilter/xt_TCPMSS.c                          |   30 +-
 net/netfilter/xt_connlimit.c                       |   27 +-
 net/netfilter/xt_hashlimit.c                       |  215 +-
 net/netfilter/xt_limit.c                           |    4 +-
 net/netfilter/xt_osf.c                             |    4 +-
 net/netfilter/xt_recent.c                          |  168 +-
 net/netfilter/xt_repldata.h                        |   35 +
 net/netlabel/netlabel_domainhash.c                 |    1 -
 net/netlabel/netlabel_unlabeled.c                  |    3 -
 net/netlink/af_netlink.c                           |    7 +-
 net/netlink/genetlink.c                            |    4 +-
 net/netrom/af_netrom.c                             |   21 +-
 net/netrom/nr_route.c                              |   53 +-
 net/packet/Kconfig                                 |   10 -
 net/packet/af_packet.c                             |  300 +-
 net/phonet/datagram.c                              |    6 +-
 net/phonet/pep-gprs.c                              |    4 +-
 net/phonet/pep.c                                   |   29 +-
 net/phonet/pn_dev.c                                |    4 +-
 net/rds/tcp_connect.c                              |    7 +-
 net/rds/tcp_listen.c                               |    6 +-
 net/rds/tcp_send.c                                 |    4 +-
 net/rose/af_rose.c                                 |   22 +-
 net/sched/sch_api.c                                |    1 +
 net/sched/sch_fifo.c                               |   34 +
 net/sctp/bind_addr.c                               |    1 -
 net/sctp/ipv6.c                                    |    1 -
 net/sctp/proc.c                                    |    4 +-
 net/sctp/protocol.c                                |    6 +-
 net/sctp/socket.c                                  |    2 +-
 net/sunrpc/rpc_pipe.c                              |    2 +-
 net/sysctl_net.c                                   |    4 +-
 net/tipc/Kconfig                                   |   75 +-
 net/tipc/core.c                                    |   10 +-
 net/unix/af_unix.c                                 |    6 +-
 net/unix/sysctl_net_unix.c                         |    2 +-
 net/wimax/op-msg.c                                 |    3 +-
 net/wimax/op-reset.c                               |    3 +-
 net/wimax/op-rfkill.c                              |    3 +-
 net/wimax/op-state-get.c                           |    3 +-
 net/wimax/stack.c                                  |    3 +-
 net/wireless/.gitignore                            |    1 +
 net/wireless/Kconfig                               |   13 +-
 net/wireless/Makefile                              |    6 +
 net/wireless/chan.c                                |   41 +-
 net/wireless/core.c                                |   59 +-
 net/wireless/core.h                                |   20 +-
 net/wireless/db.txt                                |   17 +
 net/wireless/genregdb.awk                          |  118 +
 net/wireless/lib80211_crypt_ccmp.c                 |    2 +-
 net/wireless/lib80211_crypt_tkip.c                 |   23 +-
 net/wireless/mlme.c                                |  214 +-
 net/wireless/nl80211.c                             |  866 ++-
 net/wireless/nl80211.h                             |   23 +
 net/wireless/radiotap.c                            |  305 +-
 net/wireless/reg.c                                 |  687 +-
 net/wireless/reg.h                                 |   29 +
 net/wireless/regdb.h                               |    7 +
 net/wireless/scan.c                                |  158 +-
 net/wireless/sme.c                                 |   41 +
 net/wireless/sysfs.c                               |   20 +
 net/wireless/util.c                                |  137 +-
 net/wireless/wext-compat.c                         |   49 +-
 net/wireless/wext-proc.c                           |    4 +-
 net/x25/af_x25.c                                   |   24 +-
 net/x25/x25_proc.c                                 |  114 +-
 net/xfrm/xfrm_input.c                              |    2 +-
 net/xfrm/xfrm_ipcomp.c                             |   16 +-
 net/xfrm/xfrm_policy.c                             |   43 +-
 net/xfrm/xfrm_proc.c                               |    6 +-
 net/xfrm/xfrm_state.c                              |   88 +-
 net/xfrm/xfrm_sysctl.c                             |    4 +-
 net/xfrm/xfrm_user.c                               |  111 +-
 1214 files changed, 113853 insertions(+), 39098 deletions(-)
 create mode 100755 Documentation/networking/ixgbevf.txt
 create mode 100644 Documentation/networking/tcp-thin.txt
 create mode 100644 Documentation/powerpc/dts-bindings/fsl/can.txt
 create mode 100644 drivers/net/can/sja1000/plx_pci.c
 create mode 100644 drivers/net/greth.c
 create mode 100644 drivers/net/greth.h
 create mode 100644 drivers/net/irda/sh_sir.c
 delete mode 100644 drivers/net/isa-skeleton.c
 create mode 100644 drivers/net/ixgbe/ixgbe_mbx.c
 create mode 100644 drivers/net/ixgbe/ixgbe_mbx.h
 create mode 100644 drivers/net/ixgbe/ixgbe_sriov.c
 create mode 100644 drivers/net/ixgbe/ixgbe_sriov.h
 create mode 100644 drivers/net/ixgbevf/Makefile
 create mode 100644 drivers/net/ixgbevf/defines.h
 create mode 100644 drivers/net/ixgbevf/ethtool.c
 create mode 100644 drivers/net/ixgbevf/ixgbevf.h
 create mode 100644 drivers/net/ixgbevf/ixgbevf_main.c
 create mode 100644 drivers/net/ixgbevf/mbx.c
 create mode 100644 drivers/net/ixgbevf/mbx.h
 create mode 100644 drivers/net/ixgbevf/regs.h
 create mode 100644 drivers/net/ixgbevf/vf.c
 create mode 100644 drivers/net/ixgbevf/vf.h
 create mode 100644 drivers/net/ksz884x.c
 create mode 100644 drivers/net/macvtap.c
 create mode 100644 drivers/net/qlcnic/Makefile
 create mode 100644 drivers/net/qlcnic/qlcnic.h
 create mode 100644 drivers/net/qlcnic/qlcnic_ctx.c
 create mode 100644 drivers/net/qlcnic/qlcnic_ethtool.c
 create mode 100644 drivers/net/qlcnic/qlcnic_hdr.h
 create mode 100644 drivers/net/qlcnic/qlcnic_hw.c
 create mode 100644 drivers/net/qlcnic/qlcnic_init.c
 create mode 100644 drivers/net/qlcnic/qlcnic_main.c
 rename drivers/net/stmmac/{mac100.c => dwmac100.c} (68%)
 rename drivers/net/stmmac/{mac100.h => dwmac100.h} (100%)
 rename drivers/net/stmmac/{gmac.h => dwmac1000.h} (95%)
 create mode 100644 drivers/net/stmmac/dwmac1000_core.c
 rename drivers/net/stmmac/{gmac.c => dwmac1000_dma.c} (53%)
 create mode 100644 drivers/net/stmmac/dwmac_dma.h
 create mode 100644 drivers/net/stmmac/dwmac_lib.c
 create mode 100644 drivers/net/wireless/ath/ath9k/gpio.c
 create mode 100644 drivers/net/wireless/ath/ath9k/init.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-spectrum.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_io.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_io.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_testmode.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_testmode.h
 create mode 100644 drivers/pci/vpd.c
 create mode 100644 drivers/vhost/Kconfig
 create mode 100644 drivers/vhost/Makefile
 create mode 100644 drivers/vhost/net.c
 create mode 100644 drivers/vhost/vhost.c
 create mode 100644 drivers/vhost/vhost.h
 delete mode 100644 firmware/bnx2/bnx2-mips-06-5.0.0.j3.fw.ihex
 create mode 100644 firmware/bnx2/bnx2-mips-06-5.0.0.j6.fw.ihex
 rename firmware/bnx2/{bnx2-mips-09-5.0.0.j3.fw.ihex => bnx2-mips-09-5.0.0.j9.fw.ihex} (63%)
 create mode 100644 firmware/bnx2/bnx2-rv2p-09-5.0.0.j10.fw.ihex
 delete mode 100644 firmware/bnx2/bnx2-rv2p-09-5.0.0.j3.fw.ihex
 create mode 100644 firmware/bnx2/bnx2-rv2p-09ax-5.0.0.j10.fw.ihex
 delete mode 100644 firmware/bnx2/bnx2-rv2p-09ax-5.0.0.j3.fw.ihex
 create mode 100644 firmware/bnx2x-e1-5.2.13.0.fw.ihex
 create mode 100644 firmware/bnx2x-e1h-5.2.13.0.fw.ihex
 create mode 100644 include/linux/netfilter/xt_CT.h
 create mode 100644 include/linux/stmmac.h
 create mode 100644 include/linux/vhost.h
 create mode 100644 include/net/netfilter/nf_conntrack_zones.h
 create mode 100644 net/bridge/br_multicast.c
 create mode 100644 net/mac80211/offchannel.c
 create mode 100644 net/mac80211/work.c
 create mode 100644 net/netfilter/ipvs/ip_vs_proto_sctp.c
 create mode 100644 net/netfilter/xt_CT.c
 create mode 100644 net/netfilter/xt_repldata.h
 create mode 100644 net/wireless/.gitignore
 create mode 100644 net/wireless/db.txt
 create mode 100644 net/wireless/genregdb.awk
 create mode 100644 net/wireless/regdb.h
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
