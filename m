Return-Path: <linux-kernel-owner+w=401wt.eu-S1761593AbZFJVX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761593AbZFJVX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755724AbZFJVXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:23:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48901 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757341AbZFJVXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:23:45 -0400
Date: Wed, 10 Jun 2009 23:23:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/kbuild for v2.6.31
Message-ID: <20090610212308.GA20181@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-kbuild-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-kbuild-for-linus

A difficult unification, lots of cleanups and future-proofing - plus 
fixes for relocatable kernels. This topic branch had three 
regressions.

out-of-topic modifications in x86-kbuild-for-linus:
---------------------------------------------------
kernel/sysctl.c                    # 5031296: x86: add extension fields for boo
scripts/Makefile.lib               # d3dd3b5: kbuild: allow compressors (gzip, 
scripts/bin_size                   # d3dd3b5: kbuild: allow compressors (gzip, 

 Thanks,

	Ingo

------------------>
H. Peter Anvin (26):
      x86, boot: align the .bss section in the decompressor
      kbuild: allow compressors (gzip, bzip2, lzma) to take multiple inputs
      x86: add a Kconfig symbol for when relocations are needed
      x86, boot: simplify arch/x86/boot/compressed/Makefile
      x86, boot: follow standard Kbuild style for compression suffix
      x86, boot: use BP_scratch in arch/x86/boot/compressed/head_*.S
      x86, boot: stylistic cleanups for boot/compressed/head_32.S
      x86, boot: stylistic cleanups for boot/compressed/head_64.S
      x86, boot: straighten out ranges to copy/zero in compressed/head*.S
      x86, boot: set up the decompression stack as early as possible
      x86, boot: zero EFLAGS on 32 bits
      x86, boot: use appropriate rep string for move and clear
      x86, boot: determine compressed code offset at compile time
      x86, boot: make symbols from the main vmlinux available
      x86, boot: use LOAD_PHYSICAL_ADDR on 64 bits
      x86, boot: remove dead code from boot/compressed/head_*.S
      x86, boot: make kernel_alignment adjustable; new bzImage fields
      x86: document new bzImage fields
      x86: default CONFIG_PHYSICAL_START and CONFIG_PHYSICAL_ALIGN to 16 MB
      x86: make CONFIG_RELOCATABLE the default
      x86, defconfig: update to current, no material changes
      x86, defconfig: update kernel position parameters
      x86: add extension fields for bootloader type and version
      x86, boot: correct sanity checks in boot/compressed/misc.c
      x86-64: align __PHYSICAL_START, remove __KERNEL_ALIGN
      x86, boot: correct the calculation of ZO_INIT_SIZE

Ingo Molnar (2):
      x86, vmlinux.lds: add copyright
      x86, vmlinux.lds: fix relocatable symbols

Linus Torvalds (1):
      x86: unify arch/x86/boot/compressed/vmlinux_*.lds

Mike Galbraith (1):
      x86, boot: add new generated files to the appropriate .gitignore files

Sam Ravnborg (16):
      x86: standardize Kbuild rules
      x86: beautify vmlinux_64.lds.S
      x86: beautify vmlinux_32.lds.S
      x86, vmlinux.lds: unify header/footer
      x86, vmlinux.lds: unify PHDRS
      x86, vmlinux.lds: unify start/end of SECTIONS
      x86, vmlinux.lds: unify .text output sections
      x86, vmlinux.lds: unify exception table
      x86, vmlinux.lds: unify data output sections
      x86, vmlinux.lds: move vsyscall output sections
      x86, vmlinux.lds: unify first part of initdata
      x86, vmlinux.lds: unify parainstructions
      x86, vmlinux.lds: unify .exit.* and .init.ramfs
      x86, vmlinux.lds: unify percpu
      x86, vmlinux.lds: unify remaining parts
      x86: boot/compressed/vmlinux.lds.S: fix build of bzImage with 64 bit compiler


 Documentation/x86/boot.txt                         |  122 ++++++-
 arch/x86/Kbuild                                    |   16 +
 arch/x86/Kconfig                                   |   41 ++-
 arch/x86/Makefile                                  |   19 +-
 arch/x86/boot/.gitignore                           |    2 +
 arch/x86/boot/Makefile                             |   24 +-
 arch/x86/boot/compressed/.gitignore                |    3 +
 arch/x86/boot/compressed/Makefile                  |   54 +--
 arch/x86/boot/compressed/head_32.S                 |  194 +++++-----
 arch/x86/boot/compressed/head_64.S                 |  169 ++++----
 arch/x86/boot/compressed/misc.c                    |   12 +-
 arch/x86/boot/compressed/mkpiggy.c                 |   97 +++++
 .../compressed/{vmlinux_64.lds => vmlinux.lds.S}   |   29 +-
 arch/x86/boot/compressed/vmlinux.scr               |   10 -
 arch/x86/boot/compressed/vmlinux_32.lds            |   43 --
 arch/x86/boot/header.S                             |   28 +-
 arch/x86/configs/i386_defconfig                    |  148 ++++++--
 arch/x86/configs/x86_64_defconfig                  |  150 +++++--
 arch/x86/include/asm/boot.h                        |   15 +
 arch/x86/include/asm/bootparam.h                   |    3 +-
 arch/x86/include/asm/page_64_types.h               |   14 +-
 arch/x86/include/asm/processor.h                   |    1 +
 arch/x86/kernel/asm-offsets_32.c                   |    1 +
 arch/x86/kernel/asm-offsets_64.c                   |    1 +
 arch/x86/kernel/head_32.S                          |    7 -
 arch/x86/kernel/setup.c                            |   10 +-
 arch/x86/kernel/vmlinux.lds.S                      |  430 +++++++++++++++++++-
 arch/x86/kernel/vmlinux_32.lds.S                   |  229 -----------
 arch/x86/kernel/vmlinux_64.lds.S                   |  298 --------------
 kernel/sysctl.c                                    |    8 +
 scripts/Makefile.lib                               |   28 +-
 scripts/bin_size                                   |   10 -
 32 files changed, 1235 insertions(+), 981 deletions(-)
 create mode 100644 arch/x86/Kbuild
 create mode 100644 arch/x86/boot/compressed/mkpiggy.c
 rename arch/x86/boot/compressed/{vmlinux_64.lds => vmlinux.lds.S} (57%)
 delete mode 100644 arch/x86/boot/compressed/vmlinux.scr
 delete mode 100644 arch/x86/boot/compressed/vmlinux_32.lds
 delete mode 100644 arch/x86/kernel/vmlinux_32.lds.S
 delete mode 100644 arch/x86/kernel/vmlinux_64.lds.S
 delete mode 100644 scripts/bin_size

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index e020366..8da3a79 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -50,6 +50,10 @@ Protocol 2.08:	(Kernel 2.6.26) Added crc32 checksum and ELF format
 Protocol 2.09:	(Kernel 2.6.26) Added a field of 64-bit physical
 		pointer to single linked list of struct	setup_data.
 
+Protocol 2.10:	(Kernel 2.6.31) Added a protocol for relaxed alignment
+		beyond the kernel_alignment added, new init_size and
+		pref_address fields.  Added extended boot loader IDs.
+
 **** MEMORY LAYOUT
 
 The traditional memory map for the kernel loader, used for Image or
@@ -168,12 +172,13 @@ Offset	Proto	Name		Meaning
 021C/4	2.00+	ramdisk_size	initrd size (set by boot loader)
 0220/4	2.00+	bootsect_kludge	DO NOT USE - for bootsect.S use only
 0224/2	2.01+	heap_end_ptr	Free memory after setup end
-0226/2	N/A	pad1		Unused
+0226/1	2.02+(3 ext_loader_ver	Extended boot loader version
+0227/1	2.02+(3	ext_loader_type	Extended boot loader ID
 0228/4	2.02+	cmd_line_ptr	32-bit pointer to the kernel command line
 022C/4	2.03+	ramdisk_max	Highest legal initrd address
 0230/4	2.05+	kernel_alignment Physical addr alignment required for kernel
 0234/1	2.05+	relocatable_kernel Whether kernel is relocatable or not
-0235/1	N/A	pad2		Unused
+0235/1	2.10+	min_alignment	Minimum alignment, as a power of two
 0236/2	N/A	pad3		Unused
 0238/4	2.06+	cmdline_size	Maximum size of the kernel command line
 023C/4	2.07+	hardware_subarch Hardware subarchitecture
@@ -182,6 +187,8 @@ Offset	Proto	Name		Meaning
 024C/4	2.08+	payload_length	Length of kernel payload
 0250/8	2.09+	setup_data	64-bit physical pointer to linked list
 				of struct setup_data
+0258/8	2.10+	pref_address	Preferred loading address
+0260/4	2.10+	init_size	Linear memory required during initialization
 
 (1) For backwards compatibility, if the setup_sects field contains 0, the
     real value is 4.
@@ -190,6 +197,8 @@ Offset	Proto	Name		Meaning
     field are unusable, which means the size of a bzImage kernel
     cannot be determined.
 
+(3) Ignored, but safe to set, for boot protocols 2.02-2.09.
+
 If the "HdrS" (0x53726448) magic number is not found at offset 0x202,
 the boot protocol version is "old".  Loading an old kernel, the
 following parameters should be assumed:
@@ -343,18 +352,32 @@ Protocol:	2.00+
   0xTV here, where T is an identifier for the boot loader and V is
   a version number.  Otherwise, enter 0xFF here.
 
+  For boot loader IDs above T = 0xD, write T = 0xE to this field and
+  write the extended ID minus 0x10 to the ext_loader_type field.
+  Similarly, the ext_loader_ver field can be used to provide more than
+  four bits for the bootloader version.
+
+  For example, for T = 0x15, V = 0x234, write:
+
+  type_of_loader  <- 0xE4
+  ext_loader_type <- 0x05
+  ext_loader_ver  <- 0x23
+
   Assigned boot loader ids:
 	0  LILO			(0x00 reserved for pre-2.00 bootloader)
 	1  Loadlin
 	2  bootsect-loader	(0x20, all other values reserved)
-	3  SYSLINUX
-	4  EtherBoot
+	3  Syslinux
+	4  Etherboot/gPXE
 	5  ELILO
 	7  GRUB
-	8  U-BOOT
+	8  U-Boot
 	9  Xen
 	A  Gujin
 	B  Qemu
+	C  Arcturus Networks uCbootloader
+	E  Extended		(see ext_loader_type)
+	F  Special		(0xFF = undefined)
 
   Please contact <hpa@zytor.com> if you need a bootloader ID
   value assigned.
@@ -453,6 +476,35 @@ Protocol:	2.01+
   Set this field to the offset (from the beginning of the real-mode
   code) of the end of the setup stack/heap, minus 0x0200.
 
+Field name:	ext_loader_ver
+Type:		write (optional)
+Offset/size:	0x226/1
+Protocol:	2.02+
+
+  This field is used as an extension of the version number in the
+  type_of_loader field.  The total version number is considered to be
+  (type_of_loader & 0x0f) + (ext_loader_ver << 4).
+
+  The use of this field is boot loader specific.  If not written, it
+  is zero.
+
+  Kernels prior to 2.6.31 did not recognize this field, but it is safe
+  to write for protocol version 2.02 or higher.
+
+Field name:	ext_loader_type
+Type:		write (obligatory if (type_of_loader & 0xf0) == 0xe0)
+Offset/size:	0x227/1
+Protocol:	2.02+
+
+  This field is used as an extension of the type number in
+  type_of_loader field.  If the type in type_of_loader is 0xE, then
+  the actual type is (ext_loader_type + 0x10).
+
+  This field is ignored if the type in type_of_loader is not 0xE.
+
+  Kernels prior to 2.6.31 did not recognize this field, but it is safe
+  to write for protocol version 2.02 or higher.
+
 Field name:	cmd_line_ptr
 Type:		write (obligatory)
 Offset/size:	0x228/4
@@ -482,11 +534,19 @@ Protocol:	2.03+
   0x37FFFFFF, you can start your ramdisk at 0x37FE0000.)
 
 Field name:	kernel_alignment
-Type:		read (reloc)
+Type:		read/modify (reloc)
 Offset/size:	0x230/4
-Protocol:	2.05+
+Protocol:	2.05+ (read), 2.10+ (modify)
+
+  Alignment unit required by the kernel (if relocatable_kernel is
+  true.)  A relocatable kernel that is loaded at an alignment
+  incompatible with the value in this field will be realigned during
+  kernel initialization.
 
-  Alignment unit required by the kernel (if relocatable_kernel is true.)
+  Starting with protocol version 2.10, this reflects the kernel
+  alignment preferred for optimal performance; it is possible for the
+  loader to modify this field to permit a lesser alignment.  See the
+  min_alignment and pref_address field below.
 
 Field name:	relocatable_kernel
 Type:		read (reloc)
@@ -498,6 +558,22 @@ Protocol:	2.05+
   After loading, the boot loader must set the code32_start field to
   point to the loaded code, or to a boot loader hook.
 
+Field name:	min_alignment
+Type:		read (reloc)
+Offset/size:	0x235/1
+Protocol:	2.10+
+
+  This field, if nonzero, indicates as a power of two the minimum
+  alignment required, as opposed to preferred, by the kernel to boot.
+  If a boot loader makes use of this field, it should update the
+  kernel_alignment field with the alignment unit desired; typically:
+
+	kernel_alignment = 1 << min_alignment
+
+  There may be a considerable performance cost with an excessively
+  misaligned kernel.  Therefore, a loader should typically try each
+  power-of-two alignment from kernel_alignment down to this alignment.
+
 Field name:	cmdline_size
 Type:		read
 Offset/size:	0x238/4
@@ -582,6 +658,36 @@ Protocol:	2.09+
   sure to consider the case where the linked list already contains
   entries.
 
+Field name:	pref_address
+Type:		read (reloc)
+Offset/size:	0x258/8
+Protocol:	2.10+
+
+  This field, if nonzero, represents a preferred load address for the
+  kernel.  A relocating bootloader should attempt to load at this
+  address if possible.
+
+  A non-relocatable kernel will unconditionally move itself and to run
+  at this address.
+
+Field name:	init_size
+Type:		read
+Offset/size:	0x25c/4
+
+  This field indicates the amount of linear contiguous memory starting
+  at the kernel runtime start address that the kernel needs before it
+  is capable of examining its memory map.  This is not the same thing
+  as the total amount of memory the kernel needs to boot, but it can
+  be used by a relocating boot loader to help select a safe load
+  address for the kernel.
+
+  The kernel runtime start address is determined by the following algorithm:
+
+  if (relocatable_kernel)
+	runtime_start = align_up(load_address, kernel_alignment)
+  else
+	runtime_start = pref_address
+
 
 **** THE IMAGE CHECKSUM
 
diff --git a/arch/x86/Kbuild b/arch/x86/Kbuild
new file mode 100644
index 0000000..ad8ec35
--- /dev/null
+++ b/arch/x86/Kbuild
@@ -0,0 +1,16 @@
+
+obj-$(CONFIG_KVM) += kvm/
+
+# Xen paravirtualization support
+obj-$(CONFIG_XEN) += xen/
+
+# lguest paravirtualization support
+obj-$(CONFIG_LGUEST_GUEST) += lguest/
+
+obj-y += kernel/
+obj-y += mm/
+
+obj-y += crypto/
+obj-y += vdso/
+obj-$(CONFIG_IA32_EMULATION) += ia32/
+
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index bc25b9f..3e0f80a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -47,6 +47,11 @@ config X86
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
 
+config OUTPUT_FORMAT
+	string
+	default "elf32-i386" if X86_32
+	default "elf64-x86-64" if X86_64
+
 config ARCH_DEFCONFIG
 	string
 	default "arch/x86/configs/i386_defconfig" if X86_32
@@ -1450,9 +1455,7 @@ config KEXEC_JUMP
 
 config PHYSICAL_START
 	hex "Physical address where the kernel is loaded" if (EMBEDDED || CRASH_DUMP)
-	default "0x1000000" if X86_NUMAQ
-	default "0x200000" if X86_64
-	default "0x100000"
+	default "0x1000000"
 	---help---
 	  This gives the physical address where the kernel is loaded.
 
@@ -1471,15 +1474,15 @@ config PHYSICAL_START
 	  to be specifically compiled to run from a specific memory area
 	  (normally a reserved region) and this option comes handy.
 
-	  So if you are using bzImage for capturing the crash dump, leave
-	  the value here unchanged to 0x100000 and set CONFIG_RELOCATABLE=y.
-	  Otherwise if you plan to use vmlinux for capturing the crash dump
-	  change this value to start of the reserved region (Typically 16MB
-	  0x1000000). In other words, it can be set based on the "X" value as
-	  specified in the "crashkernel=YM@XM" command line boot parameter
-	  passed to the panic-ed kernel. Typically this parameter is set as
-	  crashkernel=64M@16M. Please take a look at
-	  Documentation/kdump/kdump.txt for more details about crash dumps.
+	  So if you are using bzImage for capturing the crash dump,
+	  leave the value here unchanged to 0x1000000 and set
+	  CONFIG_RELOCATABLE=y.  Otherwise if you plan to use vmlinux
+	  for capturing the crash dump change this value to start of
+	  the reserved region.  In other words, it can be set based on
+	  the "X" value as specified in the "crashkernel=YM@XM"
+	  command line boot parameter passed to the panic-ed
+	  kernel. Please take a look at Documentation/kdump/kdump.txt
+	  for more details about crash dumps.
 
 	  Usage of bzImage for capturing the crash dump is recommended as
 	  one does not have to build two kernels. Same kernel can be used
@@ -1492,8 +1495,8 @@ config PHYSICAL_START
 	  Don't change this unless you know what you are doing.
 
 config RELOCATABLE
-	bool "Build a relocatable kernel (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "Build a relocatable kernel"
+	default y
 	---help---
 	  This builds a kernel image that retains relocation information
 	  so it can be loaded someplace besides the default 1MB.
@@ -1508,12 +1511,16 @@ config RELOCATABLE
 	  it has been loaded at and the compile time physical address
 	  (CONFIG_PHYSICAL_START) is ignored.
 
+# Relocation on x86-32 needs some additional build support
+config X86_NEED_RELOCS
+	def_bool y
+	depends on X86_32 && RELOCATABLE
+
 config PHYSICAL_ALIGN
 	hex
 	prompt "Alignment value to which kernel should be aligned" if X86_32
-	default "0x100000" if X86_32
-	default "0x200000" if X86_64
-	range 0x2000 0x400000
+	default "0x1000000"
+	range 0x2000 0x1000000
 	---help---
 	  This value puts the alignment restrictions on physical address
 	  where kernel is loaded and run from. Kernel is compiled for an
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index f05d8c9..e81f0b2 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -7,8 +7,6 @@ else
         KBUILD_DEFCONFIG := $(ARCH)_defconfig
 endif
 
-core-$(CONFIG_KVM) += arch/x86/kvm/
-
 # BITS is used as extension for files which are available in a 32 bit
 # and a 64 bit version to simplify shared Makefiles.
 # e.g.: obj-y += foo_$(BITS).o
@@ -118,21 +116,8 @@ head-y += arch/x86/kernel/init_task.o
 
 libs-y  += arch/x86/lib/
 
-# Sub architecture files that needs linking first
-core-y += $(fcore-y)
-
-# Xen paravirtualization support
-core-$(CONFIG_XEN) += arch/x86/xen/
-
-# lguest paravirtualization support
-core-$(CONFIG_LGUEST_GUEST) += arch/x86/lguest/
-
-core-y += arch/x86/kernel/
-core-y += arch/x86/mm/
-
-core-y += arch/x86/crypto/
-core-y += arch/x86/vdso/
-core-$(CONFIG_IA32_EMULATION) += arch/x86/ia32/
+# See arch/x86/Kbuild for content of core part of the kernel
+core-y += arch/x86/
 
 # drivers-y are linked after core-y
 drivers-$(CONFIG_MATH_EMULATION) += arch/x86/math-emu/
diff --git a/arch/x86/boot/.gitignore b/arch/x86/boot/.gitignore
index 172cf8a..851fe93 100644
--- a/arch/x86/boot/.gitignore
+++ b/arch/x86/boot/.gitignore
@@ -3,6 +3,8 @@ bzImage
 cpustr.h
 mkcpustr
 offsets.h
+voffset.h
+zoffset.h
 setup
 setup.bin
 setup.elf
diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 6633b6e..619d297 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -86,19 +86,27 @@ $(obj)/vmlinux.bin: $(obj)/compressed/vmlinux FORCE
 
 SETUP_OBJS = $(addprefix $(obj)/,$(setup-y))
 
-sed-offsets := -e 's/^00*/0/' \
-        -e 's/^\([0-9a-fA-F]*\) . \(input_data\|input_data_end\)$$/\#define \2 0x\1/p'
+sed-voffset := -e 's/^\([0-9a-fA-F]*\) . \(_text\|_end\)$$/\#define VO_\2 0x\1/p'
 
-quiet_cmd_offsets = OFFSETS $@
-      cmd_offsets = $(NM) $< | sed -n $(sed-offsets) > $@
+quiet_cmd_voffset = VOFFSET $@
+      cmd_voffset = $(NM) $< | sed -n $(sed-voffset) > $@
 
-$(obj)/offsets.h: $(obj)/compressed/vmlinux FORCE
-	$(call if_changed,offsets)
+targets += voffset.h
+$(obj)/voffset.h: vmlinux FORCE
+	$(call if_changed,voffset)
+
+sed-zoffset := -e 's/^\([0-9a-fA-F]*\) . \(startup_32\|input_data\|_end\|z_.*\)$$/\#define ZO_\2 0x\1/p'
+
+quiet_cmd_zoffset = ZOFFSET $@
+      cmd_zoffset = $(NM) $< | sed -n $(sed-zoffset) > $@
+
+targets += zoffset.h
+$(obj)/zoffset.h: $(obj)/compressed/vmlinux FORCE
+	$(call if_changed,zoffset)
 
-targets += offsets.h
 
 AFLAGS_header.o += -I$(obj)
-$(obj)/header.o: $(obj)/offsets.h
+$(obj)/header.o: $(obj)/voffset.h $(obj)/zoffset.h
 
 LDFLAGS_setup.elf	:= -T
 $(obj)/setup.elf: $(src)/setup.ld $(SETUP_OBJS) FORCE
diff --git a/arch/x86/boot/compressed/.gitignore b/arch/x86/boot/compressed/.gitignore
index 63eff3b..4a46fab 100644
--- a/arch/x86/boot/compressed/.gitignore
+++ b/arch/x86/boot/compressed/.gitignore
@@ -1,3 +1,6 @@
 relocs
 vmlinux.bin.all
 vmlinux.relocs
+vmlinux.lds
+mkpiggy
+piggy.S
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 65551c9..49c8a4c 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -19,7 +19,9 @@ KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
 LDFLAGS := -m elf_$(UTS_MACHINE)
 LDFLAGS_vmlinux := -T
 
-$(obj)/vmlinux: $(src)/vmlinux_$(BITS).lds $(obj)/head_$(BITS).o $(obj)/misc.o $(obj)/piggy.o FORCE
+hostprogs-y	:= mkpiggy
+
+$(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o $(obj)/piggy.o FORCE
 	$(call if_changed,ld)
 	@:
 
@@ -29,7 +31,7 @@ $(obj)/vmlinux.bin: vmlinux FORCE
 
 
 targets += vmlinux.bin.all vmlinux.relocs relocs
-hostprogs-$(CONFIG_X86_32) += relocs
+hostprogs-$(CONFIG_X86_NEED_RELOCS) += relocs
 
 quiet_cmd_relocs = RELOCS  $@
       cmd_relocs = $(obj)/relocs $< > $@;$(obj)/relocs --abs-relocs $<
@@ -37,46 +39,22 @@ $(obj)/vmlinux.relocs: vmlinux $(obj)/relocs FORCE
 	$(call if_changed,relocs)
 
 vmlinux.bin.all-y := $(obj)/vmlinux.bin
-vmlinux.bin.all-$(CONFIG_RELOCATABLE) += $(obj)/vmlinux.relocs
-quiet_cmd_relocbin = BUILD   $@
-      cmd_relocbin = cat $(filter-out FORCE,$^) > $@
-$(obj)/vmlinux.bin.all: $(vmlinux.bin.all-y) FORCE
-	$(call if_changed,relocbin)
-
-ifeq ($(CONFIG_X86_32),y)
+vmlinux.bin.all-$(CONFIG_X86_NEED_RELOCS) += $(obj)/vmlinux.relocs
 
-ifdef CONFIG_RELOCATABLE
-$(obj)/vmlinux.bin.gz: $(obj)/vmlinux.bin.all FORCE
-	$(call if_changed,gzip)
-$(obj)/vmlinux.bin.bz2: $(obj)/vmlinux.bin.all FORCE
-	$(call if_changed,bzip2)
-$(obj)/vmlinux.bin.lzma: $(obj)/vmlinux.bin.all FORCE
-	$(call if_changed,lzma)
-else
-$(obj)/vmlinux.bin.gz: $(obj)/vmlinux.bin FORCE
+$(obj)/vmlinux.bin.gz: $(vmlinux.bin.all-y) FORCE
 	$(call if_changed,gzip)
-$(obj)/vmlinux.bin.bz2: $(obj)/vmlinux.bin FORCE
+$(obj)/vmlinux.bin.bz2: $(vmlinux.bin.all-y) FORCE
 	$(call if_changed,bzip2)
-$(obj)/vmlinux.bin.lzma: $(obj)/vmlinux.bin FORCE
+$(obj)/vmlinux.bin.lzma: $(vmlinux.bin.all-y) FORCE
 	$(call if_changed,lzma)
-endif
-LDFLAGS_piggy.o := -r --format binary --oformat elf32-i386 -T
 
-else
+suffix-$(CONFIG_KERNEL_GZIP)	:= gz
+suffix-$(CONFIG_KERNEL_BZIP2)	:= bz2
+suffix-$(CONFIG_KERNEL_LZMA)	:= lzma
 
-$(obj)/vmlinux.bin.gz: $(obj)/vmlinux.bin FORCE
-	$(call if_changed,gzip)
-$(obj)/vmlinux.bin.bz2: $(obj)/vmlinux.bin FORCE
-	$(call if_changed,bzip2)
-$(obj)/vmlinux.bin.lzma: $(obj)/vmlinux.bin FORCE
-	$(call if_changed,lzma)
-
-LDFLAGS_piggy.o := -r --format binary --oformat elf64-x86-64 -T
-endif
+quiet_cmd_mkpiggy = MKPIGGY $@
+      cmd_mkpiggy = $(obj)/mkpiggy $< > $@ || ( rm -f $@ ; false )
 
-suffix_$(CONFIG_KERNEL_GZIP)  = gz
-suffix_$(CONFIG_KERNEL_BZIP2) = bz2
-suffix_$(CONFIG_KERNEL_LZMA)  = lzma
-
-$(obj)/piggy.o: $(obj)/vmlinux.scr $(obj)/vmlinux.bin.$(suffix_y) FORCE
-	$(call if_changed,ld)
+targets += piggy.S
+$(obj)/piggy.S: $(obj)/vmlinux.bin.$(suffix-y) $(obj)/mkpiggy FORCE
+	$(call if_changed,mkpiggy)
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 3a8a866..75e4f00 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -12,16 +12,16 @@
  * the page directory. [According to comments etc elsewhere on a compressed
  * kernel it will end up at 0x1000 + 1Mb I hope so as I assume this. - AC]
  *
- * Page 0 is deliberately kept safe, since System Management Mode code in 
+ * Page 0 is deliberately kept safe, since System Management Mode code in
  * laptops may need to access the BIOS data stored there.  This is also
- * useful for future device drivers that either access the BIOS via VM86 
+ * useful for future device drivers that either access the BIOS via VM86
  * mode.
  */
 
 /*
  * High loaded stuff by Hans Lermen & Werner Almesberger, Feb. 1996
  */
-.text
+	.text
 
 #include <linux/linkage.h>
 #include <asm/segment.h>
@@ -29,161 +29,151 @@
 #include <asm/boot.h>
 #include <asm/asm-offsets.h>
 
-.section ".text.head","ax",@progbits
+	.section ".text.head","ax",@progbits
 ENTRY(startup_32)
 	cld
-	/* test KEEP_SEGMENTS flag to see if the bootloader is asking
-	 * us to not reload segments */
-	testb $(1<<6), BP_loadflags(%esi)
-	jnz 1f
+	/*
+	 * Test KEEP_SEGMENTS flag to see if the bootloader is asking
+	 * us to not reload segments
+	 */
+	testb	$(1<<6), BP_loadflags(%esi)
+	jnz	1f
 
 	cli
-	movl $(__BOOT_DS),%eax
-	movl %eax,%ds
-	movl %eax,%es
-	movl %eax,%fs
-	movl %eax,%gs
-	movl %eax,%ss
+	movl	$__BOOT_DS, %eax
+	movl	%eax, %ds
+	movl	%eax, %es
+	movl	%eax, %fs
+	movl	%eax, %gs
+	movl	%eax, %ss
 1:
 
-/* Calculate the delta between where we were compiled to run
+/*
+ * Calculate the delta between where we were compiled to run
  * at and where we were actually loaded at.  This can only be done
  * with a short local call on x86.  Nothing  else will tell us what
  * address we are running at.  The reserved chunk of the real-mode
  * data at 0x1e4 (defined as a scratch field) are used as the stack
  * for this calculation. Only 4 bytes are needed.
  */
-	leal (0x1e4+4)(%esi), %esp
-	call 1f
-1:	popl %ebp
-	subl $1b, %ebp
+	leal	(BP_scratch+4)(%esi), %esp
+	call	1f
+1:	popl	%ebp
+	subl	$1b, %ebp
 
-/* %ebp contains the address we are loaded at by the boot loader and %ebx
+/*
+ * %ebp contains the address we are loaded at by the boot loader and %ebx
  * contains the address where we should move the kernel image temporarily
  * for safe in-place decompression.
  */
 
 #ifdef CONFIG_RELOCATABLE
-	movl 	%ebp, %ebx
-	addl    $(CONFIG_PHYSICAL_ALIGN - 1), %ebx
-	andl    $(~(CONFIG_PHYSICAL_ALIGN - 1)), %ebx
+	movl	%ebp, %ebx
+	movl	BP_kernel_alignment(%esi), %eax
+	decl	%eax
+	addl    %eax, %ebx
+	notl	%eax
+	andl    %eax, %ebx
 #else
-	movl $LOAD_PHYSICAL_ADDR, %ebx
+	movl	$LOAD_PHYSICAL_ADDR, %ebx
 #endif
 
-	/* Replace the compressed data size with the uncompressed size */
-	subl input_len(%ebp), %ebx
-	movl output_len(%ebp), %eax
-	addl %eax, %ebx
-	/* Add 8 bytes for every 32K input block */
-	shrl $12, %eax
-	addl %eax, %ebx
-	/* Add 32K + 18 bytes of extra slack */
-	addl $(32768 + 18), %ebx
-	/* Align on a 4K boundary */
-	addl $4095, %ebx
-	andl $~4095, %ebx
-
-/* Copy the compressed kernel to the end of our buffer
+	/* Target address to relocate to for decompression */
+	addl	$z_extract_offset, %ebx
+
+	/* Set up the stack */
+	leal	boot_stack_end(%ebx), %esp
+
+	/* Zero EFLAGS */
+	pushl	$0
+	popfl
+
+/*
+ * Copy the compressed kernel to the end of our buffer
  * where decompression in place becomes safe.
  */
-	pushl %esi
-	leal _end(%ebp), %esi
-	leal _end(%ebx), %edi
-	movl $(_end - startup_32), %ecx
+	pushl	%esi
+	leal	(_bss-4)(%ebp), %esi
+	leal	(_bss-4)(%ebx), %edi
+	movl	$(_bss - startup_32), %ecx
+	shrl	$2, %ecx
 	std
-	rep
-	movsb
+	rep	movsl
 	cld
-	popl %esi
-
-/* Compute the kernel start address.
- */
-#ifdef CONFIG_RELOCATABLE
-	addl    $(CONFIG_PHYSICAL_ALIGN - 1), %ebp
-	andl    $(~(CONFIG_PHYSICAL_ALIGN - 1)), %ebp
-#else
-	movl	$LOAD_PHYSICAL_ADDR, %ebp
-#endif
+	popl	%esi
 
 /*
  * Jump to the relocated address.
  */
-	leal relocated(%ebx), %eax
-	jmp *%eax
+	leal	relocated(%ebx), %eax
+	jmp	*%eax
 ENDPROC(startup_32)
 
-.section ".text"
+	.text
 relocated:
 
 /*
- * Clear BSS
- */
-	xorl %eax,%eax
-	leal _edata(%ebx),%edi
-	leal _end(%ebx), %ecx
-	subl %edi,%ecx
-	cld
-	rep
-	stosb
-
-/*
- * Setup the stack for the decompressor
+ * Clear BSS (stack is currently empty)
  */
-	leal boot_stack_end(%ebx), %esp
+	xorl	%eax, %eax
+	leal	_bss(%ebx), %edi
+	leal	_ebss(%ebx), %ecx
+	subl	%edi, %ecx
+	shrl	$2, %ecx
+	rep	stosl
 
 /*
  * Do the decompression, and jump to the new kernel..
  */
-	movl output_len(%ebx), %eax
-	pushl %eax
-			# push arguments for decompress_kernel:
-	pushl %ebp	# output address
-	movl input_len(%ebx), %eax
-	pushl %eax	# input_len
-	leal input_data(%ebx), %eax
-	pushl %eax	# input_data
-	leal boot_heap(%ebx), %eax
-	pushl %eax	# heap area
-	pushl %esi	# real mode pointer
-	call decompress_kernel
-	addl $20, %esp
-	popl %ecx
+	leal	z_extract_offset_negative(%ebx), %ebp
+				/* push arguments for decompress_kernel: */
+	pushl	%ebp		/* output address */
+	pushl	$z_input_len	/* input_len */
+	leal	input_data(%ebx), %eax
+	pushl	%eax		/* input_data */
+	leal	boot_heap(%ebx), %eax
+	pushl	%eax		/* heap area */
+	pushl	%esi		/* real mode pointer */
+	call	decompress_kernel
+	addl	$20, %esp
 
 #if CONFIG_RELOCATABLE
-/* Find the address of the relocations.
+/*
+ * Find the address of the relocations.
  */
-	movl %ebp, %edi
-	addl %ecx, %edi
+	leal	z_output_len(%ebp), %edi
 
-/* Calculate the delta between where vmlinux was compiled to run
+/*
+ * Calculate the delta between where vmlinux was compiled to run
  * and where it was actually loaded.
  */
-	movl %ebp, %ebx
-	subl $LOAD_PHYSICAL_ADDR, %ebx
-	jz   2f		/* Nothing to be done if loaded at compiled addr. */
+	movl	%ebp, %ebx
+	subl	$LOAD_PHYSICAL_ADDR, %ebx
+	jz	2f	/* Nothing to be done if loaded at compiled addr. */
 /*
  * Process relocations.
  */
 
-1:	subl $4, %edi
-	movl 0(%edi), %ecx
-	testl %ecx, %ecx
-	jz 2f
-	addl %ebx, -__PAGE_OFFSET(%ebx, %ecx)
-	jmp 1b
+1:	subl	$4, %edi
+	movl	(%edi), %ecx
+	testl	%ecx, %ecx
+	jz	2f
+	addl	%ebx, -__PAGE_OFFSET(%ebx, %ecx)
+	jmp	1b
 2:
 #endif
 
 /*
  * Jump to the decompressed kernel.
  */
-	xorl %ebx,%ebx
-	jmp *%ebp
+	xorl	%ebx, %ebx
+	jmp	*%ebp
 
-.bss
-/* Stack and heap for uncompression */
-.balign 4
+/*
+ * Stack and heap for uncompression
+ */
+	.bss
+	.balign 4
 boot_heap:
 	.fill BOOT_HEAP_SIZE, 1, 0
 boot_stack:
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index ed4a829..f62c284 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -21,8 +21,8 @@
 /*
  * High loaded stuff by Hans Lermen & Werner Almesberger, Feb. 1996
  */
-.code32
-.text
+	.code32
+	.text
 
 #include <linux/linkage.h>
 #include <asm/segment.h>
@@ -33,12 +33,14 @@
 #include <asm/processor-flags.h>
 #include <asm/asm-offsets.h>
 
-.section ".text.head"
+	.section ".text.head"
 	.code32
 ENTRY(startup_32)
 	cld
-	/* test KEEP_SEGMENTS flag to see if the bootloader is asking
-	 * us to not reload segments */
+	/*
+	 * Test KEEP_SEGMENTS flag to see if the bootloader is asking
+	 * us to not reload segments
+	 */
 	testb $(1<<6), BP_loadflags(%esi)
 	jnz 1f
 
@@ -49,14 +51,15 @@ ENTRY(startup_32)
 	movl	%eax, %ss
 1:
 
-/* Calculate the delta between where we were compiled to run
+/*
+ * Calculate the delta between where we were compiled to run
  * at and where we were actually loaded at.  This can only be done
  * with a short local call on x86.  Nothing  else will tell us what
  * address we are running at.  The reserved chunk of the real-mode
  * data at 0x1e4 (defined as a scratch field) are used as the stack
  * for this calculation. Only 4 bytes are needed.
  */
-	leal	(0x1e4+4)(%esi), %esp
+	leal	(BP_scratch+4)(%esi), %esp
 	call	1f
 1:	popl	%ebp
 	subl	$1b, %ebp
@@ -70,32 +73,28 @@ ENTRY(startup_32)
 	testl	%eax, %eax
 	jnz	no_longmode
 
-/* Compute the delta between where we were compiled to run at
+/*
+ * Compute the delta between where we were compiled to run at
  * and where the code will actually run at.
- */
-/* %ebp contains the address we are loaded at by the boot loader and %ebx
+ *
+ * %ebp contains the address we are loaded at by the boot loader and %ebx
  * contains the address where we should move the kernel image temporarily
  * for safe in-place decompression.
  */
 
 #ifdef CONFIG_RELOCATABLE
 	movl	%ebp, %ebx
-	addl	$(PMD_PAGE_SIZE -1), %ebx
-	andl	$PMD_PAGE_MASK, %ebx
+	movl	BP_kernel_alignment(%esi), %eax
+	decl	%eax
+	addl	%eax, %ebx
+	notl	%eax
+	andl	%eax, %ebx
 #else
-	movl	$CONFIG_PHYSICAL_START, %ebx
+	movl	$LOAD_PHYSICAL_ADDR, %ebx
 #endif
 
-	/* Replace the compressed data size with the uncompressed size */
-	subl	input_len(%ebp), %ebx
-	movl	output_len(%ebp), %eax
-	addl	%eax, %ebx
-	/* Add 8 bytes for every 32K input block */
-	shrl	$12, %eax
-	addl	%eax, %ebx
-	/* Add 32K + 18 bytes of extra slack and align on a 4K boundary */
-	addl	$(32768 + 18 + 4095), %ebx
-	andl	$~4095, %ebx
+	/* Target address to relocate to for decompression */
+	addl	$z_extract_offset, %ebx
 
 /*
  * Prepare for entering 64 bit mode
@@ -114,7 +113,7 @@ ENTRY(startup_32)
  /*
   * Build early 4G boot pagetable
   */
-	/* Initialize Page tables to 0*/
+	/* Initialize Page tables to 0 */
 	leal	pgtable(%ebx), %edi
 	xorl	%eax, %eax
 	movl	$((4096*6)/4), %ecx
@@ -155,7 +154,8 @@ ENTRY(startup_32)
 	btsl	$_EFER_LME, %eax
 	wrmsr
 
-	/* Setup for the jump to 64bit mode
+	/*
+	 * Setup for the jump to 64bit mode
 	 *
 	 * When the jump is performend we will be in long mode but
 	 * in 32bit compatibility mode with EFER.LME = 1, CS.L = 0, CS.D = 1
@@ -184,7 +184,8 @@ no_longmode:
 
 #include "../../kernel/verify_cpu_64.S"
 
-	/* Be careful here startup_64 needs to be at a predictable
+	/*
+	 * Be careful here startup_64 needs to be at a predictable
 	 * address so I can export it in an ELF header.  Bootloaders
 	 * should look at the ELF header to find this address, as
 	 * it may change in the future.
@@ -192,7 +193,8 @@ no_longmode:
 	.code64
 	.org 0x200
 ENTRY(startup_64)
-	/* We come here either from startup_32 or directly from a
+	/*
+	 * We come here either from startup_32 or directly from a
 	 * 64bit bootloader.  If we come here from a bootloader we depend on
 	 * an identity mapped page table being provied that maps our
 	 * entire text+data+bss and hopefully all of memory.
@@ -209,50 +211,54 @@ ENTRY(startup_64)
 	movl    $0x20, %eax
 	ltr	%ax
 
-	/* Compute the decompressed kernel start address.  It is where
+	/*
+	 * Compute the decompressed kernel start address.  It is where
 	 * we were loaded at aligned to a 2M boundary. %rbp contains the
 	 * decompressed kernel start address.
 	 *
 	 * If it is a relocatable kernel then decompress and run the kernel
 	 * from load address aligned to 2MB addr, otherwise decompress and
-	 * run the kernel from CONFIG_PHYSICAL_START
+	 * run the kernel from LOAD_PHYSICAL_ADDR
+	 *
+	 * We cannot rely on the calculation done in 32-bit mode, since we
+	 * may have been invoked via the 64-bit entry point.
 	 */
 
 	/* Start with the delta to where the kernel will run at. */
 #ifdef CONFIG_RELOCATABLE
 	leaq	startup_32(%rip) /* - $startup_32 */, %rbp
-	addq	$(PMD_PAGE_SIZE - 1), %rbp
-	andq	$PMD_PAGE_MASK, %rbp
-	movq	%rbp, %rbx
+	movl	BP_kernel_alignment(%rsi), %eax
+	decl	%eax
+	addq	%rax, %rbp
+	notq	%rax
+	andq	%rax, %rbp
 #else
-	movq	$CONFIG_PHYSICAL_START, %rbp
-	movq	%rbp, %rbx
+	movq	$LOAD_PHYSICAL_ADDR, %rbp
 #endif
 
-	/* Replace the compressed data size with the uncompressed size */
-	movl	input_len(%rip), %eax
-	subq	%rax, %rbx
-	movl	output_len(%rip), %eax
-	addq	%rax, %rbx
-	/* Add 8 bytes for every 32K input block */
-	shrq	$12, %rax
-	addq	%rax, %rbx
-	/* Add 32K + 18 bytes of extra slack and align on a 4K boundary */
-	addq	$(32768 + 18 + 4095), %rbx
-	andq	$~4095, %rbx
-
-/* Copy the compressed kernel to the end of our buffer
+	/* Target address to relocate to for decompression */
+	leaq	z_extract_offset(%rbp), %rbx
+
+	/* Set up the stack */
+	leaq	boot_stack_end(%rbx), %rsp
+
+	/* Zero EFLAGS */
+	pushq	$0
+	popfq
+
+/*
+ * Copy the compressed kernel to the end of our buffer
  * where decompression in place becomes safe.
  */
-	leaq	_end_before_pgt(%rip), %r8
-	leaq	_end_before_pgt(%rbx), %r9
-	movq	$_end_before_pgt /* - $startup_32 */, %rcx
-1:	subq	$8, %r8
-	subq	$8, %r9
-	movq	0(%r8), %rax
-	movq	%rax, 0(%r9)
-	subq	$8, %rcx
-	jnz	1b
+	pushq	%rsi
+	leaq	(_bss-8)(%rip), %rsi
+	leaq	(_bss-8)(%rbx), %rdi
+	movq	$_bss /* - $startup_32 */, %rcx
+	shrq	$3, %rcx
+	std
+	rep	movsq
+	cld
+	popq	%rsi
 
 /*
  * Jump to the relocated address.
@@ -260,37 +266,28 @@ ENTRY(startup_64)
 	leaq	relocated(%rbx), %rax
 	jmp	*%rax
 
-.section ".text"
+	.text
 relocated:
 
 /*
- * Clear BSS
+ * Clear BSS (stack is currently empty)
  */
-	xorq	%rax, %rax
-	leaq    _edata(%rbx), %rdi
-	leaq    _end_before_pgt(%rbx), %rcx
+	xorl	%eax, %eax
+	leaq    _bss(%rip), %rdi
+	leaq    _ebss(%rip), %rcx
 	subq	%rdi, %rcx
-	cld
-	rep
-	stosb
-
-	/* Setup the stack */
-	leaq	boot_stack_end(%rip), %rsp
-
-	/* zero EFLAGS after setting rsp */
-	pushq	$0
-	popfq
+	shrq	$3, %rcx
+	rep	stosq
 
 /*
  * Do the decompression, and jump to the new kernel..
  */
-	pushq	%rsi			# Save the real mode argument
-	movq	%rsi, %rdi		# real mode address
-	leaq	boot_heap(%rip), %rsi	# malloc area for uncompression
-	leaq	input_data(%rip), %rdx  # input_data
-	movl	input_len(%rip), %eax
-	movq	%rax, %rcx		# input_len
-	movq	%rbp, %r8		# output
+	pushq	%rsi			/* Save the real mode argument */
+	movq	%rsi, %rdi		/* real mode address */
+	leaq	boot_heap(%rip), %rsi	/* malloc area for uncompression */
+	leaq	input_data(%rip), %rdx  /* input_data */
+	movl	$z_input_len, %ecx	/* input_len */
+	movq	%rbp, %r8		/* output target address */
 	call	decompress_kernel
 	popq	%rsi
 
@@ -311,11 +308,21 @@ gdt:
 	.quad   0x0000000000000000	/* TS continued */
 gdt_end:
 
-.bss
-/* Stack and heap for uncompression */
-.balign 4
+/*
+ * Stack and heap for uncompression
+ */
+	.bss
+	.balign 4
 boot_heap:
 	.fill BOOT_HEAP_SIZE, 1, 0
 boot_stack:
 	.fill BOOT_STACK_SIZE, 1, 0
 boot_stack_end:
+
+/*
+ * Space for page tables (not in .bss so not zeroed)
+ */
+	.section ".pgtable","a",@nobits
+	.balign 4096
+pgtable:
+	.fill 6*4096, 1, 0
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index e45be73..842b2a3 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -325,21 +325,19 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 	free_mem_ptr     = heap;	/* Heap */
 	free_mem_end_ptr = heap + BOOT_HEAP_SIZE;
 
+	if ((unsigned long)output & (MIN_KERNEL_ALIGN - 1))
+		error("Destination address inappropriately aligned");
 #ifdef CONFIG_X86_64
-	if ((unsigned long)output & (__KERNEL_ALIGN - 1))
-		error("Destination address not 2M aligned");
-	if ((unsigned long)output >= 0xffffffffffUL)
+	if (heap > 0x3fffffffffffUL)
 		error("Destination address too large");
 #else
-	if ((u32)output & (CONFIG_PHYSICAL_ALIGN - 1))
-		error("Destination address not CONFIG_PHYSICAL_ALIGN aligned");
 	if (heap > ((-__PAGE_OFFSET-(512<<20)-1) & 0x7fffffff))
 		error("Destination address too large");
+#endif
 #ifndef CONFIG_RELOCATABLE
-	if ((u32)output != LOAD_PHYSICAL_ADDR)
+	if ((unsigned long)output != LOAD_PHYSICAL_ADDR)
 		error("Wrong destination address");
 #endif
-#endif
 
 	if (!quiet)
 		putstr("\nDecompressing Linux... ");
diff --git a/arch/x86/boot/compressed/mkpiggy.c b/arch/x86/boot/compressed/mkpiggy.c
new file mode 100644
index 0000000..bcbd36c
--- /dev/null
+++ b/arch/x86/boot/compressed/mkpiggy.c
@@ -0,0 +1,97 @@
+/* ----------------------------------------------------------------------- *
+ *
+ *  Copyright (C) 2009 Intel Corporation. All rights reserved.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License version
+ *  2 as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ *  02110-1301, USA.
+ *
+ *  H. Peter Anvin <hpa@linux.intel.com>
+ *
+ * ----------------------------------------------------------------------- */
+
+/*
+ * Compute the desired load offset from a compressed program; outputs
+ * a small assembly wrapper with the appropriate symbols defined.
+ */
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <inttypes.h>
+
+static uint32_t getle32(const void *p)
+{
+	const uint8_t *cp = p;
+
+	return (uint32_t)cp[0] + ((uint32_t)cp[1] << 8) +
+		((uint32_t)cp[2] << 16) + ((uint32_t)cp[3] << 24);
+}
+
+int main(int argc, char *argv[])
+{
+	uint32_t olen;
+	long ilen;
+	unsigned long offs;
+	FILE *f;
+
+	if (argc < 2) {
+		fprintf(stderr, "Usage: %s compressed_file\n", argv[0]);
+		return 1;
+	}
+
+	/* Get the information for the compressed kernel image first */
+
+	f = fopen(argv[1], "r");
+	if (!f) {
+		perror(argv[1]);
+		return 1;
+	}
+
+
+	if (fseek(f, -4L, SEEK_END)) {
+		perror(argv[1]);
+	}
+	fread(&olen, sizeof olen, 1, f);
+	ilen = ftell(f);
+	olen = getle32(&olen);
+	fclose(f);
+
+	/*
+	 * Now we have the input (compressed) and output (uncompressed)
+	 * sizes, compute the necessary decompression offset...
+	 */
+
+	offs = (olen > ilen) ? olen - ilen : 0;
+	offs += olen >> 12;	/* Add 8 bytes for each 32K block */
+	offs += 32*1024 + 18;	/* Add 32K + 18 bytes slack */
+	offs = (offs+4095) & ~4095; /* Round to a 4K boundary */
+
+	printf(".section \".rodata.compressed\",\"a\",@progbits\n");
+	printf(".globl z_input_len\n");
+	printf("z_input_len = %lu\n", ilen);
+	printf(".globl z_output_len\n");
+	printf("z_output_len = %lu\n", (unsigned long)olen);
+	printf(".globl z_extract_offset\n");
+	printf("z_extract_offset = 0x%lx\n", offs);
+	/* z_extract_offset_negative allows simplification of head_32.S */
+	printf(".globl z_extract_offset_negative\n");
+	printf("z_extract_offset_negative = -0x%lx\n", offs);
+
+	printf(".globl input_data, input_data_end\n");
+	printf("input_data:\n");
+	printf(".incbin \"%s\"\n", argv[1]);
+	printf("input_data_end:\n");
+
+	return 0;
+}
diff --git a/arch/x86/boot/compressed/vmlinux_64.lds b/arch/x86/boot/compressed/vmlinux.lds.S
similarity index 57%
rename from arch/x86/boot/compressed/vmlinux_64.lds
rename to arch/x86/boot/compressed/vmlinux.lds.S
index bef1ac8..cc353e1 100644
--- a/arch/x86/boot/compressed/vmlinux_64.lds
+++ b/arch/x86/boot/compressed/vmlinux.lds.S
@@ -1,6 +1,17 @@
-OUTPUT_FORMAT("elf64-x86-64", "elf64-x86-64", "elf64-x86-64")
+OUTPUT_FORMAT(CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT)
+
+#undef i386
+
+#include <asm/page_types.h>
+
+#ifdef CONFIG_X86_64
 OUTPUT_ARCH(i386:x86-64)
 ENTRY(startup_64)
+#else
+OUTPUT_ARCH(i386)
+ENTRY(startup_32)
+#endif
+
 SECTIONS
 {
 	/* Be careful parts of head_64.S assume startup_32 is at
@@ -33,16 +44,22 @@ SECTIONS
 		*(.data.*)
 		_edata = . ;
 	}
+	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
 	.bss : {
 		_bss = . ;
 		*(.bss)
 		*(.bss.*)
 		*(COMMON)
-		. = ALIGN(8);
-		_end_before_pgt = . ;
-		. = ALIGN(4096);
-		pgtable = . ;
-		. = . + 4096 * 6;
+		. = ALIGN(8);	/* For convenience during zeroing */
 		_ebss = .;
 	}
+#ifdef CONFIG_X86_64
+       . = ALIGN(PAGE_SIZE);
+       .pgtable : {
+		_pgtable = . ;
+		*(.pgtable)
+		_epgtable = . ;
+	}
+#endif
+	_end = .;
 }
diff --git a/arch/x86/boot/compressed/vmlinux.scr b/arch/x86/boot/compressed/vmlinux.scr
deleted file mode 100644
index f02382a..0000000
--- a/arch/x86/boot/compressed/vmlinux.scr
+++ /dev/null
@@ -1,10 +0,0 @@
-SECTIONS
-{
-  .rodata.compressed : {
-	input_len = .;
-	LONG(input_data_end - input_data) input_data = .;
-	*(.data)
-	output_len = . - 4;
-	input_data_end = .;
-	}
-}
diff --git a/arch/x86/boot/compressed/vmlinux_32.lds b/arch/x86/boot/compressed/vmlinux_32.lds
deleted file mode 100644
index bb3c483..0000000
--- a/arch/x86/boot/compressed/vmlinux_32.lds
+++ /dev/null
@@ -1,43 +0,0 @@
-OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
-OUTPUT_ARCH(i386)
-ENTRY(startup_32)
-SECTIONS
-{
-	/* Be careful parts of head_32.S assume startup_32 is at
-	 * address 0.
-	 */
-	. = 0;
-	.text.head : {
-		_head = . ;
-		*(.text.head)
-		_ehead = . ;
-	}
-	.rodata.compressed : {
-		*(.rodata.compressed)
-	}
-	.text :	{
-		_text = .; 	/* Text */
-		*(.text)
-		*(.text.*)
-		_etext = . ;
-	}
-	.rodata : {
-		_rodata = . ;
-		*(.rodata)	 /* read-only data */
-		*(.rodata.*)
-		_erodata = . ;
-	}
-	.data :	{
-		_data = . ;
-		*(.data)
-		*(.data.*)
-		_edata = . ;
-	}
-	.bss : {
-		_bss = . ;
-		*(.bss)
-		*(.bss.*)
-		*(COMMON)
-		_end = . ;
-	}
-}
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 5d84d1c..1040f6e 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -22,7 +22,8 @@
 #include <asm/page_types.h>
 #include <asm/setup.h>
 #include "boot.h"
-#include "offsets.h"
+#include "voffset.h"
+#include "zoffset.h"
 
 BOOTSEG		= 0x07C0		/* original address of boot-sector */
 SYSSEG		= 0x1000		/* historical load address >> 4 */
@@ -115,7 +116,7 @@ _start:
 	# Part 2 of the header, from the old setup.S
 
 		.ascii	"HdrS"		# header signature
-		.word	0x0209		# header version number (>= 0x0105)
+		.word	0x020a		# header version number (>= 0x0105)
 					# or else old loadlin-1.5 will fail)
 		.globl realmode_swtch
 realmode_swtch:	.word	0, 0		# default_switch, SETUPSEG
@@ -168,7 +169,11 @@ heap_end_ptr:	.word	_end+STACK_SIZE-512
 					# end of setup code can be used by setup
 					# for local heap purposes.
 
-pad1:		.word	0
+ext_loader_ver:
+		.byte	0		# Extended boot loader version
+ext_loader_type:
+		.byte	0		# Extended boot loader type
+
 cmd_line_ptr:	.long	0		# (Header version 0x0202 or later)
 					# If nonzero, a 32-bit pointer
 					# to the kernel command line.
@@ -200,7 +205,7 @@ relocatable_kernel:    .byte 1
 #else
 relocatable_kernel:    .byte 0
 #endif
-pad2:			.byte 0
+min_alignment:		.byte MIN_KERNEL_ALIGN_LG2	# minimum alignment
 pad3:			.word 0
 
 cmdline_size:   .long   COMMAND_LINE_SIZE-1     #length of the command line,
@@ -212,13 +217,24 @@ hardware_subarch:	.long 0			# subarchitecture, added with 2.07
 
 hardware_subarch_data:	.quad 0
 
-payload_offset:		.long input_data
-payload_length:		.long input_data_end-input_data
+payload_offset:		.long ZO_input_data
+payload_length:		.long ZO_z_input_len
 
 setup_data:		.quad 0			# 64-bit physical pointer to
 						# single linked list of
 						# struct setup_data
 
+pref_address:		.quad LOAD_PHYSICAL_ADDR	# preferred load addr
+
+#define ZO_INIT_SIZE	(ZO__end - ZO_startup_32 + ZO_z_extract_offset)
+#define VO_INIT_SIZE	(VO__end - VO__text)
+#if ZO_INIT_SIZE > VO_INIT_SIZE
+#define INIT_SIZE ZO_INIT_SIZE
+#else
+#define INIT_SIZE VO_INIT_SIZE
+#endif
+init_size:		.long INIT_SIZE		# kernel initialization size
+
 # End of setup header #####################################################
 
 	.section ".inittext", "ax"
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 235b81d..edb992e 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -1,12 +1,13 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.29-rc4
-# Tue Feb 24 15:50:58 2009
+# Linux kernel version: 2.6.30-rc2
+# Mon May 11 16:21:55 2009
 #
 # CONFIG_64BIT is not set
 CONFIG_X86_32=y
 # CONFIG_X86_64 is not set
 CONFIG_X86=y
+CONFIG_OUTPUT_FORMAT="elf32-i386"
 CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
 CONFIG_GENERIC_TIME=y
 CONFIG_GENERIC_CMOS_UPDATE=y
@@ -33,6 +34,7 @@ CONFIG_ARCH_HAS_CPU_RELAX=y
 CONFIG_ARCH_HAS_DEFAULT_IDLE=y
 CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
 CONFIG_HAVE_SETUP_PER_CPU_AREA=y
+CONFIG_HAVE_DYNAMIC_PER_CPU_AREA=y
 # CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
 CONFIG_ARCH_HIBERNATION_POSSIBLE=y
 CONFIG_ARCH_SUSPEND_POSSIBLE=y
@@ -40,15 +42,16 @@ CONFIG_ARCH_SUSPEND_POSSIBLE=y
 CONFIG_ARCH_POPULATES_NODE_MAP=y
 # CONFIG_AUDIT_ARCH is not set
 CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
+CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
 CONFIG_GENERIC_HARDIRQS=y
+CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
 CONFIG_GENERIC_IRQ_PROBE=y
 CONFIG_GENERIC_PENDING_IRQ=y
-CONFIG_X86_SMP=y
 CONFIG_USE_GENERIC_SMP_HELPERS=y
 CONFIG_X86_32_SMP=y
 CONFIG_X86_HT=y
-CONFIG_X86_BIOS_REBOOT=y
 CONFIG_X86_TRAMPOLINE=y
+CONFIG_X86_32_LAZY_GS=y
 CONFIG_KTIME_SCALAR=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
@@ -60,10 +63,17 @@ CONFIG_LOCK_KERNEL=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
 CONFIG_LOCALVERSION=""
 # CONFIG_LOCALVERSION_AUTO is not set
+CONFIG_HAVE_KERNEL_GZIP=y
+CONFIG_HAVE_KERNEL_BZIP2=y
+CONFIG_HAVE_KERNEL_LZMA=y
+CONFIG_KERNEL_GZIP=y
+# CONFIG_KERNEL_BZIP2 is not set
+# CONFIG_KERNEL_LZMA is not set
 CONFIG_SWAP=y
 CONFIG_SYSVIPC=y
 CONFIG_SYSVIPC_SYSCTL=y
 CONFIG_POSIX_MQUEUE=y
+CONFIG_POSIX_MQUEUE_SYSCTL=y
 CONFIG_BSD_PROCESS_ACCT=y
 # CONFIG_BSD_PROCESS_ACCT_V3 is not set
 CONFIG_TASKSTATS=y
@@ -113,23 +123,26 @@ CONFIG_PID_NS=y
 CONFIG_NET_NS=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
+CONFIG_RD_GZIP=y
+CONFIG_RD_BZIP2=y
+CONFIG_RD_LZMA=y
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_SYSCTL=y
+CONFIG_ANON_INODES=y
 # CONFIG_EMBEDDED is not set
 CONFIG_UID16=y
 CONFIG_SYSCTL_SYSCALL=y
 CONFIG_KALLSYMS=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
+# CONFIG_STRIP_ASM_SYMS is not set
 CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
 CONFIG_PCSPKR_PLATFORM=y
-# CONFIG_COMPAT_BRK is not set
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
-CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
 CONFIG_TIMERFD=y
@@ -139,6 +152,7 @@ CONFIG_AIO=y
 CONFIG_VM_EVENT_COUNTERS=y
 CONFIG_PCI_QUIRKS=y
 CONFIG_SLUB_DEBUG=y
+# CONFIG_COMPAT_BRK is not set
 # CONFIG_SLAB is not set
 CONFIG_SLUB=y
 # CONFIG_SLOB is not set
@@ -154,6 +168,8 @@ CONFIG_HAVE_IOREMAP_PROT=y
 CONFIG_HAVE_KPROBES=y
 CONFIG_HAVE_KRETPROBES=y
 CONFIG_HAVE_ARCH_TRACEHOOK=y
+CONFIG_HAVE_DMA_API_DEBUG=y
+# CONFIG_SLOW_WORK is not set
 CONFIG_HAVE_GENERIC_DMA_COHERENT=y
 CONFIG_SLABINFO=y
 CONFIG_RT_MUTEXES=y
@@ -167,7 +183,6 @@ CONFIG_MODULE_FORCE_UNLOAD=y
 CONFIG_STOP_MACHINE=y
 CONFIG_BLOCK=y
 # CONFIG_LBD is not set
-CONFIG_BLK_DEV_IO_TRACE=y
 CONFIG_BLK_DEV_BSG=y
 # CONFIG_BLK_DEV_INTEGRITY is not set
 
@@ -194,12 +209,12 @@ CONFIG_HIGH_RES_TIMERS=y
 CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
 CONFIG_SMP=y
 CONFIG_SPARSE_IRQ=y
-CONFIG_X86_FIND_SMP_CONFIG=y
 CONFIG_X86_MPPARSE=y
+# CONFIG_X86_BIGSMP is not set
+CONFIG_X86_EXTENDED_PLATFORM=y
 # CONFIG_X86_ELAN is not set
-# CONFIG_X86_GENERICARCH is not set
-# CONFIG_X86_VSMP is not set
 # CONFIG_X86_RDC321X is not set
+# CONFIG_X86_32_NON_STANDARD is not set
 CONFIG_SCHED_OMIT_FRAME_POINTER=y
 # CONFIG_PARAVIRT_GUEST is not set
 # CONFIG_MEMTEST is not set
@@ -230,8 +245,10 @@ CONFIG_M686=y
 # CONFIG_GENERIC_CPU is not set
 CONFIG_X86_GENERIC=y
 CONFIG_X86_CPU=y
+CONFIG_X86_L1_CACHE_BYTES=64
+CONFIG_X86_INTERNODE_CACHE_BYTES=64
 CONFIG_X86_CMPXCHG=y
-CONFIG_X86_L1_CACHE_SHIFT=7
+CONFIG_X86_L1_CACHE_SHIFT=5
 CONFIG_X86_XADD=y
 # CONFIG_X86_PPRO_FENCE is not set
 CONFIG_X86_WP_WORKS_OK=y
@@ -247,7 +264,7 @@ CONFIG_X86_DEBUGCTLMSR=y
 CONFIG_CPU_SUP_INTEL=y
 CONFIG_CPU_SUP_CYRIX_32=y
 CONFIG_CPU_SUP_AMD=y
-CONFIG_CPU_SUP_CENTAUR_32=y
+CONFIG_CPU_SUP_CENTAUR=y
 CONFIG_CPU_SUP_TRANSMETA_32=y
 CONFIG_CPU_SUP_UMC_32=y
 CONFIG_X86_DS=y
@@ -279,6 +296,7 @@ CONFIG_MICROCODE_AMD=y
 CONFIG_MICROCODE_OLD_INTERFACE=y
 CONFIG_X86_MSR=y
 CONFIG_X86_CPUID=y
+# CONFIG_X86_CPU_DEBUG is not set
 # CONFIG_NOHIGHMEM is not set
 CONFIG_HIGHMEM4G=y
 # CONFIG_HIGHMEM64G is not set
@@ -302,6 +320,8 @@ CONFIG_ZONE_DMA_FLAG=1
 CONFIG_BOUNCE=y
 CONFIG_VIRT_TO_BUS=y
 CONFIG_UNEVICTABLE_LRU=y
+CONFIG_HAVE_MLOCK=y
+CONFIG_HAVE_MLOCKED_PAGE_BIT=y
 CONFIG_HIGHPTE=y
 CONFIG_X86_CHECK_BIOS_CORRUPTION=y
 CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
@@ -312,6 +332,7 @@ CONFIG_MTRR=y
 CONFIG_X86_PAT=y
 CONFIG_EFI=y
 CONFIG_SECCOMP=y
+# CONFIG_CC_STACKPROTECTOR is not set
 # CONFIG_HZ_100 is not set
 # CONFIG_HZ_250 is not set
 # CONFIG_HZ_300 is not set
@@ -322,8 +343,9 @@ CONFIG_KEXEC=y
 CONFIG_CRASH_DUMP=y
 # CONFIG_KEXEC_JUMP is not set
 CONFIG_PHYSICAL_START=0x1000000
-# CONFIG_RELOCATABLE is not set
-CONFIG_PHYSICAL_ALIGN=0x200000
+CONFIG_RELOCATABLE=y
+CONFIG_X86_NEED_RELOCS=y
+CONFIG_PHYSICAL_ALIGN=0x1000000
 CONFIG_HOTPLUG_CPU=y
 # CONFIG_COMPAT_VDSO is not set
 # CONFIG_CMDLINE_BOOL is not set
@@ -363,7 +385,6 @@ CONFIG_ACPI_THERMAL=y
 CONFIG_ACPI_BLACKLIST_YEAR=0
 # CONFIG_ACPI_DEBUG is not set
 # CONFIG_ACPI_PCI_SLOT is not set
-CONFIG_ACPI_SYSTEM=y
 CONFIG_X86_PM_TIMER=y
 CONFIG_ACPI_CONTAINER=y
 # CONFIG_ACPI_SBS is not set
@@ -425,6 +446,7 @@ CONFIG_PCI_BIOS=y
 CONFIG_PCI_DIRECT=y
 CONFIG_PCI_MMCONFIG=y
 CONFIG_PCI_DOMAINS=y
+# CONFIG_DMAR is not set
 CONFIG_PCIEPORTBUS=y
 # CONFIG_HOTPLUG_PCI_PCIE is not set
 CONFIG_PCIEAER=y
@@ -435,6 +457,7 @@ CONFIG_PCI_MSI=y
 # CONFIG_PCI_DEBUG is not set
 # CONFIG_PCI_STUB is not set
 CONFIG_HT_IRQ=y
+# CONFIG_PCI_IOV is not set
 CONFIG_ISA_DMA_API=y
 # CONFIG_ISA is not set
 # CONFIG_MCA is not set
@@ -481,7 +504,6 @@ CONFIG_NET=y
 #
 # Networking options
 #
-CONFIG_COMPAT_NET_DEV_OPS=y
 CONFIG_PACKET=y
 CONFIG_PACKET_MMAP=y
 CONFIG_UNIX=y
@@ -639,6 +661,7 @@ CONFIG_LLC=y
 # CONFIG_LAPB is not set
 # CONFIG_ECONET is not set
 # CONFIG_WAN_ROUTER is not set
+# CONFIG_PHONET is not set
 CONFIG_NET_SCHED=y
 
 #
@@ -696,6 +719,7 @@ CONFIG_NET_SCH_FIFO=y
 #
 # CONFIG_NET_PKTGEN is not set
 # CONFIG_NET_TCPPROBE is not set
+# CONFIG_NET_DROP_MONITOR is not set
 CONFIG_HAMRADIO=y
 
 #
@@ -706,12 +730,10 @@ CONFIG_HAMRADIO=y
 # CONFIG_IRDA is not set
 # CONFIG_BT is not set
 # CONFIG_AF_RXRPC is not set
-# CONFIG_PHONET is not set
 CONFIG_FIB_RULES=y
 CONFIG_WIRELESS=y
 CONFIG_CFG80211=y
 # CONFIG_CFG80211_REG_DEBUG is not set
-CONFIG_NL80211=y
 CONFIG_WIRELESS_OLD_REGULATORY=y
 CONFIG_WIRELESS_EXT=y
 CONFIG_WIRELESS_EXT_SYSFS=y
@@ -789,6 +811,7 @@ CONFIG_MISC_DEVICES=y
 # CONFIG_ICS932S401 is not set
 # CONFIG_ENCLOSURE_SERVICES is not set
 # CONFIG_HP_ILO is not set
+# CONFIG_ISL29003 is not set
 # CONFIG_C2PORT is not set
 
 #
@@ -842,6 +865,7 @@ CONFIG_SCSI_SPI_ATTRS=y
 # CONFIG_SCSI_LOWLEVEL is not set
 # CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
 # CONFIG_SCSI_DH is not set
+# CONFIG_SCSI_OSD_INITIATOR is not set
 CONFIG_ATA=y
 # CONFIG_ATA_NONSTANDARD is not set
 CONFIG_ATA_ACPI=y
@@ -940,6 +964,7 @@ CONFIG_DM_ZERO=y
 CONFIG_MACINTOSH_DRIVERS=y
 CONFIG_MAC_EMUMOUSEBTN=y
 CONFIG_NETDEVICES=y
+CONFIG_COMPAT_NET_DEV_OPS=y
 # CONFIG_IFB is not set
 # CONFIG_DUMMY is not set
 # CONFIG_BONDING is not set
@@ -977,6 +1002,8 @@ CONFIG_MII=y
 CONFIG_NET_VENDOR_3COM=y
 # CONFIG_VORTEX is not set
 # CONFIG_TYPHOON is not set
+# CONFIG_ETHOC is not set
+# CONFIG_DNET is not set
 CONFIG_NET_TULIP=y
 # CONFIG_DE2104X is not set
 # CONFIG_TULIP is not set
@@ -1026,6 +1053,7 @@ CONFIG_E1000=y
 CONFIG_E1000E=y
 # CONFIG_IP1000 is not set
 # CONFIG_IGB is not set
+# CONFIG_IGBVF is not set
 # CONFIG_NS83820 is not set
 # CONFIG_HAMACHI is not set
 # CONFIG_YELLOWFIN is not set
@@ -1040,6 +1068,7 @@ CONFIG_BNX2=y
 # CONFIG_QLA3XXX is not set
 # CONFIG_ATL1 is not set
 # CONFIG_ATL1E is not set
+# CONFIG_ATL1C is not set
 # CONFIG_JME is not set
 CONFIG_NETDEV_10000=y
 # CONFIG_CHELSIO_T1 is not set
@@ -1049,6 +1078,7 @@ CONFIG_CHELSIO_T3_DEPENDS=y
 # CONFIG_IXGBE is not set
 # CONFIG_IXGB is not set
 # CONFIG_S2IO is not set
+# CONFIG_VXGE is not set
 # CONFIG_MYRI10GE is not set
 # CONFIG_NETXEN_NIC is not set
 # CONFIG_NIU is not set
@@ -1058,6 +1088,7 @@ CONFIG_CHELSIO_T3_DEPENDS=y
 # CONFIG_BNX2X is not set
 # CONFIG_QLGE is not set
 # CONFIG_SFC is not set
+# CONFIG_BE2NET is not set
 CONFIG_TR=y
 # CONFIG_IBMOL is not set
 # CONFIG_IBMLS is not set
@@ -1073,8 +1104,8 @@ CONFIG_WLAN_80211=y
 # CONFIG_LIBERTAS is not set
 # CONFIG_LIBERTAS_THINFIRM is not set
 # CONFIG_AIRO is not set
-# CONFIG_HERMES is not set
 # CONFIG_ATMEL is not set
+# CONFIG_AT76C50X_USB is not set
 # CONFIG_AIRO_CS is not set
 # CONFIG_PCMCIA_WL3501 is not set
 # CONFIG_PRISM54 is not set
@@ -1084,21 +1115,21 @@ CONFIG_WLAN_80211=y
 # CONFIG_RTL8187 is not set
 # CONFIG_ADM8211 is not set
 # CONFIG_MAC80211_HWSIM is not set
+# CONFIG_MWL8K is not set
 # CONFIG_P54_COMMON is not set
 CONFIG_ATH5K=y
 # CONFIG_ATH5K_DEBUG is not set
 # CONFIG_ATH9K is not set
+# CONFIG_AR9170_USB is not set
 # CONFIG_IPW2100 is not set
 # CONFIG_IPW2200 is not set
-# CONFIG_IWLCORE is not set
-# CONFIG_IWLWIFI_LEDS is not set
-# CONFIG_IWLAGN is not set
-# CONFIG_IWL3945 is not set
+# CONFIG_IWLWIFI is not set
 # CONFIG_HOSTAP is not set
 # CONFIG_B43 is not set
 # CONFIG_B43LEGACY is not set
 # CONFIG_ZD1211RW is not set
 # CONFIG_RT2X00 is not set
+# CONFIG_HERMES is not set
 
 #
 # Enable WiMAX (Networking options) to see the WiMAX drivers
@@ -1209,6 +1240,8 @@ CONFIG_INPUT_TABLET=y
 # CONFIG_TABLET_USB_KBTAB is not set
 # CONFIG_TABLET_USB_WACOM is not set
 CONFIG_INPUT_TOUCHSCREEN=y
+# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
+# CONFIG_TOUCHSCREEN_AD7879 is not set
 # CONFIG_TOUCHSCREEN_FUJITSU is not set
 # CONFIG_TOUCHSCREEN_GUNZE is not set
 # CONFIG_TOUCHSCREEN_ELO is not set
@@ -1303,6 +1336,7 @@ CONFIG_UNIX98_PTYS=y
 # CONFIG_LEGACY_PTYS is not set
 # CONFIG_IPMI_HANDLER is not set
 CONFIG_HW_RANDOM=y
+# CONFIG_HW_RANDOM_TIMERIOMEM is not set
 CONFIG_HW_RANDOM_INTEL=y
 CONFIG_HW_RANDOM_AMD=y
 CONFIG_HW_RANDOM_GEODE=y
@@ -1390,7 +1424,6 @@ CONFIG_I2C_I801=y
 # CONFIG_SENSORS_PCF8574 is not set
 # CONFIG_PCF8575 is not set
 # CONFIG_SENSORS_PCA9539 is not set
-# CONFIG_SENSORS_PCF8591 is not set
 # CONFIG_SENSORS_MAX6875 is not set
 # CONFIG_SENSORS_TSL2550 is not set
 # CONFIG_I2C_DEBUG_CORE is not set
@@ -1424,6 +1457,7 @@ CONFIG_HWMON=y
 # CONFIG_SENSORS_ADT7475 is not set
 # CONFIG_SENSORS_K8TEMP is not set
 # CONFIG_SENSORS_ASB100 is not set
+# CONFIG_SENSORS_ATK0110 is not set
 # CONFIG_SENSORS_ATXP1 is not set
 # CONFIG_SENSORS_DS1621 is not set
 # CONFIG_SENSORS_I5K_AMB is not set
@@ -1433,6 +1467,7 @@ CONFIG_HWMON=y
 # CONFIG_SENSORS_FSCHER is not set
 # CONFIG_SENSORS_FSCPOS is not set
 # CONFIG_SENSORS_FSCHMD is not set
+# CONFIG_SENSORS_G760A is not set
 # CONFIG_SENSORS_GL518SM is not set
 # CONFIG_SENSORS_GL520SM is not set
 # CONFIG_SENSORS_CORETEMP is not set
@@ -1448,11 +1483,14 @@ CONFIG_HWMON=y
 # CONFIG_SENSORS_LM90 is not set
 # CONFIG_SENSORS_LM92 is not set
 # CONFIG_SENSORS_LM93 is not set
+# CONFIG_SENSORS_LTC4215 is not set
 # CONFIG_SENSORS_LTC4245 is not set
+# CONFIG_SENSORS_LM95241 is not set
 # CONFIG_SENSORS_MAX1619 is not set
 # CONFIG_SENSORS_MAX6650 is not set
 # CONFIG_SENSORS_PC87360 is not set
 # CONFIG_SENSORS_PC87427 is not set
+# CONFIG_SENSORS_PCF8591 is not set
 # CONFIG_SENSORS_SIS5595 is not set
 # CONFIG_SENSORS_DME1737 is not set
 # CONFIG_SENSORS_SMSC47M1 is not set
@@ -1643,7 +1681,6 @@ CONFIG_FB_EFI=y
 # CONFIG_FB_3DFX is not set
 # CONFIG_FB_VOODOO1 is not set
 # CONFIG_FB_VT8623 is not set
-# CONFIG_FB_CYBLA is not set
 # CONFIG_FB_TRIDENT is not set
 # CONFIG_FB_ARK is not set
 # CONFIG_FB_PM3 is not set
@@ -1652,6 +1689,7 @@ CONFIG_FB_EFI=y
 # CONFIG_FB_VIRTUAL is not set
 # CONFIG_FB_METRONOME is not set
 # CONFIG_FB_MB862XX is not set
+# CONFIG_FB_BROADSHEET is not set
 CONFIG_BACKLIGHT_LCD_SUPPORT=y
 # CONFIG_LCD_CLASS_DEVICE is not set
 CONFIG_BACKLIGHT_CLASS_DEVICE=y
@@ -1738,6 +1776,8 @@ CONFIG_SND_PCI=y
 # CONFIG_SND_INDIGO is not set
 # CONFIG_SND_INDIGOIO is not set
 # CONFIG_SND_INDIGODJ is not set
+# CONFIG_SND_INDIGOIOX is not set
+# CONFIG_SND_INDIGODJX is not set
 # CONFIG_SND_EMU10K1 is not set
 # CONFIG_SND_EMU10K1X is not set
 # CONFIG_SND_ENS1370 is not set
@@ -1811,15 +1851,17 @@ CONFIG_USB_HIDDEV=y
 #
 # Special HID drivers
 #
-CONFIG_HID_COMPAT=y
 CONFIG_HID_A4TECH=y
 CONFIG_HID_APPLE=y
 CONFIG_HID_BELKIN=y
 CONFIG_HID_CHERRY=y
 CONFIG_HID_CHICONY=y
 CONFIG_HID_CYPRESS=y
+# CONFIG_DRAGONRISE_FF is not set
 CONFIG_HID_EZKEY=y
+CONFIG_HID_KYE=y
 CONFIG_HID_GYRATION=y
+CONFIG_HID_KENSINGTON=y
 CONFIG_HID_LOGITECH=y
 CONFIG_LOGITECH_FF=y
 # CONFIG_LOGIRUMBLEPAD2_FF is not set
@@ -1885,11 +1927,11 @@ CONFIG_USB_PRINTER=y
 # CONFIG_USB_TMC is not set
 
 #
-# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
+# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
 #
 
 #
-# see USB_STORAGE Help for more information
+# also be needed; see USB_STORAGE Help for more info
 #
 CONFIG_USB_STORAGE=y
 # CONFIG_USB_STORAGE_DEBUG is not set
@@ -1931,7 +1973,6 @@ CONFIG_USB_LIBUSUAL=y
 # CONFIG_USB_LED is not set
 # CONFIG_USB_CYPRESS_CY7C63 is not set
 # CONFIG_USB_CYTHERM is not set
-# CONFIG_USB_PHIDGET is not set
 # CONFIG_USB_IDMOUSE is not set
 # CONFIG_USB_FTDI_ELAN is not set
 # CONFIG_USB_APPLEDISPLAY is not set
@@ -1947,6 +1988,7 @@ CONFIG_USB_LIBUSUAL=y
 #
 # OTG and related infrastructure
 #
+# CONFIG_NOP_USB_XCEIV is not set
 # CONFIG_UWB is not set
 # CONFIG_MMC is not set
 # CONFIG_MEMSTICK is not set
@@ -1958,8 +2000,10 @@ CONFIG_LEDS_CLASS=y
 #
 # CONFIG_LEDS_ALIX2 is not set
 # CONFIG_LEDS_PCA9532 is not set
+# CONFIG_LEDS_LP5521 is not set
 # CONFIG_LEDS_CLEVO_MAIL is not set
 # CONFIG_LEDS_PCA955X is not set
+# CONFIG_LEDS_BD2802 is not set
 
 #
 # LED Triggers
@@ -1969,6 +2013,10 @@ CONFIG_LEDS_TRIGGERS=y
 # CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
 # CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
 # CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
+
+#
+# iptables trigger is under Netfilter config (LED target)
+#
 # CONFIG_ACCESSIBILITY is not set
 # CONFIG_INFINIBAND is not set
 CONFIG_EDAC=y
@@ -2037,6 +2085,7 @@ CONFIG_DMADEVICES=y
 # DMA Devices
 #
 # CONFIG_INTEL_IOATDMA is not set
+# CONFIG_AUXDISPLAY is not set
 # CONFIG_UIO is not set
 # CONFIG_STAGING is not set
 CONFIG_X86_PLATFORM_DEVICES=y
@@ -2071,6 +2120,7 @@ CONFIG_DMIID=y
 #
 # CONFIG_EXT2_FS is not set
 CONFIG_EXT3_FS=y
+# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
 CONFIG_EXT3_FS_XATTR=y
 CONFIG_EXT3_FS_POSIX_ACL=y
 CONFIG_EXT3_FS_SECURITY=y
@@ -2101,6 +2151,11 @@ CONFIG_AUTOFS4_FS=y
 CONFIG_GENERIC_ACL=y
 
 #
+# Caches
+#
+# CONFIG_FSCACHE is not set
+
+#
 # CD-ROM/DVD Filesystems
 #
 CONFIG_ISO9660_FS=y
@@ -2151,6 +2206,7 @@ CONFIG_MISC_FILESYSTEMS=y
 # CONFIG_ROMFS_FS is not set
 # CONFIG_SYSV_FS is not set
 # CONFIG_UFS_FS is not set
+# CONFIG_NILFS2_FS is not set
 CONFIG_NETWORK_FILESYSTEMS=y
 CONFIG_NFS_FS=y
 CONFIG_NFS_V3=y
@@ -2164,7 +2220,6 @@ CONFIG_NFS_ACL_SUPPORT=y
 CONFIG_NFS_COMMON=y
 CONFIG_SUNRPC=y
 CONFIG_SUNRPC_GSS=y
-# CONFIG_SUNRPC_REGISTER_V4 is not set
 CONFIG_RPCSEC_GSS_KRB5=y
 # CONFIG_RPCSEC_GSS_SPKM3 is not set
 # CONFIG_SMB_FS is not set
@@ -2251,6 +2306,7 @@ CONFIG_DEBUG_FS=y
 CONFIG_DEBUG_KERNEL=y
 # CONFIG_DEBUG_SHIRQ is not set
 # CONFIG_DETECT_SOFTLOCKUP is not set
+# CONFIG_DETECT_HUNG_TASK is not set
 # CONFIG_SCHED_DEBUG is not set
 CONFIG_SCHEDSTATS=y
 CONFIG_TIMER_STATS=y
@@ -2266,6 +2322,7 @@ CONFIG_TIMER_STATS=y
 # CONFIG_LOCK_STAT is not set
 # CONFIG_DEBUG_SPINLOCK_SLEEP is not set
 # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
+CONFIG_STACKTRACE=y
 # CONFIG_DEBUG_KOBJECT is not set
 # CONFIG_DEBUG_HIGHMEM is not set
 CONFIG_DEBUG_BUGVERBOSE=y
@@ -2289,13 +2346,19 @@ CONFIG_FRAME_POINTER=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
+# CONFIG_DEBUG_PAGEALLOC is not set
 CONFIG_USER_STACKTRACE_SUPPORT=y
+CONFIG_NOP_TRACER=y
 CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
 CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
 CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
 CONFIG_HAVE_HW_BRANCH_TRACER=y
+CONFIG_HAVE_FTRACE_SYSCALLS=y
+CONFIG_RING_BUFFER=y
+CONFIG_TRACING=y
+CONFIG_TRACING_SUPPORT=y
 
 #
 # Tracers
@@ -2305,13 +2368,21 @@ CONFIG_HAVE_HW_BRANCH_TRACER=y
 # CONFIG_SYSPROF_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
+# CONFIG_EVENT_TRACER is not set
+# CONFIG_FTRACE_SYSCALLS is not set
 # CONFIG_BOOT_TRACER is not set
 # CONFIG_TRACE_BRANCH_PROFILING is not set
 # CONFIG_POWER_TRACER is not set
 # CONFIG_STACK_TRACER is not set
 # CONFIG_HW_BRANCH_TRACER is not set
+# CONFIG_KMEMTRACE is not set
+# CONFIG_WORKQUEUE_TRACER is not set
+CONFIG_BLK_DEV_IO_TRACE=y
+# CONFIG_FTRACE_STARTUP_TEST is not set
+# CONFIG_MMIOTRACE is not set
 CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
-# CONFIG_DYNAMIC_PRINTK_DEBUG is not set
+# CONFIG_DYNAMIC_DEBUG is not set
+# CONFIG_DMA_API_DEBUG is not set
 # CONFIG_SAMPLES is not set
 CONFIG_HAVE_ARCH_KGDB=y
 # CONFIG_KGDB is not set
@@ -2321,7 +2392,6 @@ CONFIG_EARLY_PRINTK=y
 CONFIG_EARLY_PRINTK_DBGP=y
 CONFIG_DEBUG_STACKOVERFLOW=y
 CONFIG_DEBUG_STACK_USAGE=y
-# CONFIG_DEBUG_PAGEALLOC is not set
 # CONFIG_DEBUG_PER_CPU_MAPS is not set
 # CONFIG_X86_PTDUMP is not set
 CONFIG_DEBUG_RODATA=y
@@ -2329,7 +2399,7 @@ CONFIG_DEBUG_RODATA=y
 CONFIG_DEBUG_NX_TEST=m
 # CONFIG_4KSTACKS is not set
 CONFIG_DOUBLEFAULT=y
-# CONFIG_MMIOTRACE is not set
+CONFIG_HAVE_MMIOTRACE_SUPPORT=y
 CONFIG_IO_DELAY_TYPE_0X80=0
 CONFIG_IO_DELAY_TYPE_0XED=1
 CONFIG_IO_DELAY_TYPE_UDELAY=2
@@ -2365,6 +2435,8 @@ CONFIG_SECURITY_SELINUX_AVC_STATS=y
 CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
 # CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
 # CONFIG_SECURITY_SMACK is not set
+# CONFIG_SECURITY_TOMOYO is not set
+# CONFIG_IMA is not set
 CONFIG_CRYPTO=y
 
 #
@@ -2380,10 +2452,12 @@ CONFIG_CRYPTO_BLKCIPHER2=y
 CONFIG_CRYPTO_HASH=y
 CONFIG_CRYPTO_HASH2=y
 CONFIG_CRYPTO_RNG2=y
+CONFIG_CRYPTO_PCOMP=y
 CONFIG_CRYPTO_MANAGER=y
 CONFIG_CRYPTO_MANAGER2=y
 # CONFIG_CRYPTO_GF128MUL is not set
 # CONFIG_CRYPTO_NULL is not set
+CONFIG_CRYPTO_WORKQUEUE=y
 # CONFIG_CRYPTO_CRYPTD is not set
 CONFIG_CRYPTO_AUTHENC=y
 # CONFIG_CRYPTO_TEST is not set
@@ -2456,6 +2530,7 @@ CONFIG_CRYPTO_DES=y
 # Compression
 #
 # CONFIG_CRYPTO_DEFLATE is not set
+# CONFIG_CRYPTO_ZLIB is not set
 # CONFIG_CRYPTO_LZO is not set
 
 #
@@ -2467,11 +2542,13 @@ CONFIG_CRYPTO_HW=y
 # CONFIG_CRYPTO_DEV_GEODE is not set
 # CONFIG_CRYPTO_DEV_HIFN_795X is not set
 CONFIG_HAVE_KVM=y
+CONFIG_HAVE_KVM_IRQCHIP=y
 CONFIG_VIRTUALIZATION=y
 # CONFIG_KVM is not set
 # CONFIG_LGUEST is not set
 # CONFIG_VIRTIO_PCI is not set
 # CONFIG_VIRTIO_BALLOON is not set
+CONFIG_BINARY_PRINTF=y
 
 #
 # Library routines
@@ -2489,7 +2566,10 @@ CONFIG_CRC32=y
 # CONFIG_LIBCRC32C is not set
 CONFIG_AUDIT_GENERIC=y
 CONFIG_ZLIB_INFLATE=y
-CONFIG_PLIST=y
+CONFIG_DECOMPRESS_GZIP=y
+CONFIG_DECOMPRESS_BZIP2=y
+CONFIG_DECOMPRESS_LZMA=y
 CONFIG_HAS_IOMEM=y
 CONFIG_HAS_IOPORT=y
 CONFIG_HAS_DMA=y
+CONFIG_NLATTR=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 9fe5d21..4ba7d4e 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -1,12 +1,13 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.29-rc4
-# Tue Feb 24 15:44:16 2009
+# Linux kernel version: 2.6.30-rc2
+# Mon May 11 16:22:00 2009
 #
 CONFIG_64BIT=y
 # CONFIG_X86_32 is not set
 CONFIG_X86_64=y
 CONFIG_X86=y
+CONFIG_OUTPUT_FORMAT="elf64-x86-64"
 CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
 CONFIG_GENERIC_TIME=y
 CONFIG_GENERIC_CMOS_UPDATE=y
@@ -34,6 +35,7 @@ CONFIG_ARCH_HAS_CPU_RELAX=y
 CONFIG_ARCH_HAS_DEFAULT_IDLE=y
 CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
 CONFIG_HAVE_SETUP_PER_CPU_AREA=y
+CONFIG_HAVE_DYNAMIC_PER_CPU_AREA=y
 CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
 CONFIG_ARCH_HIBERNATION_POSSIBLE=y
 CONFIG_ARCH_SUSPEND_POSSIBLE=y
@@ -41,14 +43,14 @@ CONFIG_ZONE_DMA32=y
 CONFIG_ARCH_POPULATES_NODE_MAP=y
 CONFIG_AUDIT_ARCH=y
 CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
+CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
 CONFIG_GENERIC_HARDIRQS=y
+CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
 CONFIG_GENERIC_IRQ_PROBE=y
 CONFIG_GENERIC_PENDING_IRQ=y
-CONFIG_X86_SMP=y
 CONFIG_USE_GENERIC_SMP_HELPERS=y
 CONFIG_X86_64_SMP=y
 CONFIG_X86_HT=y
-CONFIG_X86_BIOS_REBOOT=y
 CONFIG_X86_TRAMPOLINE=y
 # CONFIG_KTIME_SCALAR is not set
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
@@ -61,10 +63,17 @@ CONFIG_LOCK_KERNEL=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
 CONFIG_LOCALVERSION=""
 # CONFIG_LOCALVERSION_AUTO is not set
+CONFIG_HAVE_KERNEL_GZIP=y
+CONFIG_HAVE_KERNEL_BZIP2=y
+CONFIG_HAVE_KERNEL_LZMA=y
+CONFIG_KERNEL_GZIP=y
+# CONFIG_KERNEL_BZIP2 is not set
+# CONFIG_KERNEL_LZMA is not set
 CONFIG_SWAP=y
 CONFIG_SYSVIPC=y
 CONFIG_SYSVIPC_SYSCTL=y
 CONFIG_POSIX_MQUEUE=y
+CONFIG_POSIX_MQUEUE_SYSCTL=y
 CONFIG_BSD_PROCESS_ACCT=y
 # CONFIG_BSD_PROCESS_ACCT_V3 is not set
 CONFIG_TASKSTATS=y
@@ -114,23 +123,26 @@ CONFIG_PID_NS=y
 CONFIG_NET_NS=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
+CONFIG_RD_GZIP=y
+CONFIG_RD_BZIP2=y
+CONFIG_RD_LZMA=y
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_SYSCTL=y
+CONFIG_ANON_INODES=y
 # CONFIG_EMBEDDED is not set
 CONFIG_UID16=y
 CONFIG_SYSCTL_SYSCALL=y
 CONFIG_KALLSYMS=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
+# CONFIG_STRIP_ASM_SYMS is not set
 CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
 CONFIG_PCSPKR_PLATFORM=y
-# CONFIG_COMPAT_BRK is not set
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
-CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
 CONFIG_TIMERFD=y
@@ -140,6 +152,7 @@ CONFIG_AIO=y
 CONFIG_VM_EVENT_COUNTERS=y
 CONFIG_PCI_QUIRKS=y
 CONFIG_SLUB_DEBUG=y
+# CONFIG_COMPAT_BRK is not set
 # CONFIG_SLAB is not set
 CONFIG_SLUB=y
 # CONFIG_SLOB is not set
@@ -155,6 +168,8 @@ CONFIG_HAVE_IOREMAP_PROT=y
 CONFIG_HAVE_KPROBES=y
 CONFIG_HAVE_KRETPROBES=y
 CONFIG_HAVE_ARCH_TRACEHOOK=y
+CONFIG_HAVE_DMA_API_DEBUG=y
+# CONFIG_SLOW_WORK is not set
 # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
 CONFIG_SLABINFO=y
 CONFIG_RT_MUTEXES=y
@@ -167,7 +182,6 @@ CONFIG_MODULE_FORCE_UNLOAD=y
 # CONFIG_MODULE_SRCVERSION_ALL is not set
 CONFIG_STOP_MACHINE=y
 CONFIG_BLOCK=y
-CONFIG_BLK_DEV_IO_TRACE=y
 CONFIG_BLK_DEV_BSG=y
 # CONFIG_BLK_DEV_INTEGRITY is not set
 CONFIG_BLOCK_COMPAT=y
@@ -196,11 +210,10 @@ CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
 CONFIG_SMP=y
 CONFIG_SPARSE_IRQ=y
 # CONFIG_NUMA_MIGRATE_IRQ_DESC is not set
-CONFIG_X86_FIND_SMP_CONFIG=y
 CONFIG_X86_MPPARSE=y
-# CONFIG_X86_ELAN is not set
-# CONFIG_X86_GENERICARCH is not set
+CONFIG_X86_EXTENDED_PLATFORM=y
 # CONFIG_X86_VSMP is not set
+# CONFIG_X86_UV is not set
 CONFIG_SCHED_OMIT_FRAME_POINTER=y
 # CONFIG_PARAVIRT_GUEST is not set
 # CONFIG_MEMTEST is not set
@@ -230,10 +243,10 @@ CONFIG_SCHED_OMIT_FRAME_POINTER=y
 # CONFIG_MCORE2 is not set
 CONFIG_GENERIC_CPU=y
 CONFIG_X86_CPU=y
-CONFIG_X86_L1_CACHE_BYTES=128
-CONFIG_X86_INTERNODE_CACHE_BYTES=128
+CONFIG_X86_L1_CACHE_BYTES=64
+CONFIG_X86_INTERNODE_CACHE_BYTES=64
 CONFIG_X86_CMPXCHG=y
-CONFIG_X86_L1_CACHE_SHIFT=7
+CONFIG_X86_L1_CACHE_SHIFT=6
 CONFIG_X86_WP_WORKS_OK=y
 CONFIG_X86_TSC=y
 CONFIG_X86_CMPXCHG64=y
@@ -242,7 +255,7 @@ CONFIG_X86_MINIMUM_CPU_FAMILY=64
 CONFIG_X86_DEBUGCTLMSR=y
 CONFIG_CPU_SUP_INTEL=y
 CONFIG_CPU_SUP_AMD=y
-CONFIG_CPU_SUP_CENTAUR_64=y
+CONFIG_CPU_SUP_CENTAUR=y
 CONFIG_X86_DS=y
 CONFIG_X86_PTRACE_BTS=y
 CONFIG_HPET_TIMER=y
@@ -269,6 +282,7 @@ CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
 CONFIG_X86_MCE=y
 CONFIG_X86_MCE_INTEL=y
 CONFIG_X86_MCE_AMD=y
+CONFIG_X86_MCE_THRESHOLD=y
 # CONFIG_I8K is not set
 CONFIG_MICROCODE=y
 CONFIG_MICROCODE_INTEL=y
@@ -276,6 +290,7 @@ CONFIG_MICROCODE_AMD=y
 CONFIG_MICROCODE_OLD_INTERFACE=y
 CONFIG_X86_MSR=y
 CONFIG_X86_CPUID=y
+# CONFIG_X86_CPU_DEBUG is not set
 CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
 CONFIG_DIRECT_GBPAGES=y
 CONFIG_NUMA=y
@@ -309,6 +324,8 @@ CONFIG_ZONE_DMA_FLAG=1
 CONFIG_BOUNCE=y
 CONFIG_VIRT_TO_BUS=y
 CONFIG_UNEVICTABLE_LRU=y
+CONFIG_HAVE_MLOCK=y
+CONFIG_HAVE_MLOCKED_PAGE_BIT=y
 CONFIG_X86_CHECK_BIOS_CORRUPTION=y
 CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
 CONFIG_X86_RESERVE_LOW_64K=y
@@ -317,6 +334,7 @@ CONFIG_MTRR=y
 CONFIG_X86_PAT=y
 CONFIG_EFI=y
 CONFIG_SECCOMP=y
+# CONFIG_CC_STACKPROTECTOR is not set
 # CONFIG_HZ_100 is not set
 # CONFIG_HZ_250 is not set
 # CONFIG_HZ_300 is not set
@@ -325,9 +343,10 @@ CONFIG_HZ=1000
 CONFIG_SCHED_HRTICK=y
 CONFIG_KEXEC=y
 CONFIG_CRASH_DUMP=y
+# CONFIG_KEXEC_JUMP is not set
 CONFIG_PHYSICAL_START=0x1000000
-# CONFIG_RELOCATABLE is not set
-CONFIG_PHYSICAL_ALIGN=0x200000
+CONFIG_RELOCATABLE=y
+CONFIG_PHYSICAL_ALIGN=0x1000000
 CONFIG_HOTPLUG_CPU=y
 # CONFIG_COMPAT_VDSO is not set
 # CONFIG_CMDLINE_BOOL is not set
@@ -370,7 +389,6 @@ CONFIG_ACPI_NUMA=y
 CONFIG_ACPI_BLACKLIST_YEAR=0
 # CONFIG_ACPI_DEBUG is not set
 # CONFIG_ACPI_PCI_SLOT is not set
-CONFIG_ACPI_SYSTEM=y
 CONFIG_X86_PM_TIMER=y
 CONFIG_ACPI_CONTAINER=y
 # CONFIG_ACPI_SBS is not set
@@ -436,6 +454,7 @@ CONFIG_PCI_MSI=y
 # CONFIG_PCI_DEBUG is not set
 # CONFIG_PCI_STUB is not set
 CONFIG_HT_IRQ=y
+# CONFIG_PCI_IOV is not set
 CONFIG_ISA_DMA_API=y
 CONFIG_K8_NB=y
 CONFIG_PCCARD=y
@@ -481,7 +500,6 @@ CONFIG_NET=y
 #
 # Networking options
 #
-CONFIG_COMPAT_NET_DEV_OPS=y
 CONFIG_PACKET=y
 CONFIG_PACKET_MMAP=y
 CONFIG_UNIX=y
@@ -639,6 +657,7 @@ CONFIG_LLC=y
 # CONFIG_LAPB is not set
 # CONFIG_ECONET is not set
 # CONFIG_WAN_ROUTER is not set
+# CONFIG_PHONET is not set
 CONFIG_NET_SCHED=y
 
 #
@@ -696,6 +715,7 @@ CONFIG_NET_SCH_FIFO=y
 #
 # CONFIG_NET_PKTGEN is not set
 # CONFIG_NET_TCPPROBE is not set
+# CONFIG_NET_DROP_MONITOR is not set
 CONFIG_HAMRADIO=y
 
 #
@@ -706,12 +726,10 @@ CONFIG_HAMRADIO=y
 # CONFIG_IRDA is not set
 # CONFIG_BT is not set
 # CONFIG_AF_RXRPC is not set
-# CONFIG_PHONET is not set
 CONFIG_FIB_RULES=y
 CONFIG_WIRELESS=y
 CONFIG_CFG80211=y
 # CONFIG_CFG80211_REG_DEBUG is not set
-CONFIG_NL80211=y
 CONFIG_WIRELESS_OLD_REGULATORY=y
 CONFIG_WIRELESS_EXT=y
 CONFIG_WIRELESS_EXT_SYSFS=y
@@ -788,9 +806,8 @@ CONFIG_MISC_DEVICES=y
 # CONFIG_TIFM_CORE is not set
 # CONFIG_ICS932S401 is not set
 # CONFIG_ENCLOSURE_SERVICES is not set
-# CONFIG_SGI_XP is not set
 # CONFIG_HP_ILO is not set
-# CONFIG_SGI_GRU is not set
+# CONFIG_ISL29003 is not set
 # CONFIG_C2PORT is not set
 
 #
@@ -844,6 +861,7 @@ CONFIG_SCSI_SPI_ATTRS=y
 # CONFIG_SCSI_LOWLEVEL is not set
 # CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
 # CONFIG_SCSI_DH is not set
+# CONFIG_SCSI_OSD_INITIATOR is not set
 CONFIG_ATA=y
 # CONFIG_ATA_NONSTANDARD is not set
 CONFIG_ATA_ACPI=y
@@ -940,6 +958,7 @@ CONFIG_DM_ZERO=y
 CONFIG_MACINTOSH_DRIVERS=y
 CONFIG_MAC_EMUMOUSEBTN=y
 CONFIG_NETDEVICES=y
+CONFIG_COMPAT_NET_DEV_OPS=y
 # CONFIG_IFB is not set
 # CONFIG_DUMMY is not set
 # CONFIG_BONDING is not set
@@ -977,6 +996,8 @@ CONFIG_MII=y
 CONFIG_NET_VENDOR_3COM=y
 # CONFIG_VORTEX is not set
 # CONFIG_TYPHOON is not set
+# CONFIG_ETHOC is not set
+# CONFIG_DNET is not set
 CONFIG_NET_TULIP=y
 # CONFIG_DE2104X is not set
 # CONFIG_TULIP is not set
@@ -1026,6 +1047,7 @@ CONFIG_E1000=y
 # CONFIG_E1000E is not set
 # CONFIG_IP1000 is not set
 # CONFIG_IGB is not set
+# CONFIG_IGBVF is not set
 # CONFIG_NS83820 is not set
 # CONFIG_HAMACHI is not set
 # CONFIG_YELLOWFIN is not set
@@ -1040,6 +1062,7 @@ CONFIG_TIGON3=y
 # CONFIG_QLA3XXX is not set
 # CONFIG_ATL1 is not set
 # CONFIG_ATL1E is not set
+# CONFIG_ATL1C is not set
 # CONFIG_JME is not set
 CONFIG_NETDEV_10000=y
 # CONFIG_CHELSIO_T1 is not set
@@ -1049,6 +1072,7 @@ CONFIG_CHELSIO_T3_DEPENDS=y
 # CONFIG_IXGBE is not set
 # CONFIG_IXGB is not set
 # CONFIG_S2IO is not set
+# CONFIG_VXGE is not set
 # CONFIG_MYRI10GE is not set
 # CONFIG_NETXEN_NIC is not set
 # CONFIG_NIU is not set
@@ -1058,6 +1082,7 @@ CONFIG_CHELSIO_T3_DEPENDS=y
 # CONFIG_BNX2X is not set
 # CONFIG_QLGE is not set
 # CONFIG_SFC is not set
+# CONFIG_BE2NET is not set
 CONFIG_TR=y
 # CONFIG_IBMOL is not set
 # CONFIG_3C359 is not set
@@ -1072,8 +1097,8 @@ CONFIG_WLAN_80211=y
 # CONFIG_LIBERTAS is not set
 # CONFIG_LIBERTAS_THINFIRM is not set
 # CONFIG_AIRO is not set
-# CONFIG_HERMES is not set
 # CONFIG_ATMEL is not set
+# CONFIG_AT76C50X_USB is not set
 # CONFIG_AIRO_CS is not set
 # CONFIG_PCMCIA_WL3501 is not set
 # CONFIG_PRISM54 is not set
@@ -1083,21 +1108,21 @@ CONFIG_WLAN_80211=y
 # CONFIG_RTL8187 is not set
 # CONFIG_ADM8211 is not set
 # CONFIG_MAC80211_HWSIM is not set
+# CONFIG_MWL8K is not set
 # CONFIG_P54_COMMON is not set
 CONFIG_ATH5K=y
 # CONFIG_ATH5K_DEBUG is not set
 # CONFIG_ATH9K is not set
+# CONFIG_AR9170_USB is not set
 # CONFIG_IPW2100 is not set
 # CONFIG_IPW2200 is not set
-# CONFIG_IWLCORE is not set
-# CONFIG_IWLWIFI_LEDS is not set
-# CONFIG_IWLAGN is not set
-# CONFIG_IWL3945 is not set
+# CONFIG_IWLWIFI is not set
 # CONFIG_HOSTAP is not set
 # CONFIG_B43 is not set
 # CONFIG_B43LEGACY is not set
 # CONFIG_ZD1211RW is not set
 # CONFIG_RT2X00 is not set
+# CONFIG_HERMES is not set
 
 #
 # Enable WiMAX (Networking options) to see the WiMAX drivers
@@ -1208,6 +1233,8 @@ CONFIG_INPUT_TABLET=y
 # CONFIG_TABLET_USB_KBTAB is not set
 # CONFIG_TABLET_USB_WACOM is not set
 CONFIG_INPUT_TOUCHSCREEN=y
+# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
+# CONFIG_TOUCHSCREEN_AD7879 is not set
 # CONFIG_TOUCHSCREEN_FUJITSU is not set
 # CONFIG_TOUCHSCREEN_GUNZE is not set
 # CONFIG_TOUCHSCREEN_ELO is not set
@@ -1301,6 +1328,7 @@ CONFIG_UNIX98_PTYS=y
 # CONFIG_LEGACY_PTYS is not set
 # CONFIG_IPMI_HANDLER is not set
 CONFIG_HW_RANDOM=y
+# CONFIG_HW_RANDOM_TIMERIOMEM is not set
 # CONFIG_HW_RANDOM_INTEL is not set
 # CONFIG_HW_RANDOM_AMD is not set
 CONFIG_NVRAM=y
@@ -1382,7 +1410,6 @@ CONFIG_I2C_I801=y
 # CONFIG_SENSORS_PCF8574 is not set
 # CONFIG_PCF8575 is not set
 # CONFIG_SENSORS_PCA9539 is not set
-# CONFIG_SENSORS_PCF8591 is not set
 # CONFIG_SENSORS_MAX6875 is not set
 # CONFIG_SENSORS_TSL2550 is not set
 # CONFIG_I2C_DEBUG_CORE is not set
@@ -1416,6 +1443,7 @@ CONFIG_HWMON=y
 # CONFIG_SENSORS_ADT7475 is not set
 # CONFIG_SENSORS_K8TEMP is not set
 # CONFIG_SENSORS_ASB100 is not set
+# CONFIG_SENSORS_ATK0110 is not set
 # CONFIG_SENSORS_ATXP1 is not set
 # CONFIG_SENSORS_DS1621 is not set
 # CONFIG_SENSORS_I5K_AMB is not set
@@ -1425,6 +1453,7 @@ CONFIG_HWMON=y
 # CONFIG_SENSORS_FSCHER is not set
 # CONFIG_SENSORS_FSCPOS is not set
 # CONFIG_SENSORS_FSCHMD is not set
+# CONFIG_SENSORS_G760A is not set
 # CONFIG_SENSORS_GL518SM is not set
 # CONFIG_SENSORS_GL520SM is not set
 # CONFIG_SENSORS_CORETEMP is not set
@@ -1440,11 +1469,14 @@ CONFIG_HWMON=y
 # CONFIG_SENSORS_LM90 is not set
 # CONFIG_SENSORS_LM92 is not set
 # CONFIG_SENSORS_LM93 is not set
+# CONFIG_SENSORS_LTC4215 is not set
 # CONFIG_SENSORS_LTC4245 is not set
+# CONFIG_SENSORS_LM95241 is not set
 # CONFIG_SENSORS_MAX1619 is not set
 # CONFIG_SENSORS_MAX6650 is not set
 # CONFIG_SENSORS_PC87360 is not set
 # CONFIG_SENSORS_PC87427 is not set
+# CONFIG_SENSORS_PCF8591 is not set
 # CONFIG_SENSORS_SIS5595 is not set
 # CONFIG_SENSORS_DME1737 is not set
 # CONFIG_SENSORS_SMSC47M1 is not set
@@ -1635,6 +1667,7 @@ CONFIG_FB_EFI=y
 # CONFIG_FB_VIRTUAL is not set
 # CONFIG_FB_METRONOME is not set
 # CONFIG_FB_MB862XX is not set
+# CONFIG_FB_BROADSHEET is not set
 CONFIG_BACKLIGHT_LCD_SUPPORT=y
 # CONFIG_LCD_CLASS_DEVICE is not set
 CONFIG_BACKLIGHT_CLASS_DEVICE=y
@@ -1720,6 +1753,8 @@ CONFIG_SND_PCI=y
 # CONFIG_SND_INDIGO is not set
 # CONFIG_SND_INDIGOIO is not set
 # CONFIG_SND_INDIGODJ is not set
+# CONFIG_SND_INDIGOIOX is not set
+# CONFIG_SND_INDIGODJX is not set
 # CONFIG_SND_EMU10K1 is not set
 # CONFIG_SND_EMU10K1X is not set
 # CONFIG_SND_ENS1370 is not set
@@ -1792,15 +1827,17 @@ CONFIG_USB_HIDDEV=y
 #
 # Special HID drivers
 #
-CONFIG_HID_COMPAT=y
 CONFIG_HID_A4TECH=y
 CONFIG_HID_APPLE=y
 CONFIG_HID_BELKIN=y
 CONFIG_HID_CHERRY=y
 CONFIG_HID_CHICONY=y
 CONFIG_HID_CYPRESS=y
+# CONFIG_DRAGONRISE_FF is not set
 CONFIG_HID_EZKEY=y
+CONFIG_HID_KYE=y
 CONFIG_HID_GYRATION=y
+CONFIG_HID_KENSINGTON=y
 CONFIG_HID_LOGITECH=y
 CONFIG_LOGITECH_FF=y
 # CONFIG_LOGIRUMBLEPAD2_FF is not set
@@ -1866,11 +1903,11 @@ CONFIG_USB_PRINTER=y
 # CONFIG_USB_TMC is not set
 
 #
-# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
+# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
 #
 
 #
-# see USB_STORAGE Help for more information
+# also be needed; see USB_STORAGE Help for more info
 #
 CONFIG_USB_STORAGE=y
 # CONFIG_USB_STORAGE_DEBUG is not set
@@ -1912,7 +1949,6 @@ CONFIG_USB_LIBUSUAL=y
 # CONFIG_USB_LED is not set
 # CONFIG_USB_CYPRESS_CY7C63 is not set
 # CONFIG_USB_CYTHERM is not set
-# CONFIG_USB_PHIDGET is not set
 # CONFIG_USB_IDMOUSE is not set
 # CONFIG_USB_FTDI_ELAN is not set
 # CONFIG_USB_APPLEDISPLAY is not set
@@ -1928,6 +1964,7 @@ CONFIG_USB_LIBUSUAL=y
 #
 # OTG and related infrastructure
 #
+# CONFIG_NOP_USB_XCEIV is not set
 # CONFIG_UWB is not set
 # CONFIG_MMC is not set
 # CONFIG_MEMSTICK is not set
@@ -1939,8 +1976,10 @@ CONFIG_LEDS_CLASS=y
 #
 # CONFIG_LEDS_ALIX2 is not set
 # CONFIG_LEDS_PCA9532 is not set
+# CONFIG_LEDS_LP5521 is not set
 # CONFIG_LEDS_CLEVO_MAIL is not set
 # CONFIG_LEDS_PCA955X is not set
+# CONFIG_LEDS_BD2802 is not set
 
 #
 # LED Triggers
@@ -1950,6 +1989,10 @@ CONFIG_LEDS_TRIGGERS=y
 # CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
 # CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
 # CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
+
+#
+# iptables trigger is under Netfilter config (LED target)
+#
 # CONFIG_ACCESSIBILITY is not set
 # CONFIG_INFINIBAND is not set
 CONFIG_EDAC=y
@@ -2018,6 +2061,7 @@ CONFIG_DMADEVICES=y
 # DMA Devices
 #
 # CONFIG_INTEL_IOATDMA is not set
+# CONFIG_AUXDISPLAY is not set
 # CONFIG_UIO is not set
 # CONFIG_STAGING is not set
 CONFIG_X86_PLATFORM_DEVICES=y
@@ -2051,6 +2095,7 @@ CONFIG_DMIID=y
 #
 # CONFIG_EXT2_FS is not set
 CONFIG_EXT3_FS=y
+# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
 CONFIG_EXT3_FS_XATTR=y
 CONFIG_EXT3_FS_POSIX_ACL=y
 CONFIG_EXT3_FS_SECURITY=y
@@ -2082,6 +2127,11 @@ CONFIG_AUTOFS4_FS=y
 CONFIG_GENERIC_ACL=y
 
 #
+# Caches
+#
+# CONFIG_FSCACHE is not set
+
+#
 # CD-ROM/DVD Filesystems
 #
 CONFIG_ISO9660_FS=y
@@ -2132,6 +2182,7 @@ CONFIG_MISC_FILESYSTEMS=y
 # CONFIG_ROMFS_FS is not set
 # CONFIG_SYSV_FS is not set
 # CONFIG_UFS_FS is not set
+# CONFIG_NILFS2_FS is not set
 CONFIG_NETWORK_FILESYSTEMS=y
 CONFIG_NFS_FS=y
 CONFIG_NFS_V3=y
@@ -2145,7 +2196,6 @@ CONFIG_NFS_ACL_SUPPORT=y
 CONFIG_NFS_COMMON=y
 CONFIG_SUNRPC=y
 CONFIG_SUNRPC_GSS=y
-# CONFIG_SUNRPC_REGISTER_V4 is not set
 CONFIG_RPCSEC_GSS_KRB5=y
 # CONFIG_RPCSEC_GSS_SPKM3 is not set
 # CONFIG_SMB_FS is not set
@@ -2232,6 +2282,7 @@ CONFIG_DEBUG_FS=y
 CONFIG_DEBUG_KERNEL=y
 # CONFIG_DEBUG_SHIRQ is not set
 # CONFIG_DETECT_SOFTLOCKUP is not set
+# CONFIG_DETECT_HUNG_TASK is not set
 # CONFIG_SCHED_DEBUG is not set
 CONFIG_SCHEDSTATS=y
 CONFIG_TIMER_STATS=y
@@ -2247,6 +2298,7 @@ CONFIG_TIMER_STATS=y
 # CONFIG_LOCK_STAT is not set
 # CONFIG_DEBUG_SPINLOCK_SLEEP is not set
 # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
+CONFIG_STACKTRACE=y
 # CONFIG_DEBUG_KOBJECT is not set
 CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_INFO is not set
@@ -2269,13 +2321,19 @@ CONFIG_FRAME_POINTER=y
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
+# CONFIG_DEBUG_PAGEALLOC is not set
 CONFIG_USER_STACKTRACE_SUPPORT=y
+CONFIG_NOP_TRACER=y
 CONFIG_HAVE_FUNCTION_TRACER=y
 CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
 CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
 CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
 CONFIG_HAVE_HW_BRANCH_TRACER=y
+CONFIG_HAVE_FTRACE_SYSCALLS=y
+CONFIG_RING_BUFFER=y
+CONFIG_TRACING=y
+CONFIG_TRACING_SUPPORT=y
 
 #
 # Tracers
@@ -2285,13 +2343,21 @@ CONFIG_HAVE_HW_BRANCH_TRACER=y
 # CONFIG_SYSPROF_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
+# CONFIG_EVENT_TRACER is not set
+# CONFIG_FTRACE_SYSCALLS is not set
 # CONFIG_BOOT_TRACER is not set
 # CONFIG_TRACE_BRANCH_PROFILING is not set
 # CONFIG_POWER_TRACER is not set
 # CONFIG_STACK_TRACER is not set
 # CONFIG_HW_BRANCH_TRACER is not set
+# CONFIG_KMEMTRACE is not set
+# CONFIG_WORKQUEUE_TRACER is not set
+CONFIG_BLK_DEV_IO_TRACE=y
+# CONFIG_FTRACE_STARTUP_TEST is not set
+# CONFIG_MMIOTRACE is not set
 CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
-# CONFIG_DYNAMIC_PRINTK_DEBUG is not set
+# CONFIG_DYNAMIC_DEBUG is not set
+# CONFIG_DMA_API_DEBUG is not set
 # CONFIG_SAMPLES is not set
 CONFIG_HAVE_ARCH_KGDB=y
 # CONFIG_KGDB is not set
@@ -2301,14 +2367,13 @@ CONFIG_EARLY_PRINTK=y
 CONFIG_EARLY_PRINTK_DBGP=y
 CONFIG_DEBUG_STACKOVERFLOW=y
 CONFIG_DEBUG_STACK_USAGE=y
-# CONFIG_DEBUG_PAGEALLOC is not set
 # CONFIG_DEBUG_PER_CPU_MAPS is not set
 # CONFIG_X86_PTDUMP is not set
 CONFIG_DEBUG_RODATA=y
 # CONFIG_DEBUG_RODATA_TEST is not set
 CONFIG_DEBUG_NX_TEST=m
 # CONFIG_IOMMU_DEBUG is not set
-# CONFIG_MMIOTRACE is not set
+CONFIG_HAVE_MMIOTRACE_SUPPORT=y
 CONFIG_IO_DELAY_TYPE_0X80=0
 CONFIG_IO_DELAY_TYPE_0XED=1
 CONFIG_IO_DELAY_TYPE_UDELAY=2
@@ -2344,6 +2409,8 @@ CONFIG_SECURITY_SELINUX_AVC_STATS=y
 CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
 # CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
 # CONFIG_SECURITY_SMACK is not set
+# CONFIG_SECURITY_TOMOYO is not set
+# CONFIG_IMA is not set
 CONFIG_CRYPTO=y
 
 #
@@ -2359,10 +2426,12 @@ CONFIG_CRYPTO_BLKCIPHER2=y
 CONFIG_CRYPTO_HASH=y
 CONFIG_CRYPTO_HASH2=y
 CONFIG_CRYPTO_RNG2=y
+CONFIG_CRYPTO_PCOMP=y
 CONFIG_CRYPTO_MANAGER=y
 CONFIG_CRYPTO_MANAGER2=y
 # CONFIG_CRYPTO_GF128MUL is not set
 # CONFIG_CRYPTO_NULL is not set
+CONFIG_CRYPTO_WORKQUEUE=y
 # CONFIG_CRYPTO_CRYPTD is not set
 CONFIG_CRYPTO_AUTHENC=y
 # CONFIG_CRYPTO_TEST is not set
@@ -2414,6 +2483,7 @@ CONFIG_CRYPTO_SHA1=y
 #
 CONFIG_CRYPTO_AES=y
 # CONFIG_CRYPTO_AES_X86_64 is not set
+# CONFIG_CRYPTO_AES_NI_INTEL is not set
 # CONFIG_CRYPTO_ANUBIS is not set
 CONFIG_CRYPTO_ARC4=y
 # CONFIG_CRYPTO_BLOWFISH is not set
@@ -2435,6 +2505,7 @@ CONFIG_CRYPTO_DES=y
 # Compression
 #
 # CONFIG_CRYPTO_DEFLATE is not set
+# CONFIG_CRYPTO_ZLIB is not set
 # CONFIG_CRYPTO_LZO is not set
 
 #
@@ -2444,10 +2515,12 @@ CONFIG_CRYPTO_DES=y
 CONFIG_CRYPTO_HW=y
 # CONFIG_CRYPTO_DEV_HIFN_795X is not set
 CONFIG_HAVE_KVM=y
+CONFIG_HAVE_KVM_IRQCHIP=y
 CONFIG_VIRTUALIZATION=y
 # CONFIG_KVM is not set
 # CONFIG_VIRTIO_PCI is not set
 # CONFIG_VIRTIO_BALLOON is not set
+CONFIG_BINARY_PRINTF=y
 
 #
 # Library routines
@@ -2464,7 +2537,10 @@ CONFIG_CRC32=y
 # CONFIG_CRC7 is not set
 # CONFIG_LIBCRC32C is not set
 CONFIG_ZLIB_INFLATE=y
-CONFIG_PLIST=y
+CONFIG_DECOMPRESS_GZIP=y
+CONFIG_DECOMPRESS_BZIP2=y
+CONFIG_DECOMPRESS_LZMA=y
 CONFIG_HAS_IOMEM=y
 CONFIG_HAS_IOPORT=y
 CONFIG_HAS_DMA=y
+CONFIG_NLATTR=y
diff --git a/arch/x86/include/asm/boot.h b/arch/x86/include/asm/boot.h
index 6ba23dd..418e632 100644
--- a/arch/x86/include/asm/boot.h
+++ b/arch/x86/include/asm/boot.h
@@ -8,11 +8,26 @@
 
 #ifdef __KERNEL__
 
+#include <asm/page_types.h>
+
 /* Physical address where kernel should be loaded. */
 #define LOAD_PHYSICAL_ADDR ((CONFIG_PHYSICAL_START \
 				+ (CONFIG_PHYSICAL_ALIGN - 1)) \
 				& ~(CONFIG_PHYSICAL_ALIGN - 1))
 
+/* Minimum kernel alignment, as a power of two */
+#ifdef CONFIG_x86_64
+#define MIN_KERNEL_ALIGN_LG2	PMD_SHIFT
+#else
+#define MIN_KERNEL_ALIGN_LG2	(PAGE_SHIFT+1)
+#endif
+#define MIN_KERNEL_ALIGN	(_AC(1, UL) << MIN_KERNEL_ALIGN_LG2)
+
+#if (CONFIG_PHYSICAL_ALIGN & (CONFIG_PHYSICAL_ALIGN-1)) || \
+	(CONFIG_PHYSICAL_ALIGN < (_AC(1, UL) << MIN_KERNEL_ALIGN_LG2))
+#error "Invalid value for CONFIG_PHYSICAL_ALIGN"
+#endif
+
 #ifdef CONFIG_KERNEL_BZIP2
 #define BOOT_HEAP_SIZE             0x400000
 #else /* !CONFIG_KERNEL_BZIP2 */
diff --git a/arch/x86/include/asm/bootparam.h b/arch/x86/include/asm/bootparam.h
index 433adae..1724e8d 100644
--- a/arch/x86/include/asm/bootparam.h
+++ b/arch/x86/include/asm/bootparam.h
@@ -50,7 +50,8 @@ struct setup_header {
 	__u32	ramdisk_size;
 	__u32	bootsect_kludge;
 	__u16	heap_end_ptr;
-	__u16	_pad1;
+	__u8	ext_loader_ver;
+	__u8	ext_loader_type;
 	__u32	cmd_line_ptr;
 	__u32	initrd_addr_max;
 	__u32	kernel_alignment;
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index d38c91b..e11900f 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -32,17 +32,9 @@
  */
 #define __PAGE_OFFSET           _AC(0xffff880000000000, UL)
 
-#define __PHYSICAL_START	CONFIG_PHYSICAL_START
-#define __KERNEL_ALIGN		0x200000
-
-/*
- * Make sure kernel is aligned to 2MB address. Catching it at compile
- * time is better. Change your config file and compile the kernel
- * for a 2MB aligned address (CONFIG_PHYSICAL_START)
- */
-#if (CONFIG_PHYSICAL_START % __KERNEL_ALIGN) != 0
-#error "CONFIG_PHYSICAL_START must be a multiple of 2MB"
-#endif
+#define __PHYSICAL_START	((CONFIG_PHYSICAL_START +	 	\
+				  (CONFIG_PHYSICAL_ALIGN - 1)) &	\
+				 ~(CONFIG_PHYSICAL_ALIGN - 1))
 
 #define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
 #define __START_KERNEL_map	_AC(0xffffffff80000000, UL)
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index fcf4d92..6384d25 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -814,6 +814,7 @@ extern unsigned int		BIOS_revision;
 
 /* Boot loader type from the setup header: */
 extern int			bootloader_type;
+extern int			bootloader_version;
 
 extern char			ignore_fpu_irq;
 
diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
index 5a6aa1c..1a830cb 100644
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
@@ -146,4 +146,5 @@ void foo(void)
 	OFFSET(BP_loadflags, boot_params, hdr.loadflags);
 	OFFSET(BP_hardware_subarch, boot_params, hdr.hardware_subarch);
 	OFFSET(BP_version, boot_params, hdr.version);
+	OFFSET(BP_kernel_alignment, boot_params, hdr.kernel_alignment);
 }
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index e72f062..898ecc4 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -125,6 +125,7 @@ int main(void)
 	OFFSET(BP_loadflags, boot_params, hdr.loadflags);
 	OFFSET(BP_hardware_subarch, boot_params, hdr.hardware_subarch);
 	OFFSET(BP_version, boot_params, hdr.version);
+	OFFSET(BP_kernel_alignment, boot_params, hdr.kernel_alignment);
 
 	BLANK();
 	DEFINE(PAGE_SIZE_asm, PAGE_SIZE);
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 3068388..dc5ed4b 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -608,13 +608,6 @@ ignore_int:
 ENTRY(initial_code)
 	.long i386_start_kernel
 
-.section .text
-/*
- * Real beginning of normal "text" segment
- */
-ENTRY(stext)
-ENTRY(_stext)
-
 /*
  * BSS section
  */
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index b415843..2b09345 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -214,8 +214,8 @@ unsigned long mmu_cr4_features;
 unsigned long mmu_cr4_features = X86_CR4_PAE;
 #endif
 
-/* Boot loader ID as an integer, for the benefit of proc_dointvec */
-int bootloader_type;
+/* Boot loader ID and version as integers, for the benefit of proc_dointvec */
+int bootloader_type, bootloader_version;
 
 /*
  * Setup options
@@ -706,6 +706,12 @@ void __init setup_arch(char **cmdline_p)
 #endif
 	saved_video_mode = boot_params.hdr.vid_mode;
 	bootloader_type = boot_params.hdr.type_of_loader;
+	if ((bootloader_type >> 4) == 0xe) {
+		bootloader_type &= 0xf;
+		bootloader_type |= (boot_params.hdr.ext_loader_type+0x10) << 4;
+	}
+	bootloader_version  = bootloader_type & 0xf;
+	bootloader_version |= boot_params.hdr.ext_loader_ver << 4;
 
 #ifdef CONFIG_BLK_DEV_RAM
 	rd_image_start = boot_params.hdr.ram_size & RAMDISK_IMAGE_START_MASK;
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 849ee61..4c85b2e 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -1,5 +1,431 @@
+/*
+ * ld script for the x86 kernel
+ *
+ * Historic 32-bit version written by Martin Mares <mj@atrey.karlin.mff.cuni.cz>
+ *
+ * Modernisation, unification and other changes and fixes:
+ *   Copyright (C) 2007-2009  Sam Ravnborg <sam@ravnborg.org>
+ *
+ *
+ * Don't define absolute symbols until and unless you know that symbol
+ * value is should remain constant even if kernel image is relocated
+ * at run time. Absolute symbols are not relocated. If symbol value should
+ * change if kernel is relocated, make the symbol section relative and
+ * put it inside the section definition.
+ */
+
 #ifdef CONFIG_X86_32
-# include "vmlinux_32.lds.S"
+#define LOAD_OFFSET __PAGE_OFFSET
 #else
-# include "vmlinux_64.lds.S"
+#define LOAD_OFFSET __START_KERNEL_map
 #endif
+
+#include <asm-generic/vmlinux.lds.h>
+#include <asm/asm-offsets.h>
+#include <asm/thread_info.h>
+#include <asm/page_types.h>
+#include <asm/cache.h>
+#include <asm/boot.h>
+
+#undef i386     /* in case the preprocessor is a 32bit one */
+
+OUTPUT_FORMAT(CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT)
+
+#ifdef CONFIG_X86_32
+OUTPUT_ARCH(i386)
+ENTRY(phys_startup_32)
+jiffies = jiffies_64;
+#else
+OUTPUT_ARCH(i386:x86-64)
+ENTRY(phys_startup_64)
+jiffies_64 = jiffies;
+#endif
+
+PHDRS {
+	text PT_LOAD FLAGS(5);          /* R_E */
+	data PT_LOAD FLAGS(7);          /* RWE */
+#ifdef CONFIG_X86_64
+	user PT_LOAD FLAGS(7);          /* RWE */
+	data.init PT_LOAD FLAGS(7);     /* RWE */
+#ifdef CONFIG_SMP
+	percpu PT_LOAD FLAGS(7);        /* RWE */
+#endif
+	data.init2 PT_LOAD FLAGS(7);    /* RWE */
+#endif
+	note PT_NOTE FLAGS(0);          /* ___ */
+}
+
+SECTIONS
+{
+#ifdef CONFIG_X86_32
+        . = LOAD_OFFSET + LOAD_PHYSICAL_ADDR;
+        phys_startup_32 = startup_32 - LOAD_OFFSET;
+#else
+        . = __START_KERNEL;
+        phys_startup_64 = startup_64 - LOAD_OFFSET;
+#endif
+
+	/* Text and read-only data */
+
+	/* bootstrapping code */
+	.text.head : AT(ADDR(.text.head) - LOAD_OFFSET) {
+		_text = .;
+		*(.text.head)
+	} :text = 0x9090
+
+	/* The rest of the text */
+	.text :  AT(ADDR(.text) - LOAD_OFFSET) {
+#ifdef CONFIG_X86_32
+		/* not really needed, already page aligned */
+		. = ALIGN(PAGE_SIZE);
+		*(.text.page_aligned)
+#endif
+		. = ALIGN(8);
+		_stext = .;
+		TEXT_TEXT
+		SCHED_TEXT
+		LOCK_TEXT
+		KPROBES_TEXT
+		IRQENTRY_TEXT
+		*(.fixup)
+		*(.gnu.warning)
+		/* End of text section */
+		_etext = .;
+	} :text = 0x9090
+
+	NOTES :text :note
+
+	/* Exception table */
+	. = ALIGN(16);
+	__ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
+		__start___ex_table = .;
+		*(__ex_table)
+		__stop___ex_table = .;
+	} :text = 0x9090
+
+	RODATA
+
+	/* Data */
+	. = ALIGN(PAGE_SIZE);
+	.data : AT(ADDR(.data) - LOAD_OFFSET) {
+		DATA_DATA
+		CONSTRUCTORS
+
+#ifdef CONFIG_X86_64
+		/* End of data section */
+		_edata = .;
+#endif
+	} :data
+
+#ifdef CONFIG_X86_32
+	/* 32 bit has nosave before _edata */
+	. = ALIGN(PAGE_SIZE);
+	.data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
+		__nosave_begin = .;
+		*(.data.nosave)
+		. = ALIGN(PAGE_SIZE);
+		__nosave_end = .;
+	}
+#endif
+
+	. = ALIGN(PAGE_SIZE);
+	.data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
+		*(.data.page_aligned)
+		*(.data.idt)
+	}
+
+#ifdef CONFIG_X86_32
+	. = ALIGN(32);
+#else
+	. = ALIGN(PAGE_SIZE);
+	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
+#endif
+	.data.cacheline_aligned :
+		AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {
+		*(.data.cacheline_aligned)
+	}
+
+	/* rarely changed data like cpu maps */
+#ifdef CONFIG_X86_32
+	. = ALIGN(32);
+#else
+	. = ALIGN(CONFIG_X86_INTERNODE_CACHE_BYTES);
+#endif
+	.data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
+		*(.data.read_mostly)
+
+#ifdef CONFIG_X86_32
+		/* End of data section */
+		_edata = .;
+#endif
+	}
+
+#ifdef CONFIG_X86_64
+
+#define VSYSCALL_ADDR (-10*1024*1024)
+#define VSYSCALL_PHYS_ADDR ((LOADADDR(.data.read_mostly) + \
+                            SIZEOF(.data.read_mostly) + 4095) & ~(4095))
+#define VSYSCALL_VIRT_ADDR ((ADDR(.data.read_mostly) + \
+                            SIZEOF(.data.read_mostly) + 4095) & ~(4095))
+
+#define VLOAD_OFFSET (VSYSCALL_ADDR - VSYSCALL_PHYS_ADDR)
+#define VLOAD(x) (ADDR(x) - VLOAD_OFFSET)
+
+#define VVIRT_OFFSET (VSYSCALL_ADDR - VSYSCALL_VIRT_ADDR)
+#define VVIRT(x) (ADDR(x) - VVIRT_OFFSET)
+
+	. = VSYSCALL_ADDR;
+	.vsyscall_0 : AT(VSYSCALL_PHYS_ADDR) {
+		*(.vsyscall_0)
+	} :user
+
+	__vsyscall_0 = VSYSCALL_VIRT_ADDR;
+
+	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
+	.vsyscall_fn : AT(VLOAD(.vsyscall_fn)) {
+		*(.vsyscall_fn)
+	}
+
+	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
+	.vsyscall_gtod_data : AT(VLOAD(.vsyscall_gtod_data)) {
+		*(.vsyscall_gtod_data)
+	}
+
+	vsyscall_gtod_data = VVIRT(.vsyscall_gtod_data);
+	.vsyscall_clock : AT(VLOAD(.vsyscall_clock)) {
+		*(.vsyscall_clock)
+	}
+	vsyscall_clock = VVIRT(.vsyscall_clock);
+
+
+	.vsyscall_1 ADDR(.vsyscall_0) + 1024: AT(VLOAD(.vsyscall_1)) {
+		*(.vsyscall_1)
+	}
+	.vsyscall_2 ADDR(.vsyscall_0) + 2048: AT(VLOAD(.vsyscall_2)) {
+		*(.vsyscall_2)
+	}
+
+	.vgetcpu_mode : AT(VLOAD(.vgetcpu_mode)) {
+		*(.vgetcpu_mode)
+	}
+	vgetcpu_mode = VVIRT(.vgetcpu_mode);
+
+	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
+	.jiffies : AT(VLOAD(.jiffies)) {
+		*(.jiffies)
+	}
+	jiffies = VVIRT(.jiffies);
+
+	.vsyscall_3 ADDR(.vsyscall_0) + 3072: AT(VLOAD(.vsyscall_3)) {
+		*(.vsyscall_3)
+	}
+
+	. = VSYSCALL_VIRT_ADDR + PAGE_SIZE;
+
+#undef VSYSCALL_ADDR
+#undef VSYSCALL_PHYS_ADDR
+#undef VSYSCALL_VIRT_ADDR
+#undef VLOAD_OFFSET
+#undef VLOAD
+#undef VVIRT_OFFSET
+#undef VVIRT
+
+#endif /* CONFIG_X86_64 */
+
+	/* init_task */
+	. = ALIGN(THREAD_SIZE);
+	.data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
+		*(.data.init_task)
+	}
+#ifdef CONFIG_X86_64
+	 :data.init
+#endif
+
+	/*
+	 * smp_locks might be freed after init
+	 * start/end must be page aligned
+	 */
+	. = ALIGN(PAGE_SIZE);
+	.smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
+		__smp_locks = .;
+		*(.smp_locks)
+		__smp_locks_end = .;
+		. = ALIGN(PAGE_SIZE);
+	}
+
+	/* Init code and data - will be freed after init */
+	. = ALIGN(PAGE_SIZE);
+	.init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
+		__init_begin = .; /* paired with __init_end */
+		_sinittext = .;
+		INIT_TEXT
+		_einittext = .;
+	}
+
+	.init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {
+		INIT_DATA
+	}
+
+	. = ALIGN(16);
+	.init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) {
+		__setup_start = .;
+		*(.init.setup)
+		__setup_end = .;
+	}
+	.initcall.init : AT(ADDR(.initcall.init) - LOAD_OFFSET) {
+		__initcall_start = .;
+		INITCALLS
+		__initcall_end = .;
+	}
+
+	.con_initcall.init : AT(ADDR(.con_initcall.init) - LOAD_OFFSET) {
+		__con_initcall_start = .;
+		*(.con_initcall.init)
+		__con_initcall_end = .;
+	}
+
+	.x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
+		__x86_cpu_dev_start = .;
+		*(.x86_cpu_dev.init)
+		__x86_cpu_dev_end = .;
+	}
+
+	SECURITY_INIT
+
+	. = ALIGN(8);
+	.parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
+		__parainstructions = .;
+		*(.parainstructions)
+		__parainstructions_end = .;
+	}
+
+	. = ALIGN(8);
+	.altinstructions : AT(ADDR(.altinstructions) - LOAD_OFFSET) {
+		__alt_instructions = .;
+		*(.altinstructions)
+		__alt_instructions_end = .;
+	}
+
+	.altinstr_replacement : AT(ADDR(.altinstr_replacement) - LOAD_OFFSET) {
+		*(.altinstr_replacement)
+	}
+
+	/*
+	 * .exit.text is discard at runtime, not link time, to deal with
+	 *  references from .altinstructions and .eh_frame
+	 */
+	.exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) {
+		EXIT_TEXT
+	}
+
+	.exit.data : AT(ADDR(.exit.data) - LOAD_OFFSET) {
+		EXIT_DATA
+	}
+
+#ifdef CONFIG_BLK_DEV_INITRD
+	. = ALIGN(PAGE_SIZE);
+	.init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {
+		__initramfs_start = .;
+		*(.init.ramfs)
+		__initramfs_end = .;
+	}
+#endif
+
+#if defined(CONFIG_X86_64) && defined(CONFIG_SMP)
+	/*
+	 * percpu offsets are zero-based on SMP.  PERCPU_VADDR() changes the
+	 * output PHDR, so the next output section - __data_nosave - should
+	 * start another section data.init2.  Also, pda should be at the head of
+	 * percpu area.  Preallocate it and define the percpu offset symbol
+	 * so that it can be accessed as a percpu variable.
+	 */
+	. = ALIGN(PAGE_SIZE);
+	PERCPU_VADDR(0, :percpu)
+#else
+	PERCPU(PAGE_SIZE)
+#endif
+
+	. = ALIGN(PAGE_SIZE);
+
+	/* freed after init ends here */
+	.init.end : AT(ADDR(.init.end) - LOAD_OFFSET) {
+		__init_end = .;
+	}
+
+#ifdef CONFIG_X86_64
+	.data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
+		. = ALIGN(PAGE_SIZE);
+		__nosave_begin = .;
+		*(.data.nosave)
+		. = ALIGN(PAGE_SIZE);
+		__nosave_end = .;
+	} :data.init2
+	/* use another section data.init2, see PERCPU_VADDR() above */
+#endif
+
+	/* BSS */
+	. = ALIGN(PAGE_SIZE);
+	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {
+		__bss_start = .;
+		*(.bss.page_aligned)
+		*(.bss)
+		. = ALIGN(4);
+		__bss_stop = .;
+	}
+
+	. = ALIGN(PAGE_SIZE);
+	.brk : AT(ADDR(.brk) - LOAD_OFFSET) {
+		__brk_base = .;
+		. += 64 * 1024;		/* 64k alignment slop space */
+		*(.brk_reservation)	/* areas brk users have reserved */
+		__brk_limit = .;
+	}
+
+	.end : AT(ADDR(.end) - LOAD_OFFSET) {
+		_end = .;
+	}
+
+	/* Sections to be discarded */
+	/DISCARD/ : {
+		*(.exitcall.exit)
+		*(.eh_frame)
+		*(.discard)
+	}
+
+        STABS_DEBUG
+        DWARF_DEBUG
+}
+
+
+#ifdef CONFIG_X86_32
+ASSERT((_end - LOAD_OFFSET <= KERNEL_IMAGE_SIZE),
+        "kernel image bigger than KERNEL_IMAGE_SIZE")
+#else
+/*
+ * Per-cpu symbols which need to be offset from __per_cpu_load
+ * for the boot processor.
+ */
+#define INIT_PER_CPU(x) init_per_cpu__##x = per_cpu__##x + __per_cpu_load
+INIT_PER_CPU(gdt_page);
+INIT_PER_CPU(irq_stack_union);
+
+/*
+ * Build-time check on the image size:
+ */
+ASSERT((_end - _text <= KERNEL_IMAGE_SIZE),
+	"kernel image bigger than KERNEL_IMAGE_SIZE")
+
+#ifdef CONFIG_SMP
+ASSERT((per_cpu__irq_stack_union == 0),
+        "irq_stack_union is not at start of per-cpu area");
+#endif
+
+#endif /* CONFIG_X86_32 */
+
+#ifdef CONFIG_KEXEC
+#include <asm/kexec.h>
+
+ASSERT(kexec_control_code_size <= KEXEC_CONTROL_CODE_MAX_SIZE,
+       "kexec control code size is too big")
+#endif
+
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
deleted file mode 100644
index 62ad500..0000000
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ /dev/null
@@ -1,229 +0,0 @@
-/* ld script to make i386 Linux kernel
- * Written by Martin Mares <mj@atrey.karlin.mff.cuni.cz>;
- *
- * Don't define absolute symbols until and unless you know that symbol
- * value is should remain constant even if kernel image is relocated
- * at run time. Absolute symbols are not relocated. If symbol value should
- * change if kernel is relocated, make the symbol section relative and
- * put it inside the section definition.
- */
-
-#define LOAD_OFFSET __PAGE_OFFSET
-
-#include <asm-generic/vmlinux.lds.h>
-#include <asm/thread_info.h>
-#include <asm/page_types.h>
-#include <asm/cache.h>
-#include <asm/boot.h>
-
-OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
-OUTPUT_ARCH(i386)
-ENTRY(phys_startup_32)
-jiffies = jiffies_64;
-
-PHDRS {
-	text PT_LOAD FLAGS(5);	/* R_E */
-	data PT_LOAD FLAGS(7);	/* RWE */
-	note PT_NOTE FLAGS(0);	/* ___ */
-}
-SECTIONS
-{
-  . = LOAD_OFFSET + LOAD_PHYSICAL_ADDR;
-  phys_startup_32 = startup_32 - LOAD_OFFSET;
-
-  .text.head : AT(ADDR(.text.head) - LOAD_OFFSET) {
-  	_text = .;			/* Text and read-only data */
-	*(.text.head)
-  } :text = 0x9090
-
-  /* read-only */
-  .text : AT(ADDR(.text) - LOAD_OFFSET) {
-	. = ALIGN(PAGE_SIZE); /* not really needed, already page aligned */
-	*(.text.page_aligned)
-	TEXT_TEXT
-	SCHED_TEXT
-	LOCK_TEXT
-	KPROBES_TEXT
-	IRQENTRY_TEXT
-	*(.fixup)
-	*(.gnu.warning)
-  	_etext = .;			/* End of text section */
-  } :text = 0x9090
-
-  NOTES :text :note
-
-  . = ALIGN(16);		/* Exception table */
-  __ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
-  	__start___ex_table = .;
-	 *(__ex_table)
-  	__stop___ex_table = .;
-  } :text = 0x9090
-
-  RODATA
-
-  /* writeable */
-  . = ALIGN(PAGE_SIZE);
-  .data : AT(ADDR(.data) - LOAD_OFFSET) {	/* Data */
-	DATA_DATA
-	CONSTRUCTORS
-	} :data
-
-  . = ALIGN(PAGE_SIZE);
-  .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
-  	__nosave_begin = .;
-	*(.data.nosave)
-  	. = ALIGN(PAGE_SIZE);
-  	__nosave_end = .;
-  }
-
-  . = ALIGN(PAGE_SIZE);
-  .data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
-	*(.data.page_aligned)
-	*(.data.idt)
-  }
-
-  . = ALIGN(32);
-  .data.cacheline_aligned : AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {
-	*(.data.cacheline_aligned)
-  }
-
-  /* rarely changed data like cpu maps */
-  . = ALIGN(32);
-  .data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
-	*(.data.read_mostly)
-	_edata = .;		/* End of data section */
-  }
-
-  . = ALIGN(THREAD_SIZE);	/* init_task */
-  .data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
-	*(.data.init_task)
-  }
-
-  /* might get freed after init */
-  . = ALIGN(PAGE_SIZE);
-  .smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
-  	__smp_locks = .;
-	*(.smp_locks)
-	__smp_locks_end = .;
-  }
-  /* will be freed after init
-   * Following ALIGN() is required to make sure no other data falls on the
-   * same page where __smp_alt_end is pointing as that page might be freed
-   * after boot. Always make sure that ALIGN() directive is present after
-   * the section which contains __smp_alt_end.
-   */
-  . = ALIGN(PAGE_SIZE);
-
-  /* will be freed after init */
-  . = ALIGN(PAGE_SIZE);		/* Init code and data */
-  .init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
-  	__init_begin = .;
-	_sinittext = .;
-	INIT_TEXT
-	_einittext = .;
-  }
-  .init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {
-	INIT_DATA
-  }
-  . = ALIGN(16);
-  .init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) {
-  	__setup_start = .;
-	*(.init.setup)
-  	__setup_end = .;
-   }
-  .initcall.init : AT(ADDR(.initcall.init) - LOAD_OFFSET) {
-  	__initcall_start = .;
-	INITCALLS
-  	__initcall_end = .;
-  }
-  .con_initcall.init : AT(ADDR(.con_initcall.init) - LOAD_OFFSET) {
-  	__con_initcall_start = .;
-	*(.con_initcall.init)
-  	__con_initcall_end = .;
-  }
-  .x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
-	__x86_cpu_dev_start = .;
-	*(.x86_cpu_dev.init)
-	__x86_cpu_dev_end = .;
-  }
-  SECURITY_INIT
-  . = ALIGN(4);
-  .altinstructions : AT(ADDR(.altinstructions) - LOAD_OFFSET) {
-  	__alt_instructions = .;
-	*(.altinstructions)
-	__alt_instructions_end = .;
-  }
-  .altinstr_replacement : AT(ADDR(.altinstr_replacement) - LOAD_OFFSET) {
-	*(.altinstr_replacement)
-  }
-  . = ALIGN(4);
-  .parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
-  	__parainstructions = .;
-	*(.parainstructions)
-  	__parainstructions_end = .;
-  }
-  /* .exit.text is discard at runtime, not link time, to deal with references
-     from .altinstructions and .eh_frame */
-  .exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) {
-	EXIT_TEXT
-  }
-  .exit.data : AT(ADDR(.exit.data) - LOAD_OFFSET) {
-	EXIT_DATA
-  }
-#if defined(CONFIG_BLK_DEV_INITRD)
-  . = ALIGN(PAGE_SIZE);
-  .init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {
-	__initramfs_start = .;
-	*(.init.ramfs)
-	__initramfs_end = .;
-  }
-#endif
-  PERCPU(PAGE_SIZE)
-  . = ALIGN(PAGE_SIZE);
-  /* freed after init ends here */
-
-  .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
-	__init_end = .;
-	__bss_start = .;		/* BSS */
-	*(.bss.page_aligned)
-	*(.bss)
-	. = ALIGN(4);
-	__bss_stop = .;
-  }
-
-  .brk : AT(ADDR(.brk) - LOAD_OFFSET) {
-	. = ALIGN(PAGE_SIZE);
-	__brk_base = . ;
- 	. += 64 * 1024 ;	/* 64k alignment slop space */
-	*(.brk_reservation)	/* areas brk users have reserved */
-	__brk_limit = . ;
-  }
-
-  .end : AT(ADDR(.end) - LOAD_OFFSET) {
-	_end = . ;
-  }
-
-  /* Sections to be discarded */
-  /DISCARD/ : {
-	*(.exitcall.exit)
-	*(.discard)
-	}
-
-  STABS_DEBUG
-
-  DWARF_DEBUG
-}
-
-/*
- * Build-time check on the image size:
- */
-ASSERT((_end - LOAD_OFFSET <= KERNEL_IMAGE_SIZE),
-	"kernel image bigger than KERNEL_IMAGE_SIZE")
-
-#ifdef CONFIG_KEXEC
-/* Link time checks */
-#include <asm/kexec.h>
-
-ASSERT(kexec_control_code_size <= KEXEC_CONTROL_CODE_MAX_SIZE,
-       "kexec control code size is too big")
-#endif
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
deleted file mode 100644
index c874250..0000000
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ /dev/null
@@ -1,298 +0,0 @@
-/* ld script to make x86-64 Linux kernel
- * Written by Martin Mares <mj@atrey.karlin.mff.cuni.cz>;
- */
-
-#define LOAD_OFFSET __START_KERNEL_map
-
-#include <asm-generic/vmlinux.lds.h>
-#include <asm/asm-offsets.h>
-#include <asm/page_types.h>
-
-#undef i386	/* in case the preprocessor is a 32bit one */
-
-OUTPUT_FORMAT("elf64-x86-64", "elf64-x86-64", "elf64-x86-64")
-OUTPUT_ARCH(i386:x86-64)
-ENTRY(phys_startup_64)
-jiffies_64 = jiffies;
-PHDRS {
-	text PT_LOAD FLAGS(5);	/* R_E */
-	data PT_LOAD FLAGS(7);	/* RWE */
-	user PT_LOAD FLAGS(7);	/* RWE */
-	data.init PT_LOAD FLAGS(7);	/* RWE */
-#ifdef CONFIG_SMP
-	percpu PT_LOAD FLAGS(7);	/* RWE */
-#endif
-	data.init2 PT_LOAD FLAGS(7);	/* RWE */
-	note PT_NOTE FLAGS(0);	/* ___ */
-}
-SECTIONS
-{
-  . = __START_KERNEL;
-  phys_startup_64 = startup_64 - LOAD_OFFSET;
-  .text :  AT(ADDR(.text) - LOAD_OFFSET) {
-	_text = .;			/* Text and read-only data */
-	/* First the code that has to be first for bootstrapping */
-	*(.text.head)
-	_stext = .;
-	/* Then the rest */
-	TEXT_TEXT
-	SCHED_TEXT
-	LOCK_TEXT
-	KPROBES_TEXT
-	IRQENTRY_TEXT
-	*(.fixup)
-	*(.gnu.warning)
-	_etext = .;		/* End of text section */
-  } :text = 0x9090
-
-  NOTES :text :note
-
-  . = ALIGN(16);		/* Exception table */
-  __ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
-  	__start___ex_table = .;
-	 *(__ex_table)
-  	__stop___ex_table = .;
-  } :text = 0x9090
-
-  RODATA
-
-  . = ALIGN(PAGE_SIZE);		/* Align data segment to page size boundary */
-				/* Data */
-  .data : AT(ADDR(.data) - LOAD_OFFSET) {
-	DATA_DATA
-	CONSTRUCTORS
-	_edata = .;			/* End of data section */
-	} :data
-
-
-  .data.cacheline_aligned : AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {
-	. = ALIGN(PAGE_SIZE);
-	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
-	*(.data.cacheline_aligned)
-  }
-  . = ALIGN(CONFIG_X86_INTERNODE_CACHE_BYTES);
-  .data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
-  	*(.data.read_mostly)
-  }
-
-#define VSYSCALL_ADDR (-10*1024*1024)
-#define VSYSCALL_PHYS_ADDR ((LOADADDR(.data.read_mostly) + SIZEOF(.data.read_mostly) + 4095) & ~(4095))
-#define VSYSCALL_VIRT_ADDR ((ADDR(.data.read_mostly) + SIZEOF(.data.read_mostly) + 4095) & ~(4095))
-
-#define VLOAD_OFFSET (VSYSCALL_ADDR - VSYSCALL_PHYS_ADDR)
-#define VLOAD(x) (ADDR(x) - VLOAD_OFFSET)
-
-#define VVIRT_OFFSET (VSYSCALL_ADDR - VSYSCALL_VIRT_ADDR)
-#define VVIRT(x) (ADDR(x) - VVIRT_OFFSET)
-
-  . = VSYSCALL_ADDR;
-  .vsyscall_0 :	 AT(VSYSCALL_PHYS_ADDR) { *(.vsyscall_0) } :user
-  __vsyscall_0 = VSYSCALL_VIRT_ADDR;
-
-  . = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
-  .vsyscall_fn : AT(VLOAD(.vsyscall_fn)) { *(.vsyscall_fn) }
-  . = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
-  .vsyscall_gtod_data : AT(VLOAD(.vsyscall_gtod_data))
-		{ *(.vsyscall_gtod_data) }
-  vsyscall_gtod_data = VVIRT(.vsyscall_gtod_data);
-  .vsyscall_clock : AT(VLOAD(.vsyscall_clock))
-		{ *(.vsyscall_clock) }
-  vsyscall_clock = VVIRT(.vsyscall_clock);
-
-
-  .vsyscall_1 ADDR(.vsyscall_0) + 1024: AT(VLOAD(.vsyscall_1))
-		{ *(.vsyscall_1) }
-  .vsyscall_2 ADDR(.vsyscall_0) + 2048: AT(VLOAD(.vsyscall_2))
-		{ *(.vsyscall_2) }
-
-  .vgetcpu_mode : AT(VLOAD(.vgetcpu_mode)) { *(.vgetcpu_mode) }
-  vgetcpu_mode = VVIRT(.vgetcpu_mode);
-
-  . = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
-  .jiffies : AT(VLOAD(.jiffies)) { *(.jiffies) }
-  jiffies = VVIRT(.jiffies);
-
-  .vsyscall_3 ADDR(.vsyscall_0) + 3072: AT(VLOAD(.vsyscall_3))
-		{ *(.vsyscall_3) }
-
-  . = VSYSCALL_VIRT_ADDR + PAGE_SIZE;
-
-#undef VSYSCALL_ADDR
-#undef VSYSCALL_PHYS_ADDR
-#undef VSYSCALL_VIRT_ADDR
-#undef VLOAD_OFFSET
-#undef VLOAD
-#undef VVIRT_OFFSET
-#undef VVIRT
-
-  .data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
-	. = ALIGN(THREAD_SIZE);	/* init_task */
-	*(.data.init_task)
-  }:data.init
-
-  .data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
-	. = ALIGN(PAGE_SIZE);
-	*(.data.page_aligned)
-  }
-
-  .smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
-	/* might get freed after init */
-	. = ALIGN(PAGE_SIZE);
-	__smp_alt_begin = .;
-	__smp_locks = .;
-	*(.smp_locks)
-	__smp_locks_end = .;
-	. = ALIGN(PAGE_SIZE);
-	__smp_alt_end = .;
-  }
-
-  . = ALIGN(PAGE_SIZE);		/* Init code and data */
-  __init_begin = .;	/* paired with __init_end */
-  .init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
-	_sinittext = .;
-	INIT_TEXT
-	_einittext = .;
-  }
-  .init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {
-	__initdata_begin = .;
-	INIT_DATA
-	__initdata_end = .;
-   }
-
-  .init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) {
-	. = ALIGN(16);
-	__setup_start = .;
-	*(.init.setup)
-	__setup_end = .;
-  }
-  .initcall.init : AT(ADDR(.initcall.init) - LOAD_OFFSET) {
-	__initcall_start = .;
-	INITCALLS
-	__initcall_end = .;
-  }
-  .con_initcall.init : AT(ADDR(.con_initcall.init) - LOAD_OFFSET) {
-	__con_initcall_start = .;
-	*(.con_initcall.init)
-	__con_initcall_end = .;
-  }
-  .x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
-	__x86_cpu_dev_start = .;
-	*(.x86_cpu_dev.init)
-	__x86_cpu_dev_end = .;
-  }
-  SECURITY_INIT
-
-  . = ALIGN(8);
-  .parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
-	__parainstructions = .;
-       *(.parainstructions)
-	__parainstructions_end = .;
-  }
-
-  .altinstructions : AT(ADDR(.altinstructions) - LOAD_OFFSET) {
-	. = ALIGN(8);
-	__alt_instructions = .;
-	*(.altinstructions)
-	__alt_instructions_end = .;
-  }
-  .altinstr_replacement : AT(ADDR(.altinstr_replacement) - LOAD_OFFSET) {
-	*(.altinstr_replacement)
-  }
-  /* .exit.text is discard at runtime, not link time, to deal with references
-     from .altinstructions and .eh_frame */
-  .exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) {
-	EXIT_TEXT
-  }
-  .exit.data : AT(ADDR(.exit.data) - LOAD_OFFSET) {
-	EXIT_DATA
-  }
-
-#ifdef CONFIG_BLK_DEV_INITRD
-  . = ALIGN(PAGE_SIZE);
-  .init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {
-	__initramfs_start = .;
-	*(.init.ramfs)
-	__initramfs_end = .;
-  }
-#endif
-
-#ifdef CONFIG_SMP
-  /*
-   * percpu offsets are zero-based on SMP.  PERCPU_VADDR() changes the
-   * output PHDR, so the next output section - __data_nosave - should
-   * start another section data.init2.  Also, pda should be at the head of
-   * percpu area.  Preallocate it and define the percpu offset symbol
-   * so that it can be accessed as a percpu variable.
-   */
-  . = ALIGN(PAGE_SIZE);
-  PERCPU_VADDR(0, :percpu)
-#else
-  PERCPU(PAGE_SIZE)
-#endif
-
-  . = ALIGN(PAGE_SIZE);
-  __init_end = .;
-
-  .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
-	. = ALIGN(PAGE_SIZE);
-	__nosave_begin = .;
-	*(.data.nosave)
-	. = ALIGN(PAGE_SIZE);
-	__nosave_end = .;
-  } :data.init2 /* use another section data.init2, see PERCPU_VADDR() above */
-
-  .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
-	. = ALIGN(PAGE_SIZE);
-	__bss_start = .;		/* BSS */
-	*(.bss.page_aligned)
-	*(.bss)
-	__bss_stop = .;
-  }
-
-  .brk : AT(ADDR(.brk) - LOAD_OFFSET) {
-	. = ALIGN(PAGE_SIZE);
-	__brk_base = . ;
- 	. += 64 * 1024 ;	/* 64k alignment slop space */
-	*(.brk_reservation)	/* areas brk users have reserved */
-	__brk_limit = . ;
-  }
-
-  _end = . ;
-
-  /* Sections to be discarded */
-  /DISCARD/ : {
-	*(.exitcall.exit)
-	*(.eh_frame)
-	*(.discard)
-	}
-
-  STABS_DEBUG
-
-  DWARF_DEBUG
-}
-
- /*
-  * Per-cpu symbols which need to be offset from __per_cpu_load
-  * for the boot processor.
-  */
-#define INIT_PER_CPU(x) init_per_cpu__##x = per_cpu__##x + __per_cpu_load
-INIT_PER_CPU(gdt_page);
-INIT_PER_CPU(irq_stack_union);
-
-/*
- * Build-time check on the image size:
- */
-ASSERT((_end - _text <= KERNEL_IMAGE_SIZE),
-	"kernel image bigger than KERNEL_IMAGE_SIZE")
-
-#ifdef CONFIG_SMP
-ASSERT((per_cpu__irq_stack_union == 0),
-        "irq_stack_union is not at start of per-cpu area");
-#endif
-
-#ifdef CONFIG_KEXEC
-#include <asm/kexec.h>
-
-ASSERT(kexec_control_code_size <= KEXEC_CONTROL_CODE_MAX_SIZE,
-       "kexec control code size is too big")
-#endif
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index e3d2c7d..cf91c93 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -729,6 +729,14 @@ static struct ctl_table kern_table[] = {
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "bootloader_version",
+		.data		= &bootloader_version,
+		.maxlen		= sizeof (int),
+		.mode		= 0444,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "kstack_depth_to_print",
 		.data		= &kstack_depth_to_print,
 		.maxlen		= sizeof(int),
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 9796195..f8cf938 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -183,20 +183,34 @@ cmd_objcopy = $(OBJCOPY) $(OBJCOPYFLAGS) $(OBJCOPYFLAGS_$(@F)) $< $@
 # ---------------------------------------------------------------------------
 
 quiet_cmd_gzip = GZIP    $@
-cmd_gzip = gzip -f -9 < $< > $@
+cmd_gzip = (cat $(filter-out FORCE,$^) | gzip -f -9 > $@) || \
+	(rm -f $@ ; false)
 
 
 # Bzip2
 # ---------------------------------------------------------------------------
 
-# Bzip2 does not include size in file... so we have to fake that
-size_append=$(CONFIG_SHELL) $(srctree)/scripts/bin_size
-
-quiet_cmd_bzip2 = BZIP2    $@
-cmd_bzip2 = (bzip2 -9 < $< && $(size_append) $<) > $@ || (rm -f $@ ; false)
+# Bzip2 and LZMA do not include size in file... so we have to fake that;
+# append the size as a 32-bit littleendian number as gzip does.
+size_append = echo -ne $(shell						\
+dec_size=0;								\
+for F in $1; do								\
+	fsize=$$(stat -c "%s" $$F);					\
+	dec_size=$$(expr $$dec_size + $$fsize);				\
+done;									\
+printf "%08x" $$dec_size |						\
+	sed 's/\(..\)\(..\)\(..\)\(..\)/\\\\x\4\\\\x\3\\\\x\2\\\\x\1/g'	\
+)
+
+quiet_cmd_bzip2 = BZIP2   $@
+cmd_bzip2 = (cat $(filter-out FORCE,$^) | \
+	bzip2 -9 && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
+	(rm -f $@ ; false)
 
 # Lzma
 # ---------------------------------------------------------------------------
 
 quiet_cmd_lzma = LZMA    $@
-cmd_lzma = (lzma -9 -c $< && $(size_append) $<) >$@ || (rm -f $@ ; false)
+cmd_lzma = (cat $(filter-out FORCE,$^) | \
+	lzma -9 && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
+	(rm -f $@ ; false)
diff --git a/scripts/bin_size b/scripts/bin_size
deleted file mode 100644
index 43e1b36..0000000
--- a/scripts/bin_size
+++ /dev/null
@@ -1,10 +0,0 @@
-#!/bin/sh
-
-if [ $# = 0 ] ; then
-   echo Usage: $0 file
-fi
-
-size_dec=`stat -c "%s" $1`
-size_hex_echo_string=`printf "%08x" $size_dec |
-     sed 's/\(..\)\(..\)\(..\)\(..\)/\\\\x\4\\\\x\3\\\\x\2\\\\x\1/g'`
-/bin/echo -ne $size_hex_echo_string
