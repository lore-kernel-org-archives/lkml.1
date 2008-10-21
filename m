Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbYJUQmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbYJUQmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 12:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbYJUQmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 12:42:24 -0400
Received: from krynn.se.axis.com ([193.13.178.10]:37182 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbYJUQmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 12:42:20 -0400
Date: Tue, 21 Oct 2008 18:42:11 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [RFC] CRIS: Move header files from include to arch/cris
Message-ID: <20081021164211.GG24715@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm looking for some feedback on the changes in the branch include_move
at the git-tree:

	git://repo.or.cz/cris-mirror.git include_move

I've performed the move of the CRIS headers using the ARM and Blackfin
ports as a pattern.

That means that the machine dependent header files are moved to
arch/cris/mach-{fs,a3}/include, while the common and architecture
dependent files are moved to arch/cris/include.

It is mainly this I'd like some input on, since most other ports
that have moved their header files have put all headers in arch/*/include.


I've also removed a number of duplicated headers for arch-v32.

A shortlog is available at:

http://repo.or.cz/w/cris-mirror.git?a=commit;h=fc39fc9bc04995b8b31e50fa90a750c4be78f0ba

Since the complete patch is too large to post, I'll just include
the commands I've performed to complete the move, and the files changed
after the move.

/Jesper

mkdir -p arch/cris/include/arch-v10
mkdir -p arch/cris/include/arch-v32
mkdir -p arch/cris/mach-a3/include
mkdir -p arch/cris/mach-fs/include
git mv include/asm-cris/arch-v32/mach-a3 arch/cris/mach-a3/include/mach
git mv include/asm-cris/arch-v32/mach-fs arch/cris/mach-fs/include/mach
git mv include/asm-cris/arch-v10 arch/cris/include/arch-v10/arch
git mv include/asm-cris/arch-v32 arch/cris/include/arch-v32/arch
git mv include/asm-cris arch/cris/include/asm
git rm -f arch/cris/include/arch-v32/arch/hwregs/intr_vect.h
git rm -f arch/cris/include/arch-v32/arch/hwregs/strmux_defs.h
git rm -f arch/cris/include/arch-v32/arch/hwregs/pinmux_defs.h
git rm -f arch/cris/include/arch-v32/arch/hwregs/gio_defs.h
git rm -f arch/cris/include/arch-v32/arch/pinmux.h
git rm -f arch/cris/include/arch-v32/arch/arbiter.h
git rm -f arch/cris/include/arch-v32/arch/hwregs/asm/reg_map_asm.h
git rm -f arch/cris/include/arch-v32/arch/hwregs/asm/pinmux_defs_asm.h

---
 arch/cris/Makefile                             |   26 ++++++++-----------------
 arch/cris/arch-v10/boot/compressed/head.S      |    2 -
 arch/cris/arch-v10/boot/compressed/misc.c      |    2 -
 arch/cris/arch-v10/boot/rescue/head.S          |    2 -
 arch/cris/arch-v10/boot/rescue/kimagerescue.S  |    2 -
 arch/cris/arch-v10/boot/rescue/testrescue.S    |    2 -
 arch/cris/arch-v10/drivers/axisflashmap.c      |    2 -
 arch/cris/arch-v10/drivers/ds1302.c            |    4 +--
 arch/cris/arch-v10/drivers/gpio.c              |    4 +--
 arch/cris/arch-v10/drivers/i2c.c               |    4 +--
 arch/cris/arch-v10/drivers/sync_serial.c       |    4 +--
 arch/cris/arch-v10/kernel/crisksyms.c          |    2 -
 arch/cris/arch-v10/kernel/debugport.c          |    2 -
 arch/cris/arch-v10/kernel/dma.c                |    2 -
 arch/cris/arch-v10/kernel/entry.S              |    2 -
 arch/cris/arch-v10/kernel/fasttimer.c          |    2 -
 arch/cris/arch-v10/kernel/head.S               |    2 -
 arch/cris/arch-v10/kernel/io_interface_mux.c   |    4 +--
 arch/cris/arch-v10/kernel/kgdb.c               |    2 -
 arch/cris/arch-v10/kernel/process.c            |    2 -
 arch/cris/arch-v10/kernel/time.c               |    2 -
 arch/cris/arch-v10/kernel/traps.c              |    2 -
 arch/cris/arch-v10/mm/fault.c                  |    2 -
 arch/cris/arch-v10/mm/init.c                   |    2 -
 arch/cris/arch-v10/mm/tlb.c                    |    2 -
 arch/cris/arch-v32/boot/compressed/head.S      |    4 +--
 arch/cris/arch-v32/drivers/mach-a3/gpio.c      |    2 -
 arch/cris/arch-v32/drivers/mach-a3/nandflash.c |    2 -
 arch/cris/arch-v32/drivers/mach-fs/nandflash.c |    2 -
 arch/cris/arch-v32/drivers/pci/bios.c          |    2 -
 arch/cris/arch-v32/kernel/cache.c              |    4 +--
 arch/cris/arch-v32/kernel/crisksyms.c          |    8 +++----
 arch/cris/arch-v32/kernel/debugport.c          |    2 -
 arch/cris/arch-v32/kernel/entry.S              |    4 +--
 arch/cris/arch-v32/kernel/head.S               |    4 +--
 arch/cris/arch-v32/kernel/kgdb.c               |    8 +++----
 arch/cris/arch-v32/kernel/kgdb_asm.S           |    2 -
 arch/cris/arch-v32/kernel/pinmux.c             |    8 +++----
 arch/cris/arch-v32/kernel/ptrace.c             |    2 -
 arch/cris/arch-v32/kernel/signal.c             |    4 +--
 arch/cris/arch-v32/lib/nand_init.S             |   10 ++++-----
 arch/cris/arch-v32/mach-a3/dma.c               |    2 -
 arch/cris/arch-v32/mach-a3/io.c                |    2 -
 arch/cris/arch-v32/mach-fs/cpufreq.c           |    6 ++---
 arch/cris/arch-v32/mach-fs/dma.c               |    2 -
 arch/cris/arch-v32/mach-fs/io.c                |    4 +--
 arch/cris/arch-v32/mach-fs/vcs_hook.c          |    4 +--
 arch/cris/arch-v32/mm/init.c                   |    4 +--
 arch/cris/arch-v32/mm/tlb.c                    |    4 +--
 arch/cris/include/arch-v10/arch/io.h           |    2 -
 arch/cris/include/arch-v10/arch/irq.h          |    2 -
 arch/cris/include/arch-v32/arch/cache.h        |    2 -
 arch/cris/include/arch-v32/arch/cryptocop.h    |    2 -
 arch/cris/include/arch-v32/arch/io.h           |    4 +--
 arch/cris/include/asm/atomic.h                 |    2 -
 arch/cris/include/asm/bitops.h                 |    2 -
 arch/cris/include/asm/bug.h                    |    2 -
 arch/cris/include/asm/byteorder.h              |    2 -
 arch/cris/include/asm/cache.h                  |    2 -
 arch/cris/include/asm/checksum.h               |    2 -
 arch/cris/include/asm/delay.h                  |    2 -
 arch/cris/include/asm/dma.h                    |    2 -
 arch/cris/include/asm/elf.h                    |    2 -
 arch/cris/include/asm/io.h                     |    2 -
 arch/cris/include/asm/irq.h                    |    2 -
 arch/cris/include/asm/mmu.h                    |    2 -
 arch/cris/include/asm/page.h                   |    2 -
 arch/cris/include/asm/pgtable.h                |    2 -
 arch/cris/include/asm/processor.h              |    2 -
 arch/cris/include/asm/ptrace.h                 |    2 -
 arch/cris/include/asm/spinlock.h               |    2 -
 arch/cris/include/asm/system.h                 |    2 -
 arch/cris/include/asm/thread_info.h            |    2 -
 arch/cris/include/asm/timex.h                  |    2 -
 arch/cris/include/asm/tlb.h                    |    2 -
 arch/cris/include/asm/uaccess.h                |    2 -
 arch/cris/include/asm/unistd.h                 |    2 -
 arch/cris/include/asm/user.h                   |    2 -
 arch/cris/mm/ioremap.c                         |    2 -
 drivers/net/cris/eth_v10.c                     |    4 +--
 drivers/serial/crisv10.c                       |    4 +--
 drivers/serial/crisv10.h                       |    2 -
 82 files changed, 122 insertions(+), 130 deletions(-)

diff --git a/arch/cris/Makefile b/arch/cris/Makefile
index c6f5f5a..24881fa 100644
--- a/arch/cris/Makefile
+++ b/arch/cris/Makefile
@@ -23,12 +23,16 @@ mach-$(CONFIG_ETRAXFS) := fs
 
 ifneq ($(arch-y),)
 SARCH := arch-$(arch-y)
+inc := -Iarch/cris/include/arch-$(arch-y) -Iarch/cris/include/arch-$(arch-y)/arch
 else
 SARCH :=
+inc :=
 endif
 
 ifneq ($(mach-y),)
 MACH := mach-$(mach-y)
+inc += -Iarch/cris/$(MACH)/include
+inc += -Iarch/cris/$(MACH)/include/mach
 else
 MACH :=
 endif
@@ -39,9 +43,9 @@ OBJCOPYFLAGS := -O binary -R .note -R .comment -S
 
 CPPFLAGS_vmlinux.lds = -DDRAM_VIRTUAL_BASE=0x$(CONFIG_ETRAX_DRAM_VIRTUAL_BASE)
 
-KBUILD_AFLAGS += -mlinux -march=$(arch-y) -Iinclude/asm/arch/mach -Iinclude/asm/arch
-
-KBUILD_CFLAGS += -mlinux -march=$(arch-y) -pipe -Iinclude/asm/arch/mach -Iinclude/asm/arch
+KBUILD_AFLAGS += -mlinux -march=$(arch-y) $(inc)
+KBUILD_CFLAGS += -mlinux -march=$(arch-y) -pipe $(inc)
+KBUILD_CPPFLAGS += $(inc)
 
 ifdef CONFIG_FRAME_POINTER
 KBUILD_CFLAGS := $(subst -fomit-frame-pointer,,$(KBUILD_CFLAGS)) -g
@@ -73,7 +77,7 @@ all: zImage
 zImage Image: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
 
-archprepare: $(SRC_ARCH)/.links $(srctree)/include/asm-$(ARCH)/.arch FORCE
+archprepare: $(SRC_ARCH)/.links FORCE
 
 # Create some links to make all tools happy
 $(SRC_ARCH)/.links:
@@ -95,17 +99,6 @@ endif
 	@ln -sfn ../$(SARCH)/kernel/asm-offsets.c $(SRC_ARCH)/kernel/asm-offsets.c
 	@touch $@
 
-# Create link to sub arch includes
-$(srctree)/include/asm-$(ARCH)/.arch: $(wildcard include/config/arch/*.h)
-	@echo '  SYMLINK include/asm-$(ARCH)/arch -> include/asm-$(ARCH)/$(SARCH)'
-	@rm -f $(srctree)/include/asm-$(ARCH)/arch/mach
-	@rm -f $(srctree)/include/asm-$(ARCH)/arch
-	@ln -sf $(SARCH) $(srctree)/include/asm-$(ARCH)/arch
-ifdef CONFIG_ETRAX_ARCH_V32
-	@ln -sf $(MACH) $(srctree)/include/asm-$(ARCH)/arch/mach
-endif
-	@touch $@
-
 archclean:
 	$(Q)if [ -e arch/$(ARCH)/boot ]; then \
 		$(MAKE) $(clean)=arch/$(ARCH)/boot; \
@@ -116,8 +109,7 @@ CLEAN_FILES += \
 	$(MACHINE)/boot/compressed/decompress.bin \
 	$(MACHINE)/boot/compressed/piggy.gz \
 	$(MACHINE)/boot/rescue/rescue.bin \
-	$(SRC_ARCH)/.links \
-	$(srctree)/include/asm-$(ARCH)/.arch
+	$(SRC_ARCH)/.links
 
 MRPROPER_FILES += \
 	$(SRC_ARCH)/drivers \
diff --git a/arch/cris/arch-v10/boot/compressed/head.S b/arch/cris/arch-v10/boot/compressed/head.S
index 981fbae..0bb4dcc 100644
--- a/arch/cris/arch-v10/boot/compressed/head.S
+++ b/arch/cris/arch-v10/boot/compressed/head.S
@@ -9,7 +9,7 @@
  */
 
 #define ASSEMBLER_MACROS_ONLY
-#include <asm/arch/sv_addr_ag.h>
+#include <arch/sv_addr_ag.h>
 
 #define RAM_INIT_MAGIC 0x56902387
 #define COMMAND_LINE_MAGIC 0x87109563
diff --git a/arch/cris/arch-v10/boot/compressed/misc.c b/arch/cris/arch-v10/boot/compressed/misc.c
index d933c89..a4db150 100644
--- a/arch/cris/arch-v10/boot/compressed/misc.c
+++ b/arch/cris/arch-v10/boot/compressed/misc.c
@@ -20,7 +20,7 @@
 
 
 #include <linux/types.h>
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 
 /*
  * gzip declarations
diff --git a/arch/cris/arch-v10/boot/rescue/head.S b/arch/cris/arch-v10/boot/rescue/head.S
index 6ba7be8..fb503d1 100644
--- a/arch/cris/arch-v10/boot/rescue/head.S
+++ b/arch/cris/arch-v10/boot/rescue/head.S
@@ -65,7 +65,7 @@
 #ifdef CONFIG_ETRAX_AXISFLASHMAP
 
 #define ASSEMBLER_MACROS_ONLY
-#include <asm/arch/sv_addr_ag.h>
+#include <arch/sv_addr_ag.h>
 
 	;; The partitiontable is looked for at the first sector after the boot
 	;; sector. Sector size is 65536 bytes in all flashes we use.
diff --git a/arch/cris/arch-v10/boot/rescue/kimagerescue.S b/arch/cris/arch-v10/boot/rescue/kimagerescue.S
index 55eeff8..6f7b3e6 100644
--- a/arch/cris/arch-v10/boot/rescue/kimagerescue.S
+++ b/arch/cris/arch-v10/boot/rescue/kimagerescue.S
@@ -6,7 +6,7 @@
  */
 
 #define ASSEMBLER_MACROS_ONLY
-#include <asm/arch/sv_addr_ag.h>
+#include <arch/sv_addr_ag.h>
 
 #define CODE_START 0x40004000
 #define CODE_LENGTH 784
diff --git a/arch/cris/arch-v10/boot/rescue/testrescue.S b/arch/cris/arch-v10/boot/rescue/testrescue.S
index 2d937f9..fc7ec67 100644
--- a/arch/cris/arch-v10/boot/rescue/testrescue.S
+++ b/arch/cris/arch-v10/boot/rescue/testrescue.S
@@ -6,7 +6,7 @@
  */
 
 #define ASSEMBLER_MACROS_ONLY
-#include <asm/arch/sv_addr_ag.h>
+#include <arch/sv_addr_ag.h>
 
 	.text
 
diff --git a/arch/cris/arch-v10/drivers/axisflashmap.c b/arch/cris/arch-v10/drivers/axisflashmap.c
index b3bdda9..b207970 100644
--- a/arch/cris/arch-v10/drivers/axisflashmap.c
+++ b/arch/cris/arch-v10/drivers/axisflashmap.c
@@ -26,7 +26,7 @@
 
 #include <asm/axisflashmap.h>
 #include <asm/mmu.h>
-#include <asm/arch/sv_addr_ag.h>
+#include <arch/sv_addr_ag.h>
 
 #ifdef CONFIG_CRIS_LOW_MAP
 #define FLASH_UNCACHED_ADDR  KSEG_8
diff --git a/arch/cris/arch-v10/drivers/ds1302.c b/arch/cris/arch-v10/drivers/ds1302.c
index c9aa390..126e169 100644
--- a/arch/cris/arch-v10/drivers/ds1302.c
+++ b/arch/cris/arch-v10/drivers/ds1302.c
@@ -24,10 +24,10 @@
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 #include <asm/io.h>
 #include <asm/rtc.h>
-#include <asm/arch/io_interface_mux.h>
+#include <arch/io_interface_mux.h>
 
 #include "i2c.h"
 
diff --git a/arch/cris/arch-v10/drivers/gpio.c b/arch/cris/arch-v10/drivers/gpio.c
index 86048e6..4b0f65f 100644
--- a/arch/cris/arch-v10/drivers/gpio.c
+++ b/arch/cris/arch-v10/drivers/gpio.c
@@ -23,11 +23,11 @@
 #include <linux/interrupt.h>
 
 #include <asm/etraxgpio.h>
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 #include <asm/io.h>
 #include <asm/system.h>
 #include <asm/irq.h>
-#include <asm/arch/io_interface_mux.h>
+#include <arch/io_interface_mux.h>
 
 #define GPIO_MAJOR 120  /* experimental MAJOR number */
 
diff --git a/arch/cris/arch-v10/drivers/i2c.c b/arch/cris/arch-v10/drivers/i2c.c
index 2797e67..7f656ae 100644
--- a/arch/cris/arch-v10/drivers/i2c.c
+++ b/arch/cris/arch-v10/drivers/i2c.c
@@ -25,10 +25,10 @@
 #include <asm/etraxi2c.h>
 
 #include <asm/system.h>
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 #include <asm/io.h>
 #include <asm/delay.h>
-#include <asm/arch/io_interface_mux.h>
+#include <arch/io_interface_mux.h>
 
 #include "i2c.h"
 
diff --git a/arch/cris/arch-v10/drivers/sync_serial.c b/arch/cris/arch-v10/drivers/sync_serial.c
index 91fea62..6cc1a03 100644
--- a/arch/cris/arch-v10/drivers/sync_serial.c
+++ b/arch/cris/arch-v10/drivers/sync_serial.c
@@ -26,11 +26,11 @@
 #include <asm/irq.h>
 #include <asm/dma.h>
 #include <asm/io.h>
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
 #include <asm/sync_serial.h>
-#include <asm/arch/io_interface_mux.h>
+#include <arch/io_interface_mux.h>
 
 /* The receiver is a bit tricky beacuse of the continuous stream of data.*/
 /*                                                                       */
diff --git a/arch/cris/arch-v10/kernel/crisksyms.c b/arch/cris/arch-v10/kernel/crisksyms.c
index e6b8013..1ca6fc2 100644
--- a/arch/cris/arch-v10/kernel/crisksyms.c
+++ b/arch/cris/arch-v10/kernel/crisksyms.c
@@ -1,6 +1,6 @@
 #include <linux/module.h>
 #include <asm/io.h>
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 
 /* Export shadow registers for the CPU I/O pins */
 EXPORT_SYMBOL(genconfig_shadow);
diff --git a/arch/cris/arch-v10/kernel/debugport.c b/arch/cris/arch-v10/kernel/debugport.c
index 3dc6e91..99851ba 100644
--- a/arch/cris/arch-v10/kernel/debugport.c
+++ b/arch/cris/arch-v10/kernel/debugport.c
@@ -19,7 +19,7 @@
 #include <linux/delay.h>
 #include <linux/tty.h>
 #include <asm/system.h>
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 #include <asm/io.h>             /* Get SIMCOUT. */
 
 extern void reset_watchdog(void);
diff --git a/arch/cris/arch-v10/kernel/dma.c b/arch/cris/arch-v10/kernel/dma.c
index eb1fa0d..929e686 100644
--- a/arch/cris/arch-v10/kernel/dma.c
+++ b/arch/cris/arch-v10/kernel/dma.c
@@ -7,7 +7,7 @@
 #include <linux/errno.h>
 
 #include <asm/dma.h>
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 
 /* Macro to access ETRAX 100 registers */
 #define SETS(var, reg, field, val) var = (var & ~IO_MASK_(reg##_, field##_)) | \
diff --git a/arch/cris/arch-v10/kernel/entry.S b/arch/cris/arch-v10/kernel/entry.S
index 3a65f32..ed171d3 100644
--- a/arch/cris/arch-v10/kernel/entry.S
+++ b/arch/cris/arch-v10/kernel/entry.S
@@ -23,7 +23,7 @@
 #include <linux/linkage.h>
 #include <linux/sys.h>
 #include <asm/unistd.h>
-#include <asm/arch/sv_addr_ag.h>
+#include <arch/sv_addr_ag.h>
 #include <asm/errno.h>
 #include <asm/thread_info.h>
 #include <asm/asm-offsets.h>
diff --git a/arch/cris/arch-v10/kernel/fasttimer.c b/arch/cris/arch-v10/kernel/fasttimer.c
index 31ff35c..5ff08a8 100644
--- a/arch/cris/arch-v10/kernel/fasttimer.c
+++ b/arch/cris/arch-v10/kernel/fasttimer.c
@@ -24,7 +24,7 @@
 #include <asm/rtc.h>
 
 
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 #include <asm/fasttimer.h>
 #include <linux/proc_fs.h>
 
diff --git a/arch/cris/arch-v10/kernel/head.S b/arch/cris/arch-v10/kernel/head.S
index 96344af..fc45771 100644
--- a/arch/cris/arch-v10/kernel/head.S
+++ b/arch/cris/arch-v10/kernel/head.S
@@ -10,7 +10,7 @@
 #define ASSEMBLER_MACROS_ONLY
 /* The IO_* macros use the ## token concatenation operator, so
    -traditional must not be used when assembling this file.  */
-#include <asm/arch/sv_addr_ag.h>
+#include <arch/sv_addr_ag.h>
 
 #define CRAMFS_MAGIC 0x28cd3d45
 #define RAM_INIT_MAGIC 0x56902387
diff --git a/arch/cris/arch-v10/kernel/io_interface_mux.c b/arch/cris/arch-v10/kernel/io_interface_mux.c
index add98e0..29f97e9 100644
--- a/arch/cris/arch-v10/kernel/io_interface_mux.c
+++ b/arch/cris/arch-v10/kernel/io_interface_mux.c
@@ -11,9 +11,9 @@
 #include <linux/module.h>
 #include <linux/init.h>
 
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 #include <asm/io.h>
-#include <asm/arch/io_interface_mux.h>
+#include <arch/io_interface_mux.h>
 
 
 #define DBG(s)
diff --git a/arch/cris/arch-v10/kernel/kgdb.c b/arch/cris/arch-v10/kernel/kgdb.c
index 6fea45f..b9f9c8c 100644
--- a/arch/cris/arch-v10/kernel/kgdb.c
+++ b/arch/cris/arch-v10/kernel/kgdb.c
@@ -176,7 +176,7 @@
 #include <asm/setup.h>
 #include <asm/ptrace.h>
 
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 #include <asm/irq.h>
 
 static int kgdb_started = 0;
diff --git a/arch/cris/arch-v10/kernel/process.c b/arch/cris/arch-v10/kernel/process.c
index 53117f0..bd9b3ff 100644
--- a/arch/cris/arch-v10/kernel/process.c
+++ b/arch/cris/arch-v10/kernel/process.c
@@ -14,7 +14,7 @@
 #include <linux/err.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 #include <linux/init.h>
 
 #ifdef CONFIG_ETRAX_GPIO
diff --git a/arch/cris/arch-v10/kernel/time.c b/arch/cris/arch-v10/kernel/time.c
index 525483f..c685ba4 100644
--- a/arch/cris/arch-v10/kernel/time.c
+++ b/arch/cris/arch-v10/kernel/time.c
@@ -14,7 +14,7 @@
 #include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/mm.h>
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 #include <asm/types.h>
 #include <asm/signal.h>
 #include <asm/io.h>
diff --git a/arch/cris/arch-v10/kernel/traps.c b/arch/cris/arch-v10/kernel/traps.c
index 9eada5d..8bebb96 100644
--- a/arch/cris/arch-v10/kernel/traps.c
+++ b/arch/cris/arch-v10/kernel/traps.c
@@ -10,7 +10,7 @@
 
 #include <linux/ptrace.h>
 #include <asm/uaccess.h>
-#include <asm/arch/sv_addr_ag.h>
+#include <arch/sv_addr_ag.h>
 
 void
 show_registers(struct pt_regs *regs)
diff --git a/arch/cris/arch-v10/mm/fault.c b/arch/cris/arch-v10/mm/fault.c
index 65504fd..087a209 100644
--- a/arch/cris/arch-v10/mm/fault.c
+++ b/arch/cris/arch-v10/mm/fault.c
@@ -13,7 +13,7 @@
 #include <linux/mm.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 #include <asm/mmu_context.h>
 
 /* debug of low-level TLB reload */
diff --git a/arch/cris/arch-v10/mm/init.c b/arch/cris/arch-v10/mm/init.c
index 742fd19..baa746c 100644
--- a/arch/cris/arch-v10/mm/init.c
+++ b/arch/cris/arch-v10/mm/init.c
@@ -12,7 +12,7 @@
 #include <asm/mmu.h>
 #include <asm/io.h>
 #include <asm/mmu_context.h>
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 
 extern void tlb_init(void);
 
diff --git a/arch/cris/arch-v10/mm/tlb.c b/arch/cris/arch-v10/mm/tlb.c
index 6baf5bd..4a496e4 100644
--- a/arch/cris/arch-v10/mm/tlb.c
+++ b/arch/cris/arch-v10/mm/tlb.c
@@ -12,7 +12,7 @@
 
 #include <asm/tlb.h>
 #include <asm/mmu_context.h>
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 
 #define D(x)
 
diff --git a/arch/cris/arch-v32/boot/compressed/head.S b/arch/cris/arch-v32/boot/compressed/head.S
index f86208c..ea30129 100644
--- a/arch/cris/arch-v32/boot/compressed/head.S
+++ b/arch/cris/arch-v32/boot/compressed/head.S
@@ -7,7 +7,7 @@
 
 #define ASSEMBLER_MACROS_ONLY
 #include <hwregs/asm/reg_map_asm.h>
-#include <asm/arch/mach/startup.inc>
+#include <mach/startup.inc>
 
 #define RAM_INIT_MAGIC 0x56902387
 #define COMMAND_LINE_MAGIC 0x87109563
@@ -17,7 +17,7 @@
 	.globl	input_data
 
 	.text
-start:
+_start:
 	di
 
 	;; Start clocks for used blocks.
diff --git a/arch/cris/arch-v32/drivers/mach-a3/gpio.c b/arch/cris/arch-v32/drivers/mach-a3/gpio.c
index ef98608..7a87bc0 100644
--- a/arch/cris/arch-v32/drivers/mach-a3/gpio.c
+++ b/arch/cris/arch-v32/drivers/mach-a3/gpio.c
@@ -33,7 +33,7 @@
 #include <asm/io.h>
 #include <asm/system.h>
 #include <asm/irq.h>
-#include <asm/arch/mach/pinmux.h>
+#include <mach/pinmux.h>
 
 #ifdef CONFIG_ETRAX_VIRTUAL_GPIO
 #include "../i2c.h"
diff --git a/arch/cris/arch-v32/drivers/mach-a3/nandflash.c b/arch/cris/arch-v32/drivers/mach-a3/nandflash.c
index 01ed0be..25d6f2b 100644
--- a/arch/cris/arch-v32/drivers/mach-a3/nandflash.c
+++ b/arch/cris/arch-v32/drivers/mach-a3/nandflash.c
@@ -18,7 +18,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
-#include <asm/arch/memmap.h>
+#include <arch/memmap.h>
 #include <hwregs/reg_map.h>
 #include <hwregs/reg_rdwr.h>
 #include <hwregs/pio_defs.h>
diff --git a/arch/cris/arch-v32/drivers/mach-fs/nandflash.c b/arch/cris/arch-v32/drivers/mach-fs/nandflash.c
index aa01b13..c5a0f54 100644
--- a/arch/cris/arch-v32/drivers/mach-fs/nandflash.c
+++ b/arch/cris/arch-v32/drivers/mach-fs/nandflash.c
@@ -18,7 +18,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
-#include <asm/arch/memmap.h>
+#include <arch/memmap.h>
 #include <hwregs/reg_map.h>
 #include <hwregs/reg_rdwr.h>
 #include <hwregs/gio_defs.h>
diff --git a/arch/cris/arch-v32/drivers/pci/bios.c b/arch/cris/arch-v32/drivers/pci/bios.c
index 5b79a7a..77ee319 100644
--- a/arch/cris/arch-v32/drivers/pci/bios.c
+++ b/arch/cris/arch-v32/drivers/pci/bios.c
@@ -1,6 +1,6 @@
 #include <linux/pci.h>
 #include <linux/kernel.h>
-#include <asm/arch/hwregs/intr_vect.h>
+#include <arch/hwregs/intr_vect.h>
 
 void __devinit  pcibios_fixup_bus(struct pci_bus *b)
 {
diff --git a/arch/cris/arch-v32/kernel/cache.c b/arch/cris/arch-v32/kernel/cache.c
index 80da7b8..f38433b 100644
--- a/arch/cris/arch-v32/kernel/cache.c
+++ b/arch/cris/arch-v32/kernel/cache.c
@@ -1,7 +1,7 @@
 #include <linux/module.h>
 #include <asm/io.h>
-#include <asm/arch/cache.h>
-#include <asm/arch/hwregs/dma.h>
+#include <arch/cache.h>
+#include <arch/hwregs/dma.h>
 
 /* This file is used to workaround a cache bug, Guinness TR 106. */
 
diff --git a/arch/cris/arch-v32/kernel/crisksyms.c b/arch/cris/arch-v32/kernel/crisksyms.c
index 77d02c1..64933e2 100644
--- a/arch/cris/arch-v32/kernel/crisksyms.c
+++ b/arch/cris/arch-v32/kernel/crisksyms.c
@@ -1,9 +1,9 @@
 #include <linux/module.h>
 #include <linux/irq.h>
-#include <asm/arch/dma.h>
-#include <asm/arch/intmem.h>
-#include <asm/arch/mach/pinmux.h>
-#include <asm/arch/io.h>
+#include <arch/dma.h>
+#include <arch/intmem.h>
+#include <mach/pinmux.h>
+#include <arch/io.h>
 
 /* Functions for allocating DMA channels */
 EXPORT_SYMBOL(crisv32_request_dma);
diff --git a/arch/cris/arch-v32/kernel/debugport.c b/arch/cris/arch-v32/kernel/debugport.c
index 15af4c2..794b364 100644
--- a/arch/cris/arch-v32/kernel/debugport.c
+++ b/arch/cris/arch-v32/kernel/debugport.c
@@ -9,7 +9,7 @@
 #include <hwregs/reg_map.h>
 #include <hwregs/ser_defs.h>
 #include <hwregs/dma_defs.h>
-#include <asm/arch/mach/pinmux.h>
+#include <mach/pinmux.h>
 
 struct dbg_port
 {
diff --git a/arch/cris/arch-v32/kernel/entry.S b/arch/cris/arch-v32/kernel/entry.S
index eebbaba..7f6f93e 100644
--- a/arch/cris/arch-v32/kernel/entry.S
+++ b/arch/cris/arch-v32/kernel/entry.S
@@ -24,8 +24,8 @@
 #include <asm/thread_info.h>
 #include <asm/asm-offsets.h>
 
-#include <asm/arch/hwregs/asm/reg_map_asm.h>
-#include <asm/arch/hwregs/asm/intr_vect_defs_asm.h>
+#include <hwregs/asm/reg_map_asm.h>
+#include <hwregs/asm/intr_vect_defs_asm.h>
 
 	;; Exported functions.
 	.globl system_call
diff --git a/arch/cris/arch-v32/kernel/head.S b/arch/cris/arch-v32/kernel/head.S
index 2d66a7c..f902d87 100644
--- a/arch/cris/arch-v32/kernel/head.S
+++ b/arch/cris/arch-v32/kernel/head.S
@@ -11,11 +11,11 @@
  * -traditional must not be used when assembling this file.
  */
 #include <hwregs/reg_rdwr.h>
-#include <asm/arch/memmap.h>
+#include <arch/memmap.h>
 #include <hwregs/intr_vect.h>
 #include <hwregs/asm/mmu_defs_asm.h>
 #include <hwregs/asm/reg_map_asm.h>
-#include <asm/arch/mach/startup.inc>
+#include <mach/startup.inc>
 
 #define CRAMFS_MAGIC 0x28cd3d45
 #define JHEAD_MAGIC 0x1FF528A6
diff --git a/arch/cris/arch-v32/kernel/kgdb.c b/arch/cris/arch-v32/kernel/kgdb.c
index 8bd5a5b..c981fd6 100644
--- a/arch/cris/arch-v32/kernel/kgdb.c
+++ b/arch/cris/arch-v32/kernel/kgdb.c
@@ -174,10 +174,10 @@
 #include <asm/ptrace.h>
 
 #include <asm/irq.h>
-#include <asm/arch/hwregs/reg_map.h>
-#include <asm/arch/hwregs/reg_rdwr.h>
-#include <asm/arch/hwregs/intr_vect_defs.h>
-#include <asm/arch/hwregs/ser_defs.h>
+#include <arch/hwregs/reg_map.h>
+#include <arch/hwregs/reg_rdwr.h>
+#include <arch/hwregs/intr_vect_defs.h>
+#include <arch/hwregs/ser_defs.h>
 
 /* From entry.S. */
 extern void gdb_handle_exception(void);
diff --git a/arch/cris/arch-v32/kernel/kgdb_asm.S b/arch/cris/arch-v32/kernel/kgdb_asm.S
index 3e7fa9e..eba93e7 100644
--- a/arch/cris/arch-v32/kernel/kgdb_asm.S
+++ b/arch/cris/arch-v32/kernel/kgdb_asm.S
@@ -5,7 +5,7 @@
  * port exceptions for kernel debugging purposes.
  */
 
-#include <asm/arch/hwregs/intr_vect.h>
+#include <arch/hwregs/intr_vect.h>
 
 	;; Exported functions.
 	.globl kgdb_handle_exception
diff --git a/arch/cris/arch-v32/kernel/pinmux.c b/arch/cris/arch-v32/kernel/pinmux.c
index a2b8aa3..6eb54ea 100644
--- a/arch/cris/arch-v32/kernel/pinmux.c
+++ b/arch/cris/arch-v32/kernel/pinmux.c
@@ -11,10 +11,10 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/spinlock.h>
-#include <asm/arch/hwregs/reg_map.h>
-#include <asm/arch/hwregs/reg_rdwr.h>
-#include <asm/arch/pinmux.h>
-#include <asm/arch/hwregs/pinmux_defs.h>
+#include <arch/hwregs/reg_map.h>
+#include <arch/hwregs/reg_rdwr.h>
+#include <arch/pinmux.h>
+#include <arch/hwregs/pinmux_defs.h>
 
 #undef DEBUG
 
diff --git a/arch/cris/arch-v32/kernel/ptrace.c b/arch/cris/arch-v32/kernel/ptrace.c
index e27f467..dd40147 100644
--- a/arch/cris/arch-v32/kernel/ptrace.c
+++ b/arch/cris/arch-v32/kernel/ptrace.c
@@ -17,7 +17,7 @@
 #include <asm/pgtable.h>
 #include <asm/system.h>
 #include <asm/processor.h>
-#include <asm/arch/hwregs/supp_reg.h>
+#include <arch/hwregs/supp_reg.h>
 
 /*
  * Determines which bits in CCS the user has access to.
diff --git a/arch/cris/arch-v32/kernel/signal.c b/arch/cris/arch-v32/kernel/signal.c
index 58c1866..da7d2be 100644
--- a/arch/cris/arch-v32/kernel/signal.c
+++ b/arch/cris/arch-v32/kernel/signal.c
@@ -18,8 +18,8 @@
 #include <asm/processor.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
-#include <asm/arch/ptrace.h>
-#include <asm/arch/hwregs/cpu_vect.h>
+#include <arch/ptrace.h>
+#include <arch/hwregs/cpu_vect.h>
 
 extern unsigned long cris_signal_return_page;
 
diff --git a/arch/cris/arch-v32/lib/nand_init.S b/arch/cris/arch-v32/lib/nand_init.S
index e019816..e705f5c 100644
--- a/arch/cris/arch-v32/lib/nand_init.S
+++ b/arch/cris/arch-v32/lib/nand_init.S
@@ -22,11 +22,11 @@
 ##
 ##=============================================================================
 
-#include <asm/arch/hwregs/asm/reg_map_asm.h>
-#include <asm/arch/hwregs/asm/gio_defs_asm.h>
-#include <asm/arch/hwregs/asm/pinmux_defs_asm.h>
-#include <asm/arch/hwregs/asm/bif_core_defs_asm.h>
-#include <asm/arch/hwregs/asm/config_defs_asm.h>
+#include <arch/hwregs/asm/reg_map_asm.h>
+#include <arch/hwregs/asm/gio_defs_asm.h>
+#include <arch/hwregs/asm/pinmux_defs_asm.h>
+#include <arch/hwregs/asm/bif_core_defs_asm.h>
+#include <arch/hwregs/asm/config_defs_asm.h>
 
 ;; There are 8-bit NAND flashes and 16-bit NAND flashes.
 ;; We need to treat them slightly different.
diff --git a/arch/cris/arch-v32/mach-a3/dma.c b/arch/cris/arch-v32/mach-a3/dma.c
index 25f236e..f35e4f6 100644
--- a/arch/cris/arch-v32/mach-a3/dma.c
+++ b/arch/cris/arch-v32/mach-a3/dma.c
@@ -2,7 +2,7 @@
 
 #include <linux/kernel.h>
 #include <linux/spinlock.h>
-#include <asm/arch/mach/dma.h>
+#include <mach/dma.h>
 #include <hwregs/reg_map.h>
 #include <hwregs/reg_rdwr.h>
 #include <hwregs/marb_defs.h>
diff --git a/arch/cris/arch-v32/mach-a3/io.c b/arch/cris/arch-v32/mach-a3/io.c
index 9eeaf3e..c22f67e 100644
--- a/arch/cris/arch-v32/mach-a3/io.c
+++ b/arch/cris/arch-v32/mach-a3/io.c
@@ -12,7 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <asm/io.h>
-#include <asm/arch/mach/pinmux.h>
+#include <mach/pinmux.h>
 #include <hwregs/gio_defs.h>
 
 struct crisv32_ioport crisv32_ioports[] = {
diff --git a/arch/cris/arch-v32/mach-fs/cpufreq.c b/arch/cris/arch-v32/mach-fs/cpufreq.c
index 58bd71e..d92cf70 100644
--- a/arch/cris/arch-v32/mach-fs/cpufreq.c
+++ b/arch/cris/arch-v32/mach-fs/cpufreq.c
@@ -2,9 +2,9 @@
 #include <linux/module.h>
 #include <linux/cpufreq.h>
 #include <hwregs/reg_map.h>
-#include <asm/arch/hwregs/reg_rdwr.h>
-#include <asm/arch/hwregs/config_defs.h>
-#include <asm/arch/hwregs/bif_core_defs.h>
+#include <arch/hwregs/reg_rdwr.h>
+#include <arch/hwregs/config_defs.h>
+#include <arch/hwregs/bif_core_defs.h>
 
 static int
 cris_sdram_freq_notifier(struct notifier_block *nb, unsigned long val,
diff --git a/arch/cris/arch-v32/mach-fs/dma.c b/arch/cris/arch-v32/mach-fs/dma.c
index a6acf4e..2d970d7 100644
--- a/arch/cris/arch-v32/mach-fs/dma.c
+++ b/arch/cris/arch-v32/mach-fs/dma.c
@@ -10,7 +10,7 @@
 #include <hwregs/strmux_defs.h>
 #include <linux/errno.h>
 #include <asm/system.h>
-#include <asm/arch/mach/arbiter.h>
+#include <mach/arbiter.h>
 
 static char used_dma_channels[MAX_DMA_CHANNELS];
 static const char *used_dma_channels_users[MAX_DMA_CHANNELS];
diff --git a/arch/cris/arch-v32/mach-fs/io.c b/arch/cris/arch-v32/mach-fs/io.c
index a03a3ad..cb6327b 100644
--- a/arch/cris/arch-v32/mach-fs/io.c
+++ b/arch/cris/arch-v32/mach-fs/io.c
@@ -12,8 +12,8 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <asm/io.h>
-#include <asm/arch/pinmux.h>
-#include <asm/arch/hwregs/gio_defs.h>
+#include <mach/pinmux.h>
+#include <hwregs/gio_defs.h>
 
 #ifndef DEBUG
 #define DEBUG(x)
diff --git a/arch/cris/arch-v32/mach-fs/vcs_hook.c b/arch/cris/arch-v32/mach-fs/vcs_hook.c
index 593b10f..b11594a 100644
--- a/arch/cris/arch-v32/mach-fs/vcs_hook.c
+++ b/arch/cris/arch-v32/mach-fs/vcs_hook.c
@@ -5,8 +5,8 @@
 
 #include "vcs_hook.h"
 #include <stdarg.h>
-#include <asm/arch-v32/hwregs/reg_map.h>
-#include <asm/arch-v32/hwregs/intr_vect_defs.h>
+#include <arch-v32/hwregs/reg_map.h>
+#include <arch-v32/hwregs/intr_vect_defs.h>
 
 #define HOOK_TRIG_ADDR     0xb7000000	/* hook cvlog model reg address */
 #define HOOK_MEM_BASE_ADDR 0xa0000000	/* csp4 (shared mem) base addr */
diff --git a/arch/cris/arch-v32/mm/init.c b/arch/cris/arch-v32/mm/init.c
index 8a34b8b..caeb921 100644
--- a/arch/cris/arch-v32/mm/init.c
+++ b/arch/cris/arch-v32/mm/init.c
@@ -16,8 +16,8 @@
 #include <asm/mmu.h>
 #include <asm/io.h>
 #include <asm/mmu_context.h>
-#include <asm/arch/hwregs/asm/mmu_defs_asm.h>
-#include <asm/arch/hwregs/supp_reg.h>
+#include <arch/hwregs/asm/mmu_defs_asm.h>
+#include <arch/hwregs/supp_reg.h>
 
 extern void tlb_init(void);
 
diff --git a/arch/cris/arch-v32/mm/tlb.c b/arch/cris/arch-v32/mm/tlb.c
index eda5ebc..55ade36 100644
--- a/arch/cris/arch-v32/mm/tlb.c
+++ b/arch/cris/arch-v32/mm/tlb.c
@@ -9,8 +9,8 @@
 
 #include <asm/tlb.h>
 #include <asm/mmu_context.h>
-#include <asm/arch/hwregs/asm/mmu_defs_asm.h>
-#include <asm/arch/hwregs/supp_reg.h>
+#include <arch/hwregs/asm/mmu_defs_asm.h>
+#include <arch/hwregs/supp_reg.h>
 
 #define UPDATE_TLB_SEL_IDX(val)					\
 do {								\
diff --git a/arch/cris/include/arch-v10/arch/io.h b/arch/cris/include/arch-v10/arch/io.h
index c08c242..f627ad0 100644
--- a/arch/cris/include/arch-v10/arch/io.h
+++ b/arch/cris/include/arch-v10/arch/io.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_ARCH_CRIS_IO_H
 #define _ASM_ARCH_CRIS_IO_H
 
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 
 /* Etrax shadow registers - which live in arch/cris/kernel/shadows.c */
 
diff --git a/arch/cris/include/arch-v10/arch/irq.h b/arch/cris/include/arch-v10/arch/irq.h
index b1128a9..6248004 100644
--- a/arch/cris/include/arch-v10/arch/irq.h
+++ b/arch/cris/include/arch-v10/arch/irq.h
@@ -5,7 +5,7 @@
 #ifndef _ASM_ARCH_IRQ_H
 #define _ASM_ARCH_IRQ_H
 
-#include <asm/arch/sv_addr_ag.h>
+#include <arch/sv_addr_ag.h>
 
 #define NR_IRQS 32
 
diff --git a/arch/cris/include/arch-v32/arch/cache.h b/arch/cris/include/arch-v32/arch/cache.h
index b3d752d..dfc7305 100644
--- a/arch/cris/include/arch-v32/arch/cache.h
+++ b/arch/cris/include/arch-v32/arch/cache.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_CRIS_ARCH_CACHE_H
 #define _ASM_CRIS_ARCH_CACHE_H
 
-#include <asm/arch/hwregs/dma.h>
+#include <arch/hwregs/dma.h>
 
 /* A cache-line is 32 bytes. */
 #define L1_CACHE_BYTES 32
diff --git a/arch/cris/include/arch-v32/arch/cryptocop.h b/arch/cris/include/arch-v32/arch/cryptocop.h
index dfa1f66..e1cd83d 100644
--- a/arch/cris/include/arch-v32/arch/cryptocop.h
+++ b/arch/cris/include/arch-v32/arch/cryptocop.h
@@ -122,7 +122,7 @@ struct strcop_crypto_op{
 
 /********** The API to use from inside the kernel. ************/
 
-#include <asm/arch/hwregs/dma.h>
+#include <arch/hwregs/dma.h>
 
 typedef enum {
 	cryptocop_alg_csum = 0,
diff --git a/arch/cris/include/arch-v32/arch/io.h b/arch/cris/include/arch-v32/arch/io.h
index 6b38912..7202445 100644
--- a/arch/cris/include/arch-v32/arch/io.h
+++ b/arch/cris/include/arch-v32/arch/io.h
@@ -43,7 +43,7 @@ extern struct crisv32_iopin crisv32_led_net1_red;
 
 static inline void crisv32_io_set(struct crisv32_iopin *iopin, int val)
 {
-	long flags;
+	unsigned long flags;
 	spin_lock_irqsave(&iopin->port->lock, flags);
 
 	if (val)
@@ -57,7 +57,7 @@ static inline void crisv32_io_set(struct crisv32_iopin *iopin, int val)
 static inline void crisv32_io_set_dir(struct crisv32_iopin* iopin,
 			       enum crisv32_io_dir dir)
 {
-	long flags;
+	unsigned long flags;
 	spin_lock_irqsave(&iopin->port->lock, flags);
 
 	if (dir == crisv32_io_dir_in)
diff --git a/arch/cris/include/asm/atomic.h b/arch/cris/include/asm/atomic.h
index 5fc8776..f71ea68 100644
--- a/arch/cris/include/asm/atomic.h
+++ b/arch/cris/include/asm/atomic.h
@@ -6,7 +6,7 @@
 #include <linux/compiler.h>
 
 #include <asm/system.h>
-#include <asm/arch/atomic.h>
+#include <arch/atomic.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
diff --git a/arch/cris/include/asm/bitops.h b/arch/cris/include/asm/bitops.h
index 75ea6e0..c0e62f8 100644
--- a/arch/cris/include/asm/bitops.h
+++ b/arch/cris/include/asm/bitops.h
@@ -18,7 +18,7 @@
 #error only <linux/bitops.h> can be included directly
 #endif
 
-#include <asm/arch/bitops.h>
+#include <arch/bitops.h>
 #include <asm/system.h>
 #include <asm/atomic.h>
 #include <linux/compiler.h>
diff --git a/arch/cris/include/asm/bug.h b/arch/cris/include/asm/bug.h
index fee12d4..3b39589 100644
--- a/arch/cris/include/asm/bug.h
+++ b/arch/cris/include/asm/bug.h
@@ -1,4 +1,4 @@
 #ifndef _CRIS_BUG_H
 #define _CRIS_BUG_H
-#include <asm/arch/bug.h>
+#include <arch/bug.h>
 #endif
diff --git a/arch/cris/include/asm/byteorder.h b/arch/cris/include/asm/byteorder.h
index 0cd9db1..cc8e418 100644
--- a/arch/cris/include/asm/byteorder.h
+++ b/arch/cris/include/asm/byteorder.h
@@ -4,7 +4,7 @@
 #ifdef __GNUC__
 
 #ifdef __KERNEL__
-#include <asm/arch/byteorder.h>
+#include <arch/byteorder.h>
 
 /* defines are necessary because the other files detect the presence
  * of a defined __arch_swab32, not an inline
diff --git a/arch/cris/include/asm/cache.h b/arch/cris/include/asm/cache.h
index 46a3b26..a692b9f 100644
--- a/arch/cris/include/asm/cache.h
+++ b/arch/cris/include/asm/cache.h
@@ -1,6 +1,6 @@
 #ifndef _ASM_CACHE_H
 #define _ASM_CACHE_H
 
-#include <asm/arch/cache.h>
+#include <arch/cache.h>
 
 #endif /* _ASM_CACHE_H */
diff --git a/arch/cris/include/asm/checksum.h b/arch/cris/include/asm/checksum.h
index c6c5be6..75dcb77 100644
--- a/arch/cris/include/asm/checksum.h
+++ b/arch/cris/include/asm/checksum.h
@@ -3,7 +3,7 @@
 #ifndef _CRIS_CHECKSUM_H
 #define _CRIS_CHECKSUM_H
 
-#include <asm/arch/checksum.h>
+#include <arch/checksum.h>
 
 /*
  * computes the checksum of a memory block at buff, length len,
diff --git a/arch/cris/include/asm/delay.h b/arch/cris/include/asm/delay.h
index 123e19a..75ec581 100644
--- a/arch/cris/include/asm/delay.h
+++ b/arch/cris/include/asm/delay.h
@@ -7,7 +7,7 @@
  * Delay routines, using a pre-computed "loops_per_second" value.
  */
 
-#include <asm/arch/delay.h>
+#include <arch/delay.h>
 
 /* Use only for very small delays ( < 1 msec).  */
 
diff --git a/arch/cris/include/asm/dma.h b/arch/cris/include/asm/dma.h
index 6f188dc..30fd715 100644
--- a/arch/cris/include/asm/dma.h
+++ b/arch/cris/include/asm/dma.h
@@ -3,7 +3,7 @@
 #ifndef _ASM_DMA_H
 #define _ASM_DMA_H
 
-#include <asm/arch/dma.h>
+#include <arch/dma.h>
 
 /* it's useless on the Etrax, but unfortunately needed by the new
    bootmem allocator (but this should do it for this) */
diff --git a/arch/cris/include/asm/elf.h b/arch/cris/include/asm/elf.h
index f0d17fb..0f51b10 100644
--- a/arch/cris/include/asm/elf.h
+++ b/arch/cris/include/asm/elf.h
@@ -45,7 +45,7 @@ typedef unsigned long elf_fpregset_t;
 #define ELF_DATA	ELFDATA2LSB
 #define ELF_ARCH	EM_CRIS
 
-#include <asm/arch/elf.h>
+#include <arch/elf.h>
 
 /* The master for these definitions is {binutils}/include/elf/cris.h:  */
 /* User symbols in this file have a leading underscore.  */
diff --git a/arch/cris/include/asm/io.h b/arch/cris/include/asm/io.h
index b87ce63..32567bc 100644
--- a/arch/cris/include/asm/io.h
+++ b/arch/cris/include/asm/io.h
@@ -2,7 +2,7 @@
 #define _ASM_CRIS_IO_H
 
 #include <asm/page.h>   /* for __va, __pa */
-#include <asm/arch/io.h>
+#include <arch/io.h>
 #include <linux/kernel.h>
 
 struct cris_io_operations
diff --git a/arch/cris/include/asm/irq.h b/arch/cris/include/asm/irq.h
index 998cce9..ce0fcf5 100644
--- a/arch/cris/include/asm/irq.h
+++ b/arch/cris/include/asm/irq.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_IRQ_H
 #define _ASM_IRQ_H
 
-#include <asm/arch/irq.h>
+#include <arch/irq.h>
 
 static inline int irq_canonicalize(int irq)
 {  
diff --git a/arch/cris/include/asm/mmu.h b/arch/cris/include/asm/mmu.h
index c40a1bc..e06ea94 100644
--- a/arch/cris/include/asm/mmu.h
+++ b/arch/cris/include/asm/mmu.h
@@ -5,6 +5,6 @@
 #ifndef _CRIS_MMU_H
 #define _CRIS_MMU_H
 
-#include <asm/arch/mmu.h>
+#include <arch/mmu.h>
 
 #endif
diff --git a/arch/cris/include/asm/page.h b/arch/cris/include/asm/page.h
index d19272b..f3fdbd0 100644
--- a/arch/cris/include/asm/page.h
+++ b/arch/cris/include/asm/page.h
@@ -1,7 +1,7 @@
 #ifndef _CRIS_PAGE_H
 #define _CRIS_PAGE_H
 
-#include <asm/arch/page.h>
+#include <arch/page.h>
 #include <linux/const.h>
 
 /* PAGE_SHIFT determines the page size */
diff --git a/arch/cris/include/asm/pgtable.h b/arch/cris/include/asm/pgtable.h
index 829e7a7..50aa974 100644
--- a/arch/cris/include/asm/pgtable.h
+++ b/arch/cris/include/asm/pgtable.h
@@ -12,7 +12,7 @@
 #include <linux/sched.h>
 #include <asm/mmu.h>
 #endif
-#include <asm/arch/pgtable.h>
+#include <arch/pgtable.h>
 
 /*
  * The Linux memory management assumes a three-level page table setup. On
diff --git a/arch/cris/include/asm/processor.h b/arch/cris/include/asm/processor.h
index cdc0c1d..3f7248f 100644
--- a/arch/cris/include/asm/processor.h
+++ b/arch/cris/include/asm/processor.h
@@ -13,7 +13,7 @@
 #include <asm/system.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
-#include <asm/arch/processor.h>
+#include <arch/processor.h>
 
 struct task_struct;
 
diff --git a/arch/cris/include/asm/ptrace.h b/arch/cris/include/asm/ptrace.h
index d910925..6618893 100644
--- a/arch/cris/include/asm/ptrace.h
+++ b/arch/cris/include/asm/ptrace.h
@@ -1,7 +1,7 @@
 #ifndef _CRIS_PTRACE_H
 #define _CRIS_PTRACE_H
 
-#include <asm/arch/ptrace.h>
+#include <arch/ptrace.h>
 
 #ifdef __KERNEL__
 
diff --git a/arch/cris/include/asm/spinlock.h b/arch/cris/include/asm/spinlock.h
index 2e8ba8a..ed816b5 100644
--- a/arch/cris/include/asm/spinlock.h
+++ b/arch/cris/include/asm/spinlock.h
@@ -1 +1 @@
-#include <asm/arch/spinlock.h>
+#include <arch/spinlock.h>
diff --git a/arch/cris/include/asm/system.h b/arch/cris/include/asm/system.h
index 5bcfe5a..8657b08 100644
--- a/arch/cris/include/asm/system.h
+++ b/arch/cris/include/asm/system.h
@@ -1,7 +1,7 @@
 #ifndef __ASM_CRIS_SYSTEM_H
 #define __ASM_CRIS_SYSTEM_H
 
-#include <asm/arch/system.h>
+#include <arch/system.h>
 
 /* the switch_to macro calls resume, an asm function in entry.S which does the actual
  * task switching.
diff --git a/arch/cris/include/asm/thread_info.h b/arch/cris/include/asm/thread_info.h
index 7efe100..f25bc28 100644
--- a/arch/cris/include/asm/thread_info.h
+++ b/arch/cris/include/asm/thread_info.h
@@ -16,7 +16,7 @@
 #ifndef __ASSEMBLY__
 #include <asm/types.h>
 #include <asm/processor.h>
-#include <asm/arch/thread_info.h>
+#include <arch/thread_info.h>
 #include <asm/segment.h>
 #endif
 
diff --git a/arch/cris/include/asm/timex.h b/arch/cris/include/asm/timex.h
index b92e0e8..980924a 100644
--- a/arch/cris/include/asm/timex.h
+++ b/arch/cris/include/asm/timex.h
@@ -7,7 +7,7 @@
 #ifndef _ASM_CRIS_TIMEX_H
 #define _ASM_CRIS_TIMEX_H
 
-#include <asm/arch/timex.h>
+#include <arch/timex.h>
 
 /*
  * We don't have a cycle-counter.. but we do not support SMP anyway where this is
diff --git a/arch/cris/include/asm/tlb.h b/arch/cris/include/asm/tlb.h
index 7724246..77384ea 100644
--- a/arch/cris/include/asm/tlb.h
+++ b/arch/cris/include/asm/tlb.h
@@ -3,7 +3,7 @@
 
 #include <linux/pagemap.h>
 
-#include <asm/arch/tlb.h>
+#include <arch/tlb.h>
 
 /*
  * cris doesn't need any special per-pte or
diff --git a/arch/cris/include/asm/uaccess.h b/arch/cris/include/asm/uaccess.h
index ea11eaf..9145408 100644
--- a/arch/cris/include/asm/uaccess.h
+++ b/arch/cris/include/asm/uaccess.h
@@ -54,7 +54,7 @@
 #define __access_ok(addr,size) (__kernel_ok || __user_ok((addr),(size)))
 #define access_ok(type,addr,size) __access_ok((unsigned long)(addr),(size))
 
-#include <asm/arch/uaccess.h>
+#include <arch/uaccess.h>
 
 /*
  * The exception table consists of pairs of addresses: the first is the
diff --git a/arch/cris/include/asm/unistd.h b/arch/cris/include/asm/unistd.h
index 76398ef..235d076 100644
--- a/arch/cris/include/asm/unistd.h
+++ b/arch/cris/include/asm/unistd.h
@@ -336,7 +336,7 @@
 
 #define NR_syscalls 327
 
-#include <asm/arch/unistd.h>
+#include <arch/unistd.h>
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/cris/include/asm/user.h b/arch/cris/include/asm/user.h
index 73e60fc..59147cf 100644
--- a/arch/cris/include/asm/user.h
+++ b/arch/cris/include/asm/user.h
@@ -4,7 +4,7 @@
 #include <linux/types.h>
 #include <asm/ptrace.h>
 #include <asm/page.h>
-#include <asm/arch/user.h>
+#include <arch/user.h>
 
 /*
  * Core file format: The core file is written in such a way that gdb
diff --git a/arch/cris/mm/ioremap.c b/arch/cris/mm/ioremap.c
index 8b0b934..f9ca44b 100644
--- a/arch/cris/mm/ioremap.c
+++ b/arch/cris/mm/ioremap.c
@@ -12,7 +12,7 @@
 #include <linux/vmalloc.h>
 #include <linux/io.h>
 #include <asm/pgalloc.h>
-#include <asm/arch/memmap.h>
+#include <arch/memmap.h>
 
 /*
  * Generic mapping function (not visible outside):
diff --git a/drivers/net/cris/eth_v10.c b/drivers/net/cris/eth_v10.c
index 65d0a91..7e8a631 100644
--- a/drivers/net/cris/eth_v10.c
+++ b/drivers/net/cris/eth_v10.c
@@ -32,14 +32,14 @@
 #include <linux/skbuff.h>
 #include <linux/ethtool.h>
 
-#include <asm/arch/svinto.h>/* DMA and register descriptions */
+#include <arch/svinto.h>/* DMA and register descriptions */
 #include <asm/io.h>         /* CRIS_LED_* I/O functions */
 #include <asm/irq.h>
 #include <asm/dma.h>
 #include <asm/system.h>
 #include <asm/ethernet.h>
 #include <asm/cache.h>
-#include <asm/arch/io_interface_mux.h>
+#include <arch/io_interface_mux.h>
 
 //#define ETHDEBUG
 #define D(x)
diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
index 211c217..8b2c619 100644
--- a/drivers/serial/crisv10.c
+++ b/drivers/serial/crisv10.c
@@ -34,14 +34,14 @@ static char *serial_version = "$Revision: 1.25 $";
 #include <asm/system.h>
 #include <linux/delay.h>
 
-#include <asm/arch/svinto.h>
+#include <arch/svinto.h>
 
 /* non-arch dependent serial structures are in linux/serial.h */
 #include <linux/serial.h>
 /* while we keep our own stuff (struct e100_serial) in a local .h file */
 #include "crisv10.h"
 #include <asm/fasttimer.h>
-#include <asm/arch/io_interface_mux.h>
+#include <arch/io_interface_mux.h>
 
 #ifdef CONFIG_ETRAX_SERIAL_FAST_TIMER
 #ifndef CONFIG_ETRAX_FAST_TIMER
diff --git a/drivers/serial/crisv10.h b/drivers/serial/crisv10.h
index e3c5c8c..f36a729 100644
--- a/drivers/serial/crisv10.h
+++ b/drivers/serial/crisv10.h
@@ -10,7 +10,7 @@
 #include <linux/circ_buf.h>
 #include <asm/termios.h>
 #include <asm/dma.h>
-#include <asm/arch/io_interface_mux.h>
+#include <arch/io_interface_mux.h>
 
 /* Software state per channel */
 

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
