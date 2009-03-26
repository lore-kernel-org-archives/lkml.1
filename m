Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbZCZJIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbZCZJIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 05:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbZCZJHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 05:07:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52085
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751771AbZCZJHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 05:07:31 -0400
Date: Thu, 26 Mar 2009 02:07:14 -0700 (PDT)
Message-Id: <20090326.020714.36421849.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Networking for 2.6.30
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n2Q98Wqu015433


These are the networking updates for 2.6.30

The safest fix for the GRO stinker Ingo and others ran into
is here as well, and I will push that to -stable once it
hits your tree.

Some notable items:

1) Lots of net_device_ops conversions, we are close to being
   where we can remove the compatibility code.  There are some
   platform specific network drivers that still need conversions.

2) Lots of performance work with netfilter thanks to Stephen
   Hemminger and Eric Dumazet.

3) IP multicast routing is now network namespace aware, as are
   the various PPP drivers.

4) A framework for hardware timestamping and higher resolution
   software timestamping from Patrick Ohly and the Intel folks.

5) RDS network protocol stack from Oracle.

6) Lots of cleanups and driver updates all over.

Nothing really earth shattering in here.

Please pull, thanks a lot!

The following changes since commit 8e0ee43bc2c3e19db56a4adaa9a9b04ce885cd84:
  Linus Torvalds (1):
        Linux 2.6.29

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-next-2.6.git master

Abbas, Mohamed (3):
      iwlwifi: allow user to set max rate
      iwlagn: fix agn rate scaling
      iwl3945: fix deep sleep when removing the driver.

Abhijeet Kolekar (22):
      iwl3945: use iwl_rx_mem_buffer
      iwl3945: use iwl_rx_queue in iwl3945
      iwl3945: use iwl_hw_params in iwl3945_priv
      iwl3945: rename iwl3945_priv variables
      iwl3945: replaces iwl3945_priv with iwl_priv
      iwl3945: use iwl-io.h and delete iwl-3945-io.h
      iwl3945: use iwl_rx_scan handlers
      iwl3945: use iwl_mac_hw_scan callback
      iwl3945: use iwl rx handlers
      iwl3945: use iwl_rx_reply_error notification
      iwl3945: remove duplicate interrupt code
      iwl3945: use iwl_isr
      iwl3945: use SW rfkill from iwlwifi
      iwl3945: synchronize timestamp with uCode
      iwl3945: unify set key flow with iwlwifi
      iwl3945: add iwl3945_setup_mac
      iwl3945 : use iwl_activate_qos
      iwl3945: add test for new association
      iwl3945: fix sparse error
      iwl3945: use iwl_led structure
      iwl3945 : fix rate scaling
      iwl3945: use iwl_tx_cmd_complete

Adam Nielsen (1):
      netfilter: x_tables: add LED trigger target

Alex Chiang (1):
      e1000e: normalize usage of serdes_has_link

Alex Williamson (5):
      virtio_net: Add a virtqueue for outbound control commands
      virtio_net: Add a set_rx_mode interface
      virtio_net: Add a MAC filter table
      virtio_net: Add support for VLAN filtering in the hypervisor
      virtio_net: Allow setting the MAC address of the NIC

Alexander Duyck (57):
      igb: igb should not flag lltx
      igb: make certain to power on optics for 82576 fiber nics
      e1000: drop lltx, remove unnecessary lock
      igb: optimize/refactor receive path
      igb: move setting of buffsz out of repeated path in alloc_rx_buffers
      igb: move initialization of number of queues into set_interrupt_capability
      igb: remove check for needing an io port
      igb: add link check function
      igb: make dev_spec a union and remove dynamic allocation
      igb: read address from RAH/RAL instead of from EEPROM
      igb: rename phy ops
      igb: rename nvm ops
      igb: remove unused rx_hdr_split statistic
      igb: update feature flags supported in ethtool
      igb: update testing done by ethtool
      igb: add counter for dma out of sync errors
      igb: cleanup igb_netpoll to be more friendly with napi & GRO
      igb: remove redundant timer updates and cleanup watchdog_task
      igb: rename igb_update_mc_addr_list_82575 to not include the 82575
      igb: remove unnecessary adapter->hw calls when just hw-> will do.
      igb: don't read eicr when responding to legacy interrupts
      igb: move get_hw_control within igb_resume.
      igb: change pba size determination from if to switch statement
      igb: remove disable_av variable from mac_info struct
      igb: remove redundant count set and err_hw_init
      igb: update stats before doing reset in igb_down
      igb: fix two minor items found during code review
      igb: update version number and copyright dates
      igb: misc whitespace/formatting cleanups
      igb: reduce size required to trigger low latency
      igb: cleanup incorrect comment and set IP Checksum Enable
      igb: misc cleanup to combine one if statement
      igb: remove unused defines
      igb: transition driver to only using advanced descriptors
      igb: update napi polling to consolidate function and return correct values
      igb: add vfs_allocated_count as placeholder for number of vfs
      igb: add pf side of VMDq support
      igb: Add support for enabling VFs to PF driver.
      igb: this patch addes the sr-iov enablement option via num_vfs parameter
      igb: remove skb_orphan calls
      igb: remove netif running call from igb_poll
      igb: resolve warning of unused adapter struct
      igb: support wol on second port
      igb: add PF to pool
      igb: correct typo that was setting vfta mask to 1
      igb: add support for another dual port 82576 non-security nic
      igb: add support for 82576 quad copper adapter
      e1000e: add support for 82583 device id
      e1000e: fix dma error handling issues
      ixgb: refactor tx path to use skb_dma_map/unmap
      igb: remove IGB_DESC_UNUSED since it is better handled by a function call
      igb: update driver to use setup_timer function
      igb: rework igb_set_multi so that vfs are properly updated
      igb: cleanup tx dma so map & unmap use matching calls
      e1000: fix tx hang detect logic and address dma mapping issues
      e1000: cleanup clean_tx_irq routine so that it completely cleans ring
      e1000e: commonize tx cleanup routine to match e1000 & igb

Alexey Dobriyan (2):
      pppol2tp: stop using proc internals
      ppp: section fixes re netns

Alina Friedrichsen (21):
      mac80211: Disallow to set multicast BSSID
      mac80211: Don't scan if BSSID and channel are set manually
      mac80211: Don't merge if BSSID is set manually
      mac80211: Allow to set channel in adhoc properly
      mac80211: Read the TSF via debugfs
      ath5k: Read and write the TSF via debugfs
      ath9k: Read and write the TSF via debugfs
      mac80211: Fixed BSSID handling revisited
      mac80211: Generic TSF debugging
      b43: Accessing the TSF via mac80211
      mac80211: Creating new IBSS with fixed BSSID
      mac80211: IBSS join rework
      mac80211: Remove TSF atomic requirement from the documentation
      ath9k: Don't reset TSF after scanning automatically
      mac80211: Introduce a generic commit() to apply changes
      mac80211: Don't merge with the same BSSID
      mac80211: Give it some time to do the TSF sync
      zd1211rw: Implement get_tsf()
      ath9k: Fix FIF_BCN_PRBRESP_PROMISC handling
      ath9k: Set TSF fix
      ath5k: Set TSF fix

Andre Haupt (1):
      Bluetooth: Eliminate a sparse warning in bt3c driver

Andrew H. Richter (1):
      claw: fix minor findings from code analysis tool

Andrew Price (1):
      rt2400,rt2500: init led_qual for LED_MODE_DEFAULT

Andrey Borzenkov (5):
      Move orinoco Kconfig entries into drivers/net/wireless/orinoco/Kconfig
      orinoco: convert to struct net_device_ops
      orinoco: trivial cleanup in alloc_orinocodev
      orinoco: checkpatch cleanup
      orinoco: firmware: consistently compile out fw cache support if not requested

Andrey Yurovsky (1):
      rt2x00: Add mesh support

Andy Fleming (5):
      netdev: Merge UCC and gianfar MDIO bus drivers
      gianfar: Add support for skb recycling
      gianfar: Fix stashing support
      gianfar: remove gianfar_mii.c
      gianfar: Convert to use netdev_ops

Andy Grover (26):
      RDS: Socket interface
      RDS: Main header file
      RDS: Congestion-handling code
      RDS: Transport code
      RDS: Info and stats
      RDS: Connection handling
      RDS: loopback
      RDS: sysctls
      RDS: Message parsing
      RDS: send.c
      RDS: recv.c
      RDS: RDMA support
      RDS/IB: Infiniband transport
      RDS/IB: Ring-handling code.
      RDS/IB: Implement RDMA ops using FMRs
      RDS/IB: Implement IB-specific datagram send.
      RDS/IB: Receive datagrams via IB
      RDS/IB: Stats and sysctls
      RDS: Add iWARP support
      RDS: Common RDMA transport code
      RDS: Documentation
      RDS: Add AF and PF #defines for RDS sockets
      RDS: Add userspace header
      RDS: Add RDS to AF key strings
      RDS: Add MAINTAINERS entry
      RDS: Kconfig and Makefile

Andy Richter (1):
      kmsg: convert claw printk messages

Anton Vorontsov (7):
      gianfar: Implement proper, per netdevice wakeup management
      phylib: Rework suspend/resume code to check netdev wakeup capability
      gianfar: Fix sparse warnings
      gianfar: Fix build with CONFIG_PM enabled
      fsl_pq_mdio: Revive Gianfar TBI PHY support
      fsl_pq_mdio: Use proper address translation
      ucc_geth: Fix build breakage caused by a merge

Arthur Jones (3):
      e1000e: allow tx of pre-formatted vlan tagged packets
      e1000e: fixup merge error
      igb: allow tx of pre-formatted vlan tagged packets

Ayaz Abdulla (18):
      forcedeth: mgmt unit interface
      forcedeth: msi interrupt fix
      forcedeth: ethtool tx csum fix
      forcedeth: recover error support
      forcedeth: bump version to 63
      forcedeth: fix stats version feature
      forcedeth: fix missing napi enable/disable calls
      forcedeth: remove msix + napi
      forcedeth: save irq events for napi processing
      forcedeth: remove overhead
      forcedeth: add/modify tx done with limit
      forcedeth: napi - handle all processing
      forcedeth: add new optimization mode
      forcedeth: remove isr processing loop
      forcedeth: add interrupt moderation logic
      forcedeth: performance changes
      forcedeth: fix irq clearing and napi spin lock changes
      forcedeth: version bump to 64

Ben Hutchings (24):
      net: Remove redundant NAPI functions
      tehuti: Use request_firmware()
      typhoon: Use request_firmware()
      sfc: SFT9001: Include non-breaking cable diagnostics in online self-tests
      sfc: Fix test for MDIO read failure
      sfc: SFT9001/SFN4111T: Check PHY boot status during board initialisation
      sfc: Remove "XFP" from log messages that are not specific to XFP
      sfc: Fix reporting of PHY id
      sfc: Add support for QT2025C PHY
      sfc: Delete unused efx_blinker::led_num field
      sfc: Clean up LED control
      sfc: Add support for SFN4112F SFP+ reference design
      sfc: Fix efx_ethtool_nway_result() to use clause 45 MDIO registers
      sfc: Reject packets from the kernel TX queue during a loopback self-test
      sfc: Clean up properly on reset failure paths
      sfc: Clear I2C adapter structure in falcon_remove_nic()
      sfc: Don't wake TX queues while they're being flushed
      sfc: Fix search for flush completion events
      sfc: Improve NIC internal error recovery
      sfc: Pad packets to 33 bytes to prevent TX packet parser lockup
      sfc: Work around unreliable legacy interrupt status
      sfc: Remove unused private PCI register definitions
      sfc: Optimise falcon_writel_page_locked() for page > 0
      sfc: Implement adaptive IRQ moderation

Benjamin Thery (9):
      netns: ipmr: allocate mroute_socket per-namespace.
      netns: ipmr: dynamically allocate vif_table
      netns: ipmr: store netns in struct mfc_cache
      netns: ipmr: dynamically allocate mfc_cache_array
      netns: ipmr: declare counter cache_resolve_queue_len per-namespace
      netns: ipmr: declare mroute_do_assert and mroute_do_pim per-namespace
      netns: ipmr: declare reg_vif_num per-namespace
      netns: ipmr: declare ipmr /proc/net entries per-namespace
      netns: ipmr: enable namespace support in ipv4 multicast routing code

Bernard Pidoux (3):
      ax25: SOCK_DEBUG message simplification
      ax25: zero length frame filtering in AX25
      netrom: zero length frame filtering in NetRom

Bing Zhao (1):
      libertas: fix power save issue in libertas_sdio module

Bob Copeland (25):
      ath5k: support LEDs on Acer Aspire One netbook
      ath5k: fix off-by-one in gpio checks
      mac80211: document return codes from ops callbacks
      ath5k: fix bf->skb==NULL panic in ath5k_tasklet_rx
      mac80211: add suspend/resume callbacks
      ath5k: remove stop/start calls from within suspend/resume
      ath5k: remove unused led_off parameter
      ath5k: use short preamble when possible
      ath5k: honor the RTS/CTS bits
      mac80211: change workqueue back to non-freezeable
      mac80211: flush workqueue a second time in suspend()
      ath9k: remove write-only current_rd_inuse
      ath9k: save a few calls to ath9k_regd_get_eepromRD
      ath9k: convert isWwrSKU macro into C code
      ath9k: remove ath9k_regd_get_rd()
      ath9k: remove prototype for ath9k_regd_get_current_country
      ath9k: move common regulatory code out of if() branches
      ath5k: don't mask off interrupt bits
      ath5k: use spin_lock_irqsave for beacon lock
      ath5k: move beacon processing to a tasklet
      ath5k: compute rts/cts duration after computing full pktlen
      ath9k: fix 802.11g conformance test limit typo
      ath5k: extract LED code into a separate file
      ath5k: use a table for LED parameters
      ath5k: update LED table with reported devices

Breno Leitao (2):
      s2io: Formatting log message
      e1000: Removing the unused macro PAGE_USE_COUNT()

Breno Leit√£o (1):
      ixgbe: Removing the unused PAGE_USE_COUNT() macro.

Brian Haley (1):
      ipv6: Fix incorrect disable_ipv6 behavior

Brice Goglin (1):
      myri10ge: update firmware headers to 1.4.41

Bruce Allan (2):
      e100: add support for 82552 10/100 adapter
      e1000e: add support for 82574 device ID 0x10F6

Cesar Eduardo Barros (5):
      sc92031: more useful banner in kernel log
      sc92031: remove meaningless version string
      sc92031: inline SC92031_DESCRIPTION
      sc92031: use device id directly instead of made-up name
      sc92031: add a link to the datasheet

Chatre, Reinette (2):
      iwl3945: add debugging for wrong command queue
      iwlwifi: add test to determine if interface in monitor mode

Christian Lamparter (24):
      p54: label queues with their corresponding names
      p54: enable proper frame injection
      p54usb: utilize usb_reset_device for 3887
      p54: prevent upload of wrong firmwares
      p54: regulatory domain hints
      p54: enable rx/tx antenna diversity by eeprom bits
      p54: implement FIF_OTHER_BSS filter setting
      p54: power save management
      p54: return NETDEV_TX_OK in p54_tx and fix sparse warnings
      p54: refactor p54_alloc_skb
      p54: upgrade memrecord to p54_tx_info
      p54: prepare the eeprom parser routines for longbow
      p54: longbow frontend support
      p54spi: stlc45xx eeprom blob
      p54spi: p54spi driver
      p54usb: fix conflict with recent usb changes
      p54spi: remove arch specific dependencies
      p54usb: stop USB core interference in exit path
      p54: unify ieee80211 device registration
      p54pci: convert printk(KERN_* to dev_*
      p54: fix iwconfig txpower off
      p54: initial SoftLED support
      p54: enable power save support
      p54: completely ignore rx'd frames with bad FCS

Christoph Paasch (2):
      netfilter: change generic l4 protocol number
      netfilter: remove IPvX specific parts from nf_conntrack_l4proto.h

Colin McCabe (2):
      libertas: Update libertas core with GSPI constants
      libertas: if_spi, driver for libertas GSPI devices

Constantin Baranov (2):
      niu: fix PHY template choice for 10G copper
      niu: improve ethtool support for gigabit copper cards

Cyrill Gorcunov (9):
      net: pppoe - code cleanup and helpers
      net: pppoe - introduce net-namespace functionality
      net: pppol2tp - introduce net-namespace functionality
      net: ppp_generic - introduce net-namespace functionality v2
      net: pppoe,pppol2tp - register channels with explicit net
      net: pppoe - get rid of DECLARE_MAC_BUF
      net: pppoe - stop using proc internals
      net: sysctl_net - use net_eq to compare nets
      net: netfilter conntrack - add per-net functionality for DCCP protocol

Dan Williams (13):
      libertas: fix CF firmware loading for some cards
      airo: clean up and clarify interrupt-time task handling
      airo: re-arrange WPA capability checks
      airo: simplify WEP index and capability checks
      airo: clean up WEP key operations
      airo: use __attribute__ ((packed)) not #pragma
      airo: clean up and clarify micinit()
      airo: remove useless #defines
      hostap: convert usage of net/ieee80211.h to linux/ieee80211.h
      make net/ieee80211.h private to ipw2x00
      cfg80211: age scan results on resume
      ipw2x00: age scan results on resume
      libertas: use private SDIO workqueue to avoid scheduling latency

Daniel Mack (2):
      drivers/net/ax88796.c: take IRQ flags from platform_device
      ax88796: Add method to take MAC from platform data

Danny Kukawka (5):
      iwlwifi: fix led naming
      ath9k: fix led naming
      b43legacy: fix led naming
      rt2x00: fix led naming
      iwlwifi: another led naming fix

Dave Jones (1):
      a2065: skb_padto cleanups

Dave Young (2):
      Bluetooth: Remove CONFIG_DEBUG_LOCK_ALLOC ifdefs
      Bluetooth: Move hci_conn_del_sysfs() back to avoid device destruct too early

David Dillow (1):
      typhoon: repair firmware loading

David Kilroy (20):
      wireless: Add channel/frequency conversions to ieee80211.h
      orinoco: Remove unused variable rx_data
      orinoco: address leading and trailing whitespace
      orinoco: spaces in parenthesised expressions
      orinoco: remove unnecessary braces
      orinoco: keep line length below 80 characters
      orinoco: Fix interesting checkpatch errors
      orinoco: Rename orinoco.c
      orinoco: use orinoco_private instead of net_device in scan helper
      orinoco: Move scan helpers to a separate file
      orinoco: Move MIC helpers into new file
      orinoco: Move firmware handling into a separate file
      orinoco: Use accessor functions for bitrate tables
      orinoco: Add hardware function to set multicast mode
      orinoco: Move hardware functions into separate file
      orinoco: Move WEXT handlers into a separate file
      orinoco: hermes_dld does not need to be a module
      orinoco: hermes doesn't need to be a separate module
      orinoco: validate firmware header
      orinoco: prevent accessing memory outside the firmware image

David S. Miller (53):
      com20020: Fix allyesconfig build failure.
      com0020: Add missing symbol export for com20020_netdev_ops.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      net: Allow RX queue selection to seed TX queue hashing.
      net: Add skb_record_rx_queue() calls to multiqueue capable drivers.
      net: If SKB has attached socket, use socket's hash for TX queue selection.
      net: Get rid of by-hand TX queue hashing.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'master' of /home/davem/src/GIT/linux-2.6/
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      net: Increase default NET_SKB_PAD to 32.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      net: Kill skbuff macros from the stone ages.
      netdev: Use __netdev_alloc_skb() instead of __dev_alloc_skb().
      irda: Use __netdev_alloc_skb() instead of __dev_alloc_skb().
      net: Move skbuff symbol exports after each symbol's definition.
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'master' of /home/davem/src/GIT/linux-2.6/
      Revert "etherh: Get working again."
      Merge branch 'master' of /home/davem/src/GIT/linux-2.6/
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of git://git.kernel.org/.../holtmann/bluetooth-next-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      typhoon: Need non-vmalloc memory to DMA firmware to the card.
      ixgbe: Fix some compiler warnings.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      rds: Fix build on powerpc.
      typhoon: Add missing firmware copy.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      sunvnet: Convert to net_device_ops.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of git://git.infradead.org/~dwmw2/solos-2.6
      spider_net: Fix build.
      myri_sbus: Convert to net_device_ops.
      sunbmac: Convert to net_device_ops.
      sunlance: Convert to net_device_ops.
      sunqe: Convert to net_device_ops.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      myri_sbus/sunbmac/sunlance/sunqe: Add missing net_device_ops entries.
      spider_net: Add missing .ndo_validate_addr
      ucc_geth: Fix merge error.
      Merge branch 'master' of git://git.kernel.org/.../kaber/nf-next-2.6
      Merge branch 'master' of git://git.kernel.org/.../kaber/nf-2.6
      rndis_wlan: Fix build with netdev_ops compat disabled.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6

David Woodhouse (27):
      solos: Fix length header in FPGA transfers
      solos: Clean up firmware loading code
      solos: Kill global 'opens' count.
      solos: Handle attribute show/store in kernel more sanely
      solos: Add initial list of parameters
      solos: Handle new line status change packets, hook up to ATM layer info
      solos: Kill existing connections on link down event
      solos: Reject non-AAL5 connections.... for now
      solos: Add SNR and Attn to status packet, fix oops on load
      solos: Fix under-allocation of skb size for get/set parameters
      solos: Remove parameter group from sysfs on ATM dev deregister
      solos: First attempt at DMA support
      solos: Tidy up DMA handling a little. Still untested
      solos: Tidy up tx_mask handling for ports which need TX
      solos: Remove unused loopback debug stuff
      solos: Remove IRQF_DISABLED, don't frob IRQ enable on the FPGA in solos_irq()
      solos: Remove superfluous wait_queue_head_t from struct solos_param
      solos: Fix various bugs in status packet handling
      solos: Clean up handling of card->tx_mask a little
      solos: Remove debugging, commented-out test code
      solos: Add 'reset' module parameter to reset the DSL chips on load
      solos: Tidy up status interrupt handling, cope with 'ERROR' status
      solos: Don't clear config registers at startup
      solos: Set RX empty flag at startup only for !dma mode
      solos: Swap upstream/downstream rates in status packet, clean up some more
      solos: Reset device on unload, free pending skbs
      solos: Disable DMA until we have an FPGA update with it actually implemented.

Denys Fedoryshchenko (1):
      ipv4: arp announce, arp_proxy and windows ip conflict verification

Dhananjay Phadke (22):
      netxen: remove superfluous doorbell map
      netxen: fix sparse warnings
      netxen: ratelimit error prints
      netxen: firmware download support
      netxen: advertise wake-on-lan support
      netxen: cleanup unused code
      netxen: refactor pci probe
      netxen: update copyright
      netxen: support larger dma addressing
      netxen: firmware download improvements
      netxen: cleanup rx handling
      netxen: small xmit optimizations
      netxen: refactor netdev open close
      netxen: cleanup superfluous multi-context code
      netxen: annotate board_config and board_type
      netxen: fix endianness in serial number
      netxen: add suspend resume support
      netxen: sanitize variable names
      netxen: remove old lro code
      netxen: add receive side scaling (rss) support
      netxen: update version to 4.0.30
      netxen: fix firmware download warnings

Divy Le Ray (13):
      cxgb3: ease msi-x settings conditions
      cxgb3: Notify fatal errors
      iw_cxgb3: handle chip reset notifications
      cxgb3: ring rx door bell less frequently
      cxgb3: release page ref on mapping error
      cxgb3: fix skb truesize in jumbo mode
      cxgb3: prefetch buffer access in GRO mode
      cxgb3: separate TX and RX reclaim handlers
      cxgb3: disable high freq non-data interrupts
      cxgb3: Update Rev3 mac workaround
      cxgb3: detect mac link faults.
      cxgb3: update FW
      cxgb3: update driver version

Don Skidmore (4):
      ixgbe: fix slow load times on 82598 nics
      ixgbe: add support KX/KX4 device
      ixgbe: Add 82598 support for BX mezzanine devices
      ixgbe: fix for 82598 Si errata causing buffer overflow

Eilon Greenstein (60):
      bnx2x: New FW
      bnx2x: Multi-queue
      bnx2x: MSI support
      bnx2x: System-page alignment
      bnx2x: Disabling interrupts after iSCSI-boot
      bnx2x: Removing microcode assertion check
      bnx2x: Per queue statistics
      bnx2x: Moving skb_record_rx_queue
      bnx2x: BW shaper enhancements
      bnx2x: Flow control enhancement
      bnx2x: Removing the board type
      bnx2x: Removing redundant device parameters
      bnx2x: GPIO accessories
      bnx2x: Supporting BCM8726 PHY
      bnx2x: PHY lock list
      bnx2x: Supporting BCM8481 PHY
      bnx2x: Saving PHY FW version
      bnx2x: EMAC reset
      bnx2x: Using the HW 5th lane
      bnx2x: Removing CL73 code
      bnx2x: GMII not SGMII
      bnx2x: Pre emphasis configuration
      bnx2x: Using registers name
      bnx2x: Manual setting for MRRS
      bnx2x: Returning EBUSY in debug mode as well
      bnx2x: Increasing FW timeout
      bnx2x: smp_mb and not just smp_rmb
      bnx2x: Using nvram default WoL config
      bnx2x: Memory clean up on failure
      bnx2x: Optimize chip MPS configuration
      bnx2x: Loopback in diag mode
      bnx2x: Better struct naming
      bnx2x: Removing redundant macros
      bnx2x: Sparse endianity annotation
      bnx2x: Removing unused struct
      bnx2x: Driver dump
      bnx2x: Moving includes
      bnx2x: Re-arrange module parameters
      bnx2x: Comments and prints
      bnx2x: Clean-up
      bnx2x: Version
      bnx2x: Remove redundant smb_mb on unload
      bnx2x: Misleading name
      bnx2x: Reduce the likelihood of smb_mb
      bnx2x: Add rmb to read status block indices on load
      bnx2x: Unlimited Tx interrupt work
      bnx2x: napi_poll budget check
      bnx2x: Missing module parameter description
      bnx2x: Using DMA engine
      bnx2x: Calling tx disable unconditionally
      bnx2x: Supporting new BCM8726 FW
      bnx2x: Enable BCM8726 module transmitter
      bnx2x: BCM8705 has no microcode
      bnx2x: Display BCM8481 FW version
      bnx2x: Loopback support at external PHY
      bnx2x: Whitespace
      bnx2x: Debug prints
      bnx2x: Register dump
      bnx2x: Version update
      bnx2x: Adding licensing to bnx2x_init_values.h

Eric Biederman (4):
      veth: Allow setting the L3 MTU
      neigh: Allow for user space users of the neighbour table
      macvlan: Support creating macvlans from macvlans
      macvlan: Deterministic ingress packet delivery

Eric Dumazet (13):
      net: move bsockets outside of read only beginning of struct inet_hashinfo
      netfilter: arp_tables: unfold two critical loops in arp_packet_match()
      netfilter: xt_physdev fixes
      netfilter: xt_physdev: unfold two loops in physdev_mt()
      netfilter: ip6_tables: unfold two loops in ip6_packet_match()
      netfilter: ip_tables: unfold two critical loops in ip_packet_match()
      netfilter: xt_hashlimit fix
      tcp: allow timestamps even if SYN packet has tsval=0
      net: reorder fields of struct socket
      net: reorder struct Qdisc for better SMP performance
      net: remove useless prefetch() call
      netfilter: nf_conntrack: Reduce conntrack count in nf_conntrack_free()
      arp_tables: ifname_compare() can assume 16bit alignment

Eric Leblond (7):
      netfilter: log invalid new icmpv6 packet with nf_log_packet()
      netfilter: use a linked list of loggers
      netfilter: print the list of register loggers
      netfilter: sysctl support of logger choice
      netfilter: fix warning about invalid const usage
      netfilter: fix warning in ebt_ulog init function.
      netfilter: fix nf_logger name in ebt_ulog.

Eric Sesterhenn (1):
      MISDN: list usage cleanup

Eric W. Biederman (13):
      tun: Remove unnecessary tun_get_by_name
      tun: Fix races in tun_set_iff
      tun: Use POLLERR not EBADF in tun_chr_poll
      tun: Introduce tun_file
      tun: Grab the netns in open.
      tun: Make tun_net_xmit atomic wrt tun_attach && tun_detach
      tun: Move read_wait into tun_file
      tun: Fix races between tun_net_close and free_netdev.
      tun: There is no longer any need to deny changing network namespaces
      tun: Implement ip link del tunXXX
      netns: Fix icmp shutdown.
      tcp: Like icmp use register_pernet_subsys
      netns: Remove net_alive

Evgeniy Polyakov (1):
      inet: Allowing more than 64k connections and heavily optimize bind(0) time.

Felix Fietkau (1):
      ath5k: properly free rx dma descriptors

Fenghua Yu (1):
      iwlwifi: dma mapping read and write changes

Florian Fainelli (3):
      au1000: reorder functions
      r6040: Fix second PHY address
      Bump release date to 25Mar2009 and version to 0.22

Florian Westphal (2):
      netfilter: ctnetlink: remove remaining module refcounting
      netfilter: remove nf_ct_l4proto_find_get/nf_ct_l4proto_put

Francois Romieu (1):
      tg3: remove extra casting

Frank Blaschka (6):
      lcs: convert to net_device_ops
      ctcm: convert to net_device_ops
      netiucv: convert to net_device_ops
      claw: convert to net_device_ops
      qeth: add statistics for tx csum
      qeth: remove EDDP

Frank Seidel (2):
      airo: reduce stack memory footprint
      iwlwifi: reduce stack size

Frederic Weisbecker (1):
      connector: create connector workqueue only while needed once

Gabor Juhos (20):
      ath9k: use signed format to print HAL status
      ath9k: convert to struct device
      ath9k: convert to use bus-agnostic DMA routines
      ath9k: introduce bus specific cache size routine
      ath9k: introduce bus specific cleanup routine
      ath9k: move PCI code into separate file
      ath9k: introduce platform driver for AHB bus support
      ath9k: get EEPROM contents from platform data on AHB bus
      ath9k: remove (u16) casts from rtc register access
      ath9k: fix ar5416Addac_9100 values
      ath9k: fix null pointer dereference in ani monitor code
      ath9k: enable support for AR9100
      ath9k: fix AR_TXCFG_DMASZ_MASK value
      ath9k: create a common debugfs_root for all device instances
      ath9k: cleanup AR5416 version checking macros
      ath9k: move ar9100 version checking macros into a more appropriate place
      ath9k: fix AR_SREV_9100_OR_LATER macro
      ath9k: fix compile error in ahb.c
      ath9k: fix compile error in debug.c
      ath9k: always compile ath_radio_{en,dis}able

Gabriele Paoloni (1):
      ppp: ppp_mp_explode() redesign

Geert Uytterhoeven (1):
      dnet: drivers/net/dnet.c needs <linux/io.h>

Gerrit Renker (6):
      dccp: Initialisation framework for feature negotiation
      dccp: Implement both feature-local and feature-remote Sequence Window feature
      dccp: Initialisation and type-checking of feature sysctls
      dccp: Debugging functions for feature negotiation
      dccp: Minimise header option overhead in setting the MPS
      dccp: Do not let initial option overhead shrink the MPS

Graf Yang (1):
      net: fix some trailing whitespaces

Greg Ungerer (2):
      fec: add FEC platform support to ColdFire CPU's setup code
      m68knommu: remove ColdFire specific setup code from FEC driver

Guo-Fu Tseng (5):
      jme: Modifies messages to display correct hardware version
      jme: Fix pci sync
      jme: Clear all modified GHC register flags
      jme: Adding {64,40}bits DMA mask back
      jme: Advance version number after previous changes

Hagen Paul Pfeifer (2):
      netfilter: nf_conntrack: table max size should hold at least table size
      netfilter: fix hardcoded size assumptions

Hannes Eder (60):
      drivers/isdn/hardware/mISDN: fix sparse warnings: make symbols static
      drivers/isdn/mISDN: fix sparse warnings: make symbols static
      drivers/isdn/hardware/mISDN: change type of hfc_jiffies to unsigned long
      drivers/net/at1700.c: fix sparse warning: symbol shadows an earlier one
      drivers/net/e2100.c: fix sparse warning: symbol shadows an earlier one
      drivers/net/ni65.c: fix sparse warnings: symbol shadows an earlier one
      drivers/net/ns83820.c: fix sparse warnings: fix signedness
      drivers/net/niu.c: fix sparse warning: symbol shadows an earlier one
      drivers/net/lance.c: fix sparse warnings: fix signedness
      drivers/net/ni65.c: fix sparse warnings: fix signedness
      drivers/net/ppp*.c: fix sparse warnings: fix signedness
      drivers/net/r6040.c: fix sparse warning: Using plain integer as NULL pointer
      drivers/net/s2io.c: fix sparse warning: symbol shadows an earlier one
      drivers/net/arcnet: fix sparse warning: symbol shadows an earlier one
      drivers/net/atl1e: fix sparse warnings: fix signedness
      drivers/net/atlx: fix sparse warnings: fix signedness
      drivers/net/bonding: fix sparse warnings: context imbalance
      drivers/net/bonding: fix sparse warning: symbol shadows an earlier one
      drivers/net/cxgb3: fix sparse warning: symbol shadows an earlier one
      drivers/net/cxgb3: fix sparse warnings: fix signedness
      drivers/net/e1000e: fix sparse warning: Should it be static?
      drivers/net/hamradio: fix warning: format not a string literal and no ...
      drivers/net/hamradio: fix sparse warning: context imbalance
      drivers/net/hamradio: fix sparse warning: symbol shadows an earlier one
      drivers/net/hamradio: fix sparse warnings: fix signedness
      drivers/net/ixgbe: fix sparse warning: Should it be static?
      drivers/net/pcmcia: fix warning: format not a string literal and no ...
      drivers/net/sfc: fix sparse warning: symbol shadows an earlier one
      drivers/net/skfp: fix sparse warning: Should it be static?
      drivers/net/tokenring: fix warning: format not a string literal and no ...
      drivers/net/tokenring: fix sparse warning: symbol shadows an earlier one
      drivers/net/tulip: fix warning: format not a string literal and no ...
      drivers/net/tulip: fix sparse warning: symbol shadows an earlier one
      drivers/net/usb: fix sparse warnings: Should it be static?
      drivers/net/wan: fix warning: format not a string literal and no ...
      drivers/net/wan: fix sparse warning: symbol shadows an earlier one
      drivers/net/wireless: fix sparse warning: context imbalance
      drivers/net/wireless: fix sparse warnings: symbol shadows an earlier one
      drivers/net/wireless: fix sparse warnings: fix signedness
      drivers/net/wireless/ath9k: fix sparse warnings: Should it be static?
      drivers/net/wireless/b43: fix warning: format not a string literal and no ...
      drivers/net/wireless/ipw2x00: fix sparse warnings: fix signedness
      drivers/net/wireless/prism54: fix sparse warning: fix signedness
      drivers/net/tokenring: fix sparse warning: cast truncates bits from const value
      drivers/net/sfc: fix sparse warnings: Should it be static?
      drivers/net/igb: fix sparse warning: symbol shadows an earlier one
      ipv6: fix sparse warning: Using plain integer as NULL pointer
      net/802: fix sparse warnings: context imbalance
      9p: fix sparse warning: cast adds address space
      appletalk: fix warning: format not a string literal and no ...
      sysctl: fix sparse warning: Should it be static?
      decnet: fix sparse warnings: context imbalance
      decnet: fix sparse warnings: symbol shadows an earlier one
      inet fragments: fix sparse warning: context imbalance
      wanrouter: fix sparse warnings: context imbalance
      drivers/isdn/capi: fix sparse warning: context imbalance
      drivers/isdn/act2000: fix sparse warning: symbol shadows an earlier one
      drivers/isdn/hisax: fix sparse warning: Should it be static?
      drivers/isdn/hardware/icon: fix sparse warning: cast truncates bits
      drivers/isdn/hardware/eicon: fix sparse warnings: Should it be static?

Hannes Hering (1):
      ehea: Fix: Remove adapter from adapter list in error path

Hantzis Fotis (1):
      tcp: tcp_init_wl / tcp_update_wl argument cleanup

Harvey Harrison (9):
      typhoon: replace users of __constant_{endian}
      bnx2: annotate bp->phy_lock functions
      prism54: remove private implementation of le32_add_cpu
      wimax: replace uses of __constant_{endian}
      net: replace uses of __constant_{endian}
      wireless: replace uses of __constant_{endian}
      rndis: remove private wrapper of __constant_cpu_to_le32
      net: replace __constant_{endian} uses in net headers
      wimax: replace uses of __constant_{endian}

Heiko Carstens (1):
      qeth: fix wait_event_timeout handling

Helmut Schaa (10):
      ath5k: discard 11g caps if reported by an ar5211 eeprom
      iwl3945: report killswitch changes even if the interface is down
      iwl3945: fix some warnings when compiled without debug
      iwlagn: fix hw-rfkill while the interface is down
      iwlagn: clean up error path in iwl_pci_probe
      libipw: fix debug output
      ipw2x00: remove duplicated defines
      ipw2x00: Use IE definitions from linux/ieee80211.h
      ipw2x00: remove obsolete enums
      mac80211: handle failed scan requests in STA mode

Herbert Xu (23):
      e1000e: Invoke VLAN GRO handler
      ixgbe: Replace LRO with GRO
      sfc: Replace LRO with GRO
      igb: Replace LRO with GRO
      cxgb3: Replace LRO with GRO
      gro: Move common completion code into helpers
      gro: Avoid copying headers of unmerged packets
      gro: Do not merge paged packets into frag_list
      gro: Open-code memcpy in napi_fraginfo_skb
      gro: Fix handling of imprecisely split packets
      ipv4: Delete redundant sk_family assignment
      net: Partially allow skb destructors to be used on receive path
      net: Reexport sock_alloc_send_pskb
      tun: Limit amount of queued packets per device
      gro: Fix frag_list merging on imprecisely split packets
      gro: Remember number of held packets instead of counting every time
      gro: Optimise Ethernet header comparison
      gro: Optimise IPv4 packet reception
      gro: Optimise TCP packet reception
      tun: Fix merge error
      tcp: Always set urgent pointer if it's beyond snd_nxt
      GRO: Move netpoll checks to correct location
      gro: Fix vlan/netpoll check again

Herton Ronaldo Krzesinski (1):
      mac80211: deauth before flushing STA information

Huang Weiyi (2):
      dnet: remove duplicated #include
      atl1c: remove duplicated #include

Ilpo J√§rvinen (27):
      ipmr: use goto to common label instead of opencoding
      ax25: more common return path joining
      ipv6/ndisc: join error paths
      ipv6/addrconf: common code located
      net/sunrpc/xprtsock.c: some common code found
      tcp: don't backtrack to sacked skbs
      tcp: fix lost_cnt_hint miscounts
      tcp: deferring in middle of queue makes very little sense
      tcp: Don't clear hints when tcp_fragmenting
      tcp: fix corner case issue in segmentation during rexmitting
      tcp: remove redundant code from tcp_mark_lost_retrans
      tcp: separate timeout marking loop to it's own function
      tcp: cleanup ca_state mess in tcp_timer
      tcp: drop unnecessary local var in collapse
      htcp: merge icsk_ca_state compare
      tcp: add helper for AI algorithm
      tcp: kill eff_sacks "cache", the sole user can calculate itself
      tcp: in sendmsg/pages open code the real goto target
      tcp: get rid of two unnecessary u16s in TCP skb flags copying
      tcp: remove pointless .dsack/.num_sacks code
      tcp: kill dead end_seq variable in clean_rtx_queue
      tcp: consolidate paws check
      tcp: don't check mtu probe completion in the loop
      tcp: simplify tcp_current_mss
      tcp: cache result of earlier divides when mss-aligning things
      tcp: make sure xmit goal size never becomes zero
      net/*: use linux/kernel.h swap()

Inaky Perez-Gonzalez (7):
      wimax/i2400m: convert to net_device_ops
      wimax/i2400m: add the ability to fallback to other firmware files if the default is not there
      wimax/i2400m: drop support for deprecated major fw interface, add for new minor
      wimax/i2400m: firmware_check() encodes the firmware version in i2400m->fw_version
      wimax/i2400m: allow control of the base-station idle mode timeout
      wimax/i2400m: support extended data RX protocol (no need to reallocate skbs)
      wimax/i2400m: implement RX reorder support

Ivo van Doorn (31):
      rt2x00: Implement Powersaving
      rt2x00: Move link tuning into seperate file
      rt2x00: Reduce calls to bbp_read()
      rt2x00: Restrict interface between rt2x00link and drivers
      rt2x00: Add RFKILL support to rt2500usb and rt73usb
      rt2x00: Rename CONFIG_CRYPTO_COPY_IV
      rt2x00: Implement WDS support
      rt2x00: Split EEPROM_NIC_TX_RX_FIXED
      rt2x00: Move code into seperate functions
      rt2x00: Remove ENTRY_TXD_OFDM_RATE
      rt2x00: Allow drivers to pass the noise value during rxdone
      rt2x00: Introduce RXDONE_SIGNAL_MASK mask
      rt2x00: Release rt2x00 2.3.0
      rt2x00: Replace RFKILL with INPUT
      rt2x00: Only register rfkill input when key is present
      rt2x00: Update copyright year to 2009
      rt2x00: conf_tx() only need register access for WMM queues
      rt2x00: Add LED_MODE_ASUS support
      rt2x00: rt2x00_rev() should return u32
      rt2x00: Restrict firmware file lengths
      rt2x00: Simplify suspend/resume handling
      rt2x00: Move intf_work to mac82011 workqueue
      rt2x00: Add kill_tx_queue callback function
      rt2x00: Validate firmware in driver
      Add new rt73usb USB ID
      rt2x00: uncomment get_tsf
      rt2x00: Remove check for rf word 0
      rt2x00: Add various new USB IDs for rt73usb
      rt2x00: Fix RF offset
      rt2x00: Fix SW antenna diversity
      rt2x00: Export all register stats through debugfs

Jaikumar Ganesh (1):
      Bluetooth: When encryption is dropped, do not send RFCOMM packets

Jan Engelhardt (8):
      net: constify VFTs
      netfilter: remove unneeded goto
      netfilter: Combine ipt_TTL and ip6t_HL source
      netfilter: Combine ipt_ttl and ip6t_hl source
      netfilter: xtables: add backward-compat options
      netfilter: install missing headers
      netfilter: xtables: avoid pointer to self
      netfilter: trivial Kconfig spelling fixes

Jan-Bernd Themann (1):
      ehea: fix circular locking problem

Jarek Poplawski (7):
      net: Optimize memory usage when splicing from sockets.
      pkt_sched: sch_hfsc: sch_htb: Add non-work-conserving warning handler.
      pkt_sched: sch_htb: Warn on too many events.
      pkt_sched: sch_htb: Use workqueue to schedule after too many events.
      pkt_sched: sch_multiq: Change errno on non-multiqueue devices use.
      net: Fix page seeking for skb_splice_bits().
      pkt_sched: Change misleading code in class delete.

Jason Andryuk (7):
      at76c50x-usb: update to latest mac80211 hw scan api
      at76c50x-usb: convert at76_debug to an unsigned int
      at76c50x-usb: fix oops on disconnect
      at76c50x-usb: clean up DMA on stack
      at76c50x-usb: additional disconnect fixes
      iwl3945: initialize is_valid_rtc_data_addr function pointer
      iwl3945: re-add iwl_poll_direct_bit return value check

Jay Sternberg (13):
      iwlwifi: correct Kconfig to prevent following entries from not indenting
      iwlwifi: remove static from 5000 structures
      iwlwifi: add recognition of Intel WiFi Link 6000 and 6050 Series
      iwlwifi: add recognition of Intel WiFi Link 100 Series
      iwlwifi: add new HW_REV_TYPEs for Intel WiFi Link 100, 6000 and 6050 Series
      iwlwifi: simplify parameter setting to allow support for 6000 series
      iwlwifi: parametrize configuration of the PLL for exclusion on 6000
      iwlwifi: correct API command overlap
      iwlwifi: define structures and functions externally for customization
      iwlwifi: remove chain noise calibration functions from 6000 family
      ipw2x00: correct Kconfig to prevent following entries from not indenting
      iwlwifi: update 5150 API version to support new firmware
      iwlwifi: correct device name for 1000 series

Jeff Kirsher (1):
      igb: remove LRO Kconfig option

Jesper Dangaard Brouer (5):
      ipv4: Fix rp_filter description in net/ipv4/Kconfig.
      ipv4: Clean whitespaces in net/ipv4/Kconfig.
      Doc: Fix typos in ip-sysctl.txt about rp_filter.
      Doc: Cleanup whitespaces in ip-sysctl.txt
      Doc: Refer to ip-sysctl.txt for strict vs. loose rp_filter mode

Jesse Brandeburg (18):
      e1000e: drop lltx, remove unnecessary lock
      igb: remove dead code in transmit routine
      e1000e: add aer support
      e1000e: remove workaround for e1000 hardware
      ixbge: fix bug when using large pages and jumbo frames
      e1000e: fix unmap bug
      e1000: fix unmap bug
      ixgbe: Fix interrupt configuration for 82599
      ixgbe: fix bug with napi add before request_irq
      ixgbe: Fix the Tx clean logic to return proper status
      ixgbe: Cleanup on the Rx init path
      ixgbe: Add a few safety nets for register writes and descriptor cleanups
      ixgbe: Cleanup some whitespace issues, fixup and add some comments
      ixgbe: Fixup the watchdog interrupt scheduling on 82599
      e1000: fix close race with interrupt
      e1000e: fix loss of multicast packets
      e1000e: fix close interrupt race
      e1000e: update version number

Jiri Pirko (3):
      8139cp: allow to set mac address on running device
      8139too: allow to set mac address on running device
      bonding: select current active slave when enslaving device for mode tlb and alb

Jiri Slaby (5):
      IWL: fix WARN typo
      ipw2200, fix ipw io functions
      ath5k: fix hw rate index condition
      ath5k: constify stuff
      ath5k: don't change mac in eeprom_read_mac on error

Joakim Tjernlund (1):
      ucc_geth: Convert to net_device_ops

Joe Perches (1):
      sctp/ipv6.c: use ipv6_addr_copy

Joel A. Fowler (1):
      ctcm: fix minor findings from code analysis tool

Johannes Berg (54):
      ssb/b43: add new N PHY device
      b43: detect N PHY revision/radio
      mac80211: clean up set_key callback
      mac80211: remove user_power_level from driver API
      mac80211: clarify alignment docs, fix up alignment
      mac80211: clean up channel type config
      mac80211: validate SIOCSIWPOWER arguments better
      mac80211: move dynamic PS timeout to hardware config
      mac80211: extend/document powersave API
      cfg80211: add PM hooks
      mac80211: constify ieee80211_if_conf.bssid
      wireless: restrict to 32 legacy rates
      mac80211: Add capability to enable/disable beaconing
      mac80211: add interface list lock
      mac80211: don't try to powersave/config disabled interfaces
      mac80211: remove HW_SIGNAL_DB
      mac80211: convert to net_device_ops
      mac80211: convert master interface to netdev_ops
      zd1211rw: do not ratelimit no-ops
      mac80211: disable IBSS beacon before join
      zd1211rw: honour enable_beacon conf
      mac80211: properly validate/translate IW_AUTH_MFP values
      mac80211: reject extra IEs for probe request when hw_scan
      mac80211: fix beacon enable more
      mac80211: remove bssid argument from prepare_for_handlers
      mac80211: remove stray aggregation debugfs definition
      mac80211: fix RX aggregation timeouts
      mac80211: restructure HT code
      mac80211: restrict aggregation to supported interface modes
      mac80211: hardware should not deny going back to legacy
      mac80211: document TX aggregation (and small cleanup)
      mac80211: fix race in TX aggregation
      mac80211: fix aggregation timer lockups
      mac80211: clean up BA session teardown
      mac80211: RX aggregation: clean up stop session
      mac80211: further cleanups to stopping BA sessions
      cfg80211/nl80211: scanning (and mac80211 update to use it)
      mac80211: dont add BSS when creating IBSS
      cfg80211: free_priv for BSS info
      cfg80211: allow users to request removing a BSS
      cfg80211: add more flexible BSS lookup
      mac80211: use cfg80211s BSS infrastructure
      mac80211: calculate wstats_flags on the fly
      mac80211: fix IBSS auth
      mac80211: split managed/ibss code a little more
      mac80211: disallow moving netns
      mac80211: fix aggregation for hardware with ampdu queues
      mac80211: split IBSS/managed code
      cfg80211/mac80211: fill qual.qual value/adjust max_qual.qual
      mac80211: add missing kernel-doc
      nl80211: remove admin requirement from station get
      cfg80211: clean up signal type
      mac80211/cfg80211: move iwrange handler to cfg80211
      mac80211: Fix quality reporting for wireless stats

John Daiker (4):
      b43: checkpatch.pl cleanups
      airo_cs: checkpatch.pl cleanups
      atmel: checkpatch.pl cleanups
      ray_cs: checkpatch.pl and Lindent cleanups

John Dykstra (1):
      tcp: Discard segments that ack data not yet sent

John W. Linville (2):
      airo: correct improper initialization of local variable
      iwlagn: default to MAX_UCODE_BEACON_INTERVAL in iwl_adjust_beacon_interval

Josh Stone (1):
      net: Add dependent headers to trace/skb.h

Jouni Malinen (49):
      mac80211: 802.11w - STA flag for MFP
      mac80211: 802.11w - CCMP for management frames
      mac80211: 802.11w - Add BIP (AES-128-CMAC)
      mac80211: 802.11w - Use BIP (AES-128-CMAC)
      mac80211: 802.11w - WEXT parameter for setting mgmt cipher
      mac80211: 802.11w - WEXT configuration for IGTK
      mac80211: 802.11w - Configuration of MFP disabled/optional/required
      mac80211: 802.11w - SA Query processing
      mac80211: 802.11w - Do not force Action frames to disable encryption
      mac80211: 802.11w - Drop unprotected robust management frames if MFP is used
      mac80211: 802.11w - Implement Association Comeback processing
      mac80211: 802.11w - Optional software CCMP for management frames
      mac80211: 802.11w - Add driver capability flag for MFP
      ath9k: Fix set_key error codes
      ath9k: Setup MFP options for CCMP
      mac80211_hwsim: Report driver as MFP capable
      mac80211: Mark ieee80211_process_sa_query_req() static
      mac80211: Fix radiotap header it_present on big endian CPUs
      nl80211: Fix documentation errors
      ath9k: Use a defined value for pci_set_power_state()
      nl80211: New command for adding extra IE(s) into management frames
      mac80211: Fix drop-unencrypted for management frames
      mac80211: Fix MFP Association Comeback to use Timeout Interval IE
      nl80211: Optional IEs into scan request
      nl80211: Provide access to STA TX/RX packet counters
      ath9k: Unlock sc->mutex on error path
      nl80211: Avoid AP mode BUG_ON hang with invalid lock assert
      ath9k: Add module parameter to disable hardware crypto
      ath9k: Fix hw crypto configuration for TKIP in AP mode
      ath9k: Document keycache operations
      ath9k: Remove unused key xoring
      ath9k: Clean up setkey operations
      ath9k: Cleanup multiple VIF processing
      ath9k: Set BSSID mask based on configured interfaces
      ath9k: Add data structure for supporting virtual radio/wiphy operation
      ath9k: Add support for multiple secondary virtual wiphys
      ath9k: Configure RX filter for multi-BSSID broadcast
      ath9k: Virtual wiphy pause/unpause functionality
      ath9k: Add routines for switching between active virtual wiphys
      ath9k: Make start/stop operations aware of virtual wiphys
      ath9k: Register larger listen interval
      ath9k: Pause other virtual wiphys on channel change
      ath9k: Check virtual wiphy state on tx()
      ath9k: Add workaround to recover from failed channel changes
      ath9k: Special processing for channel changes during scan
      ath9k: Add a simple virtual wiphy scheduler
      ath9k: Add a debugfs interface for controlling virtual wiphys
      mac80211: Fix WMM ACM parsing and AC downgrade operation
      ath9k: Fix FIF_PROMISC_IN_BSS processing in station mode

Kalle Valo (6):
      mac80211: make wake/stop_queue_by_reason() functions static
      mac80211: remove multicast check from check_tim()
      mac80211: use ps-poll when dynamic power save mode is disabled
      at76c50x-usb: add driver
      at76c50x-usb: add link to the TODO list
      at76c50x-usb: use dev_name() instead of struct device.bus_id

Kay Sievers (3):
      net: struct device - replace bus_id with dev_name(), dev_set_name()
      wimax: struct device - replace bus_id with dev_name(), dev_set_name()
      qeth: struct device - replace bus_id with dev_name(), dev_set_name()

Klaus-Dieter Wacker (3):
      Use kthread instead of kernel_thread
      lcs: invalid return codes from hard_start_xmit.
      qeth: unregister MAC addresses during recovery.

Kolekar, Abhijeet (15):
      iwl3945: Change IWLWIFI_VERSION constant name
      iwl3945: include iwl-core.h
      iwl3945: replace iwl_3945_cfg with iwl_cfg
      iwl3945: move structures from iwl-3945.h to iwl-dev.h
      iwl3945: remove duplicate structures from iwl-3945.h
      iwl3945: replace iwl3945_broadcast_addr with iwl_bcast_addr
      iwl3945: use iwl_mod_params for 3945
      iwl3945: cleanup and remove duplicate code
      iwl3945: add load ucode op
      iwl3945: add apm ops
      iwl3945: add set_pwr_src
      iwl3945: simplify iwl3945_pci_probe
      iwl3945: release resources before shutting down
      iwl3945: use iwl_get_hw_mode
      iwl3945: adding utils ops

Krishna Kumar (1):
      net: Optimize skb_tx_hash() by eliminating a comparison

Krzysztof Ha≈Çasa (3):
      WAN: Generic HDLC now uses IFF_WAN_HDLC private flag.
      WAN: Allow hw HDLC drivers to override dev->get_stats.
      WAN: Convert generic HDLC drivers to netdev_ops.

Kumar Gala (1):
      gianfar: pass the proper dev to DMA ops

Larry Finger (4):
      b43: Eliminate compilation warning in b43_op_set_key
      rtl8187: Fix locking of private data
      rtl8187: Increase receive queue depth
      rtl8187: Fix driver to return TX retry info for RTL8187L

Lennert Buytenhek (14):
      mv643xx_eth: unify ethtool ops for phy'd and phy-less interfaces
      mv643xx_eth: rework interrupt coalescing, and export via ethtool
      mv643xx_eth: implement ethtool rx/tx ring size query and resizing
      mv643xx_eth: export rx csum get/set methods via ethtool
      mv643xx_eth: allow enabling/disabling tx checksumming via ethtool
      mv643xx_eth: implement Large Receive Offload
      mv643xx_eth: make LRO unconditional
      mv643xx_eth: convert to net_device_ops
      mv643xx_eth: move a couple of init actions from ->open() to port probe
      mv643xx_eth: set sane default receive coalescing timeout
      mwl8k: Marvell TOPDOG wireless driver
      dsa: set ->iflink on slave interfaces to the ifindex of the parent
      dsa: add support for the Marvell 88E6095/6095F switch chips
      dsa: add switch chip cascading support

Li Yang (1):
      gianfar: reallocate skb when headroom is not enough for fcb

Lucas Nussbaum (1):
      sctp: Allow to disable SCTP checksums via module parameter

Luis R. Rodriguez (73):
      mac80211: add HT conf helpers
      ath9k: use hw->conf on ath_setcurmode()
      ath9k: remove cache of rate preference when using 11g protection
      ath9k: Rename ath_setcurmode() to ath_cache_conf_rate()
      ath9k: consolidate arguments on hw reset
      ath9k: make request to get the noisefloor threshold band specific
      ath9k: use ieee80211_conf on ath9k_hw_iscal_supported()
      ath9k: make use of conf_is_ht*() in the rest of the driver
      iwlwifi: make use of conf_is_ht*() helpers
      mac80211: no need for ht.enabled
      ath9k: Make ANI CCK and OFDM error triggers band specific
      ath9k: remove mode specific default noise floor values
      ath9k: remove ath9k_hw_chan2wmode()
      ath9k: remove ath9k_hw_check_chan()
      ath9k: remove superfluous check on changing channel
      ath9k: fix sparse warnings
      cfg80211: call reg_notifier() once
      cfg80211: allow multiple driver regulatory_hints()
      cfg80211: fix typo on message after intersection
      cfg80211: add wiphy_apply_custom_regulatory()
      cfg80211: export freq_reg_info()
      cfg80211: process user requests only after previous user/driver/core requests
      cfg80211: ignore consecutive equal regulatory hints
      cfg80211: rename fw_handles_regulatory to custom_regulatory
      cfg80211: move check for ignore_reg_update() on wiphy_update_regulatory()
      cfg80211: pass more detailed regulatory request information on reg_notifier()
      cfg80211: Allow for strict regulatory settings
      mac80211: allow mac80211 drivers to get to struct ieee80211_hw from wiphy
      cfg80211: allow users to help a driver's compliance
      ath9k: simplify regulatory code
      ath9k: fix debug print on regd
      ath9k: remove useless ath9k driver version information
      cfg80211: do not pass -EALREADY to userspace on regdomain change request
      ath9k: replace usage of internal wireless_modes for conf
      ath9k: move check for radar freqs into a helper
      ath9k: remove passive scan on 5 GHz if country IE knows better
      mac80211: do not TX injected frames when not allowed
      cfg80211: add get reg command
      ath9k: fix reg_notifier() flags used upon a country IE
      ath9k: add comments for ath9k_hw_configpcipowersave()
      ath9k: add udelay() for AR5416 on ath9k_hw_configpcipowersave()
      cfg80211: rename cfg80211_registered_device's idx to wiphy_idx
      cfg80211: add wiphy_idx_valid to check for wiphy_idx sanity
      cfg80211: rename cfg80211_drv_mutex to cfg80211_mutex
      nl80211: disallow user requests prior to regulatory_init()
      cfg80211: add regulatory_hint_core() to separate the core reg hint
      cfg80211: propagate -ENOMEM during regulatory_init()
      cfg80211: add assert_cfg80211_lock() to ensure proper protection
      cfg80211: make regulatory_request use wiphy_idx instead of wiphy
      cfg80211: protect first access of last_request on 11d hint under mutex
      cfg80211: remove likely from an 11d hint case
      cfg80211: free rd on unlikely event on 11d hint
      cfg80211: move all regulatory hints to workqueue
      cfg80211: comments style cleanup
      cfg80211: allow drivers that agree on regulatory to agree
      cfg80211: rename regdom_changed to regdom_changes() and use it
      cfg80211: enable active-scan / beaconing on Ch 1-11 for world regdom
      cfg80211: enable 5 GHz world roaming channels
      cfg80211: Add AP beacon regulatory hints
      ath9k: follow beacon hints on reg_notifier when world roaming
      cfg80211: make __regulatory_hint() static
      cfg80211: pass the regulatory_request struct in __regulatory_hint()
      cfg80211: do not kzalloc() again for a new request on __regulatory_hint
      cfg80211: pass the regulatory_request to ignore_request
      mac80211_hwsim: add support for 5 GHz
      cfg80211: Enable passive scan on channels 12-14 for world roaming
      cfg80211: fix max tx power for world regdom on 5 GHz to 20dBm
      cfg80211: remove REGDOM_SET_BY_INIT
      cfg80211: move enum reg_set_by to nl80211.h
      cfg80211: add regulatory netlink multicast group
      mac80211_hwsim: add regulatory testing options
      ath9k: downgrade xmit queue full message to xmit debug
      ath9k: make few eeprom and calib items static

Maciej Sosnowski (1):
      igb: switch to new dca API

Magnus Damm (1):
      smc91x: struct net_device_ops

Marcel Holtmann (31):
      Bluetooth: Preparation for usage of SOL_BLUETOOTH
      Bluetooth: Add global deferred socket parameter
      Bluetooth: Add support for deferring RFCOMM connection setup
      Bluetooth: Add support for deferring L2CAP connection setup
      Bluetooth: Reject incoming SCO connections without listeners
      Bluetooth: Fix SCO state handling for incoming connections
      Bluetooth: Add enhanced security model for Simple Pairing
      Bluetooth: Replace L2CAP link mode with security level
      Bluetooth: Replace RFCOMM link mode with security level
      Bluetooth: Pause RFCOMM TX when encryption drops
      Bluetooth: Disconnect L2CAP connections without encryption
      Bluetooth: Restrict application of socket options
      Bluetooth: Update version numbers
      Bluetooth: Submit bulk URBs along with interrupt URBs
      Bluetooth: Don't check encryption for L2CAP raw sockets
      Bluetooth: Add SCO fallback for eSCO connection attempts
      Bluetooth: Use general bonding whenever possible
      Bluetooth: Set authentication requirements if not available
      Bluetooth: Fix race condition with L2CAP information request
      Bluetooth: Fix double L2CAP connection request
      Bluetooth: Don't enforce authentication for L2CAP PSM 1 and 3
      Bluetooth: Request L2CAP fixed channel list if available
      Bluetooth: Add CID field to L2CAP socket address structure
      Bluetooth: Ask upper layers for HCI disconnect reason
      Bluetooth: Fix authentication requirements for L2CAP security check
      Bluetooth: Set authentication requirement before requesting it
      Bluetooth: Fix poll() misbehavior when using BT_DEFER_SETUP
      Bluetooth: Change RFCOMM to use BT_CONNECT2 for BT_DEFER_SETUP
      Bluetooth: Disallow usage of L2CAP CID setting for now
      Bluetooth: Fix RFCOMM usage of in-kernel L2CAP sockets
      Bluetooth: Permit BT_SECURITY also for L2CAP raw sockets

Marcin Slusarz (1):
      phylib: convert state_queue work to delayed_work

Mark H. Weaver (1):
      netfilter: nf_conntrack_tcp: fix unaligned memory access in tcp_sack

Mark McLoughlin (1):
      virtio_net: add link status handling

Masakazu Mokuno (2):
      PS3: gelic: convert the ethernet part to net_device_ops
      PS3: gelic: wireless: convert the wireless part to net_device_ops

Matt Carlson (14):
      tg3: Fix 5906 link problems
      tg3: Drop non-VLAN rx pkts larger than the MTU
      tg3: Update ethtool set_settings error checks
      tg3: Refine tg3_vlan_rx_register()
      tg3: Eliminate nvram routine forward declarations
      tg3: Invert nvram_read() and nvram_read_swab()
      tg3: Correct NVRAM stream endian notations
      tg3: Eliminate tg3_nvram_read_swab()
      tg3: Refactor firmware version routines
      tg3: Add legacy bootcode version decoding
      tg3: Add DASH firmware version reporting
      tg3: Add version reporting for hardware selfboot
      tg3: Update copyright and version
      Update TG3 MAINTAINERS entry

Michael Buesch (33):
      b43: Fixup set_key handling
      b43: Use 64bit atomic register access for TSF
      b43/ssb: Add SPROM8 extraction and LP-PHY detection
      b43: Change schedule for old-fw support removal
      b43: Automatically probe for opensource firmware
      b43: Fix phy_g.c compiler warning
      b43: Dynamically control log verbosity
      b43: Add LP-PHY register definitions
      b43: Add LP-PHY baseband init for >=rev2
      b43: Add LP 2062 radio init
      ssb: Add PMU support
      b43: Port spec bugfixes for the LP baseband init
      b43: (b2062) Fix crystal frequency calculations
      b43: Add parts of LP-PHY TX power control
      b43: Move DMA stop sanity check
      b43: Fix DMA buffer size handling
      b43: Optimize DMA buffers
      b43: Add slot count compiletime assertion
      b43: Fix radio host flags
      b43: Honor the no-slow-clock boardflag
      b43: Enable PCI slow clock workaround, if needed.
      mac80211: Add software scan notifiers
      b43: Implement sw scan callbacks
      b43: Convert usage of b43_phy_set()
      b43: Convert usage of b43_phy_mask()
      b43: Convert usage of b43_phy_maskset()
      b43: Convert usage of b43_radio_set()
      b43: Convert usage of b43_radio_mask()
      b43: Convert usage of b43_radio_maskset()
      b43: Remove bogus integer truncation warnings
      ssb: Add SPROM fallback support
      b43: Pass more RX flags to mac80211
      b43: Fix compilation for devices without PCI core

Michael Tokarev (1):
      tun: Check supplemental groups in TUN/TAP driver.

Mike Rapoport (1):
      libertas: if_spi: add ability to call board specific setup/teardown methods

Mikhail Zolotaryov (1):
      powerpc 4xx EMAC driver: device name reported on timeout is not correct

Mohamed Abbas (1):
      iwlagn: fix warning when set WEP key

Nathan Williams (1):
      solos: Automatically determine number of ports

Neil Horman (4):
      Network Drop Monitor: Add trace declaration for skb frees
      Network Drop Monitor: Adding kfree_skb_clean for non-drops and modifying end-of-line points for skbs
      Network Drop Monitor: Adding drop monitor implementation & Netlink protocol
      Network Drop Monitor: Adding Build changes to enable drop monitor

Nick Kossifidis (10):
      ath5k: Update EEPROM code
      ath5k: More EEPROM code updates
      ath5k: Minor QCU updates
      ath5k: PHY code cleanup
      ath5k: Update gain_F calibration code and add documentation
      ath5k: Update RF Buffer handling
      ath5k: Update initvals
      ath5k: Update reset code
      ath5k: Disable BMISS interrupts
      ath5k: Don't call reset on config_interface

PJ Waskiewicz (11):
      ixgbe: Add hardware specific initialization code for 82599 devices
      ixgbe: Add DCB for 82599, remove BCN support
      ixgbe: Add 82599 device id's, hook it up into the main driver.
      ixgbe: Fix get_supported_physical_layer() due to new 82599 PHY types
      ixgbe: Fix an accounting problem when the Rx FIFO is full
      ixgbe: Disable DROP_EN for Rx queues
      ixgbe: Two small fixes for 82599 when bringing the device down and for WoL
      ixgbe: Add documentation for the driver
      ixgbe: Fix PCI bus reporting on driver load for 82598 after 82599 merge
      ixgbe: Correctly report Wake On LAN for 82599 KX4 devices
      ixgbe: Allow Priority Flow Control settings to survive a device reset

Pablo Neira Ayuso (11):
      netlink: change return-value logic of netlink_broadcast()
      netlink: add NETLINK_BROADCAST_ERROR socket option
      netfilter: nf_conntrack: account packets drop by tcp_packet()
      netlink: change nlmsg_notify() return value logic
      netfilter: conntrack: increase drop stats if sequence adjustment fails
      netfilter: ctnetlink: cleanup master conntrack assignation
      netfilter: ctnetlink: cleanup conntrack update preliminary checkings
      netfilter: ctnetlink: move event reporting for new entries outside the lock
      netfilter: xtables: add cluster match
      nefilter: nfnetlink: add nfnetlink_set_err and use it in ctnetlink
      netlink: add NETLINK_NO_ENOBUFS socket flag

Patrick McHardy (1):
      netfilter: ctnetlink: fix rcu context imbalance

Patrick Ohly (11):
      clocksource: allow usage independent of timekeeping.c
      timecompare: generic infrastructure to map between two time bases
      net: new user space API for time stamping of incoming and outgoing packets
      net: infrastructure for hardware time stamping
      net: socket infrastructure for SO_TIMESTAMPING
      ip: support for TX timestamps on UDP and RAW sockets
      net: pass new SIOCSHWTSTAMP through to device drivers
      igb: access to NIC time
      igb: stub support for SIOCSHWTSTAMP
      igb: use timecompare to implement hardware time stamping
      net: kernel panic in dev_hard_start_xmit: remove faulty software TX time stamping

Paul Bolle (1):
      gigaset: return -ENOTTY for unimplemented functions

Paulius Zaleckas (3):
      ppp_generic: Simplify tx_dropped stats
      hso: remove claiming and releasing of USB interface
      hso: remove hso_free_device()

Pavel Roskin (1):
      bmac: remove unused variable bp in bmac_misc_intr()

Peter P Waskiewicz Jr (8):
      ixgbe: Refactor MSI-X allocation mechanism
      ixgbe: Update copyright dates, bump the driver version number
      ixgbe: Refactor set_num_queues() and cache_ring_register()
      ixgbe: Update link setup code to better support autonegotiation of speed
      ixgbe: Display EEPROM version in ethtool -i queries
      ixgbe: Update flow control state machine in link setup
      ixgbe: Defeature Tx Head writeback
      ixgbe: Fix a set_num_queues() bug that can result in num_(r|t)x_queues = 0

Rami Rosen (9):
      mac80211: remove an unnecessary assignment to info in __ieee80211_tx().
      mac80211: remove an unused parameter in ieee80211_rx_mgmt_probe_req().
      mac80211: remove an unused definition (MAX_STA_COUNT) in sta_info.h.
      mac80211: remove unused variable in ieee80211_local (dot11WEPUndecryptableCount).
      mac80211: remove mesh_plink_close() method.
      mac80211: trivial documentation fixes (enum mesh_path_flags).
      mac80211: trivial documentation fix (mesh_nexthop_lookup()).
      tcp: remove parameter from tcp_recv_urg().
      net: core: remove unneeded include in net/core/utils.c.

Randy Dunlap (4):
      wireless: fix for CONFIG_NL80211=n
      skbuff.h: fix timestamps kernel-doc
      rds: fix iband RDMA dependencies
      wimax: fix i2400m printk formats

Reinette Chatre (8):
      iwlwifi: update copyright year to 2009
      iwlwifi: fix FAT channel config for 5000 series
      iwlwifi: use singlethread workqueue
      iwlwifi: Fix and rework Kconfig file
      iwlwifi: fix *pci_probe error flow
      iwl3945: unmap previously mapped memory
      iwlwifi: print contents of control register when error occurs
      iwlwifi: correct log level when error occurs

Richard Kennedy (1):
      ipv6: reorder struct inet6_ifaddr to remove padding on 64 bit builds

Rick Farrington (1):
      iwlagn: reduce off channel reception for 4965

Roel Kluin (11):
      phylib: unsigneds go unnoticed
      ath5k: notice a negative keytype
      libertas: pos[4] tested twice, 2nd should be pos[5]
      atm: Add missing parentheses
      wavelan: Test arraysize before an element of the array.
      p54: misplaced parentheses
      b43: Fix LO calibration txctl reg value
      wireless, wavelan: spin off by 1
      x25: '< 0' and '>= 0' test on unsigned
      tcp: '< 0' test on unsigned
      ctcm: avoid wraparound in length of incoming data

Ron Mercer (33):
      qlge: Clean up mac address and frame route settings.
      qlge: Increase MAC addr hw sem granularity.
      qlge: Change frame route hw semaphore granularity.
      qlge: Optimize rx buffer refill process.
      qlge: Use one path to (re)fill rx buffers.
      qlge: Add defines for firmware support.
      qlge: Clean up firmware reset path.
      qlge: Move firmware event handler.
      qlge: Prepare to add new device.
      qlge: Reduce debug print output.
      qlge: Add support for firmware mailbox commands.
      qlge: Add support for device ID 8000.
      qlge: Add support for getting/setting port config.
      qlge: Add firmware support for insert/remove SFP.
      qlge: Clean up link down processing.
      qlge: Clean up link up processing.
      qlge: Add worker-handler for firmware events.
      qlge: Clean up event handler for firmware init.
      qlge: Improve handling for firmware init failure.
      qlge: Save status from firmware crash (system err).
      qlge: Add support for lost firmware events.
      qlge: Move reset logic into asic_reset_worker func.
      qlge: Remove debug junk from asic reset logic.
      qlge: Increase filtering for inbound csum settings.
      qlge: Add support for GRO.
      qlge: Add tx multiqueue support.
      qlge: bugfix: Tell hw to strip vlan header.
      qlge: Get rid of irqsave/restore in intr disable.
      qlge: Clear shadow registers before use.
      qlge: Remove spinlock from asic init path.
      qlge: bugfix: Move netif_napi_del() to common call point.
      qlge: bugfix: Pad outbound frames smaller than 60 bytes.
      qlge: bugfix: Fix endian issue related to rx buffers.

Russell King (1):
      etherh: Get working again.

Samuel Ortiz (27):
      iwl3945: Getting rid of iwl-3945-debug.h
      iwl3945: Remove DRV_NAME dependenies
      iwl3945: Getting rid of iwl3945_eeprom_channel
      iwl3945: Have consistant and not redefined HW constants
      iwl3945: Use iwl-agn-rs.h rates definitions.
      iwl3945: Getting rid of iwl-3945-led.h
      iwl3945: Remove power related definitions from 3945 code
      iwl3945: iwl3945_queue and iwl3945_channel_info replacement
      iwl3945: sync tx queue data structure with iwlagn
      iwl3945: switch to the iwl-core send_card_state routine
      iwl3945: Change crypto parameter name
      iwl3945: Fix iwl3945_init_drv()
      iwl3945: Use iwl_txq_update_write_ptr
      iwlwifi: Add TFD library operations
      iwl3945: Use iwl-hcmd host command routines
      iwl3945: Use iwl-rfkill
      iwl3945: Define send_tx_power
      iwl3945: Use iwlcore scan code
      iwlwifi: make iwl_tx_queue->tfds void*
      iwl3945: Use iwlcore TX queue management routines
      iwl3945: Use iwl-eeprom.c routines
      iwl3945: Use the iwlcore geos routines
      iwlwifi: Remove IWL3945_DEBUG
      iwl3945: Getting rid of priv->antenna
      iwl3945: Add restart_fw module parameter
      iwl3945: Remaining host command cleanups
      iwl3945: Getting rid of the *39_rxon iwl_priv fields

Santwona Behera (2):
      ethtool: Add RX pkt classification interface
      niu: Add TCAM classification configuration

Sascha Hauer (9):
      fec: remove unused #else branches
      fec: remove empty functions
      fec: use linux/*.h instead of asm/*.h
      fec: do not use memcpy on physical addresses
      fec: use dma_alloc_coherent for descriptor ring
      fec: Fix KS8721BL_ICSR phy register offset
      fec: replace flush_dcache_range with dma_sync_single
      fec: Add support for Freescale MX27
      FEC: Turn FEC driver into platform device driver

Sathya Perla (1):
      be2net: cleanup rx/tx rate calculations

Scott Feldman (4):
      enic: bug fix: return notify intr credits
      enic: record all bad FCS errs as frame errors
      enic: bug fix: tx_timeout reset path fix-ups
      enic: Add api for link down count and to get firmware notification status.

Scott James Remnant (2):
      netfilter: auto-load ip6_queue module when socket opened
      netfilter: auto-load ip_queue module when socket opened

Senthil Balasubramanian (7):
      ath9k: INI update for Atheros AR9280 and AR9285 chipset.
      ath9k: Fix AR9285 specific noise floor eeprom reads.
      ath9k: Add open loop control support
      ath9k: Get rid of unnecessary ATOMIC memory alloc during init time
      ath9k: RX buffers may be accessed/freed even before initialized/alloced.
      ath9k: INI update for AR9285 and periodic PA offset caliberation
      ath9k: Incorrect AR9285 version check macro

Shannon Nelson (1):
      ixgbe: Move ring features into an enum, allowing easier future maintenance

Simon Farnsworth (2):
      solos: Slight debugging improvements
      solos: FPGA and firmware update support.

Stephen Hemminger (164):
      atm: br2684 internal stats
      br2684: convert to net_device_ops
      clip: convert to internal network_device_stats
      lec: convert to internal network_device_stats
      lec: convert to net_device_ops
      netrom: convert to internal net_device_stats
      netrom: convert to net_device_ops
      rose: convert to internal net_device_stats
      rose: convert to network_device_ops
      appletalk: remove unneeded stubs
      arcnet: convert to internal stats
      arcnet: convert to net_device_ops
      com20020: convert to net_devic_ops
      3c501: convert to net_device_ops
      3c505: convert to net_device_ops
      3c507: convert to net_device_ops
      3c509: convert to net_device_ops
      3c515: convert to net_device_ops
      3c523: convert to net_device_ops
      3c527: convert to net_device_ops
      3c59x: convert to net_device_ops
      ibmtr: convert to internal network_device_stats
      ibmtr: convert to net_device_ops
      lanstreamer: convert to internal network stats
      lanstreamer: convert to net_device_ops
      olympic: convert to internal network device stats
      olympic: convert to net_device_ops
      tms380tr: convert to net_device_ops
      3c559: convert to net_device_ops
      znet: convert to net_device_ops
      6pack: convert to net_device_ops
      baycom: convert to internal net_device_stats
      baycom: convert to net_device_ops
      bpqether: convert to internal net_device_stats
      bpqether: convert to net_device_ops
      dmascc: convert to internal network device stats
      dmascc: convert to network_device_ops
      hdlcdrv: convert to internal net_device_stats
      hdlcdrv: convert to net_device_ops
      yam: convert to internal net_device_stats
      yam: convert to net_device_ops
      scc: convert to internal net_device_ops
      mkiss: convert to internal network device stats
      dmascc: convert to net_device_ops
      dmascc: convert to internal net_device_ops
      net: add ARP notify option for devices
      inet: Fix virt-manager regression due to bind(0) changes.
      sky2: remove unneede workaround
      sky2: handle dma mapping errors
      sky2: move VPD display into debug interface
      sky2: set VPD size
      netfilter: x_tables: change elements in x_tables
      netfilter: x_tables: remove unneeded initializations
      netfilter: ebtables: remove unneeded initializations
      netfilter: iptables: lock free counters
      ip: add loose reverse path filtering
      ip: ipip compile warning
      llc: fix non-const printk warning
      snap: handle registration error and compile warning
      tulip: get rid of warning for non-const string literal
      lapb: get rid of non-const printk warning
      3c59x: get rid of non-const printk warnings
      ne2k-pci: fix non-constant printk warnings
      sis900: fix non-constant printk warnings
      yellowfin: fix non-constant printk warnings
      acenic: fix non-constant printk warnings
      natsemi: fix non-constant printk warnings
      fealnx: fix non-constant printk warnings
      via-rhine: fix non-constant printk warnings
      starfire: fix non-constant printk warnings
      sundance: fix non-constant printk warnings
      hamachi: fix non-constant printk warnings
      forcedeth: fix non-constant printk warnings
      mdio: fix non-constant printk warnings
      net: convert usage of packet_type to read_mostly
      net: fix warning about non-const string
      netfilter: Kconfig spelling fixes (trivial)
      tipc: fix non-const printf format arguments
      rtnetlink: add new value for DHCP added routes
      atm: lec use dev_change_mtu
      skb: expose and constify hash primitives
      ixgbe: fix select_queue management
      snap: use const for descriptor
      ipx: use constant for strings and desciptor
      atm: fix non-const printk argument
      eql: fix non-constant printk warning
      atm: convert mpc device to using netdev_ops
      atm: convert clip driver to net_device_ops
      infiniband: convert c2 to net_device_ops
      infiniband: convert nes driver to net_device_ops
      infiniband: convert ipoib to net_device_ops
      irda: net_device_ops ioctl fix
      irlan: convert to net_device_ops
      irda: convert irda_usb to net_device_ops
      irda: convert mcs driver to net_device_ops
      stir4200: convert to net_device_ops
      irda: convert w83977af_ir to net_device_ops
      irda: convert nsc_ircc driver to net_device_ops
      irda: convert ali driver to net_device_ops
      irda: convert vlsi driver to net_device_ops
      irda: convert smsc driver to net_device_ops
      irda: convert via-ircc to net_device_ops
      irda: convert sir device to net_device_ops
      irda: convert kingsun device to net_device_ops
      irda: convert ksdazzle device to net_device_ops
      irda: convert ks959 driver to net_device_ops
      usbnet: convert catc to internal net_device_stats
      usbnet: convert catc device to net_device_ops
      usbnet: convert to internal net_device stats
      usbnet: convert rtl driver to net_device_ops
      usbnet: convert hso driver to net_device_ops
      usbnet: convert to internal net_device_stats
      usbnet: support net_device_ops
      usbnet: convert asix driver to net_device_ops
      usbnet: convert dms9601 driver to net_device_ops
      usbnet: convert msc7830 driver to net_device_ops
      usbnet: convert smsc95xx driver to net_device_ops
      usbnet: convert rndis driver to use dev_get_stats
      usbnet: convert rndis driver to net_device_ops
      pcmcia: convert 3c589 to net_device_ops
      pcmcia: convert 3c574 to net_device_ops
      pcmcia: convert fmvj18x driver to internal net_device_stats
      pcmcia: convert fmvj18x driver to net_device_ops
      pcmcia: convert nmclan driver to net_device_ops
      pcnet: convert driver to net_device_ops
      xir2cps: convert to internal net_device stats
      xirc2ps: convert to net_device_ops
      smc91c92: convert to internal net_device_stats
      smc91c92: convert to net_device_ops
      axnet: convert to net_device_ops
      x25_asy: convert to internal net_device_stats
      x25_asy: convert to net_device_ops
      dlci: convert to internal net_device_stats
      dlci: convert to net_device_ops
      cycx: convert to net_device_ops
      lapbether: convert to internal net_device_stats
      labether: convert to net_device_ops
      sbni: use internal net_device_stats
      sbni: convert to net_device_ops
      netwave: convert to internal net_device_stats
      netwave: convert to net_device_ops
      strip: convert to net_device_ops
      wavelan: convert to internal net_device_stats
      wavelan: convert to net_device_ops
      airo: convert to net_device_ops
      atmel: convert to net_device_ops
      raylan: convert to net_device_ops
      wl3501: convert to internal net_device_stats
      wl3501: convert to net_device_ops
      zd1201: convert to internal net_device_stats
      zd1201: convert to net_device_ops
      mac80211_hwsim: convert to net_device_ops
      prism54: convert to net_device_ops
      prism54: convert to internal net_device_stats
      libertas: convert to internal net_device_stats
      libertas: convert to net_device_ops
      ipw2x00: convert to internal net_device_stats
      ipw2x00: convert infrastructure for use by net_device_ops
      ipw2100: convert to net_device_ops
      ipw2200: convert to net_device_ops
      hostap: convert to internal net_device_stats
      hostap: convert to net_device_ops
      netdev: expose net_device_ops compat as config option
      bridge: bad error handling when adding invalid ether address

Steve Glendinning (14):
      smsc95xx: remove unused completion struct
      smsc95xx: fix function prototype of async callback
      smsc911x: leave RX_STOP interrupt permanently enabled
      smsc911x: add support for platform-specific irq flags
      smsc911x: register isr as IRQF_SHARED
      smsc911x: add external phy detection overrides
      smsc911x: allow mac address to be saved before device reset
      smsc911x: check for FFWD success before checking for timeout
      smsc911x: improve EEPROM loading timeout logic in open
      smsc911x: define status word positions as constants
      smsc911x: replace print_mac with %pM
      smsc911x: allow setting of mac address
      smsc9420: fix big endian rx checksum offload
      phy: add new LAN8710 and LAN8720 device ids to smsc phy driver

Sujith (76):
      mac80211: Add 802.11h CSA support
      ath9k: rateCodeToIndex is not used, remove it
      ath9k: Update short guard interval in rate control
      ath9k: Reorganize code in xmit.c
      ath9k: Remove ath_tx_stopdma and call ath9k_hw_stoptxdma directly
      ath9k: Merge queue draining functions
      ath9k: Add a helper function to wake mac80211 queues
      ath9k: Handle holding descriptor in TX completion properly
      ath9k: Revamp TX aggregation
      ath9k: Cleanup buffer type assignment
      mac80211: Add documentation bits for mac80211_rate_control_flags
      ath9k: Fix MCS rates registration bug for AR9285
      ath9k: Fix bug in rate control capability registration
      ath9k: Fix bug in NF calibration
      ath9k: Handle chainmask for A9280
      ath9k: Reconfigure beacons on getting a notification from mac80211
      ath9k: Fix station access in aggregation completion
      ath9k: Setup short preamble properly in rate registration
      ath9k: Fix bug in TX DMA termination
      ath9k: Fix lockdep warning
      mac80211: Reset assoc_scan_tries after an unsuccessful scan run
      ath9k: Fix typo in checking for chip revision
      ath9k: Remove a bunch of unused macros
      ath9k: Cleanup get_rate() interface
      ath9k: Handle mac80211's RC flags for MCS rates
      ath9k: Add debugfs files for printing TX rate details
      ath9k: Lock mac80211 callbacks with a mutex
      ath9k: Remove all the redundant internal buffer types
      ath9k: Handle mac80211's FIF_CONTROL flag properly
      ath9k: Add retry counters to rate control debug file
      ath9k: Header file cleanup
      ath9k: Convert ANI channel to a pointer
      ath9k: Remove all the sc_ prefixes
      ath9k: Store HW version information in a separate structure
      ath9k: Move regulatory information to a separate structure
      ath9k: Remove duplicate variables
      ath9k: Merge ath_hal and ath_hal_5416 structures
      ath9k: Add callbacks hooks for EEPROM operations
      ath9k: Cleanup EEPROM operations
      ath9k: Remove all the useless ah_ variable prefixes
      ath9k: Store the correct max TX power level
      ath9k: Fix rd_ext EEPROM capability for AR9285
      ath9k: Enable Fractional N mode
      ath9k: Enable TSF Out of Range Interrupt
      ath9k: Initialize AGC calibration properly
      ath9k: Fix bug in disabling MIB counters
      ath9k: Fix incorrect noise floor reading for 4k EEPROM
      ath9k: Decrease minimum NF threshold
      mac80211: Extend the rate control API with an update callback
      ath9k: Program the RTC registers correctly
      ath9k: Fix HW wait timeout
      ath9k: Fix antenna assignment bug in TX status processing
      ath9k: Initialize channel change time
      ath9k: Remove a few unused capability macros
      ath9k: Remove ath_txq_depth and get the queue depth directly
      ath9k: Use beacon interval directly
      ath9k: Remove multiple macro occurrences
      ath9k: Add PER to RC debug statistics
      ath9k: Fix bug in EEPROM chainmask retrieval
      ath9k: Fix PCI shutdown sequence
      ath9k: Add appropriate ANI values for AP mode
      mac80211: Notify the driver only when the beacon interval changes
      mac80211: Fix TKIP/WEP HT capability handling
      ath9k: Fill in rate_update mac80211 callback
      mac80211: Update IBSS beacon timestamp properly
      ath9k: Use new scan notifiers from mac80211
      ath9k: Scrub beacon.c
      ath9k: Cleanup beacon stuck processing
      ath9k: Split beacon configuration into mode specific routines
      ath9k: Handle TSF properly for AP mode
      ath9k: Lock config_interface() callback with a mutex
      ath9k: Remove unused variables in struct ath_beacon_config
      ath9k: Initialize ANI properly
      ath9k: Fix bug in TX aggregation
      ath9k: Fix bug in reading debugfs file 'rcstat'
      ath9k: Add spectrum management to HW capabilities

Thomas Gleixner (1):
      net: replace commatas with semicolons

Thomas Klein (4):
      ehea: Use net_device_ops structure
      ehea: Fix mem allocations which require page alignment
      ehea: Improve driver behaviour in low mem conditions
      ehea: Fix memory hotplug handling

Tilman Schmidt (1):
      gigaset: Kconfig cleanup

Timo Teras (2):
      gre: strict physical device binding
      gre: optimize hash lookup

Tobias Klauser (2):
      ath5k: Storage class should be before const qualifier
      orinoco: Storage class should be before const qualifier

Tomas Winkler (10):
      iwlwifi: 3945 extract flow handler definitions into iwl-3945-fh.h
      iwlwifi: 3945 unfold iwl-3945-commands.h
      iwlwifi: use iwl-commands.h also in 3945
      iwlwifi: 3945 remove duplicated code from iwl-3945-commands.h
      iwlwifi: 3945 drop usage of union tsf
      iwlwifi: 3945 remove iwl-3945-commands.h
      iwlwifi: clean up printing
      iwlwifi: don't use implicit priv in IWL_DEBUG
      iwlwifi: use pci registers defined in pci_regs.h
      iwlwifi: drop PCIe workaround applicable for development boards

Tomasz Lemiech (1):
      tulip: Fix for MTU problems with 802.1q tagged frames

Tulio Magno Quites Machado Filho (1):
      ath5k: support LED's on emachines E510 notebook

Ursula Braun (4):
      netiucv: invalid return code from hard_start_xmit
      claw: invalid return codes from hard_start_xmit
      ctcm: invalid return code from hard_start_xmit
      qeth: check for completion of a running recovery

Vasanthakumar Thiagarajan (18):
      mac80211: Scale down to non-HT association with TKIP/WEP as pairwise cipher
      mac80211: Fix tx power setting
      ath9k: Enable Bluetooth Coexistence support
      mac80211: Handle power constraint level advertised in 11d+h beacon
      ath9k: Fix basic connectivity issue
      ath9k: Fix typo in chip version check
      ath9k: Remove unnecessary gpio configuration in ath9k_hw_reset()
      ath9k: Remove unused ath9k_hw_select_antconfig() from hw.c
      ath9k: Clean up the way the eeprom antenna configuration is read
      ath9k: Fix LED blink pattern
      mac80211: Remove bss information of the current AP when it goes out of range
      mac80211: Free current bss information in few places where we don't need it any more
      mac80211: Make sure non-HT connection when IEEE80211_STA_TKIP_WEP_USED is set
      ath9k: Fix PTK/GTK handshake timeout
      ath9k: Filter out beacons from other BSS in STA mode
      ath9k: Configure Power control register appropriately for h/w with 4k eeprom
      ath9k: Remove ununsed ack duration stuff with long/short preamble
      ath9k: Use suitable macros with 4k eeprom data

Vernon Sauder (1):
      smc91x: enable ethtool EEPROM interface

Victor Shcherbatyuk (1):
      Bluetooth: Fix issue with return value of rfcomm_sock_sendmsg()

Vitaly Mayatskikh (1):
      udp: Wrong locking code in udp seq_file infrastructure

Vivek Natarajan (10):
      mac80211: Reset the power save timer from master_start_xmit.
      mac80211: A couple of fixes to dynamic power save.
      mac80211: Enhancements to dynamic power save.
      mac80211: Cancel the power save timer in ieee80211_stop.
      ath9k: Enable dynamic power save in ath9k.
      mac80211: Cancel the dynamic ps timer in ioctl_siwpower.
      ath9k: Enable MIB and TIM interrupts for station mode.
      mac80211: Fix the wrong WARN_ON message appearing on enabling power save.
      mac80211: Always send a null data frame if TIM bit is set.
      ath9k: Handle power modes in isr for power save.

Vlad Yasevich (10):
      sctp: Clean up sctp checksumming code
      sctp: Fix the RTO-doubling on idle-link heartbeats
      sctp: Inherit all socket options from parent correctly.
      sctp: Fix broken RTO-doubling for data retransmits
      sctp: simplify sctp listening code
      sctp: Clean up TEST_FRAME hacks.
      ipv6: Disallow binding to v4-mapped address on v6-only socket.
      ipv6: Allow ipv4 wildcard binds after ipv6 address binds
      ipv6: Make v4-mapped bindings consistent with IPv4
      ipv6: Fix conflict resolutions during ipv6 binding

Wei Yongjun (31):
      mac80211: cleanup kmalloc/memset -> kcalloc
      ipv6: Remove some pointless conditionals before kfree_skb()
      gre: used time_before for comparing jiffies
      ipip: used time_before for comparing jiffies
      sit: used time_before for comparing jiffies
      Bluetooth: Remove some pointless conditionals before kfree_skb()
      Bluetooth: Remove some pointless conditionals before kfree_skb()
      isdn: remove some pointless conditionals before kfree_skb()
      irda: remove some pointless conditionals before kfree_skb()
      ppp: remove some pointless conditionals before kfree_skb()
      drivers/net/rionet.c: remove some pointless conditionals before kfree_skb()
      i2400m: remove some pointless conditionals before kfree_skb()
      wan: remove some pointless conditionals before kfree_skb()
      af_key: remove some pointless conditionals before kfree_skb()
      pktgen: remove some pointless conditionals before kfree_skb()
      unix: remove some pointless conditionals before kfree_skb()
      netlink: remove some pointless conditionals before kfree_skb()
      can: remove some pointless conditionals before kfree_skb()
      packet: remove some pointless conditionals before kfree_skb()
      core: remove some pointless conditionals before kfree_skb()
      decnet: remove some pointless conditionals before kfree_skb()
      iucv: remove some pointless conditionals before kfree_skb()
      llc: remove some pointless conditionals before kfree_skb()
      chelsio: remove some pointless conditionals before kfree_skb()
      ns83820: remove some pointless conditionals before kfree_skb()
      sctp: Add some missing types for debug message
      sctp: remove dup code in net/sctp/socket.c
      sctp: fix the length check in sctp_getsockopt_maxburst()
      sctp: use time_before or time_after for comparing jiffies
      sctp: fix to indicate ASCONF support in INIT-ACK only if peer has such capable
      sctp: fix to send FORWARD-TSN chunk only if peer has such capable

Wey-Yi Guy (6):
      iwlwifi: add valid tx antenna information in rate_scale_table debugfs
      iwlwifi: add rf information in rate_scale debugfs command
      iwlwifi: remove un-necessary rs_tl_turn_on_agg() after agg enabled
      iwlwifi: HT performance improvement changes
      iwlwifi: check IEEE80211_TX_STAT_AMPDU for agg pkt
      iwlwifi: verify the antenna selection when receive fixed rate debugfs

Winkler, Tomas (29):
      iwlwifi: move sysfs status entry to debugfs
      iwlwifi: kill retry_rate sysfs for iwlagn
      iwlwifi: 3945 remove current_rate from station entry.
      iwlwifi: emliminate iwl3945_mac_get_stats mac80211 handler
      iwlwifi: replace IWL_WARNING with IWL_WARN
      iwlwifi: replace IWL_ERROR with IWL_ERR
      iwlwifi: use iwl_cmd instead of iwl3945_cmd
      iwl3945: use iwl_rb_status
      iwl3945: rearrange 3945 tfd
      iwl3945: use iwl3945_tx_cmd instead of iwl_tx_cmd
      iwl3945: use rx queue management infrastructure from iwlcore
      iwl3945: kill hw_params.tx_ant_num
      iwl3945: kill iwl3945_rx_queue_restock
      iwl3945: kill iwl3945_rx_queue_space
      iwl3945: kill iwl3945_x2_queue_used
      iwl3945: remove double defined 3945 tfd structures
      iwl3945: use hw_params.rx_buf_size
      iwlwifi: make iwl-power.c more readable
      iwlwifi: fix iwl_mac_set_key and iwl3945_mac_set_key
      iwlwifi: kill iwl3945_scan_cancel and iwl3945_scan_cancel_timeout
      iwlwifi: kill scan39
      iwlwifi: remove unused or twice defined members in iwl_priv
      iwlwifi: eliminate power_data_39.
      iwlwifi: fix probe mask for 39 scan API
      iwlwifi: iwl_tx_queue_alloc : fix warning in printk formatting
      iwlwifi: suppress unused variable warning when compiling w/o IWLWIFI_DEBUG
      iwlwifi: iwl3945_send_tx_power must be static
      iwlwifi: check return value of pci_enable_device
      iwlwifi: unify iwlagn and 3945 power save management

Wu Fengguang (1):
      iwlwifi: beautify code

Wu, Fengguang (1):
      iwlwifi: report correct and detailed values about requested txpower

Yang Hongyang (1):
      spider_net: Convert to net_device_ops.

Yinghai Lu (5):
      forcedeth: make msi-x different name for rx-tx
      forcedeth: don't clear nic_poll_irq too early
      forcedeth: disable irq at first before schedule rx
      forcedeth: ck804 and mcp55 doesn't need timerirq
      forcedeth: enable msix to default

Zhu Yi (1):
      iwlwifi: add more comments to IWL_DL_xx

dave graham (4):
      e1000e: Disable dynamic clock gating for 82571 per si errata.
      e1000e: remove RXSEQ link monitoring for serdes
      e1000e: Serdes - attempt autoneg when link restored.
      e1000e: Remove mutex_trylock and associated WARN on failure.

malc (1):
      sctp: add Adaptation Layer Indication parameter only when it's set

remi.denis-courmont@nokia (6):
      Phonet: move to Networking options like other protocol stacks
      Phonet: check destination before delivering packets locally
      Phonet: allow phonet_device_init() to fail, put it to __init section
      Phonet: handle rtnetlink registration failure
      Phonet: remove useless locking in device cleanup
      Phonet: use per-namespace devices list

vibi sreenivasan (1):
      macb: fix warning "warning: unused variable `dev' "

 Documentation/DocBook/mac80211.tmpl                |   12 +-
 Documentation/feature-removal-schedule.txt         |    4 +-
 Documentation/networking/dccp.txt                  |    3 +-
 Documentation/networking/ip-sysctl.txt             |  148 +-
 Documentation/networking/ixgbe.txt                 |  199 +
 Documentation/networking/rds.txt                   |  356 +
 Documentation/networking/timestamping.txt          |  180 +
 Documentation/networking/timestamping/.gitignore   |    1 +
 Documentation/networking/timestamping/Makefile     |    6 +
 .../networking/timestamping/timestamping.c         |  533 +
 Documentation/powerpc/dts-bindings/fsl/tsec.txt    |    6 +
 MAINTAINERS                                        |    8 +
 arch/alpha/include/asm/socket.h                    |    3 +
 arch/arm/include/asm/socket.h                      |    3 +
 arch/arm/mach-kirkwood/common.c                    |    5 +-
 arch/arm/mach-kirkwood/rd88f6281-setup.c           |   13 +-
 arch/arm/mach-orion5x/common.c                     |    5 +-
 arch/arm/mach-orion5x/rd88f5181l-fxo-setup.c       |    9 +-
 arch/arm/mach-orion5x/rd88f5181l-ge-setup.c        |   10 +-
 arch/arm/mach-orion5x/rd88f6183ap-ge-setup.c       |   10 +-
 arch/arm/mach-orion5x/wrt350n-v2-setup.c           |    9 +-
 arch/avr32/include/asm/socket.h                    |    3 +
 arch/blackfin/include/asm/socket.h                 |    3 +
 arch/cris/include/asm/socket.h                     |    3 +
 arch/h8300/include/asm/socket.h                    |    3 +
 arch/ia64/include/asm/socket.h                     |    3 +
 arch/m68k/include/asm/socket.h                     |    3 +
 arch/m68knommu/platform/520x/config.c              |   56 +
 arch/m68knommu/platform/523x/config.c              |   51 +
 arch/m68knommu/platform/5272/config.c              |   48 +
 arch/m68knommu/platform/527x/config.c              |  113 +-
 arch/m68knommu/platform/528x/config.c              |   58 +
 arch/m68knommu/platform/532x/config.c              |   49 +
 arch/mips/include/asm/socket.h                     |    3 +
 arch/parisc/include/asm/socket.h                   |    3 +
 arch/powerpc/include/asm/socket.h                  |    3 +
 arch/s390/include/asm/socket.h                     |    3 +
 arch/sh/include/asm/socket.h                       |    3 +
 arch/sparc/include/asm/socket.h                    |    3 +
 arch/x86/include/asm/socket.h                      |    3 +
 arch/xtensa/include/asm/socket.h                   |    3 +
 drivers/acpi/event.c                               |    6 +-
 drivers/atm/firestream.c                           |    8 +-
 drivers/atm/iphase.c                               |    4 +-
 drivers/atm/solos-attrlist.c                       |   70 +
 drivers/atm/solos-pci.c                            |  824 +-
 drivers/block/aoe/aoenet.c                         |    2 +-
 drivers/bluetooth/bfusb.c                          |    3 +-
 drivers/bluetooth/bt3c_cs.c                        |    4 +-
 drivers/bluetooth/btusb.c                          |   40 +-
 drivers/bluetooth/hci_h4.c                         |    3 +-
 drivers/bluetooth/hci_ll.c                         |    3 +-
 drivers/char/pcmcia/synclink_cs.c                  |   18 +-
 drivers/char/synclink.c                            |   18 +-
 drivers/char/synclink_gt.c                         |   18 +-
 drivers/char/synclinkmp.c                          |   18 +-
 drivers/connector/cn_queue.c                       |   80 +-
 drivers/connector/connector.c                      |   19 +-
 drivers/infiniband/hw/amso1100/c2.c                |   41 +-
 drivers/infiniband/hw/amso1100/c2.h                |    2 -
 drivers/infiniband/hw/amso1100/c2_provider.c       |   22 +-
 drivers/infiniband/hw/cxgb3/cxio_hal.c             |    3 +
 drivers/infiniband/hw/cxgb3/cxio_hal.h             |    2 +
 drivers/infiniband/hw/cxgb3/iwch.c                 |   15 +-
 drivers/infiniband/hw/nes/nes_hw.c                 |    2 +-
 drivers/infiniband/hw/nes/nes_nic.c                |   29 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |    6 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   18 +-
 drivers/isdn/act2000/act2000_isa.c                 |    6 +-
 drivers/isdn/capi/capi.c                           |    2 +-
 drivers/isdn/capi/kcapi_proc.c                     |    2 +
 drivers/isdn/gigaset/Kconfig                       |   14 +-
 drivers/isdn/gigaset/usb-gigaset.c                 |    8 +-
 drivers/isdn/hardware/eicon/debug.c                |    2 +-
 drivers/isdn/hardware/eicon/message.c              |   70 +-
 drivers/isdn/hardware/mISDN/hfcpci.c               |    4 +-
 drivers/isdn/hardware/mISDN/hfcsusb.c              |    6 +-
 drivers/isdn/hardware/mISDN/hfcsusb.h              |    6 +-
 drivers/isdn/hisax/callc.c                         |    1 -
 drivers/isdn/hisax/config.c                        |    6 -
 drivers/isdn/hisax/hfcscard.c                      |    2 -
 drivers/isdn/hisax/hisax.h                         |    9 +
 drivers/isdn/hisax/isdnl1.c                        |    4 +-
 drivers/isdn/hisax/sedlbauer.c                     |    2 -
 drivers/isdn/hisax/teles0.c                        |    2 -
 drivers/isdn/hisax/teles3.c                        |    1 -
 drivers/isdn/mISDN/clock.c                         |   10 +-
 drivers/isdn/mISDN/timerdev.c                      |    3 +-
 drivers/isdn/pcbit/layer2.c                        |    6 +-
 drivers/leds/Kconfig                               |    3 +
 drivers/net/3c501.c                                |   17 +-
 drivers/net/3c505.c                                |   18 +-
 drivers/net/3c507.c                                |   15 +-
 drivers/net/3c509.c                                |   25 +-
 drivers/net/3c515.c                                |   21 +-
 drivers/net/3c523.c                                |   25 +-
 drivers/net/3c527.c                                |   19 +-
 drivers/net/3c59x.c                                |   61 +-
 drivers/net/8139cp.c                               |   30 +-
 drivers/net/8139too.c                              |   32 +-
 drivers/net/82596.c                                |   17 +-
 drivers/net/Kconfig                                |   34 +-
 drivers/net/Makefile                               |    5 +-
 drivers/net/a2065.c                                |   19 +-
 drivers/net/acenic.c                               |    2 +-
 drivers/net/amd8111e.c                             |    6 +-
 drivers/net/arcnet/arc-rawmode.c                   |    4 +-
 drivers/net/arcnet/arcnet.c                        |   72 +-
 drivers/net/arcnet/capmode.c                       |    6 +-
 drivers/net/arcnet/com20020-isa.c                  |    2 +
 drivers/net/arcnet/com20020-pci.c                  |    3 +
 drivers/net/arcnet/com20020.c                      |   11 +-
 drivers/net/arcnet/rfc1051.c                       |   12 +-
 drivers/net/arcnet/rfc1201.c                       |   47 +-
 drivers/net/arm/ep93xx_eth.c                       |    8 +-
 drivers/net/arm/ixp4xx_eth.c                       |   12 +-
 drivers/net/arm/ks8695net.c                        |    2 +-
 drivers/net/at1700.c                               |    2 +-
 drivers/net/atl1c/atl1c.h                          |    1 -
 drivers/net/atl1e/atl1e.h                          |    2 +-
 drivers/net/atl1e/atl1e_main.c                     |    6 +-
 drivers/net/atl1e/atl1e_param.c                    |    2 +-
 drivers/net/atlx/atl1.c                            |    2 +-
 drivers/net/atlx/atl2.c                            |    2 +-
 drivers/net/au1000_eth.c                           | 1051 +-
 drivers/net/ax88796.c                              |   31 +-
 drivers/net/b44.c                                  |    8 +-
 drivers/net/benet/be.h                             |   12 +-
 drivers/net/benet/be_main.c                        |   96 +-
 drivers/net/bfin_mac.c                             |   12 +-
 drivers/net/bmac.c                                 |    3 +-
 drivers/net/bnx2.c                                 |   24 +-
 drivers/net/bnx2x.h                                |  186 +-
 drivers/net/bnx2x_dump.h                           |  526 +
 drivers/net/bnx2x_fw_defs.h                        |  153 +-
 drivers/net/bnx2x_hsi.h                            |  559 +-
 drivers/net/bnx2x_init.h                           |  163 +-
 drivers/net/bnx2x_init_values.h                    |26545 +++++++++++---------
 drivers/net/bnx2x_link.c                           | 1416 +-
 drivers/net/bnx2x_link.h                           |   23 +-
 drivers/net/bnx2x_main.c                           | 2640 ++-
 drivers/net/bnx2x_reg.h                            |  314 +-
 drivers/net/bonding/bond_3ad.h                     |    2 +-
 drivers/net/bonding/bond_alb.c                     |   12 +-
 drivers/net/bonding/bond_main.c                    |   17 +-
 drivers/net/cassini.c                              |    8 +-
 drivers/net/chelsio/sge.c                          |    7 +-
 drivers/net/cpmac.c                                |   12 +-
 drivers/net/cxgb3/adapter.h                        |   21 +-
 drivers/net/cxgb3/ael1002.c                        |    3 +-
 drivers/net/cxgb3/common.h                         |    6 +
 drivers/net/cxgb3/cxgb3_main.c                     |  254 +-
 drivers/net/cxgb3/cxgb3_offload.c                  |   12 +
 drivers/net/cxgb3/cxgb3_offload.h                  |    7 +
 drivers/net/cxgb3/regs.h                           |   21 +
 drivers/net/cxgb3/sge.c                            |  315 +-
 drivers/net/cxgb3/t3_hw.c                          |  164 +-
 drivers/net/cxgb3/version.h                        |    4 +-
 drivers/net/cxgb3/xgmac.c                          |   85 +-
 drivers/net/declance.c                             |    6 +-
 drivers/net/defxx.c                                |    2 +-
 drivers/net/depca.c                                |    6 +-
 drivers/net/dnet.c                                 |    2 +-
 drivers/net/e100.c                                 |   99 +-
 drivers/net/e1000/e1000.h                          |    2 -
 drivers/net/e1000/e1000_main.c                     |  162 +-
 drivers/net/e1000e/82571.c                         |  273 +-
 drivers/net/e1000e/defines.h                       |    1 +
 drivers/net/e1000e/e1000.h                         |    4 +-
 drivers/net/e1000e/ethtool.c                       |    3 +-
 drivers/net/e1000e/hw.h                            |   11 +
 drivers/net/e1000e/ich8lan.c                       |   17 +-
 drivers/net/e1000e/lib.c                           |   66 +-
 drivers/net/e1000e/netdev.c                        |  261 +-
 drivers/net/e2100.c                                |    6 +-
 drivers/net/ehea/ehea.h                            |    2 +-
 drivers/net/ehea/ehea_main.c                       |  189 +-
 drivers/net/ehea/ehea_qmr.c                        |    4 +-
 drivers/net/enic/enic.h                            |    3 +-
 drivers/net/enic/enic_main.c                       |   84 +-
 drivers/net/enic/vnic_dev.c                        |   33 +-
 drivers/net/enic/vnic_dev.h                        |    2 +
 drivers/net/enic/vnic_devcmd.h                     |    8 +-
 drivers/net/enic/vnic_intr.h                       |   14 +
 drivers/net/epic100.c                              |    6 +-
 drivers/net/eql.c                                  |    2 +-
 drivers/net/fealnx.c                               |    4 +-
 drivers/net/fec.c                                  |  890 +-
 drivers/net/fec.h                                  |   11 +-
 drivers/net/forcedeth.c                            |  750 +-
 drivers/net/fs_enet/fs_enet-main.c                 |    4 +-
 drivers/net/{gianfar_mii.c => fsl_pq_mdio.c}       |  265 +-
 drivers/net/fsl_pq_mdio.h                          |   45 +
 drivers/net/gianfar.c                              |  182 +-
 drivers/net/gianfar.h                              |   20 +-
 drivers/net/gianfar_ethtool.c                      |    1 +
 drivers/net/gianfar_mii.h                          |   54 -
 drivers/net/gianfar_sysfs.c                        |   33 +-
 drivers/net/hamachi.c                              |   10 +-
 drivers/net/hamradio/6pack.c                       |   20 +-
 drivers/net/hamradio/baycom_epp.c                  |   43 +-
 drivers/net/hamradio/bpqether.c                    |   47 +-
 drivers/net/hamradio/dmascc.c                      |   54 +-
 drivers/net/hamradio/hdlcdrv.c                     |   45 +-
 drivers/net/hamradio/mkiss.c                       |   55 +-
 drivers/net/hamradio/scc.c                         |   24 +-
 drivers/net/hamradio/yam.c                         |   68 +-
 drivers/net/ibm_newemac/core.c                     |    2 +-
 drivers/net/ibmveth.c                              |    8 +-
 drivers/net/igb/Makefile                           |    4 +-
 drivers/net/igb/e1000_82575.c                      |  141 +-
 drivers/net/igb/e1000_82575.h                      |   64 +-
 drivers/net/igb/e1000_defines.h                    |  134 +-
 drivers/net/igb/e1000_hw.h                         |  202 +-
 drivers/net/igb/e1000_mac.c                        |   66 +-
 drivers/net/igb/e1000_mac.h                        |    9 +-
 drivers/net/igb/e1000_mbx.c                        |  447 +
 drivers/net/igb/e1000_mbx.h                        |   77 +
 drivers/net/igb/e1000_nvm.c                        |   44 +-
 drivers/net/igb/e1000_phy.c                        |  352 +-
 drivers/net/igb/e1000_phy.h                        |    3 +-
 drivers/net/igb/e1000_regs.h                       |  103 +-
 drivers/net/igb/igb.h                              |   92 +-
 drivers/net/igb/igb_ethtool.c                      |  206 +-
 drivers/net/igb/igb_main.c                         | 1891 ++-
 drivers/net/irda/ali-ircc.c                        |   23 +-
 drivers/net/irda/irda-usb.c                        |   18 +-
 drivers/net/irda/kingsun-sir.c                     |   11 +-
 drivers/net/irda/ks959-sir.c                       |   11 +-
 drivers/net/irda/ksdazzle-sir.c                    |   12 +-
 drivers/net/irda/mcs7780.c                         |   13 +-
 drivers/net/irda/nsc-ircc.c                        |   23 +-
 drivers/net/irda/sir_dev.c                         |   17 +-
 drivers/net/irda/smsc-ircc2.c                      |   30 +-
 drivers/net/irda/stir4200.c                        |   12 +-
 drivers/net/irda/via-ircc.c                        |   22 +-
 drivers/net/irda/vlsi_ir.c                         |   14 +-
 drivers/net/irda/w83977af_ir.c                     |   13 +-
 drivers/net/ixgb/ixgb_main.c                       |   76 +-
 drivers/net/ixgbe/Makefile                         |    7 +-
 drivers/net/ixgbe/ixgbe.h                          |   66 +-
 drivers/net/ixgbe/ixgbe_82598.c                    |  336 +-
 drivers/net/ixgbe/ixgbe_82599.c                    | 1292 +
 drivers/net/ixgbe/ixgbe_common.c                   |  483 +-
 drivers/net/ixgbe/ixgbe_common.h                   |   15 +-
 drivers/net/ixgbe/ixgbe_dcb.c                      |   19 +-
 drivers/net/ixgbe/ixgbe_dcb.h                      |   56 +-
 drivers/net/ixgbe/ixgbe_dcb_82598.c                |    3 +-
 drivers/net/ixgbe/ixgbe_dcb_82598.h                |    2 +-
 drivers/net/ixgbe/ixgbe_dcb_82599.c                |  467 +
 drivers/net/ixgbe/ixgbe_dcb_82599.h                |  127 +
 drivers/net/ixgbe/ixgbe_dcb_nl.c                   |  205 +-
 drivers/net/ixgbe/ixgbe_ethtool.c                  |  130 +-
 drivers/net/ixgbe/ixgbe_main.c                     | 1399 +-
 drivers/net/ixgbe/ixgbe_phy.c                      |  592 +-
 drivers/net/ixgbe/ixgbe_phy.h                      |   18 +-
 drivers/net/ixgbe/ixgbe_type.h                     |  825 +-
 drivers/net/ixp2000/ixpdev.c                       |    4 +-
 drivers/net/jazzsonic.c                            |    6 +-
 drivers/net/jme.c                                  |   31 +-
 drivers/net/jme.h                                  |    8 +-
 drivers/net/korina.c                               |    4 +-
 drivers/net/lance.c                                |   11 +-
 drivers/net/macb.c                                 |   21 +-
 drivers/net/macsonic.c                             |   15 +-
 drivers/net/macvlan.c                              |   84 +-
 drivers/net/mlx4/en_rx.c                           |    5 +-
 drivers/net/mv643xx_eth.c                          |  412 +-
 drivers/net/myri10ge/myri10ge.c                    |    7 +-
 drivers/net/myri10ge/myri10ge_mcp_gen_header.h     |    9 +
 drivers/net/myri_sbus.c                            |   20 +-
 drivers/net/natsemi.c                              |    8 +-
 drivers/net/ne2k-pci.c                             |    5 +-
 drivers/net/netxen/Makefile                        |    9 +-
 drivers/net/netxen/netxen_nic.h                    |  171 +-
 drivers/net/netxen/netxen_nic_ctx.c                |  201 +-
 drivers/net/netxen/netxen_nic_ethtool.c            |  181 +-
 drivers/net/netxen/netxen_nic_hdr.h                |   21 +-
 drivers/net/netxen/netxen_nic_hw.c                 |  595 +-
 drivers/net/netxen/netxen_nic_hw.h                 |   63 +-
 drivers/net/netxen/netxen_nic_init.c               |  916 +-
 drivers/net/netxen/netxen_nic_main.c               | 1162 +-
 drivers/net/netxen/netxen_nic_niu.c                |  230 +-
 drivers/net/netxen/netxen_nic_phan_reg.h           |   10 +-
 drivers/net/ni65.c                                 |   11 +-
 drivers/net/niu.c                                  | 1059 +-
 drivers/net/niu.h                                  |   19 +-
 drivers/net/ns83820.c                              |    5 +-
 drivers/net/pasemi_mac.c                           |    6 +-
 drivers/net/pcmcia/3c574_cs.c                      |   23 +-
 drivers/net/pcmcia/3c589_cs.c                      |   25 +-
 drivers/net/pcmcia/axnet_cs.c                      |   70 +-
 drivers/net/pcmcia/fmvj18x_cs.c                    |   59 +-
 drivers/net/pcmcia/nmclan_cs.c                     |   23 +-
 drivers/net/pcmcia/pcnet_cs.c                      |   34 +-
 drivers/net/pcmcia/smc91c92_cs.c                   |   79 +-
 drivers/net/pcmcia/xirc2ps_cs.c                    |   66 +-
 drivers/net/pcnet32.c                              |    6 +-
 drivers/net/phy/mdio-gpio.c                        |   13 +-
 drivers/net/phy/mdio_bus.c                         |   56 +-
 drivers/net/phy/phy.c                              |   41 +-
 drivers/net/phy/smsc.c                             |   31 +
 drivers/net/ppp_async.c                            |    9 +-
 drivers/net/ppp_generic.c                          |  494 +-
 drivers/net/ppp_synctty.c                          |    6 +-
 drivers/net/pppoe.c                                |  521 +-
 drivers/net/pppol2tp.c                             |  192 +-
 drivers/net/pppox.c                                |    3 -
 drivers/net/ps3_gelic_net.c                        |   26 +-
 drivers/net/ps3_gelic_wireless.c                   |   28 +-
 drivers/net/qla3xxx.c                              |    6 +-
 drivers/net/qlge/qlge.h                            |  161 +-
 drivers/net/qlge/qlge_dbg.c                        |    9 +
 drivers/net/qlge/qlge_ethtool.c                    |    3 +-
 drivers/net/qlge/qlge_main.c                       |  630 +-
 drivers/net/qlge/qlge_mpi.c                        |  835 +-
 drivers/net/r6040.c                                |   14 +-
 drivers/net/r8169.c                                |    6 +-
 drivers/net/rionet.c                               |    3 +-
 drivers/net/s2io.c                                 |   15 +-
 drivers/net/sb1250-mac.c                           |   16 +-
 drivers/net/sc92031.c                              |   27 +-
 drivers/net/sfc/Kconfig                            |    1 -
 drivers/net/sfc/bitfield.h                         |    4 +-
 drivers/net/sfc/boards.c                           |   74 +-
 drivers/net/sfc/boards.h                           |    1 +
 drivers/net/sfc/efx.c                              |   74 +-
 drivers/net/sfc/efx.h                              |    4 +-
 drivers/net/sfc/ethtool.c                          |   28 +-
 drivers/net/sfc/falcon.c                           |   96 +-
 drivers/net/sfc/falcon.h                           |    2 +
 drivers/net/sfc/falcon_io.h                        |   13 +-
 drivers/net/sfc/mdio_10g.c                         |   28 +-
 drivers/net/sfc/mdio_10g.h                         |    8 +-
 drivers/net/sfc/mtd.c                              |    1 +
 drivers/net/sfc/net_driver.h                       |   29 +-
 drivers/net/sfc/phy.h                              |    8 +-
 drivers/net/sfc/rx.c                               |  209 +-
 drivers/net/sfc/rx.h                               |    3 -
 drivers/net/sfc/sfe4001.c                          |   21 +-
 drivers/net/sfc/tenxpress.c                        |  141 +-
 drivers/net/sfc/tx.c                               |   13 +-
 drivers/net/sfc/workarounds.h                      |    2 +
 drivers/net/sfc/xfp_phy.c                          |  105 +-
 drivers/net/sis900.c                               |    4 +-
 drivers/net/skfp/h/smc.h                           |   17 +
 drivers/net/skfp/hwmtm.c                           |    9 -
 drivers/net/skfp/pcmplc.c                          |    3 -
 drivers/net/skfp/skfddi.c                          |    3 -
 drivers/net/skfp/smt.c                             |   10 -
 drivers/net/skge.c                                 |    6 +-
 drivers/net/sky2.c                                 |  267 +-
 drivers/net/smc911x.c                              |    2 +-
 drivers/net/smc91x.c                               |  140 +-
 drivers/net/smc91x.h                               |   10 +
 drivers/net/smsc911x.c                             |  215 +-
 drivers/net/smsc911x.h                             |    7 +
 drivers/net/smsc9420.c                             |   10 +-
 drivers/net/spider_net.c                           |   44 +-
 drivers/net/starfire.c                             |    8 +-
 drivers/net/sunbmac.c                              |   22 +-
 drivers/net/sundance.c                             |    5 +-
 drivers/net/sungem.c                               |    6 +-
 drivers/net/sunlance.c                             |   17 +-
 drivers/net/sunqe.c                                |   17 +-
 drivers/net/sunvnet.c                              |   18 +-
 drivers/net/tc35815.c                              |   10 +-
 drivers/net/tehuti.c                               |   45 +-
 drivers/net/tehuti.h                               |    1 +
 drivers/net/tehuti_fw.h                            |10712 --------
 drivers/net/tg3.c                                  |  776 +-
 drivers/net/tg3.h                                  |   18 +
 drivers/net/tokenring/3c359.c                      |   17 +-
 drivers/net/tokenring/abyss.c                      |   10 +-
 drivers/net/tokenring/ibmtr.c                      |   43 +-
 drivers/net/tokenring/lanstreamer.c                |   45 +-
 drivers/net/tokenring/lanstreamer.h                |    1 -
 drivers/net/tokenring/madgemc.c                    |    2 -
 drivers/net/tokenring/olympic.c                    |   39 +-
 drivers/net/tokenring/olympic.h                    |    1 -
 drivers/net/tokenring/smctr.c                      |   13 +-
 drivers/net/tokenring/smctr.h                      |    1 -
 drivers/net/tokenring/tms380tr.c                   |   21 +-
 drivers/net/tokenring/tms380tr.h                   |    1 +
 drivers/net/tokenring/tmspci.c                     |    4 +-
 drivers/net/tsi108_eth.c                           |    8 +-
 drivers/net/tulip/de4x5.c                          |    7 +-
 drivers/net/tulip/dmfe.c                           |    2 +-
 drivers/net/tulip/interrupt.c                      |   94 +-
 drivers/net/tulip/media.c                          |    8 +-
 drivers/net/tulip/tulip.h                          |   32 +-
 drivers/net/tulip/uli526x.c                        |    2 +-
 drivers/net/tulip/winbond-840.c                    |    7 +-
 drivers/net/tun.c                                  |  528 +-
 drivers/net/typhoon-firmware.h                     | 3778 ---
 drivers/net/typhoon.c                              |  104 +-
 drivers/net/typhoon.h                              |  234 +-
 drivers/net/ucc_geth.c                             |   43 +-
 drivers/net/ucc_geth.h                             |   14 +-
 drivers/net/ucc_geth_ethtool.c                     |    1 -
 drivers/net/ucc_geth_mii.c                         |  295 -
 drivers/net/ucc_geth_mii.h                         |  101 -
 drivers/net/usb/asix.c                             |   47 +-
 drivers/net/usb/catc.c                             |   52 +-
 drivers/net/usb/dm9601.c                           |   16 +-
 drivers/net/usb/hso.c                              |   43 +-
 drivers/net/usb/mcs7830.c                          |   16 +-
 drivers/net/usb/rndis_host.c                       |   38 +-
 drivers/net/usb/rtl8150.c                          |   48 +-
 drivers/net/usb/smsc95xx.c                         |   25 +-
 drivers/net/usb/usbnet.c                           |   40 +-
 drivers/net/veth.c                                 |   45 +-
 drivers/net/via-rhine.c                            |    9 +-
 drivers/net/via-velocity.h                         |    6 +-
 drivers/net/virtio_net.c                           |  242 +-
 drivers/net/wan/c101.c                             |   12 +-
 drivers/net/wan/cosa.c                             |   17 +-
 drivers/net/wan/cycx_x25.c                         |   41 +-
 drivers/net/wan/dlci.c                             |   54 +-
 drivers/net/wan/dscc4.c                            |   18 +-
 drivers/net/wan/farsync.c                          |   18 +-
 drivers/net/wan/hd64572.c                          |    4 +-
 drivers/net/wan/hdlc.c                             |   33 +-
 drivers/net/wan/hdlc_cisco.c                       |   17 +-
 drivers/net/wan/hdlc_fr.c                          |   44 +-
 drivers/net/wan/hdlc_ppp.c                         |    6 +-
 drivers/net/wan/hdlc_raw.c                         |    5 +-
 drivers/net/wan/hdlc_raw_eth.c                     |    8 +-
 drivers/net/wan/hdlc_x25.c                         |    2 +-
 drivers/net/wan/hostess_sv11.c                     |   12 +-
 drivers/net/wan/ixp4xx_hss.c                       |   24 +-
 drivers/net/wan/lapbether.c                        |   39 +-
 drivers/net/wan/lmc/lmc_main.c                     |   19 +-
 drivers/net/wan/lmc/lmc_proto.c                    |   17 +-
 drivers/net/wan/n2.c                               |   12 +-
 drivers/net/wan/pc300too.c                         |   12 +-
 drivers/net/wan/pci200syn.c                        |   12 +-
 drivers/net/wan/sbni.c                             |  105 +-
 drivers/net/wan/sealevel.c                         |   12 +-
 drivers/net/wan/wanxl.c                            |   14 +-
 drivers/net/wan/x25_asy.c                          |   44 +-
 drivers/net/wan/x25_asy.h                          |    4 -
 drivers/net/wan/z85230.c                           |    3 +-
 drivers/net/wimax/i2400m/Makefile                  |    1 +
 drivers/net/wimax/i2400m/control.c                 |  147 +-
 drivers/net/wimax/i2400m/debug-levels.h            |    1 +
 drivers/net/wimax/i2400m/driver.c                  |   28 +-
 drivers/net/wimax/i2400m/fw.c                      |   65 +-
 drivers/net/wimax/i2400m/i2400m.h                  |   91 +-
 drivers/net/wimax/i2400m/netdev.c                  |  120 +-
 drivers/net/wimax/i2400m/rx.c                      |  749 +-
 drivers/net/wimax/i2400m/sdio.c                    |   27 +-
 drivers/net/wimax/i2400m/sysfs.c                   |   80 +
 drivers/net/wimax/i2400m/usb-notif.c               |    2 +-
 drivers/net/wimax/i2400m/usb.c                     |   30 +-
 drivers/net/wireless/Kconfig                       |  145 +-
 drivers/net/wireless/Makefile                      |    4 +
 drivers/net/wireless/airo.c                        | 1210 +-
 drivers/net/wireless/airo_cs.c                     |   73 +-
 drivers/net/wireless/at76c50x-usb.c                | 2501 ++
 drivers/net/wireless/at76c50x-usb.h                |  463 +
 drivers/net/wireless/ath5k/Makefile                |    1 +
 drivers/net/wireless/ath5k/ath5k.h                 |   80 +-
 drivers/net/wireless/ath5k/attach.c                |   31 +-
 drivers/net/wireless/ath5k/base.c                  |  322 +-
 drivers/net/wireless/ath5k/base.h                  |    4 +-
 drivers/net/wireless/ath5k/caps.c                  |    6 +-
 drivers/net/wireless/ath5k/debug.c                 |   53 +-
 drivers/net/wireless/ath5k/debug.h                 |    1 -
 drivers/net/wireless/ath5k/eeprom.c                |  177 +-
 drivers/net/wireless/ath5k/eeprom.h                |    1 +
 drivers/net/wireless/ath5k/gpio.c                  |   10 +-
 drivers/net/wireless/ath5k/initvals.c              | 1575 +-
 drivers/net/wireless/ath5k/led.c                   |  174 +
 drivers/net/wireless/ath5k/pcu.c                   |   23 +-
 drivers/net/wireless/ath5k/phy.c                   | 2029 +--
 drivers/net/wireless/ath5k/qcu.c                   |   47 +-
 drivers/net/wireless/ath5k/reg.h                   |  124 +-
 drivers/net/wireless/ath5k/reset.c                 |  950 +-
 drivers/net/wireless/ath5k/rfbuffer.h              | 1181 +
 drivers/net/wireless/ath5k/rfgain.h                |  516 +
 drivers/net/wireless/ath9k/Makefile                |    3 +
 drivers/net/wireless/ath9k/ahb.c                   |  192 +
 drivers/net/wireless/ath9k/ani.c                   |  288 +-
 drivers/net/wireless/ath9k/ani.h                   |  138 +
 drivers/net/wireless/ath9k/ath9k.h                 | 1733 +-
 drivers/net/wireless/ath9k/beacon.c                |  768 +-
 drivers/net/wireless/ath9k/calib.c                 |  553 +-
 drivers/net/wireless/ath9k/calib.h                 |  124 +
 drivers/net/wireless/ath9k/core.h                  |  787 -
 drivers/net/wireless/ath9k/debug.c                 |  415 +-
 drivers/net/wireless/ath9k/debug.h                 |  165 +
 drivers/net/wireless/ath9k/eeprom.c                | 3173 ++--
 drivers/net/wireless/ath9k/eeprom.h                |  506 +
 drivers/net/wireless/ath9k/hw.c                    | 1707 +-
 drivers/net/wireless/ath9k/hw.h                    | 1557 +-
 drivers/net/wireless/ath9k/initvals.h              |  716 +-
 drivers/net/wireless/ath9k/mac.c                   |  233 +-
 drivers/net/wireless/ath9k/mac.h                   |  680 +
 drivers/net/wireless/ath9k/main.c                  | 1925 +-
 drivers/net/wireless/ath9k/pci.c                   |  313 +
 drivers/net/wireless/ath9k/phy.c                   |  240 +-
 drivers/net/wireless/ath9k/phy.h                   |   49 +-
 drivers/net/wireless/ath9k/rc.c                    |  345 +-
 drivers/net/wireless/ath9k/rc.h                    |   28 +-
 drivers/net/wireless/ath9k/recv.c                  |  170 +-
 drivers/net/wireless/ath9k/reg.h                   |  123 +-
 drivers/net/wireless/ath9k/regd.c                  | 1246 +-
 drivers/net/wireless/ath9k/regd.h                  |  207 +-
 drivers/net/wireless/ath9k/regd_common.h           | 2058 +--
 drivers/net/wireless/ath9k/virtual.c               |  662 +
 drivers/net/wireless/ath9k/xmit.c                  | 2871 +--
 drivers/net/wireless/atmel.c                       |  483 +-
 drivers/net/wireless/b43/Kconfig                   |   14 +-
 drivers/net/wireless/b43/Makefile                  |    1 +
 drivers/net/wireless/b43/b43.h                     |   43 +-
 drivers/net/wireless/b43/debugfs.c                 |   48 +-
 drivers/net/wireless/b43/debugfs.h                 |    5 +-
 drivers/net/wireless/b43/dma.c                     |   65 +-
 drivers/net/wireless/b43/dma.h                     |   17 +-
 drivers/net/wireless/b43/lo.c                      |   77 +-
 drivers/net/wireless/b43/main.c                    |  456 +-
 drivers/net/wireless/b43/main.h                    |   25 +
 drivers/net/wireless/b43/phy_a.c                   |  111 +-
 drivers/net/wireless/b43/phy_g.c                   |  614 +-
 drivers/net/wireless/b43/phy_lp.c                  |  395 +-
 drivers/net/wireless/b43/phy_lp.h                  |  329 +-
 drivers/net/wireless/b43/pio.c                     |   16 +-
 drivers/net/wireless/b43/rfkill.c                  |    2 +-
 drivers/net/wireless/b43/tables_lpphy.c            |  394 +
 drivers/net/wireless/b43/tables_lpphy.h            |   31 +
 drivers/net/wireless/b43/wa.c                      |  113 +-
 drivers/net/wireless/b43/xmit.c                    |   17 +-
 drivers/net/wireless/b43legacy/leds.c              |    8 +-
 drivers/net/wireless/b43legacy/main.c              |    2 +-
 drivers/net/wireless/hostap/hostap.h               |    2 +-
 drivers/net/wireless/hostap/hostap_80211.h         |    2 +-
 drivers/net/wireless/hostap/hostap_80211_rx.c      |  111 +-
 drivers/net/wireless/hostap/hostap_80211_tx.c      |   51 +-
 drivers/net/wireless/hostap/hostap_ap.c            |  146 +-
 drivers/net/wireless/hostap/hostap_ap.h            |    6 +-
 drivers/net/wireless/hostap/hostap_hw.c            |   37 +-
 drivers/net/wireless/hostap/hostap_info.c          |    1 +
 drivers/net/wireless/hostap/hostap_ioctl.c         |    7 +-
 drivers/net/wireless/hostap/hostap_main.c          |  117 +-
 drivers/net/wireless/hostap/hostap_wlan.h          |    1 -
 drivers/net/wireless/ipw2x00/Kconfig               |    3 +-
 .../net/wireless/ipw2x00}/ieee80211.h              |  112 +-
 drivers/net/wireless/ipw2x00/ipw2100.c             |   74 +-
 drivers/net/wireless/ipw2x00/ipw2100.h             |    8 +-
 drivers/net/wireless/ipw2x00/ipw2200.c             |  198 +-
 drivers/net/wireless/ipw2x00/ipw2200.h             |    7 +-
 drivers/net/wireless/ipw2x00/libipw_geo.c          |    2 +-
 drivers/net/wireless/ipw2x00/libipw_module.c       |   49 +-
 drivers/net/wireless/ipw2x00/libipw_rx.c           |  122 +-
 drivers/net/wireless/ipw2x00/libipw_tx.c           |   12 +-
 drivers/net/wireless/ipw2x00/libipw_wx.c           |   27 +-
 drivers/net/wireless/iwlwifi/Kconfig               |   99 +-
 drivers/net/wireless/iwlwifi/Makefile              |   11 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c            |   73 +
 drivers/net/wireless/iwlwifi/iwl-3945-commands.h   | 1702 --
 drivers/net/wireless/iwlwifi/iwl-3945-debug.h      |  167 -
 drivers/net/wireless/iwlwifi/iwl-3945-fh.h         |  188 +
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h         |  227 +-
 drivers/net/wireless/iwlwifi/iwl-3945-io.h         |  404 -
 drivers/net/wireless/iwlwifi/iwl-3945-led.c        |   77 +-
 drivers/net/wireless/iwlwifi/iwl-3945-led.h        |   50 +-
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c         |  297 +-
 drivers/net/wireless/iwlwifi/iwl-3945-rs.h         |  206 -
 drivers/net/wireless/iwlwifi/iwl-3945.c            | 1174 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h            |  761 +-
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h         |   47 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c            |  215 +-
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h         |   14 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c            |  239 +-
 .../iwlwifi/{iwl-3945-core.h => iwl-6000-hw.h}     |   59 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c            |  158 +
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c  |  108 -
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c          |  290 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h          |   57 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c             | 1362 +-
 drivers/net/wireless/iwlwifi/iwl-calib.c           |   93 +-
 drivers/net/wireless/iwlwifi/iwl-calib.h           |    4 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h        |  511 +-
 drivers/net/wireless/iwlwifi/iwl-core.c            |  785 +-
 drivers/net/wireless/iwlwifi/iwl-core.h            |  100 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h             |    7 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h           |  183 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c         |   23 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h             |  133 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c          |   40 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h          |    9 +-
 drivers/net/wireless/iwlwifi/iwl-fh.h              |   21 +-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c            |   32 +-
 drivers/net/wireless/iwlwifi/iwl-helpers.h         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-io.h              |   44 +-
 drivers/net/wireless/iwlwifi/iwl-led.c             |   26 +-
 drivers/net/wireless/iwlwifi/iwl-led.h             |    6 +-
 drivers/net/wireless/iwlwifi/iwl-power.c           |  102 +-
 drivers/net/wireless/iwlwifi/iwl-power.h           |   16 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h            |    4 +-
 drivers/net/wireless/iwlwifi/iwl-rfkill.c          |   17 +-
 drivers/net/wireless/iwlwifi/iwl-rfkill.h          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c              |   60 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c            |  184 +-
 drivers/net/wireless/iwlwifi/iwl-spectrum.c        |   12 +-
 drivers/net/wireless/iwlwifi/iwl-spectrum.h        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c             |  105 +-
 drivers/net/wireless/iwlwifi/iwl-sta.h             |    5 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c              |  287 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c        | 5572 +----
 drivers/net/wireless/libertas/Makefile             |    2 +
 drivers/net/wireless/libertas/debugfs.c            |   14 +-
 drivers/net/wireless/libertas/defs.h               |    3 +
 drivers/net/wireless/libertas/dev.h                |    1 -
 drivers/net/wireless/libertas/host.h               |    1 +
 drivers/net/wireless/libertas/hostcmd.h            |    8 +
 drivers/net/wireless/libertas/if_cs.c              |    4 +-
 drivers/net/wireless/libertas/if_sdio.c            |   20 +-
 drivers/net/wireless/libertas/if_spi.c             | 1218 +
 drivers/net/wireless/libertas/if_spi.h             |  208 +
 drivers/net/wireless/libertas/main.c               |   74 +-
 drivers/net/wireless/libertas/rx.c                 |   18 +-
 drivers/net/wireless/libertas/scan.c               |    2 +-
 drivers/net/wireless/libertas/tx.c                 |    8 +-
 drivers/net/wireless/libertas/wext.c               |    2 +-
 drivers/net/wireless/libertas_tf/cmd.c             |    2 +-
 drivers/net/wireless/libertas_tf/libertas_tf.h     |    2 +-
 drivers/net/wireless/mac80211_hwsim.c              |  358 +-
 drivers/net/wireless/mwl8k.c                       | 3789 +++
 drivers/net/wireless/netwave_cs.c                  |   91 +-
 drivers/net/wireless/orinoco/Kconfig               |  120 +
 drivers/net/wireless/orinoco/Makefile              |    3 +-
 drivers/net/wireless/orinoco/airport.c             |   37 +-
 drivers/net/wireless/orinoco/fw.c                  |  390 +
 drivers/net/wireless/orinoco/fw.h                  |   21 +
 drivers/net/wireless/orinoco/hermes.c              |  116 +-
 drivers/net/wireless/orinoco/hermes.h              |   35 +-
 drivers/net/wireless/orinoco/hermes_dld.c          |  132 +-
 drivers/net/wireless/orinoco/hermes_dld.h          |   12 +-
 drivers/net/wireless/orinoco/hw.c                  |  586 +
 drivers/net/wireless/orinoco/hw.h                  |   47 +
 drivers/net/wireless/orinoco/main.c                | 2667 ++
 drivers/net/wireless/orinoco/main.h                |   63 +
 drivers/net/wireless/orinoco/mic.c                 |   79 +
 drivers/net/wireless/orinoco/mic.h                 |   22 +
 drivers/net/wireless/orinoco/orinoco.c             | 6159 -----
 drivers/net/wireless/orinoco/orinoco.h             |   28 +-
 drivers/net/wireless/orinoco/orinoco_cs.c          |   33 +-
 drivers/net/wireless/orinoco/orinoco_nortel.c      |    7 +-
 drivers/net/wireless/orinoco/orinoco_pci.c         |    5 +-
 drivers/net/wireless/orinoco/orinoco_pci.h         |   12 +-
 drivers/net/wireless/orinoco/orinoco_plx.c         |    3 +-
 drivers/net/wireless/orinoco/orinoco_tmd.c         |    4 +-
 drivers/net/wireless/orinoco/scan.c                |  233 +
 drivers/net/wireless/orinoco/scan.h                |   29 +
 drivers/net/wireless/orinoco/spectrum_cs.c         |   19 +-
 drivers/net/wireless/orinoco/wext.c                | 2325 ++
 drivers/net/wireless/orinoco/wext.h                |   13 +
 drivers/net/wireless/p54/Kconfig                   |   10 +
 drivers/net/wireless/p54/Makefile                  |    1 +
 drivers/net/wireless/p54/p54.h                     |   64 +-
 drivers/net/wireless/p54/p54common.c               |  783 +-
 drivers/net/wireless/p54/p54common.h               |  132 +-
 drivers/net/wireless/p54/p54pci.c                  |   42 +-
 drivers/net/wireless/p54/p54spi.c                  |  765 +
 drivers/net/wireless/p54/p54spi.h                  |  125 +
 drivers/net/wireless/p54/p54spi_eeprom.h           |  678 +
 drivers/net/wireless/p54/p54usb.c                  |   94 +-
 drivers/net/wireless/p54/p54usb.h                  |    1 +
 drivers/net/wireless/prism54/isl_ioctl.c           |    3 +-
 drivers/net/wireless/prism54/islpci_dev.c          |   40 +-
 drivers/net/wireless/prism54/islpci_dev.h          |    3 -
 drivers/net/wireless/prism54/islpci_eth.c          |   18 +-
 drivers/net/wireless/prism54/islpci_mgt.h          |    6 -
 drivers/net/wireless/prism54/oid_mgt.c             |    2 +-
 drivers/net/wireless/ray_cs.c                      | 3815 ++--
 drivers/net/wireless/rndis_wlan.c                  |  117 +-
 drivers/net/wireless/rt2x00/Kconfig                |    7 +-
 drivers/net/wireless/rt2x00/Makefile               |    1 +
 drivers/net/wireless/rt2x00/rt2400pci.c            |  103 +-
 drivers/net/wireless/rt2x00/rt2400pci.h            |    6 +-
 drivers/net/wireless/rt2x00/rt2500pci.c            |  131 +-
 drivers/net/wireless/rt2x00/rt2500pci.h            |    6 +-
 drivers/net/wireless/rt2x00/rt2500usb.c            |   72 +-
 drivers/net/wireless/rt2x00/rt2500usb.h            |   14 +-
 drivers/net/wireless/rt2x00/rt2x00.h               |  154 +-
 drivers/net/wireless/rt2x00/rt2x00config.c         |   11 +-
 drivers/net/wireless/rt2x00/rt2x00crypto.c         |   15 +-
 drivers/net/wireless/rt2x00/rt2x00debug.c          |   49 +-
 drivers/net/wireless/rt2x00/rt2x00debug.h          |    2 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |  416 +-
 drivers/net/wireless/rt2x00/rt2x00dump.h           |    2 +-
 drivers/net/wireless/rt2x00/rt2x00firmware.c       |   29 +-
 drivers/net/wireless/rt2x00/rt2x00leds.c           |    8 +-
 drivers/net/wireless/rt2x00/rt2x00leds.h           |    2 +-
 drivers/net/wireless/rt2x00/rt2x00lib.h            |  106 +-
 drivers/net/wireless/rt2x00/rt2x00link.c           |  471 +
 drivers/net/wireless/rt2x00/rt2x00mac.c            |   77 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c            |    2 +-
 drivers/net/wireless/rt2x00/rt2x00pci.h            |    2 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c          |  216 +-
 drivers/net/wireless/rt2x00/rt2x00queue.h          |   17 +-
 drivers/net/wireless/rt2x00/rt2x00reg.h            |   22 +-
 drivers/net/wireless/rt2x00/rt2x00rfkill.c         |  127 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c            |   64 +-
 drivers/net/wireless/rt2x00/rt2x00usb.h            |   13 +-
 drivers/net/wireless/rt2x00/rt61pci.c              |  244 +-
 drivers/net/wireless/rt2x00/rt61pci.h              |   13 +-
 drivers/net/wireless/rt2x00/rt73usb.c              |  208 +-
 drivers/net/wireless/rt2x00/rt73usb.h              |   19 +-
 drivers/net/wireless/rtl818x/rtl8187.h             |    4 +-
 drivers/net/wireless/rtl818x/rtl8187_dev.c         |   92 +-
 drivers/net/wireless/strip.c                       |   28 +-
 drivers/net/wireless/wavelan.c                     |   11 +-
 drivers/net/wireless/wavelan_cs.c                  |   79 +-
 drivers/net/wireless/wavelan_cs.p.h                |    6 -
 drivers/net/wireless/wl3501.h                      |    2 +-
 drivers/net/wireless/wl3501_cs.c                   |   51 +-
 drivers/net/wireless/zd1201.c                      |   55 +-
 drivers/net/wireless/zd1201.h                      |    1 -
 drivers/net/wireless/zd1211rw/zd_chip.c            |   21 +
 drivers/net/wireless/zd1211rw/zd_chip.h            |    2 +
 drivers/net/wireless/zd1211rw/zd_def.h             |    5 +
 drivers/net/wireless/zd1211rw/zd_mac.c             |   38 +-
 drivers/net/xen-netfront.c                         |    8 +-
 drivers/net/xtsonic.c                              |    2 +-
 drivers/net/yellowfin.c                            |    6 +-
 drivers/net/znet.c                                 |   17 +-
 drivers/s390/net/Makefile                          |    2 +-
 drivers/s390/net/claw.c                            |  485 +-
 drivers/s390/net/ctcm_fsms.c                       |    5 +-
 drivers/s390/net/ctcm_main.c                       |   39 +-
 drivers/s390/net/ctcm_mpc.c                        |   17 +-
 drivers/s390/net/lcs.c                             |   33 +-
 drivers/s390/net/netiucv.c                         |   16 +-
 drivers/s390/net/qeth_core.h                       |    8 +-
 drivers/s390/net/qeth_core_main.c                  |  110 +-
 drivers/s390/net/qeth_core_offl.c                  |  699 -
 drivers/s390/net/qeth_core_offl.h                  |   76 -
 drivers/s390/net/qeth_core_sys.c                   |    4 -
 drivers/s390/net/qeth_l2_main.c                    |   99 +-
 drivers/s390/net/qeth_l3_main.c                    |  129 +-
 drivers/scsi/scsi_transport_fc.c                   |   16 +-
 drivers/scsi/scsi_transport_iscsi.c                |   12 +-
 drivers/ssb/Makefile                               |    1 +
 drivers/ssb/b43_pci_bridge.c                       |    2 +
 drivers/ssb/driver_chipcommon.c                    |   14 +-
 drivers/ssb/driver_chipcommon_pmu.c                |  508 +
 drivers/ssb/pci.c                                  |   88 +-
 drivers/ssb/sprom.c                                |   36 +
 drivers/ssb/ssb_private.h                          |    1 +
 drivers/usb/gadget/rndis.c                         |   99 +-
 drivers/video/uvesafb.c                            |    5 +-
 firmware/3com/typhoon.bin.ihex                     | 2819 +++
 firmware/Makefile                                  |    4 +-
 firmware/WHENCE                                    |   60 +-
 firmware/cxgb3/t3fw-7.0.0.bin.ihex                 | 1881 --
 firmware/cxgb3/t3fw-7.1.0.bin.ihex                 | 1885 ++
 firmware/tehuti/bdx.bin.ihex                       | 2678 ++
 fs/compat_ioctl.c                                  |    8 +
 fs/dquot.c                                         |    5 +-
 include/asm-frv/socket.h                           |    3 +
 include/asm-m32r/socket.h                          |    3 +
 include/asm-mn10300/socket.h                       |    3 +
 include/linux/Kbuild                               |    1 +
 include/linux/arcdevice.h                          |    9 +-
 include/linux/ath9k_platform.h                     |   28 +
 include/linux/clocksource.h                        |  101 +
 include/linux/com20020.h                           |    1 +
 include/linux/connector.h                          |    8 +
 include/linux/dccp.h                               |   51 +-
 include/linux/errqueue.h                           |    1 +
 include/linux/etherdevice.h                        |   21 +
 include/linux/ethtool.h                            |   89 +-
 include/linux/gen_stats.h                          |    2 +-
 include/linux/hdlc.h                               |    5 +
 include/linux/hdlcdrv.h                            |    3 +-
 include/linux/ibmtr.h                              |    2 +-
 include/linux/ieee80211.h                          |  181 +
 include/linux/if.h                                 |    1 +
 include/linux/if_ether.h                           |    8 +-
 include/linux/if_pppox.h                           |   20 +-
 include/linux/if_tun.h                             |    2 +
 include/linux/if_tunnel.h                          |   16 +-
 include/linux/inetdevice.h                         |    1 +
 include/linux/mroute.h                             |   18 +-
 include/linux/ncp_no.h                             |   26 +-
 include/linux/neighbour.h                          |    1 +
 include/linux/net.h                                |    8 +-
 include/linux/net_dropmon.h                        |   56 +
 include/linux/net_tstamp.h                         |  104 +
 include/linux/netdevice.h                          |  111 +-
 include/linux/netfilter/Kbuild                     |    8 +
 include/linux/netfilter/nfnetlink.h                |    1 +
 include/linux/netfilter/x_tables.h                 |   15 +-
 include/linux/netfilter/xt_LED.h                   |   13 +
 include/linux/netfilter/xt_cluster.h               |   15 +
 include/linux/netfilter/xt_limit.h                 |    9 +-
 include/linux/netfilter/xt_quota.h                 |    4 +-
 include/linux/netfilter/xt_statistic.h             |    7 +-
 include/linux/netfilter_bridge.h                   |    4 +-
 include/linux/netfilter_ipv6/Kbuild                |    1 +
 include/linux/netlink.h                            |    2 +
 include/linux/netpoll.h                            |   11 +
 include/linux/nl80211.h                            |  177 +-
 include/linux/pci_ids.h                            |    6 +
 include/linux/phy.h                                |    3 +-
 include/linux/pim.h                                |    4 +-
 include/linux/ppp_channel.h                        |    6 +-
 include/linux/rds.h                                |  250 +
 include/linux/rtnetlink.h                          |    5 +-
 include/linux/sctp.h                               |   92 +-
 include/linux/skbuff.h                             |  124 +-
 include/linux/smsc911x.h                           |    3 +
 include/linux/socket.h                             |    3 +
 include/linux/sockios.h                            |    3 +
 include/linux/spi/libertas_spi.h                   |   32 +
 include/linux/ssb/ssb.h                            |    4 +
 include/linux/ssb/ssb_driver_chipcommon.h          |  224 +
 include/linux/ssb/ssb_regs.h                       |   36 +
 include/linux/sysctl.h                             |    1 +
 include/linux/tcp.h                                |   23 +-
 include/linux/timecompare.h                        |  125 +
 include/linux/usb/rndis_host.h                     |   85 +-
 include/linux/usb/usbnet.h                         |    5 +
 include/linux/virtio_net.h                         |   71 +
 include/linux/wimax/debug.h                        |    2 +-
 include/linux/wimax/i2400m.h                       |   69 +
 include/linux/wireless.h                           |   12 +-
 include/net/addrconf.h                             |    4 +-
 include/net/atmclip.h                              |    1 -
 include/net/ax88796.h                              |   13 +-
 include/net/bluetooth/bluetooth.h                  |   12 +
 include/net/bluetooth/hci.h                        |    8 +
 include/net/bluetooth/hci_core.h                   |   84 +-
 include/net/bluetooth/l2cap.h                      |   13 +-
 include/net/bluetooth/rfcomm.h                     |   20 +-
 include/net/cfg80211.h                             |  266 +-
 include/net/dsa.h                                  |   42 +-
 include/net/if_inet6.h                             |    5 +-
 include/net/inet_ecn.h                             |    4 +-
 include/net/inet_frag.h                            |    3 +-
 include/net/inet_hashtables.h                      |    4 +-
 include/net/ip.h                                   |    1 +
 include/net/ip_vs.h                                |    4 +-
 include/net/ipv6.h                                 |    4 +-
 include/net/ipx.h                                  |    2 +-
 include/net/mac80211.h                             |  260 +-
 include/net/netfilter/nf_conntrack.h               |    2 +-
 include/net/netfilter/nf_conntrack_l4proto.h       |   10 +-
 include/net/netfilter/nf_log.h                     |   11 +-
 include/net/netns/ipv4.h                           |   13 +
 include/net/netrom.h                               |    4 -
 include/net/phonet/phonet.h                        |    1 -
 include/net/phonet/pn_dev.h                        |    5 +-
 include/net/pkt_sched.h                            |    1 +
 include/net/psnap.h                                |    6 +-
 include/net/sch_generic.h                          |   28 +-
 include/net/sctp/checksum.h                        |   14 +-
 include/net/sctp/command.h                         |    3 +-
 include/net/sctp/sctp.h                            |    9 +-
 include/net/sctp/structs.h                         |    7 +
 include/net/sock.h                                 |   49 +-
 include/net/tcp.h                                  |   37 +-
 include/net/transp_v6.h                            |    2 +-
 include/net/udp.h                                  |    2 +
 include/net/wireless.h                             |   86 +-
 include/rdma/ib_verbs.h                            |    2 +-
 include/trace/skb.h                                |   11 +
 kernel/sysctl_check.c                              |    1 +
 kernel/time/Makefile                               |    2 +-
 kernel/time/clocksource.c                          |   76 +
 kernel/time/timecompare.c                          |  191 +
 lib/kobject_uevent.c                               |    3 +
 net/802/psnap.c                                    |   15 +-
 net/802/tr.c                                       |    2 +
 net/8021q/vlan.c                                   |    4 +-
 net/8021q/vlan_core.c                              |   53 +-
 net/9p/trans_fd.c                                  |    2 +-
 net/Kconfig                                        |   17 +-
 net/Makefile                                       |    1 +
 net/appletalk/ddp.c                                |   10 +-
 net/appletalk/dev.c                                |   10 +-
 net/atm/br2684.c                                   |   58 +-
 net/atm/clip.c                                     |   39 +-
 net/atm/lec.c                                      |   66 +-
 net/atm/lec.h                                      |    1 -
 net/atm/mpc.c                                      |   32 +-
 net/atm/mpc.h                                      |    5 +-
 net/ax25/af_ax25.c                                 |   21 +-
 net/ax25/ax25_iface.c                              |   13 +-
 net/bluetooth/af_bluetooth.c                       |   17 +-
 net/bluetooth/cmtp/core.c                          |    3 +-
 net/bluetooth/hci_conn.c                           |   64 +-
 net/bluetooth/hci_core.c                           |    3 +-
 net/bluetooth/hci_event.c                          |   26 +-
 net/bluetooth/l2cap.c                              |  602 +-
 net/bluetooth/rfcomm/core.c                        |  179 +-
 net/bluetooth/rfcomm/sock.c                        |  189 +-
 net/bluetooth/sco.c                                |   57 +-
 net/bridge/br_if.c                                 |    1 -
 net/bridge/br_netfilter.c                          |    2 +-
 net/bridge/br_netlink.c                            |    3 +-
 net/bridge/netfilter/ebt_log.c                     |    2 +-
 net/bridge/netfilter/ebt_ulog.c                    |   14 +-
 net/bridge/netfilter/ebtable_broute.c              |    1 -
 net/bridge/netfilter/ebtable_filter.c              |    1 -
 net/bridge/netfilter/ebtable_nat.c                 |    1 -
 net/can/af_can.c                                   |    5 +-
 net/can/raw.c                                      |    3 +
 net/compat.c                                       |   19 +-
 net/core/Makefile                                  |    3 +
 net/core/datagram.c                                |    2 +-
 net/core/dev.c                                     |  258 +-
 net/core/drop_monitor.c                            |  263 +
 net/core/ethtool.c                                 |   58 +-
 net/core/fib_rules.c                               |    3 +-
 net/core/neighbour.c                               |   15 +-
 net/core/net-sysfs.c                               |    2 +-
 net/core/net-traces.c                              |   29 +
 net/core/pktgen.c                                  |   18 +-
 net/core/rtnetlink.c                               |    9 +-
 net/core/skbuff.c                                  |  235 +-
 net/core/sock.c                                    |   95 +-
 net/core/sysctl_net_core.c                         |    1 +
 net/core/utils.c                                   |    1 -
 net/dccp/ackvec.h                                  |    3 +
 net/dccp/dccp.h                                    |   26 +-
 net/dccp/feat.c                                    |  232 +-
 net/dccp/feat.h                                    |   21 +-
 net/dccp/minisocks.c                               |   11 -
 net/dccp/options.c                                 |    8 -
 net/dccp/output.c                                  |   37 +-
 net/dccp/proto.c                                   |    2 -
 net/dccp/sysctl.c                                  |   43 +-
 net/decnet/af_decnet.c                             |   25 +-
 net/decnet/dn_dev.c                                |    6 +-
 net/decnet/dn_route.c                              |    8 +-
 net/decnet/dn_table.c                              |    3 +-
 net/decnet/sysctl_net_decnet.c                     |    2 +-
 net/dsa/Kconfig                                    |    6 +-
 net/dsa/dsa.c                                      |  177 +-
 net/dsa/dsa_priv.h                                 |   97 +-
 net/dsa/mv88e6060.c                                |   12 +-
 net/dsa/mv88e6123_61_65.c                          |   92 +-
 net/dsa/mv88e6131.c                                |   98 +-
 net/dsa/slave.c                                    |   34 +-
 net/dsa/tag_dsa.c                                  |   34 +-
 net/dsa/tag_edsa.c                                 |   34 +-
 net/dsa/tag_trailer.c                              |   14 +-
 net/econet/af_econet.c                             |    4 +-
 net/ipv4/Kconfig                                   |   52 +-
 net/ipv4/af_inet.c                                 |   28 +-
 net/ipv4/arp.c                                     |   13 +-
 net/ipv4/devinet.c                                 |   12 +-
 net/ipv4/fib_frontend.c                            |    2 +-
 net/ipv4/fib_semantics.c                           |    5 +-
 net/ipv4/icmp.c                                    |    2 +
 net/ipv4/inet_connection_sock.c                    |   42 +-
 net/ipv4/inet_fragment.c                           |    1 +
 net/ipv4/inet_hashtables.c                         |   12 +-
 net/ipv4/ip_gre.c                                  |  136 +-
 net/ipv4/ip_output.c                               |    6 +
 net/ipv4/ipconfig.c                                |    8 +-
 net/ipv4/ipip.c                                    |    7 +-
 net/ipv4/ipmr.c                                    |  464 +-
 net/ipv4/netfilter/Kconfig                         |   30 +-
 net/ipv4/netfilter/Makefile                        |    2 -
 net/ipv4/netfilter/arp_tables.c                    |  163 +-
 net/ipv4/netfilter/arptable_filter.c               |    2 -
 net/ipv4/netfilter/ip_queue.c                      |    2 +
 net/ipv4/netfilter/ip_tables.c                     |  153 +-
 net/ipv4/netfilter/ipt_LOG.c                       |    2 +-
 net/ipv4/netfilter/ipt_TTL.c                       |   97 -
 net/ipv4/netfilter/ipt_ULOG.c                      |    2 +-
 net/ipv4/netfilter/ipt_ttl.c                       |   63 -
 net/ipv4/netfilter/iptable_filter.c                |    1 -
 net/ipv4/netfilter/iptable_mangle.c                |    1 -
 net/ipv4/netfilter/iptable_raw.c                   |    1 -
 net/ipv4/netfilter/iptable_security.c              |    1 -
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c     |    4 +-
 net/ipv4/netfilter/nf_nat_rule.c                   |    1 -
 net/ipv4/netfilter/nf_nat_snmp_basic.c             |    4 +-
 net/ipv4/proc.c                                    |    4 +-
 net/ipv4/raw.c                                     |    1 +
 net/ipv4/route.c                                   |   15 +-
 net/ipv4/tcp.c                                     |   89 +-
 net/ipv4/tcp_bic.c                                 |   11 +-
 net/ipv4/tcp_cong.c                                |   21 +-
 net/ipv4/tcp_cubic.c                               |   11 +-
 net/ipv4/tcp_htcp.c                                |    3 +-
 net/ipv4/tcp_input.c                               |  198 +-
 net/ipv4/tcp_ipv4.c                                |   11 +-
 net/ipv4/tcp_minisocks.c                           |    9 +-
 net/ipv4/tcp_output.c                              |   94 +-
 net/ipv4/tcp_probe.c                               |    5 +-
 net/ipv4/tcp_scalable.c                            |   10 +-
 net/ipv4/tcp_timer.c                               |   23 +-
 net/ipv4/tcp_veno.c                                |    7 +-
 net/ipv4/tcp_yeah.c                                |    9 +-
 net/ipv4/udp.c                                     |   15 +-
 net/ipv4/xfrm4_policy.c                            |    2 +-
 net/ipv6/addrconf.c                                |  116 +-
 net/ipv6/af_inet6.c                                |   60 +-
 net/ipv6/ipv6_sockglue.c                           |    3 +-
 net/ipv6/ndisc.c                                   |   22 +-
 net/ipv6/netfilter/Kconfig                         |   38 +-
 net/ipv6/netfilter/Makefile                        |    2 -
 net/ipv6/netfilter/ip6_queue.c                     |    1 +
 net/ipv6/netfilter/ip6_tables.c                    |  152 +-
 net/ipv6/netfilter/ip6t_HL.c                       |   95 -
 net/ipv6/netfilter/ip6t_LOG.c                      |    2 +-
 net/ipv6/netfilter/ip6t_hl.c                       |   68 -
 net/ipv6/netfilter/ip6table_filter.c               |    1 -
 net/ipv6/netfilter/ip6table_mangle.c               |    1 -
 net/ipv6/netfilter/ip6table_raw.c                  |    1 -
 net/ipv6/netfilter/ip6table_security.c             |    1 -
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c     |    1 +
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c     |    4 +
 net/ipv6/route.c                                   |    9 +-
 net/ipv6/sit.c                                     |    5 +-
 net/ipv6/tcp_ipv6.c                                |    8 +-
 net/ipv6/udp.c                                     |   28 +
 net/ipv6/xfrm6_policy.c                            |    2 +-
 net/ipv6/xfrm6_state.c                             |    2 +-
 net/ipx/af_ipx.c                                   |   20 +-
 net/irda/irda_device.c                             |    5 +-
 net/irda/irlan/irlan_eth.c                         |   19 +-
 net/irda/irmod.c                                   |    4 +-
 net/iucv/af_iucv.c                                 |    3 +-
 net/key/af_key.c                                   |    6 +-
 net/llc/af_llc.c                                   |    6 +-
 net/llc/llc_conn.c                                 |    3 +-
 net/llc/llc_core.c                                 |    8 +-
 net/mac80211/Makefile                              |    6 +-
 net/mac80211/aes_cmac.c                            |  135 +
 net/mac80211/aes_cmac.h                            |   19 +
 net/mac80211/agg-rx.c                              |  302 +
 net/mac80211/agg-tx.c                              |  701 +
 net/mac80211/cfg.c                                 |  170 +-
 net/mac80211/debugfs.c                             |   59 +-
 net/mac80211/debugfs_key.c                         |   79 +-
 net/mac80211/debugfs_key.h                         |   10 +
 net/mac80211/debugfs_netdev.c                      |   48 +-
 net/mac80211/debugfs_sta.c                         |    5 +-
 net/mac80211/ht.c                                  |  903 +-
 net/mac80211/ibss.c                                |  907 +
 net/mac80211/ieee80211_i.h                         |  278 +-
 net/mac80211/iface.c                               |  168 +-
 net/mac80211/key.c                                 |  115 +-
 net/mac80211/key.h                                 |   16 +
 net/mac80211/main.c                                |  172 +-
 net/mac80211/mesh.c                                |   15 +-
 net/mac80211/mesh.h                                |   10 +-
 net/mac80211/mesh_hwmp.c                           |    7 +-
 net/mac80211/mesh_plink.c                          |   38 +-
 net/mac80211/mlme.c                                | 1885 +-
 net/mac80211/pm.c                                  |  117 +
 net/mac80211/rate.h                                |   12 +
 net/mac80211/rx.c                                  |  406 +-
 net/mac80211/scan.c                                |  688 +-
 net/mac80211/spectmgmt.c                           |  103 +-
 net/mac80211/sta_info.c                            |   52 +-
 net/mac80211/sta_info.h                            |   13 +-
 net/mac80211/tx.c                                  |  122 +-
 net/mac80211/util.c                                |  267 +-
 net/mac80211/wext.c                                |  467 +-
 net/mac80211/wme.c                                 |  170 +-
 net/mac80211/wme.h                                 |    6 -
 net/mac80211/wpa.c                                 |  152 +-
 net/mac80211/wpa.h                                 |    5 +
 net/netfilter/Kconfig                              |   63 +
 net/netfilter/Makefile                             |    4 +
 net/netfilter/core.c                               |    2 -
 net/netfilter/ipvs/ip_vs_sync.c                    |    4 +-
 net/netfilter/nf_conntrack_amanda.c                |    4 +-
 net/netfilter/nf_conntrack_core.c                  |   14 +-
 net/netfilter/nf_conntrack_expect.c                |    3 +-
 net/netfilter/nf_conntrack_h323_main.c             |    8 +-
 net/netfilter/nf_conntrack_netbios_ns.c            |    2 +-
 net/netfilter/nf_conntrack_netlink.c               |  161 +-
 net/netfilter/nf_conntrack_pptp.c                  |    2 +-
 net/netfilter/nf_conntrack_proto.c                 |   21 -
 net/netfilter/nf_conntrack_proto_dccp.c            |  145 +-
 net/netfilter/nf_conntrack_proto_generic.c         |    2 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |    5 +-
 net/netfilter/nf_conntrack_proto_udp.c             |    2 +
 net/netfilter/nf_log.c                             |  201 +-
 net/netfilter/nf_tproxy_core.c                     |    1 +
 net/netfilter/nfnetlink.c                          |    6 +
 net/netfilter/nfnetlink_log.c                      |   18 +-
 net/netfilter/x_tables.c                           |   26 +-
 net/netfilter/xt_HL.c                              |  171 +
 net/netfilter/xt_LED.c                             |  161 +
 net/netfilter/xt_cluster.c                         |  164 +
 net/netfilter/xt_hashlimit.c                       |    7 +-
 net/netfilter/xt_hl.c                              |  108 +
 net/netfilter/xt_limit.c                           |   40 +-
 net/netfilter/xt_physdev.c                         |   37 +-
 net/netfilter/xt_quota.c                           |   31 +-
 net/netfilter/xt_statistic.c                       |   28 +-
 net/netlink/af_netlink.c                           |   88 +-
 net/netrom/af_netrom.c                             |   13 +-
 net/netrom/nr_dev.c                                |   26 +-
 net/packet/af_packet.c                             |    5 +-
 net/phonet/af_phonet.c                             |   34 +-
 net/phonet/pn_dev.c                                |  119 +-
 net/phonet/pn_netlink.c                            |   29 +-
 net/rds/Kconfig                                    |   14 +
 net/rds/Makefile                                   |   14 +
 net/rds/af_rds.c                                   |  586 +
 net/rds/bind.c                                     |  199 +
 net/rds/cong.c                                     |  404 +
 net/rds/connection.c                               |  487 +
 net/rds/ib.c                                       |  323 +
 net/rds/ib.h                                       |  367 +
 net/rds/ib_cm.c                                    |  726 +
 net/rds/ib_rdma.c                                  |  641 +
 net/rds/ib_recv.c                                  |  869 +
 net/rds/ib_ring.c                                  |  168 +
 net/rds/ib_send.c                                  |  874 +
 net/rds/ib_stats.c                                 |   95 +
 net/rds/ib_sysctl.c                                |  137 +
 net/rds/info.c                                     |  241 +
 net/rds/info.h                                     |   30 +
 net/rds/iw.c                                       |  333 +
 net/rds/iw.h                                       |  395 +
 net/rds/iw_cm.c                                    |  750 +
 net/rds/iw_rdma.c                                  |  888 +
 net/rds/iw_recv.c                                  |  869 +
 net/rds/iw_ring.c                                  |  169 +
 net/rds/iw_send.c                                  |  975 +
 net/rds/iw_stats.c                                 |   95 +
 net/rds/iw_sysctl.c                                |  137 +
 net/rds/loop.c                                     |  188 +
 net/rds/loop.h                                     |    9 +
 net/rds/message.c                                  |  402 +
 net/rds/page.c                                     |  221 +
 net/rds/rdma.c                                     |  679 +
 net/rds/rdma.h                                     |   84 +
 net/rds/rdma_transport.c                           |  214 +
 net/rds/rdma_transport.h                           |   28 +
 net/rds/rds.h                                      |  686 +
 net/rds/recv.c                                     |  542 +
 net/rds/send.c                                     | 1003 +
 net/rds/stats.c                                    |  148 +
 net/rds/sysctl.c                                   |  122 +
 net/rds/threads.c                                  |  265 +
 net/rds/transport.c                                |  117 +
 net/rose/af_rose.c                                 |    3 +-
 net/rose/rose_dev.c                                |   22 +-
 net/sched/sch_api.c                                |   11 +
 net/sched/sch_cbq.c                                |    7 +-
 net/sched/sch_drr.c                                |    7 +-
 net/sched/sch_hfsc.c                               |   13 +-
 net/sched/sch_htb.c                                |   49 +-
 net/sched/sch_multiq.c                             |    2 +-
 net/sched/sch_tbf.c                                |    9 +-
 net/sctp/debug.c                                   |    4 +
 net/sctp/input.c                                   |   14 +-
 net/sctp/ipv6.c                                    |   36 +-
 net/sctp/output.c                                  |   21 +-
 net/sctp/outqueue.c                                |    6 +-
 net/sctp/protocol.c                                |   31 +-
 net/sctp/sm_make_chunk.c                           |   37 +-
 net/sctp/sm_sideeffect.c                           |   43 +-
 net/sctp/sm_statefuns.c                            |    6 +-
 net/sctp/socket.c                                  |  216 +-
 net/sctp/transport.c                               |    9 +-
 net/socket.c                                       |   84 +-
 net/sunrpc/xprtsock.c                              |   53 +-
 net/sysctl_net.c                                   |    2 +-
 net/tipc/bcast.c                                   |    4 +-
 net/tipc/bcast.h                                   |    2 +-
 net/tipc/dbg.c                                     |    2 +-
 net/tipc/node.c                                    |    2 +-
 net/unix/af_unix.c                                 |    3 +-
 net/wanrouter/wanmain.c                            |    8 +-
 net/wanrouter/wanproc.c                            |    2 +
 net/wimax/op-msg.c                                 |    9 +-
 net/wimax/stack.c                                  |   12 +-
 net/wireless/Makefile                              |    2 +-
 net/wireless/core.c                                |  136 +-
 net/wireless/core.h                                |   59 +-
 net/wireless/nl80211.c                             |  602 +-
 net/wireless/nl80211.h                             |   17 +
 net/wireless/reg.c                                 | 1226 +-
 net/wireless/reg.h                                 |   45 +-
 net/wireless/scan.c                                |  866 +
 net/wireless/sysfs.c                               |   39 +-
 net/wireless/util.c                                |    2 +-
 net/wireless/wext-compat.c                         |   97 +
 net/x25/af_x25.c                                   |   15 +-
 1194 files changed, 129817 insertions(+), 89563 deletions(-)
 create mode 100644 Documentation/networking/ixgbe.txt
 create mode 100644 Documentation/networking/rds.txt
 create mode 100644 Documentation/networking/timestamping.txt
 create mode 100644 Documentation/networking/timestamping/.gitignore
 create mode 100644 Documentation/networking/timestamping/Makefile
 create mode 100644 Documentation/networking/timestamping/timestamping.c
 create mode 100644 drivers/atm/solos-attrlist.c
 create mode 100644 drivers/net/bnx2x_dump.h
 rename drivers/net/{gianfar_mii.c => fsl_pq_mdio.c} (54%)
 create mode 100644 drivers/net/fsl_pq_mdio.h
 delete mode 100644 drivers/net/gianfar_mii.h
 create mode 100644 drivers/net/igb/e1000_mbx.c
 create mode 100644 drivers/net/igb/e1000_mbx.h
 create mode 100644 drivers/net/ixgbe/ixgbe_82599.c
 create mode 100644 drivers/net/ixgbe/ixgbe_dcb_82599.c
 create mode 100644 drivers/net/ixgbe/ixgbe_dcb_82599.h
 delete mode 100644 drivers/net/tehuti_fw.h
 delete mode 100644 drivers/net/typhoon-firmware.h
 delete mode 100644 drivers/net/ucc_geth_mii.c
 delete mode 100644 drivers/net/ucc_geth_mii.h
 create mode 100644 drivers/net/wimax/i2400m/sysfs.c
 create mode 100644 drivers/net/wireless/at76c50x-usb.c
 create mode 100644 drivers/net/wireless/at76c50x-usb.h
 create mode 100644 drivers/net/wireless/ath5k/led.c
 create mode 100644 drivers/net/wireless/ath5k/rfbuffer.h
 create mode 100644 drivers/net/wireless/ath5k/rfgain.h
 create mode 100644 drivers/net/wireless/ath9k/ahb.c
 create mode 100644 drivers/net/wireless/ath9k/ani.h
 create mode 100644 drivers/net/wireless/ath9k/calib.h
 delete mode 100644 drivers/net/wireless/ath9k/core.h
 create mode 100644 drivers/net/wireless/ath9k/debug.h
 create mode 100644 drivers/net/wireless/ath9k/eeprom.h
 create mode 100644 drivers/net/wireless/ath9k/mac.h
 create mode 100644 drivers/net/wireless/ath9k/pci.c
 create mode 100644 drivers/net/wireless/ath9k/virtual.c
 create mode 100644 drivers/net/wireless/b43/tables_lpphy.c
 create mode 100644 drivers/net/wireless/b43/tables_lpphy.h
 rename {include/net => drivers/net/wireless/ipw2x00}/ieee80211.h (90%)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-1000.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-commands.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-debug.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-fh.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-io.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-rs.h
 rename drivers/net/wireless/iwlwifi/{iwl-3945-core.h => iwl-6000-hw.h} (64%)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-6000.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c
 create mode 100644 drivers/net/wireless/libertas/if_spi.c
 create mode 100644 drivers/net/wireless/libertas/if_spi.h
 create mode 100644 drivers/net/wireless/mwl8k.c
 create mode 100644 drivers/net/wireless/orinoco/Kconfig
 create mode 100644 drivers/net/wireless/orinoco/fw.c
 create mode 100644 drivers/net/wireless/orinoco/fw.h
 create mode 100644 drivers/net/wireless/orinoco/hw.c
 create mode 100644 drivers/net/wireless/orinoco/hw.h
 create mode 100644 drivers/net/wireless/orinoco/main.c
 create mode 100644 drivers/net/wireless/orinoco/main.h
 create mode 100644 drivers/net/wireless/orinoco/mic.c
 create mode 100644 drivers/net/wireless/orinoco/mic.h
 delete mode 100644 drivers/net/wireless/orinoco/orinoco.c
 create mode 100644 drivers/net/wireless/orinoco/scan.c
 create mode 100644 drivers/net/wireless/orinoco/scan.h
 create mode 100644 drivers/net/wireless/orinoco/wext.c
 create mode 100644 drivers/net/wireless/orinoco/wext.h
 create mode 100644 drivers/net/wireless/p54/p54spi.c
 create mode 100644 drivers/net/wireless/p54/p54spi.h
 create mode 100644 drivers/net/wireless/p54/p54spi_eeprom.h
 create mode 100644 drivers/net/wireless/rt2x00/rt2x00link.c
 create mode 100644 drivers/ssb/driver_chipcommon_pmu.c
 create mode 100644 firmware/3com/typhoon.bin.ihex
 delete mode 100644 firmware/cxgb3/t3fw-7.0.0.bin.ihex
 create mode 100644 firmware/cxgb3/t3fw-7.1.0.bin.ihex
 create mode 100644 firmware/tehuti/bdx.bin.ihex
 create mode 100644 include/linux/ath9k_platform.h
 create mode 100644 include/linux/net_dropmon.h
 create mode 100644 include/linux/net_tstamp.h
 create mode 100644 include/linux/netfilter/xt_LED.h
 create mode 100644 include/linux/netfilter/xt_cluster.h
 create mode 100644 include/linux/rds.h
 create mode 100644 include/linux/spi/libertas_spi.h
 create mode 100644 include/linux/timecompare.h
 create mode 100644 include/trace/skb.h
 create mode 100644 kernel/time/timecompare.c
 create mode 100644 net/core/drop_monitor.c
 create mode 100644 net/core/net-traces.c
 delete mode 100644 net/ipv4/netfilter/ipt_TTL.c
 delete mode 100644 net/ipv4/netfilter/ipt_ttl.c
 delete mode 100644 net/ipv6/netfilter/ip6t_HL.c
 delete mode 100644 net/ipv6/netfilter/ip6t_hl.c
 create mode 100644 net/mac80211/aes_cmac.c
 create mode 100644 net/mac80211/aes_cmac.h
 create mode 100644 net/mac80211/agg-rx.c
 create mode 100644 net/mac80211/agg-tx.c
 create mode 100644 net/mac80211/ibss.c
 create mode 100644 net/mac80211/pm.c
 create mode 100644 net/netfilter/xt_HL.c
 create mode 100644 net/netfilter/xt_LED.c
 create mode 100644 net/netfilter/xt_cluster.c
 create mode 100644 net/netfilter/xt_hl.c
 create mode 100644 net/rds/Kconfig
 create mode 100644 net/rds/Makefile
 create mode 100644 net/rds/af_rds.c
 create mode 100644 net/rds/bind.c
 create mode 100644 net/rds/cong.c
 create mode 100644 net/rds/connection.c
 create mode 100644 net/rds/ib.c
 create mode 100644 net/rds/ib.h
 create mode 100644 net/rds/ib_cm.c
 create mode 100644 net/rds/ib_rdma.c
 create mode 100644 net/rds/ib_recv.c
 create mode 100644 net/rds/ib_ring.c
 create mode 100644 net/rds/ib_send.c
 create mode 100644 net/rds/ib_stats.c
 create mode 100644 net/rds/ib_sysctl.c
 create mode 100644 net/rds/info.c
 create mode 100644 net/rds/info.h
 create mode 100644 net/rds/iw.c
 create mode 100644 net/rds/iw.h
 create mode 100644 net/rds/iw_cm.c
 create mode 100644 net/rds/iw_rdma.c
 create mode 100644 net/rds/iw_recv.c
 create mode 100644 net/rds/iw_ring.c
 create mode 100644 net/rds/iw_send.c
 create mode 100644 net/rds/iw_stats.c
 create mode 100644 net/rds/iw_sysctl.c
 create mode 100644 net/rds/loop.c
 create mode 100644 net/rds/loop.h
 create mode 100644 net/rds/message.c
 create mode 100644 net/rds/page.c
 create mode 100644 net/rds/rdma.c
 create mode 100644 net/rds/rdma.h
 create mode 100644 net/rds/rdma_transport.c
 create mode 100644 net/rds/rdma_transport.h
 create mode 100644 net/rds/rds.h
 create mode 100644 net/rds/recv.c
 create mode 100644 net/rds/send.c
 create mode 100644 net/rds/stats.c
 create mode 100644 net/rds/sysctl.c
 create mode 100644 net/rds/threads.c
 create mode 100644 net/rds/transport.c
 create mode 100644 net/wireless/scan.c
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
