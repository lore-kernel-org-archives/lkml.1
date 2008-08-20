Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbYHTS1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbYHTS1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 14:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbYHTS1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 14:27:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:34080 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbYHTS1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 14:27:12 -0400
Date: Wed, 20 Aug 2008 11:22:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.26.3
Message-ID: <20080820182245.GA22189@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.26.3
kernel.

It contains lots of bugfixes, all over the map.  Any users of the 2.6.26
kernel series should upgrade to this version.  For details on the fixes,
see the changelog entries and the diffstat below.

I'll also be replying to this message with a copy of the patch between
2.6.26.2 and 2.6.26.3

The updated 2.6.26.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.26.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.26.y.git;a=summary

thanks,

greg k-h

-------------

 Makefile                              |    2 
 arch/ia64/kvm/kvm-ia64.c              |    5 
 arch/sparc64/kernel/irq.c             |   52 +++++++
 arch/sparc64/kernel/kstack.h          |   60 ++++++++
 arch/sparc64/kernel/process.c         |   32 ++--
 arch/sparc64/kernel/signal.c          |    6 
 arch/sparc64/kernel/stacktrace.c      |   11 -
 arch/sparc64/kernel/traps.c           |    7 
 arch/sparc64/lib/mcount.S             |   39 +++++
 arch/sparc64/mm/init.c                |   11 +
 arch/sparc64/mm/ultra.S               |    7 
 arch/x86/boot/boot.h                  |    8 +
 arch/x86/boot/cpucheck.c              |    8 -
 arch/x86/boot/main.c                  |    4 
 arch/x86/kernel/cpu/mtrr/generic.c    |    2 
 arch/x86/kvm/mmu.c                    |    1 
 arch/x86/kvm/svm.c                    |    7 
 arch/x86/kvm/vmx.c                    |    2 
 arch/x86/kvm/x86.c                    |  109 ++++++---------
 arch/x86/pci/k8-bus_64.c              |    4 
 block/scsi_ioctl.c                    |    2 
 drivers/char/hw_random/via-rng.c      |    8 +
 drivers/crypto/padlock-aes.c          |   28 +++
 drivers/crypto/padlock-sha.c          |    9 +
 drivers/i2c/Kconfig                   |   14 +
 drivers/i2c/algos/Kconfig             |   11 +
 drivers/i2c/i2c-core.c                |    4 
 drivers/ide/ide-cd.c                  |   18 +-
 drivers/ide/pci/cs5520.c              |    1 
 drivers/ide/pci/it821x.c              |    6 
 drivers/misc/acer-wmi.c               |   19 ++
 drivers/net/r8169.c                   |    6 
 drivers/net/wireless/rtl8187.h        |    4 
 drivers/net/wireless/rtl8187_dev.c    |    3 
 drivers/pci/quirks.c                  |    7 
 drivers/scsi/hptiop.c                 |    7 
 drivers/scsi/qla2xxx/qla_attr.c       |   43 ++++--
 drivers/scsi/qla2xxx/qla_def.h        |    1 
 drivers/scsi/qla2xxx/qla_gbl.h        |    2 
 drivers/scsi/qla2xxx/qla_init.c       |   16 --
 drivers/scsi/qla2xxx/qla_os.c         |   55 +++++--
 drivers/scsi/scsi_transport_spi.c     |    8 -
 drivers/scsi/ses.c                    |   18 +-
 drivers/usb/core/message.c            |    2 
 drivers/usb/serial/ftdi_sio.c         |    5 
 drivers/usb/serial/ftdi_sio.h         |    6 
 drivers/usb/serial/pl2303.c           |    1 
 drivers/usb/serial/pl2303.h           |    4 
 drivers/usb/serial/usb-serial.c       |    7 
 drivers/usb/storage/scsiglue.c        |   25 ++-
 drivers/usb/storage/transport.c       |   17 ++
 drivers/usb/storage/unusual_devs.h    |   18 ++
 drivers/video/arkfb.c                 |   18 +-
 drivers/video/aty/radeon_accel.c      |   12 +
 drivers/video/matrox/matroxfb_maven.c |    2 
 drivers/video/s3fb.c                  |   18 +-
 drivers/video/vt8623fb.c              |   20 +-
 fs/cifs/asn1.c                        |    2 
 fs/cifs/cifs_spnego.c                 |   18 +-
 fs/cifs/cifsfs.c                      |    2 
 fs/cifs/inode.c                       |    1 
 include/asm-sparc64/futex.h           |    2 
 include/asm-sparc64/irq.h             |    4 
 include/asm-sparc64/ptrace.h          |    8 -
 include/asm-x86/i387.h                |   32 ++++
 include/asm-x86/spinlock.h            |    4 
 include/linux/usb/serial.h            |    3 
 include/video/radeon.h                |    9 -
 kernel/posix-timers.c                 |   19 +-
 kernel/relay.c                        |   12 +
 kernel/signal.c                       |    1 
 lib/random32.c                        |   48 +++---
 mm/memory.c                           |   16 +-
 mm/mlock.c                            |    2 
 net/dccp/proto.c                      |    5 
 net/ipv4/ipvs/ip_vs_est.c             |    7 
 net/ipv4/syncookies.c                 |    1 
 net/ipv6/ip6_output.c                 |    4 
 net/ipv6/syncookies.c                 |    1 
 sound/soc/fsl/fsl_dma.c               |  242 ++++++++++++++++++----------------
 sound/soc/fsl/fsl_ssi.c               |   74 ++++++++--
 81 files changed, 940 insertions(+), 399 deletions(-)


Alan Stern (5):
      USB: fix interface unregistration logic
      usb-storage: unusual_devs entries for iRiver T10 and Datafab CF+SM reader
      usb-serial: don't release unregistered minors
      usb-storage: revert DMA-alignment change for Wireless USB
      usb-storage: automatically recognize bad residues

Andre Schenk (1):
      USB: ftdi_sio: Add USB Product Id for ELV HS485

Andrew Vasquez (1):
      qla2xxx: Set an rport's dev_loss_tmo value in a consistent manner.

Arnaldo Carvalho de Melo (1):
      dccp: change L/R must have at least one byte in the dccpsf_val field

Avi Kivity (1):
      KVM: Avoid instruction emulation when event delivery is pending

Bartlomiej Zolnierkiewicz (1):
      cs5520: add enablebits checking

Carlos Corbacho (1):
      acer-wmi: Fix wireless and bluetooth on early AMW0 v2 laptops

Dave Jones (1):
      USB: usb-storage: quirk around v1.11 firmware on Nikon D4

David Miller (2):
      radeonfb: fix accel engine hangs
      radeon: misc corrections

David S. Miller (7):
      sparc64: Fix global reg snapshotting on self-cpu.
      sparc64: Do not clobber %g7 in setcontext() trap.
      sparc64: Fix end-of-stack checking in save_stack_trace().
      sparc64: Fix recursion in stack overflow detection handling.
      sparc64: Make global reg dumping even more useful.
      sparc64: Implement IRQ stacks.
      sparc64: Handle stack trace attempts before irqstacks are setup.

Dean Hildebrand (1):
      PCI: Limit VPD length for Broadcom 5708S

Dimitri Gorokhovik (1):
      ide: it821x in pass-through mode segfaults in 2.6.26-stable

Florian Westphal (1):
      syncookies: Make sure ECN is disabled

Frederik Kriewitz (1):
      USB: ftdi_sio: add support for Luminance Stellaris Evaluation/Development Kits

Greg Kroah-Hartman (1):
      Linux 2.6.26.3

Hans Verkuil (1):
      i2c: Fix NULL pointer dereference in i2c_new_probed_device

HighPoint Linux Team (1):
      SCSI: hptiop: add more PCI device IDs

James Bottomley (2):
      SCSI: ses: fix VPD inquiry overrun
      SCSI: scsi_transport_spi: fix oops in revalidate

Jan Beulich (2):
      CIFS: Fix compiler warning on 64-bit
      x86: fix spin_is_contended()

Jean Delvare (2):
      matrox maven: fix a broken error path
      i2c: Let users select algorithm drivers manually again

Jeff Layton (1):
      CIFS: properly account for new user= field in SPNEGO upcall string allocation

Joerg Roedel (1):
      x86: fix setup code crashes on my old 486 box

Julia Lawall (1):
      KVM: ia64: Fix irq disabling leak in error handling code

KOSAKI Motohiro (1):
      mlock() fix return values

Larry Finger (1):
      rtl8187: Fix lockups due to concurrent access to config routine

Marcelo Tosatti (3):
      KVM: task switch: segment base is linear address
      KVM: task switch: use seg regs provided by subarch instead of reading from GDT
      KVM: task switch: translate guest segment limit to virt-extension byte granular field

Marcus Sundberg (1):
      r8169: avoid thrashing PCI conf space above RTL_GIGA_MAC_VER_06

Mikael Pettersson (1):
      sparc64: FUTEX_OP_ANDN fix

Oleg Nesterov (2):
      posix-timers: do_schedule_next_timer: fix the setting of ->si_overrun
      posix-timers: fix posix_timer_event() vs dequeue_signal() race

Ondrej Zajicek (1):
      vt8623fb: fix kernel oops

Petr Tesarik (1):
      ide-cd: fix endianity for the error message in cdrom_read_capacity

Seokmann Ju (1):
      qla2xxx: Add dev_loss_tmo_callbk/terminate_rport_io callback support.

Stephen Hemminger (1):
      random32: seeding improvement

Steve French (2):
      CIFS: mount of IPC$ breaks with iget patch
      CIFS: if get root inode fails during mount, cleanup tree connection

Suresh Siddha (1):
      crypto: padlock - fix VIA PadLock instruction usage with irq_ts_save/restore()

Sven Wegener (1):
      ipvs: Fix possible deadlock in estimator code

Tim Wright (1):
      SCSI: block: Fix miscalculation of sg_io timeout in CDROM_SEND_PACKET handler.

Timur Tabi (2):
      ALSA: asoc: restrict sample rate and size in Freescale MPC8610 sound drivers
      ALSA: ASoC: fix SNDCTL_DSP_SYNC support in Freescale 8610 sound drivers

Tollef Fog Heen (1):
      USB: pl2023: Remove USB id (4348:5523) handled by ch341

Tom Zanussi (1):
      relay: fix "full buffer with exactly full last subbuffer" accounting problem

Wei Yongjun (1):
      ipv6: Fix ip6_xmit to send fragments if ipfragok is true

Yinghai Lu (1):
      x86: amd opteron TOM2 mask val fix

