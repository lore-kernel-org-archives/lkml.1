Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbYJJAWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbYJJAWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 20:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbYJJAWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 20:22:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50654 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbYJJAWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 20:22:24 -0400
Date: Fri, 10 Oct 2008 02:21:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 updates for v2.6.28, phase #10, roundup.
Message-ID: <20081010002157.GA17765@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-v28-for-linus-phase10 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-v28-for-linus-phase10

Remaining x86 topics: x86/xsave, x86/xen, x86/time, x86/setup, 
                      x86/dumpstack, x86/cpu, x86/build, x86/spinlocks, 
                      x86/memory-corruption-check, x86/idle, 
                      x86/exports, x86/early-printk, x86/crashdump, 
                      x86/commandline, x86/microcode, x86/quirks.

out-of-topic modifications in x86-v28-for-linus-phase10:
--------------------------------------------------------
MAINTAINERS                        # e7f5b30: x86: AMD microcode patch loading 
drivers/base/power/main.c          # 5394f80: x86: check for and defend against
drivers/usb/host/ehci.h            # 0af3673: usb: move ehci reg def
drivers/video/Kconfig              # a57a5c2: x86 setup: remove remnants of CON
drivers/video/console/Kconfig      # a57a5c2: x86 setup: remove remnants of CON
include/linux/kernel.h             # 9c3254a: x86: fix compile error with corru
                                   # bb577f9: x86: add periodic corruption chec
                                   # 5394f80: x86: check for and defend against
include/linux/usb/ehci_def.h       # 0af3673: usb: move ehci reg def
scripts/Kbuild.include             # 43789e2: kbuild: fix cc-option and cc-opti

 Thanks,

	Ingo

------------------>
Alexander van Heukelum (8):
      dumpstack: x86: move die_nmi to dumpstack_32.c
      dumpstack: x86: make printk_address equal
      dumpstack: x86: add "end" parameter to valid_stack_ptr and print_context_stack
      dumptrace: x86: consistently include loglevel, print stack switch
      dumpstack: x86: use log_lvl and unify trace formatting
      dumpstack: i386: make kstack= an early boot-param and add oops=panic
      dumpstack: x86: various small unification steps
      dumpstack: x86: various small unification steps, fix

Alexey Dobriyan (2):
      x86 setup: remove remnants of CONFIG_VIDEO_SELECT (read: vga=)
      x86: make setup_xstate_init() __init

Andrey Borzenkov (2):
      x86: fix ghost EDD devices in /sys again
      x86 setup: fix ghost entries under /sys/firmware/edd take 3

Arjan van de Ven (1):
      x86: use round_jiffies() for the corruption check timer

Chuck Ebbert (1):
      xen: make CONFIG_XEN_SAVE_RESTORE depend on CONFIG_XEN

David Woodhouse (1):
      Fix date output in x86 microcode driver.

Dmitry Adamushko (6):
      x86-microcode: fix unbalanced use of get_cpu()
      x86-microcode: generic interface refactoring
      x86, microcode rework, v2
      x86: moved microcode.c to microcode_intel.c
      x86, microcode_amd: cleanup, mark request_microcode_user() as unsupported
      x86/microcode: fix sleeping function called from invalid context at kernel/mutex.c

Glauber Costa (13):
      x86: use user_mode macro
      x86: coalesce tests
      x86: set bp field in pt_regs properly
      x86: use frame pointer information on x86_64 profile_pc
      x86: remove SEGMENT_IS_FLAT_CODE
      x86: use user_mode_vm instead of user_mode
      x86: bind irq0 irq data to cpu0
      x86: factor out irq initialization for x86_64
      x86: make init_ISA_irqs nonstatic
      x86: rename timer_event_interrupt to timer_interrupt
      x86: replace hardcoded number
      x86: wrap MCA_bus test around an ifdef
      x86: move vgetcpu mode probing to cpu detection

H. Peter Anvin (5):
      x86: boot/compressed/Makefile: fix "make clean"
      x86: when building image.iso, use isohybrid if it exists
      kbuild: fix cc-option and cc-option-yn
      x86: prevent binutils from being "smart" and generating NOPLs for us
      Revert "x86: fix ghost EDD devices in /sys again"

Harvey Harrison (1):
      x86: early_printk.c trivial sparse fixes

Hugh Dickins (1):
      x86: add periodic corruption check

Ingo Molnar (8):
      x86: usb debug port early console, fix
      x86, microcode support: fix build error
      x86, microcode: fix symbol exports
      x86, microcode: fix module license string
      x86, microcode rework, v2, fix
      x86: add DMI quirk for AMI BIOS which corrupts address 0xc000 during resume
      x86: reserve low 64K on AMI and Phoenix BIOS boxen
      x86: add X86_RESERVE_LOW_64K

Jan Beulich (5):
      x86: ticket spin locks: fix asm constraints
      x86: ticket spin locks: factor out more common code
      x86: ticket spin locks: reduce instruction dependencies
      x86: init annotations in early_printk() setup
      x86: adjust dependencies for CONFIG_X86_CMOV

Jeremy Fitzhardinge (6):
      x86: check for and defend against BIOS memory corruption
      x86: clean up memory corruption check and add more kernel parameters
      x86: default corruption check to off, but put parameter default in Kconfig
      x86: fix compile error with corruption checking disabled
      xen: clean up x86-64 warnings
      xen: remove unused balloon.h

Michal Januszewski (1):
      x86: replace a magic number with a named constant in the VESA boot code

Paul Bolle (2):
      x86 setup: remove DEF_INITSEG and DEF_SETUPSEG
      x86 setup: remove IMAGE_OFFSET

Peter Oruba (20):
      x86: AMD microcode patch loading support v2
      x86: moved Intel microcode patch loader declarations to seperate header file
      x86: typedef removal
      x86: move per CPU microcode structure declaration to header file
      x86: move microcode.c to microcode_intel.c
      x86: code split to two parts
      x86: structure declaration renaming
      x86: add AMD specific declarations
      x86: first step of refactoring, introducing microcode_ops
      x86: major refactoring
      x86: AMD microcode patch loading support
      x86: AMD microcode patch loader style corrections
      x86: Intel microcode patch loader style corrections
      x86: moved function declarations out from AMD microcode patch loader to heade file
      x86: minor pointer type cast in AMD microcode patch loader
      x86: Microcode patch loader style corrections
      x86: Fixed NULL function pointer dereference in AMD microcode patch loader.
      x86, microcode rework, v2, renaming
      x86, microcode rework, v2, renaming cont.
      x86: microcode patch loader bugfix

Randy Dunlap (1):
      x86, microcode_amd: fix shift warning

Yinghai Lu (5):
      usb: move ehci reg def
      x86: usb debug port early console, v4
      x86: fix CONFIG_X86_RESERVE_LOW_64K=y
      x86: fix macro with bad_bios_dmi_table
      x86: cleanup, remove extra ifdef


 Documentation/kernel-parameters.txt |   26 +-
 MAINTAINERS                         |    5 +
 arch/x86/Kconfig                    |   90 ++++-
 arch/x86/Kconfig.debug              |   13 +
 arch/x86/Makefile_32.cpu            |    5 +
 arch/x86/boot/Makefile              |    5 +-
 arch/x86/boot/compressed/Makefile   |    8 +-
 arch/x86/boot/edd.c                 |    7 +-
 arch/x86/boot/video-vesa.c          |    2 +-
 arch/x86/configs/i386_defconfig     |    1 -
 arch/x86/configs/x86_64_defconfig   |    1 -
 arch/x86/kernel/Makefile            |    6 +-
 arch/x86/kernel/cpu/common.c        |   12 +
 arch/x86/kernel/dumpstack_32.c      |  157 ++++---
 arch/x86/kernel/dumpstack_64.c      |   38 +-
 arch/x86/kernel/early_printk.c      |  766 +++++++++++++++++++++++++++++++-
 arch/x86/kernel/entry_64.S          |    7 +
 arch/x86/kernel/irqinit_64.c        |   43 ++-
 arch/x86/kernel/microcode.c         |  853 -----------------------------------
 arch/x86/kernel/microcode_amd.c     |  435 ++++++++++++++++++
 arch/x86/kernel/microcode_core.c    |  508 +++++++++++++++++++++
 arch/x86/kernel/microcode_intel.c   |  480 ++++++++++++++++++++
 arch/x86/kernel/setup.c             |  196 ++++++++-
 arch/x86/kernel/time_32.c           |    7 +-
 arch/x86/kernel/time_64.c           |   23 +-
 arch/x86/kernel/traps.c             |   37 --
 arch/x86/kernel/xsave.c             |    2 +-
 arch/x86/mm/init_32.c               |    2 +
 arch/x86/mm/init_64.c               |    2 +
 arch/x86/xen/Kconfig                |    4 +-
 arch/x86/xen/enlighten.c            |   61 +--
 arch/x86/xen/xen-asm_64.S           |   20 +-
 drivers/base/power/main.c           |    1 +
 drivers/usb/host/ehci.h             |  138 +------
 drivers/video/Kconfig               |    2 -
 drivers/video/console/Kconfig       |   16 -
 drivers/xen/balloon.c               |    1 -
 include/asm-x86/boot.h              |    2 -
 include/asm-x86/microcode.h         |   47 ++
 include/asm-x86/processor.h         |   35 --
 include/asm-x86/segment.h           |    6 -
 include/asm-x86/spinlock.h          |   60 +--
 include/linux/kernel.h              |   17 +
 include/linux/usb/ehci_def.h        |  160 +++++++
 include/xen/balloon.h               |   61 ---
 scripts/Kbuild.include              |    4 +-
 46 files changed, 2992 insertions(+), 1380 deletions(-)
 delete mode 100644 arch/x86/kernel/microcode.c
 create mode 100644 arch/x86/kernel/microcode_amd.c
 create mode 100644 arch/x86/kernel/microcode_core.c
 create mode 100644 arch/x86/kernel/microcode_intel.c
 create mode 100644 include/asm-x86/microcode.h
 create mode 100644 include/linux/usb/ehci_def.h
 delete mode 100644 include/xen/balloon.h

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c5d891f..998877b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -658,11 +658,12 @@ and is between 256 and 4096 characters. It is defined in the file
 	earlyprintk=	[X86-32,X86-64,SH,BLACKFIN]
 			earlyprintk=vga
 			earlyprintk=serial[,ttySn[,baudrate]]
+			earlyprintk=dbgp
 
 			Append ",keep" to not disable it when the real console
 			takes over.
 
-			Only vga or serial at a time, not both.
+			Only vga or serial or usb debug port at a time.
 
 			Currently only ttyS0 and ttyS1 are supported.
 
@@ -1227,6 +1228,29 @@ and is between 256 and 4096 characters. It is defined in the file
 			         or
 			         memmap=0x10000$0x18690000
 
+	memory_corruption_check=0/1 [X86]
+			Some BIOSes seem to corrupt the first 64k of
+			memory when doing things like suspend/resume.
+			Setting this option will scan the memory
+			looking for corruption.  Enabling this will
+			both detect corruption and prevent the kernel
+			from using the memory being corrupted.
+			However, its intended as a diagnostic tool; if
+			repeatable BIOS-originated corruption always
+			affects the same memory, you can use memmap=
+			to prevent the kernel from using that memory.
+
+	memory_corruption_check_size=size [X86]
+			By default it checks for corruption in the low
+			64k, making this memory unavailable for normal
+			use.  Use this parameter to scan for
+			corruption in more or less memory.
+
+	memory_corruption_check_period=seconds [X86]
+			By default it checks for corruption every 60
+			seconds.  Use this parameter to check at some
+			other rate.  0 disables periodic checking.
+
 	memtest=	[KNL,X86] Enable memtest
 			Format: <integer>
 			range: 0,4 : pattern number
diff --git a/MAINTAINERS b/MAINTAINERS
index 3c124d7..0f5227e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -390,6 +390,11 @@ L:	iommu@lists.linux-foundation.org
 T:	git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git
 S:	Supported
 
+AMD MICROCODE UPDATE SUPPORT
+P:      Peter Oruba
+M:      peter.oruba@amd.com
+S:      Supported
+
 AMS (Apple Motion Sensor) DRIVER
 P:	Stelian Pop
 M:	stelian@popies.net
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b667150..f84046d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -790,23 +790,45 @@ config X86_REBOOTFIXUPS
 	  Say N otherwise.
 
 config MICROCODE
-	tristate "/dev/cpu/microcode - Intel IA32 CPU microcode support"
+	tristate "/dev/cpu/microcode - microcode support"
 	select FW_LOADER
 	---help---
 	  If you say Y here, you will be able to update the microcode on
-	  Intel processors in the IA32 family, e.g. Pentium Pro, Pentium II,
-	  Pentium III, Pentium 4, Xeon etc.  You will obviously need the
-	  actual microcode binary data itself which is not shipped with the
-	  Linux kernel.
+	  certain Intel and AMD processors. The Intel support is for the
+	  IA32 family, e.g. Pentium Pro, Pentium II, Pentium III,
+	  Pentium 4, Xeon etc. The AMD support is for family 0x10 and
+	  0x11 processors, e.g. Opteron, Phenom and Turion 64 Ultra.
+	  You will obviously need the actual microcode binary data itself
+	  which is not shipped with the Linux kernel.
 
-	  For latest news and information on obtaining all the required
-	  ingredients for this driver, check:
-	  <http://www.urbanmyth.org/microcode/>.
+	  This option selects the general module only, you need to select
+	  at least one vendor specific module as well.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called microcode.
 
-config MICROCODE_OLD_INTERFACE
+config MICROCODE_INTEL
+       bool "Intel microcode patch loading support"
+       depends on MICROCODE
+       default MICROCODE
+       select FW_LOADER
+       --help---
+         This options enables microcode patch loading support for Intel
+         processors.
+
+         For latest news and information on obtaining all the required
+         Intel ingredients for this driver, check:
+         <http://www.urbanmyth.org/microcode/>.
+
+config MICROCODE_AMD
+       bool "AMD microcode patch loading support"
+       depends on MICROCODE
+       select FW_LOADER
+       --help---
+         If you select this option, microcode patch loading support for AMD
+	 processors will be enabled.
+
+   config MICROCODE_OLD_INTERFACE
 	def_bool y
 	depends on MICROCODE
 
@@ -1073,6 +1095,56 @@ config HIGHPTE
 	  low memory.  Setting this option will put user-space page table
 	  entries in high memory.
 
+config X86_CHECK_BIOS_CORRUPTION
+        bool "Check for low memory corruption"
+	help
+	 Periodically check for memory corruption in low memory, which
+	 is suspected to be caused by BIOS.  Even when enabled in the
+	 configuration, it is disabled at runtime.  Enable it by
+	 setting "memory_corruption_check=1" on the kernel command
+	 line.  By default it scans the low 64k of memory every 60
+	 seconds; see the memory_corruption_check_size and
+	 memory_corruption_check_period parameters in
+	 Documentation/kernel-parameters.txt to adjust this.
+
+	 When enabled with the default parameters, this option has
+	 almost no overhead, as it reserves a relatively small amount
+	 of memory and scans it infrequently.  It both detects corruption
+	 and prevents it from affecting the running system.
+
+	 It is, however, intended as a diagnostic tool; if repeatable
+	 BIOS-originated corruption always affects the same memory,
+	 you can use memmap= to prevent the kernel from using that
+	 memory.
+
+config X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK
+        bool "Set the default setting of memory_corruption_check"
+	depends on X86_CHECK_BIOS_CORRUPTION
+	default y
+	help
+	 Set whether the default state of memory_corruption_check is
+	 on or off.
+
+config X86_RESERVE_LOW_64K
+        bool "Reserve low 64K of RAM on AMI/Phoenix BIOSen"
+	default y
+	help
+	 Reserve the first 64K of physical RAM on BIOSes that are known
+	 to potentially corrupt that memory range. A numbers of BIOSes are
+	 known to utilize this area during suspend/resume, so it must not
+	 be used by the kernel.
+
+	 Set this to N if you are absolutely sure that you trust the BIOS
+	 to get all its memory reservations and usages right.
+
+	 If you have doubts about the BIOS (e.g. suspend/resume does not
+	 work or there's kernel crashes after certain hardware hotplug
+	 events) and it's not AMI or Phoenix, then you might want to enable
+	 X86_CHECK_BIOS_CORRUPTION=y to allow the kernel to check typical
+	 corruption patterns.
+
+	 Say Y if unsure.
+
 config MATH_EMULATION
 	bool
 	prompt "Math emulation" if X86_32
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 092f019..2a3dfbd 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -43,6 +43,19 @@ config EARLY_PRINTK
 	  with klogd/syslogd or the X server. You should normally N here,
 	  unless you want to debug such a crash.
 
+config EARLY_PRINTK_DBGP
+	bool "Early printk via EHCI debug port"
+	default n
+	depends on EARLY_PRINTK && PCI
+	help
+	  Write kernel log output directly into the EHCI debug port.
+
+	  This is useful for kernel debugging when your machine crashes very
+	  early before the console code is initialized. For normal operation
+	  it is not recommended because it looks ugly and doesn't cooperate
+	  with klogd/syslogd or the X server. You should normally N here,
+	  unless you want to debug such a crash. You need usb debug device.
+
 config DEBUG_STACKOVERFLOW
 	bool "Check for stack overflows"
 	depends on DEBUG_KERNEL
diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
index 12bdd85..80177ec 100644
--- a/arch/x86/Makefile_32.cpu
+++ b/arch/x86/Makefile_32.cpu
@@ -44,3 +44,8 @@ cflags-$(CONFIG_MGEODEGX1)	+= -march=pentium-mmx
 # cpu entries
 cflags-$(CONFIG_X86_GENERIC) 	+= $(call tune,generic,$(call tune,i686))
 
+# Bug fix for binutils: this option is required in order to keep
+# binutils from generating NOPL instructions against our will.
+ifneq ($(CONFIG_X86_P6_NOP),y)
+cflags-y			+= $(call cc-option,-Wa$(comma)-mtune=generic32,)
+endif
diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 7ee102f..cd48c72 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -72,9 +72,7 @@ KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os -D_SETUP -D__KERNEL__ \
 KBUILD_CFLAGS +=   $(call cc-option,-m32)
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
 
-$(obj)/zImage:  IMAGE_OFFSET := 0x1000
 $(obj)/zImage:  asflags-y := $(SVGA_MODE) $(RAMDISK)
-$(obj)/bzImage: IMAGE_OFFSET := 0x100000
 $(obj)/bzImage: ccflags-y := -D__BIG_KERNEL__
 $(obj)/bzImage: asflags-y := $(SVGA_MODE) $(RAMDISK) -D__BIG_KERNEL__
 $(obj)/bzImage: BUILDFLAGS   := -b
@@ -117,7 +115,7 @@ $(obj)/setup.bin: $(obj)/setup.elf FORCE
 	$(call if_changed,objcopy)
 
 $(obj)/compressed/vmlinux: FORCE
-	$(Q)$(MAKE) $(build)=$(obj)/compressed IMAGE_OFFSET=$(IMAGE_OFFSET) $@
+	$(Q)$(MAKE) $(build)=$(obj)/compressed $@
 
 # Set this if you want to pass append arguments to the zdisk/fdimage/isoimage kernel
 FDARGS =
@@ -181,6 +179,7 @@ isoimage: $(BOOTIMAGE)
 	mkisofs -J -r -o $(obj)/image.iso -b isolinux.bin -c boot.cat \
 		-no-emul-boot -boot-load-size 4 -boot-info-table \
 		$(obj)/isoimage
+	isohybrid $(obj)/image.iso 2>/dev/null || true
 	rm -rf $(obj)/isoimage
 
 zlilo: $(BOOTIMAGE)
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 92fdd35..1771c80 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -27,9 +27,8 @@ $(obj)/vmlinux.bin: vmlinux FORCE
 	$(call if_changed,objcopy)
 
 
-ifeq ($(CONFIG_X86_32),y)
-targets += vmlinux.bin.all vmlinux.relocs
-hostprogs-y := relocs
+targets += vmlinux.bin.all vmlinux.relocs relocs
+hostprogs-$(CONFIG_X86_32) += relocs
 
 quiet_cmd_relocs = RELOCS  $@
       cmd_relocs = $(obj)/relocs $< > $@;$(obj)/relocs --abs-relocs $<
@@ -43,6 +42,8 @@ quiet_cmd_relocbin = BUILD   $@
 $(obj)/vmlinux.bin.all: $(vmlinux.bin.all-y) FORCE
 	$(call if_changed,relocbin)
 
+ifeq ($(CONFIG_X86_32),y)
+
 ifdef CONFIG_RELOCATABLE
 $(obj)/vmlinux.bin.gz: $(obj)/vmlinux.bin.all FORCE
 	$(call if_changed,gzip)
@@ -59,6 +60,5 @@ $(obj)/vmlinux.bin.gz: $(obj)/vmlinux.bin FORCE
 LDFLAGS_piggy.o := -r --format binary --oformat elf64-x86-64 -T
 endif
 
-
 $(obj)/piggy.o: $(obj)/vmlinux.scr $(obj)/vmlinux.bin.gz FORCE
 	$(call if_changed,ld)
diff --git a/arch/x86/boot/edd.c b/arch/x86/boot/edd.c
index d93cbc6..1aae8f3 100644
--- a/arch/x86/boot/edd.c
+++ b/arch/x86/boot/edd.c
@@ -41,6 +41,7 @@ static u32 read_mbr_sig(u8 devno, struct edd_info *ei, u32 *mbrsig)
 	char *mbrbuf_ptr, *mbrbuf_end;
 	u32 buf_base, mbr_base;
 	extern char _end[];
+	u16 mbr_magic;
 
 	sector_size = ei->params.bytes_per_sector;
 	if (!sector_size)
@@ -58,11 +59,15 @@ static u32 read_mbr_sig(u8 devno, struct edd_info *ei, u32 *mbrsig)
 	if (mbrbuf_end > (char *)(size_t)boot_params.hdr.heap_end_ptr)
 		return -1;
 
+	memset(mbrbuf_ptr, 0, sector_size);
 	if (read_mbr(devno, mbrbuf_ptr))
 		return -1;
 
 	*mbrsig = *(u32 *)&mbrbuf_ptr[EDD_MBR_SIG_OFFSET];
-	return 0;
+	mbr_magic = *(u16 *)&mbrbuf_ptr[510];
+
+	/* check for valid MBR magic */
+	return mbr_magic == 0xAA55 ? 0 : -1;
 }
 
 static int get_edd_info(u8 devno, struct edd_info *ei)
diff --git a/arch/x86/boot/video-vesa.c b/arch/x86/boot/video-vesa.c
index 401ad99..1e6fe02 100644
--- a/arch/x86/boot/video-vesa.c
+++ b/arch/x86/boot/video-vesa.c
@@ -224,7 +224,7 @@ static void vesa_store_pm_info(void)
 static void vesa_store_mode_params_graphics(void)
 {
 	/* Tell the kernel we're in VESA graphics mode */
-	boot_params.screen_info.orig_video_isVGA = 0x23;
+	boot_params.screen_info.orig_video_isVGA = VIDEO_TYPE_VLFB;
 
 	/* Mode parameters */
 	boot_params.screen_info.vesa_attributes = vminfo.mode_attr;
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index c54b710..13b8c86 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -1533,7 +1533,6 @@ CONFIG_BACKLIGHT_CLASS_DEVICE=y
 CONFIG_VGA_CONSOLE=y
 CONFIG_VGACON_SOFT_SCROLLBACK=y
 CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
-CONFIG_VIDEO_SELECT=y
 CONFIG_DUMMY_CONSOLE=y
 # CONFIG_FRAMEBUFFER_CONSOLE is not set
 CONFIG_LOGO=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 638bc85..f0a03d7 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -1504,7 +1504,6 @@ CONFIG_BACKLIGHT_CLASS_DEVICE=y
 CONFIG_VGA_CONSOLE=y
 CONFIG_VGACON_SOFT_SCROLLBACK=y
 CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
-CONFIG_VIDEO_SELECT=y
 CONFIG_DUMMY_CONSOLE=y
 # CONFIG_FRAMEBUFFER_CONSOLE is not set
 CONFIG_LOGO=y
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 4dc47a3..cb6ade4 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -51,7 +51,6 @@ obj-$(CONFIG_X86_BIOS_REBOOT)	+= reboot.o
 obj-$(CONFIG_MCA)		+= mca_32.o
 obj-$(CONFIG_X86_MSR)		+= msr.o
 obj-$(CONFIG_X86_CPUID)		+= cpuid.o
-obj-$(CONFIG_MICROCODE)		+= microcode.o
 obj-$(CONFIG_PCI)		+= early-quirks.o
 apm-y				:= apm_32.o
 obj-$(CONFIG_APM)		+= apm.o
@@ -100,6 +99,11 @@ scx200-y			+= scx200_32.o
 
 obj-$(CONFIG_OLPC)		+= olpc.o
 
+microcode-y				:= microcode_core.o
+microcode-$(CONFIG_MICROCODE_INTEL)	+= microcode_intel.o
+microcode-$(CONFIG_MICROCODE_AMD)	+= microcode_amd.o
+obj-$(CONFIG_MICROCODE)			+= microcode.o
+
 ###
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e378a16..db08541 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -730,12 +730,24 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 #endif
 }
 
+#ifdef CONFIG_X86_64
+static void vgetcpu_set_mode(void)
+{
+	if (cpu_has(&boot_cpu_data, X86_FEATURE_RDTSCP))
+		vgetcpu_mode = VGETCPU_RDTSCP;
+	else
+		vgetcpu_mode = VGETCPU_LSL;
+}
+#endif
+
 void __init identify_boot_cpu(void)
 {
 	identify_cpu(&boot_cpu_data);
 #ifdef CONFIG_X86_32
 	sysenter_setup();
 	enable_sep_cpu();
+#else
+	vgetcpu_set_mode();
 #endif
 }
 
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index c398b27..201ee35 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -16,45 +16,31 @@
 
 #include <asm/stacktrace.h>
 
+#define STACKSLOTS_PER_LINE 8
+#define get_bp(bp) asm("movl %%ebp, %0" : "=r" (bp) :)
+
 int panic_on_unrecovered_nmi;
-int kstack_depth_to_print = 24;
+int kstack_depth_to_print = 3 * STACKSLOTS_PER_LINE;
 static unsigned int code_bytes = 64;
 static int die_counter;
 
 void printk_address(unsigned long address, int reliable)
 {
-#ifdef CONFIG_KALLSYMS
-	unsigned long offset = 0;
-	unsigned long symsize;
-	const char *symname;
-	char *modname;
-	char *delim = ":";
-	char namebuf[KSYM_NAME_LEN];
-	char reliab[4] = "";
-
-	symname = kallsyms_lookup(address, &symsize, &offset,
-					&modname, namebuf);
-	if (!symname) {
-		printk(" [<%08lx>]\n", address);
-		return;
-	}
-	if (!reliable)
-		strcpy(reliab, "? ");
-
-	if (!modname)
-		modname = delim = "";
-	printk(" [<%08lx>] %s%s%s%s%s+0x%lx/0x%lx\n",
-		address, reliab, delim, modname, delim, symname, offset, symsize);
-#else
-	printk(" [<%08lx>]\n", address);
-#endif
+	printk(" [<%p>] %s%pS\n", (void *) address,
+			reliable ? "" : "? ", (void *) address);
 }
 
 static inline int valid_stack_ptr(struct thread_info *tinfo,
-			void *p, unsigned int size)
+			void *p, unsigned int size, void *end)
 {
 	void *t = tinfo;
-	return	p > t && p <= t + THREAD_SIZE - size;
+	if (end) {
+		if (p < end && p >= (end-THREAD_SIZE))
+			return 1;
+		else
+			return 0;
+	}
+	return p > t && p < t + THREAD_SIZE - size;
 }
 
 /* The form of the top of the frame on the stack */
@@ -66,16 +52,17 @@ struct stack_frame {
 static inline unsigned long
 print_context_stack(struct thread_info *tinfo,
 		unsigned long *stack, unsigned long bp,
-		const struct stacktrace_ops *ops, void *data)
+		const struct stacktrace_ops *ops, void *data,
+		unsigned long *end)
 {
 	struct stack_frame *frame = (struct stack_frame *)bp;
 
-	while (valid_stack_ptr(tinfo, stack, sizeof(*stack))) {
+	while (valid_stack_ptr(tinfo, stack, sizeof(*stack), end)) {
 		unsigned long addr;
 
 		addr = *stack;
 		if (__kernel_text_address(addr)) {
-			if ((unsigned long) stack == bp + 4) {
+			if ((unsigned long) stack == bp + sizeof(long)) {
 				ops->address(data, addr, 1);
 				frame = frame->next_frame;
 				bp = (unsigned long) frame;
@@ -98,7 +85,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	if (!stack) {
 		unsigned long dummy;
 		stack = &dummy;
-		if (task != current)
+		if (task && task != current)
 			stack = (unsigned long *)task->thread.sp;
 	}
 
@@ -106,7 +93,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	if (!bp) {
 		if (task == current) {
 			/* Grab bp right from our regs */
-			asm("movl %%ebp, %0" : "=r" (bp) :);
+			get_bp(bp);
 		} else {
 			/* bp is the last reg pushed by switch_to */
 			bp = *(unsigned long *) task->thread.sp;
@@ -119,17 +106,13 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 
 		context = (struct thread_info *)
 			((unsigned long)stack & (~(THREAD_SIZE - 1)));
-		bp = print_context_stack(context, stack, bp, ops, data);
-		/*
-		 * Should be after the line below, but somewhere
-		 * in early boot context comes out corrupted and we
-		 * can't reference it:
-		 */
-		if (ops->stack(data, "IRQ") < 0)
-			break;
+		bp = print_context_stack(context, stack, bp, ops, data, NULL);
+
 		stack = (unsigned long *)context->previous_esp;
 		if (!stack)
 			break;
+		if (ops->stack(data, "IRQ") < 0)
+			break;
 		touch_nmi_watchdog();
 	}
 }
@@ -150,6 +133,7 @@ static void print_trace_warning(void *data, char *msg)
 
 static int print_trace_stack(void *data, char *name)
 {
+	printk("%s <%s> ", (char *)data, name);
 	return 0;
 }
 
@@ -158,11 +142,9 @@ static int print_trace_stack(void *data, char *name)
  */
 static void print_trace_address(void *data, unsigned long addr, int reliable)
 {
-	printk("%s [<%08lx>] ", (char *)data, addr);
-	if (!reliable)
-		printk("? ");
-	print_symbol("%s\n", addr);
 	touch_nmi_watchdog();
+	printk(data);
+	printk_address(addr, reliable);
 }
 
 static const struct stacktrace_ops print_trace_ops = {
@@ -176,8 +158,8 @@ static void
 show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		unsigned long *stack, unsigned long bp, char *log_lvl)
 {
+	printk("%sCall Trace:\n", log_lvl);
 	dump_trace(task, regs, stack, bp, &print_trace_ops, log_lvl);
-	printk("%s =======================\n", log_lvl);
 }
 
 void show_trace(struct task_struct *task, struct pt_regs *regs,
@@ -188,7 +170,7 @@ void show_trace(struct task_struct *task, struct pt_regs *regs,
 
 static void
 show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
-		   unsigned long *sp, unsigned long bp, char *log_lvl)
+		unsigned long *sp, unsigned long bp, char *log_lvl)
 {
 	unsigned long *stack;
 	int i;
@@ -204,18 +186,17 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 	for (i = 0; i < kstack_depth_to_print; i++) {
 		if (kstack_end(stack))
 			break;
-		if (i && ((i % 8) == 0))
-			printk("\n%s       ", log_lvl);
-		printk("%08lx ", *stack++);
+		if (i && ((i % STACKSLOTS_PER_LINE) == 0))
+			printk("\n%s", log_lvl);
+		printk(" %08lx", *stack++);
+		touch_nmi_watchdog();
 	}
-	printk("\n%sCall Trace:\n", log_lvl);
-
+	printk("\n");
 	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
 }
 
 void show_stack(struct task_struct *task, unsigned long *sp)
 {
-	printk("       ");
 	show_stack_log_lvl(task, NULL, sp, 0, "");
 }
 
@@ -229,7 +210,7 @@ void dump_stack(void)
 
 #ifdef CONFIG_FRAME_POINTER
 	if (!bp)
-		asm("movl %%ebp, %0" : "=r" (bp):);
+		get_bp(bp);
 #endif
 
 	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
@@ -237,8 +218,7 @@ void dump_stack(void)
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
-
-	show_trace(current, NULL, &stack, bp);
+	show_trace(NULL, NULL, &stack, bp);
 }
 
 EXPORT_SYMBOL(dump_stack);
@@ -250,7 +230,7 @@ void show_registers(struct pt_regs *regs)
 	print_modules();
 	__show_regs(regs, 0);
 
-	printk(KERN_EMERG "Process %.*s (pid: %d, ti=%p task=%p task.ti=%p)",
+	printk(KERN_EMERG "Process %.*s (pid: %d, ti=%p task=%p task.ti=%p)\n",
 		TASK_COMM_LEN, current->comm, task_pid_nr(current),
 		current_thread_info(), current, task_thread_info(current));
 	/*
@@ -263,14 +243,15 @@ void show_registers(struct pt_regs *regs)
 		unsigned char c;
 		u8 *ip;
 
-		printk("\n" KERN_EMERG "Stack: ");
-		show_stack_log_lvl(NULL, regs, &regs->sp, 0, KERN_EMERG);
+		printk(KERN_EMERG "Stack:\n");
+		show_stack_log_lvl(NULL, regs, &regs->sp,
+				0, KERN_EMERG);
 
 		printk(KERN_EMERG "Code: ");
 
 		ip = (u8 *)regs->ip - code_prologue;
 		if (ip < (u8 *)PAGE_OFFSET || probe_kernel_address(ip, c)) {
-			/* try starting at EIP */
+			/* try starting at IP */
 			ip = (u8 *)regs->ip;
 			code_len = code_len - code_prologue + 1;
 		}
@@ -338,13 +319,10 @@ void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 
 	if (kexec_should_crash(current))
 		crash_kexec(regs);
-
 	if (in_interrupt())
 		panic("Fatal exception in interrupt");
-
 	if (panic_on_oops)
 		panic("Fatal exception");
-
 	oops_exit();
 	do_exit(signr);
 }
@@ -403,13 +381,60 @@ void die(const char *str, struct pt_regs *regs, long err)
 	oops_end(flags, regs, SIGSEGV);
 }
 
+static DEFINE_SPINLOCK(nmi_print_lock);
+
+void notrace __kprobes
+die_nmi(char *str, struct pt_regs *regs, int do_panic)
+{
+	if (notify_die(DIE_NMIWATCHDOG, str, regs, 0, 2, SIGINT) == NOTIFY_STOP)
+		return;
+
+	spin_lock(&nmi_print_lock);
+	/*
+	* We are in trouble anyway, lets at least try
+	* to get a message out:
+	*/
+	bust_spinlocks(1);
+	printk(KERN_EMERG "%s", str);
+	printk(" on CPU%d, ip %08lx, registers:\n",
+		smp_processor_id(), regs->ip);
+	show_registers(regs);
+	if (do_panic)
+		panic("Non maskable interrupt");
+	console_silent();
+	spin_unlock(&nmi_print_lock);
+	bust_spinlocks(0);
+
+	/*
+	 * If we are in kernel we are probably nested up pretty bad
+	 * and might aswell get out now while we still can:
+	 */
+	if (!user_mode_vm(regs)) {
+		current->thread.trap_no = 2;
+		crash_kexec(regs);
+	}
+
+	do_exit(SIGSEGV);
+}
+
+static int __init oops_setup(char *s)
+{
+	if (!s)
+		return -EINVAL;
+	if (!strcmp(s, "panic"))
+		panic_on_oops = 1;
+	return 0;
+}
+early_param("oops", oops_setup);
+
 static int __init kstack_setup(char *s)
 {
+	if (!s)
+		return -EINVAL;
 	kstack_depth_to_print = simple_strtoul(s, NULL, 0);
-
-	return 1;
+	return 0;
 }
-__setup("kstack=", kstack_setup);
+early_param("kstack", kstack_setup);
 
 static int __init code_bytes_setup(char *s)
 {
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 6f15050..086cc81 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -16,15 +16,18 @@
 
 #include <asm/stacktrace.h>
 
+#define STACKSLOTS_PER_LINE 4
+#define get_bp(bp) asm("movq %%rbp, %0" : "=r" (bp) :)
+
 int panic_on_unrecovered_nmi;
-int kstack_depth_to_print = 12;
+int kstack_depth_to_print = 3 * STACKSLOTS_PER_LINE;
 static unsigned int code_bytes = 64;
 static int die_counter;
 
 void printk_address(unsigned long address, int reliable)
 {
-	printk(" [<%016lx>] %s%pS\n",
-			address, reliable ?	"" : "? ", (void *) address);
+	printk(" [<%p>] %s%pS\n", (void *) address,
+			reliable ? "" : "? ", (void *) address);
 }
 
 static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
@@ -141,7 +144,7 @@ print_context_stack(struct thread_info *tinfo,
 
 		addr = *stack;
 		if (__kernel_text_address(addr)) {
-			if ((unsigned long) stack == bp + 8) {
+			if ((unsigned long) stack == bp + sizeof(long)) {
 				ops->address(data, addr, 1);
 				frame = frame->next_frame;
 				bp = (unsigned long) frame;
@@ -177,7 +180,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	if (!bp) {
 		if (task == current) {
 			/* Grab bp right from our regs */
-			asm("movq %%rbp, %0" : "=r" (bp) : );
+			get_bp(bp);
 		} else {
 			/* bp is the last reg pushed by switch_to */
 			bp = *(unsigned long *) task->thread.sp;
@@ -247,24 +250,29 @@ EXPORT_SYMBOL(dump_trace);
 static void
 print_trace_warning_symbol(void *data, char *msg, unsigned long symbol)
 {
+	printk(data);
 	print_symbol(msg, symbol);
 	printk("\n");
 }
 
 static void print_trace_warning(void *data, char *msg)
 {
-	printk("%s\n", msg);
+	printk("%s%s\n", (char *)data, msg);
 }
 
 static int print_trace_stack(void *data, char *name)
 {
-	printk(" <%s> ", name);
+	printk("%s <%s> ", (char *)data, name);
 	return 0;
 }
 
+/*
+ * Print one address/symbol entries per line.
+ */
 static void print_trace_address(void *data, unsigned long addr, int reliable)
 {
 	touch_nmi_watchdog();
+	printk(data);
 	printk_address(addr, reliable);
 }
 
@@ -279,7 +287,7 @@ static void
 show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		unsigned long *stack, unsigned long bp, char *log_lvl)
 {
-	printk("Call Trace:\n");
+	printk("%sCall Trace:\n", log_lvl);
 	dump_trace(task, regs, stack, bp, &print_trace_ops, log_lvl);
 }
 
@@ -324,8 +332,8 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		if (((long) stack & (THREAD_SIZE-1)) == 0)
 			break;
 		}
-		if (i && ((i % 4) == 0))
-			printk("\n");
+		if (i && ((i % STACKSLOTS_PER_LINE) == 0))
+			printk("\n%s", log_lvl);
 		printk(" %016lx", *stack++);
 		touch_nmi_watchdog();
 	}
@@ -348,7 +356,7 @@ void dump_stack(void)
 
 #ifdef CONFIG_FRAME_POINTER
 	if (!bp)
-		asm("movq %%rbp, %0" : "=r" (bp) : );
+		get_bp(bp);
 #endif
 
 	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
@@ -383,15 +391,15 @@ void show_registers(struct pt_regs *regs)
 		unsigned char c;
 		u8 *ip;
 
-		printk("Stack: ");
+		printk(KERN_EMERG "Stack:\n");
 		show_stack_log_lvl(NULL, regs, (unsigned long *)sp,
-				regs->bp, "");
+				regs->bp, KERN_EMERG);
 
 		printk(KERN_EMERG "Code: ");
 
 		ip = (u8 *)regs->ip - code_prologue;
 		if (ip < (u8 *)PAGE_OFFSET || probe_kernel_address(ip, c)) {
-			/* try starting at RIP */
+			/* try starting at IP */
 			ip = (u8 *)regs->ip;
 			code_len = code_len - code_prologue + 1;
 		}
@@ -470,7 +478,7 @@ void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 
 int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 {
-	printk(KERN_EMERG "%s: %04lx [%u] ", str, err & 0xffff, ++die_counter);
+	printk(KERN_EMERG "%s: %04lx [#%d] ", str, err & 0xffff, ++die_counter);
 #ifdef CONFIG_PREEMPT
 	printk("PREEMPT ");
 #endif
diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index ff9e735..02fc5b4 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -3,11 +3,19 @@
 #include <linux/init.h>
 #include <linux/string.h>
 #include <linux/screen_info.h>
+#include <linux/usb/ch9.h>
+#include <linux/pci_regs.h>
+#include <linux/pci_ids.h>
+#include <linux/errno.h>
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/fcntl.h>
 #include <asm/setup.h>
 #include <xen/hvc-console.h>
+#include <asm/pci-direct.h>
+#include <asm/pgtable.h>
+#include <asm/fixmap.h>
+#include <linux/usb/ehci_def.h>
 
 /* Simple VGA output */
 #define VGABASE		(__ISA_IO_base + 0xb8000)
@@ -78,6 +86,7 @@ static int early_serial_base = 0x3f8;  /* ttyS0 */
 static int early_serial_putc(unsigned char ch)
 {
 	unsigned timeout = 0xffff;
+
 	while ((inb(early_serial_base + LSR) & XMTRDY) == 0 && --timeout)
 		cpu_relax();
 	outb(ch, early_serial_base + TXR);
@@ -111,7 +120,7 @@ static __init void early_serial_init(char *s)
 		if (!strncmp(s, "0x", 2)) {
 			early_serial_base = simple_strtoul(s, &e, 16);
 		} else {
-			static int bases[] = { 0x3f8, 0x2f8 };
+			static const int __initconst bases[] = { 0x3f8, 0x2f8 };
 
 			if (!strncmp(s, "ttyS", 4))
 				s += 4;
@@ -151,6 +160,721 @@ static struct console early_serial_console = {
 	.index =	-1,
 };
 
+#ifdef CONFIG_EARLY_PRINTK_DBGP
+
+static struct ehci_caps __iomem *ehci_caps;
+static struct ehci_regs __iomem *ehci_regs;
+static struct ehci_dbg_port __iomem *ehci_debug;
+static unsigned int dbgp_endpoint_out;
+
+struct ehci_dev {
+	u32 bus;
+	u32 slot;
+	u32 func;
+};
+
+static struct ehci_dev ehci_dev;
+
+#define USB_DEBUG_DEVNUM 127
+
+#define DBGP_DATA_TOGGLE	0x8800
+
+static inline u32 dbgp_pid_update(u32 x, u32 tok)
+{
+	return ((x ^ DBGP_DATA_TOGGLE) & 0xffff00) | (tok & 0xff);
+}
+
+static inline u32 dbgp_len_update(u32 x, u32 len)
+{
+	return (x & ~0x0f) | (len & 0x0f);
+}
+
+/*
+ * USB Packet IDs (PIDs)
+ */
+
+/* token */
+#define USB_PID_OUT		0xe1
+#define USB_PID_IN		0x69
+#define USB_PID_SOF		0xa5
+#define USB_PID_SETUP		0x2d
+/* handshake */
+#define USB_PID_ACK		0xd2
+#define USB_PID_NAK		0x5a
+#define USB_PID_STALL		0x1e
+#define USB_PID_NYET		0x96
+/* data */
+#define USB_PID_DATA0		0xc3
+#define USB_PID_DATA1		0x4b
+#define USB_PID_DATA2		0x87
+#define USB_PID_MDATA		0x0f
+/* Special */
+#define USB_PID_PREAMBLE	0x3c
+#define USB_PID_ERR		0x3c
+#define USB_PID_SPLIT		0x78
+#define USB_PID_PING		0xb4
+#define USB_PID_UNDEF_0		0xf0
+
+#define USB_PID_DATA_TOGGLE	0x88
+#define DBGP_CLAIM (DBGP_OWNER | DBGP_ENABLED | DBGP_INUSE)
+
+#define PCI_CAP_ID_EHCI_DEBUG	0xa
+
+#define HUB_ROOT_RESET_TIME	50	/* times are in msec */
+#define HUB_SHORT_RESET_TIME	10
+#define HUB_LONG_RESET_TIME	200
+#define HUB_RESET_TIMEOUT	500
+
+#define DBGP_MAX_PACKET		8
+
+static int dbgp_wait_until_complete(void)
+{
+	u32 ctrl;
+	int loop = 0x100000;
+
+	do {
+		ctrl = readl(&ehci_debug->control);
+		/* Stop when the transaction is finished */
+		if (ctrl & DBGP_DONE)
+			break;
+	} while (--loop > 0);
+
+	if (!loop)
+		return -1;
+
+	/*
+	 * Now that we have observed the completed transaction,
+	 * clear the done bit.
+	 */
+	writel(ctrl | DBGP_DONE, &ehci_debug->control);
+	return (ctrl & DBGP_ERROR) ? -DBGP_ERRCODE(ctrl) : DBGP_LEN(ctrl);
+}
+
+static void dbgp_mdelay(int ms)
+{
+	int i;
+
+	while (ms--) {
+		for (i = 0; i < 1000; i++)
+			outb(0x1, 0x80);
+	}
+}
+
+static void dbgp_breath(void)
+{
+	/* Sleep to give the debug port a chance to breathe */
+}
+
+static int dbgp_wait_until_done(unsigned ctrl)
+{
+	u32 pids, lpid;
+	int ret;
+	int loop = 3;
+
+retry:
+	writel(ctrl | DBGP_GO, &ehci_debug->control);
+	ret = dbgp_wait_until_complete();
+	pids = readl(&ehci_debug->pids);
+	lpid = DBGP_PID_GET(pids);
+
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * If the port is getting full or it has dropped data
+	 * start pacing ourselves, not necessary but it's friendly.
+	 */
+	if ((lpid == USB_PID_NAK) || (lpid == USB_PID_NYET))
+		dbgp_breath();
+
+	/* If I get a NACK reissue the transmission */
+	if (lpid == USB_PID_NAK) {
+		if (--loop > 0)
+			goto retry;
+	}
+
+	return ret;
+}
+
+static void dbgp_set_data(const void *buf, int size)
+{
+	const unsigned char *bytes = buf;
+	u32 lo, hi;
+	int i;
+
+	lo = hi = 0;
+	for (i = 0; i < 4 && i < size; i++)
+		lo |= bytes[i] << (8*i);
+	for (; i < 8 && i < size; i++)
+		hi |= bytes[i] << (8*(i - 4));
+	writel(lo, &ehci_debug->data03);
+	writel(hi, &ehci_debug->data47);
+}
+
+static void dbgp_get_data(void *buf, int size)
+{
+	unsigned char *bytes = buf;
+	u32 lo, hi;
+	int i;
+
+	lo = readl(&ehci_debug->data03);
+	hi = readl(&ehci_debug->data47);
+	for (i = 0; i < 4 && i < size; i++)
+		bytes[i] = (lo >> (8*i)) & 0xff;
+	for (; i < 8 && i < size; i++)
+		bytes[i] = (hi >> (8*(i - 4))) & 0xff;
+}
+
+static int dbgp_bulk_write(unsigned devnum, unsigned endpoint,
+			 const char *bytes, int size)
+{
+	u32 pids, addr, ctrl;
+	int ret;
+
+	if (size > DBGP_MAX_PACKET)
+		return -1;
+
+	addr = DBGP_EPADDR(devnum, endpoint);
+
+	pids = readl(&ehci_debug->pids);
+	pids = dbgp_pid_update(pids, USB_PID_OUT);
+
+	ctrl = readl(&ehci_debug->control);
+	ctrl = dbgp_len_update(ctrl, size);
+	ctrl |= DBGP_OUT;
+	ctrl |= DBGP_GO;
+
+	dbgp_set_data(bytes, size);
+	writel(addr, &ehci_debug->address);
+	writel(pids, &ehci_debug->pids);
+
+	ret = dbgp_wait_until_done(ctrl);
+	if (ret < 0)
+		return ret;
+
+	return ret;
+}
+
+static int dbgp_bulk_read(unsigned devnum, unsigned endpoint, void *data,
+				 int size)
+{
+	u32 pids, addr, ctrl;
+	int ret;
+
+	if (size > DBGP_MAX_PACKET)
+		return -1;
+
+	addr = DBGP_EPADDR(devnum, endpoint);
+
+	pids = readl(&ehci_debug->pids);
+	pids = dbgp_pid_update(pids, USB_PID_IN);
+
+	ctrl = readl(&ehci_debug->control);
+	ctrl = dbgp_len_update(ctrl, size);
+	ctrl &= ~DBGP_OUT;
+	ctrl |= DBGP_GO;
+
+	writel(addr, &ehci_debug->address);
+	writel(pids, &ehci_debug->pids);
+	ret = dbgp_wait_until_done(ctrl);
+	if (ret < 0)
+		return ret;
+
+	if (size > ret)
+		size = ret;
+	dbgp_get_data(data, size);
+	return ret;
+}
+
+static int dbgp_control_msg(unsigned devnum, int requesttype, int request,
+	int value, int index, void *data, int size)
+{
+	u32 pids, addr, ctrl;
+	struct usb_ctrlrequest req;
+	int read;
+	int ret;
+
+	read = (requesttype & USB_DIR_IN) != 0;
+	if (size > (read ? DBGP_MAX_PACKET:0))
+		return -1;
+
+	/* Compute the control message */
+	req.bRequestType = requesttype;
+	req.bRequest = request;
+	req.wValue = cpu_to_le16(value);
+	req.wIndex = cpu_to_le16(index);
+	req.wLength = cpu_to_le16(size);
+
+	pids = DBGP_PID_SET(USB_PID_DATA0, USB_PID_SETUP);
+	addr = DBGP_EPADDR(devnum, 0);
+
+	ctrl = readl(&ehci_debug->control);
+	ctrl = dbgp_len_update(ctrl, sizeof(req));
+	ctrl |= DBGP_OUT;
+	ctrl |= DBGP_GO;
+
+	/* Send the setup message */
+	dbgp_set_data(&req, sizeof(req));
+	writel(addr, &ehci_debug->address);
+	writel(pids, &ehci_debug->pids);
+	ret = dbgp_wait_until_done(ctrl);
+	if (ret < 0)
+		return ret;
+
+	/* Read the result */
+	return dbgp_bulk_read(devnum, 0, data, size);
+}
+
+
+/* Find a PCI capability */
+static u32 __init find_cap(u32 num, u32 slot, u32 func, int cap)
+{
+	u8 pos;
+	int bytes;
+
+	if (!(read_pci_config_16(num, slot, func, PCI_STATUS) &
+		PCI_STATUS_CAP_LIST))
+		return 0;
+
+	pos = read_pci_config_byte(num, slot, func, PCI_CAPABILITY_LIST);
+	for (bytes = 0; bytes < 48 && pos >= 0x40; bytes++) {
+		u8 id;
+
+		pos &= ~3;
+		id = read_pci_config_byte(num, slot, func, pos+PCI_CAP_LIST_ID);
+		if (id == 0xff)
+			break;
+		if (id == cap)
+			return pos;
+
+		pos = read_pci_config_byte(num, slot, func,
+						 pos+PCI_CAP_LIST_NEXT);
+	}
+	return 0;
+}
+
+static u32 __init __find_dbgp(u32 bus, u32 slot, u32 func)
+{
+	u32 class;
+
+	class = read_pci_config(bus, slot, func, PCI_CLASS_REVISION);
+	if ((class >> 8) != PCI_CLASS_SERIAL_USB_EHCI)
+		return 0;
+
+	return find_cap(bus, slot, func, PCI_CAP_ID_EHCI_DEBUG);
+}
+
+static u32 __init find_dbgp(int ehci_num, u32 *rbus, u32 *rslot, u32 *rfunc)
+{
+	u32 bus, slot, func;
+
+	for (bus = 0; bus < 256; bus++) {
+		for (slot = 0; slot < 32; slot++) {
+			for (func = 0; func < 8; func++) {
+				unsigned cap;
+
+				cap = __find_dbgp(bus, slot, func);
+
+				if (!cap)
+					continue;
+				if (ehci_num-- != 0)
+					continue;
+				*rbus = bus;
+				*rslot = slot;
+				*rfunc = func;
+				return cap;
+			}
+		}
+	}
+	return 0;
+}
+
+static int ehci_reset_port(int port)
+{
+	u32 portsc;
+	u32 delay_time, delay;
+	int loop;
+
+	/* Reset the usb debug port */
+	portsc = readl(&ehci_regs->port_status[port - 1]);
+	portsc &= ~PORT_PE;
+	portsc |= PORT_RESET;
+	writel(portsc, &ehci_regs->port_status[port - 1]);
+
+	delay = HUB_ROOT_RESET_TIME;
+	for (delay_time = 0; delay_time < HUB_RESET_TIMEOUT;
+	     delay_time += delay) {
+		dbgp_mdelay(delay);
+
+		portsc = readl(&ehci_regs->port_status[port - 1]);
+		if (portsc & PORT_RESET) {
+			/* force reset to complete */
+			loop = 2;
+			writel(portsc & ~(PORT_RWC_BITS | PORT_RESET),
+				&ehci_regs->port_status[port - 1]);
+			do {
+				portsc = readl(&ehci_regs->port_status[port-1]);
+			} while ((portsc & PORT_RESET) && (--loop > 0));
+		}
+
+		/* Device went away? */
+		if (!(portsc & PORT_CONNECT))
+			return -ENOTCONN;
+
+		/* bomb out completely if something weird happend */
+		if ((portsc & PORT_CSC))
+			return -EINVAL;
+
+		/* If we've finished resetting, then break out of the loop */
+		if (!(portsc & PORT_RESET) && (portsc & PORT_PE))
+			return 0;
+	}
+	return -EBUSY;
+}
+
+static int ehci_wait_for_port(int port)
+{
+	u32 status;
+	int ret, reps;
+
+	for (reps = 0; reps < 3; reps++) {
+		dbgp_mdelay(100);
+		status = readl(&ehci_regs->status);
+		if (status & STS_PCD) {
+			ret = ehci_reset_port(port);
+			if (ret == 0)
+				return 0;
+		}
+	}
+	return -ENOTCONN;
+}
+
+#ifdef DBGP_DEBUG
+# define dbgp_printk early_printk
+#else
+static inline void dbgp_printk(const char *fmt, ...) { }
+#endif
+
+typedef void (*set_debug_port_t)(int port);
+
+static void default_set_debug_port(int port)
+{
+}
+
+static set_debug_port_t set_debug_port = default_set_debug_port;
+
+static void nvidia_set_debug_port(int port)
+{
+	u32 dword;
+	dword = read_pci_config(ehci_dev.bus, ehci_dev.slot, ehci_dev.func,
+				 0x74);
+	dword &= ~(0x0f<<12);
+	dword |= ((port & 0x0f)<<12);
+	write_pci_config(ehci_dev.bus, ehci_dev.slot, ehci_dev.func, 0x74,
+				 dword);
+	dbgp_printk("set debug port to %d\n", port);
+}
+
+static void __init detect_set_debug_port(void)
+{
+	u32 vendorid;
+
+	vendorid = read_pci_config(ehci_dev.bus, ehci_dev.slot, ehci_dev.func,
+		 0x00);
+
+	if ((vendorid & 0xffff) == 0x10de) {
+		dbgp_printk("using nvidia set_debug_port\n");
+		set_debug_port = nvidia_set_debug_port;
+	}
+}
+
+static int __init ehci_setup(void)
+{
+	struct usb_debug_descriptor dbgp_desc;
+	u32 cmd, ctrl, status, portsc, hcs_params;
+	u32 debug_port, new_debug_port = 0, n_ports;
+	u32  devnum;
+	int ret, i;
+	int loop;
+	int port_map_tried;
+	int playtimes = 3;
+
+try_next_time:
+	port_map_tried = 0;
+
+try_next_port:
+
+	hcs_params = readl(&ehci_caps->hcs_params);
+	debug_port = HCS_DEBUG_PORT(hcs_params);
+	n_ports    = HCS_N_PORTS(hcs_params);
+
+	dbgp_printk("debug_port: %d\n", debug_port);
+	dbgp_printk("n_ports:    %d\n", n_ports);
+
+	for (i = 1; i <= n_ports; i++) {
+		portsc = readl(&ehci_regs->port_status[i-1]);
+		dbgp_printk("portstatus%d: %08x\n", i, portsc);
+	}
+
+	if (port_map_tried && (new_debug_port != debug_port)) {
+		if (--playtimes) {
+			set_debug_port(new_debug_port);
+			goto try_next_time;
+		}
+		return -1;
+	}
+
+	loop = 10;
+	/* Reset the EHCI controller */
+	cmd = readl(&ehci_regs->command);
+	cmd |= CMD_RESET;
+	writel(cmd, &ehci_regs->command);
+	do {
+		cmd = readl(&ehci_regs->command);
+	} while ((cmd & CMD_RESET) && (--loop > 0));
+
+	if (!loop) {
+		dbgp_printk("can not reset ehci\n");
+		return -1;
+	}
+	dbgp_printk("ehci reset done\n");
+
+	/* Claim ownership, but do not enable yet */
+	ctrl = readl(&ehci_debug->control);
+	ctrl |= DBGP_OWNER;
+	ctrl &= ~(DBGP_ENABLED | DBGP_INUSE);
+	writel(ctrl, &ehci_debug->control);
+
+	/* Start the ehci running */
+	cmd = readl(&ehci_regs->command);
+	cmd &= ~(CMD_LRESET | CMD_IAAD | CMD_PSE | CMD_ASE | CMD_RESET);
+	cmd |= CMD_RUN;
+	writel(cmd, &ehci_regs->command);
+
+	/* Ensure everything is routed to the EHCI */
+	writel(FLAG_CF, &ehci_regs->configured_flag);
+
+	/* Wait until the controller is no longer halted */
+	loop = 10;
+	do {
+		status = readl(&ehci_regs->status);
+	} while ((status & STS_HALT) && (--loop > 0));
+
+	if (!loop) {
+		dbgp_printk("ehci can be started\n");
+		return -1;
+	}
+	dbgp_printk("ehci started\n");
+
+	/* Wait for a device to show up in the debug port */
+	ret = ehci_wait_for_port(debug_port);
+	if (ret < 0) {
+		dbgp_printk("No device found in debug port\n");
+		goto next_debug_port;
+	}
+	dbgp_printk("ehci wait for port done\n");
+
+	/* Enable the debug port */
+	ctrl = readl(&ehci_debug->control);
+	ctrl |= DBGP_CLAIM;
+	writel(ctrl, &ehci_debug->control);
+	ctrl = readl(&ehci_debug->control);
+	if ((ctrl & DBGP_CLAIM) != DBGP_CLAIM) {
+		dbgp_printk("No device in debug port\n");
+		writel(ctrl & ~DBGP_CLAIM, &ehci_debug->control);
+		goto err;
+	}
+	dbgp_printk("debug ported enabled\n");
+
+	/* Completely transfer the debug device to the debug controller */
+	portsc = readl(&ehci_regs->port_status[debug_port - 1]);
+	portsc &= ~PORT_PE;
+	writel(portsc, &ehci_regs->port_status[debug_port - 1]);
+
+	dbgp_mdelay(100);
+
+	/* Find the debug device and make it device number 127 */
+	for (devnum = 0; devnum <= 127; devnum++) {
+		ret = dbgp_control_msg(devnum,
+			USB_DIR_IN | USB_TYPE_STANDARD | USB_RECIP_DEVICE,
+			USB_REQ_GET_DESCRIPTOR, (USB_DT_DEBUG << 8), 0,
+			&dbgp_desc, sizeof(dbgp_desc));
+		if (ret > 0)
+			break;
+	}
+	if (devnum > 127) {
+		dbgp_printk("Could not find attached debug device\n");
+		goto err;
+	}
+	if (ret < 0) {
+		dbgp_printk("Attached device is not a debug device\n");
+		goto err;
+	}
+	dbgp_endpoint_out = dbgp_desc.bDebugOutEndpoint;
+
+	/* Move the device to 127 if it isn't already there */
+	if (devnum != USB_DEBUG_DEVNUM) {
+		ret = dbgp_control_msg(devnum,
+			USB_DIR_OUT | USB_TYPE_STANDARD | USB_RECIP_DEVICE,
+			USB_REQ_SET_ADDRESS, USB_DEBUG_DEVNUM, 0, NULL, 0);
+		if (ret < 0) {
+			dbgp_printk("Could not move attached device to %d\n",
+				USB_DEBUG_DEVNUM);
+			goto err;
+		}
+		devnum = USB_DEBUG_DEVNUM;
+		dbgp_printk("debug device renamed to 127\n");
+	}
+
+	/* Enable the debug interface */
+	ret = dbgp_control_msg(USB_DEBUG_DEVNUM,
+		USB_DIR_OUT | USB_TYPE_STANDARD | USB_RECIP_DEVICE,
+		USB_REQ_SET_FEATURE, USB_DEVICE_DEBUG_MODE, 0, NULL, 0);
+	if (ret < 0) {
+		dbgp_printk(" Could not enable the debug device\n");
+		goto err;
+	}
+	dbgp_printk("debug interface enabled\n");
+
+	/* Perform a small write to get the even/odd data state in sync
+	 */
+	ret = dbgp_bulk_write(USB_DEBUG_DEVNUM, dbgp_endpoint_out, " ", 1);
+	if (ret < 0) {
+		dbgp_printk("dbgp_bulk_write failed: %d\n", ret);
+		goto err;
+	}
+	dbgp_printk("small write doned\n");
+
+	return 0;
+err:
+	/* Things didn't work so remove my claim */
+	ctrl = readl(&ehci_debug->control);
+	ctrl &= ~(DBGP_CLAIM | DBGP_OUT);
+	writel(ctrl, &ehci_debug->control);
+	return -1;
+
+next_debug_port:
+	port_map_tried |= (1<<(debug_port - 1));
+	new_debug_port = ((debug_port-1+1)%n_ports) + 1;
+	if (port_map_tried != ((1<<n_ports) - 1)) {
+		set_debug_port(new_debug_port);
+		goto try_next_port;
+	}
+	if (--playtimes) {
+		set_debug_port(new_debug_port);
+		goto try_next_time;
+	}
+
+	return -1;
+}
+
+static int __init early_dbgp_init(char *s)
+{
+	u32 debug_port, bar, offset;
+	u32 bus, slot, func, cap;
+	void __iomem *ehci_bar;
+	u32 dbgp_num;
+	u32 bar_val;
+	char *e;
+	int ret;
+	u8 byte;
+
+	if (!early_pci_allowed())
+		return -1;
+
+	dbgp_num = 0;
+	if (*s)
+		dbgp_num = simple_strtoul(s, &e, 10);
+	dbgp_printk("dbgp_num: %d\n", dbgp_num);
+
+	cap = find_dbgp(dbgp_num, &bus, &slot, &func);
+	if (!cap)
+		return -1;
+
+	dbgp_printk("Found EHCI debug port on %02x:%02x.%1x\n", bus, slot,
+			 func);
+
+	debug_port = read_pci_config(bus, slot, func, cap);
+	bar = (debug_port >> 29) & 0x7;
+	bar = (bar * 4) + 0xc;
+	offset = (debug_port >> 16) & 0xfff;
+	dbgp_printk("bar: %02x offset: %03x\n", bar, offset);
+	if (bar != PCI_BASE_ADDRESS_0) {
+		dbgp_printk("only debug ports on bar 1 handled.\n");
+
+		return -1;
+	}
+
+	bar_val = read_pci_config(bus, slot, func, PCI_BASE_ADDRESS_0);
+	dbgp_printk("bar_val: %02x offset: %03x\n", bar_val, offset);
+	if (bar_val & ~PCI_BASE_ADDRESS_MEM_MASK) {
+		dbgp_printk("only simple 32bit mmio bars supported\n");
+
+		return -1;
+	}
+
+	/* double check if the mem space is enabled */
+	byte = read_pci_config_byte(bus, slot, func, 0x04);
+	if (!(byte & 0x2)) {
+		byte  |= 0x02;
+		write_pci_config_byte(bus, slot, func, 0x04, byte);
+		dbgp_printk("mmio for ehci enabled\n");
+	}
+
+	/*
+	 * FIXME I don't have the bar size so just guess PAGE_SIZE is more
+	 * than enough.  1K is the biggest I have seen.
+	 */
+	set_fixmap_nocache(FIX_DBGP_BASE, bar_val & PAGE_MASK);
+	ehci_bar = (void __iomem *)__fix_to_virt(FIX_DBGP_BASE);
+	ehci_bar += bar_val & ~PAGE_MASK;
+	dbgp_printk("ehci_bar: %p\n", ehci_bar);
+
+	ehci_caps  = ehci_bar;
+	ehci_regs  = ehci_bar + HC_LENGTH(readl(&ehci_caps->hc_capbase));
+	ehci_debug = ehci_bar + offset;
+	ehci_dev.bus = bus;
+	ehci_dev.slot = slot;
+	ehci_dev.func = func;
+
+	detect_set_debug_port();
+
+	ret = ehci_setup();
+	if (ret < 0) {
+		dbgp_printk("ehci_setup failed\n");
+		ehci_debug = NULL;
+
+		return -1;
+	}
+
+	return 0;
+}
+
+static void early_dbgp_write(struct console *con, const char *str, u32 n)
+{
+	int chunk, ret;
+
+	if (!ehci_debug)
+		return;
+	while (n > 0) {
+		chunk = n;
+		if (chunk > DBGP_MAX_PACKET)
+			chunk = DBGP_MAX_PACKET;
+		ret = dbgp_bulk_write(USB_DEBUG_DEVNUM,
+			dbgp_endpoint_out, str, chunk);
+		str += chunk;
+		n -= chunk;
+	}
+}
+
+static struct console early_dbgp_console = {
+	.name =		"earlydbg",
+	.write =	early_dbgp_write,
+	.flags =	CON_PRINTBUFFER,
+	.index =	-1,
+};
+#endif
+
 /* Console interface to a host file on AMD's SimNow! */
 
 static int simnow_fd;
@@ -165,6 +889,7 @@ enum {
 static noinline long simnow(long cmd, long a, long b, long c)
 {
 	long ret;
+
 	asm volatile("cpuid" :
 		     "=a" (ret) :
 		     "b" (a), "c" (b), "d" (c), "0" (MAGIC1), "D" (cmd + MAGIC2));
@@ -174,6 +899,7 @@ static noinline long simnow(long cmd, long a, long b, long c)
 static void __init simnow_init(char *str)
 {
 	char *fn = "klog";
+
 	if (*str == '=')
 		fn = ++str;
 	/* error ignored */
@@ -194,7 +920,7 @@ static struct console simnow_console = {
 
 /* Direct interface for emergencies */
 static struct console *early_console = &early_vga_console;
-static int early_console_initialized;
+static int __initdata early_console_initialized;
 
 asmlinkage void early_printk(const char *fmt, ...)
 {
@@ -208,10 +934,11 @@ asmlinkage void early_printk(const char *fmt, ...)
 	va_end(ap);
 }
 
-static int __initdata keep_early;
 
 static int __init setup_early_printk(char *buf)
 {
+	int keep_early;
+
 	if (!buf)
 		return 0;
 
@@ -219,8 +946,7 @@ static int __init setup_early_printk(char *buf)
 		return 0;
 	early_console_initialized = 1;
 
-	if (strstr(buf, "keep"))
-		keep_early = 1;
+	keep_early = (strstr(buf, "keep") != NULL);
 
 	if (!strncmp(buf, "serial", 6)) {
 		early_serial_init(buf + 6);
@@ -238,6 +964,17 @@ static int __init setup_early_printk(char *buf)
 		simnow_init(buf + 6);
 		early_console = &simnow_console;
 		keep_early = 1;
+#ifdef CONFIG_EARLY_PRINTK_DBGP
+	} else if (!strncmp(buf, "dbgp", 4)) {
+		if (early_dbgp_init(buf+4) < 0)
+			return 0;
+		early_console = &early_dbgp_console;
+		/*
+		 * usb subsys will reset ehci controller, so don't keep
+		 * that early console
+		 */
+		keep_early = 0;
+#endif
 #ifdef CONFIG_HVC_XEN
 	} else if (!strncmp(buf, "xen", 3)) {
 		early_console = &xenboot_console;
@@ -251,4 +988,23 @@ static int __init setup_early_printk(char *buf)
 	register_console(early_console);
 	return 0;
 }
+
+static void __init enable_debug_console(char *buf)
+{
+#ifdef DBGP_DEBUG
+	struct console *old_early_console = NULL;
+
+	if (early_console_initialized && early_console) {
+		old_early_console = early_console;
+		unregister_console(early_console);
+		early_console_initialized = 0;
+	}
+
+	setup_early_printk(buf);
+
+	if (early_console == old_early_console && old_early_console)
+		register_console(old_early_console);
+#endif
+}
+
 early_param("earlyprintk", setup_early_printk);
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 104fa65..1db6ce4 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -667,6 +667,13 @@ END(stub_rt_sigreturn)
 	SAVE_ARGS
 	leaq -ARGOFFSET(%rsp),%rdi	# arg1 for handler
 	pushq %rbp
+	/*
+	 * Save rbp twice: One is for marking the stack frame, as usual, and the
+	 * other, to fill pt_regs properly. This is because bx comes right
+	 * before the last saved register in that structure, and not bp. If the
+	 * base pointer were in the place bx is today, this would not be needed.
+	 */
+	movq %rbp, -8(%rsp)
 	CFI_ADJUST_CFA_OFFSET	8
 	CFI_REL_OFFSET		rbp, 0
 	movq %rsp,%rbp
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index 2f4d009..d17fbc2 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -135,7 +135,7 @@ DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
 	[IRQ15_VECTOR + 1 ... NR_VECTORS - 1] = -1
 };
 
-static void __init init_ISA_irqs (void)
+void __init init_ISA_irqs(void)
 {
 	int i;
 
@@ -160,22 +160,8 @@ static void __init init_ISA_irqs (void)
 
 void init_IRQ(void) __attribute__((weak, alias("native_init_IRQ")));
 
-void __init native_init_IRQ(void)
+static void __init smp_intr_init(void)
 {
-	int i;
-
-	init_ISA_irqs();
-	/*
-	 * Cover the whole vector space, no vector can escape
-	 * us. (some of these will be overridden and become
-	 * 'special' SMP interrupts)
-	 */
-	for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
-		int vector = FIRST_EXTERNAL_VECTOR + i;
-		if (vector != IA32_SYSCALL_VECTOR)
-			set_intr_gate(vector, interrupt[i]);
-	}
-
 #ifdef CONFIG_SMP
 	/*
 	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
@@ -203,6 +189,12 @@ void __init native_init_IRQ(void)
 	/* Low priority IPI to cleanup after moving an irq */
 	set_intr_gate(IRQ_MOVE_CLEANUP_VECTOR, irq_move_cleanup_interrupt);
 #endif
+}
+
+static void __init apic_intr_init(void)
+{
+	smp_intr_init();
+
 	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
 	alloc_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
 
@@ -212,6 +204,25 @@ void __init native_init_IRQ(void)
 	/* IPI vectors for APIC spurious and error interrupts */
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
+}
+
+void __init native_init_IRQ(void)
+{
+	int i;
+
+	init_ISA_irqs();
+	/*
+	 * Cover the whole vector space, no vector can escape
+	 * us. (some of these will be overridden and become
+	 * 'special' SMP interrupts)
+	 */
+	for (i = 0; i < (NR_VECTORS - FIRST_EXTERNAL_VECTOR); i++) {
+		int vector = FIRST_EXTERNAL_VECTOR + i;
+		if (vector != IA32_SYSCALL_VECTOR)
+			set_intr_gate(vector, interrupt[i]);
+	}
+
+	apic_intr_init();
 
 	if (!acpi_ioapic)
 		setup_irq(2, &irq2);
diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
deleted file mode 100644
index 652fa5c..0000000
--- a/arch/x86/kernel/microcode.c
+++ /dev/null
@@ -1,853 +0,0 @@
-/*
- *	Intel CPU Microcode Update Driver for Linux
- *
- *	Copyright (C) 2000-2006 Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
- *		      2006	Shaohua Li <shaohua.li@intel.com>
- *
- *	This driver allows to upgrade microcode on Intel processors
- *	belonging to IA-32 family - PentiumPro, Pentium II,
- *	Pentium III, Xeon, Pentium 4, etc.
- *
- *	Reference: Section 8.11 of Volume 3a, IA-32 Intel? Architecture
- *	Software Developer's Manual
- *	Order Number 253668 or free download from:
- *
- *	http://developer.intel.com/design/pentium4/manuals/253668.htm
- *
- *	For more information, go to http://www.urbanmyth.org/microcode
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License
- *	as published by the Free Software Foundation; either version
- *	2 of the License, or (at your option) any later version.
- *
- *	1.0	16 Feb 2000, Tigran Aivazian <tigran@sco.com>
- *		Initial release.
- *	1.01	18 Feb 2000, Tigran Aivazian <tigran@sco.com>
- *		Added read() support + cleanups.
- *	1.02	21 Feb 2000, Tigran Aivazian <tigran@sco.com>
- *		Added 'device trimming' support. open(O_WRONLY) zeroes
- *		and frees the saved copy of applied microcode.
- *	1.03	29 Feb 2000, Tigran Aivazian <tigran@sco.com>
- *		Made to use devfs (/dev/cpu/microcode) + cleanups.
- *	1.04	06 Jun 2000, Simon Trimmer <simon@veritas.com>
- *		Added misc device support (now uses both devfs and misc).
- *		Added MICROCODE_IOCFREE ioctl to clear memory.
- *	1.05	09 Jun 2000, Simon Trimmer <simon@veritas.com>
- *		Messages for error cases (non Intel & no suitable microcode).
- *	1.06	03 Aug 2000, Tigran Aivazian <tigran@veritas.com>
- *		Removed ->release(). Removed exclusive open and status bitmap.
- *		Added microcode_rwsem to serialize read()/write()/ioctl().
- *		Removed global kernel lock usage.
- *	1.07	07 Sep 2000, Tigran Aivazian <tigran@veritas.com>
- *		Write 0 to 0x8B msr and then cpuid before reading revision,
- *		so that it works even if there were no update done by the
- *		BIOS. Otherwise, reading from 0x8B gives junk (which happened
- *		to be 0 on my machine which is why it worked even when I
- *		disabled update by the BIOS)
- *		Thanks to Eric W. Biederman <ebiederman@lnxi.com> for the fix.
- *	1.08	11 Dec 2000, Richard Schaal <richard.schaal@intel.com> and
- *			     Tigran Aivazian <tigran@veritas.com>
- *		Intel Pentium 4 processor support and bugfixes.
- *	1.09	30 Oct 2001, Tigran Aivazian <tigran@veritas.com>
- *		Bugfix for HT (Hyper-Threading) enabled processors
- *		whereby processor resources are shared by all logical processors
- *		in a single CPU package.
- *	1.10	28 Feb 2002 Asit K Mallick <asit.k.mallick@intel.com> and
- *		Tigran Aivazian <tigran@veritas.com>,
- *		Serialize updates as required on HT processors due to speculative
- *		nature of implementation.
- *	1.11	22 Mar 2002 Tigran Aivazian <tigran@veritas.com>
- *		Fix the panic when writing zero-length microcode chunk.
- *	1.12	29 Sep 2003 Nitin Kamble <nitin.a.kamble@intel.com>,
- *		Jun Nakajima <jun.nakajima@intel.com>
- *		Support for the microcode updates in the new format.
- *	1.13	10 Oct 2003 Tigran Aivazian <tigran@veritas.com>
- *		Removed ->read() method and obsoleted MICROCODE_IOCFREE ioctl
- *		because we no longer hold a copy of applied microcode
- *		in kernel memory.
- *	1.14	25 Jun 2004 Tigran Aivazian <tigran@veritas.com>
- *		Fix sigmatch() macro to handle old CPUs with pf == 0.
- *		Thanks to Stuart Swales for pointing out this bug.
- */
-
-//#define DEBUG /* pr_debug */
-#include <linux/capability.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/sched.h>
-#include <linux/smp_lock.h>
-#include <linux/cpumask.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/vmalloc.h>
-#include <linux/miscdevice.h>
-#include <linux/spinlock.h>
-#include <linux/mm.h>
-#include <linux/fs.h>
-#include <linux/mutex.h>
-#include <linux/cpu.h>
-#include <linux/firmware.h>
-#include <linux/platform_device.h>
-
-#include <asm/msr.h>
-#include <asm/uaccess.h>
-#include <asm/processor.h>
-
-MODULE_DESCRIPTION("Intel CPU (IA-32) Microcode Update Driver");
-MODULE_AUTHOR("Tigran Aivazian <tigran@aivazian.fsnet.co.uk>");
-MODULE_LICENSE("GPL");
-
-#define MICROCODE_VERSION 	"1.14a"
-
-#define DEFAULT_UCODE_DATASIZE 	(2000) 	  /* 2000 bytes */
-#define MC_HEADER_SIZE		(sizeof (microcode_header_t))  	  /* 48 bytes */
-#define DEFAULT_UCODE_TOTALSIZE (DEFAULT_UCODE_DATASIZE + MC_HEADER_SIZE) /* 2048 bytes */
-#define EXT_HEADER_SIZE		(sizeof (struct extended_sigtable)) /* 20 bytes */
-#define EXT_SIGNATURE_SIZE	(sizeof (struct extended_signature)) /* 12 bytes */
-#define DWSIZE			(sizeof (u32))
-#define get_totalsize(mc) \
-	(((microcode_t *)mc)->hdr.totalsize ? \
-	 ((microcode_t *)mc)->hdr.totalsize : DEFAULT_UCODE_TOTALSIZE)
-#define get_datasize(mc) \
-	(((microcode_t *)mc)->hdr.datasize ? \
-	 ((microcode_t *)mc)->hdr.datasize : DEFAULT_UCODE_DATASIZE)
-
-#define sigmatch(s1, s2, p1, p2) \
-	(((s1) == (s2)) && (((p1) & (p2)) || (((p1) == 0) && ((p2) == 0))))
-
-#define exttable_size(et) ((et)->count * EXT_SIGNATURE_SIZE + EXT_HEADER_SIZE)
-
-/* serialize access to the physical write to MSR 0x79 */
-static DEFINE_SPINLOCK(microcode_update_lock);
-
-/* no concurrent ->write()s are allowed on /dev/cpu/microcode */
-static DEFINE_MUTEX(microcode_mutex);
-
-static struct ucode_cpu_info {
-	int valid;
-	unsigned int sig;
-	unsigned int pf;
-	unsigned int rev;
-	microcode_t *mc;
-} ucode_cpu_info[NR_CPUS];
-
-static void collect_cpu_info(int cpu_num)
-{
-	struct cpuinfo_x86 *c = &cpu_data(cpu_num);
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu_num;
-	unsigned int val[2];
-
-	/* We should bind the task to the CPU */
-	BUG_ON(raw_smp_processor_id() != cpu_num);
-	uci->pf = uci->rev = 0;
-	uci->mc = NULL;
-	uci->valid = 1;
-
-	if (c->x86_vendor != X86_VENDOR_INTEL || c->x86 < 6 ||
-	    	cpu_has(c, X86_FEATURE_IA64)) {
-		printk(KERN_ERR "microcode: CPU%d not a capable Intel "
-			"processor\n", cpu_num);
-		uci->valid = 0;
-		return;
-	}
-
-	uci->sig = cpuid_eax(0x00000001);
-
-	if ((c->x86_model >= 5) || (c->x86 > 6)) {
-		/* get processor flags from MSR 0x17 */
-		rdmsr(MSR_IA32_PLATFORM_ID, val[0], val[1]);
-		uci->pf = 1 << ((val[1] >> 18) & 7);
-	}
-
-	wrmsr(MSR_IA32_UCODE_REV, 0, 0);
-	/* see notes above for revision 1.07.  Apparent chip bug */
-	sync_core();
-	/* get the current revision from MSR 0x8B */
-	rdmsr(MSR_IA32_UCODE_REV, val[0], uci->rev);
-	pr_debug("microcode: collect_cpu_info : sig=0x%x, pf=0x%x, rev=0x%x\n",
-			uci->sig, uci->pf, uci->rev);
-}
-
-static inline int microcode_update_match(int cpu_num,
-	microcode_header_t *mc_header, int sig, int pf)
-{
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu_num;
-
-	if (!sigmatch(sig, uci->sig, pf, uci->pf)
-		|| mc_header->rev <= uci->rev)
-		return 0;
-	return 1;
-}
-
-static int microcode_sanity_check(void *mc)
-{
-	microcode_header_t *mc_header = mc;
-	struct extended_sigtable *ext_header = NULL;
-	struct extended_signature *ext_sig;
-	unsigned long total_size, data_size, ext_table_size;
-	int sum, orig_sum, ext_sigcount = 0, i;
-
-	total_size = get_totalsize(mc_header);
-	data_size = get_datasize(mc_header);
-	if (data_size + MC_HEADER_SIZE > total_size) {
-		printk(KERN_ERR "microcode: error! "
-			"Bad data size in microcode data file\n");
-		return -EINVAL;
-	}
-
-	if (mc_header->ldrver != 1 || mc_header->hdrver != 1) {
-		printk(KERN_ERR "microcode: error! "
-			"Unknown microcode update format\n");
-		return -EINVAL;
-	}
-	ext_table_size = total_size - (MC_HEADER_SIZE + data_size);
-	if (ext_table_size) {
-		if ((ext_table_size < EXT_HEADER_SIZE)
-		 || ((ext_table_size - EXT_HEADER_SIZE) % EXT_SIGNATURE_SIZE)) {
-			printk(KERN_ERR "microcode: error! "
-				"Small exttable size in microcode data file\n");
-			return -EINVAL;
-		}
-		ext_header = mc + MC_HEADER_SIZE + data_size;
-		if (ext_table_size != exttable_size(ext_header)) {
-			printk(KERN_ERR "microcode: error! "
-				"Bad exttable size in microcode data file\n");
-			return -EFAULT;
-		}
-		ext_sigcount = ext_header->count;
-	}
-
-	/* check extended table checksum */
-	if (ext_table_size) {
-		int ext_table_sum = 0;
-		int *ext_tablep = (int *)ext_header;
-
-		i = ext_table_size / DWSIZE;
-		while (i--)
-			ext_table_sum += ext_tablep[i];
-		if (ext_table_sum) {
-			printk(KERN_WARNING "microcode: aborting, "
-				"bad extended signature table checksum\n");
-			return -EINVAL;
-		}
-	}
-
-	/* calculate the checksum */
-	orig_sum = 0;
-	i = (MC_HEADER_SIZE + data_size) / DWSIZE;
-	while (i--)
-		orig_sum += ((int *)mc)[i];
-	if (orig_sum) {
-		printk(KERN_ERR "microcode: aborting, bad checksum\n");
-		return -EINVAL;
-	}
-	if (!ext_table_size)
-		return 0;
-	/* check extended signature checksum */
-	for (i = 0; i < ext_sigcount; i++) {
-		ext_sig = (void *)ext_header + EXT_HEADER_SIZE +
-			  EXT_SIGNATURE_SIZE * i;
-		sum = orig_sum
-			- (mc_header->sig + mc_header->pf + mc_header->cksum)
-			+ (ext_sig->sig + ext_sig->pf + ext_sig->cksum);
-		if (sum) {
-			printk(KERN_ERR "microcode: aborting, bad checksum\n");
-			return -EINVAL;
-		}
-	}
-	return 0;
-}
-
-/*
- * return 0 - no update found
- * return 1 - found update
- * return < 0 - error
- */
-static int get_maching_microcode(void *mc, int cpu)
-{
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-	microcode_header_t *mc_header = mc;
-	struct extended_sigtable *ext_header;
-	unsigned long total_size = get_totalsize(mc_header);
-	int ext_sigcount, i;
-	struct extended_signature *ext_sig;
-	void *new_mc;
-
-	if (microcode_update_match(cpu, mc_header,
-			mc_header->sig, mc_header->pf))
-		goto find;
-
-	if (total_size <= get_datasize(mc_header) + MC_HEADER_SIZE)
-		return 0;
-
-	ext_header = mc + get_datasize(mc_header) + MC_HEADER_SIZE;
-	ext_sigcount = ext_header->count;
-	ext_sig = (void *)ext_header + EXT_HEADER_SIZE;
-	for (i = 0; i < ext_sigcount; i++) {
-		if (microcode_update_match(cpu, mc_header,
-				ext_sig->sig, ext_sig->pf))
-			goto find;
-		ext_sig++;
-	}
-	return 0;
-find:
-	pr_debug("microcode: CPU%d found a matching microcode update with"
-		" version 0x%x (current=0x%x)\n", cpu, mc_header->rev,uci->rev);
-	new_mc = vmalloc(total_size);
-	if (!new_mc) {
-		printk(KERN_ERR "microcode: error! Can not allocate memory\n");
-		return -ENOMEM;
-	}
-
-	/* free previous update file */
-	vfree(uci->mc);
-
-	memcpy(new_mc, mc, total_size);
-	uci->mc = new_mc;
-	return 1;
-}
-
-static void apply_microcode(int cpu)
-{
-	unsigned long flags;
-	unsigned int val[2];
-	int cpu_num = raw_smp_processor_id();
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu_num;
-
-	/* We should bind the task to the CPU */
-	BUG_ON(cpu_num != cpu);
-
-	if (uci->mc == NULL)
-		return;
-
-	/* serialize access to the physical write to MSR 0x79 */
-	spin_lock_irqsave(&microcode_update_lock, flags);
-
-	/* write microcode via MSR 0x79 */
-	wrmsr(MSR_IA32_UCODE_WRITE,
-		(unsigned long) uci->mc->bits,
-		(unsigned long) uci->mc->bits >> 16 >> 16);
-	wrmsr(MSR_IA32_UCODE_REV, 0, 0);
-
-	/* see notes above for revision 1.07.  Apparent chip bug */
-	sync_core();
-
-	/* get the current revision from MSR 0x8B */
-	rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
-
-	spin_unlock_irqrestore(&microcode_update_lock, flags);
-	if (val[1] != uci->mc->hdr.rev) {
-		printk(KERN_ERR "microcode: CPU%d update from revision "
-			"0x%x to 0x%x failed\n", cpu_num, uci->rev, val[1]);
-		return;
-	}
-	printk(KERN_INFO "microcode: CPU%d updated from revision "
-	       "0x%x to 0x%x, date = %08x \n",
-	       cpu_num, uci->rev, val[1], uci->mc->hdr.date);
-	uci->rev = val[1];
-}
-
-#ifdef CONFIG_MICROCODE_OLD_INTERFACE
-static void __user *user_buffer;	/* user area microcode data buffer */
-static unsigned int user_buffer_size;	/* it's size */
-
-static long get_next_ucode(void **mc, long offset)
-{
-	microcode_header_t mc_header;
-	unsigned long total_size;
-
-	/* No more data */
-	if (offset >= user_buffer_size)
-		return 0;
-	if (copy_from_user(&mc_header, user_buffer + offset, MC_HEADER_SIZE)) {
-		printk(KERN_ERR "microcode: error! Can not read user data\n");
-		return -EFAULT;
-	}
-	total_size = get_totalsize(&mc_header);
-	if (offset + total_size > user_buffer_size) {
-		printk(KERN_ERR "microcode: error! Bad total size in microcode "
-				"data file\n");
-		return -EINVAL;
-	}
-	*mc = vmalloc(total_size);
-	if (!*mc)
-		return -ENOMEM;
-	if (copy_from_user(*mc, user_buffer + offset, total_size)) {
-		printk(KERN_ERR "microcode: error! Can not read user data\n");
-		vfree(*mc);
-		return -EFAULT;
-	}
-	return offset + total_size;
-}
-
-static int do_microcode_update (void)
-{
-	long cursor = 0;
-	int error = 0;
-	void *new_mc = NULL;
-	int cpu;
-	cpumask_t old;
-
-	old = current->cpus_allowed;
-
-	while ((cursor = get_next_ucode(&new_mc, cursor)) > 0) {
-		error = microcode_sanity_check(new_mc);
-		if (error)
-			goto out;
-		/*
-		 * It's possible the data file has multiple matching ucode,
-		 * lets keep searching till the latest version
-		 */
-		for_each_online_cpu(cpu) {
-			struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-
-			if (!uci->valid)
-				continue;
-			set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-			error = get_maching_microcode(new_mc, cpu);
-			if (error < 0)
-				goto out;
-			if (error == 1)
-				apply_microcode(cpu);
-		}
-		vfree(new_mc);
-	}
-out:
-	if (cursor > 0)
-		vfree(new_mc);
-	if (cursor < 0)
-		error = cursor;
-	set_cpus_allowed_ptr(current, &old);
-	return error;
-}
-
-static int microcode_open (struct inode *unused1, struct file *unused2)
-{
-	cycle_kernel_lock();
-	return capable(CAP_SYS_RAWIO) ? 0 : -EPERM;
-}
-
-static ssize_t microcode_write (struct file *file, const char __user *buf, size_t len, loff_t *ppos)
-{
-	ssize_t ret;
-
-	if ((len >> PAGE_SHIFT) > num_physpages) {
-		printk(KERN_ERR "microcode: too much data (max %ld pages)\n", num_physpages);
-		return -EINVAL;
-	}
-
-	get_online_cpus();
-	mutex_lock(&microcode_mutex);
-
-	user_buffer = (void __user *) buf;
-	user_buffer_size = (int) len;
-
-	ret = do_microcode_update();
-	if (!ret)
-		ret = (ssize_t)len;
-
-	mutex_unlock(&microcode_mutex);
-	put_online_cpus();
-
-	return ret;
-}
-
-static const struct file_operations microcode_fops = {
-	.owner		= THIS_MODULE,
-	.write		= microcode_write,
-	.open		= microcode_open,
-};
-
-static struct miscdevice microcode_dev = {
-	.minor		= MICROCODE_MINOR,
-	.name		= "microcode",
-	.fops		= &microcode_fops,
-};
-
-static int __init microcode_dev_init (void)
-{
-	int error;
-
-	error = misc_register(&microcode_dev);
-	if (error) {
-		printk(KERN_ERR
-			"microcode: can't misc_register on minor=%d\n",
-			MICROCODE_MINOR);
-		return error;
-	}
-
-	return 0;
-}
-
-static void microcode_dev_exit (void)
-{
-	misc_deregister(&microcode_dev);
-}
-
-MODULE_ALIAS_MISCDEV(MICROCODE_MINOR);
-#else
-#define microcode_dev_init() 0
-#define microcode_dev_exit() do { } while(0)
-#endif
-
-static long get_next_ucode_from_buffer(void **mc, const u8 *buf,
-	unsigned long size, long offset)
-{
-	microcode_header_t *mc_header;
-	unsigned long total_size;
-
-	/* No more data */
-	if (offset >= size)
-		return 0;
-	mc_header = (microcode_header_t *)(buf + offset);
-	total_size = get_totalsize(mc_header);
-
-	if (offset + total_size > size) {
-		printk(KERN_ERR "microcode: error! Bad data in microcode data file\n");
-		return -EINVAL;
-	}
-
-	*mc = vmalloc(total_size);
-	if (!*mc) {
-		printk(KERN_ERR "microcode: error! Can not allocate memory\n");
-		return -ENOMEM;
-	}
-	memcpy(*mc, buf + offset, total_size);
-	return offset + total_size;
-}
-
-/* fake device for request_firmware */
-static struct platform_device *microcode_pdev;
-
-static int cpu_request_microcode(int cpu)
-{
-	char name[30];
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
-	const struct firmware *firmware;
-	const u8 *buf;
-	unsigned long size;
-	long offset = 0;
-	int error;
-	void *mc;
-
-	/* We should bind the task to the CPU */
-	BUG_ON(cpu != raw_smp_processor_id());
-	sprintf(name,"intel-ucode/%02x-%02x-%02x",
-		c->x86, c->x86_model, c->x86_mask);
-	error = request_firmware(&firmware, name, &microcode_pdev->dev);
-	if (error) {
-		pr_debug("microcode: data file %s load failed\n", name);
-		return error;
-	}
-	buf = firmware->data;
-	size = firmware->size;
-	while ((offset = get_next_ucode_from_buffer(&mc, buf, size, offset))
-			> 0) {
-		error = microcode_sanity_check(mc);
-		if (error)
-			break;
-		error = get_maching_microcode(mc, cpu);
-		if (error < 0)
-			break;
-		/*
-		 * It's possible the data file has multiple matching ucode,
-		 * lets keep searching till the latest version
-		 */
-		if (error == 1) {
-			apply_microcode(cpu);
-			error = 0;
-		}
-		vfree(mc);
-	}
-	if (offset > 0)
-		vfree(mc);
-	if (offset < 0)
-		error = offset;
-	release_firmware(firmware);
-
-	return error;
-}
-
-static int apply_microcode_check_cpu(int cpu)
-{
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-	cpumask_t old;
-	unsigned int val[2];
-	int err = 0;
-
-	/* Check if the microcode is available */
-	if (!uci->mc)
-		return 0;
-
-	old = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-
-	/* Check if the microcode we have in memory matches the CPU */
-	if (c->x86_vendor != X86_VENDOR_INTEL || c->x86 < 6 ||
-	    cpu_has(c, X86_FEATURE_IA64) || uci->sig != cpuid_eax(0x00000001))
-		err = -EINVAL;
-
-	if (!err && ((c->x86_model >= 5) || (c->x86 > 6))) {
-		/* get processor flags from MSR 0x17 */
-		rdmsr(MSR_IA32_PLATFORM_ID, val[0], val[1]);
-		if (uci->pf != (1 << ((val[1] >> 18) & 7)))
-			err = -EINVAL;
-	}
-
-	if (!err) {
-		wrmsr(MSR_IA32_UCODE_REV, 0, 0);
-		/* see notes above for revision 1.07.  Apparent chip bug */
-		sync_core();
-		/* get the current revision from MSR 0x8B */
-		rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
-		if (uci->rev != val[1])
-			err = -EINVAL;
-	}
-
-	if (!err)
-		apply_microcode(cpu);
-	else
-		printk(KERN_ERR "microcode: Could not apply microcode to CPU%d:"
-			" sig=0x%x, pf=0x%x, rev=0x%x\n",
-			cpu, uci->sig, uci->pf, uci->rev);
-
-	set_cpus_allowed_ptr(current, &old);
-	return err;
-}
-
-static void microcode_init_cpu(int cpu, int resume)
-{
-	cpumask_t old;
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-
-	old = current->cpus_allowed;
-
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-	mutex_lock(&microcode_mutex);
-	collect_cpu_info(cpu);
-	if (uci->valid && system_state == SYSTEM_RUNNING && !resume)
-		cpu_request_microcode(cpu);
-	mutex_unlock(&microcode_mutex);
-	set_cpus_allowed_ptr(current, &old);
-}
-
-static void microcode_fini_cpu(int cpu)
-{
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-
-	mutex_lock(&microcode_mutex);
-	uci->valid = 0;
-	vfree(uci->mc);
-	uci->mc = NULL;
-	mutex_unlock(&microcode_mutex);
-}
-
-static ssize_t reload_store(struct sys_device *dev,
-			    struct sysdev_attribute *attr,
-			    const char *buf, size_t sz)
-{
-	struct ucode_cpu_info *uci = ucode_cpu_info + dev->id;
-	char *end;
-	unsigned long val = simple_strtoul(buf, &end, 0);
-	int err = 0;
-	int cpu = dev->id;
-
-	if (end == buf)
-		return -EINVAL;
-	if (val == 1) {
-		cpumask_t old = current->cpus_allowed;
-
-		get_online_cpus();
-		set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-
-		mutex_lock(&microcode_mutex);
-		if (uci->valid)
-			err = cpu_request_microcode(cpu);
-		mutex_unlock(&microcode_mutex);
-		put_online_cpus();
-		set_cpus_allowed_ptr(current, &old);
-	}
-	if (err)
-		return err;
-	return sz;
-}
-
-static ssize_t version_show(struct sys_device *dev,
-			struct sysdev_attribute *attr, char *buf)
-{
-	struct ucode_cpu_info *uci = ucode_cpu_info + dev->id;
-
-	return sprintf(buf, "0x%x\n", uci->rev);
-}
-
-static ssize_t pf_show(struct sys_device *dev,
-			struct sysdev_attribute *attr, char *buf)
-{
-	struct ucode_cpu_info *uci = ucode_cpu_info + dev->id;
-
-	return sprintf(buf, "0x%x\n", uci->pf);
-}
-
-static SYSDEV_ATTR(reload, 0200, NULL, reload_store);
-static SYSDEV_ATTR(version, 0400, version_show, NULL);
-static SYSDEV_ATTR(processor_flags, 0400, pf_show, NULL);
-
-static struct attribute *mc_default_attrs[] = {
-	&attr_reload.attr,
-	&attr_version.attr,
-	&attr_processor_flags.attr,
-	NULL
-};
-
-static struct attribute_group mc_attr_group = {
-	.attrs = mc_default_attrs,
-	.name = "microcode",
-};
-
-static int __mc_sysdev_add(struct sys_device *sys_dev, int resume)
-{
-	int err, cpu = sys_dev->id;
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-
-	if (!cpu_online(cpu))
-		return 0;
-
-	pr_debug("microcode: CPU%d added\n", cpu);
-	memset(uci, 0, sizeof(*uci));
-
-	err = sysfs_create_group(&sys_dev->kobj, &mc_attr_group);
-	if (err)
-		return err;
-
-	microcode_init_cpu(cpu, resume);
-
-	return 0;
-}
-
-static int mc_sysdev_add(struct sys_device *sys_dev)
-{
-	return __mc_sysdev_add(sys_dev, 0);
-}
-
-static int mc_sysdev_remove(struct sys_device *sys_dev)
-{
-	int cpu = sys_dev->id;
-
-	if (!cpu_online(cpu))
-		return 0;
-
-	pr_debug("microcode: CPU%d removed\n", cpu);
-	microcode_fini_cpu(cpu);
-	sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
-	return 0;
-}
-
-static int mc_sysdev_resume(struct sys_device *dev)
-{
-	int cpu = dev->id;
-
-	if (!cpu_online(cpu))
-		return 0;
-	pr_debug("microcode: CPU%d resumed\n", cpu);
-	/* only CPU 0 will apply ucode here */
-	apply_microcode(0);
-	return 0;
-}
-
-static struct sysdev_driver mc_sysdev_driver = {
-	.add = mc_sysdev_add,
-	.remove = mc_sysdev_remove,
-	.resume = mc_sysdev_resume,
-};
-
-static __cpuinit int
-mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
-{
-	unsigned int cpu = (unsigned long)hcpu;
-	struct sys_device *sys_dev;
-
-	sys_dev = get_cpu_sysdev(cpu);
-	switch (action) {
-	case CPU_UP_CANCELED_FROZEN:
-		/* The CPU refused to come up during a system resume */
-		microcode_fini_cpu(cpu);
-		break;
-	case CPU_ONLINE:
-	case CPU_DOWN_FAILED:
-		mc_sysdev_add(sys_dev);
-		break;
-	case CPU_ONLINE_FROZEN:
-		/* System-wide resume is in progress, try to apply microcode */
-		if (apply_microcode_check_cpu(cpu)) {
-			/* The application of microcode failed */
-			microcode_fini_cpu(cpu);
-			__mc_sysdev_add(sys_dev, 1);
-			break;
-		}
-	case CPU_DOWN_FAILED_FROZEN:
-		if (sysfs_create_group(&sys_dev->kobj, &mc_attr_group))
-			printk(KERN_ERR "microcode: Failed to create the sysfs "
-				"group for CPU%d\n", cpu);
-		break;
-	case CPU_DOWN_PREPARE:
-		mc_sysdev_remove(sys_dev);
-		break;
-	case CPU_DOWN_PREPARE_FROZEN:
-		/* Suspend is in progress, only remove the interface */
-		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
-		break;
-	}
-	return NOTIFY_OK;
-}
-
-static struct notifier_block __refdata mc_cpu_notifier = {
-	.notifier_call = mc_cpu_callback,
-};
-
-static int __init microcode_init (void)
-{
-	int error;
-
-	printk(KERN_INFO
-		"IA-32 Microcode Update Driver: v" MICROCODE_VERSION " <tigran@aivazian.fsnet.co.uk>\n");
-
-	error = microcode_dev_init();
-	if (error)
-		return error;
-	microcode_pdev = platform_device_register_simple("microcode", -1,
-							 NULL, 0);
-	if (IS_ERR(microcode_pdev)) {
-		microcode_dev_exit();
-		return PTR_ERR(microcode_pdev);
-	}
-
-	get_online_cpus();
-	error = sysdev_driver_register(&cpu_sysdev_class, &mc_sysdev_driver);
-	put_online_cpus();
-	if (error) {
-		microcode_dev_exit();
-		platform_device_unregister(microcode_pdev);
-		return error;
-	}
-
-	register_hotcpu_notifier(&mc_cpu_notifier);
-	return 0;
-}
-
-static void __exit microcode_exit (void)
-{
-	microcode_dev_exit();
-
-	unregister_hotcpu_notifier(&mc_cpu_notifier);
-
-	get_online_cpus();
-	sysdev_driver_unregister(&cpu_sysdev_class, &mc_sysdev_driver);
-	put_online_cpus();
-
-	platform_device_unregister(microcode_pdev);
-}
-
-module_init(microcode_init)
-module_exit(microcode_exit)
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
new file mode 100644
index 0000000..7a1f8ee
--- /dev/null
+++ b/arch/x86/kernel/microcode_amd.c
@@ -0,0 +1,435 @@
+/*
+ *  AMD CPU Microcode Update Driver for Linux
+ *  Copyright (C) 2008 Advanced Micro Devices Inc.
+ *
+ *  Author: Peter Oruba <peter.oruba@amd.com>
+ *
+ *  Based on work by:
+ *  Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
+ *
+ *  This driver allows to upgrade microcode on AMD
+ *  family 0x10 and 0x11 processors.
+ *
+ *  Licensed unter the terms of the GNU General Public
+ *  License version 2. See file COPYING for details.
+*/
+
+#include <linux/capability.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/cpumask.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/miscdevice.h>
+#include <linux/spinlock.h>
+#include <linux/mm.h>
+#include <linux/fs.h>
+#include <linux/mutex.h>
+#include <linux/cpu.h>
+#include <linux/firmware.h>
+#include <linux/platform_device.h>
+#include <linux/pci.h>
+#include <linux/pci_ids.h>
+
+#include <asm/msr.h>
+#include <asm/uaccess.h>
+#include <asm/processor.h>
+#include <asm/microcode.h>
+
+MODULE_DESCRIPTION("AMD Microcode Update Driver");
+MODULE_AUTHOR("Peter Oruba <peter.oruba@amd.com>");
+MODULE_LICENSE("GPL v2");
+
+#define UCODE_MAGIC                0x00414d44
+#define UCODE_EQUIV_CPU_TABLE_TYPE 0x00000000
+#define UCODE_UCODE_TYPE           0x00000001
+
+struct equiv_cpu_entry {
+	unsigned int installed_cpu;
+	unsigned int fixed_errata_mask;
+	unsigned int fixed_errata_compare;
+	unsigned int equiv_cpu;
+};
+
+struct microcode_header_amd {
+	unsigned int  data_code;
+	unsigned int  patch_id;
+	unsigned char mc_patch_data_id[2];
+	unsigned char mc_patch_data_len;
+	unsigned char init_flag;
+	unsigned int  mc_patch_data_checksum;
+	unsigned int  nb_dev_id;
+	unsigned int  sb_dev_id;
+	unsigned char processor_rev_id[2];
+	unsigned char nb_rev_id;
+	unsigned char sb_rev_id;
+	unsigned char bios_api_rev;
+	unsigned char reserved1[3];
+	unsigned int  match_reg[8];
+};
+
+struct microcode_amd {
+	struct microcode_header_amd hdr;
+	unsigned int mpb[0];
+};
+
+#define UCODE_MAX_SIZE          (2048)
+#define DEFAULT_UCODE_DATASIZE	(896)
+#define MC_HEADER_SIZE		(sizeof(struct microcode_header_amd))
+#define DEFAULT_UCODE_TOTALSIZE (DEFAULT_UCODE_DATASIZE + MC_HEADER_SIZE)
+#define DWSIZE			(sizeof(u32))
+/* For now we support a fixed ucode total size only */
+#define get_totalsize(mc) \
+	((((struct microcode_amd *)mc)->hdr.mc_patch_data_len * 28) \
+	 + MC_HEADER_SIZE)
+
+/* serialize access to the physical write */
+static DEFINE_SPINLOCK(microcode_update_lock);
+
+static struct equiv_cpu_entry *equiv_cpu_table;
+
+static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
+{
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+
+	memset(csig, 0, sizeof(*csig));
+
+	if (c->x86_vendor != X86_VENDOR_AMD || c->x86 < 0x10) {
+		printk(KERN_ERR "microcode: CPU%d not a capable AMD processor\n",
+		       cpu);
+		return -1;
+	}
+
+	asm volatile("movl %1, %%ecx; rdmsr"
+		     : "=a" (csig->rev)
+		     : "i" (0x0000008B) : "ecx");
+
+	printk(KERN_INFO "microcode: collect_cpu_info_amd : patch_id=0x%x\n",
+		csig->rev);
+
+	return 0;
+}
+
+static int get_matching_microcode(int cpu, void *mc, int rev)
+{
+	struct microcode_header_amd *mc_header = mc;
+	struct pci_dev *nb_pci_dev, *sb_pci_dev;
+	unsigned int current_cpu_id;
+	unsigned int equiv_cpu_id = 0x00;
+	unsigned int i = 0;
+
+	BUG_ON(equiv_cpu_table == NULL);
+	current_cpu_id = cpuid_eax(0x00000001);
+
+	while (equiv_cpu_table[i].installed_cpu != 0) {
+		if (current_cpu_id == equiv_cpu_table[i].installed_cpu) {
+			equiv_cpu_id = equiv_cpu_table[i].equiv_cpu;
+			break;
+		}
+		i++;
+	}
+
+	if (!equiv_cpu_id) {
+		printk(KERN_ERR "microcode: CPU%d cpu_id "
+		       "not found in equivalent cpu table \n", cpu);
+		return 0;
+	}
+
+	if ((mc_header->processor_rev_id[0]) != (equiv_cpu_id & 0xff)) {
+		printk(KERN_ERR
+			"microcode: CPU%d patch does not match "
+			"(patch is %x, cpu extended is %x) \n",
+			cpu, mc_header->processor_rev_id[0],
+			(equiv_cpu_id & 0xff));
+		return 0;
+	}
+
+	if ((mc_header->processor_rev_id[1]) != ((equiv_cpu_id >> 16) & 0xff)) {
+		printk(KERN_ERR "microcode: CPU%d patch does not match "
+			"(patch is %x, cpu base id is %x) \n",
+			cpu, mc_header->processor_rev_id[1],
+			((equiv_cpu_id >> 16) & 0xff));
+
+		return 0;
+	}
+
+	/* ucode may be northbridge specific */
+	if (mc_header->nb_dev_id) {
+		nb_pci_dev = pci_get_device(PCI_VENDOR_ID_AMD,
+					    (mc_header->nb_dev_id & 0xff),
+					    NULL);
+		if ((!nb_pci_dev) ||
+		    (mc_header->nb_rev_id != nb_pci_dev->revision)) {
+			printk(KERN_ERR "microcode: CPU%d NB mismatch \n", cpu);
+			pci_dev_put(nb_pci_dev);
+			return 0;
+		}
+		pci_dev_put(nb_pci_dev);
+	}
+
+	/* ucode may be southbridge specific */
+	if (mc_header->sb_dev_id) {
+		sb_pci_dev = pci_get_device(PCI_VENDOR_ID_AMD,
+					    (mc_header->sb_dev_id & 0xff),
+					    NULL);
+		if ((!sb_pci_dev) ||
+		    (mc_header->sb_rev_id != sb_pci_dev->revision)) {
+			printk(KERN_ERR "microcode: CPU%d SB mismatch \n", cpu);
+			pci_dev_put(sb_pci_dev);
+			return 0;
+		}
+		pci_dev_put(sb_pci_dev);
+	}
+
+	if (mc_header->patch_id <= rev)
+		return 0;
+
+	return 1;
+}
+
+static void apply_microcode_amd(int cpu)
+{
+	unsigned long flags;
+	unsigned int eax, edx;
+	unsigned int rev;
+	int cpu_num = raw_smp_processor_id();
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu_num;
+	struct microcode_amd *mc_amd = uci->mc;
+	unsigned long addr;
+
+	/* We should bind the task to the CPU */
+	BUG_ON(cpu_num != cpu);
+
+	if (mc_amd == NULL)
+		return;
+
+	spin_lock_irqsave(&microcode_update_lock, flags);
+
+	addr = (unsigned long)&mc_amd->hdr.data_code;
+	edx = (unsigned int)(((unsigned long)upper_32_bits(addr)));
+	eax = (unsigned int)(((unsigned long)lower_32_bits(addr)));
+
+	asm volatile("movl %0, %%ecx; wrmsr" :
+		     : "i" (0xc0010020), "a" (eax), "d" (edx) : "ecx");
+
+	/* get patch id after patching */
+	asm volatile("movl %1, %%ecx; rdmsr"
+		     : "=a" (rev)
+		     : "i" (0x0000008B) : "ecx");
+
+	spin_unlock_irqrestore(&microcode_update_lock, flags);
+
+	/* check current patch id and patch's id for match */
+	if (rev != mc_amd->hdr.patch_id) {
+		printk(KERN_ERR "microcode: CPU%d update from revision "
+		       "0x%x to 0x%x failed\n", cpu_num,
+		       mc_amd->hdr.patch_id, rev);
+		return;
+	}
+
+	printk(KERN_INFO "microcode: CPU%d updated from revision "
+	       "0x%x to 0x%x \n",
+	       cpu_num, uci->cpu_sig.rev, mc_amd->hdr.patch_id);
+
+	uci->cpu_sig.rev = rev;
+}
+
+static void * get_next_ucode(u8 *buf, unsigned int size,
+			int (*get_ucode_data)(void *, const void *, size_t),
+			unsigned int *mc_size)
+{
+	unsigned int total_size;
+#define UCODE_CONTAINER_SECTION_HDR	8
+	u8 section_hdr[UCODE_CONTAINER_SECTION_HDR];
+	void *mc;
+
+	if (get_ucode_data(section_hdr, buf, UCODE_CONTAINER_SECTION_HDR))
+		return NULL;
+
+	if (section_hdr[0] != UCODE_UCODE_TYPE) {
+		printk(KERN_ERR "microcode: error! "
+		       "Wrong microcode payload type field\n");
+		return NULL;
+	}
+
+	total_size = (unsigned long) (section_hdr[4] + (section_hdr[5] << 8));
+
+	printk(KERN_INFO "microcode: size %u, total_size %u\n",
+		size, total_size);
+
+	if (total_size > size || total_size > UCODE_MAX_SIZE) {
+		printk(KERN_ERR "microcode: error! Bad data in microcode data file\n");
+		return NULL;
+	}
+
+	mc = vmalloc(UCODE_MAX_SIZE);
+	if (mc) {
+		memset(mc, 0, UCODE_MAX_SIZE);
+		if (get_ucode_data(mc, buf + UCODE_CONTAINER_SECTION_HDR, total_size)) {
+			vfree(mc);
+			mc = NULL;
+		} else
+			*mc_size = total_size + UCODE_CONTAINER_SECTION_HDR;
+	}
+#undef UCODE_CONTAINER_SECTION_HDR
+	return mc;
+}
+
+
+static int install_equiv_cpu_table(u8 *buf,
+		int (*get_ucode_data)(void *, const void *, size_t))
+{
+#define UCODE_CONTAINER_HEADER_SIZE	12
+	u8 *container_hdr[UCODE_CONTAINER_HEADER_SIZE];
+	unsigned int *buf_pos = (unsigned int *)container_hdr;
+	unsigned long size;
+
+	if (get_ucode_data(&container_hdr, buf, UCODE_CONTAINER_HEADER_SIZE))
+		return 0;
+
+	size = buf_pos[2];
+
+	if (buf_pos[1] != UCODE_EQUIV_CPU_TABLE_TYPE || !size) {
+		printk(KERN_ERR "microcode: error! "
+		       "Wrong microcode equivalnet cpu table\n");
+		return 0;
+	}
+
+	equiv_cpu_table = (struct equiv_cpu_entry *) vmalloc(size);
+	if (!equiv_cpu_table) {
+		printk(KERN_ERR "microcode: error, can't allocate memory for equiv CPU table\n");
+		return 0;
+	}
+
+	buf += UCODE_CONTAINER_HEADER_SIZE;
+	if (get_ucode_data(equiv_cpu_table, buf, size)) {
+		vfree(equiv_cpu_table);
+		return 0;
+	}
+
+	return size + UCODE_CONTAINER_HEADER_SIZE; /* add header length */
+#undef UCODE_CONTAINER_HEADER_SIZE
+}
+
+static void free_equiv_cpu_table(void)
+{
+	if (equiv_cpu_table) {
+		vfree(equiv_cpu_table);
+		equiv_cpu_table = NULL;
+	}
+}
+
+static int generic_load_microcode(int cpu, void *data, size_t size,
+		int (*get_ucode_data)(void *, const void *, size_t))
+{
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	u8 *ucode_ptr = data, *new_mc = NULL, *mc;
+	int new_rev = uci->cpu_sig.rev;
+	unsigned int leftover;
+	unsigned long offset;
+
+	offset = install_equiv_cpu_table(ucode_ptr, get_ucode_data);
+	if (!offset) {
+		printk(KERN_ERR "microcode: installing equivalent cpu table failed\n");
+		return -EINVAL;
+	}
+
+	ucode_ptr += offset;
+	leftover = size - offset;
+
+	while (leftover) {
+		unsigned int uninitialized_var(mc_size);
+		struct microcode_header_amd *mc_header;
+
+		mc = get_next_ucode(ucode_ptr, leftover, get_ucode_data, &mc_size);
+		if (!mc)
+			break;
+
+		mc_header = (struct microcode_header_amd *)mc;
+		if (get_matching_microcode(cpu, mc, new_rev)) {
+			if (new_mc)
+				vfree(new_mc);
+			new_rev = mc_header->patch_id;
+			new_mc  = mc;
+		} else 
+			vfree(mc);
+
+		ucode_ptr += mc_size;
+		leftover  -= mc_size;
+	}
+
+	if (new_mc) {
+		if (!leftover) {
+			if (uci->mc)
+				vfree(uci->mc);
+			uci->mc = new_mc;
+			pr_debug("microcode: CPU%d found a matching microcode update with"
+				" version 0x%x (current=0x%x)\n",
+				cpu, new_rev, uci->cpu_sig.rev);
+		} else
+			vfree(new_mc);
+	}
+
+	free_equiv_cpu_table();
+
+	return (int)leftover;
+}
+
+static int get_ucode_fw(void *to, const void *from, size_t n)
+{
+	memcpy(to, from, n);
+	return 0;
+}
+
+static int request_microcode_fw(int cpu, struct device *device)
+{
+	const char *fw_name = "amd-ucode/microcode_amd.bin";
+	const struct firmware *firmware;
+	int ret;
+
+	/* We should bind the task to the CPU */
+	BUG_ON(cpu != raw_smp_processor_id());
+
+	ret = request_firmware(&firmware, fw_name, device);
+	if (ret) {
+		printk(KERN_ERR "microcode: ucode data file %s load failed\n", fw_name);
+		return ret;
+	}
+
+	ret = generic_load_microcode(cpu, (void*)firmware->data, firmware->size,
+			&get_ucode_fw);
+
+	release_firmware(firmware);
+
+	return ret;
+}
+
+static int request_microcode_user(int cpu, const void __user *buf, size_t size)
+{
+	printk(KERN_WARNING "microcode: AMD microcode update via /dev/cpu/microcode"
+			"is not supported\n");
+	return -1;
+}
+
+static void microcode_fini_cpu_amd(int cpu)
+{
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+
+	vfree(uci->mc);
+	uci->mc = NULL;
+}
+
+static struct microcode_ops microcode_amd_ops = {
+	.request_microcode_user           = request_microcode_user,
+	.request_microcode_fw             = request_microcode_fw,
+	.collect_cpu_info                 = collect_cpu_info_amd,
+	.apply_microcode                  = apply_microcode_amd,
+	.microcode_fini_cpu               = microcode_fini_cpu_amd,
+};
+
+struct microcode_ops * __init init_amd_microcode(void)
+{
+	return &microcode_amd_ops;
+}
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
new file mode 100644
index 0000000..936d8d5
--- /dev/null
+++ b/arch/x86/kernel/microcode_core.c
@@ -0,0 +1,508 @@
+/*
+ *	Intel CPU Microcode Update Driver for Linux
+ *
+ *	Copyright (C) 2000-2006 Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
+ *		      2006	Shaohua Li <shaohua.li@intel.com>
+ *
+ *	This driver allows to upgrade microcode on Intel processors
+ *	belonging to IA-32 family - PentiumPro, Pentium II,
+ *	Pentium III, Xeon, Pentium 4, etc.
+ *
+ *	Reference: Section 8.11 of Volume 3a, IA-32 Intel? Architecture
+ *	Software Developer's Manual
+ *	Order Number 253668 or free download from:
+ *
+ *	http://developer.intel.com/design/pentium4/manuals/253668.htm
+ *
+ *	For more information, go to http://www.urbanmyth.org/microcode
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
+ *
+ *	1.0	16 Feb 2000, Tigran Aivazian <tigran@sco.com>
+ *		Initial release.
+ *	1.01	18 Feb 2000, Tigran Aivazian <tigran@sco.com>
+ *		Added read() support + cleanups.
+ *	1.02	21 Feb 2000, Tigran Aivazian <tigran@sco.com>
+ *		Added 'device trimming' support. open(O_WRONLY) zeroes
+ *		and frees the saved copy of applied microcode.
+ *	1.03	29 Feb 2000, Tigran Aivazian <tigran@sco.com>
+ *		Made to use devfs (/dev/cpu/microcode) + cleanups.
+ *	1.04	06 Jun 2000, Simon Trimmer <simon@veritas.com>
+ *		Added misc device support (now uses both devfs and misc).
+ *		Added MICROCODE_IOCFREE ioctl to clear memory.
+ *	1.05	09 Jun 2000, Simon Trimmer <simon@veritas.com>
+ *		Messages for error cases (non Intel & no suitable microcode).
+ *	1.06	03 Aug 2000, Tigran Aivazian <tigran@veritas.com>
+ *		Removed ->release(). Removed exclusive open and status bitmap.
+ *		Added microcode_rwsem to serialize read()/write()/ioctl().
+ *		Removed global kernel lock usage.
+ *	1.07	07 Sep 2000, Tigran Aivazian <tigran@veritas.com>
+ *		Write 0 to 0x8B msr and then cpuid before reading revision,
+ *		so that it works even if there were no update done by the
+ *		BIOS. Otherwise, reading from 0x8B gives junk (which happened
+ *		to be 0 on my machine which is why it worked even when I
+ *		disabled update by the BIOS)
+ *		Thanks to Eric W. Biederman <ebiederman@lnxi.com> for the fix.
+ *	1.08	11 Dec 2000, Richard Schaal <richard.schaal@intel.com> and
+ *			     Tigran Aivazian <tigran@veritas.com>
+ *		Intel Pentium 4 processor support and bugfixes.
+ *	1.09	30 Oct 2001, Tigran Aivazian <tigran@veritas.com>
+ *		Bugfix for HT (Hyper-Threading) enabled processors
+ *		whereby processor resources are shared by all logical processors
+ *		in a single CPU package.
+ *	1.10	28 Feb 2002 Asit K Mallick <asit.k.mallick@intel.com> and
+ *		Tigran Aivazian <tigran@veritas.com>,
+ *		Serialize updates as required on HT processors due to
+ *		speculative nature of implementation.
+ *	1.11	22 Mar 2002 Tigran Aivazian <tigran@veritas.com>
+ *		Fix the panic when writing zero-length microcode chunk.
+ *	1.12	29 Sep 2003 Nitin Kamble <nitin.a.kamble@intel.com>,
+ *		Jun Nakajima <jun.nakajima@intel.com>
+ *		Support for the microcode updates in the new format.
+ *	1.13	10 Oct 2003 Tigran Aivazian <tigran@veritas.com>
+ *		Removed ->read() method and obsoleted MICROCODE_IOCFREE ioctl
+ *		because we no longer hold a copy of applied microcode
+ *		in kernel memory.
+ *	1.14	25 Jun 2004 Tigran Aivazian <tigran@veritas.com>
+ *		Fix sigmatch() macro to handle old CPUs with pf == 0.
+ *		Thanks to Stuart Swales for pointing out this bug.
+ */
+#include <linux/capability.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/smp_lock.h>
+#include <linux/cpumask.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/miscdevice.h>
+#include <linux/spinlock.h>
+#include <linux/mm.h>
+#include <linux/fs.h>
+#include <linux/mutex.h>
+#include <linux/cpu.h>
+#include <linux/firmware.h>
+#include <linux/platform_device.h>
+
+#include <asm/msr.h>
+#include <asm/uaccess.h>
+#include <asm/processor.h>
+#include <asm/microcode.h>
+
+MODULE_DESCRIPTION("Microcode Update Driver");
+MODULE_AUTHOR("Tigran Aivazian <tigran@aivazian.fsnet.co.uk>");
+MODULE_LICENSE("GPL");
+
+#define MICROCODE_VERSION 	"2.00"
+
+struct microcode_ops *microcode_ops;
+
+/* no concurrent ->write()s are allowed on /dev/cpu/microcode */
+static DEFINE_MUTEX(microcode_mutex);
+
+struct ucode_cpu_info ucode_cpu_info[NR_CPUS];
+EXPORT_SYMBOL_GPL(ucode_cpu_info);
+
+#ifdef CONFIG_MICROCODE_OLD_INTERFACE
+static int do_microcode_update(const void __user *buf, size_t size)
+{
+	cpumask_t old;
+	int error = 0;
+	int cpu;
+
+	old = current->cpus_allowed;
+
+	for_each_online_cpu(cpu) {
+		struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+
+		if (!uci->valid)
+			continue;
+
+		set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+		error = microcode_ops->request_microcode_user(cpu, buf, size);
+		if (error < 0)
+			goto out;
+		if (!error)
+			microcode_ops->apply_microcode(cpu);
+	}
+out:
+	set_cpus_allowed_ptr(current, &old);
+	return error;
+}
+
+static int microcode_open(struct inode *unused1, struct file *unused2)
+{
+	cycle_kernel_lock();
+	return capable(CAP_SYS_RAWIO) ? 0 : -EPERM;
+}
+
+static ssize_t microcode_write(struct file *file, const char __user *buf,
+			       size_t len, loff_t *ppos)
+{
+	ssize_t ret;
+
+	if ((len >> PAGE_SHIFT) > num_physpages) {
+		printk(KERN_ERR "microcode: too much data (max %ld pages)\n",
+		       num_physpages);
+		return -EINVAL;
+	}
+
+	get_online_cpus();
+	mutex_lock(&microcode_mutex);
+
+	ret = do_microcode_update(buf, len);
+	if (!ret)
+		ret = (ssize_t)len;
+
+	mutex_unlock(&microcode_mutex);
+	put_online_cpus();
+
+	return ret;
+}
+
+static const struct file_operations microcode_fops = {
+	.owner		= THIS_MODULE,
+	.write		= microcode_write,
+	.open		= microcode_open,
+};
+
+static struct miscdevice microcode_dev = {
+	.minor		= MICROCODE_MINOR,
+	.name		= "microcode",
+	.fops		= &microcode_fops,
+};
+
+static int __init microcode_dev_init(void)
+{
+	int error;
+
+	error = misc_register(&microcode_dev);
+	if (error) {
+		printk(KERN_ERR
+			"microcode: can't misc_register on minor=%d\n",
+			MICROCODE_MINOR);
+		return error;
+	}
+
+	return 0;
+}
+
+static void microcode_dev_exit(void)
+{
+	misc_deregister(&microcode_dev);
+}
+
+MODULE_ALIAS_MISCDEV(MICROCODE_MINOR);
+#else
+#define microcode_dev_init() 0
+#define microcode_dev_exit() do { } while (0)
+#endif
+
+/* fake device for request_firmware */
+struct platform_device *microcode_pdev;
+
+static ssize_t reload_store(struct sys_device *dev,
+			    struct sysdev_attribute *attr,
+			    const char *buf, size_t sz)
+{
+	struct ucode_cpu_info *uci = ucode_cpu_info + dev->id;
+	char *end;
+	unsigned long val = simple_strtoul(buf, &end, 0);
+	int err = 0;
+	int cpu = dev->id;
+
+	if (end == buf)
+		return -EINVAL;
+	if (val == 1) {
+		cpumask_t old = current->cpus_allowed;
+
+		get_online_cpus();
+		if (cpu_online(cpu)) {
+			set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+			mutex_lock(&microcode_mutex);
+			if (uci->valid) {
+				err = microcode_ops->request_microcode_fw(cpu,
+						&microcode_pdev->dev);
+				if (!err)
+					microcode_ops->apply_microcode(cpu);
+			}
+			mutex_unlock(&microcode_mutex);
+			set_cpus_allowed_ptr(current, &old);
+		}
+		put_online_cpus();
+	}
+	if (err)
+		return err;
+	return sz;
+}
+
+static ssize_t version_show(struct sys_device *dev,
+			struct sysdev_attribute *attr, char *buf)
+{
+	struct ucode_cpu_info *uci = ucode_cpu_info + dev->id;
+
+	return sprintf(buf, "0x%x\n", uci->cpu_sig.rev);
+}
+
+static ssize_t pf_show(struct sys_device *dev,
+			struct sysdev_attribute *attr, char *buf)
+{
+	struct ucode_cpu_info *uci = ucode_cpu_info + dev->id;
+
+	return sprintf(buf, "0x%x\n", uci->cpu_sig.pf);
+}
+
+static SYSDEV_ATTR(reload, 0200, NULL, reload_store);
+static SYSDEV_ATTR(version, 0400, version_show, NULL);
+static SYSDEV_ATTR(processor_flags, 0400, pf_show, NULL);
+
+static struct attribute *mc_default_attrs[] = {
+	&attr_reload.attr,
+	&attr_version.attr,
+	&attr_processor_flags.attr,
+	NULL
+};
+
+static struct attribute_group mc_attr_group = {
+	.attrs = mc_default_attrs,
+	.name = "microcode",
+};
+
+static void microcode_fini_cpu(int cpu)
+{
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+
+	mutex_lock(&microcode_mutex);
+	microcode_ops->microcode_fini_cpu(cpu);
+	uci->valid = 0;
+	mutex_unlock(&microcode_mutex);
+}
+
+static void collect_cpu_info(int cpu)
+{
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+
+	memset(uci, 0, sizeof(*uci));
+	if (!microcode_ops->collect_cpu_info(cpu, &uci->cpu_sig))
+		uci->valid = 1;
+}
+
+static int microcode_resume_cpu(int cpu)
+{
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	struct cpu_signature nsig;
+
+	pr_debug("microcode: CPU%d resumed\n", cpu);
+
+	if (!uci->mc)
+		return 1;
+
+	/*
+	 * Let's verify that the 'cached' ucode does belong
+	 * to this cpu (a bit of paranoia):
+	 */
+	if (microcode_ops->collect_cpu_info(cpu, &nsig)) {
+		microcode_fini_cpu(cpu);
+		return -1;
+	}
+
+	if (memcmp(&nsig, &uci->cpu_sig, sizeof(nsig))) {
+		microcode_fini_cpu(cpu);
+		/* Should we look for a new ucode here? */
+		return 1;
+	}
+
+	return 0;
+}
+
+void microcode_update_cpu(int cpu)
+{
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	int err = 0;
+
+	/*
+	 * Check if the system resume is in progress (uci->valid != NULL),
+	 * otherwise just request a firmware:
+	 */
+	if (uci->valid) {
+		err = microcode_resume_cpu(cpu);
+	} else {	
+		collect_cpu_info(cpu);
+		if (uci->valid && system_state == SYSTEM_RUNNING)
+			err = microcode_ops->request_microcode_fw(cpu,
+					&microcode_pdev->dev);
+	}
+	if (!err)
+		microcode_ops->apply_microcode(cpu);
+}
+
+static void microcode_init_cpu(int cpu)
+{
+	cpumask_t old = current->cpus_allowed;
+
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	/* We should bind the task to the CPU */
+	BUG_ON(raw_smp_processor_id() != cpu);
+
+	mutex_lock(&microcode_mutex);
+	microcode_update_cpu(cpu);
+	mutex_unlock(&microcode_mutex);
+
+	set_cpus_allowed_ptr(current, &old);
+}
+
+static int mc_sysdev_add(struct sys_device *sys_dev)
+{
+	int err, cpu = sys_dev->id;
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+
+	if (!cpu_online(cpu))
+		return 0;
+
+	pr_debug("microcode: CPU%d added\n", cpu);
+	memset(uci, 0, sizeof(*uci));
+
+	err = sysfs_create_group(&sys_dev->kobj, &mc_attr_group);
+	if (err)
+		return err;
+
+	microcode_init_cpu(cpu);
+	return 0;
+}
+
+static int mc_sysdev_remove(struct sys_device *sys_dev)
+{
+	int cpu = sys_dev->id;
+
+	if (!cpu_online(cpu))
+		return 0;
+
+	pr_debug("microcode: CPU%d removed\n", cpu);
+	microcode_fini_cpu(cpu);
+	sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
+	return 0;
+}
+
+static int mc_sysdev_resume(struct sys_device *dev)
+{
+	int cpu = dev->id;
+
+	if (!cpu_online(cpu))
+		return 0;
+
+	/* only CPU 0 will apply ucode here */
+	microcode_update_cpu(0);
+	return 0;
+}
+
+static struct sysdev_driver mc_sysdev_driver = {
+	.add = mc_sysdev_add,
+	.remove = mc_sysdev_remove,
+	.resume = mc_sysdev_resume,
+};
+
+static __cpuinit int
+mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (unsigned long)hcpu;
+	struct sys_device *sys_dev;
+
+	sys_dev = get_cpu_sysdev(cpu);
+	switch (action) {
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		microcode_init_cpu(cpu);
+	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
+		pr_debug("microcode: CPU%d added\n", cpu);
+		if (sysfs_create_group(&sys_dev->kobj, &mc_attr_group))
+			printk(KERN_ERR "microcode: Failed to create the sysfs "
+				"group for CPU%d\n", cpu);
+		break;
+	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
+		/* Suspend is in progress, only remove the interface */
+		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
+		pr_debug("microcode: CPU%d removed\n", cpu);
+		break;
+	case CPU_DEAD:
+	case CPU_UP_CANCELED_FROZEN:
+		/* The CPU refused to come up during a system resume */
+		microcode_fini_cpu(cpu);
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __refdata mc_cpu_notifier = {
+	.notifier_call = mc_cpu_callback,
+};
+
+static int __init microcode_init(void)
+{
+	struct cpuinfo_x86 *c = &cpu_data(0);
+	int error;
+
+	if (c->x86_vendor == X86_VENDOR_INTEL)
+		microcode_ops = init_intel_microcode();
+	else if (c->x86_vendor == X86_VENDOR_AMD)
+		microcode_ops = init_amd_microcode();
+
+	if (!microcode_ops) {
+		printk(KERN_ERR "microcode: no support for this CPU vendor\n");
+		return -ENODEV;
+	}
+
+	error = microcode_dev_init();
+	if (error)
+		return error;
+	microcode_pdev = platform_device_register_simple("microcode", -1,
+							 NULL, 0);
+	if (IS_ERR(microcode_pdev)) {
+		microcode_dev_exit();
+		return PTR_ERR(microcode_pdev);
+	}
+
+	get_online_cpus();
+	error = sysdev_driver_register(&cpu_sysdev_class, &mc_sysdev_driver);
+	put_online_cpus();
+	if (error) {
+		microcode_dev_exit();
+		platform_device_unregister(microcode_pdev);
+		return error;
+	}
+
+	register_hotcpu_notifier(&mc_cpu_notifier);
+
+	printk(KERN_INFO
+	       "Microcode Update Driver: v" MICROCODE_VERSION
+	       " <tigran@aivazian.fsnet.co.uk>"
+	       " <peter.oruba@amd.com>\n");
+
+	return 0;
+}
+
+static void __exit microcode_exit(void)
+{
+	microcode_dev_exit();
+
+	unregister_hotcpu_notifier(&mc_cpu_notifier);
+
+	get_online_cpus();
+	sysdev_driver_unregister(&cpu_sysdev_class, &mc_sysdev_driver);
+	put_online_cpus();
+
+	platform_device_unregister(microcode_pdev);
+
+	microcode_ops = NULL;
+
+	printk(KERN_INFO
+	       "Microcode Update Driver: v" MICROCODE_VERSION " removed.\n");
+}
+
+module_init(microcode_init);
+module_exit(microcode_exit);
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
new file mode 100644
index 0000000..622dc4a
--- /dev/null
+++ b/arch/x86/kernel/microcode_intel.c
@@ -0,0 +1,480 @@
+/*
+ *	Intel CPU Microcode Update Driver for Linux
+ *
+ *	Copyright (C) 2000-2006 Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
+ *		      2006	Shaohua Li <shaohua.li@intel.com>
+ *
+ *	This driver allows to upgrade microcode on Intel processors
+ *	belonging to IA-32 family - PentiumPro, Pentium II,
+ *	Pentium III, Xeon, Pentium 4, etc.
+ *
+ *	Reference: Section 8.11 of Volume 3a, IA-32 Intel? Architecture
+ *	Software Developer's Manual
+ *	Order Number 253668 or free download from:
+ *
+ *	http://developer.intel.com/design/pentium4/manuals/253668.htm
+ *
+ *	For more information, go to http://www.urbanmyth.org/microcode
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
+ *
+ *	1.0	16 Feb 2000, Tigran Aivazian <tigran@sco.com>
+ *		Initial release.
+ *	1.01	18 Feb 2000, Tigran Aivazian <tigran@sco.com>
+ *		Added read() support + cleanups.
+ *	1.02	21 Feb 2000, Tigran Aivazian <tigran@sco.com>
+ *		Added 'device trimming' support. open(O_WRONLY) zeroes
+ *		and frees the saved copy of applied microcode.
+ *	1.03	29 Feb 2000, Tigran Aivazian <tigran@sco.com>
+ *		Made to use devfs (/dev/cpu/microcode) + cleanups.
+ *	1.04	06 Jun 2000, Simon Trimmer <simon@veritas.com>
+ *		Added misc device support (now uses both devfs and misc).
+ *		Added MICROCODE_IOCFREE ioctl to clear memory.
+ *	1.05	09 Jun 2000, Simon Trimmer <simon@veritas.com>
+ *		Messages for error cases (non Intel & no suitable microcode).
+ *	1.06	03 Aug 2000, Tigran Aivazian <tigran@veritas.com>
+ *		Removed ->release(). Removed exclusive open and status bitmap.
+ *		Added microcode_rwsem to serialize read()/write()/ioctl().
+ *		Removed global kernel lock usage.
+ *	1.07	07 Sep 2000, Tigran Aivazian <tigran@veritas.com>
+ *		Write 0 to 0x8B msr and then cpuid before reading revision,
+ *		so that it works even if there were no update done by the
+ *		BIOS. Otherwise, reading from 0x8B gives junk (which happened
+ *		to be 0 on my machine which is why it worked even when I
+ *		disabled update by the BIOS)
+ *		Thanks to Eric W. Biederman <ebiederman@lnxi.com> for the fix.
+ *	1.08	11 Dec 2000, Richard Schaal <richard.schaal@intel.com> and
+ *			     Tigran Aivazian <tigran@veritas.com>
+ *		Intel Pentium 4 processor support and bugfixes.
+ *	1.09	30 Oct 2001, Tigran Aivazian <tigran@veritas.com>
+ *		Bugfix for HT (Hyper-Threading) enabled processors
+ *		whereby processor resources are shared by all logical processors
+ *		in a single CPU package.
+ *	1.10	28 Feb 2002 Asit K Mallick <asit.k.mallick@intel.com> and
+ *		Tigran Aivazian <tigran@veritas.com>,
+ *		Serialize updates as required on HT processors due to
+ *		speculative nature of implementation.
+ *	1.11	22 Mar 2002 Tigran Aivazian <tigran@veritas.com>
+ *		Fix the panic when writing zero-length microcode chunk.
+ *	1.12	29 Sep 2003 Nitin Kamble <nitin.a.kamble@intel.com>,
+ *		Jun Nakajima <jun.nakajima@intel.com>
+ *		Support for the microcode updates in the new format.
+ *	1.13	10 Oct 2003 Tigran Aivazian <tigran@veritas.com>
+ *		Removed ->read() method and obsoleted MICROCODE_IOCFREE ioctl
+ *		because we no longer hold a copy of applied microcode
+ *		in kernel memory.
+ *	1.14	25 Jun 2004 Tigran Aivazian <tigran@veritas.com>
+ *		Fix sigmatch() macro to handle old CPUs with pf == 0.
+ *		Thanks to Stuart Swales for pointing out this bug.
+ */
+#include <linux/capability.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/smp_lock.h>
+#include <linux/cpumask.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/miscdevice.h>
+#include <linux/spinlock.h>
+#include <linux/mm.h>
+#include <linux/fs.h>
+#include <linux/mutex.h>
+#include <linux/cpu.h>
+#include <linux/firmware.h>
+#include <linux/platform_device.h>
+
+#include <asm/msr.h>
+#include <asm/uaccess.h>
+#include <asm/processor.h>
+#include <asm/microcode.h>
+
+MODULE_DESCRIPTION("Microcode Update Driver");
+MODULE_AUTHOR("Tigran Aivazian <tigran@aivazian.fsnet.co.uk>");
+MODULE_LICENSE("GPL");
+
+struct microcode_header_intel {
+	unsigned int            hdrver;
+	unsigned int            rev;
+	unsigned int            date;
+	unsigned int            sig;
+	unsigned int            cksum;
+	unsigned int            ldrver;
+	unsigned int            pf;
+	unsigned int            datasize;
+	unsigned int            totalsize;
+	unsigned int            reserved[3];
+};
+
+struct microcode_intel {
+	struct microcode_header_intel hdr;
+	unsigned int            bits[0];
+};
+
+/* microcode format is extended from prescott processors */
+struct extended_signature {
+	unsigned int            sig;
+	unsigned int            pf;
+	unsigned int            cksum;
+};
+
+struct extended_sigtable {
+	unsigned int            count;
+	unsigned int            cksum;
+	unsigned int            reserved[3];
+	struct extended_signature sigs[0];
+};
+
+#define DEFAULT_UCODE_DATASIZE 	(2000)
+#define MC_HEADER_SIZE		(sizeof(struct microcode_header_intel))
+#define DEFAULT_UCODE_TOTALSIZE (DEFAULT_UCODE_DATASIZE + MC_HEADER_SIZE)
+#define EXT_HEADER_SIZE		(sizeof(struct extended_sigtable))
+#define EXT_SIGNATURE_SIZE	(sizeof(struct extended_signature))
+#define DWSIZE			(sizeof(u32))
+#define get_totalsize(mc) \
+	(((struct microcode_intel *)mc)->hdr.totalsize ? \
+	 ((struct microcode_intel *)mc)->hdr.totalsize : \
+	 DEFAULT_UCODE_TOTALSIZE)
+
+#define get_datasize(mc) \
+	(((struct microcode_intel *)mc)->hdr.datasize ? \
+	 ((struct microcode_intel *)mc)->hdr.datasize : DEFAULT_UCODE_DATASIZE)
+
+#define sigmatch(s1, s2, p1, p2) \
+	(((s1) == (s2)) && (((p1) & (p2)) || (((p1) == 0) && ((p2) == 0))))
+
+#define exttable_size(et) ((et)->count * EXT_SIGNATURE_SIZE + EXT_HEADER_SIZE)
+
+/* serialize access to the physical write to MSR 0x79 */
+static DEFINE_SPINLOCK(microcode_update_lock);
+
+static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
+{
+	struct cpuinfo_x86 *c = &cpu_data(cpu_num);
+	unsigned int val[2];
+
+	memset(csig, 0, sizeof(*csig));
+
+	if (c->x86_vendor != X86_VENDOR_INTEL || c->x86 < 6 ||
+	    cpu_has(c, X86_FEATURE_IA64)) {
+		printk(KERN_ERR "microcode: CPU%d not a capable Intel "
+			"processor\n", cpu_num);
+		return -1;
+	}
+
+	csig->sig = cpuid_eax(0x00000001);
+
+	if ((c->x86_model >= 5) || (c->x86 > 6)) {
+		/* get processor flags from MSR 0x17 */
+		rdmsr(MSR_IA32_PLATFORM_ID, val[0], val[1]);
+		csig->pf = 1 << ((val[1] >> 18) & 7);
+	}
+
+	wrmsr(MSR_IA32_UCODE_REV, 0, 0);
+	/* see notes above for revision 1.07.  Apparent chip bug */
+	sync_core();
+	/* get the current revision from MSR 0x8B */
+	rdmsr(MSR_IA32_UCODE_REV, val[0], csig->rev);
+	pr_debug("microcode: collect_cpu_info : sig=0x%x, pf=0x%x, rev=0x%x\n",
+			csig->sig, csig->pf, csig->rev);
+
+	return 0;
+}
+
+static inline int update_match_cpu(struct cpu_signature *csig, int sig, int pf)
+{
+	return (!sigmatch(sig, csig->sig, pf, csig->pf)) ? 0 : 1;
+}
+
+static inline int 
+update_match_revision(struct microcode_header_intel *mc_header,	int rev)
+{
+	return (mc_header->rev <= rev) ? 0 : 1;
+}
+
+static int microcode_sanity_check(void *mc)
+{
+	struct microcode_header_intel *mc_header = mc;
+	struct extended_sigtable *ext_header = NULL;
+	struct extended_signature *ext_sig;
+	unsigned long total_size, data_size, ext_table_size;
+	int sum, orig_sum, ext_sigcount = 0, i;
+
+	total_size = get_totalsize(mc_header);
+	data_size = get_datasize(mc_header);
+	if (data_size + MC_HEADER_SIZE > total_size) {
+		printk(KERN_ERR "microcode: error! "
+			"Bad data size in microcode data file\n");
+		return -EINVAL;
+	}
+
+	if (mc_header->ldrver != 1 || mc_header->hdrver != 1) {
+		printk(KERN_ERR "microcode: error! "
+			"Unknown microcode update format\n");
+		return -EINVAL;
+	}
+	ext_table_size = total_size - (MC_HEADER_SIZE + data_size);
+	if (ext_table_size) {
+		if ((ext_table_size < EXT_HEADER_SIZE)
+		 || ((ext_table_size - EXT_HEADER_SIZE) % EXT_SIGNATURE_SIZE)) {
+			printk(KERN_ERR "microcode: error! "
+				"Small exttable size in microcode data file\n");
+			return -EINVAL;
+		}
+		ext_header = mc + MC_HEADER_SIZE + data_size;
+		if (ext_table_size != exttable_size(ext_header)) {
+			printk(KERN_ERR "microcode: error! "
+				"Bad exttable size in microcode data file\n");
+			return -EFAULT;
+		}
+		ext_sigcount = ext_header->count;
+	}
+
+	/* check extended table checksum */
+	if (ext_table_size) {
+		int ext_table_sum = 0;
+		int *ext_tablep = (int *)ext_header;
+
+		i = ext_table_size / DWSIZE;
+		while (i--)
+			ext_table_sum += ext_tablep[i];
+		if (ext_table_sum) {
+			printk(KERN_WARNING "microcode: aborting, "
+				"bad extended signature table checksum\n");
+			return -EINVAL;
+		}
+	}
+
+	/* calculate the checksum */
+	orig_sum = 0;
+	i = (MC_HEADER_SIZE + data_size) / DWSIZE;
+	while (i--)
+		orig_sum += ((int *)mc)[i];
+	if (orig_sum) {
+		printk(KERN_ERR "microcode: aborting, bad checksum\n");
+		return -EINVAL;
+	}
+	if (!ext_table_size)
+		return 0;
+	/* check extended signature checksum */
+	for (i = 0; i < ext_sigcount; i++) {
+		ext_sig = (void *)ext_header + EXT_HEADER_SIZE +
+			  EXT_SIGNATURE_SIZE * i;
+		sum = orig_sum
+			- (mc_header->sig + mc_header->pf + mc_header->cksum)
+			+ (ext_sig->sig + ext_sig->pf + ext_sig->cksum);
+		if (sum) {
+			printk(KERN_ERR "microcode: aborting, bad checksum\n");
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+/*
+ * return 0 - no update found
+ * return 1 - found update
+ */
+static int
+get_matching_microcode(struct cpu_signature *cpu_sig, void *mc, int rev)
+{
+	struct microcode_header_intel *mc_header = mc;
+	struct extended_sigtable *ext_header;
+	unsigned long total_size = get_totalsize(mc_header);
+	int ext_sigcount, i;
+	struct extended_signature *ext_sig;
+
+	if (!update_match_revision(mc_header, rev))
+		return 0;
+
+	if (update_match_cpu(cpu_sig, mc_header->sig, mc_header->pf))
+		return 1;
+
+	/* Look for ext. headers: */
+	if (total_size <= get_datasize(mc_header) + MC_HEADER_SIZE)
+		return 0;
+
+	ext_header = mc + get_datasize(mc_header) + MC_HEADER_SIZE;
+	ext_sigcount = ext_header->count;
+	ext_sig = (void *)ext_header + EXT_HEADER_SIZE;
+
+	for (i = 0; i < ext_sigcount; i++) {
+		if (update_match_cpu(cpu_sig, ext_sig->sig, ext_sig->pf))
+			return 1;
+		ext_sig++;
+	}
+	return 0;
+}
+
+static void apply_microcode(int cpu)
+{
+	unsigned long flags;
+	unsigned int val[2];
+	int cpu_num = raw_smp_processor_id();
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	struct microcode_intel *mc_intel = uci->mc;
+
+	/* We should bind the task to the CPU */
+	BUG_ON(cpu_num != cpu);
+
+	if (mc_intel == NULL)
+		return;
+
+	/* serialize access to the physical write to MSR 0x79 */
+	spin_lock_irqsave(&microcode_update_lock, flags);
+
+	/* write microcode via MSR 0x79 */
+	wrmsr(MSR_IA32_UCODE_WRITE,
+	      (unsigned long) mc_intel->bits,
+	      (unsigned long) mc_intel->bits >> 16 >> 16);
+	wrmsr(MSR_IA32_UCODE_REV, 0, 0);
+
+	/* see notes above for revision 1.07.  Apparent chip bug */
+	sync_core();
+
+	/* get the current revision from MSR 0x8B */
+	rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
+
+	spin_unlock_irqrestore(&microcode_update_lock, flags);
+	if (val[1] != mc_intel->hdr.rev) {
+		printk(KERN_ERR "microcode: CPU%d update from revision "
+			"0x%x to 0x%x failed\n", cpu_num, uci->cpu_sig.rev, val[1]);
+		return;
+	}
+	printk(KERN_INFO "microcode: CPU%d updated from revision "
+	       "0x%x to 0x%x, date = %04x-%02x-%02x \n",
+		cpu_num, uci->cpu_sig.rev, val[1],
+		mc_intel->hdr.date & 0xffff,
+		mc_intel->hdr.date >> 24,
+		(mc_intel->hdr.date >> 16) & 0xff);
+	uci->cpu_sig.rev = val[1];
+}
+
+static int generic_load_microcode(int cpu, void *data, size_t size,
+		int (*get_ucode_data)(void *, const void *, size_t))
+{
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	u8 *ucode_ptr = data, *new_mc = NULL, *mc;
+	int new_rev = uci->cpu_sig.rev;
+	unsigned int leftover = size;
+
+	while (leftover) {
+		struct microcode_header_intel mc_header;
+		unsigned int mc_size;
+
+		if (get_ucode_data(&mc_header, ucode_ptr, sizeof(mc_header)))
+			break;
+
+		mc_size = get_totalsize(&mc_header);
+		if (!mc_size || mc_size > leftover) {
+			printk(KERN_ERR "microcode: error!"
+					"Bad data in microcode data file\n");
+			break;
+		}
+
+		mc = vmalloc(mc_size);
+		if (!mc)
+			break;
+
+		if (get_ucode_data(mc, ucode_ptr, mc_size) ||
+		    microcode_sanity_check(mc) < 0) {
+			vfree(mc);
+			break;
+		}
+
+		if (get_matching_microcode(&uci->cpu_sig, mc, new_rev)) {
+			if (new_mc)
+				vfree(new_mc);
+			new_rev = mc_header.rev;
+			new_mc  = mc;
+		} else
+			vfree(mc);
+
+		ucode_ptr += mc_size;
+		leftover  -= mc_size;
+	}
+
+	if (new_mc) {
+		if (!leftover) {
+			if (uci->mc)
+				vfree(uci->mc);
+			uci->mc = (struct microcode_intel *)new_mc;
+			pr_debug("microcode: CPU%d found a matching microcode update with"
+				 " version 0x%x (current=0x%x)\n",
+				cpu, new_rev, uci->cpu_sig.rev);
+		} else
+			vfree(new_mc);
+	}
+
+	return (int)leftover;
+}
+
+static int get_ucode_fw(void *to, const void *from, size_t n)
+{
+	memcpy(to, from, n);
+	return 0;
+}
+
+static int request_microcode_fw(int cpu, struct device *device)
+{
+	char name[30];
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	const struct firmware *firmware;
+	int ret;
+
+	/* We should bind the task to the CPU */
+	BUG_ON(cpu != raw_smp_processor_id());
+	sprintf(name, "intel-ucode/%02x-%02x-%02x",
+		c->x86, c->x86_model, c->x86_mask);
+	ret = request_firmware(&firmware, name, device);
+	if (ret) {
+		pr_debug("microcode: data file %s load failed\n", name);
+		return ret;
+	}
+
+	ret = generic_load_microcode(cpu, (void*)firmware->data, firmware->size,
+			&get_ucode_fw);
+
+	release_firmware(firmware);
+
+	return ret;
+}
+
+static int get_ucode_user(void *to, const void *from, size_t n)
+{
+	return copy_from_user(to, from, n);
+}
+
+static int request_microcode_user(int cpu, const void __user *buf, size_t size)
+{
+	/* We should bind the task to the CPU */
+	BUG_ON(cpu != raw_smp_processor_id());
+
+	return generic_load_microcode(cpu, (void*)buf, size, &get_ucode_user);
+}
+
+static void microcode_fini_cpu(int cpu)
+{
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+
+	vfree(uci->mc);
+	uci->mc = NULL;
+}
+
+struct microcode_ops microcode_intel_ops = {
+	.request_microcode_user		  = request_microcode_user,
+	.request_microcode_fw             = request_microcode_fw,
+	.collect_cpu_info                 = collect_cpu_info,
+	.apply_microcode                  = apply_microcode,
+	.microcode_fini_cpu               = microcode_fini_cpu,
+};
+
+struct microcode_ops * __init init_intel_microcode(void)
+{
+	return &microcode_intel_ops;
+}
+
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index e3599a4..6133530 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -582,6 +582,190 @@ static struct x86_quirks default_x86_quirks __initdata;
 struct x86_quirks *x86_quirks __initdata = &default_x86_quirks;
 
 /*
+ * Some BIOSes seem to corrupt the low 64k of memory during events
+ * like suspend/resume and unplugging an HDMI cable.  Reserve all
+ * remaining free memory in that area and fill it with a distinct
+ * pattern.
+ */
+#ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
+#define MAX_SCAN_AREAS	8
+
+static int __read_mostly memory_corruption_check = -1;
+
+static unsigned __read_mostly corruption_check_size = 64*1024;
+static unsigned __read_mostly corruption_check_period = 60; /* seconds */
+
+static struct e820entry scan_areas[MAX_SCAN_AREAS];
+static int num_scan_areas;
+
+
+static int set_corruption_check(char *arg)
+{
+	char *end;
+
+	memory_corruption_check = simple_strtol(arg, &end, 10);
+
+	return (*end == 0) ? 0 : -EINVAL;
+}
+early_param("memory_corruption_check", set_corruption_check);
+
+static int set_corruption_check_period(char *arg)
+{
+	char *end;
+
+	corruption_check_period = simple_strtoul(arg, &end, 10);
+
+	return (*end == 0) ? 0 : -EINVAL;
+}
+early_param("memory_corruption_check_period", set_corruption_check_period);
+
+static int set_corruption_check_size(char *arg)
+{
+	char *end;
+	unsigned size;
+
+	size = memparse(arg, &end);
+
+	if (*end == '\0')
+		corruption_check_size = size;
+
+	return (size == corruption_check_size) ? 0 : -EINVAL;
+}
+early_param("memory_corruption_check_size", set_corruption_check_size);
+
+
+static void __init setup_bios_corruption_check(void)
+{
+	u64 addr = PAGE_SIZE;	/* assume first page is reserved anyway */
+
+	if (memory_corruption_check == -1) {
+		memory_corruption_check =
+#ifdef CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK
+			1
+#else
+			0
+#endif
+			;
+	}
+
+	if (corruption_check_size == 0)
+		memory_corruption_check = 0;
+
+	if (!memory_corruption_check)
+		return;
+
+	corruption_check_size = round_up(corruption_check_size, PAGE_SIZE);
+
+	while(addr < corruption_check_size && num_scan_areas < MAX_SCAN_AREAS) {
+		u64 size;
+		addr = find_e820_area_size(addr, &size, PAGE_SIZE);
+
+		if (addr == 0)
+			break;
+
+		if ((addr + size) > corruption_check_size)
+			size = corruption_check_size - addr;
+
+		if (size == 0)
+			break;
+
+		e820_update_range(addr, size, E820_RAM, E820_RESERVED);
+		scan_areas[num_scan_areas].addr = addr;
+		scan_areas[num_scan_areas].size = size;
+		num_scan_areas++;
+
+		/* Assume we've already mapped this early memory */
+		memset(__va(addr), 0, size);
+
+		addr += size;
+	}
+
+	printk(KERN_INFO "Scanning %d areas for low memory corruption\n",
+	       num_scan_areas);
+	update_e820();
+}
+
+static struct timer_list periodic_check_timer;
+
+void check_for_bios_corruption(void)
+{
+	int i;
+	int corruption = 0;
+
+	if (!memory_corruption_check)
+		return;
+
+	for(i = 0; i < num_scan_areas; i++) {
+		unsigned long *addr = __va(scan_areas[i].addr);
+		unsigned long size = scan_areas[i].size;
+
+		for(; size; addr++, size -= sizeof(unsigned long)) {
+			if (!*addr)
+				continue;
+			printk(KERN_ERR "Corrupted low memory at %p (%lx phys) = %08lx\n",
+			       addr, __pa(addr), *addr);
+			corruption = 1;
+			*addr = 0;
+		}
+	}
+
+	WARN(corruption, KERN_ERR "Memory corruption detected in low memory\n");
+}
+
+static void periodic_check_for_corruption(unsigned long data)
+{
+	check_for_bios_corruption();
+	mod_timer(&periodic_check_timer, round_jiffies(jiffies + corruption_check_period*HZ));
+}
+
+void start_periodic_check_for_corruption(void)
+{
+	if (!memory_corruption_check || corruption_check_period == 0)
+		return;
+
+	printk(KERN_INFO "Scanning for low memory corruption every %d seconds\n",
+	       corruption_check_period);
+
+	init_timer(&periodic_check_timer);
+	periodic_check_timer.function = &periodic_check_for_corruption;
+	periodic_check_for_corruption(0);
+}
+#endif
+
+static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
+{
+	printk(KERN_NOTICE
+		"%s detected: BIOS may corrupt low RAM, working it around.\n",
+		d->ident);
+
+	e820_update_range(0, 0x10000, E820_RAM, E820_RESERVED);
+	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+
+	return 0;
+}
+
+/* List of systems that have known low memory corruption BIOS problems */
+static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
+#ifdef CONFIG_X86_RESERVE_LOW_64K
+	{
+		.callback = dmi_low_memory_corruption,
+		.ident = "AMI BIOS",
+		.matches = {
+			DMI_MATCH(DMI_BIOS_VENDOR, "American Megatrends Inc."),
+		},
+	},
+	{
+		.callback = dmi_low_memory_corruption,
+		.ident = "Phoenix BIOS",
+		.matches = {
+			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies, LTD"),
+		},
+	},
+#endif
+	{}
+};
+
+/*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
  * for initialization.  Note, the efi init code path is determined by the
@@ -715,6 +899,10 @@ void __init setup_arch(char **cmdline_p)
 
 	finish_e820_parsing();
 
+	dmi_scan_machine();
+
+	dmi_check_system(bad_bios_dmi_table);
+
 #ifdef CONFIG_X86_32
 	probe_roms();
 #endif
@@ -771,6 +959,10 @@ void __init setup_arch(char **cmdline_p)
 	high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
 #endif
 
+#ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
+	setup_bios_corruption_check();
+#endif
+
 	/* max_pfn_mapped is updated here */
 	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
 	max_pfn_mapped = max_low_pfn_mapped;
@@ -799,8 +991,6 @@ void __init setup_arch(char **cmdline_p)
 	vsmp_init();
 #endif
 
-	dmi_scan_machine();
-
 	io_delay_init();
 
 	/*
@@ -909,3 +1099,5 @@ void __init setup_arch(char **cmdline_p)
 #endif
 #endif
 }
+
+
diff --git a/arch/x86/kernel/time_32.c b/arch/x86/kernel/time_32.c
index bbecf8b..77b400f 100644
--- a/arch/x86/kernel/time_32.c
+++ b/arch/x86/kernel/time_32.c
@@ -47,10 +47,9 @@ unsigned long profile_pc(struct pt_regs *regs)
 	unsigned long pc = instruction_pointer(regs);
 
 #ifdef CONFIG_SMP
-	if (!v8086_mode(regs) && SEGMENT_IS_KERNEL_CODE(regs->cs) &&
-	    in_lock_functions(pc)) {
+	if (!user_mode_vm(regs) && in_lock_functions(pc)) {
 #ifdef CONFIG_FRAME_POINTER
-		return *(unsigned long *)(regs->bp + 4);
+		return *(unsigned long *)(regs->bp + sizeof(long));
 #else
 		unsigned long *sp = (unsigned long *)&regs->sp;
 
@@ -95,6 +94,7 @@ irqreturn_t timer_interrupt(int irq, void *dev_id)
 
 	do_timer_interrupt_hook();
 
+#ifdef CONFIG_MCA
 	if (MCA_bus) {
 		/* The PS/2 uses level-triggered interrupts.  You can't
 		turn them off, nor would you want to (any attempt to
@@ -108,6 +108,7 @@ irqreturn_t timer_interrupt(int irq, void *dev_id)
 		u8 irq_v = inb_p( 0x61 );	/* read the current state */
 		outb_p( irq_v|0x80, 0x61 );	/* reset the IRQ */
 	}
+#endif
 
 	return IRQ_HANDLED;
 }
diff --git a/arch/x86/kernel/time_64.c b/arch/x86/kernel/time_64.c
index e3d49c5..cb19d65 100644
--- a/arch/x86/kernel/time_64.c
+++ b/arch/x86/kernel/time_64.c
@@ -16,6 +16,7 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/time.h>
+#include <linux/mca.h>
 
 #include <asm/i8253.h>
 #include <asm/hpet.h>
@@ -33,23 +34,34 @@ unsigned long profile_pc(struct pt_regs *regs)
 	/* Assume the lock function has either no stack frame or a copy
 	   of flags from PUSHF
 	   Eflags always has bits 22 and up cleared unlike kernel addresses. */
-	if (!user_mode(regs) && in_lock_functions(pc)) {
+	if (!user_mode_vm(regs) && in_lock_functions(pc)) {
+#ifdef CONFIG_FRAME_POINTER
+		return *(unsigned long *)(regs->bp + sizeof(long));
+#else
 		unsigned long *sp = (unsigned long *)regs->sp;
 		if (sp[0] >> 22)
 			return sp[0];
 		if (sp[1] >> 22)
 			return sp[1];
+#endif
 	}
 	return pc;
 }
 EXPORT_SYMBOL(profile_pc);
 
-static irqreturn_t timer_event_interrupt(int irq, void *dev_id)
+irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
 	add_pda(irq0_irqs, 1);
 
 	global_clock_event->event_handler(global_clock_event);
 
+#ifdef CONFIG_MCA
+	if (MCA_bus) {
+		u8 irq_v = inb_p(0x61);       /* read the current state */
+		outb_p(irq_v|0x80, 0x61);     /* reset the IRQ */
+	}
+#endif
+
 	return IRQ_HANDLED;
 }
 
@@ -100,7 +112,7 @@ unsigned long __init calibrate_cpu(void)
 }
 
 static struct irqaction irq0 = {
-	.handler	= timer_event_interrupt,
+	.handler	= timer_interrupt,
 	.flags		= IRQF_DISABLED | IRQF_IRQPOLL | IRQF_NOBALANCING,
 	.mask		= CPU_MASK_NONE,
 	.name		= "timer"
@@ -111,16 +123,13 @@ void __init hpet_time_init(void)
 	if (!hpet_enable())
 		setup_pit_timer();
 
+	irq0.mask = cpumask_of_cpu(0);
 	setup_irq(0, &irq0);
 }
 
 void __init time_init(void)
 {
 	tsc_init();
-	if (cpu_has(&boot_cpu_data, X86_FEATURE_RDTSCP))
-		vgetcpu_mode = VGETCPU_RDTSCP;
-	else
-		vgetcpu_mode = VGETCPU_LSL;
 
 	late_time_init = choose_time_init();
 }
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index ffb131f..e062974 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -429,43 +429,6 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 	printk(KERN_EMERG "Dazed and confused, but trying to continue\n");
 }
 
-#ifdef CONFIG_X86_32
-static DEFINE_SPINLOCK(nmi_print_lock);
-
-void notrace __kprobes die_nmi(char *str, struct pt_regs *regs, int do_panic)
-{
-	if (notify_die(DIE_NMIWATCHDOG, str, regs, 0, 2, SIGINT) == NOTIFY_STOP)
-		return;
-
-	spin_lock(&nmi_print_lock);
-	/*
-	* We are in trouble anyway, lets at least try
-	* to get a message out:
-	*/
-	bust_spinlocks(1);
-	printk(KERN_EMERG "%s", str);
-	printk(" on CPU%d, ip %08lx, registers:\n",
-		smp_processor_id(), regs->ip);
-	show_registers(regs);
-	if (do_panic)
-		panic("Non maskable interrupt");
-	console_silent();
-	spin_unlock(&nmi_print_lock);
-	bust_spinlocks(0);
-
-	/*
-	 * If we are in kernel we are probably nested up pretty bad
-	 * and might aswell get out now while we still can:
-	 */
-	if (!user_mode_vm(regs)) {
-		current->thread.trap_no = 2;
-		crash_kexec(regs);
-	}
-
-	do_exit(SIGSEGV);
-}
-#endif
-
 static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 07713d6..ed5274a 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -272,7 +272,7 @@ void __cpuinit xsave_init(void)
 /*
  * setup the xstate image representing the init state
  */
-void setup_xstate_init(void)
+static void __init setup_xstate_init(void)
 {
 	init_xstate_buf = alloc_bootmem(xstate_size);
 	init_xstate_buf->i387.mxcsr = MXCSR_DEFAULT;
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index d3fc121..1dcba3a 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -970,6 +970,8 @@ void __init mem_init(void)
 	int codesize, reservedpages, datasize, initsize;
 	int tmp;
 
+	start_periodic_check_for_corruption();
+
 #ifdef CONFIG_FLATMEM
 	BUG_ON(!mem_map);
 #endif
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 747f6c9..a624017 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -905,6 +905,8 @@ void __init mem_init(void)
 {
 	long codesize, reservedpages, datasize, initsize;
 
+	start_periodic_check_for_corruption();
+
 	pci_iommu_alloc();
 
 	/* clear_bss() already clear the empty_zero_page */
diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index d3e6846..87b9ab1 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -26,7 +26,7 @@ config XEN_MAX_DOMAIN_MEMORY
 
 config XEN_SAVE_RESTORE
        bool
-       depends on PM
+       depends on XEN && PM
        default y
 
 config XEN_DEBUG_FS
@@ -35,4 +35,4 @@ config XEN_DEBUG_FS
 	default n
 	help
 	  Enable statistics output and various tuning options in debugfs.
-	  Enabling this option may incur a significant performance overhead.
\ No newline at end of file
+	  Enabling this option may incur a significant performance overhead.
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 708b8ea..7a34753 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -113,7 +113,14 @@ struct shared_info *HYPERVISOR_shared_info = (void *)&xen_dummy_shared_info;
  *
  * 0: not available, 1: available
  */
-static int have_vcpu_info_placement = 1;
+static int have_vcpu_info_placement =
+#ifdef CONFIG_X86_32
+	1
+#else
+	0
+#endif
+	;
+
 
 static void xen_vcpu_setup(int cpu)
 {
@@ -973,6 +980,7 @@ static void *xen_kmap_atomic_pte(struct page *page, enum km_type type)
 }
 #endif
 
+#ifdef CONFIG_X86_32
 static __init pte_t mask_rw_pte(pte_t *ptep, pte_t pte)
 {
 	/* If there's an existing pte, then don't allow _PAGE_RW to be set */
@@ -991,6 +999,7 @@ static __init void xen_set_pte_init(pte_t *ptep, pte_t pte)
 
 	xen_set_pte(ptep, pte);
 }
+#endif
 
 static __init void xen_pagetable_setup_start(pgd_t *base)
 {
@@ -1057,7 +1066,6 @@ void xen_setup_vcpu_info_placement(void)
 
 	/* xen_vcpu_setup managed to place the vcpu_info within the
 	   percpu area for all cpus, so make use of it */
-#ifdef CONFIG_X86_32
 	if (have_vcpu_info_placement) {
 		printk(KERN_INFO "Xen: using vcpu_info placement\n");
 
@@ -1067,7 +1075,6 @@ void xen_setup_vcpu_info_placement(void)
 		pv_irq_ops.irq_enable = xen_irq_enable_direct;
 		pv_mmu_ops.read_cr2 = xen_read_cr2_direct;
 	}
-#endif
 }
 
 static unsigned xen_patch(u8 type, u16 clobbers, void *insnbuf,
@@ -1088,12 +1095,10 @@ static unsigned xen_patch(u8 type, u16 clobbers, void *insnbuf,
 	goto patch_site
 
 	switch (type) {
-#ifdef CONFIG_X86_32
 		SITE(pv_irq_ops, irq_enable);
 		SITE(pv_irq_ops, irq_disable);
 		SITE(pv_irq_ops, save_fl);
 		SITE(pv_irq_ops, restore_fl);
-#endif /* CONFIG_X86_32 */
 #undef SITE
 
 	patch_site:
@@ -1429,48 +1434,11 @@ static void *m2v(phys_addr_t maddr)
 	return __ka(m2p(maddr));
 }
 
-#ifdef CONFIG_X86_64
-static void walk(pgd_t *pgd, unsigned long addr)
-{
-	unsigned l4idx = pgd_index(addr);
-	unsigned l3idx = pud_index(addr);
-	unsigned l2idx = pmd_index(addr);
-	unsigned l1idx = pte_index(addr);
-	pgd_t l4;
-	pud_t l3;
-	pmd_t l2;
-	pte_t l1;
-
-	xen_raw_printk("walk %p, %lx -> %d %d %d %d\n",
-		       pgd, addr, l4idx, l3idx, l2idx, l1idx);
-
-	l4 = pgd[l4idx];
-	xen_raw_printk("  l4: %016lx\n", l4.pgd);
-	xen_raw_printk("      %016lx\n", pgd_val(l4));
-
-	l3 = ((pud_t *)(m2v(l4.pgd)))[l3idx];
-	xen_raw_printk("  l3: %016lx\n", l3.pud);
-	xen_raw_printk("      %016lx\n", pud_val(l3));
-
-	l2 = ((pmd_t *)(m2v(l3.pud)))[l2idx];
-	xen_raw_printk("  l2: %016lx\n", l2.pmd);
-	xen_raw_printk("      %016lx\n", pmd_val(l2));
-
-	l1 = ((pte_t *)(m2v(l2.pmd)))[l1idx];
-	xen_raw_printk("  l1: %016lx\n", l1.pte);
-	xen_raw_printk("      %016lx\n", pte_val(l1));
-}
-#endif
-
 static void set_page_prot(void *addr, pgprot_t prot)
 {
 	unsigned long pfn = __pa(addr) >> PAGE_SHIFT;
 	pte_t pte = pfn_pte(pfn, prot);
 
-	xen_raw_printk("addr=%p pfn=%lx mfn=%lx prot=%016llx pte=%016llx\n",
-		       addr, pfn, get_phys_to_machine(pfn),
-		       pgprot_val(prot), pte.pte);
-
 	if (HYPERVISOR_update_va_mapping((unsigned long)addr, pte, 0))
 		BUG();
 }
@@ -1735,15 +1703,6 @@ asmlinkage void __init xen_start_kernel(void)
 
 	xen_raw_console_write("about to get started...\n");
 
-#if 0
-	xen_raw_printk("&boot_params=%p __pa(&boot_params)=%lx __va(__pa(&boot_params))=%lx\n",
-		       &boot_params, __pa_symbol(&boot_params),
-		       __va(__pa_symbol(&boot_params)));
-
-	walk(pgd, &boot_params);
-	walk(pgd, __va(__pa(&boot_params)));
-#endif
-
 	/* Start the world */
 #ifdef CONFIG_X86_32
 	i386_start_kernel();
diff --git a/arch/x86/xen/xen-asm_64.S b/arch/x86/xen/xen-asm_64.S
index 3b9bda4..05794c5 100644
--- a/arch/x86/xen/xen-asm_64.S
+++ b/arch/x86/xen/xen-asm_64.S
@@ -26,8 +26,15 @@
 /* Pseudo-flag used for virtual NMI, which we don't implement yet */
 #define XEN_EFLAGS_NMI	0x80000000
 
-#if 0
-#include <asm/percpu.h>
+#if 1
+/*
+	x86-64 does not yet support direct access to percpu variables
+	via a segment override, so we just need to make sure this code
+	never gets used
+ */
+#define BUG			ud2a
+#define PER_CPU_VAR(var, off)	0xdeadbeef
+#endif
 
 /*
 	Enable events.  This clears the event mask and tests the pending
@@ -35,6 +42,8 @@
 	events, then enter the hypervisor to get them handled.
  */
 ENTRY(xen_irq_enable_direct)
+	BUG
+
 	/* Unmask events */
 	movb $0, PER_CPU_VAR(xen_vcpu_info, XEN_vcpu_info_mask)
 
@@ -58,6 +67,8 @@ ENDPATCH(xen_irq_enable_direct)
 	non-zero.
  */
 ENTRY(xen_irq_disable_direct)
+	BUG
+
 	movb $1, PER_CPU_VAR(xen_vcpu_info, XEN_vcpu_info_mask)
 ENDPATCH(xen_irq_disable_direct)
 	ret
@@ -74,6 +85,8 @@ ENDPATCH(xen_irq_disable_direct)
 	Xen and x86 use opposite senses (mask vs enable).
  */
 ENTRY(xen_save_fl_direct)
+	BUG
+
 	testb $0xff, PER_CPU_VAR(xen_vcpu_info, XEN_vcpu_info_mask)
 	setz %ah
 	addb %ah,%ah
@@ -91,6 +104,8 @@ ENDPATCH(xen_save_fl_direct)
 	if so.
  */
 ENTRY(xen_restore_fl_direct)
+	BUG
+
 	testb $X86_EFLAGS_IF>>8, %ah
 	setz PER_CPU_VAR(xen_vcpu_info, XEN_vcpu_info_mask)
 	/* Preempt here doesn't matter because that will deal with
@@ -133,7 +148,6 @@ check_events:
 	pop %rcx
 	pop %rax
 	ret
-#endif
 
 ENTRY(xen_adjust_exception_frame)
 	mov 8+0(%rsp),%rcx
diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 273a944..bf6d355 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -254,6 +254,7 @@ static char *pm_verb(int event)
 
 static void pm_dev_dbg(struct device *dev, pm_message_t state, char *info)
 {
+	check_for_bios_corruption();
 	dev_dbg(dev, "%s%s%s\n", info, pm_verb(state.event),
 		((state.event & PM_EVENT_SLEEP) && device_may_wakeup(dev)) ?
 		", may wakeup" : "");
diff --git a/drivers/usb/host/ehci.h b/drivers/usb/host/ehci.h
index 5799298..b697a13 100644
--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -210,143 +210,7 @@ timer_action (struct ehci_hcd *ehci, enum ehci_timer_action action)
 
 /*-------------------------------------------------------------------------*/
 
-/* EHCI register interface, corresponds to EHCI Revision 0.95 specification */
-
-/* Section 2.2 Host Controller Capability Registers */
-struct ehci_caps {
-	/* these fields are specified as 8 and 16 bit registers,
-	 * but some hosts can't perform 8 or 16 bit PCI accesses.
-	 */
-	u32		hc_capbase;
-#define HC_LENGTH(p)		(((p)>>00)&0x00ff)	/* bits 7:0 */
-#define HC_VERSION(p)		(((p)>>16)&0xffff)	/* bits 31:16 */
-	u32		hcs_params;     /* HCSPARAMS - offset 0x4 */
-#define HCS_DEBUG_PORT(p)	(((p)>>20)&0xf)	/* bits 23:20, debug port? */
-#define HCS_INDICATOR(p)	((p)&(1 << 16))	/* true: has port indicators */
-#define HCS_N_CC(p)		(((p)>>12)&0xf)	/* bits 15:12, #companion HCs */
-#define HCS_N_PCC(p)		(((p)>>8)&0xf)	/* bits 11:8, ports per CC */
-#define HCS_PORTROUTED(p)	((p)&(1 << 7))	/* true: port routing */
-#define HCS_PPC(p)		((p)&(1 << 4))	/* true: port power control */
-#define HCS_N_PORTS(p)		(((p)>>0)&0xf)	/* bits 3:0, ports on HC */
-
-	u32		hcc_params;      /* HCCPARAMS - offset 0x8 */
-#define HCC_EXT_CAPS(p)		(((p)>>8)&0xff)	/* for pci extended caps */
-#define HCC_ISOC_CACHE(p)       ((p)&(1 << 7))  /* true: can cache isoc frame */
-#define HCC_ISOC_THRES(p)       (((p)>>4)&0x7)  /* bits 6:4, uframes cached */
-#define HCC_CANPARK(p)		((p)&(1 << 2))  /* true: can park on async qh */
-#define HCC_PGM_FRAMELISTLEN(p) ((p)&(1 << 1))  /* true: periodic_size changes*/
-#define HCC_64BIT_ADDR(p)       ((p)&(1))       /* true: can use 64-bit addr */
-	u8		portroute [8];	 /* nibbles for routing - offset 0xC */
-} __attribute__ ((packed));
-
-
-/* Section 2.3 Host Controller Operational Registers */
-struct ehci_regs {
-
-	/* USBCMD: offset 0x00 */
-	u32		command;
-/* 23:16 is r/w intr rate, in microframes; default "8" == 1/msec */
-#define CMD_PARK	(1<<11)		/* enable "park" on async qh */
-#define CMD_PARK_CNT(c)	(((c)>>8)&3)	/* how many transfers to park for */
-#define CMD_LRESET	(1<<7)		/* partial reset (no ports, etc) */
-#define CMD_IAAD	(1<<6)		/* "doorbell" interrupt async advance */
-#define CMD_ASE		(1<<5)		/* async schedule enable */
-#define CMD_PSE		(1<<4)		/* periodic schedule enable */
-/* 3:2 is periodic frame list size */
-#define CMD_RESET	(1<<1)		/* reset HC not bus */
-#define CMD_RUN		(1<<0)		/* start/stop HC */
-
-	/* USBSTS: offset 0x04 */
-	u32		status;
-#define STS_ASS		(1<<15)		/* Async Schedule Status */
-#define STS_PSS		(1<<14)		/* Periodic Schedule Status */
-#define STS_RECL	(1<<13)		/* Reclamation */
-#define STS_HALT	(1<<12)		/* Not running (any reason) */
-/* some bits reserved */
-	/* these STS_* flags are also intr_enable bits (USBINTR) */
-#define STS_IAA		(1<<5)		/* Interrupted on async advance */
-#define STS_FATAL	(1<<4)		/* such as some PCI access errors */
-#define STS_FLR		(1<<3)		/* frame list rolled over */
-#define STS_PCD		(1<<2)		/* port change detect */
-#define STS_ERR		(1<<1)		/* "error" completion (overflow, ...) */
-#define STS_INT		(1<<0)		/* "normal" completion (short, ...) */
-
-	/* USBINTR: offset 0x08 */
-	u32		intr_enable;
-
-	/* FRINDEX: offset 0x0C */
-	u32		frame_index;	/* current microframe number */
-	/* CTRLDSSEGMENT: offset 0x10 */
-	u32		segment;	/* address bits 63:32 if needed */
-	/* PERIODICLISTBASE: offset 0x14 */
-	u32		frame_list;	/* points to periodic list */
-	/* ASYNCLISTADDR: offset 0x18 */
-	u32		async_next;	/* address of next async queue head */
-
-	u32		reserved [9];
-
-	/* CONFIGFLAG: offset 0x40 */
-	u32		configured_flag;
-#define FLAG_CF		(1<<0)		/* true: we'll support "high speed" */
-
-	/* PORTSC: offset 0x44 */
-	u32		port_status [0];	/* up to N_PORTS */
-/* 31:23 reserved */
-#define PORT_WKOC_E	(1<<22)		/* wake on overcurrent (enable) */
-#define PORT_WKDISC_E	(1<<21)		/* wake on disconnect (enable) */
-#define PORT_WKCONN_E	(1<<20)		/* wake on connect (enable) */
-/* 19:16 for port testing */
-#define PORT_LED_OFF	(0<<14)
-#define PORT_LED_AMBER	(1<<14)
-#define PORT_LED_GREEN	(2<<14)
-#define PORT_LED_MASK	(3<<14)
-#define PORT_OWNER	(1<<13)		/* true: companion hc owns this port */
-#define PORT_POWER	(1<<12)		/* true: has power (see PPC) */
-#define PORT_USB11(x) (((x)&(3<<10))==(1<<10))	/* USB 1.1 device */
-/* 11:10 for detecting lowspeed devices (reset vs release ownership) */
-/* 9 reserved */
-#define PORT_RESET	(1<<8)		/* reset port */
-#define PORT_SUSPEND	(1<<7)		/* suspend port */
-#define PORT_RESUME	(1<<6)		/* resume it */
-#define PORT_OCC	(1<<5)		/* over current change */
-#define PORT_OC		(1<<4)		/* over current active */
-#define PORT_PEC	(1<<3)		/* port enable change */
-#define PORT_PE		(1<<2)		/* port enable */
-#define PORT_CSC	(1<<1)		/* connect status change */
-#define PORT_CONNECT	(1<<0)		/* device connected */
-#define PORT_RWC_BITS   (PORT_CSC | PORT_PEC | PORT_OCC)
-} __attribute__ ((packed));
-
-#define USBMODE		0x68		/* USB Device mode */
-#define USBMODE_SDIS	(1<<3)		/* Stream disable */
-#define USBMODE_BE	(1<<2)		/* BE/LE endianness select */
-#define USBMODE_CM_HC	(3<<0)		/* host controller mode */
-#define USBMODE_CM_IDLE	(0<<0)		/* idle state */
-
-/* Appendix C, Debug port ... intended for use with special "debug devices"
- * that can help if there's no serial console.  (nonstandard enumeration.)
- */
-struct ehci_dbg_port {
-	u32	control;
-#define DBGP_OWNER	(1<<30)
-#define DBGP_ENABLED	(1<<28)
-#define DBGP_DONE	(1<<16)
-#define DBGP_INUSE	(1<<10)
-#define DBGP_ERRCODE(x)	(((x)>>7)&0x07)
-#	define DBGP_ERR_BAD	1
-#	define DBGP_ERR_SIGNAL	2
-#define DBGP_ERROR	(1<<6)
-#define DBGP_GO		(1<<5)
-#define DBGP_OUT	(1<<4)
-#define DBGP_LEN(x)	(((x)>>0)&0x0f)
-	u32	pids;
-#define DBGP_PID_GET(x)		(((x)>>16)&0xff)
-#define DBGP_PID_SET(data,tok)	(((data)<<8)|(tok))
-	u32	data03;
-	u32	data47;
-	u32	address;
-#define DBGP_EPADDR(dev,ep)	(((dev)<<8)|(ep))
-} __attribute__ ((packed));
+#include <linux/usb/ehci_def.h>
 
 /*-------------------------------------------------------------------------*/
 
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 70d135e..3773d7d 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -678,7 +678,6 @@ config FB_VESA
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-	select VIDEO_SELECT
 	help
 	  This is the frame buffer device driver for generic VESA 2.0
 	  compliant graphic cards. The older VESA 1.2 cards are not supported.
@@ -1583,7 +1582,6 @@ config FB_CYBLA
 	tristate "Cyberblade/i1 support"
 	depends on FB && PCI && X86_32 && !64BIT
 	select FB_CFB_IMAGEBLIT
-	select VIDEO_SELECT
 	---help---
 	  This driver is supposed to support the Trident Cyberblade/i1
 	  graphics core integrated in the VIA VT8601A North Bridge,
diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
index 06f87b0..2f50a80 100644
--- a/drivers/video/console/Kconfig
+++ b/drivers/video/console/Kconfig
@@ -43,22 +43,6 @@ config VGACON_SOFT_SCROLLBACK_SIZE
 	 buffer.  Each 64KB will give you approximately 16 80x25
 	 screenfuls of scrollback buffer
 
-config VIDEO_SELECT
-	bool "Video mode selection support"
-	depends on  X86 && VGA_CONSOLE
-	---help---
-	  This enables support for text mode selection on kernel startup. If
-	  you want to take advantage of some high-resolution text mode your
-	  card's BIOS offers, but the traditional Linux utilities like
-	  SVGATextMode don't, you can say Y here and set the mode using the
-	  "vga=" option from your boot loader (lilo or loadlin) or set
-	  "vga=ask" which brings up a video mode menu on kernel startup. (Try
-	  "man bootparam" or see the documentation of your boot loader about
-	  how to pass options to the kernel.)
-
-	  Read the file <file:Documentation/svga.txt> for more information
-	  about the Video mode selection support. If unsure, say N.
-
 config MDA_CONSOLE
 	depends on !M68K && !PARISC && ISA
 	tristate "MDA text console (dual-headed) (EXPERIMENTAL)"
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index a51f3e1..8c83abc 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -53,7 +53,6 @@
 #include <asm/tlb.h>
 
 #include <xen/interface/memory.h>
-#include <xen/balloon.h>
 #include <xen/xenbus.h>
 #include <xen/features.h>
 #include <xen/page.h>
diff --git a/include/asm-x86/boot.h b/include/asm-x86/boot.h
index 825de5d..1d63bd5 100644
--- a/include/asm-x86/boot.h
+++ b/include/asm-x86/boot.h
@@ -2,9 +2,7 @@
 #define ASM_X86__BOOT_H
 
 /* Don't touch these, unless you really know what you're doing. */
-#define DEF_INITSEG	0x9000
 #define DEF_SYSSEG	0x1000
-#define DEF_SETUPSEG	0x9020
 #define DEF_SYSSIZE	0x7F00
 
 /* Internal svga startup constants */
diff --git a/include/asm-x86/microcode.h b/include/asm-x86/microcode.h
new file mode 100644
index 0000000..62c793b
--- /dev/null
+++ b/include/asm-x86/microcode.h
@@ -0,0 +1,47 @@
+#ifndef ASM_X86__MICROCODE_H
+#define ASM_X86__MICROCODE_H
+
+struct cpu_signature {
+	unsigned int sig;
+	unsigned int pf;
+	unsigned int rev;
+};
+
+struct device;
+
+struct microcode_ops {
+	int  (*request_microcode_user) (int cpu, const void __user *buf, size_t size);
+	int  (*request_microcode_fw) (int cpu, struct device *device);
+
+	void (*apply_microcode) (int cpu);
+
+	int  (*collect_cpu_info) (int cpu, struct cpu_signature *csig);
+	void (*microcode_fini_cpu) (int cpu);
+};
+
+struct ucode_cpu_info {
+	struct cpu_signature cpu_sig;
+	int valid;
+	void *mc;
+};
+extern struct ucode_cpu_info ucode_cpu_info[];
+
+#ifdef CONFIG_MICROCODE_INTEL
+extern struct microcode_ops * __init init_intel_microcode(void);
+#else
+static inline struct microcode_ops * __init init_intel_microcode(void)
+{
+	return NULL;
+}
+#endif /* CONFIG_MICROCODE_INTEL */
+
+#ifdef CONFIG_MICROCODE_AMD
+extern struct microcode_ops * __init init_amd_microcode(void);
+#else
+static inline struct microcode_ops * __init init_amd_microcode(void)
+{
+	return NULL;
+}
+#endif
+
+#endif /* ASM_X86__MICROCODE_H */
diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index c7d3546..ee7cbb3 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -586,41 +586,6 @@ static inline void clear_in_cr4(unsigned long mask)
 	write_cr4(cr4);
 }
 
-struct microcode_header {
-	unsigned int		hdrver;
-	unsigned int		rev;
-	unsigned int		date;
-	unsigned int		sig;
-	unsigned int		cksum;
-	unsigned int		ldrver;
-	unsigned int		pf;
-	unsigned int		datasize;
-	unsigned int		totalsize;
-	unsigned int		reserved[3];
-};
-
-struct microcode {
-	struct microcode_header	hdr;
-	unsigned int		bits[0];
-};
-
-typedef struct microcode	microcode_t;
-typedef struct microcode_header	microcode_header_t;
-
-/* microcode format is extended from prescott processors */
-struct extended_signature {
-	unsigned int		sig;
-	unsigned int		pf;
-	unsigned int		cksum;
-};
-
-struct extended_sigtable {
-	unsigned int		count;
-	unsigned int		cksum;
-	unsigned int		reserved[3];
-	struct extended_signature sigs[0];
-};
-
 typedef struct {
 	unsigned long		seg;
 } mm_segment_t;
diff --git a/include/asm-x86/segment.h b/include/asm-x86/segment.h
index ea5f0a8..5d6e694 100644
--- a/include/asm-x86/segment.h
+++ b/include/asm-x86/segment.h
@@ -131,12 +131,6 @@
  * Matching rules for certain types of segments.
  */
 
-/* Matches only __KERNEL_CS, ignoring PnP / USER / APM segments */
-#define SEGMENT_IS_KERNEL_CODE(x) (((x) & 0xfc) == GDT_ENTRY_KERNEL_CS * 8)
-
-/* Matches __KERNEL_CS and __USER_CS (they must be 2 entries apart) */
-#define SEGMENT_IS_FLAT_CODE(x)  (((x) & 0xec) == GDT_ENTRY_KERNEL_CS * 8)
-
 /* Matches PNP_CS32 and PNP_CS16 (they must be consecutive) */
 #define SEGMENT_IS_PNP_CODE(x)   (((x) & 0xf4) == GDT_ENTRY_PNPBIOS_BASE * 8)
 
diff --git a/include/asm-x86/spinlock.h b/include/asm-x86/spinlock.h
index 8badab0..157ff7f 100644
--- a/include/asm-x86/spinlock.h
+++ b/include/asm-x86/spinlock.h
@@ -21,8 +21,10 @@
 
 #ifdef CONFIG_X86_32
 # define LOCK_PTR_REG "a"
+# define REG_PTR_MODE "k"
 #else
 # define LOCK_PTR_REG "D"
+# define REG_PTR_MODE "q"
 #endif
 
 #if defined(CONFIG_X86_32) && \
@@ -54,19 +56,7 @@
  * much between them in performance though, especially as locks are out of line.
  */
 #if (NR_CPUS < 256)
-static inline int __ticket_spin_is_locked(raw_spinlock_t *lock)
-{
-	int tmp = ACCESS_ONCE(lock->slock);
-
-	return (((tmp >> 8) & 0xff) != (tmp & 0xff));
-}
-
-static inline int __ticket_spin_is_contended(raw_spinlock_t *lock)
-{
-	int tmp = ACCESS_ONCE(lock->slock);
-
-	return (((tmp >> 8) - tmp) & 0xff) > 1;
-}
+#define TICKET_SHIFT 8
 
 static __always_inline void __ticket_spin_lock(raw_spinlock_t *lock)
 {
@@ -89,19 +79,17 @@ static __always_inline void __ticket_spin_lock(raw_spinlock_t *lock)
 
 static __always_inline int __ticket_spin_trylock(raw_spinlock_t *lock)
 {
-	int tmp;
-	short new;
+	int tmp, new;
 
-	asm volatile("movw %2,%w0\n\t"
+	asm volatile("movzwl %2, %0\n\t"
 		     "cmpb %h0,%b0\n\t"
+		     "leal 0x100(%" REG_PTR_MODE "0), %1\n\t"
 		     "jne 1f\n\t"
-		     "movw %w0,%w1\n\t"
-		     "incb %h1\n\t"
 		     LOCK_PREFIX "cmpxchgw %w1,%2\n\t"
 		     "1:"
 		     "sete %b1\n\t"
 		     "movzbl %b1,%0\n\t"
-		     : "=&a" (tmp), "=Q" (new), "+m" (lock->slock)
+		     : "=&a" (tmp), "=&q" (new), "+m" (lock->slock)
 		     :
 		     : "memory", "cc");
 
@@ -116,19 +104,7 @@ static __always_inline void __ticket_spin_unlock(raw_spinlock_t *lock)
 		     : "memory", "cc");
 }
 #else
-static inline int __ticket_spin_is_locked(raw_spinlock_t *lock)
-{
-	int tmp = ACCESS_ONCE(lock->slock);
-
-	return (((tmp >> 16) & 0xffff) != (tmp & 0xffff));
-}
-
-static inline int __ticket_spin_is_contended(raw_spinlock_t *lock)
-{
-	int tmp = ACCESS_ONCE(lock->slock);
-
-	return (((tmp >> 16) - tmp) & 0xffff) > 1;
-}
+#define TICKET_SHIFT 16
 
 static __always_inline void __ticket_spin_lock(raw_spinlock_t *lock)
 {
@@ -146,7 +122,7 @@ static __always_inline void __ticket_spin_lock(raw_spinlock_t *lock)
 		     /* don't need lfence here, because loads are in-order */
 		     "jmp 1b\n"
 		     "2:"
-		     : "+Q" (inc), "+m" (lock->slock), "=r" (tmp)
+		     : "+r" (inc), "+m" (lock->slock), "=&r" (tmp)
 		     :
 		     : "memory", "cc");
 }
@@ -160,13 +136,13 @@ static __always_inline int __ticket_spin_trylock(raw_spinlock_t *lock)
 		     "movl %0,%1\n\t"
 		     "roll $16, %0\n\t"
 		     "cmpl %0,%1\n\t"
+		     "leal 0x00010000(%" REG_PTR_MODE "0), %1\n\t"
 		     "jne 1f\n\t"
-		     "addl $0x00010000, %1\n\t"
 		     LOCK_PREFIX "cmpxchgl %1,%2\n\t"
 		     "1:"
 		     "sete %b1\n\t"
 		     "movzbl %b1,%0\n\t"
-		     : "=&a" (tmp), "=r" (new), "+m" (lock->slock)
+		     : "=&a" (tmp), "=&q" (new), "+m" (lock->slock)
 		     :
 		     : "memory", "cc");
 
@@ -182,6 +158,20 @@ static __always_inline void __ticket_spin_unlock(raw_spinlock_t *lock)
 }
 #endif
 
+static inline int __ticket_spin_is_locked(raw_spinlock_t *lock)
+{
+	int tmp = ACCESS_ONCE(lock->slock);
+
+	return !!(((tmp >> TICKET_SHIFT) ^ tmp) & ((1 << TICKET_SHIFT) - 1));
+}
+
+static inline int __ticket_spin_is_contended(raw_spinlock_t *lock)
+{
+	int tmp = ACCESS_ONCE(lock->slock);
+
+	return (((tmp >> TICKET_SHIFT) - tmp) & ((1 << TICKET_SHIFT) - 1)) > 1;
+}
+
 #ifdef CONFIG_PARAVIRT
 /*
  * Define virtualization-friendly old-style lock byte lock, for use in
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 75d81f1..b8fd749 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -240,6 +240,23 @@ extern const char *print_tainted(void);
 extern void add_taint(unsigned);
 extern int root_mountflags;
 
+#ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
+/*
+ * This is obviously not a great place for this, but we want to be
+ * able to scatter it around anywhere in the kernel.
+ */
+void check_for_bios_corruption(void);
+void start_periodic_check_for_corruption(void);
+#else
+static inline void check_for_bios_corruption(void)
+{
+}
+
+static inline void start_periodic_check_for_corruption(void)
+{
+}
+#endif
+
 /* Values used for system_state */
 extern enum system_states {
 	SYSTEM_BOOTING,
diff --git a/include/linux/usb/ehci_def.h b/include/linux/usb/ehci_def.h
new file mode 100644
index 0000000..5b88e36
--- /dev/null
+++ b/include/linux/usb/ehci_def.h
@@ -0,0 +1,160 @@
+/*
+ * Copyright (c) 2001-2002 by David Brownell
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef __LINUX_USB_EHCI_DEF_H
+#define __LINUX_USB_EHCI_DEF_H
+
+/* EHCI register interface, corresponds to EHCI Revision 0.95 specification */
+
+/* Section 2.2 Host Controller Capability Registers */
+struct ehci_caps {
+	/* these fields are specified as 8 and 16 bit registers,
+	 * but some hosts can't perform 8 or 16 bit PCI accesses.
+	 */
+	u32		hc_capbase;
+#define HC_LENGTH(p)		(((p)>>00)&0x00ff)	/* bits 7:0 */
+#define HC_VERSION(p)		(((p)>>16)&0xffff)	/* bits 31:16 */
+	u32		hcs_params;     /* HCSPARAMS - offset 0x4 */
+#define HCS_DEBUG_PORT(p)	(((p)>>20)&0xf)	/* bits 23:20, debug port? */
+#define HCS_INDICATOR(p)	((p)&(1 << 16))	/* true: has port indicators */
+#define HCS_N_CC(p)		(((p)>>12)&0xf)	/* bits 15:12, #companion HCs */
+#define HCS_N_PCC(p)		(((p)>>8)&0xf)	/* bits 11:8, ports per CC */
+#define HCS_PORTROUTED(p)	((p)&(1 << 7))	/* true: port routing */
+#define HCS_PPC(p)		((p)&(1 << 4))	/* true: port power control */
+#define HCS_N_PORTS(p)		(((p)>>0)&0xf)	/* bits 3:0, ports on HC */
+
+	u32		hcc_params;      /* HCCPARAMS - offset 0x8 */
+#define HCC_EXT_CAPS(p)		(((p)>>8)&0xff)	/* for pci extended caps */
+#define HCC_ISOC_CACHE(p)       ((p)&(1 << 7))  /* true: can cache isoc frame */
+#define HCC_ISOC_THRES(p)       (((p)>>4)&0x7)  /* bits 6:4, uframes cached */
+#define HCC_CANPARK(p)		((p)&(1 << 2))  /* true: can park on async qh */
+#define HCC_PGM_FRAMELISTLEN(p) ((p)&(1 << 1))  /* true: periodic_size changes*/
+#define HCC_64BIT_ADDR(p)       ((p)&(1))       /* true: can use 64-bit addr */
+	u8		portroute [8];	 /* nibbles for routing - offset 0xC */
+} __attribute__ ((packed));
+
+
+/* Section 2.3 Host Controller Operational Registers */
+struct ehci_regs {
+
+	/* USBCMD: offset 0x00 */
+	u32		command;
+/* 23:16 is r/w intr rate, in microframes; default "8" == 1/msec */
+#define CMD_PARK	(1<<11)		/* enable "park" on async qh */
+#define CMD_PARK_CNT(c)	(((c)>>8)&3)	/* how many transfers to park for */
+#define CMD_LRESET	(1<<7)		/* partial reset (no ports, etc) */
+#define CMD_IAAD	(1<<6)		/* "doorbell" interrupt async advance */
+#define CMD_ASE		(1<<5)		/* async schedule enable */
+#define CMD_PSE		(1<<4)		/* periodic schedule enable */
+/* 3:2 is periodic frame list size */
+#define CMD_RESET	(1<<1)		/* reset HC not bus */
+#define CMD_RUN		(1<<0)		/* start/stop HC */
+
+	/* USBSTS: offset 0x04 */
+	u32		status;
+#define STS_ASS		(1<<15)		/* Async Schedule Status */
+#define STS_PSS		(1<<14)		/* Periodic Schedule Status */
+#define STS_RECL	(1<<13)		/* Reclamation */
+#define STS_HALT	(1<<12)		/* Not running (any reason) */
+/* some bits reserved */
+	/* these STS_* flags are also intr_enable bits (USBINTR) */
+#define STS_IAA		(1<<5)		/* Interrupted on async advance */
+#define STS_FATAL	(1<<4)		/* such as some PCI access errors */
+#define STS_FLR		(1<<3)		/* frame list rolled over */
+#define STS_PCD		(1<<2)		/* port change detect */
+#define STS_ERR		(1<<1)		/* "error" completion (overflow, ...) */
+#define STS_INT		(1<<0)		/* "normal" completion (short, ...) */
+
+	/* USBINTR: offset 0x08 */
+	u32		intr_enable;
+
+	/* FRINDEX: offset 0x0C */
+	u32		frame_index;	/* current microframe number */
+	/* CTRLDSSEGMENT: offset 0x10 */
+	u32		segment;	/* address bits 63:32 if needed */
+	/* PERIODICLISTBASE: offset 0x14 */
+	u32		frame_list;	/* points to periodic list */
+	/* ASYNCLISTADDR: offset 0x18 */
+	u32		async_next;	/* address of next async queue head */
+
+	u32		reserved [9];
+
+	/* CONFIGFLAG: offset 0x40 */
+	u32		configured_flag;
+#define FLAG_CF		(1<<0)		/* true: we'll support "high speed" */
+
+	/* PORTSC: offset 0x44 */
+	u32		port_status [0];	/* up to N_PORTS */
+/* 31:23 reserved */
+#define PORT_WKOC_E	(1<<22)		/* wake on overcurrent (enable) */
+#define PORT_WKDISC_E	(1<<21)		/* wake on disconnect (enable) */
+#define PORT_WKCONN_E	(1<<20)		/* wake on connect (enable) */
+/* 19:16 for port testing */
+#define PORT_LED_OFF	(0<<14)
+#define PORT_LED_AMBER	(1<<14)
+#define PORT_LED_GREEN	(2<<14)
+#define PORT_LED_MASK	(3<<14)
+#define PORT_OWNER	(1<<13)		/* true: companion hc owns this port */
+#define PORT_POWER	(1<<12)		/* true: has power (see PPC) */
+#define PORT_USB11(x) (((x)&(3<<10)) == (1<<10))	/* USB 1.1 device */
+/* 11:10 for detecting lowspeed devices (reset vs release ownership) */
+/* 9 reserved */
+#define PORT_RESET	(1<<8)		/* reset port */
+#define PORT_SUSPEND	(1<<7)		/* suspend port */
+#define PORT_RESUME	(1<<6)		/* resume it */
+#define PORT_OCC	(1<<5)		/* over current change */
+#define PORT_OC		(1<<4)		/* over current active */
+#define PORT_PEC	(1<<3)		/* port enable change */
+#define PORT_PE		(1<<2)		/* port enable */
+#define PORT_CSC	(1<<1)		/* connect status change */
+#define PORT_CONNECT	(1<<0)		/* device connected */
+#define PORT_RWC_BITS   (PORT_CSC | PORT_PEC | PORT_OCC)
+} __attribute__ ((packed));
+
+#define USBMODE		0x68		/* USB Device mode */
+#define USBMODE_SDIS	(1<<3)		/* Stream disable */
+#define USBMODE_BE	(1<<2)		/* BE/LE endianness select */
+#define USBMODE_CM_HC	(3<<0)		/* host controller mode */
+#define USBMODE_CM_IDLE	(0<<0)		/* idle state */
+
+/* Appendix C, Debug port ... intended for use with special "debug devices"
+ * that can help if there's no serial console.  (nonstandard enumeration.)
+ */
+struct ehci_dbg_port {
+	u32	control;
+#define DBGP_OWNER	(1<<30)
+#define DBGP_ENABLED	(1<<28)
+#define DBGP_DONE	(1<<16)
+#define DBGP_INUSE	(1<<10)
+#define DBGP_ERRCODE(x)	(((x)>>7)&0x07)
+#	define DBGP_ERR_BAD	1
+#	define DBGP_ERR_SIGNAL	2
+#define DBGP_ERROR	(1<<6)
+#define DBGP_GO		(1<<5)
+#define DBGP_OUT	(1<<4)
+#define DBGP_LEN(x)	(((x)>>0)&0x0f)
+	u32	pids;
+#define DBGP_PID_GET(x)		(((x)>>16)&0xff)
+#define DBGP_PID_SET(data, tok)	(((data)<<8)|(tok))
+	u32	data03;
+	u32	data47;
+	u32	address;
+#define DBGP_EPADDR(dev, ep)	(((dev)<<8)|(ep))
+} __attribute__ ((packed));
+
+#endif /* __LINUX_USB_EHCI_DEF_H */
diff --git a/include/xen/balloon.h b/include/xen/balloon.h
deleted file mode 100644
index fe43b0f..0000000
--- a/include/xen/balloon.h
+++ /dev/null
@@ -1,61 +0,0 @@
-/******************************************************************************
- * balloon.h
- *
- * Xen balloon driver - enables returning/claiming memory to/from Xen.
- *
- * Copyright (c) 2003, B Dragovic
- * Copyright (c) 2003-2004, M Williamson, K Fraser
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License version 2
- * as published by the Free Software Foundation; or, when distributed
- * separately from the Linux kernel or incorporated into other
- * software packages, subject to the following license:
- *
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this source file (the "Software"), to deal in the Software without
- * restriction, including without limitation the rights to use, copy, modify,
- * merge, publish, distribute, sublicense, and/or sell copies of the Software,
- * and to permit persons to whom the Software is furnished to do so, subject to
- * the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
- * IN THE SOFTWARE.
- */
-
-#ifndef __XEN_BALLOON_H__
-#define __XEN_BALLOON_H__
-
-#include <linux/spinlock.h>
-
-#if 0
-/*
- * Inform the balloon driver that it should allow some slop for device-driver
- * memory activities.
- */
-void balloon_update_driver_allowance(long delta);
-
-/* Allocate/free a set of empty pages in low memory (i.e., no RAM mapped). */
-struct page **alloc_empty_pages_and_pagevec(int nr_pages);
-void free_empty_pages_and_pagevec(struct page **pagevec, int nr_pages);
-
-void balloon_release_driver_page(struct page *page);
-
-/*
- * Prevent the balloon driver from changing the memory reservation during
- * a driver critical region.
- */
-extern spinlock_t balloon_lock;
-#define balloon_lock(__flags)   spin_lock_irqsave(&balloon_lock, __flags)
-#define balloon_unlock(__flags) spin_unlock_irqrestore(&balloon_lock, __flags)
-#endif
-
-#endif /* __XEN_BALLOON_H__ */
diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index d64e6ba..982dcae 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -105,12 +105,12 @@ as-instr = $(call try-run,\
 # Usage: cflags-y += $(call cc-option,-march=winchip-c6,-march=i586)
 
 cc-option = $(call try-run,\
-	$(CC) $(KBUILD_CFLAGS) $(1) -S -xc /dev/null -o "$$TMP",$(1),$(2))
+	$(CC) $(KBUILD_CFLAGS) $(1) -c -xc /dev/null -o "$$TMP",$(1),$(2))
 
 # cc-option-yn
 # Usage: flag := $(call cc-option-yn,-march=winchip-c6)
 cc-option-yn = $(call try-run,\
-	$(CC) $(KBUILD_CFLAGS) $(1) -S -xc /dev/null -o "$$TMP",y,n)
+	$(CC) $(KBUILD_CFLAGS) $(1) -c -xc /dev/null -o "$$TMP",y,n)
 
 # cc-option-align
 # Prefix align with either -falign or -malign
