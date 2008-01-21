Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbYAUUbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbYAUUbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 15:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbYAUU21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 15:28:27 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55960 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754520AbYAUU2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 15:28:22 -0500
Message-Id: <20080121202822.125953000@sgi.com>
References: <20080121202821.815918000@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 21 Jan 2008 12:28:23 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu
Cc: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] x86: Change Kconfig to HAVE_SETUP_PER_CPU_AREAF rc8-mm1-fixup with git-x86
Content-Disposition: inline; filename=x86_generic_percpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the Kconfig variable used to indicate that x86 has it's
own per_cpu area setup routine.

Based on 2.6.24-rc8-mm1 + latest (08/1/21) git-x86

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
Fixup:
    - Because of git-x86 merge, the change to using HAVE_SETUP_PER_CPU_AREA
      was dropped.  This puts it back so both versions are consistent.
---
 arch/x86/Kconfig             |    2 +-
 include/asm-generic/percpu.h |    2 +-
 init/main.c                  |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -100,7 +100,7 @@ config GENERIC_TIME_VSYSCALL
 	bool
 	default X86_64
 
-config ARCH_SETS_UP_PER_CPU_AREA
+config HAVE_SETUP_PER_CPU_AREA
 	def_bool X86_64
 
 config ARCH_SUPPORTS_OPROFILE
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -59,7 +59,7 @@ extern unsigned long __per_cpu_offset[NR
 	(*SHIFT_PERCPU_PTR(&per_cpu_var(var), __my_cpu_offset))
 
 
-#ifdef CONFIG_ARCH_SETS_UP_PER_CPU_AREA
+#ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
 extern void setup_per_cpu_areas(void);
 #endif
 
--- a/init/main.c
+++ b/init/main.c
@@ -363,7 +363,7 @@ static inline void smp_prepare_cpus(unsi
 
 #else
 
-#ifndef CONFIG_ARCH_SETS_UP_PER_CPU_AREA
+#ifndef CONFIG_HAVE_SETUP_PER_CPU_AREA
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
 
 EXPORT_SYMBOL(__per_cpu_offset);
@@ -384,7 +384,7 @@ static void __init setup_per_cpu_areas(v
 		ptr += size;
 	}
 }
-#endif /* CONFIG_ARCH_SETS_UP_CPU_AREA */
+#endif /* CONFIG_HAVE_SETUP_PER_CPU_AREA */
 
 /* Called by boot processor to activate the rest. */
 static void __init smp_init(void)

-- 
