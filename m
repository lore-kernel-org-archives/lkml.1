Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbYAXWDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbYAXWDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756536AbYAXWDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 17:03:32 -0500
Received: from tomts16.bellnexxia.net ([209.226.175.4]:64328 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755612AbYAXWDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:03:30 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAKaZmEdMQWYq/2dsb2JhbACBV5AfnTs
Date: Thu, 24 Jan 2008 17:03:26 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 03/26] Move Kconfig.instrumentation to arch/Kconfig and
	init/Kconfig
Message-ID: <20080124220325.GA4622@Krystal>
References: <20080124202706.250598537@polymtl.ca> <20080124203333.499728934@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080124203333.499728934@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:02:30 up 82 days,  3:07,  6 users,  load average: 2.18, 2.34,
	1.41
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> Move the instrumentation Kconfig to
> 
> arch/Kconfig for architecture dependent options
>   - oprofile
>   - kprobes
> 
> and
> 
> init/Kconfig for architecture independent options
>   - profiling
>   - markers
> 
> Remove the "Instrumentation Support" menu. Everything moves to "General setup".
> Delete the kernel/Kconfig.instrumentation file.
> 

Please wait for updated version. Waiting for the next ARM merge adding
kprobes to ARM, which will likely break this.

> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> CC: Sam Ravnborg <sam@ravnborg.org>
> ---
>  arch/Kconfig                   |   28 ++++++++++++++++++++
>  arch/alpha/Kconfig             |    2 -
>  arch/arm/Kconfig               |    2 -
>  arch/blackfin/Kconfig          |    2 -
>  arch/cris/Kconfig              |    2 -
>  arch/frv/Kconfig               |    2 -
>  arch/h8300/Kconfig             |    2 -
>  arch/ia64/Kconfig              |    2 -
>  arch/m32r/Kconfig              |    2 -
>  arch/m68k/Kconfig              |    2 -
>  arch/m68knommu/Kconfig         |    2 -
>  arch/mips/Kconfig              |    2 -
>  arch/parisc/Kconfig            |    2 -
>  arch/powerpc/Kconfig           |    2 -
>  arch/ppc/Kconfig               |    2 -
>  arch/s390/Kconfig              |    2 -
>  arch/sh/Kconfig                |    2 -
>  arch/sh64/Kconfig              |    2 -
>  arch/sparc/Kconfig             |    2 -
>  arch/sparc64/Kconfig           |    2 -
>  arch/um/Kconfig                |    2 -
>  arch/v850/Kconfig              |    2 -
>  arch/x86/Kconfig               |    2 -
>  arch/xtensa/Kconfig            |    2 -
>  init/Kconfig                   |   12 ++++++++
>  kernel/Kconfig.instrumentation |   55 -----------------------------------------
>  26 files changed, 40 insertions(+), 101 deletions(-)
> 
> Index: linux-2.6-lttng.mm/arch/Kconfig
> ===================================================================
> --- linux-2.6-lttng.mm.orig/arch/Kconfig	2008-01-24 14:10:37.000000000 -0500
> +++ linux-2.6-lttng.mm/arch/Kconfig	2008-01-24 14:20:06.000000000 -0500
> @@ -1,3 +1,31 @@
>  #
>  # General architecture dependent options
>  #
> +
> +config OPROFILE
> +	tristate "OProfile system profiling (EXPERIMENTAL)"
> +	depends on PROFILING
> +	depends on HAVE_OPROFILE
> +	help
> +	  OProfile is a profiling system capable of profiling the
> +	  whole system, include the kernel, kernel modules, libraries,
> +	  and applications.
> +
> +	  If unsure, say N.
> +
> +config HAVE_OPROFILE
> +	def_bool n
> +
> +config KPROBES
> +	bool "Kprobes"
> +	depends on KALLSYMS && MODULES
> +	depends on HAVE_KPROBES
> +	help
> +	  Kprobes allows you to trap at almost any kernel address and
> +	  execute a callback function.  register_kprobe() establishes
> +	  a probepoint and specifies the callback.  Kprobes is useful
> +	  for kernel debugging, non-intrusive instrumentation and testing.
> +	  If in doubt, say "N".
> +
> +config HAVE_KPROBES
> +	def_bool n
> Index: linux-2.6-lttng.mm/init/Kconfig
> ===================================================================
> --- linux-2.6-lttng.mm.orig/init/Kconfig	2008-01-24 14:10:55.000000000 -0500
> +++ linux-2.6-lttng.mm/init/Kconfig	2008-01-24 14:18:34.000000000 -0500
> @@ -702,6 +702,18 @@ config PROC_PAGE_MONITOR
>  	  /proc/kpagecount, and /proc/kpageflags. Disabling these
>            interfaces will reduce the size of the kernel by approximately 4kb.
>  
> +config PROFILING
> +	bool "Profiling support (EXPERIMENTAL)"
> +	help
> +	  Say Y here to enable the extended profiling support mechanisms used
> +	  by profilers such as OProfile.
> +
> +config MARKERS
> +	bool "Activate markers"
> +	help
> +	  Place an empty function call at each marker site. Can be
> +	  dynamically changed for a probe function.
> +
>  source "arch/Kconfig"
>  
>  endmenu		# General setup
> Index: linux-2.6-lttng.mm/arch/alpha/Kconfig
> ===================================================================
> --- linux-2.6-lttng.mm.orig/arch/alpha/Kconfig	2008-01-24 14:10:37.000000000 -0500
> +++ linux-2.6-lttng.mm/arch/alpha/Kconfig	2008-01-24 14:18:34.000000000 -0500
> @@ -653,8 +653,6 @@ source "drivers/Kconfig"
>  
>  source "fs/Kconfig"
>  
> -source "kernel/Kconfig.instrumentation"
> -
>  source "arch/alpha/Kconfig.debug"
>  
>  # DUMMY_CONSOLE may be defined in drivers/video/console/Kconfig
> Index: linux-2.6-lttng.mm/arch/arm/Kconfig
> ===================================================================
> --- linux-2.6-lttng.mm.orig/arch/arm/Kconfig	2008-01-24 14:18:00.000000000 -0500
> +++ linux-2.6-lttng.mm/arch/arm/Kconfig	2008-01-24 14:18:34.000000000 -0500
> @@ -1149,8 +1149,6 @@ endmenu
>  
>  source "fs/Kconfig"
>  
> -source "kernel/Kconfig.instrumentation"
> -
>  source "arch/arm/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng.mm/arch/blackfin/Kconfig
> ===================================================================
> --- linux-2.6-lttng.mm.orig/arch/blackfin/Kconfig	2008-01-24 14:10:39.000000000 -0500
> +++ linux-2.6-lttng.mm/arch/blackfin/Kconfig	2008-01-24 14:18:34.000000000 -0500
> @@ -1003,8 +1003,6 @@ source "drivers/Kconfig"
>  
>  source "fs/Kconfig"
>  
> -source "kernel/Kconfig.instrumentation"
> -
>  source "arch/blackfin/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng.mm/arch/cris/Kconfig
> ===================================================================
> --- linux-2.6-lttng.mm.orig/arch/cris/Kconfig	2008-01-24 14:10:39.000000000 -0500
> +++ linux-2.6-lttng.mm/arch/cris/Kconfig	2008-01-24 14:18:34.000000000 -0500
> @@ -214,8 +214,6 @@ source "drivers/pci/Kconfig"
>  
>  source "drivers/usb/Kconfig"
>  
> -source "kernel/Kconfig.instrumentation"
> -
>  source "arch/cris/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng.mm/arch/frv/Kconfig
> ===================================================================
> --- linux-2.6-lttng.mm.orig/arch/frv/Kconfig	2008-01-24 14:10:39.000000000 -0500
> +++ linux-2.6-lttng.mm/arch/frv/Kconfig	2008-01-24 14:18:34.000000000 -0500
> @@ -384,8 +384,6 @@ source "drivers/Kconfig"
>  
>  source "fs/Kconfig"
>  
> -source "kernel/Kconfig.instrumentation"
> -
>  source "arch/frv/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng.mm/arch/h8300/Kconfig
> ===================================================================
> --- linux-2.6-lttng.mm.orig/arch/h8300/Kconfig	2008-01-24 14:10:39.000000000 -0500
> +++ linux-2.6-lttng.mm/arch/h8300/Kconfig	2008-01-24 14:18:34.000000000 -0500
> @@ -226,8 +226,6 @@ endmenu
>  
>  source "fs/Kconfig"
>  
> -source "kernel/Kconfig.instrumentation"
> -
>  source "arch/h8300/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng.mm/arch/ia64/Kconfig
> ===================================================================
> --- linux-2.6-lttng.mm.orig/arch/ia64/Kconfig	2008-01-24 14:10:39.000000000 -0500
> +++ linux-2.6-lttng.mm/arch/ia64/Kconfig	2008-01-24 14:18:34.000000000 -0500
> @@ -602,8 +602,6 @@ config IRQ_PER_CPU
>  
>  source "arch/ia64/hp/sim/Kconfig"
>  
> -source "kernel/Kconfig.instrumentation"
> -
>  source "arch/ia64/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng.mm/arch/m32r/Kconfig
> ===================================================================
> --- linux-2.6-lttng.mm.orig/arch/m32r/Kconfig	2008-01-24 14:10:39.000000000 -0500
> +++ linux-2.6-lttng.mm/arch/m32r/Kconfig	2008-01-24 14:18:34.000000000 -0500
> @@ -430,8 +430,6 @@ source "drivers/Kconfig"
>  
>  source "fs/Kconfig"
>  
> -source "kernel/Kconfig.instrumentation"
> -
>  source "arch/m32r/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng.mm/arch/m68k/Kconfig
> ===================================================================
> --- linux-2.6-lttng.mm.orig/arch/m68k/Kconfig	2008-01-24 14:10:39.000000000 -0500
> +++ linux-2.6-lttng.mm/arch/m68k/Kconfig	2008-01-24 14:18:34.000000000 -0500
> @@ -667,8 +667,6 @@ endmenu
>  
>  source "fs/Kconfig"
>  
> -source "kernel/Kconfig.instrumentation"
> -
>  source "arch/m68k/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng.mm/arch/m68knommu/Kconfig
> ===================================================================
> --- linux-2.6-lttng.mm.orig/arch/m68knommu/Kconfig	2008-01-24 14:10:39.000000000 -0500
> +++ linux-2.6-lttng.mm/arch/m68knommu/Kconfig	2008-01-24 14:18:34.000000000 -0500
> @@ -710,8 +710,6 @@ source "drivers/Kconfig"
>  
>  source "fs/Kconfig"
>  
> -source "kernel/Kconfig.instrumentation"
> -
>  source "arch/m68knommu/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng.mm/arch/mips/Kconfig
> ===================================================================
> --- linux-2.6-lttng.mm.orig/arch/mips/Kconfig	2008-01-24 14:10:39.000000000 -0500
> +++ linux-2.6-lttng.mm/arch/mips/Kconfig	2008-01-24 14:18:34.000000000 -0500
> @@ -2096,8 +2096,6 @@ source "drivers/Kconfig"
>  
>  source "fs/Kconfig"
>  
> -source "kernel/Kconfig.instrumentation"
> -
>  source "arch/mips/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng.mm/arch/parisc/Kconfig
> ===================================================================
> --- linux-2.6-lttng.mm.orig/arch/parisc/Kconfig	2008-01-24 14:10:40.000000000 -0500
> +++ linux-2.6-lttng.mm/arch/parisc/Kconfig	2008-01-24 14:18:34.000000000 -0500
> @@ -276,8 +276,6 @@ source "drivers/Kconfig"
>  
>  source "fs/Kconfig"
>  
> -source "kernel/Kconfig.instrumentation"
> -
>  source "arch/parisc/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng.mm/arch/powerpc/Kconfig
> ===================================================================
> --- linux-2.6-lttng.mm.orig/arch/powerpc/Kconfig	2008-01-24 14:10:40.000000000 -0500
> +++ linux-2.6-lttng.mm/arch/powerpc/Kconfig	2008-01-24 14:18:34.000000000 -0500
> @@ -713,8 +713,6 @@ source "arch/powerpc/sysdev/qe_lib/Kconf
>  
>  source "lib/Kconfig"
>  
> -source "kernel/Kconfig.instrumentation"
> -
>  source "arch/powerpc/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng.mm/arch/ppc/Kconfig
> ===================================================================
> --- linux-2.6-lttng.mm.orig/arch/ppc/Kconfig	2008-01-24 14:10:41.000000000 -0500
> +++ linux-2.6-lttng.mm/arch/ppc/Kconfig	2008-01-24 14:18:34.000000000 -0500
> @@ -1319,8 +1319,6 @@ endmenu
>  
>  source "lib/Kconfig"
>  
> -source "kernel/Kconfig.instrumentation"
> -
>  source "arch/ppc/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng.mm/arch/s390/Kconfig
> ===================================================================
> --- linux-2.6-lttng.mm.orig/arch/s390/Kconfig	2008-01-24 14:10:41.000000000 -0500
> +++ linux-2.6-lttng.mm/arch/s390/Kconfig	2008-01-24 14:18:34.000000000 -0500
> @@ -528,8 +528,6 @@ source "drivers/Kconfig"
>  
>  source "fs/Kconfig"
>  
> -source "kernel/Kconfig.instrumentation"
> -
>  source "arch/s390/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng.mm/arch/sh/Kconfig
> ===================================================================
> --- linux-2.6-lttng.mm.orig/arch/sh/Kconfig	2008-01-24 14:10:41.000000000 -0500
> +++ linux-2.6-lttng.mm/arch/sh/Kconfig	2008-01-24 14:18:34.000000000 -0500
> @@ -899,8 +899,6 @@ source "drivers/Kconfig"
>  
>  source "fs/Kconfig"
>  
> -source "kernel/Kconfig.instrumentation"
> -
>  source "arch/sh/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng.mm/arch/sh64/Kconfig
> ===================================================================
> --- linux-2.6-lttng.mm.orig/arch/sh64/Kconfig	2008-01-24 14:10:41.000000000 -0500
> +++ linux-2.6-lttng.mm/arch/sh64/Kconfig	2008-01-24 14:18:34.000000000 -0500
> @@ -279,8 +279,6 @@ source "drivers/Kconfig"
>  
>  source "fs/Kconfig"
>  
> -source "kernel/Kconfig.instrumentation"
> -
>  source "arch/sh64/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng.mm/arch/sparc/Kconfig
> ===================================================================
> --- linux-2.6-lttng.mm.orig/arch/sparc/Kconfig	2008-01-24 14:10:41.000000000 -0500
> +++ linux-2.6-lttng.mm/arch/sparc/Kconfig	2008-01-24 14:18:34.000000000 -0500
> @@ -324,8 +324,6 @@ endmenu
>  
>  source "fs/Kconfig"
>  
> -source "kernel/Kconfig.instrumentation"
> -
>  source "arch/sparc/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng.mm/arch/sparc64/Kconfig
> ===================================================================
> --- linux-2.6-lttng.mm.orig/arch/sparc64/Kconfig	2008-01-24 14:10:41.000000000 -0500
> +++ linux-2.6-lttng.mm/arch/sparc64/Kconfig	2008-01-24 14:18:34.000000000 -0500
> @@ -470,8 +470,6 @@ source "drivers/sbus/char/Kconfig"
>  
>  source "fs/Kconfig"
>  
> -source "kernel/Kconfig.instrumentation"
> -
>  source "arch/sparc64/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng.mm/arch/um/Kconfig
> ===================================================================
> --- linux-2.6-lttng.mm.orig/arch/um/Kconfig	2008-01-24 14:10:42.000000000 -0500
> +++ linux-2.6-lttng.mm/arch/um/Kconfig	2008-01-24 14:18:34.000000000 -0500
> @@ -271,6 +271,4 @@ config INPUT
>  	bool
>  	default n
>  
> -source "kernel/Kconfig.instrumentation"
> -
>  source "arch/um/Kconfig.debug"
> Index: linux-2.6-lttng.mm/arch/v850/Kconfig
> ===================================================================
> --- linux-2.6-lttng.mm.orig/arch/v850/Kconfig	2008-01-24 14:10:42.000000000 -0500
> +++ linux-2.6-lttng.mm/arch/v850/Kconfig	2008-01-24 14:18:34.000000000 -0500
> @@ -334,8 +334,6 @@ source "sound/Kconfig"
>  
>  source "drivers/usb/Kconfig"
>  
> -source "kernel/Kconfig.instrumentation"
> -
>  source "arch/v850/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng.mm/arch/xtensa/Kconfig
> ===================================================================
> --- linux-2.6-lttng.mm.orig/arch/xtensa/Kconfig	2008-01-24 14:10:42.000000000 -0500
> +++ linux-2.6-lttng.mm/arch/xtensa/Kconfig	2008-01-24 14:18:34.000000000 -0500
> @@ -246,8 +246,6 @@ config EMBEDDED_RAMDISK_IMAGE
>  	  provide one yourself.
>  endmenu
>  
> -source "kernel/Kconfig.instrumentation"
> -
>  source "arch/xtensa/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng.mm/arch/x86/Kconfig
> ===================================================================
> --- linux-2.6-lttng.mm.orig/arch/x86/Kconfig	2008-01-24 14:10:42.000000000 -0500
> +++ linux-2.6-lttng.mm/arch/x86/Kconfig	2008-01-24 14:18:34.000000000 -0500
> @@ -1609,8 +1609,6 @@ source "drivers/firmware/Kconfig"
>  
>  source "fs/Kconfig"
>  
> -source "kernel/Kconfig.instrumentation"
> -
>  source "arch/x86/Kconfig.debug"
>  
>  source "security/Kconfig"
> Index: linux-2.6-lttng.mm/kernel/Kconfig.instrumentation
> ===================================================================
> --- linux-2.6-lttng.mm.orig/kernel/Kconfig.instrumentation	2008-01-24 14:10:55.000000000 -0500
> +++ /dev/null	1970-01-01 00:00:00.000000000 +0000
> @@ -1,55 +0,0 @@
> -menuconfig INSTRUMENTATION
> -	bool "Instrumentation Support"
> -	default y
> -	---help---
> -	  Say Y here to get to see options related to performance measurement,
> -	  system-wide debugging, and testing. This option alone does not add any
> -	  kernel code.
> -
> -	  If you say N, all options in this submenu will be skipped and
> -	  disabled. If you're trying to debug the kernel itself, go see the
> -	  Kernel Hacking menu.
> -
> -if INSTRUMENTATION
> -
> -config PROFILING
> -	bool "Profiling support (EXPERIMENTAL)"
> -	help
> -	  Say Y here to enable the extended profiling support mechanisms used
> -	  by profilers such as OProfile.
> -
> -config OPROFILE
> -	tristate "OProfile system profiling (EXPERIMENTAL)"
> -	depends on PROFILING
> -	depends on HAVE_OPROFILE
> -	help
> -	  OProfile is a profiling system capable of profiling the
> -	  whole system, include the kernel, kernel modules, libraries,
> -	  and applications.
> -
> -	  If unsure, say N.
> -
> -config HAVE_OPROFILE
> -	def_bool n
> -
> -config KPROBES
> -	bool "Kprobes"
> -	depends on KALLSYMS && MODULES
> -	depends on HAVE_KPROBES
> -	help
> -	  Kprobes allows you to trap at almost any kernel address and
> -	  execute a callback function.  register_kprobe() establishes
> -	  a probepoint and specifies the callback.  Kprobes is useful
> -	  for kernel debugging, non-intrusive instrumentation and testing.
> -	  If in doubt, say "N".
> -
> -config HAVE_KPROBES
> -	def_bool n
> -
> -config MARKERS
> -	bool "Activate markers"
> -	help
> -	  Place an empty function call at each marker site. Can be
> -	  dynamically changed for a probe function.
> -
> -endif # INSTRUMENTATION
> 
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
