Return-Path: <linux-kernel-owner+w=401wt.eu-S1759450AbYHAXPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759450AbYHAXPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 19:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756049AbYHAXOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 19:14:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52416 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbYHAXOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 19:14:36 -0400
Date: Fri, 1 Aug 2008 16:12:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.26.1
Message-ID: <20080801231207.GC22309@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.26.1
kernel.

It contains lots of bugfixes, all over the map.  Any users of the 2.6.26
kernel series should upgrade to this version.  For details on the fixes,
see the changelog entries and the diffstat below.

I'll also be replying to this message with a copy of the patch between
2.6.26 and 2.6.26.1

The updated 2.6.26.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.26.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.26.y.git;a=summary

thanks,

greg k-h

-------------

 Documentation/networking/udplite.txt          |    2 
 Documentation/video4linux/cx18.txt            |   12 --
 Makefile                                      |    5 
 arch/ia64/kvm/kvm-ia64.c                      |    3 
 arch/powerpc/kvm/powerpc.c                    |    4 
 arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c |    6 +
 arch/s390/kvm/kvm-s390.c                      |    4 
 arch/sparc64/kernel/irq.c                     |   10 +
 arch/sparc64/kernel/ldc.c                     |   38 +++---
 arch/sparc64/kernel/time.c                    |   15 +-
 arch/um/include/init.h                        |    8 +
 arch/x86/Kconfig.cpu                          |    2 
 arch/x86/kernel/acpi/sleep.c                  |   17 ++-
 arch/x86/kernel/i387.c                        |    4 
 arch/x86/kernel/ptrace.c                      |    4 
 arch/x86/kernel/reboot.c                      |    8 +
 arch/x86/kvm/mmu.c                            |   10 +
 arch/x86/kvm/svm.c                            |   34 ++++--
 arch/x86/kvm/vmx.c                            |    7 -
 arch/x86/kvm/x86.c                            |    5 
 arch/x86/kvm/x86_emulate.c                    |    2 
 arch/x86/mm/init_64.c                         |    2 
 drivers/acpi/processor_perflib.c              |   15 ++
 drivers/cpufreq/cpufreq.c                     |    3 
 drivers/dma/iop-adma.c                        |    2 
 drivers/ide/ide-cd.c                          |   27 ++++
 drivers/media/dvb/dvb-usb/dib0700_devices.c   |    7 +
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h       |    1 
 drivers/media/video/Kconfig                   |    8 -
 drivers/media/video/cx18/cx18-firmware.c      |    2 
 drivers/media/video/cx23885/cx23885-core.c    |  142 ++++++++++++++++++++++++--
 drivers/media/video/saa7134/saa7134-cards.c   |    3 
 drivers/media/video/saa7134/saa7134-core.c    |    5 
 drivers/media/video/uvc/Kconfig               |   17 +++
 drivers/media/video/uvc/uvc_driver.c          |   12 ++
 drivers/media/video/uvc/uvc_status.c          |   19 ++-
 drivers/media/video/uvc/uvc_video.c           |  116 +++++++++++++--------
 drivers/media/video/uvc/uvcvideo.h            |    2 
 drivers/mmc/host/pxamci.c                     |    2 
 drivers/net/hamradio/hdlcdrv.c                |    1 
 drivers/net/ixgbe/ixgbe_main.c                |    2 
 drivers/net/myri10ge/myri10ge.c               |   30 ++---
 drivers/net/wireless/ath5k/base.c             |    5 
 drivers/net/wireless/b43legacy/main.c         |    2 
 drivers/rtc/rtc-at91rm9200.c                  |   16 +-
 drivers/spi/mpc52xx_psc_spi.c                 |   22 +---
 drivers/usb/serial/usb-serial.c               |    5 
 fs/dquot.c                                    |   16 ++
 fs/ecryptfs/crypto.c                          |   30 +++--
 fs/isofs/rock.c                               |   22 +++-
 fs/libfs.c                                    |    4 
 fs/proc/task_mmu.c                            |    2 
 include/asm-arm/bitops.h                      |    9 +
 include/asm-generic/vmlinux.lds.h             |    4 
 include/asm-sparc64/io.h                      |    1 
 include/asm-x86/signal.h                      |    4 
 include/linux/cpufreq.h                       |    1 
 include/linux/ipv6.h                          |    2 
 include/linux/kvm_host.h                      |    1 
 kernel/cpuset.c                               |    4 
 kernel/marker.c                               |   12 +-
 kernel/rcupreempt.c                           |    2 
 kernel/sys_ni.c                               |    1 
 mm/filemap.c                                  |    2 
 mm/shmem.c                                    |    3 
 net/ipv4/tcp_input.c                          |    3 
 net/ipv4/udp.c                                |    4 
 net/ipv6/ip6_fib.c                            |    4 
 scripts/Makefile.modpost                      |    1 
 scripts/mod/modpost.c                         |    3 
 sound/pci/trident/trident_main.c              |    5 
 virt/kvm/kvm_main.c                           |    3 
 72 files changed, 589 insertions(+), 222 deletions(-)

Adam Greenblatt (1):
      isofs: fix minor filesystem corruption

Alex Nixon (1):
      VFS: increase pseudo-filesystem block size to PAGE_SIZE

Alexey Dobriyan (1):
      proc: fix /proc/*/pagemap some more

Andrew Morton (1):
      ARM: fix fls() for 64-bit arguments

Atsushi Nemoto (1):
      Fix build on COMPAT platforms when CONFIG_EPOLL is disabled

Avi Kivity (1):
      KVM: MMU: Fix potential race setting upper shadow ptes on nonpae hosts

Brice Goglin (2):
      myri10ge: do not forget to setup the single slice pointers
      myri10ge: do not use mgp->max_intr_slots before loading the firmware

David Brownell (1):
      rtc-at91rm9200: avoid spurious irqs

David S. Miller (5):
      ipv6: __KERNEL__ ifdef struct ipv6_devconf
      tcp: Clear probes_out more aggressively in tcp_ack().
      sparc64: Fix lockdep issues in LDC protocol layer.
      sparc64: Fix cpufreq notifier registry.
      sparc64: Do not define BIO_VMERGE_BOUNDARY.

Eric Sandeen (1):
      eCryptfs: use page_alloc not kmalloc to get a page of memory

Gerrit Renker (1):
      udplite: Protection against coverage value wrap-around

Greg Kroah-Hartman (1):
      Linux 2.6.26.1

H. Peter Anvin (1):
      x86, suspend, acpi: enter Big Real Mode

Hans Verkuil (1):
      V4L: cx18: Upgrade to newer firmware & update documentation

Herton Ronaldo Krzesinski (1):
      Fix typos from signal_32/64.h merge

Hugh Dickins (1):
      tmpfs: fix kernel BUG in shmem_delete_inode

Ingo Molnar (2):
      x86 reboot quirks: add Dell Precision WorkStation T5400
      x86: fix kernel_physical_mapping_init() for large x86 systems

Jan Beulich (1):
      vmlinux.lds: move __attribute__((__cold__)) functions back into final .text section

Jan Kara (1):
      quota: fix possible infinite loop in quota code

Jan Kratochvil (1):
      x86: fix crash due to missing debugctlmsr on AMD K6-3

Jeff Dike (1):
      UML - Fix boot crash

Jens Axboe (1):
      ide-cd: fix oops when using growisofs

Jesse Brandeburg (1):
      ixgbe: remove device ID for unsupported device

Joerg Roedel (1):
      KVM: SVM: fix suspend/resume support

Julia Lawall (1):
      b43legacy: Release mutex in error handling code

Karl Beldan (1):
      pxamci: trivial fix of DMA alignment register bit clearing

Kay Sievers (1):
      iop-adma: fix platform driver hotplug/coldplug

Laurent Pinchart (5):
      V4L: uvcvideo: Fix a buffer overflow in format descriptor parsing
      V4L: uvcvideo: Use GFP_NOIO when allocating memory during resume
      V4L: uvcvideo: Don't free URB buffers on suspend
      V4L: uvcvideo: Make input device support optional
      V4L: uvcvideo: Add support for Medion Akoya Mini E1210 integrated webcam

Linus Torvalds (1):
      Fix off-by-one error in iov_iter_advance()

Luotao Fu (1):
      mpc52xx_psc_spi: fix block transfer

Marcelo Tosatti (2):
      KVM: mmu_shrink: kvm_mmu_zap_page requires slots_lock to be held
      KVM: MMU: nuke shadowed pgtable pages and ptes on memslot destruction

Mathieu Desnoyers (2):
      markers: fix duplicate modpost entry
      markers: fix markers read barrier for multiple probes

Miao Xie (1):
      cpusets: fix wrong domain attr updates

Micah Dowty (1):
      hdlcdrv: Fix CRC calculation.

Michael Krufky (1):
      DVB: dib0700: add support for Hauppauge Nova-TD Stick 52009

Mohammed Gamal (1):
      KVM: x86 emulator: Fix HLT instruction

Oliver Neukum (1):
      USB: fix usb serial pm counter decrement for disconnected interfaces

Paul E. McKenney (1):
      rcu: fix rcu_try_flip_waitack_needed() to prevent grace-period stall

Pavel Roskin (1):
      ath5k: don't enable MSI, we cannot handle it yet

Pierre Ossman (1):
      ALSA: trident - pause s/pdif output

Roland McGrath (1):
      Patch Upstream: x86 ptrace: fix PTRACE_GETFPXREGS error

Sheng Yang (2):
      KVM: VMX: Fix a wrong usage of vmcs_config
      KVM: VMX: Add ept_sync_context in flush_tlb

Simon Arlott (1):
      V4L: saa7134: Copy tuner data earlier to avoid overwriting manual tuner type

Stephen Hemminger (1):
      ipv6: use timer pending

Steven Toth (5):
      V4L: cx23885: Bugfix for concurrent use of /dev/video0 and /dev/video1
      DVB: cx23885: Ensure PAD_CTRL is always reset to a sensible default
      DVB: cx23885: DVB Transport cards using DVB port VIDB/TS1 did not stream
      DVB: cx23885: Reallocated the sram to avoid concurrent VIDB/C issues
      DVB: cx23885: SRAM changes for the 885 and 887 silicon parts

Thomas Renninger (1):
      cpufreq acpi: only call _PPC after cpufreq ACPI init funcs got called already

