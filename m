Return-Path: <linux-kernel-owner+w=401wt.eu-S965063AbXCGE7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965063AbXCGE7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 23:59:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965351AbXCGE7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 23:59:12 -0500
Received: from smtp.osdl.org ([65.172.181.24]:48469 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965185AbXCGE7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 23:59:06 -0500
Date: Tue, 6 Mar 2007 20:59:01 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux v2.6.21-rc3
Message-ID: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463790079-1345696304-1173243541=:5963"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463790079-1345696304-1173243541=:5963
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT


We've finally hopefully started to put a dent in the regressions, 
especially the suspend/resume problems introduced since 2.6.20.

So 2.6.21-rc3 is out there now, and there's some hope that it will work 
more widely than -rc1 and -rc2 did. Please do give it a good testing, and 
update Adrian and the mailing list (and me) about any regressions 
(hopefully many more of the "it's fixed now" than other kinds, but all 
regressions are interesting).

The appended shortlog gives a reasonable overview. In general we're 
definitely calming down, and most of the changes are fairly small and 
obvious fixes. 

Let's keep the fixes to a minimum, especially since I'm planning on biting 
peoples heads off if I get any more pull requests for things that aren't 
real and obvious fixes. 

		Linus

---

Adam Litke (1):
      Fix get_unmapped_area and fsync for hugetlb shm segments

Adrian Bunk (8):
      HID: hid-debug.c should #include <linux/hid-debug.h>
      arch/arm26/kernel/entry.S: remove dead code
      make ipc/shm.c:shm_nopage() static
      mm/{,tiny-}shmem.c cleanups
      drivers/video/sm501fb.c: make 4 functions static
      fix the SYSCTL=n compilation
      arch/i386/kernel/vmi.c must #include <asm/kmap_types.h>
      remove arch/i386/kernel/tsc.c:custom_sched_clock

Ahmed S. Darwish (1):
      KVM: Use ARRAY_SIZE macro instead of manual calculation.

Akira Iguchi (1):
      scc_pata: bugfix for checking DMA IRQ status

Alan Cox (4):
      libata-core: Fix simplex handling
      pata_qdi: Fix initialisation
      siimage: DRAC4 note
      ide: remove a ton of pointless #undef REALLY_SLOW_IO

Alexandr Andreev (1):
      [IA64] sync compat getdents

Alexey Dobriyan (1):
      geode-aes: use unsigned long for spin_lock_irqsave

Allan Graves (1):
      uml: enable RAW

Andres Salomon (3):
      i386: make x86_64 tsc header require i386 rather than vice-versa
      hrtimers: fix HRTIMER_CB_IRQSAFE_NO_SOFTIRQ description
      hrtimers: hrtimer_clock_base description typo

Andrew Morton (7):
      throttle_vm_writeout(): don't loop on GFP_NOFS and GFP_NOIO allocations
      ide: fix pmac breakage
      KVM: Move kvmfs magic number to <linux/magic.h>
      cyclades: return closing_wait
      revert "drivers/net/tulip/dmfe: support basic carrier detection"
      sis900 warning fixes
      fix build with CONFIG_NO_IDLE_HZ=n

Andrzej Zaborowski (1):
      ARM: OMAP: correct misc 15xx and non-15xx platform code

Antonino A. Daplas (2):
      MAINTAINERS: Update email address
      atyfb: Fix kconfig error

Aristeu Sergio Rozanski Filho (1):
      tty_io: fix race in master pty close/slave pty close path

Arnaldo Carvalho de Melo (1):
      [TCP]: Fix minisock tcp_create_openreq_child() typo.

Arnaud Patard (1):
      ARM: OMAP: board-nokia770: correct lcd name

Atsushi Nemoto (4):
      [MIPS] jmr3927: build fix
      [MIPS] Convert to RTC-class ds1742 driver
      [MIPS] No need to write c0_compare in plat_timer_setup
      [MIPS] TX39: Remove redundant tx39_blast_icache() calls

Avi Kivity (13):
      KVM: mmu: add missing dirty page tracking cases
      KVM: Cosmetics
      KVM: Add hypercall host support for svm
      KVM: Wire up hypercall handlers to a central arch-independent location
      KVM: svm: init cr0 with the wp bit set
      KVM: More 0 -> NULL conversions
      KVM: Add internal filesystem for generating inodes
      KVM: Create an inode per virtual machine
      KVM: Rename some kvm_dev_ioctl_*() functions to kvm_vm_ioctl_*()
      KVM: Move kvm_vm_ioctl_create_vcpu() around
      KVM: Per-vcpu inodes
      KVM: Bump API version
      KVM: Fix bogus failure in kvm.ko module initialization

Bartlomiej Zolnierkiewicz (3):
      ide: remove some obsoleted kernel params (v2)
      ide: make legacy IDE VLB modules check for the "probe" kernel params (v2)
      pata_pdc202xx_old: fix data corruption and other problems

Ben Dooks (2):
      [ARM] 4238/1: S3C24XX: docs: update suspend and resume
      [ARM] 4239/1: S3C24XX: Update kconfig entries for PM

Brice Goglin (1):
      myri10ge: fix copyright and license

Catalin Marinas (1):
      [ARM] 4241/1: Define mb() as compiler barrier on a uniprocessor system

Christian Krafft (1):
      ipmi: check, if default ports are accessible on PPC

Christoph Lameter (1):
      Page migration: Fix vma flag checking

Con Kolivas (1):
      sched: remove SMT nice

Cornelia Huck (3):
      [S390] cio: Fix locking when calling notify function.
      [S390] cio: Use path verification to check for path state.
      [S390] cio: Call cancel_halt_clear even when actl == 0.

Dale Farnsworth (2):
      mv643xx_eth: move mac_addr inside mv643xx_eth_platform_data
      mv643xx_eth: Place explicit port number in mv643xx_eth_platform_data

Dan Aloni (1):
      [VLAN]: Avoid a 4-order allocation.

Daniel Walker (2):
      update timekeeping_is_continuous comment
      fix vsyscall settimeofday

Dave Johnson (1):
      [MIPS] Fix __raw_read_trylock() to allow multiple readers

Dave Jones (2):
      Fix mv643xx_eth compilation.
      nvidiafb backlight: Fix implicit declaration in nv_backlight

Dave Kleikamp (1):
      fs: nobh_truncate_page() fix

David Brownell (5):
      rtc_cmos oops fix
      ARM: OMAP: omap GP timer: HZ != 100
      parport is an orphan
      add CONFIG_GENERIC_GPIO
      gpio_keys driver shouldn't be ARM-specific

David Howells (3):
      FRV: No ZONE_DMA
      FRV: Add some missng lazy MMU hooks for NOMMU mode
      FRV: Missing error defs

David Miller (2):
      Bug in MM_RB debugging
      video/aty/mach64_ct.c: fix bogus delay loop

David Rientjes (1):
      x86_64: remove unusued 'flags' variable

David S. Miller (13):
      [XFRM] xfrm_user: Fix return values of xfrm_add_sa_expire.
      [NET]: Revert socket.h/stat.h ifdef hacks.
      [SPARC64]: Update defconfig.
      [SPARC64]: Fix parport_pc build.
      [SPARC]: Fix bus handling in build_device_resources().
      [SPARC]: Handle unresolvable resources better in of_device.c
      [SPARC]: Provide pci_device_to_OF_node() just like powerpc.
      [SPARC]: Provide 'get_property()' alias for of_get_property().
      [RADEON]: Fix blanking return value.
      [AOE]: Add get_unaligned() calls where needed.
      [AF_UNIX]: Test against sk_max_ack_backlog properly.
      [SPARC64]: Fix floppy build failure.
      [NET]: Revert incorrect accept queue backlog changes.

David Stevens (1):
      [IPV6]: /proc/net/anycast6 unbalanced inet6_dev refcnt

Dimitri Gorokhovik (1):
      initramfs should not depend on CONFIG_BLOCK

Dirk Behme (8):
      ARM: OMAP: Fix warning in clock.c
      ARM: OMAP: No IRQF_TRIGGER set_type function for IRQ 353 (MPUIO)
      ARM: OMAP: Fix warnings in plat-omap
      ARM: OMAP: Fix warning in mach-omap2
      ARM: OMAP: Fix CONFIG_DEBUG_LL
      ARM: OMAP: Fix warning in mach-omap1
      ARM: OMAP: Workqueue changes for board-h4.c
      ARM: OMAP: Add missing includes to board-nokia770

Divy Le Ray (1):
      cxgb3 - Tag driver version

Dmitriy Monakhov (4):
      ecryptfs: check xattr operation support fix
      ecryptfs: lower root result must be adirectory
      ecryptfs: handle AOP_TRUNCATED_PAGE better
      3c59x: Handle pci_enable_device() failure while resuming

Don Fry (1):
      pcnet32: Fix PCnet32 performance bug on non-coherent architecutres

Eric Dumazet (1):
      [INET]: twcal_jiffie should be unsigned long, not int

Eric W. Biederman (4):
      x86_64/i386 irq: Fix !CONFIG_SMP compilation
      msi: sanely support hardware level msi disabling
      msi: fix up the msi enable/disable logic
      msi: support masking msi irqs without a mask bit

Florian Fainelli (3):
      [MIPS] MTX1: remove unneeded settings
      [MIPS] MTX1: add idsel cardbus ressources
      [MIPS] MTX1: clear PCI errors

Florian Zumbiehl (2):
      [PPPOE]: Key connections properly on local device.
      [PPPOE]: Use ifindex instead of device pointer in key lookups.

Geert Uytterhoeven (1):
      ps3: introduce CONFIG_PS3_ADVANCED

Gerald Schaefer (1):
      [S390] Fixed handling of access register mode faults.

Gerrit Renker (2):
      [DCCP]: Correctly split CCID half connections
      [DCCP]: Set RTO for newly created child socket

Greg Banks (1):
      knfsd: provide sunrpc pool_mode module option

Greg Ungerer (8):
      m68knommu: use irq_handler_t for passing handler types in 68360 setup
      m68knommu: use irq_handler_t for passing handler types in 68328 setup
      m68knommu: use irq_handler_t and remove regs arg for 68328
      m68knommu: set GPIO lines for serial ports on 5282 in mcfserial.c
      m68knommu: fix work queues in mcfserial.c driver
      m68knommu: GPIO line defines for the ColdFire 5282
      m68knommu: use irq_handler_t and rtc_time in prototypes
      m68knommu: remove local_bh_count

H. Peter Anvin (1):
      md: RAID6: clean up CPUID and FPU enter/exit code

Hans Verkuil (5):
      V4L/DVB (5255): Fix cx25840 firmware loading.
      V4L/DVB (5304): Improve chip matching in v4l2_register
      V4L/DVB (5270): Add VIDIOC_G_ENC_INDEX ioctl
      V4L/DVB (5271): Add VIDIOC_TRY_ENCODER_CMD and VIDIOC_ENCODER_CMD ioctls.
      V4L/DVB (5305): Mark VIDIOC_DBG_S/G_REGISTER as experimental

Heiko Carstens (5):
      timer/hrtimer: take per cpu locks in sane order
      [S390] smp: disable preemption in smp_call_function/smp_call_function_on
      [S390] reipl: move dump_prefix_page out of text section.
      [S390] nss: disable kexec.
      [S390] check_bugs() should be inline.

Horms (1):
      [IA64] point saved_max_pfn to the max_pfn of the entire system

Hugh Dickins (2):
      shmem and simple const super_operations
      suspend regression: sysfs deadlock

Ingo Molnar (8):
      sched: fix SMT scheduler bug
      KVM: add MSR based hypercall API
      KVM: Add host hypercall support for vmx
      paravirt: remove NO_IDLE_HZ on x86
      paravirt: clarify VMI description
      paravirt: let users decide whether they want VMI
      disable NMI watchdog by default
      paravirt: re-enable COMPAT_VDSO

James Simmons (1):
      fbdev: fix kconfig error if FB_DDC=n

Jan Altenberg (1):
      [GIANFAR]: Fix compile error in latest git

Jan Beulich (1):
      adjust legacy IDE resource setting (v2)

Jaroslav Kysela (1):
      [ALSA] version 1.0.14rc3

Jason Gaston (1):
      ahci: RAID mode SATA patch for Intel ICH9M

Jay Vosburgh (3):
      bonding: fix double dev_add_pack
      bonding: only receive ARPs for us
      bonding: Improve IGMP join processing

Jean Delvare (2):
      V4L/DVB (5258): Cafe_ccic: fix compiler warning
      io_apic.h needs apicdef.h

Jeff Dike (8):
      uml: fix host LDT lookup initialization locking, try 2
      uml: add back accidentally removed error
      uml: host VDSO fix
      uml: pte_mkread fix
      linux/audit.h needs linux/types.h
      uml: fix formatting violations in signal delivery code
      uml: add a debugging message
      uml: comment the initialization of a global

Jeff Garzik (5):
      [libata] change master/slave IDENTIFY order
      [libata] pata_{legacy,sc1200,sl82c105}: add missing hooks
      [libata] pata_cmd64x: fix driver description in comments
      [netdrvr] tulip, de2104x: fix typo: s/__sparc_/__sparc__/
      [libata] pata_jmicron: build fix

Jeremy Katz (1):
      KVM: Move virtualization deactivation from CPU_DEAD state to CPU_DOWN_PREPARE

Jin-Bong lee (1):
      V4L/DVB (5276): Cxusb: fix firmware patch for big endian systems

Jiri Kosina (6):
      USB HID: use CONFIG_HID_DEBUG for outputting report descriptor
      HID: fix bug in zeroing the last field byte in output reports
      HID: fix possible double-free on error path in hid parser
      HID: fix broken Logitech S510 keyboard report descriptor; make extra keys work
      HID: add git tree information to MAINTAINERS
      HID: fix Logitech DiNovo Edge touchwheel and Logic3 /SpectraVideo middle button

Joe Sauer (1):
      [ALSA] soc - Fix WM9712 register cache entry

Joerg Roedel (2):
      KVM: vmx: hack set_cr0_no_modeswitch() to actually do modeswitch
      KVM: SVM: intercept SMI to handle it at host level

Johannes Berg (2):
      schedule wext/rtnl for removal
      [NET]: Fix compat_sock_common_getsockopt typo.

John Heffner (1):
      [TCP]: Document several sysctls.

John Stultz (1):
      clocksource init adjustments (fix bug #7426)

Josh Triplett (1):
      Publish rcutorture module parameters via sysfs, read-only

Julien BLACHE (1):
      USB HID: Fix USB vendor and product IDs endianness for USB HID devices

Karsten Keil (1):
      Fix buffer overflow and races in capi debug functions

Kristen Carlson Accardi (1):
      ACPI: make bay depend on dock

Krzysztof Halasa (1):
      [HDLC] Fix dev->header_cache_update having a random value.

Lee Schermerhorn (1):
      [IA64] always build arch/ia64/lib/xor.o

Li Yang (2):
      ucc_geth: Fix BD processing
      ucc_geth: returns NETDEV_TX_BUSY when BD ring is full

Liam Girdwood (1):
      [ALSA] soc - WM9712 PCM volume

Linsys Contractor Mithlesh Thukral (2):
      NetXen: Updates, removal of unsupported features and minor bug fixes.
      NetXen: Fix second rmmod failure observed on PowerPC machines.

Linus Torvalds (2):
      Revert "[PATCH] LOG2: Alter get_order() so that it can make use of ilog2() on a constant"
      Linux 2.6.21-rc3

Maciej W. Rozycki (1):
      dz: remove struct pt_regs references

Magnus Damm (2):
      ide-cs: Update device table
      [IA64] kexec: Use EFI_LOADER_DATA for ELF core header

Marcel Holtmann (1):
      Fix buffer overflow in Omnikey CardMan 4040 driver (CVE-2007-0005)

Marek Vašut (1):
      ARM: OMAP: OMAP310 Serial

Mark Gross (1):
      minor updat to tlclk Kconfig entry

Mark Lord (2):
      sdhci: make isr tolerant of read errors
      Fix 2.6.21 rfcomm lockups

Markus Rechberger (1):
      KVM: Use page_private()/set_page_private() apis

Martin Schwidefsky (1):
      [S390] kprobes breaks BUG_ON

Matthew Percival (1):
      ARM: OMAP: dmtimer.c omap1 register fix

Maxim Levitsky (3):
      dmfe: trivial/spelling fixes
      dmfe: fix two bugs
      dmfe: Fix link detection

Michael Halcrow (4):
      eCryptfs: resolve lower page unlocking problem
      eCryptfs: set O_LARGEFILE when opening lower file
      eCryptfs: remove unnecessary flush_dcache_page()
      eCryptfs: no path_release() after path_lookup() error

Michael Holzheu (1):
      [S390] tape: Compression overwrites crypto setting

Michael Krufky (2):
      V4L/DVB (5295): Digitv: open nxt6000 i2c_gate for TDED4 tuner handling
      V4L/DVB (5260): Cx88-blackbird: allow usage of both 376836 and 262144 sized firmware images

Michal Miroslaw (5):
      [NETFILTER]: nfnetlink_log: fix reference leak
      [NETFILTER]: nfnetlink_log: fix use after free
      [NETFILTER]: nfnetlink_log: fix NULL pointer dereference
      [NETFILTER]: nfnetlink_log: fix possible NULL pointer dereference
      [NETFILTER]: nfnetlink_log: fix reference counting

Michal Piotrowski (1):
      char/epca.c: remove unused function

Michal Wrobel (1):
      [IPV6]: anycast refcnt fix

Mikael Pettersson (1):
      pata_legacy: fix io/irq mismatch

Mike Isely (1):
      V4L/DVB (5366): Pvrusb2: Fix compilation warning for amd64 builds (use %zu instead of %u)

Mike Miller (OS Dev) (2):
      cciss: fix for 2TB support
      cciss: add struct pci_driver shutdown support (replaces reboot notifier)

Mingming Cao (1):
      ext[34]: EA block reference count racing fix

NeilBrown (10):
      Fix failure paths in modules init in umem.c
      md: fix raid10 recovery problem.
      md: move warning about creating a raid array on partitions of the one device
      md: clean out unplug and other queue function on md shutdown
      md: restart a (raid5) reshape that has been aborted due to a read/write error
      md: add support for reshape of a raid6
      md: fix for raid6 reshape
      knfsd: use recv_msg to get peer address for NFSD instead of code-copying
      knfsd: remove CONFIG_IPV6 ifdefs from sunrpc server code
      knfsd: fix recently introduced problem with shutting down a busy NFS server

Nick Piggin (2):
      Rename PG_checked to PG_owner_priv_1
      [IA64] permon use-after-free fix

Oleg Nesterov (1):
      adapt page_lock_anon_vma() to PREEMPT_RCU

Patrick McHardy (6):
      [NET]: Handle disabled preemption in gfp_any()
      [NET]: Fix kfree(skb)
      [NETFILTER]: conntrack: fix {nf,ip}_ct_iterate_cleanup endless loops
      [NETFILTER]: nf_conntrack/nf_nat: fix incorrect config ifdefs
      [NETFILTER]: tcp conntrack: accept SYN|URG as valid
      [NETFILTER]: nfnetlink_log: fix module reference counting

Paul Moore (1):
      [NetLabel]: Verify sensitivity level has a valid CIPSO mapping

Paul Mundt (1):
      fb: sm501fb off-by-1 sysfs store

Peter Zijlstra (1):
      mqueue: nested locking annotation

Pierre Ossman (3):
      ncpfs: make sure server connection survives a kill
      mmc: require explicit support for high-speed
      sdhci: release irq during suspend

Prarit Bhargava (1):
      __devinit & __devexit cleanups for de2104x driver

Rafael J. Wysocki (1):
      kconfig: Update swsusp description

Ralf Baechle (21):
      Fix sysfs build breakage if !CONFIG_SYSFS
      jmr3927: do not call tc35815_killall().
      [MIPS] N32 waitid is the same as o32.
      [MIPS] Replace sys32_socketcall with the generic compat_sys_socketcall.
      [MIPS] Replace sys32_timer_create with the generic compat_sys_timer_create.
      [MIPS] Oprofile: Add missing break statements.
      [MIPS] DEC: Remove redeclarations of mips_machgroup and mips_machtype.
      [MIPS] Fix and cleanup the mess that a dozen prom_printf variants are.
      [MIPS] RM: It should be #ifdef CONFIG_FOO not #if CONFIG_FOO ...
      [MIPS] DMA: Fix a bunch of warnings due to missing inline keywords.
      [MIPS] SN: PCI fixup needs to include <irq.h>.
      [MIPS] dma_sync_sg_for_cpu is a no-op except for non-coherent R10000s.
      [MIPS] Atlas, Malta: Fix build warning.
      [MIPS] SMTC: <asm/smtc_ipi.h> must include <linux/spinlock.h>
      [MIPS] SMTC: <asm/mips_mt.h> must include <linux/cpumask.h>
      [MIPS] SMTC: Add fordward declarations for mm_struct and task_struct.
      [MIPS] SMTC: De-obscure Malta hooks.
      [MIPS] R2 bitops compile fix for gcc < 4.0.
      [MIPS] Export __copy_user_inatomic.
      [MIPS] Wire up ioprio_set and ioprio_get.
      [MIPS] IP27: Build fix

Randy Dunlap (4):
      kernel-doc: allow space after __attribute__
      kernel-doc fixes for 2.6.20-git15 (non-drivers)
      add -mm testing in SubmitChecklist
      atyfb: fix kconfig error part 2

Richard Knutsson (1):
      ide/pci/delkin_cb.c: pci_module_init to pci_register_driver

Richard Purdie (3):
      [ARM] 4237/2: oprofile: Always allow backtraces on ARM
      backlight: Fix nvidia backlight initial brightness
      backlight: Allow enable/disable of fb backlights, fixing regressions

Robert Marquardt (1):
      HID blacklisting of all Code Mercenaries IOWarrior devices

Roland Kletzing (1):
      Documentation for io-accounting / reporting via procfs

Rolf Eike Beer (2):
      [IPX]: Remove outdated information from Kconfig
      [IPX]: Remove ancient changelog

Ron Mercer (1):
      qla3xxx: bugfix for line omitted in previous patch.

Russell King (8):
      [ARM] Yet more asm/apm-emulation.h stuff
      [ARM] EBSA110: Work around build errors
      [ARM] rtc-pcf8583: don't use BCD_TO_BIN/BIN_TO_BCD
      [ARM] rtc-pcf8583: correct month and year offsets
      [ARM] rtc-pcf8583: Final fixes for this RTC on RiscPC
      [ARM] ARM FAS216: don't modify scsi_cmnd request_bufflen
      [ARM] ARM SCSI: Don't try to dma_map_sg too many scatterlist entries
      [ARM] Acorn: move the i2c bus driver into drivers/i2c

Sam Ravnborg (2):
      fix section mismatch warning in lockdep
      usb-storage: do not rebuild when kernel version changes

Sergei Shtylyov (5):
      alim15x3: fix PIO mode setup
      cmd64x: fix PIO mode setup (take 3)
      piix/slc90e66: more tuneproc() fixing (take 2)
      ide: ide_get_best_pio_mode() returns incorrect IORDY setting (take 2)
      natsemi: netpoll fixes

Stefan Weinhuber (1):
      [S390] dasd: Use default recovery for SNSS requests

Stefano Brivio (1):
      bcm43xx: fix for 4309

Stephen Hemminger (1):
      [BRIDGE]: Fix locking of set path cost.

Steve French (7):
      [CIFS] Fix locking problem around some cifs uses of i_size write
      [CIFS] small piece missing from previous patch
      [CIFS] cifs export operations
      [CIFS] New file for previous commit
      [CIFS] Remove some unused functions/declarations
      [CIFS] Fix set file size to zero when doing chmod to Samba 3.0.26pre
      [CIFS] cifs_prepare_write was incorrectly rereading page in some cases

Takashi Iwai (7):
      [ALSA] hda-codec - Add LFE support on Dell M90
      [ALSA] hda-codec - Add missing Mic Boost controls for ALC262
      [ALSA] hda-codec - Define pin configs for MacBooks
      [ALSA] Add missing sysfs device assignment for ALSA PCI drivers
      [ALSA] ac97 - Add Thinkpad X31 and R40 to AD1981x blacklist
      [ALSA] hda-codec - Add missing Mic Boost for AD1986A codec
      [ALSA] cmipci - Allow to disable integrated FM port

Tejun Heo (11):
      libata: clear drvdata in ata_host_release(), take#2
      sata_sil24: kill unused local variable idx in sil24_fill_sg()
      libata: blacklist FUJITSU MHT2060BH for NCQ
      pata_jmicron: drop unnecessary device programming in [re]init
      jmicron ATA: reimplement jmicron ATA quirk
      ahci/pata_jmicron: match class not function number
      ahci: improve spurious SDB FIS handling
      libata: add missing PM callbacks
      libata: add missing CONFIG_PM in LLDs
      libata: add CONFIG_PM to libata core layer
      ide: fix drive side 80c cable check, take 2

Thomas Bogendoerfer (1):
      [MIPS] SNI: Fix mc146818_decode_year

Thomas Gleixner (5):
      Fix posix-cpu-timer breakage caused by stale p->last_ran value
      fix "NMI appears to be stuck"
      Save/restore periodic tick information over suspend/resume
      Scheduled removal of SA_xxx interrupt flags fixups 3
      highres: do not run the TIMER_SOFTIRQ after switching to highres mode

Tilman Schmidt (1):
      drivers/isdn/gigaset: build asyncdata.o into the gigaset module (fix)

Timo Teras (1):
      ARM: OMAP: Proper handling of DMA4_IRQSTATUS_L0

Tobin Davis (2):
      [ALSA] hda-codec - Add method for configuring Mac Pro without PCI SSID
      [ALSA] hda-codec - Fix logic error in headphone mute for Conexant codecs

Tony Breeds (1):
      Fix soft lockup with iSeries viocd driver

Tony Lindgren (3):
      ARM: OMAP: Remove obsolete alsa typedefs
      ARM: OMAP: Use linux/delay.h not asm/delay.h
      ARM: OMAP: Add missing get_irqnr_preamble and arch_ret_to_user for omap2

Tony Luck (1):
      Revert "[IA64] swiotlb abstraction (e.g. for Xen)"

Trond Myklebust (1):
      VM: invalidate_inode_pages2_range() should not exit early

Uri Lublin (4):
      KVM: Add missing calls to mark_page_dirty()
      KVM: Fix dirty page log bitmap size/access calculation
      kvm: move do_remove_write_access() up
      KVM: Remove write access permissions when dirty-page-logging is enabled

Vassili Karpov (1):
      Documentation: CPU load calculation description

Vladimir Ananiev (1):
      ARM: OMAP: omap1510->15xx conversions needed for sx1

Wei Dong (1):
      [NET]: Fix bugs in "Whether sock accept queue is full" checking

Yasuyuki Kozakai (1):
      [NETFILTER]: ip6_route_me_harder should take into account mark

Yoichi Yuasa (3):
      fix memory leak in dma_declare_coherent_memory()
      [MIPS] Cobalt: update reserved resources
      [MIPS] Cobalt: Fix early printk

Zachary Amsden (9):
      vmi: timer fixes round two
      vmi: sched clock paravirt op fix
      vmi: cpu cycles fix
      vmi: fix highpte
      vmi: paravirt drop udelay op
      vmi: pit override
      vmi: fix nohz compile
      vmi: apic ops
      vmi: smp fixes

schwab@suse.de (1):
      [IA64] Remove stack hard limit on ia64
---1463790079-1345696304-1173243541=:5963--
