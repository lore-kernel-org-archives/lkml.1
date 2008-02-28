Return-Path: <linux-kernel-owner+w=401wt.eu-S1758581AbYB1Gq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581AbYB1Gq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 01:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756669AbYB1Gpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 01:45:47 -0500
Received: from host106.paramount.wayport.net ([65.249.24.106]:52726 "EHLO
	honeydew.int.wil.cx" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754932AbYB1Gpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 01:45:44 -0500
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 03/12] arch: Remove unnecessary inclusions of asm/semaphore.h
Date: Thu, 28 Feb 2008 01:33:52 -0500
Message-Id: <1204180441-8540-3-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204180441-8540-2-git-send-email-matthew@wil.cx>
References: <20080227003605.GC5715@parisc-linux.org>
 <1204180441-8540-1-git-send-email-matthew@wil.cx>
 <1204180441-8540-2-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these files use any of the functionality promised by
asm/semaphore.h.  It's possible that they rely on it dragging in some
unrelated header file, but I can't build all these files, so we'll have
fix any build failures as they come up.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 arch/arm/common/rtctime.c                    |    1 -
 arch/arm/mach-aaec2000/clock.c               |    2 --
 arch/arm/mach-at91/clock.c                   |    1 -
 arch/arm/mach-integrator/clock.c             |    1 -
 arch/arm/mach-pnx4008/clock.c                |    1 -
 arch/arm/mach-pnx4008/gpio.c                 |    1 -
 arch/arm/mach-realview/clock.c               |    1 -
 arch/arm/mach-versatile/clock.c              |    1 -
 arch/arm/plat-omap/clock.c                   |    1 -
 arch/ia64/sn/kernel/sn2/sn_hwperf.c          |    1 -
 arch/m68k/atari/stram.c                      |    1 -
 arch/m68k/sun3/intersil.c                    |    1 -
 arch/mips/sgi-ip27/ip27-console.c            |    1 -
 arch/parisc/kernel/sys_parisc32.c            |    1 -
 arch/powerpc/kernel/rtas.c                   |    1 -
 arch/powerpc/kernel/sys_ppc32.c              |    1 -
 arch/powerpc/kernel/syscalls.c               |    1 -
 arch/powerpc/platforms/cell/spufs/file.c     |    1 -
 arch/powerpc/platforms/cell/spufs/inode.c    |    1 -
 arch/powerpc/platforms/powermac/pfunc_core.c |    1 -
 arch/ppc/syslib/ocp.c                        |    1 -
 arch/s390/kernel/compat_linux.c              |    1 -
 arch/s390/kernel/debug.c                     |    1 -
 arch/sparc64/kernel/sys_sparc32.c            |    1 -
 arch/v850/kernel/syscalls.c                  |    1 -
 arch/x86/ia32/sys_ia32.c                     |    1 -
 arch/x86/kernel/cpu/common.c                 |    1 -
 arch/x86/kernel/cpu/proc.c                   |    1 -
 28 files changed, 0 insertions(+), 29 deletions(-)

diff --git a/arch/arm/common/rtctime.c b/arch/arm/common/rtctime.c
index f53bca4..aa8f773 100644
--- a/arch/arm/common/rtctime.c
+++ b/arch/arm/common/rtctime.c
@@ -22,7 +22,6 @@
 #include <linux/mutex.h>
 
 #include <asm/rtc.h>
-#include <asm/semaphore.h>
 
 static DECLARE_WAIT_QUEUE_HEAD(rtc_wait);
 static struct fasync_struct *rtc_async_queue;
diff --git a/arch/arm/mach-aaec2000/clock.c b/arch/arm/mach-aaec2000/clock.c
index 74aa7a3..e10ee15 100644
--- a/arch/arm/mach-aaec2000/clock.c
+++ b/arch/arm/mach-aaec2000/clock.c
@@ -18,8 +18,6 @@
 #include <linux/clk.h>
 #include <linux/mutex.h>
 
-#include <asm/semaphore.h>
-
 #include "clock.h"
 
 static LIST_HEAD(clocks);
diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
index de6424e..a33dfe4 100644
--- a/arch/arm/mach-at91/clock.c
+++ b/arch/arm/mach-at91/clock.c
@@ -23,7 +23,6 @@
 #include <linux/delay.h>
 #include <linux/clk.h>
 
-#include <asm/semaphore.h>
 #include <asm/io.h>
 #include <asm/mach-types.h>
 
diff --git a/arch/arm/mach-integrator/clock.c b/arch/arm/mach-integrator/clock.c
index 95a1e26..8d761fd 100644
--- a/arch/arm/mach-integrator/clock.c
+++ b/arch/arm/mach-integrator/clock.c
@@ -17,7 +17,6 @@
 #include <linux/clk.h>
 #include <linux/mutex.h>
 
-#include <asm/semaphore.h>
 #include <asm/hardware/icst525.h>
 
 #include "clock.h"
diff --git a/arch/arm/mach-pnx4008/clock.c b/arch/arm/mach-pnx4008/clock.c
index daa8d3d..6cfffd2 100644
--- a/arch/arm/mach-pnx4008/clock.c
+++ b/arch/arm/mach-pnx4008/clock.c
@@ -21,7 +21,6 @@
 #include <linux/err.h>
 #include <linux/delay.h>
 
-#include <asm/semaphore.h>
 #include <asm/hardware.h>
 #include <asm/io.h>
 
diff --git a/arch/arm/mach-pnx4008/gpio.c b/arch/arm/mach-pnx4008/gpio.c
index 1ab84ce..ef179ca 100644
--- a/arch/arm/mach-pnx4008/gpio.c
+++ b/arch/arm/mach-pnx4008/gpio.c
@@ -17,7 +17,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <asm/semaphore.h>
 #include <asm/io.h>
 #include <asm/arch/platform.h>
 #include <asm/arch/gpio.h>
diff --git a/arch/arm/mach-realview/clock.c b/arch/arm/mach-realview/clock.c
index 21325a4..3e706c5 100644
--- a/arch/arm/mach-realview/clock.c
+++ b/arch/arm/mach-realview/clock.c
@@ -16,7 +16,6 @@
 #include <linux/clk.h>
 #include <linux/mutex.h>
 
-#include <asm/semaphore.h>
 #include <asm/hardware/icst307.h>
 
 #include "clock.h"
diff --git a/arch/arm/mach-versatile/clock.c b/arch/arm/mach-versatile/clock.c
index 9858c96..9336508 100644
--- a/arch/arm/mach-versatile/clock.c
+++ b/arch/arm/mach-versatile/clock.c
@@ -17,7 +17,6 @@
 #include <linux/clk.h>
 #include <linux/mutex.h>
 
-#include <asm/semaphore.h>
 #include <asm/hardware/icst307.h>
 
 #include "clock.h"
diff --git a/arch/arm/plat-omap/clock.c b/arch/arm/plat-omap/clock.c
index 0a60324..203ac50 100644
--- a/arch/arm/plat-omap/clock.c
+++ b/arch/arm/plat-omap/clock.c
@@ -23,7 +23,6 @@
 #include <linux/platform_device.h>
 
 #include <asm/io.h>
-#include <asm/semaphore.h>
 
 #include <asm/arch/clock.h>
 
diff --git a/arch/ia64/sn/kernel/sn2/sn_hwperf.c b/arch/ia64/sn/kernel/sn2/sn_hwperf.c
index 4b0d153..8cc0c47 100644
--- a/arch/ia64/sn/kernel/sn2/sn_hwperf.c
+++ b/arch/ia64/sn/kernel/sn2/sn_hwperf.c
@@ -37,7 +37,6 @@
 
 #include <asm/processor.h>
 #include <asm/topology.h>
-#include <asm/semaphore.h>
 #include <asm/uaccess.h>
 #include <asm/sal.h>
 #include <asm/sn/io.h>
diff --git a/arch/m68k/atari/stram.c b/arch/m68k/atari/stram.c
index 0055a6c..04c69ff 100644
--- a/arch/m68k/atari/stram.c
+++ b/arch/m68k/atari/stram.c
@@ -29,7 +29,6 @@
 #include <asm/atarihw.h>
 #include <asm/atari_stram.h>
 #include <asm/io.h>
-#include <asm/semaphore.h>
 
 #undef DEBUG
 
diff --git a/arch/m68k/sun3/intersil.c b/arch/m68k/sun3/intersil.c
index db359d7..0116d20 100644
--- a/arch/m68k/sun3/intersil.c
+++ b/arch/m68k/sun3/intersil.c
@@ -15,7 +15,6 @@
 
 #include <asm/errno.h>
 #include <asm/system.h>
-#include <asm/semaphore.h>
 #include <asm/rtc.h>
 #include <asm/intersil.h>
 
diff --git a/arch/mips/sgi-ip27/ip27-console.c b/arch/mips/sgi-ip27/ip27-console.c
index 3ba8306..984e561 100644
--- a/arch/mips/sgi-ip27/ip27-console.c
+++ b/arch/mips/sgi-ip27/ip27-console.c
@@ -8,7 +8,6 @@
 #include <linux/init.h>
 
 #include <asm/page.h>
-#include <asm/semaphore.h>
 #include <asm/sn/addrs.h>
 #include <asm/sn/sn0/hub.h>
 #include <asm/sn/klconfig.h>
diff --git a/arch/parisc/kernel/sys_parisc32.c b/arch/parisc/kernel/sys_parisc32.c
index 50bbf33..71efd6a 100644
--- a/arch/parisc/kernel/sys_parisc32.c
+++ b/arch/parisc/kernel/sys_parisc32.c
@@ -49,7 +49,6 @@
 
 #include <asm/types.h>
 #include <asm/uaccess.h>
-#include <asm/semaphore.h>
 #include <asm/mmu_context.h>
 
 #include "sys32.h"
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 52e95c2..fe8d951 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -26,7 +26,6 @@
 #include <asm/prom.h>
 #include <asm/rtas.h>
 #include <asm/hvcall.h>
-#include <asm/semaphore.h>
 #include <asm/machdep.h>
 #include <asm/firmware.h>
 #include <asm/page.h>
diff --git a/arch/powerpc/kernel/sys_ppc32.c b/arch/powerpc/kernel/sys_ppc32.c
index 4a4f5c6..fee9ee2 100644
--- a/arch/powerpc/kernel/sys_ppc32.c
+++ b/arch/powerpc/kernel/sys_ppc32.c
@@ -47,7 +47,6 @@
 #include <asm/types.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
-#include <asm/semaphore.h>
 #include <asm/time.h>
 #include <asm/mmu_context.h>
 #include <asm/ppc-pci.h>
diff --git a/arch/powerpc/kernel/syscalls.c b/arch/powerpc/kernel/syscalls.c
index 3b1d5dd..e722a4e 100644
--- a/arch/powerpc/kernel/syscalls.c
+++ b/arch/powerpc/kernel/syscalls.c
@@ -38,7 +38,6 @@
 #include <linux/personality.h>
 
 #include <asm/uaccess.h>
-#include <asm/semaphore.h>
 #include <asm/syscalls.h>
 #include <asm/time.h>
 #include <asm/unistd.h>
diff --git a/arch/powerpc/platforms/cell/spufs/file.c b/arch/powerpc/platforms/cell/spufs/file.c
index c66c375..bcb8af8 100644
--- a/arch/powerpc/platforms/cell/spufs/file.c
+++ b/arch/powerpc/platforms/cell/spufs/file.c
@@ -32,7 +32,6 @@
 #include <linux/marker.h>
 
 #include <asm/io.h>
-#include <asm/semaphore.h>
 #include <asm/spu.h>
 #include <asm/spu_info.h>
 #include <asm/uaccess.h>
diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index 6d1228c..0c32a05 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -35,7 +35,6 @@
 #include <linux/parser.h>
 
 #include <asm/prom.h>
-#include <asm/semaphore.h>
 #include <asm/spu.h>
 #include <asm/spu_priv1.h>
 #include <asm/uaccess.h>
diff --git a/arch/powerpc/platforms/powermac/pfunc_core.c b/arch/powerpc/platforms/powermac/pfunc_core.c
index 8543423..96d5ce5 100644
--- a/arch/powerpc/platforms/powermac/pfunc_core.c
+++ b/arch/powerpc/platforms/powermac/pfunc_core.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 
-#include <asm/semaphore.h>
 #include <asm/prom.h>
 #include <asm/pmac_pfunc.h>
 
diff --git a/arch/ppc/syslib/ocp.c b/arch/ppc/syslib/ocp.c
index ac80370..a6fb7dc 100644
--- a/arch/ppc/syslib/ocp.c
+++ b/arch/ppc/syslib/ocp.c
@@ -49,7 +49,6 @@
 #include <asm/io.h>
 #include <asm/ocp.h>
 #include <asm/errno.h>
-#include <asm/semaphore.h>
 
 //#define DBG(x)	printk x
 #define DBG(x)
diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linux.c
index 50b85d0..d7f2222 100644
--- a/arch/s390/kernel/compat_linux.c
+++ b/arch/s390/kernel/compat_linux.c
@@ -62,7 +62,6 @@
 
 #include <asm/types.h>
 #include <asm/uaccess.h>
-#include <asm/semaphore.h>
 
 #include <net/scm.h>
 #include <net/sock.h>
diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index 1b2f5ce..79653a7 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -17,7 +17,6 @@
 #include <linux/ctype.h>
 #include <linux/sysctl.h>
 #include <asm/uaccess.h>
-#include <asm/semaphore.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/fs.h>
diff --git a/arch/sparc64/kernel/sys_sparc32.c b/arch/sparc64/kernel/sys_sparc32.c
index deaba2b..de3be1e 100644
--- a/arch/sparc64/kernel/sys_sparc32.c
+++ b/arch/sparc64/kernel/sys_sparc32.c
@@ -55,7 +55,6 @@
 #include <asm/types.h>
 #include <asm/uaccess.h>
 #include <asm/fpumacro.h>
-#include <asm/semaphore.h>
 #include <asm/mmu_context.h>
 #include <asm/compat_signal.h>
 
diff --git a/arch/v850/kernel/syscalls.c b/arch/v850/kernel/syscalls.c
index 0a4df4d..003db9c 100644
--- a/arch/v850/kernel/syscalls.c
+++ b/arch/v850/kernel/syscalls.c
@@ -30,7 +30,6 @@
 #include <linux/file.h>
 
 #include <asm/uaccess.h>
-#include <asm/semaphore.h>
 #include <asm/unistd.h>
 
 /*
diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index abf71d2..211eed3 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -64,7 +64,6 @@
 #include <asm/mman.h>
 #include <asm/types.h>
 #include <asm/uaccess.h>
-#include <asm/semaphore.h>
 #include <asm/atomic.h>
 #include <asm/ldt.h>
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a38aafa..2ffab32 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -5,7 +5,6 @@
 #include <linux/module.h>
 #include <linux/percpu.h>
 #include <linux/bootmem.h>
-#include <asm/semaphore.h>
 #include <asm/processor.h>
 #include <asm/i387.h>
 #include <asm/msr.h>
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index af11d31..149dbce 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -1,7 +1,6 @@
 #include <linux/smp.h>
 #include <linux/timex.h>
 #include <linux/string.h>
-#include <asm/semaphore.h>
 #include <linux/seq_file.h>
 #include <linux/cpufreq.h>
 
-- 
1.5.4.1

