Return-Path: <linux-kernel-owner+w=401wt.eu-S1759811AbYEKWAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759811AbYEKWAw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 18:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756549AbYEKWAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 18:00:40 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34456 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbYEKWAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 18:00:37 -0400
References: <git-1210542959-0ff5ce7f30b45cc2014cec465c0e96c16877116e@dyn-67.arm.linux.org.uk>
Message-ID: <git-1210542959-a5b32acc9d50dd3c819c2dc5d43bd416f24aa8fd@dyn-67.arm.linux.org.uk>
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: LKML <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
       LAK <linux-arm-kernel@lists.arm.linux.org.uk>
Date: Sun, 11 May 2008 22:55:59 +0100
Content-type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Subject: Re: [ARM] Remove obsolete and unused ARM dyntick support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk@dyn-67.arm.linux.org.uk>

dyntick is superseded by the clocksource/clockevent infrastructure,
using the NO_HZ configuration option.  No one implements dyntick on
ARM anymore, so it's pointless keeping it around.  Remove dyntick
support.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/Kconfig                         |   21 -----
 arch/arm/configs/at91cap9adk_defconfig   |    1 -
 arch/arm/configs/at91rm9200dk_defconfig  |    1 -
 arch/arm/configs/at91rm9200ek_defconfig  |    1 -
 arch/arm/configs/at91sam9260ek_defconfig |    1 -
 arch/arm/configs/at91sam9261ek_defconfig |    1 -
 arch/arm/configs/at91sam9263ek_defconfig |    1 -
 arch/arm/configs/at91sam9rlek_defconfig  |    1 -
 arch/arm/configs/ateb9200_defconfig      |    1 -
 arch/arm/configs/cm_x270_defconfig       |    1 -
 arch/arm/configs/collie_defconfig        |    1 -
 arch/arm/configs/corgi_defconfig         |    1 -
 arch/arm/configs/ecbat91_defconfig       |    1 -
 arch/arm/configs/em_x270_defconfig       |    1 -
 arch/arm/configs/ep93xx_defconfig        |    1 -
 arch/arm/configs/eseries_pxa_defconfig   |    1 -
 arch/arm/configs/iop13xx_defconfig       |    1 -
 arch/arm/configs/iop32x_defconfig        |    1 -
 arch/arm/configs/iop33x_defconfig        |    1 -
 arch/arm/configs/ixp2000_defconfig       |    1 -
 arch/arm/configs/ixp23xx_defconfig       |    1 -
 arch/arm/configs/kafa_defconfig          |    1 -
 arch/arm/configs/kb9202_defconfig        |    1 -
 arch/arm/configs/ks8695_defconfig        |    1 -
 arch/arm/configs/lpd270_defconfig        |    1 -
 arch/arm/configs/lpd7a404_defconfig      |    1 -
 arch/arm/configs/netx_defconfig          |    1 -
 arch/arm/configs/onearm_defconfig        |    1 -
 arch/arm/configs/picotux200_defconfig    |    1 -
 arch/arm/configs/pnx4008_defconfig       |    1 -
 arch/arm/configs/realview-smp_defconfig  |    1 -
 arch/arm/configs/realview_defconfig      |    1 -
 arch/arm/configs/rpc_defconfig           |    1 -
 arch/arm/configs/s3c2410_defconfig       |    1 -
 arch/arm/configs/sam9_l9260_defconfig    |    1 -
 arch/arm/configs/spitz_defconfig         |    1 -
 arch/arm/configs/tct_hammer_defconfig    |    1 -
 arch/arm/configs/trizeps4_defconfig      |    1 -
 arch/arm/configs/versatile_defconfig     |    1 -
 arch/arm/kernel/process.c                |    4 +-
 arch/arm/kernel/time.c                   |  120 ------------------------------
 arch/arm/mach-omap1/pm.c                 |    7 --
 arch/arm/mach-omap2/pm.c                 |    7 --
 include/asm-arm/dyntick.h                |    6 --
 include/asm-arm/hw_irq.h                 |   11 ---
 include/asm-arm/mach/time.h              |   22 ------
 46 files changed, 1 insertions(+), 235 deletions(-)
 delete mode 100644 include/asm-arm/dyntick.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index b786e68..167824e 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -703,27 +703,6 @@ config PREEMPT
 	  Say Y here if you are building a kernel for a desktop, embedded
 	  or real-time system.  Say N if you are unsure.
 
-config NO_IDLE_HZ
-	bool "Dynamic tick timer"
-	depends on !GENERIC_CLOCKEVENTS
-	help
-	  Select this option if you want to disable continuous timer ticks
-	  and have them programmed to occur as required. This option saves
-	  power as the system can remain in idle state for longer.
-
-	  By default dynamic tick is disabled during the boot, and can be
-	  manually enabled with:
-
-	    echo 1 > /sys/devices/system/timer/timer0/dyn_tick
-
-	  Alternatively, if you want dynamic tick automatically enabled
-	  during boot, pass "dyntick=enable" via the kernel command string.
-
-	  Please note that dynamic tick may affect the accuracy of
-	  timekeeping on some platforms depending on the implementation.
-	  Currently at least OMAP, PXA2xx and SA11x0 platforms are known
-	  to have accurate timekeeping with dynamic tick.
-
 config HZ
 	int
 	default 128 if ARCH_L7200
diff --git a/arch/arm/configs/at91cap9adk_defconfig b/arch/arm/configs/at91cap9adk_defconfig
index e32e736..b8e73e9 100644
--- a/arch/arm/configs/at91cap9adk_defconfig
+++ b/arch/arm/configs/at91cap9adk_defconfig
@@ -213,7 +213,6 @@ CONFIG_CPU_CP15_MMU=y
 #
 # CONFIG_TICK_ONESHOT is not set
 # CONFIG_PREEMPT is not set
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_HZ=100
 CONFIG_AEABI=y
 CONFIG_OABI_COMPAT=y
diff --git a/arch/arm/configs/at91rm9200dk_defconfig b/arch/arm/configs/at91rm9200dk_defconfig
index 2dbbbc3..868fb7b 100644
--- a/arch/arm/configs/at91rm9200dk_defconfig
+++ b/arch/arm/configs/at91rm9200dk_defconfig
@@ -169,7 +169,6 @@ CONFIG_AT91_CF=y
 # Kernel Features
 #
 # CONFIG_PREEMPT is not set
-# CONFIG_NO_IDLE_HZ is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
 CONFIG_SELECT_MEMORY_MODEL=y
 CONFIG_FLATMEM_MANUAL=y
diff --git a/arch/arm/configs/at91rm9200ek_defconfig b/arch/arm/configs/at91rm9200ek_defconfig
index 6e994f7..de43fc6 100644
--- a/arch/arm/configs/at91rm9200ek_defconfig
+++ b/arch/arm/configs/at91rm9200ek_defconfig
@@ -160,7 +160,6 @@ CONFIG_ISA_DMA_API=y
 # Kernel Features
 #
 # CONFIG_PREEMPT is not set
-# CONFIG_NO_IDLE_HZ is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
 CONFIG_SELECT_MEMORY_MODEL=y
 CONFIG_FLATMEM_MANUAL=y
diff --git a/arch/arm/configs/at91sam9260ek_defconfig b/arch/arm/configs/at91sam9260ek_defconfig
index f659c93..2011adf 100644
--- a/arch/arm/configs/at91sam9260ek_defconfig
+++ b/arch/arm/configs/at91sam9260ek_defconfig
@@ -220,7 +220,6 @@ CONFIG_CPU_CP15_MMU=y
 #
 # CONFIG_TICK_ONESHOT is not set
 # CONFIG_PREEMPT is not set
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_HZ=100
 # CONFIG_AEABI is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
diff --git a/arch/arm/configs/at91sam9261ek_defconfig b/arch/arm/configs/at91sam9261ek_defconfig
index 3802e85..4049768 100644
--- a/arch/arm/configs/at91sam9261ek_defconfig
+++ b/arch/arm/configs/at91sam9261ek_defconfig
@@ -213,7 +213,6 @@ CONFIG_CPU_CP15_MMU=y
 #
 # CONFIG_TICK_ONESHOT is not set
 # CONFIG_PREEMPT is not set
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_HZ=100
 # CONFIG_AEABI is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
diff --git a/arch/arm/configs/at91sam9263ek_defconfig b/arch/arm/configs/at91sam9263ek_defconfig
index 32a0d74..fa1c5ae 100644
--- a/arch/arm/configs/at91sam9263ek_defconfig
+++ b/arch/arm/configs/at91sam9263ek_defconfig
@@ -213,7 +213,6 @@ CONFIG_CPU_CP15_MMU=y
 #
 # CONFIG_TICK_ONESHOT is not set
 # CONFIG_PREEMPT is not set
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_HZ=100
 # CONFIG_AEABI is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
diff --git a/arch/arm/configs/at91sam9rlek_defconfig b/arch/arm/configs/at91sam9rlek_defconfig
index 98e6746..d8ec5f9 100644
--- a/arch/arm/configs/at91sam9rlek_defconfig
+++ b/arch/arm/configs/at91sam9rlek_defconfig
@@ -211,7 +211,6 @@ CONFIG_CPU_CP15_MMU=y
 #
 # CONFIG_TICK_ONESHOT is not set
 # CONFIG_PREEMPT is not set
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_HZ=100
 # CONFIG_AEABI is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
diff --git a/arch/arm/configs/ateb9200_defconfig b/arch/arm/configs/ateb9200_defconfig
index d846a49..85c80f7 100644
--- a/arch/arm/configs/ateb9200_defconfig
+++ b/arch/arm/configs/ateb9200_defconfig
@@ -171,7 +171,6 @@ CONFIG_AT91_CF=m
 # Kernel Features
 #
 CONFIG_PREEMPT=y
-CONFIG_NO_IDLE_HZ=y
 CONFIG_HZ=100
 # CONFIG_AEABI is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
diff --git a/arch/arm/configs/cm_x270_defconfig b/arch/arm/configs/cm_x270_defconfig
index 5cab083..33b201c 100644
--- a/arch/arm/configs/cm_x270_defconfig
+++ b/arch/arm/configs/cm_x270_defconfig
@@ -194,7 +194,6 @@ CONFIG_PCI_HOST_ITE8152=y
 #
 # CONFIG_TICK_ONESHOT is not set
 # CONFIG_PREEMPT is not set
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_HZ=100
 # CONFIG_AEABI is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
diff --git a/arch/arm/configs/collie_defconfig b/arch/arm/configs/collie_defconfig
index 4264e27..f7622e6 100644
--- a/arch/arm/configs/collie_defconfig
+++ b/arch/arm/configs/collie_defconfig
@@ -166,7 +166,6 @@ CONFIG_PCMCIA_SA1100=y
 # Kernel Features
 #
 # CONFIG_PREEMPT is not set
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_HZ=100
 # CONFIG_AEABI is not set
 CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
diff --git a/arch/arm/configs/corgi_defconfig b/arch/arm/configs/corgi_defconfig
index e8980a9..9b8748a 100644
--- a/arch/arm/configs/corgi_defconfig
+++ b/arch/arm/configs/corgi_defconfig
@@ -165,7 +165,6 @@ CONFIG_PCMCIA_PXA2XX=y
 # Kernel Features
 #
 CONFIG_PREEMPT=y
-# CONFIG_NO_IDLE_HZ is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
 CONFIG_SELECT_MEMORY_MODEL=y
 CONFIG_FLATMEM_MANUAL=y
diff --git a/arch/arm/configs/ecbat91_defconfig b/arch/arm/configs/ecbat91_defconfig
index 90ed214..cfeb817 100644
--- a/arch/arm/configs/ecbat91_defconfig
+++ b/arch/arm/configs/ecbat91_defconfig
@@ -230,7 +230,6 @@ CONFIG_AT91_CF=y
 #
 # CONFIG_TICK_ONESHOT is not set
 CONFIG_PREEMPT=y
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_HZ=100
 # CONFIG_AEABI is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
diff --git a/arch/arm/configs/em_x270_defconfig b/arch/arm/configs/em_x270_defconfig
index 6bea090..d3114c2 100644
--- a/arch/arm/configs/em_x270_defconfig
+++ b/arch/arm/configs/em_x270_defconfig
@@ -197,7 +197,6 @@ CONFIG_XSCALE_PMU=y
 #
 # CONFIG_TICK_ONESHOT is not set
 # CONFIG_PREEMPT is not set
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_HZ=100
 CONFIG_AEABI=y
 CONFIG_OABI_COMPAT=y
diff --git a/arch/arm/configs/ep93xx_defconfig b/arch/arm/configs/ep93xx_defconfig
index 24a701a..21aa013 100644
--- a/arch/arm/configs/ep93xx_defconfig
+++ b/arch/arm/configs/ep93xx_defconfig
@@ -184,7 +184,6 @@ CONFIG_ARM_AMBA=y
 # Kernel Features
 #
 # CONFIG_PREEMPT is not set
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_HZ=100
 # CONFIG_AEABI is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
diff --git a/arch/arm/configs/eseries_pxa_defconfig b/arch/arm/configs/eseries_pxa_defconfig
index ed487b9..493ecee 100644
--- a/arch/arm/configs/eseries_pxa_defconfig
+++ b/arch/arm/configs/eseries_pxa_defconfig
@@ -251,7 +251,6 @@ CONFIG_PCMCIA_PXA2XX=m
 # Kernel Features
 #
 # CONFIG_PREEMPT is not set
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_HZ=100
 CONFIG_AEABI=y
 CONFIG_OABI_COMPAT=y
diff --git a/arch/arm/configs/iop13xx_defconfig b/arch/arm/configs/iop13xx_defconfig
index 988b4d1..482e570 100644
--- a/arch/arm/configs/iop13xx_defconfig
+++ b/arch/arm/configs/iop13xx_defconfig
@@ -197,7 +197,6 @@ CONFIG_PCI_LEGACY=y
 #
 # CONFIG_TICK_ONESHOT is not set
 # CONFIG_PREEMPT is not set
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_HZ=100
 # CONFIG_AEABI is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
diff --git a/arch/arm/configs/iop32x_defconfig b/arch/arm/configs/iop32x_defconfig
index 83f40d4..8612f58 100644
--- a/arch/arm/configs/iop32x_defconfig
+++ b/arch/arm/configs/iop32x_defconfig
@@ -201,7 +201,6 @@ CONFIG_PCI_LEGACY=y
 #
 # CONFIG_TICK_ONESHOT is not set
 # CONFIG_PREEMPT is not set
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_HZ=100
 # CONFIG_AEABI is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
diff --git a/arch/arm/configs/iop33x_defconfig b/arch/arm/configs/iop33x_defconfig
index 917afb5..8b0098d 100644
--- a/arch/arm/configs/iop33x_defconfig
+++ b/arch/arm/configs/iop33x_defconfig
@@ -197,7 +197,6 @@ CONFIG_PCI_LEGACY=y
 #
 # CONFIG_TICK_ONESHOT is not set
 # CONFIG_PREEMPT is not set
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_HZ=100
 # CONFIG_AEABI is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
diff --git a/arch/arm/configs/ixp2000_defconfig b/arch/arm/configs/ixp2000_defconfig
index f8f9793..84680db 100644
--- a/arch/arm/configs/ixp2000_defconfig
+++ b/arch/arm/configs/ixp2000_defconfig
@@ -184,7 +184,6 @@ CONFIG_PCI=y
 # Kernel Features
 #
 # CONFIG_PREEMPT is not set
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_HZ=100
 # CONFIG_AEABI is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
diff --git a/arch/arm/configs/ixp23xx_defconfig b/arch/arm/configs/ixp23xx_defconfig
index 27cf022..4a2f7b2 100644
--- a/arch/arm/configs/ixp23xx_defconfig
+++ b/arch/arm/configs/ixp23xx_defconfig
@@ -180,7 +180,6 @@ CONFIG_PCI=y
 # Kernel Features
 #
 # CONFIG_PREEMPT is not set
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_HZ=100
 # CONFIG_AEABI is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
diff --git a/arch/arm/configs/kafa_defconfig b/arch/arm/configs/kafa_defconfig
index ae51a40..6dd95a2 100644
--- a/arch/arm/configs/kafa_defconfig
+++ b/arch/arm/configs/kafa_defconfig
@@ -162,7 +162,6 @@ CONFIG_CPU_TLB_V4WBI=y
 # Kernel Features
 #
 CONFIG_PREEMPT=y
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_HZ=100
 # CONFIG_AEABI is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
diff --git a/arch/arm/configs/kb9202_defconfig b/arch/arm/configs/kb9202_defconfig
index c16537d..8e74c66 100644
--- a/arch/arm/configs/kb9202_defconfig
+++ b/arch/arm/configs/kb9202_defconfig
@@ -126,7 +126,6 @@ CONFIG_ISA_DMA_API=y
 #
 # Kernel Features
 #
-# CONFIG_NO_IDLE_HZ is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
 CONFIG_FLATMEM=y
 CONFIG_FLAT_NODE_MEM_MAP=y
diff --git a/arch/arm/configs/ks8695_defconfig b/arch/arm/configs/ks8695_defconfig
index 8ab21a0..6077f2c 100644
--- a/arch/arm/configs/ks8695_defconfig
+++ b/arch/arm/configs/ks8695_defconfig
@@ -174,7 +174,6 @@ CONFIG_PCCARD_NONSTATIC=y
 # Kernel Features
 #
 # CONFIG_PREEMPT is not set
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_HZ=100
 # CONFIG_AEABI is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
diff --git a/arch/arm/configs/lpd270_defconfig b/arch/arm/configs/lpd270_defconfig
index a3bf583..1a38d8e 100644
--- a/arch/arm/configs/lpd270_defconfig
+++ b/arch/arm/configs/lpd270_defconfig
@@ -173,7 +173,6 @@ CONFIG_XSCALE_PMU=y
 # Kernel Features
 #
 # CONFIG_PREEMPT is not set
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_HZ=100
 # CONFIG_AEABI is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
diff --git a/arch/arm/configs/lpd7a404_defconfig b/arch/arm/configs/lpd7a404_defconfig
index 46a0f7f..7a2e932 100644
--- a/arch/arm/configs/lpd7a404_defconfig
+++ b/arch/arm/configs/lpd7a404_defconfig
@@ -148,7 +148,6 @@ CONFIG_ARM_AMBA=y
 # Kernel Features
 #
 CONFIG_PREEMPT=y
-# CONFIG_NO_IDLE_HZ is not set
 # CONFIG_AEABI is not set
 CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
 CONFIG_SELECT_MEMORY_MODEL=y
diff --git a/arch/arm/configs/netx_defconfig b/arch/arm/configs/netx_defconfig
index 57f32f3..0884f23 100644
--- a/arch/arm/configs/netx_defconfig
+++ b/arch/arm/configs/netx_defconfig
@@ -154,7 +154,6 @@ CONFIG_ARM_AMBA=y
 # Kernel Features
 #
 CONFIG_PREEMPT=y
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_HZ=100
 # CONFIG_AEABI is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
diff --git a/arch/arm/configs/onearm_defconfig b/arch/arm/configs/onearm_defconfig
index 650a248..418ca2f 100644
--- a/arch/arm/configs/onearm_defconfig
+++ b/arch/arm/configs/onearm_defconfig
@@ -202,7 +202,6 @@ CONFIG_AT91_CF=y
 # Kernel Features
 #
 # CONFIG_PREEMPT is not set
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_HZ=100
 # CONFIG_AEABI is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
diff --git a/arch/arm/configs/picotux200_defconfig b/arch/arm/configs/picotux200_defconfig
index 95a22f5..14826f0 100644
--- a/arch/arm/configs/picotux200_defconfig
+++ b/arch/arm/configs/picotux200_defconfig
@@ -201,7 +201,6 @@ CONFIG_ARM_THUMB=y
 # Kernel Features
 #
 # CONFIG_PREEMPT is not set
-CONFIG_NO_IDLE_HZ=y
 CONFIG_HZ=100
 CONFIG_AEABI=y
 CONFIG_OABI_COMPAT=y
diff --git a/arch/arm/configs/pnx4008_defconfig b/arch/arm/configs/pnx4008_defconfig
index b5e11aa..811b8f6 100644
--- a/arch/arm/configs/pnx4008_defconfig
+++ b/arch/arm/configs/pnx4008_defconfig
@@ -151,7 +151,6 @@ CONFIG_ARM_THUMB=y
 # Kernel Features
 #
 CONFIG_PREEMPT=y
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_HZ=100
 # CONFIG_AEABI is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
diff --git a/arch/arm/configs/realview-smp_defconfig b/arch/arm/configs/realview-smp_defconfig
index fc39ba1..0c09b23 100644
--- a/arch/arm/configs/realview-smp_defconfig
+++ b/arch/arm/configs/realview-smp_defconfig
@@ -177,7 +177,6 @@ CONFIG_NR_CPUS=4
 CONFIG_HOTPLUG_CPU=y
 CONFIG_LOCAL_TIMERS=y
 # CONFIG_PREEMPT is not set
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_HZ=100
 # CONFIG_AEABI is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
diff --git a/arch/arm/configs/realview_defconfig b/arch/arm/configs/realview_defconfig
index accbf52..907e543 100644
--- a/arch/arm/configs/realview_defconfig
+++ b/arch/arm/configs/realview_defconfig
@@ -126,7 +126,6 @@ CONFIG_ISA_DMA_API=y
 #
 # Kernel Features
 #
-# CONFIG_NO_IDLE_HZ is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
 CONFIG_FLATMEM=y
 CONFIG_FLAT_NODE_MEM_MAP=y
diff --git a/arch/arm/configs/rpc_defconfig b/arch/arm/configs/rpc_defconfig
index 5ddecb9..f62d181 100644
--- a/arch/arm/configs/rpc_defconfig
+++ b/arch/arm/configs/rpc_defconfig
@@ -190,7 +190,6 @@ CONFIG_ISA_DMA_API=y
 #
 # CONFIG_TICK_ONESHOT is not set
 # CONFIG_PREEMPT is not set
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_HZ=100
 # CONFIG_AEABI is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
diff --git a/arch/arm/configs/s3c2410_defconfig b/arch/arm/configs/s3c2410_defconfig
index f8a1645..6d03763 100644
--- a/arch/arm/configs/s3c2410_defconfig
+++ b/arch/arm/configs/s3c2410_defconfig
@@ -246,7 +246,6 @@ CONFIG_ISA=y
 # Kernel Features
 #
 # CONFIG_PREEMPT is not set
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_HZ=200
 # CONFIG_AEABI is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
diff --git a/arch/arm/configs/sam9_l9260_defconfig b/arch/arm/configs/sam9_l9260_defconfig
index 484dc97..8688362 100644
--- a/arch/arm/configs/sam9_l9260_defconfig
+++ b/arch/arm/configs/sam9_l9260_defconfig
@@ -211,7 +211,6 @@ CONFIG_ARM_THUMB=y
 #
 # CONFIG_TICK_ONESHOT is not set
 CONFIG_PREEMPT=y
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_HZ=100
 # CONFIG_AEABI is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
diff --git a/arch/arm/configs/spitz_defconfig b/arch/arm/configs/spitz_defconfig
index aa7a011..7d59fb1 100644
--- a/arch/arm/configs/spitz_defconfig
+++ b/arch/arm/configs/spitz_defconfig
@@ -164,7 +164,6 @@ CONFIG_PCMCIA_PXA2XX=y
 # Kernel Features
 #
 CONFIG_PREEMPT=y
-# CONFIG_NO_IDLE_HZ is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
 CONFIG_SELECT_MEMORY_MODEL=y
 CONFIG_FLATMEM_MANUAL=y
diff --git a/arch/arm/configs/tct_hammer_defconfig b/arch/arm/configs/tct_hammer_defconfig
index 576b833..07dfb98 100644
--- a/arch/arm/configs/tct_hammer_defconfig
+++ b/arch/arm/configs/tct_hammer_defconfig
@@ -247,7 +247,6 @@ CONFIG_ARM_THUMB=y
 #
 # CONFIG_TICK_ONESHOT is not set
 # CONFIG_PREEMPT is not set
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_HZ=200
 # CONFIG_AEABI is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
diff --git a/arch/arm/configs/trizeps4_defconfig b/arch/arm/configs/trizeps4_defconfig
index 6db6392..8b7a431 100644
--- a/arch/arm/configs/trizeps4_defconfig
+++ b/arch/arm/configs/trizeps4_defconfig
@@ -195,7 +195,6 @@ CONFIG_PCMCIA_PXA2XX=y
 # Kernel Features
 #
 CONFIG_PREEMPT=y
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_HZ=100
 CONFIG_AEABI=y
 CONFIG_OABI_COMPAT=y
diff --git a/arch/arm/configs/versatile_defconfig b/arch/arm/configs/versatile_defconfig
index 48dca69..8355f88 100644
--- a/arch/arm/configs/versatile_defconfig
+++ b/arch/arm/configs/versatile_defconfig
@@ -151,7 +151,6 @@ CONFIG_ARM_AMBA=y
 # Kernel Features
 #
 # CONFIG_PREEMPT is not set
-# CONFIG_NO_IDLE_HZ is not set
 CONFIG_HZ=100
 # CONFIG_AEABI is not set
 # CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 46bf2ed..199b368 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -133,10 +133,8 @@ static void default_idle(void)
 		cpu_relax();
 	else {
 		local_irq_disable();
-		if (!need_resched()) {
-			timer_dyn_reprogram();
+		if (!need_resched())
 			arch_idle();
-		}
 		local_irq_enable();
 	}
 }
diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
index b5867ec..cc5145b 100644
--- a/arch/arm/kernel/time.c
+++ b/arch/arm/kernel/time.c
@@ -365,108 +365,6 @@ static struct sysdev_class timer_sysclass = {
 	.resume		= timer_resume,
 };
 
-#ifdef CONFIG_NO_IDLE_HZ
-static int timer_dyn_tick_enable(void)
-{
-	struct dyn_tick_timer *dyn_tick = system_timer->dyn_tick;
-	unsigned long flags;
-	int ret = -ENODEV;
-
-	if (dyn_tick) {
-		spin_lock_irqsave(&dyn_tick->lock, flags);
-		ret = 0;
-		if (!(dyn_tick->state & DYN_TICK_ENABLED)) {
-			ret = dyn_tick->enable();
-
-			if (ret == 0)
-				dyn_tick->state |= DYN_TICK_ENABLED;
-		}
-		spin_unlock_irqrestore(&dyn_tick->lock, flags);
-	}
-
-	return ret;
-}
-
-static int timer_dyn_tick_disable(void)
-{
-	struct dyn_tick_timer *dyn_tick = system_timer->dyn_tick;
-	unsigned long flags;
-	int ret = -ENODEV;
-
-	if (dyn_tick) {
-		spin_lock_irqsave(&dyn_tick->lock, flags);
-		ret = 0;
-		if (dyn_tick->state & DYN_TICK_ENABLED) {
-			ret = dyn_tick->disable();
-
-			if (ret == 0)
-				dyn_tick->state &= ~DYN_TICK_ENABLED;
-		}
-		spin_unlock_irqrestore(&dyn_tick->lock, flags);
-	}
-
-	return ret;
-}
-
-/*
- * Reprogram the system timer for at least the calculated time interval.
- * This function should be called from the idle thread with IRQs disabled,
- * immediately before sleeping.
- */
-void timer_dyn_reprogram(void)
-{
-	struct dyn_tick_timer *dyn_tick = system_timer->dyn_tick;
-	unsigned long next, seq, flags;
-
-	if (!dyn_tick)
-		return;
-
-	spin_lock_irqsave(&dyn_tick->lock, flags);
-	if (dyn_tick->state & DYN_TICK_ENABLED) {
-		next = next_timer_interrupt();
-		do {
-			seq = read_seqbegin(&xtime_lock);
-			dyn_tick->reprogram(next - jiffies);
-		} while (read_seqretry(&xtime_lock, seq));
-	}
-	spin_unlock_irqrestore(&dyn_tick->lock, flags);
-}
-
-static ssize_t timer_show_dyn_tick(struct sys_device *dev, char *buf)
-{
-	return sprintf(buf, "%i\n",
-		       (system_timer->dyn_tick->state & DYN_TICK_ENABLED) >> 1);
-}
-
-static ssize_t timer_set_dyn_tick(struct sys_device *dev, const char *buf,
-				  size_t count)
-{
-	unsigned int enable = simple_strtoul(buf, NULL, 2);
-
-	if (enable)
-		timer_dyn_tick_enable();
-	else
-		timer_dyn_tick_disable();
-
-	return count;
-}
-static SYSDEV_ATTR(dyn_tick, 0644, timer_show_dyn_tick, timer_set_dyn_tick);
-
-/*
- * dyntick=enable|disable
- */
-static char dyntick_str[4] __initdata = "";
-
-static int __init dyntick_setup(char *str)
-{
-	if (str)
-		strlcpy(dyntick_str, str, sizeof(dyntick_str));
-	return 1;
-}
-
-__setup("dyntick=", dyntick_setup);
-#endif
-
 static int __init timer_init_sysfs(void)
 {
 	int ret = sysdev_class_register(&timer_sysclass);
@@ -475,19 +373,6 @@ static int __init timer_init_sysfs(void)
 		ret = sysdev_register(&system_timer->dev);
 	}
 
-#ifdef CONFIG_NO_IDLE_HZ
-	if (ret == 0 && system_timer->dyn_tick) {
-		ret = sysdev_create_file(&system_timer->dev, &attr_dyn_tick);
-
-		/*
-		 * Turn on dynamic tick after calibrate delay
-		 * for correct bogomips
-		 */
-		if (ret == 0 && dyntick_str[0] == 'e')
-			ret = timer_dyn_tick_enable();
-	}
-#endif
-
 	return ret;
 }
 
@@ -500,10 +385,5 @@ void __init time_init(void)
 		system_timer->offset = dummy_gettimeoffset;
 #endif
 	system_timer->init();
-
-#ifdef CONFIG_NO_IDLE_HZ
-	if (system_timer->dyn_tick)
-		spin_lock_init(&system_timer->dyn_tick->lock);
-#endif
 }
 
diff --git a/arch/arm/mach-omap1/pm.c b/arch/arm/mach-omap1/pm.c
index e6c64e1..742f79e 100644
--- a/arch/arm/mach-omap1/pm.c
+++ b/arch/arm/mach-omap1/pm.c
@@ -116,13 +116,6 @@ void omap_pm_idle(void)
 		return;
 	}
 
-	/*
-	 * Since an interrupt may set up a timer, we don't want to
-	 * reprogram the hardware timer with interrupts enabled.
-	 * Re-enable interrupts only after returning from idle.
-	 */
-	timer_dyn_reprogram();
-
 #ifdef CONFIG_OMAP_MPU_TIMER
 #warning Enable 32kHz OS timer in order to allow sleep states in idle
 	use_idlect1 = use_idlect1 & ~(1 << 9);
diff --git a/arch/arm/mach-omap2/pm.c b/arch/arm/mach-omap2/pm.c
index aad781d..d6c9de8 100644
--- a/arch/arm/mach-omap2/pm.c
+++ b/arch/arm/mach-omap2/pm.c
@@ -57,13 +57,6 @@ void omap2_pm_idle(void)
 		return;
 	}
 
-	/*
-	 * Since an interrupt may set up a timer, we don't want to
-	 * reprogram the hardware timer with interrupts enabled.
-	 * Re-enable interrupts only after returning from idle.
-	 */
-	timer_dyn_reprogram();
-
 	omap2_sram_idle();
 	local_fiq_enable();
 	local_irq_enable();
diff --git a/include/asm-arm/dyntick.h b/include/asm-arm/dyntick.h
deleted file mode 100644
index 19fab2d..0000000
--- a/include/asm-arm/dyntick.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASMARM_DYNTICK_H
-#define _ASMARM_DYNTICK_H
-
-#include <asm/mach/time.h>
-
-#endif /* _ASMARM_DYNTICK_H */
diff --git a/include/asm-arm/hw_irq.h b/include/asm-arm/hw_irq.h
index 98d594a..f1a08a5 100644
--- a/include/asm-arm/hw_irq.h
+++ b/include/asm-arm/hw_irq.h
@@ -6,15 +6,4 @@
 
 #include <asm/mach/irq.h>
 
-#if defined(CONFIG_NO_IDLE_HZ)
-# include <asm/dyntick.h>
-# define handle_dynamic_tick(action)					\
-	if (!(action->flags & IRQF_TIMER) && system_timer->dyn_tick) {	\
-		write_seqlock(&xtime_lock);				\
-		if (system_timer->dyn_tick->state & DYN_TICK_ENABLED)	\
-			system_timer->dyn_tick->handler(irq, NULL);	\
-		write_sequnlock(&xtime_lock);				\
-	}
-#endif
-
 #endif
diff --git a/include/asm-arm/mach/time.h b/include/asm-arm/mach/time.h
index 5dc3570..2fd36ea 100644
--- a/include/asm-arm/mach/time.h
+++ b/include/asm-arm/mach/time.h
@@ -41,30 +41,8 @@ struct sys_timer {
 #ifndef CONFIG_GENERIC_TIME
 	unsigned long		(*offset)(void);
 #endif
-
-#ifdef CONFIG_NO_IDLE_HZ
-	struct dyn_tick_timer	*dyn_tick;
-#endif
-};
-
-#ifdef CONFIG_NO_IDLE_HZ
-
-#define DYN_TICK_ENABLED	(1 << 1)
-
-struct dyn_tick_timer {
-	spinlock_t	lock;
-	unsigned int	state;			/* Current state */
-	int		(*enable)(void);	/* Enables dynamic tick */
-	int		(*disable)(void);	/* Disables dynamic tick */
-	void		(*reprogram)(unsigned long); /* Reprograms the timer */
-	int		(*handler)(int, void *);
 };
 
-void timer_dyn_reprogram(void);
-#else
-#define timer_dyn_reprogram()	do { } while (0)
-#endif
-
 extern struct sys_timer *system_timer;
 extern void timer_tick(void);
 
