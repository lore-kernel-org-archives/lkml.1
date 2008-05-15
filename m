Return-Path: <linux-kernel-owner+w=401wt.eu-S933076AbYEOPI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076AbYEOPI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 11:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932941AbYEOPIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 11:08:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57578 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728AbYEOPIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 11:08:11 -0400
Date: Thu, 15 May 2008 08:07:21 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.25.4
Message-ID: <20080515150721.GA8420@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.25.4 kernel.

It contains a bunch of bug fixes, and one security update, so all users
of the 2.6.25 series are encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.25.3 and 2.6.25.4

The updated 2.6.25.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.25.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.25.y.git;a=summary

thanks,

greg k-h

--------

 Makefile                                       |    2 
 arch/sparc/kernel/entry.S                      |    2 
 arch/sparc/kernel/process.c                    |   25 +-
 arch/sparc/kernel/ptrace.c                     |    6 
 arch/sparc/kernel/rtrap.S                      |   11 -
 arch/sparc/kernel/signal.c                     |   84 ++++----
 arch/sparc/kernel/sys_sparc.c                  |   48 ----
 arch/sparc64/kernel/etrap.S                    |    7 
 arch/sparc64/kernel/irq.c                      |    3 
 arch/sparc64/kernel/pci.c                      |  130 +++---------
 arch/sparc64/kernel/pci_common.c               |    6 
 arch/sparc64/kernel/pci_impl.h                 |    9 
 arch/sparc64/kernel/process.c                  |   18 +
 arch/sparc64/kernel/ptrace.c                   |   16 +
 arch/sparc64/kernel/rtrap.S                    |    1 
 arch/sparc64/kernel/signal.c                   |   88 ++++----
 arch/sparc64/kernel/signal32.c                 |   48 +++-
 arch/sparc64/kernel/sys_sparc.c                |   40 ---
 arch/sparc64/kernel/sys_sparc32.c              |   33 ---
 arch/x86/Kconfig                               |   12 +
 drivers/ata/ata_piix.c                         |   25 ++
 drivers/char/vt.c                              |    6 
 drivers/i2c/busses/i2c-piix4.c                 |   32 ++-
 drivers/md/raid5.c                             |   25 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c    |  259 ++++++++++++++++++++++---
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h        |    9 
 drivers/net/macvlan.c                          |    2 
 drivers/net/r8169.c                            |    8 
 drivers/rtc/rtc-lib.c                          |    2 
 drivers/scsi/aha152x.c                         |    8 
 drivers/scsi/libiscsi.c                        |   29 +-
 drivers/scsi/qla1280.c                         |    4 
 drivers/serial/serial_core.c                   |    3 
 drivers/serial/sunhv.c                         |    2 
 drivers/serial/sunsab.c                        |    2 
 drivers/serial/sunsu.c                         |    2 
 drivers/serial/sunzilog.c                      |   32 +--
 drivers/usb/host/ohci-at91.c                   |    1 
 drivers/usb/host/ohci-ep93xx.c                 |    2 
 drivers/usb/host/ohci-hub.c                    |   43 ++++
 drivers/usb/host/ohci-omap.c                   |    2 
 drivers/usb/host/ohci-pci.c                    |   43 ----
 drivers/usb/host/ohci-pxa27x.c                 |    3 
 drivers/usb/host/ohci-sm501.c                  |    2 
 drivers/usb/host/ohci-ssb.c                    |    1 
 drivers/usb/serial/airprime.c                  |    2 
 include/asm-sparc/mman.h                       |    5 
 include/asm-sparc/psr.h                        |    1 
 include/asm-sparc/ptrace.h                     |   13 +
 include/asm-sparc/signal.h                     |    8 
 include/asm-sparc64/mman.h                     |    5 
 include/asm-sparc64/psrcompat.h                |    2 
 include/asm-sparc64/pstate.h                   |    1 
 include/asm-sparc64/ptrace.h                   |   13 +
 include/asm-sparc64/signal.h                   |    8 
 include/asm-sparc64/ttable.h                   |    7 
 include/asm-x86/topology.h                     |   18 -
 include/net/ip_vs.h                            |    3 
 include/net/netfilter/nf_conntrack_tuple.h     |   10 
 net/can/af_can.c                               |   16 +
 net/dccp/feat.c                                |    2 
 net/ipv4/ipvs/ip_vs_proto.c                    |    2 
 net/ipv4/ipvs/ip_vs_proto_ah.c                 |    1 
 net/ipv4/ipvs/ip_vs_proto_esp.c                |    1 
 net/ipv4/ipvs/ip_vs_proto_tcp.c                |    1 
 net/ipv4/ipvs/ip_vs_proto_udp.c                |    1 
 net/ipv4/ipvs/ip_vs_sync.c                     |   80 +++++--
 net/ipv4/netfilter/ip_queue.c                  |    5 
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 
 net/ipv6/netfilter/ip6_queue.c                 |    5 
 net/netfilter/nf_conntrack_core.c              |    4 
 net/netfilter/nfnetlink_queue.c                |    5 
 net/sched/sch_htb.c                            |    8 
 net/xfrm/xfrm_state.c                          |    2 
 74 files changed, 808 insertions(+), 559 deletions(-)


Alan Stern (1):
      OHCI: fix regression upon awakening from hibernation

Albert Comerma (1):
      V4L/DVB (7473): PATCH for various Dibcom based devices

Arnaud Ebalard (1):
      {nfnetlink, ip, ip6}_queue: fix skb_over_panic when enlarging packets

Chris Wright (1):
      dccp: return -EINVAL on invalid feature length

Dan Williams (1):
      md: fix raid5 'repair' operations

David S. Miller (10):
      sparc: Fix SA_ONSTACK signal handling.
      sparc: Fix fork/clone/vfork system call restart.
      sparc64: Stop creating dummy root PCI host controller devices.
      sparc64: Fix wedged irq regression.
      SPARC64: Fix args to 64-bit sys_semctl() via sys_ipc().
      serial: Fix sparc driver name strings.
      sparc: Fix ptrace() detach.
      sparc: Fix mremap address range validation.
      sparc: Fix debugger syscall restart interactions.
      sparc32: Don't twiddle PT_DTRACE in exec.

Greg Kroah-Hartman (1):
      Linux 2.6.25.4

Ivan Vecera (1):
      r8169: fix oops in r8169_get_mac_version

James Bottomley (2):
      SCSI: aha152x: Fix oops on module removal
      SCSI: aha152x: fix init suspiciously returned 1, it should follow 0/-E convention

Jarek Poplawski (1):
      sch_htb: remove from event queue in htb_parent_to_leaf()

Jean Delvare (1):
      i2c-piix4: Blacklist two mainboards

Jeremy Higdon (1):
      SCSI: qla1280: Fix queue depth problem

Julian Anastasov (1):
      ipvs: fix oops in backup for fwmark conn templates

Leonardo Chiquitto (1):
      USB: airprime: unlock mutex instead of trying to lock it again

Maciej W. Rozycki (1):
      rtc: rtc_time_to_tm: use unsigned arithmetic

Mike Christie (2):
      SCSI: libiscsi regression in 2.6.25: fix nop timer handling
      SCSI: libiscsi regression in 2.6.25: fix setting of recv timer

Oliver Hartkopp (1):
      can: Fix can_send() handling on dev_queue_xmit() failures

Patrick McHardy (1):
      macvlan: Fix memleak on device removal/crash on module removal

Philip Craig (1):
      nf_conntrack: padding breaks conntrack hash on ARM

Robert Reif (1):
      sparc: sunzilog uart order

Roel Kluin (1):
      r8169: fix past rtl_chip_info array size for unknown chipsets

Sam Ravnborg (1):
      x86: use defconfigs from x86/configs/*

Samuel Thibault (1):
      vt: fix canonical input in UTF-8 mode

Tejun Heo (1):
      ata_piix: verify SIDPR access before enabling it

Tetsuo Handa (1):
      serial: access after NULL check in uart_flush_buffer()

Vaidyanathan Srinivasan (1):
      x86: sysfs cpu?/topology is empty in 2.6.25 (32-bit Intel system)

YOSHIFUJI Hideaki (1):
      XFRM: AUDIT: Fix flowlabel text format ambibuity.

