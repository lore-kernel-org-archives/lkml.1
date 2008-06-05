Return-Path: <linux-kernel-owner+w=401wt.eu-S1763239AbYFEDhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763239AbYFEDhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 23:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbYFEDg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 23:36:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751649AbYFEDg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 23:36:57 -0400
Date: Wed, 4 Jun 2008 20:36:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.26-rc5
Message-ID: <alpine.LFD.1.10.0806042018060.3473@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Another week, another batch of mostly pretty small fixes. Hopefully the 
regression list is shrinking, and we've fixed at least a couple of the 
oopses on Arjan's list.

As usual, the bulk of the changes are in drivers and arch code - together 
they are about 70% of the diffstat. And the arch stats are bloated by some 
new/updated SH and avr defconfig files, which is also fairly common at 
this stage.

Perhaps unusually, 13% is in kernel/, almost all of it fixing up some 
scheduler issues - with the bulk of it by far being a couple of reverts 
due to performance regressions. But there's a few other fixes too.

And then there is networking and some ocfs2 updates. Along with various 
one-liners sprinkled all around.

   5.9% arch/avr32/configs/
   5.9% arch/avr32/
   2.7% arch/blackfin/mach-bf537/boards/
   2.6% arch/blackfin/mach-bf548/boards/
   5.4% arch/blackfin/
  20.6% arch/sh/configs/
  21.3% arch/sh/
  38.0% arch/
   5.6% drivers/ata/
   3.4% drivers/char/hw_random/
   3.1% drivers/net/
   2.1% drivers/pci/hotplug/
   2.3% drivers/pci/
   2.4% drivers/scsi/qla2xxx/
   2.6% drivers/scsi/
   3.0% drivers/usb/misc/
   2.7% drivers/usb/serial/
   8.3% drivers/usb/
  31.7% drivers/
   2.0% fs/
   3.7% include/
  13.0% kernel/
   2.9% net/ipv6/
   2.5% net/sctp/
   8.8% net/

The shortlog (appended) gives a reasonable view of it all. Nothing hugely 
exciting sticks to my mind, but then I don't think we've had any really 
hugely exciting problem spots either..

		Linus

---
Abhijeet Kolekar (1):
      mac80211 : Fixes the status message for iwconfig

Adrian Bunk (5):
      avr32: export copy_page
      avr32: export strnlen_user
      show_schedstat(): fix memleak
      sh/kernel/cpu/irq/intc-sh5.c build fix
      bridge: update URL

Adrian-Ken Rueegsegger (1):
      xfrm: xfrm_algo: correct usage of RIPEMD-160

Al Viro (9):
      ibmaem endianness annotations
      usb/c67x00 endianness annotations
      cdc-wdm endianness fixes
      isp1760-if iomem annotations
      cifs endianness fixes
      s2io iomem annotations
      mpc52xx_gpio iomem annotations
      celleb_scc_pciex endianness misannotations
      bogus format in ip6mr

Alan Cox (2):
      serial_core: uart_set_ldisc infrastructure
      libata-sff: Fix oops reported in kerneloops.org for pnp devices with no ctl

Alan D. Brunelle (2):
      Added in MESSAGE notes for blktraces
      Added in elevator switch message to blktrace stream

Alan Stern (8):
      USB: fix possible deadlock involving sysfs attributes
      USB: add all configs to the "descriptors" attribute
      USB: EHCI: fix up root-hub TT mess
      USB: EHCI: suppress unwanted error messages
      USB: EHCI: fix remote-wakeup regression
      USB: EHCI: fix bug in Iso scheduling
      USB: EHCI: fix performance regression
      USB: usb-storage: unusual_devs update for Cypress ATACB

Alexey Dobriyan (4):
      netfilter: nf_conntrack_expect: fix error path unwind in nf_conntrack_expect_init()
      atl1: fix 4G memory corruption bug
      [CRYPTO] cts: Init SG tables
      sparc: switch /proc/led to seq_file

Andrea Merello (3):
      rtl8180: fix wrong parameter in sa2400_rf_set_channel
      rtl8180: fix wrong parameter in max2820_rf_set_channel
      rtl8180: fix wrong parameter in grf5101_rf_set_channel

Andrew Morton (2):
      x86: section mismatch fix
      airo warning fix

Andrew Vasquez (8):
      [SCSI] qla2xxx: Display driver version at module init-time.
      [SCSI] qla2xxx: Correct locking within MSI-X interrupt handlers.
      [SCSI] qla2xxx: Don't depend on mailbox return values while enabling FCE tracing.
      [SCSI] qla2xxx: Extend the 'fw_dump' SYSFS node the ability to initiate a firmware dump.
      [SCSI] qla2xxx: Disable local-interrupts while polling for RISC status.
      [SCSI] qla2xxx: Revert "qla2xxx: Validate mid-layer 'underflow' during check-condition handling."
      [SCSI] qla2xxx: Update version number to 8.02.01-k3.
      [SCSI] qla2xxx: Update version number to 8.02.01-k4.

Anton Vorontsov (1):
      mmc_spi: mmc_spi.h should include linux/interrupts.h

Antonio Ospite (1):
      Input: pxa27x_keypad - miscellaneous fixes

Arjan van de Ven (1):
      bluetooth: fix locking bug in the rfcomm socket cleanup handling

Arnaldo Carvalho de Melo (1):
      llc: Fix double accounting of received packets

Ashish Kalra (1):
      [libata] sata_fsl: Fix broken driver, add port multiplier (PMP) support

Ben Hutchings (1):
      [netdrvr] sfc: Report XAUI link down at default log level

Benjamin Herrenschmidt (3):
      sparc64: IO accessors fix
      PCI: fix rpadlpar pci hotplug driver sysfs usage
      [POWERPC] Add "memory" clobber to MMIO accessors

Bjorn Helgaas (1):
      PNP: mark resources that conflict with PCI devices "disabled"

Brian King (1):
      [SCSI] ibmvscsi: Non SCSI error status fixup

Brice Goglin (2):
      myri10ge: update driver version
      net_dma: remove duplicate assignment in dma_skb_copy_datagram_iovec

Bruno Prémont (2):
      Input: i8042 - add Dritek quirk for Acer TravelMate 660
      Input: i8042 - make sure Dritek quirk is invoked at resume

Bryan Wu (3):
      Blackfin arch: Fix typo. it should be _outsw_8
      Blackfin arch: Fix bug - set corret SSEL and IRQ to enable AD7877 on BF527
      8250 Serial Driver: revert extra IRQ flag definition patch

Casey Schaufler (1):
      Smack: fuse mount hang fix

Cesar Eduardo Barros (1):
      sc92031: remove bogus unlikely()

Chris Lalancette (1):
      Fix crash in virtio_blk during modprobe ; rmmod ; modprobe

Christian Borntraeger (5):
      virtio_blk: allow read-only disks
      virtio_net: another race with virtio_net and enable_cb
      virtio_config: fix len calculation of config elements
      virtio_blk: fix endianess annotations
      [S390] s390 types: make dma_addr_t 64 bit capable

Colin (1):
      [IPV6] TUNNEL6: Fix incoming packet length check for inter-protocol tunnel.

Colin Ian King (1):
      [libata] ata_piix: more acer short cable quirks

Dan Williams (1):
      ipw2200: expire and use oldest BSS on adhoc create

Daniel Walker (1):
      [SCSI] qla2xxx: firmware semaphore to mutex

Dave Young (1):
      bluetooth: rfcomm_dev_state_change deadlock fix

David Howells (2):
      FRV: Specify the minimum slab/kmalloc alignment
      Fix FRV minimum slab/kmalloc alignment

David Woodhouse (1):
      ck804rom: fix driver_data in probe table.

Denis V. Lunev (4):
      [IPV6]: Do not change protocol for raw IPv6 sockets.
      [IPV6]: inet_sk(sk)->cork.opt leak
      [IPV6]: Do not change protocol for UDPv6 sockets with pending sent data.
      raw: Raw socket leak.

Dmitry Torokhov (2):
      Input: atkbd - mark keyboard as disabled when suspending/unloading
      Input: gtco - fix double kfree in error handling path

Dong Wei (1):
      netfilter: xt_connlimit: fix accouning when receive RST packet in ESTABLISHED state

Felix Homann (1):
      USB ID for Philips CPWUA054/00 Wireless USB Adapter 11g

Gerald Schaefer (1):
      [S390] appldata: prevent cpu hotplug when walking cpu_online_map.

Gerrit Renker (1):
      dccp ccid-3: Fix "t_ipi explosion" bug

Grant Grundler (1):
      [netdrvr] tulip: oops in tulip_interrupt when hibernating with swsusp/suspend2

Greg Kroah-Hartman (1):
      Revert "USB: EHCI: fix performance regression"

Gui Jianfeng (2):
      sctp: retran_path update bug fix
      sctp: Move sctp_v4_dst_saddr out of loop

Guy Cohen (2):
      iwlwifi: fix exit from stay_in_table state
      iwlwifi: fix rate scale TLC column selection bug

Haavard Skinnemoen (2):
      avr32: Update defconfigs
      avr32: Fix cpufreq oops when ondemand governor is default

Hans-Joachim Picht (1):
      [S390] fix sparsemem related compile error with allnoconfig on s390

Harvey Harrison (3):
      kgdb: use common ascii helpers and put_unaligned_be32 helper
      acpi: fix sparse const errors
      sh: module.c use kernel unaligned helpers

Heiko Carstens (3):
      [S390] Fix section mismatch warnings.
      [S390] showmem: Only walk spanned pages.
      [S390] sclp_vt220: fix scheduling while atomic bug.

Henrique de Moraes Holschuh (1):
      Input: rename SW_RADIO to SW_RFKILL_ALL

Holger Macht (1):
      [libata] ACPI: Properly handle bay devices in dock stations

Holger Schurig (1):
      libertas: fix command size for CMD_802_11_SUBSCRIBE_EVENT

Huang Weiyi (1):
      Input: apanel - remove duplicate include

Hugh Dickins (1):
      x86: fix bad pmd ffff810000207xxx(9090909090909090)

Ilpo Järvinen (2):
      tcp: Fix inconsistency source (CA_Open only when !tcp_left_out(tp))
      tcp: fix skb vs fack_count out-of-sync condition

Ingo Molnar (7):
      revert ("sched: fair: weight calculations")
      sched: cleanup
      revert ("sched: fair-group: SMP-nice for group scheduling")
      sched: re-tune NUMA topologies
      drivers/watchdog/geodewdt.c: build fix
      x86: disable preemption in native_smp_prepare_cpus
      x86: ioremap fix failing nesting check

Ivo van Doorn (4):
      rt2x00: Fix memleak in tx() path
      rt2x00: Don't count retries as failure
      rt2x00: Reset antenna RSSI after switch
      rt2x00: Use atomic interface iteration in irq context

James Bottomley (1):
      [SCSI] fix intermittent oops in scsi_bus_uevent

James Chapman (2):
      lt2p: Fix possible WARN_ON from socket code when UDP socket is closed
      l2tp: Fix possible oops if transmitting or receiving when tunnel goes down

Jarek Poplawski (2):
      ax25: Fix NULL pointer dereference and lockup.
      netfilter: nf_conntrack_ipv6: fix inconsistent lock state in nf_ct_frag6_gather()

Jason Wessel (1):
      kgdbts: Use HW breakpoints with CONFIG_DEBUG_RODATA

Javier Smaldone (1):
      USB: Add support for ROKR W5 in unusual_devs.h

Jens Axboe (3):
      splice: handle try_to_release_page() failure
      block: make blktrace use per-cpu buffers for message notes
      cfq-iosched: fix RCU problem in cfq_cic_lookup()

Joakim Tjernlund (1):
      ucc_geth_ethtool: Fix typo

Joel Becker (1):
      ocfs2: Rename 'user_stack' plugin structure to 'ocfs2_user_plugin'

John W. Linville (1):
      rtl8180: avoid NULL dereference in max2820_rf_set_channel

Jussi Kivilinna (1):
      rndis_wlan: add missing range check for power_output modparam

Kenji Kaneshige (7):
      shpchp: add message about shpchp_slot_with_bus option
      pciehp: fix NULL dereference in interrupt handler
      pciehp: fix slow probing
      pciehp: poll cmd completion if hotplug interrupt is disabled
      pciehp: move msleep after power off
      pci hotplug core: add check of duplicate slot name
      pciehp: add message about pciehp_slot_with_bus option

Kevin Winchester (1):
      x86: fix pointer type warning in arch/x86/mm/init_64.c:early_memtest

Li Yang (2):
      USB: fsl_usb2_udc: fix recursive lock
      ucc_geth_ethtool: Add a missing HW stats counter

Linus Torvalds (3):
      Mark 'scripts/decodecode' executable
      Fix uart_set_ldisc() function type
      Linux 2.6.26-rc5

Lothar Waßmann (1):
      [CPUFREQ] fix double unlock of cpu_policy_rwsem in drivers/cpufreq/cpufreq.c

Mark Asselstine (1):
      sunhme: Cleanup use of deprecated calls to save_and_cli and restore_flags.

Mark Brown (4):
      Input: wm97xx-core - report a phys for WM97xx touchscreens
      Input: wm97xx-core - fix driver name
      Input: wm97xx-core - fix race on PHY init
      Input: wm9713 - support five wire panels

Mark Lord (6):
      sata_mv: move SOC_FLAG to hpriv
      sata_mv: PHY_MODEx errata fixes
      sata_mv: nuke unreleased GenIIe revisions
      sata_mv: workaround for 60x1 errata sata13
      sata_mv: implement SoC guideline SATA_S11
      sata_mv: PHY_MODE4 cleanups

Martin Schwidefsky (4):
      [S390] 3270: fix race with stack local wait_queue_head_t.
      [S390] tape: fix race with stack local wait_queue_head_t.
      [S390] disassembler: fix idte instruction format.
      [S390] Update default configuration.

Matthew Garrett (1):
      USB: Firmware loader driver for USB Apple iSight camera

Michael Buesch (4):
      b43: Upload both beacon templates on initial load
      b43: Fix controller restart crash
      b43legacy: Fix controller restart crash
      ssb: Fix context assertion in ssb_pcicore_dev_irqvecs_enable

Michael Hennerich (2):
      Blackfin arch: Cleanup no functional changes
      Blackfin arch: Remove bad and usless code

Michael Holzheu (1):
      [S390] tape: Fix race condition in tape block device driver

Michael Karcher (1):
      USB: usb-serial: option: Don't match Huawei driver CD images

Michael Reed (1):
      [SCSI] fusion mpt: fix target missing after resetting external raid

Mike Frysinger (1):
      Blackfin arch: update anomaly headers from toolchain trunk

Mike Galbraith (1):
      sched: stop wake_affine from causing serious imbalance

Nicolas Kaiser (1):
      net/mac80211: always true conditionals

Octavian Purdila (1):
      tcp: Fix for race due to temporary drop of the socket lock in skb_splice_bits.

Olof Johansson (2):
      electra_cf: Add MODULE_DEVICE_TABLE()
      [POWERPC] pasemi: update pasemi_defconfig, enable electra_cf

Paul Mundt (4):
      sh: fix miscompilation of ip_fast_csum with gcc >= 4.3
      sh: Disable 4KSTACKS on nommu.
      sh: Update SE7206 defconfig.
      sh: Add defconfig for RSK7203.

Pavel Emelyanov (1):
      irda: Sock leak on error path in irda_create.

Pavel Machek (1):
      suspend-vs-iommu: prevent suspend if we could not resume

Peter Zijlstra (1):
      sched: fix sched_clock_cpu()

Phil Dibowitz (1):
      USB: Fix M600i unusual_devs entry

Pradeep Singh Rautela (1):
      ata: Convert to static DEFINE_SPINLOCK(lock)

Randy Dunlap (1):
      libata: fix libata-scsi kernel-doc notation

Ray Molenkamp (1):
      USB: FTDI_SIO : Add support for Matrix Orbital PID Range

René Rebe (1):
      USB: add another scanner quirk

Richard Kennedy (1):
      block: reorder cfq_queue to save space on 64bit builds

Roel Kluin (1):
      sched: unite unlikely pairs in rt_policy() and schedule_debug()

Rusty Russell (10):
      lguest: use ioremap_cache, not ioremap
      virtio: bus_id for devices should contain 'virtio'
      virtio: virtio_pci should not set bus_id.
      virtio: set device index in common code.
      lguest: fix ugly <NULL> in /proc/interrupts
      virtio: An entropy device, as suggested by hpa.
      virtio: force callback on empty.
      lguest: notify on empty
      virtio: fix virtio_net xmit of freed skb bug
      virtio: fix delayed xmit of packet and freeing of old packets.

Sam Ravnborg (1):
      kbuild: fix $(src) assignmnet with external modules

Scott Ashcroft (1):
      rndis_wlan: Make connections to TKIP PSK networks work

Senthil Balasubramanian (2):
      mac80211: Fix for NULL pointer dereference in sta_info_get()
      mac80211: fix alignment issue with compare_ether_addr()

Seokmann Ju (2):
      [SCSI] qla2xxx: Revert "qla2xxx: Use proper HA during asynchronous event handling."
      [SCSI] qla2xxx: Correct handling of AENs postings for vports.

Shaohua Li (1):
      PCI: don't enable ASPM on devices with mixed PCIe/PCI functions

Shyam Sundar (1):
      [SCSI] qla2xxx: Return correct port_type to FC-transport for Vports.

Sridhar Samudrala (1):
      tcp: Increment OUTRSTS in tcp_send_active_reset()

Stefan Haberland (1):
      [S390] dasd: use a generic wait_queue for sleep_on

Stephen Hemminger (1):
      net: neighbour table ABI problem

Stephen Rothwell (1):
      driver-core: prepare for 2.6.27 api change by adding dev_set_name

Steve Murphy (1):
      USB: pl2303: another product ID

Steven Rostedt (1):
      x86: enable preemption in delay

Sunil Mushran (3):
      ocfs2/net: Silence build warnings
      ocfs2/dlm: Silence build warnings
      ocfs2/net: Silence build warnings

Suresh Siddha (2):
      x86: fix broken math-emu with lazy allocation of fpu area
      x86, fpu: fix CONFIG_PREEMPT=y corruption of application's FPU stack

Takashi Iwai (4):
      [ALSA] ac97 - Fix ASUS A9T laptop output
      [ALSA] hda - Fix mic input on HP2133
      [ALSA] hda - Fix model for LG LS75 laptop
      [ALSA] hda - Fix resume of auto-config mode with Realtek codecs

Tejun Heo (3):
      ata_piix: fix macbook ich8m problems
      libata: SRST can't be trusted on PMP sil3726
      libata: kill unused constants

Thomas Graf (5):
      route: Mark unused route cache flags as such.
      route: Mark unused routing attributes as such
      netlink: Improve returned error codes
      route: Remove unused ifa_anycast field
      [IPV6] ADDRCONF: Check range of prefix length

Timur Tabi (1):
      [POWERPC] Fix DMA nodes in the MPC8610 HPCD device tree

Tom Zanussi (1):
      splice: fix sendfile() issue with relay

Tomas Winkler (2):
      mac80211: fix ieee80211_rx_bss_put/get imbalance
      mac80211: reorder channel and freq reporting in wext scan report

Tony Breeds (1):
      [POWERPC] Export empty_zero_page and copy_page in arch/ppc

Tony Luck (1):
      [IA64] Workaround for RSE issue

Tony Vroon (1):
      [ALSA] hda - COMPAL IFL90/JFL-92 laptop quirk

Vegard Nossum (1):
      MN10300: Fix typo in header guard

Venki Pallipadi (1):
      x86: fix Xorg crash with xf86MapVidMem error

Vlad Yasevich (4):
      sctp: Correctly implement Fast Recovery cwnd manipulations.
      sctp: Start T3-RTX timer when fast retransmitting lowest TSN
      sctp: Flush the queue only once during fast retransmit.
      sctp: Fix ECN markings for IPv6

Wang Chen (1):
      [netdrvr] CS89X0: Add cleanup for dma after fail

Wei Yongjun (1):
      dccp: Fix to handle short sequence numbers packet correctly

YOSHIFUJI Hideaki (6):
      [SCTP]: Fix NULL dereference of asoc.
      [IPV6] UDP: Possible dst leak in udpv6_sendmsg.
      [IPV4] TUNNEL4: Fix incoming packet length check for inter-protocol tunnel.
      [IPV6] ADDRCONF: Allow longer lifetime on 64bit archs.
      [IPV6]: Check outgoing interface even if source address is unspecified.
      [IPV6] NETNS: Handle ancillary data in appropriate namespace.

Yang Hongyang (2):
      [IPV6]: Fix the return value of get destination options with NULL data pointer
      [IPV6]: Fix the data length of get destination options with short length

Yi Zhu (1):
      mac80211: fix a typo in ieee80211_handle_filtered_frame comment

Yinghai Lu (1):
      x86: fix APIC warning on 32bit v2

Zhang, Yanmin (1):
      block: Move the second call to get_request to the end of the loop

matthias@kaehlcke.net (1):
      [SCSI] qla2xxx: Convert vport_sem to a mutex

peerchen (1):
      ahci: change the Device IDs of nvidia MCP7B AHCI controller in ahci.c
