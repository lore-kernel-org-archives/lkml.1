Return-Path: <linux-kernel-owner+w=401wt.eu-S964930AbXIFXjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964930AbXIFXjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 19:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932657AbXIFXjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 19:39:13 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:33223 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638AbXIFXjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 19:39:12 -0400
Date: Thu, 6 Sep 2007 16:35:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [patch 2/6] Linux Kernel Markers - Add kconfig menus for the
 marker code
Message-Id: <20070906163501.87420a01.randy.dunlap@oracle.com>
In-Reply-To: <20070906200826.196017807@polymtl.ca>
References: <20070906200733.194442762@polymtl.ca>
	<20070906200826.196017807@polymtl.ca>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Sep 2007 16:07:35 -0400 Mathieu Desnoyers wrote:

[snip]

> This patch:
> 
> Add Kconfig menus for the marker code.
> 
> [bunk@stusta.de: Never ever select MODULES]
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Reviewed-by: Christoph Hellwig <hch@infradead.org>
> Reviewed-by: "Frank Ch. Eigler" <fche@redhat.com>
> CC: Adrian Bunk <bunk@stusta.de>
> ---
> 
>  arch/alpha/Kconfig       |    2 ++
>  arch/arm/Kconfig         |    2 ++
>  arch/avr32/Kconfig.debug |    7 +++++++
>  arch/cris/Kconfig        |    2 ++
>  arch/frv/Kconfig         |    2 ++
>  arch/h8300/Kconfig       |    2 ++
>  arch/i386/Kconfig        |    2 ++
>  arch/ia64/Kconfig        |    2 ++
>  arch/m32r/Kconfig        |    2 ++
>  arch/m68k/Kconfig        |    2 ++
>  arch/m68knommu/Kconfig   |    2 ++
>  arch/mips/Kconfig        |    2 ++
>  arch/parisc/Kconfig      |    2 ++
>  arch/powerpc/Kconfig     |    2 ++
>  arch/ppc/Kconfig         |    2 ++
>  arch/s390/Kconfig        |    2 ++
>  arch/sh/Kconfig          |    2 ++
>  arch/sh64/Kconfig        |    2 ++
>  arch/sparc/Kconfig       |    2 ++
>  arch/sparc64/Kconfig     |    2 ++
>  arch/um/Kconfig          |    2 ++
>  arch/v850/Kconfig        |    2 ++
>  arch/x86_64/Kconfig      |    2 ++
>  arch/xtensa/Kconfig      |    2 ++
>  kernel/Kconfig.marker    |    7 +++++++
>  kernel/Makefile          |    1 +
>  26 files changed, 61 insertions(+)
> 
> Index: linux-2.6-lttng/arch/alpha/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/arch/alpha/Kconfig	2007-09-04 12:14:48.000000000 -0400
> +++ linux-2.6-lttng/arch/alpha/Kconfig	2007-09-04 12:16:57.000000000 -0400
> @@ -646,6 +646,8 @@ config SRM_ENV
>  
>  source "fs/Kconfig.binfmt"
>  
> +source "kernel/Kconfig.marker"
> +
>  endmenu
>  
>  source "net/Kconfig"
> Index: linux-2.6-lttng/kernel/Kconfig.marker
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/kernel/Kconfig.marker	2007-09-04 12:16:57.000000000 -0400
> @@ -0,0 +1,7 @@
> +# Code markers configuration
> +
> +config MARKERS
> +	bool "Activate markers"
> +	help
> +	  Place an empty function call at each marker site. Can be
> +	  dynamically changed for a probe function.
> Index: linux-2.6-lttng/arch/avr32/Kconfig.debug
> ===================================================================
> --- linux-2.6-lttng.orig/arch/avr32/Kconfig.debug	2007-09-04 12:14:49.000000000 -0400
> +++ linux-2.6-lttng/arch/avr32/Kconfig.debug	2007-09-04 12:16:57.000000000 -0400
> @@ -6,6 +6,9 @@ config TRACE_IRQFLAGS_SUPPORT
>  
>  source "lib/Kconfig.debug"
>  
> +menu "Instrumentation Support"
> +	depends on EXPERIMENTAL
> +
>  config KPROBES
>  	bool "Kprobes"
>  	depends on DEBUG_KERNEL
> @@ -16,4 +19,8 @@ config KPROBES
>            for kernel debugging, non-intrusive instrumentation and testing.
>            If in doubt, say "N".
>  
> +source "kernel/Kconfig.marker"
> +
> +endmenu
> +
>  endmenu

It seems sad that this patch sources Kconfig.marker, a 7-line file,
20-something times.  Yes, you (we) don't want to put those 7 lines
into 20-something different files, so sourcing is the right thing.

However, what you did for avr32 seems more on the right track to me:
make _one_ Instrumentation support menu that includes PROFILING,
OPROFILE, KPROBES, and MARKERS and then use (source) that in all
of the arches.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
