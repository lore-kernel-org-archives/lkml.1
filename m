Return-Path: <linux-kernel-owner+w=401wt.eu-S932392AbXGNXGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392AbXGNXGZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 19:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764529AbXGNXGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 19:06:17 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:39704 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764429AbXGNXGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 19:06:17 -0400
Date: Sat, 14 Jul 2007 19:01:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 3/8] Immediate Values - Non Optimized Architectures
Message-ID: <20070714230109.GD18674@Krystal>
References: <20070714012439.285079881@polymtl.ca> <20070714012623.528545293@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070714012623.528545293@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:59:35 up 7 days, 13:04,  2 users,  load average: 0.79, 0.61, 0.34
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Should be dropped, following Christoph's advice.

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> Architecture agnostic, generic, version of the immediate values. It uses a
> global variable to mimic the immediate values.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> ---
>  include/asm-alpha/immediate.h     |    1 +
>  include/asm-arm/immediate.h       |    1 +
>  include/asm-arm26/immediate.h     |    1 +
>  include/asm-blackfin/immediate.h  |    1 +
>  include/asm-cris/immediate.h      |    1 +
>  include/asm-frv/immediate.h       |    1 +
>  include/asm-generic/immediate.h   |   19 +++++++++++++++++++
>  include/asm-h8300/immediate.h     |    1 +
>  include/asm-i386/immediate.h      |    1 +
>  include/asm-ia64/immediate.h      |    1 +
>  include/asm-m32r/immediate.h      |    1 +
>  include/asm-m68k/immediate.h      |    1 +
>  include/asm-m68knommu/immediate.h |    1 +
>  include/asm-mips/immediate.h      |    1 +
>  include/asm-parisc/immediate.h    |    1 +
>  include/asm-powerpc/immediate.h   |    1 +
>  include/asm-ppc/immediate.h       |    1 +
>  include/asm-s390/immediate.h      |    1 +
>  include/asm-sh/immediate.h        |    1 +
>  include/asm-sh64/immediate.h      |    1 +
>  include/asm-sparc/immediate.h     |    1 +
>  include/asm-sparc64/immediate.h   |    1 +
>  include/asm-um/immediate.h        |    1 +
>  include/asm-v850/immediate.h      |    1 +
>  include/asm-x86_64/immediate.h    |    1 +
>  include/asm-xtensa/immediate.h    |    1 +
>  26 files changed, 44 insertions(+)
> 
> Index: linux-2.6-lttng/include/asm-generic/immediate.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/asm-generic/immediate.h	2007-07-13 19:30:52.000000000 -0400
> @@ -0,0 +1,19 @@
> +#ifndef _ASM_GENERIC_IMMEDIATE_H
> +#define _ASM_GENERIC_IMMEDIATE_H
> +
> +/*
> + * Generic immediate values: a simple, standard, memory load.
> + */
> +
> +struct module;
> +
> +#define immediate_read(var)		_immediate_read(var)
> +#define immediate_set(var, i)		((var)->value = (i))
> +#define _immediate_set(var, i)		immediate_set(var, i)
> +#define immediate_set_early(var, i)	immediate_set(var, i)
> +#define immediate_if(var)		if (immediate_read(var))
> +
> +static inline void module_immediate_setup(struct module *mod) { }
> +static inline void immediate_update_early(void) { }
> +
> +#endif /* _ASM_GENERIC_IMMEDIATE_H */
> Index: linux-2.6-lttng/include/asm-alpha/immediate.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/asm-alpha/immediate.h	2007-07-13 19:30:52.000000000 -0400
> @@ -0,0 +1 @@
> +#include <asm-generic/immediate.h>
> Index: linux-2.6-lttng/include/asm-arm/immediate.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/asm-arm/immediate.h	2007-07-13 19:30:52.000000000 -0400
> @@ -0,0 +1 @@
> +#include <asm-generic/immediate.h>
> Index: linux-2.6-lttng/include/asm-arm26/immediate.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/asm-arm26/immediate.h	2007-07-13 19:30:52.000000000 -0400
> @@ -0,0 +1 @@
> +#include <asm-generic/immediate.h>
> Index: linux-2.6-lttng/include/asm-cris/immediate.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/asm-cris/immediate.h	2007-07-13 19:30:52.000000000 -0400
> @@ -0,0 +1 @@
> +#include <asm-generic/immediate.h>
> Index: linux-2.6-lttng/include/asm-frv/immediate.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/asm-frv/immediate.h	2007-07-13 19:30:52.000000000 -0400
> @@ -0,0 +1 @@
> +#include <asm-generic/immediate.h>
> Index: linux-2.6-lttng/include/asm-h8300/immediate.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/asm-h8300/immediate.h	2007-07-13 19:30:52.000000000 -0400
> @@ -0,0 +1 @@
> +#include <asm-generic/immediate.h>
> Index: linux-2.6-lttng/include/asm-ia64/immediate.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/asm-ia64/immediate.h	2007-07-13 19:30:52.000000000 -0400
> @@ -0,0 +1 @@
> +#include <asm-generic/immediate.h>
> Index: linux-2.6-lttng/include/asm-m32r/immediate.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/asm-m32r/immediate.h	2007-07-13 19:30:52.000000000 -0400
> @@ -0,0 +1 @@
> +#include <asm-generic/immediate.h>
> Index: linux-2.6-lttng/include/asm-m68k/immediate.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/asm-m68k/immediate.h	2007-07-13 19:30:52.000000000 -0400
> @@ -0,0 +1 @@
> +#include <asm-generic/immediate.h>
> Index: linux-2.6-lttng/include/asm-m68knommu/immediate.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/asm-m68knommu/immediate.h	2007-07-13 19:30:52.000000000 -0400
> @@ -0,0 +1 @@
> +#include <asm-generic/immediate.h>
> Index: linux-2.6-lttng/include/asm-mips/immediate.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/asm-mips/immediate.h	2007-07-13 19:30:52.000000000 -0400
> @@ -0,0 +1 @@
> +#include <asm-generic/immediate.h>
> Index: linux-2.6-lttng/include/asm-parisc/immediate.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/asm-parisc/immediate.h	2007-07-13 19:30:52.000000000 -0400
> @@ -0,0 +1 @@
> +#include <asm-generic/immediate.h>
> Index: linux-2.6-lttng/include/asm-ppc/immediate.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/asm-ppc/immediate.h	2007-07-13 19:30:52.000000000 -0400
> @@ -0,0 +1 @@
> +#include <asm-generic/immediate.h>
> Index: linux-2.6-lttng/include/asm-s390/immediate.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/asm-s390/immediate.h	2007-07-13 19:30:52.000000000 -0400
> @@ -0,0 +1 @@
> +#include <asm-generic/immediate.h>
> Index: linux-2.6-lttng/include/asm-sh/immediate.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/asm-sh/immediate.h	2007-07-13 19:30:52.000000000 -0400
> @@ -0,0 +1 @@
> +#include <asm-generic/immediate.h>
> Index: linux-2.6-lttng/include/asm-sh64/immediate.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/asm-sh64/immediate.h	2007-07-13 19:30:52.000000000 -0400
> @@ -0,0 +1 @@
> +#include <asm-generic/immediate.h>
> Index: linux-2.6-lttng/include/asm-sparc/immediate.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/asm-sparc/immediate.h	2007-07-13 19:30:52.000000000 -0400
> @@ -0,0 +1 @@
> +#include <asm-generic/immediate.h>
> Index: linux-2.6-lttng/include/asm-sparc64/immediate.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/asm-sparc64/immediate.h	2007-07-13 19:30:52.000000000 -0400
> @@ -0,0 +1 @@
> +#include <asm-generic/immediate.h>
> Index: linux-2.6-lttng/include/asm-um/immediate.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/asm-um/immediate.h	2007-07-13 19:30:52.000000000 -0400
> @@ -0,0 +1 @@
> +#include <asm-generic/immediate.h>
> Index: linux-2.6-lttng/include/asm-v850/immediate.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/asm-v850/immediate.h	2007-07-13 19:30:52.000000000 -0400
> @@ -0,0 +1 @@
> +#include <asm-generic/immediate.h>
> Index: linux-2.6-lttng/include/asm-x86_64/immediate.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/asm-x86_64/immediate.h	2007-07-13 19:30:52.000000000 -0400
> @@ -0,0 +1 @@
> +#include <asm-generic/immediate.h>
> Index: linux-2.6-lttng/include/asm-xtensa/immediate.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/asm-xtensa/immediate.h	2007-07-13 19:30:52.000000000 -0400
> @@ -0,0 +1 @@
> +#include <asm-generic/immediate.h>
> Index: linux-2.6-lttng/include/asm-i386/immediate.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/asm-i386/immediate.h	2007-07-13 20:02:08.000000000 -0400
> @@ -0,0 +1 @@
> +#include <asm-generic/immediate.h>
> Index: linux-2.6-lttng/include/asm-powerpc/immediate.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/asm-powerpc/immediate.h	2007-07-13 20:02:08.000000000 -0400
> @@ -0,0 +1 @@
> +#include <asm-generic/immediate.h>
> Index: linux-2.6-lttng/include/asm-blackfin/immediate.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/asm-blackfin/immediate.h	2007-07-13 20:02:35.000000000 -0400
> @@ -0,0 +1 @@
> +#include <asm-generic/immediate.h>
> 
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
