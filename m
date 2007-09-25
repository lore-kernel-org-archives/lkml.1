Return-Path: <linux-kernel-owner+w=401wt.eu-S1759495AbXIYAqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495AbXIYAqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 20:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbXIYAqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 20:46:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41256 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754834AbXIYAqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 20:46:45 -0400
Date: Mon, 24 Sep 2007 17:46:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.23-rc8
Message-ID: <alpine.LFD.0.999.0709241740170.3579@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, I think I'm getting close to releasing a real 2.6.23. Things seem to 
have calmed down, and I think Thomas Gleixner may have found the 
suspend/resume regression that has dogged us for a while, so I'm feeling 
happy about things.

Of course, me feeling happy is usually immediately followed by some nasty 
person finding new problems, but I'll just ignore that and enjoy the 
feeling anyway, however fleeting it may be.

The shortlog really is pretty short, and I'm appending the diffstat at the 
end too in case anybody cares, but basically it's just a number of fairly 
small but real fixes, with some support for a few new chips to the sky2 
network driver..

In fact, much of the diffstat is some documentation updates and that sky2 
update. The rest tends to be a few lines, as you can tell..

		Linus

---
Alan Cox (2):
      libata: Update the blacklist with a few more devices
      libata-sff: Fix documentation

Alexey Kuznetsov (1):
      [PKT_SCHED]: Fix 'SFQ qdisc crashes with limit of 2 packets'

Alexey Starikovskiy (1):
      ACPI: suspend: consolidate handling of Sx states.

Andi Kleen (1):
      x86_64: Zero extend all registers after ptrace in 32bit entry path.

Avi Kivity (1):
      KVM: Fix virtualization menu help text

Brice Goglin (1):
      myri10ge: Add support for PCI device id 9

Christoph Hellwig (1):
      [XFS] fix valid but harmless sparse warning

Dan Williams (3):
      async_tx: usage documentation and developer notes (v2)
      async_tx: fix dma_wait_for_async_tx
      raid5: fix 2 bugs in ops_complete_biofill

Davide Libenzi (1):
      signalfd simplification

Domen Puncer (1):
      phy: export phy_mii_ioctl

Eric Leblond (1):
      [NETFILTER]: nfnetlink_log: fix sending of multipart messages

Eric Sandeen (1):
      [XFS] fix filestreams on 32-bit boxes

Frans Pop (1):
      ACPI: suspend: consolidate handling of Sx states addendum

H. Peter Anvin (2):
      [x86 setup] Present the canonical video mode number to the kernel
      [acpi] Correct the decoding of video mode numbers in wakeup.S

Herbert Valerio Riedel (1):
      [ARM] 4569/1: ep93xx_gpio_irq_type(): fix spurious enumeration offset for FGPIO handling

Herbert Xu (4):
      [PPP] pppoe: Fix double-free on skb after transmit failure
      [PPP] L2TP: Disallow non-UDP datagram sockets
      [PPP] L2TP: Fix skb handling in pppol2tp_recv_core
      [PPP] L2TP: Fix skb handling in pppol2tp_xmit

Jack Morgenstein (1):
      IB/mlx4: Fix data corruption triggered by wrong headroom marking order

Linus Torvalds (3):
      Fix CRLF line endings in Documentation/input/iforce-protocol.txt
      Revert "x86_64: Quicklist support for x86_64"
      Linux 2.6.23-rc8

Maik Broemme (1):
      ACPI: video: remove dmesg spam

Mark Fasheh (3):
      ocfs2: Allow smaller allocations during large writes
      ocfs2: Fix pos/len passed to ocfs2_write_cluster
      ocfs2: Don't double set write parameters

Michael Chan (1):
      [BNX2]: Add PHY workaround for 5709 A1.

Patrick McHardy (1):
      [NETFILTER]: MAINTAINERS update

Paul Bolle (1):
      [x86 setup] Fix typo in arch/i386/boot/header.S

Ralf Baechle (3):
      [MIPS] BCM1480: Export zbbus_mhz.
      [MIPS] BCM1480: include <linux/init.h>.
      [MIPS] SMTC: Make ack_bad_irq() safe with no IM backstop.

Rui Sousa (1):
      [ARM] 4568/1: fix l2x0 cache invalidate handling of unaligned addresses

Stefan Richter (1):
      ieee1394: ohci1394: fix initialization if built non-modular

Stephen Hemminger (7):
      sky2: fix VLAN receive processing (resend)
      sky2: ethtool speed report bug
      sky2: reorganize chip revision features
      sky2: fe+ chip support
      sky2: receive FIFO checking
      sky2: version 1.18
      missing null termination in power supply uevent

Sunil Mushran (1):
      ocfs2: Pack vote message and response structures

Takashi Iwai (1):
      Convert snd-page-alloc proc file to use seq_file

Thomas Gleixner (2):
      ACPI: disable lower idle C-states across suspend/resume
      clockevents: remove the suspend/resume workaround^Wthinko

Wolfgang Walter (1):
      rpc: fix garbage in printk in svc_tcp_accept()

Zhang Rui (1):
      ACPI: video: _DOS=0 by default to prevent hotkey hang

henry su (1):
      [libata] ahci: add ATI SB800 PCI IDs

---
 Documentation/crypto/async-tx-api.txt   |  219 +++++++++++++
 Documentation/input/iforce-protocol.txt |  508 +++++++++++++++---------------
 MAINTAINERS                             |    6 +-
 Makefile                                |    2 +-
 arch/arm/mach-ep93xx/core.c             |    2 +-
 arch/arm/mm/cache-l2x0.c                |   12 +-
 arch/i386/boot/header.S                 |    2 +-
 arch/i386/boot/video.c                  |   14 +-
 arch/i386/kernel/acpi/wakeup.S          |   41 +--
 arch/mips/kernel/i8259.c                |    5 +-
 arch/mips/kernel/irq-msc01.c            |   10 +-
 arch/mips/kernel/irq.c                  |   10 +-
 arch/mips/kernel/smtc.c                 |    5 +-
 arch/mips/sibyte/bcm1480/setup.c        |    2 +
 arch/x86_64/Kconfig                     |    8 -
 arch/x86_64/ia32/ia32entry.S            |   18 +-
 arch/x86_64/kernel/acpi/wakeup.S        |   47 +--
 arch/x86_64/kernel/process.c            |    1 -
 arch/x86_64/kernel/ptrace.c             |    4 -
 arch/x86_64/kernel/smp.c                |    2 +-
 crypto/async_tx/async_tx.c              |   12 +-
 drivers/acpi/processor_core.c           |    2 +
 drivers/acpi/processor_idle.c           |   19 ++-
 drivers/acpi/sleep/Makefile             |    2 +-
 drivers/acpi/sleep/main.c               |   57 +++-
 drivers/acpi/sleep/poweroff.c           |   75 -----
 drivers/acpi/video.c                    |    3 +-
 drivers/ata/ahci.c                      |   10 +-
 drivers/ata/libata-core.c               |    4 +
 drivers/ata/libata-sff.c                |    5 +-
 drivers/ieee1394/ieee1394_core.c        |    2 +-
 drivers/ieee1394/ohci1394.c             |    4 +-
 drivers/infiniband/hw/mlx4/qp.c         |   62 +++-
 drivers/kvm/Kconfig                     |    3 +-
 drivers/md/raid5.c                      |   17 +-
 drivers/net/bnx2.c                      |    7 +-
 drivers/net/myri10ge/myri10ge.c         |    3 +
 drivers/net/phy/phy.c                   |    1 +
 drivers/net/pppoe.c                     |    3 +-
 drivers/net/pppol2tp.c                  |  118 ++++----
 drivers/net/sky2.c                      |  368 ++++++++++++++++-------
 drivers/net/sky2.h                      |   41 ++-
 drivers/power/power_supply_sysfs.c      |    1 +
 fs/exec.c                               |    3 -
 fs/ocfs2/aops.c                         |   33 ++-
 fs/ocfs2/file.c                         |    4 +-
 fs/ocfs2/localalloc.c                   |    4 +-
 fs/ocfs2/localalloc.h                   |    2 +-
 fs/ocfs2/suballoc.c                     |   29 ++-
 fs/ocfs2/suballoc.h                     |   11 +
 fs/ocfs2/vote.c                         |    4 +-
 fs/signalfd.c                           |  190 ++----------
 fs/xfs/xfs_filestream.c                 |    7 +-
 fs/xfs/xfs_log_recover.c                |    4 +-
 include/acpi/processor.h                |    2 +
 include/asm-mips/irq.h                  |   32 ++-
 include/asm-x86_64/pgalloc.h            |   73 ++---
 include/asm-x86_64/pgtable.h            |    1 +
 include/linux/init_task.h               |    2 +-
 include/linux/sched.h                   |    2 +-
 include/linux/signalfd.h                |   40 +---
 kernel/exit.c                           |    9 -
 kernel/fork.c                           |    2 +-
 kernel/signal.c                         |    8 +-
 kernel/time/tick-broadcast.c            |   17 +-
 net/netfilter/nfnetlink_log.c           |   13 +-
 net/sched/sch_sfq.c                     |   10 +-
 net/sunrpc/svcsock.c                    |    3 +-
 sound/core/memalloc.c                   |   68 +++--
 69 files changed, 1264 insertions(+), 1046 deletions(-)
 create mode 100644 Documentation/crypto/async-tx-api.txt
 delete mode 100644 drivers/acpi/sleep/poweroff.c
