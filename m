Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbYHTS2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbYHTS2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 14:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754356AbYHTS1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 14:27:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:34087 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbYHTS1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 14:27:24 -0400
Date: Wed, 20 Aug 2008 11:23:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.25.16
Message-ID: <20080820182357.GC22189@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.25.16
kernel.

It contains lots of bugfixes, all over the map.  Any users of the 2.6.25
kernel series should upgrade to this version.  For details on the fixes,
see the changelog entries and the diffstat below.

I'll also be replying to this message with a copy of the patch between
2.6.25.15 and 2.6.25.16

The updated 2.6.25.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.25.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.25.y.git;a=summary

thanks,

greg k-h

-------------


 Makefile                                 |    2 -
 arch/sparc64/kernel/signal.c             |    6 ++-
 arch/um/Makefile                         |    1 
 arch/um/Makefile-i386                    |    7 +++
 arch/um/Makefile-x86_64                  |    3 +
 arch/um/drivers/chan_user.c              |    1 
 arch/um/drivers/cow_sys.h                |    2 -
 arch/um/drivers/daemon_user.c            |    4 +-
 arch/um/drivers/fd.c                     |    2 -
 arch/um/drivers/mcast_user.c             |    3 +
 arch/um/drivers/net_user.c               |    2 -
 arch/um/drivers/pcap_user.c              |    2 -
 arch/um/drivers/port_user.c              |    2 -
 arch/um/drivers/pty.c                    |    2 -
 arch/um/drivers/slip_user.c              |    2 -
 arch/um/drivers/tty.c                    |    2 -
 arch/um/drivers/xterm.c                  |    2 -
 arch/um/include/init.h                   |    8 ++++
 arch/um/include/os.h                     |    2 -
 arch/um/include/process.h                |    4 +-
 arch/um/include/um_malloc.h              |    9 +---
 arch/um/kernel/mem.c                     |    5 ++
 arch/um/kernel/time.c                    |    4 +-
 arch/um/kernel/um_arch.c                 |    7 ++-
 arch/um/os-Linux/drivers/ethertap_user.c |    4 +-
 arch/um/os-Linux/helper.c                |    5 +-
 arch/um/os-Linux/main.c                  |    2 -
 arch/um/os-Linux/sigio.c                 |    4 +-
 arch/um/os-Linux/signal.c                |    1 
 arch/um/os-Linux/skas/process.c          |    2 -
 arch/um/os-Linux/start_up.c              |   25 ++++++++----
 arch/um/os-Linux/sys-i386/task_size.c    |   38 ++++++++++++++-----
 arch/um/os-Linux/sys-x86_64/task_size.c  |    2 -
 arch/um/os-Linux/time.c                  |   61 ++++++++++++++++++++++++++++---
 arch/um/sys-x86_64/ksyms.c               |    5 ++
 arch/x86/boot/boot.h                     |    8 ++++
 arch/x86/boot/cpucheck.c                 |    8 ----
 arch/x86/boot/main.c                     |    4 ++
 block/scsi_ioctl.c                       |    2 -
 drivers/i2c/i2c-core.c                   |    4 +-
 drivers/ide/ide-cd.c                     |   18 +++++----
 drivers/misc/acer-wmi.c                  |   19 +++++++++
 drivers/net/r8169.c                      |    6 ++-
 drivers/scsi/hptiop.c                    |    7 +++
 drivers/scsi/qla2xxx/qla_attr.c          |   43 ++++++++++++++-------
 drivers/scsi/qla2xxx/qla_def.h           |    1 
 drivers/scsi/qla2xxx/qla_gbl.h           |    2 +
 drivers/scsi/qla2xxx/qla_init.c          |   16 ++------
 drivers/scsi/qla2xxx/qla_os.c            |   55 ++++++++++++++++++++-------
 drivers/scsi/scsi_transport_spi.c        |    8 ++--
 drivers/scsi/ses.c                       |   18 +++++++--
 drivers/usb/serial/ftdi_sio.c            |    5 ++
 drivers/usb/serial/ftdi_sio.h            |    6 +++
 drivers/usb/serial/pl2303.c              |    1 
 drivers/usb/serial/pl2303.h              |    4 --
 drivers/usb/serial/usb-serial.c          |    7 +--
 drivers/usb/storage/unusual_devs.h       |   18 ++++++++-
 drivers/video/aty/radeon_accel.c         |   12 +++++-
 drivers/video/matrox/matroxfb_maven.c    |    2 -
 fs/cifs/asn1.c                           |    2 -
 fs/cifs/cifsfs.c                         |    2 +
 fs/cifs/inode.c                          |    1 
 include/asm-sparc64/futex.h              |    2 -
 include/asm-x86/spinlock.h               |    4 +-
 include/linux/usb/serial.h               |    3 +
 include/video/radeon.h                   |    9 +++-
 kernel/posix-timers.c                    |   19 +++++++--
 kernel/relay.c                           |   12 +++++-
 kernel/signal.c                          |    1 
 lib/random32.c                           |   48 +++++++++++++-----------
 mm/memory.c                              |   16 ++++++--
 mm/mlock.c                               |    2 -
 net/dccp/proto.c                         |    5 ++
 net/ipv4/ipvs/ip_vs_est.c                |    7 ++-
 net/ipv4/netfilter/nf_nat_snmp_basic.c   |    2 -
 net/ipv6/ip6_output.c                    |    4 ++
 76 files changed, 464 insertions(+), 182 deletions(-)

Al Viro (2):
      uml: missed kmalloc() in pcap_user.c
      uml: missing export of csum_partial() on uml/amd64

Alan Stern (2):
      usb-storage: unusual_devs entries for iRiver T10 and Datafab CF+SM reader
      usb-serial: don't release unregistered minors

Andre Schenk (1):
      USB: ftdi_sio: Add USB Product Id for ELV HS485

Andrew Vasquez (1):
      qla2xxx: Set an rport's dev_loss_tmo value in a consistent manner.

Arnaldo Carvalho de Melo (1):
      dccp: change L/R must have at least one byte in the dccpsf_val field

Carlos Corbacho (1):
      acer-wmi: Fix wireless and bluetooth on early AMW0 v2 laptops

Dave Jones (1):
      USB: usb-storage: quirk around v1.11 firmware on Nikon D4

David Howells (1):
      netfilter: nf_nat_snmp_basic: fix a range check in NAT for SNMP

David Miller (2):
      radeonfb: fix accel engine hangs
      radeon: misc corrections

David S. Miller (1):
      sparc64: Do not clobber %g7 in setcontext() trap.

Frederik Kriewitz (1):
      USB: ftdi_sio: add support for Luminance Stellaris Evaluation/Development Kits

Greg Kroah-Hartman (1):
      Linux 2.6.25.16

Hans Verkuil (1):
      i2c: Fix NULL pointer dereference in i2c_new_probed_device

HighPoint Linux Team (1):
      SCSI: hptiop: add more PCI device IDs

Ingo Molnar (1):
      uml: PATH_MAX needs limits.h

James Bottomley (2):
      SCSI: ses: fix VPD inquiry overrun
      SCSI: scsi_transport_spi: fix oops in revalidate

Jan Beulich (2):
      CIFS: Fix compiler warning on 64-bit
      x86: fix spin_is_contended()

Jean Delvare (1):
      matrox maven: fix a broken error path

Jeff Dike (10):
      uml: fix build when SLOB is enabled
      uml: fix bad NTP interaction with clock
      uml: physical memory shouldn't include initial stack
      uml: track and make up lost ticks
      uml: deal with host time going backwards
      uml: memcpy export needs to follow host declaration
      uml: stub needs to tolerate SIGWINCH
      uml: work around broken host PTRACE_SYSEMU
      uml: fix gcc ICEs and unresolved externs
      uml: Fix boot crash

Joerg Roedel (1):
      x86: fix setup code crashes on my old 486 box

KOSAKI Motohiro (1):
      mlock() fix return values

Marcus Sundberg (1):
      r8169: avoid thrashing PCI conf space above RTL_GIGA_MAC_VER_06

Mikael Pettersson (1):
      sparc64: FUTEX_OP_ANDN fix

Oleg Nesterov (2):
      posix-timers: fix posix_timer_event() vs dequeue_signal() race
      posix-timers: do_schedule_next_timer: fix the setting of ->si_overrun

Petr Tesarik (1):
      ide-cd: fix endianity for the error message in cdrom_read_capacity

Seokmann Ju (1):
      qla2xxx: Add dev_loss_tmo_callbk/terminate_rport_io callback support.

Stephen Hemminger (1):
      random32: seeding improvement

Steve French (2):
      CIFS: mount of IPC$ breaks with iget patch
      CIFS: if get root inode fails during mount, cleanup tree connection

Sven Wegener (1):
      ipvs: Fix possible deadlock in estimator code

Tim Wright (1):
      SCSI: block: Fix miscalculation of sg_io timeout in CDROM_SEND_PACKET handler.

Tollef Fog Heen (1):
      USB: pl2023: Remove USB id (4348:5523) handled by ch341

Tom Spink (1):
      uml: deal with inaccessible address space start

Tom Zanussi (1):
      relay: fix "full buffer with exactly full last subbuffer" accounting problem

Wei Yongjun (1):
      ipv6: Fix ip6_xmit to send fragments if ipfragok is true

