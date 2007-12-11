Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbXLKOkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbXLKOkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 09:40:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750785AbXLKOj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 09:39:56 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:42194 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750705AbXLKOj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 09:39:56 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAB4vXkdMROHU/2dsb2JhbACBWg
Date: Tue, 11 Dec 2007 09:39:53 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: akpm@linux-foundation.org, lkml <linux-kernel@vger.kernel.org>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       davem@davemloft.net, hskinnemoen@atmel.com, sam@ravnborg.org
Subject: Re: [PATCH 2/2 V2] Kprobes: Build kretprobe examples only if arch
	supports kretprobes
Message-ID: <20071211143953.GA19562@Krystal>
References: <20071211062219.GA10166@in.ibm.com> <20071211062402.GB10166@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071211062402.GB10166@in.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:39:37 up 37 days, 19:45,  5 users,  load average: 0.96, 0.57,
	0.43
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ananth N Mavinakayanahalli (ananth@in.ibm.com) wrote:
> From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> 
> This patch builds samples/kprobes/kretprobe_example.c only on archs that
> support kretprobes. Thanks to Sam Ravnborg for Kconfig suggestions.
> 
> V2: Updated dependency on CONFIG_KRETPROBES
> 
> Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

> ---
>  samples/Kconfig          |    5 +++++
>  samples/kprobes/Makefile |    4 ++--
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.24-rc4/samples/kprobes/Makefile
> ===================================================================
> --- linux-2.6.24-rc4.orig/samples/kprobes/Makefile
> +++ linux-2.6.24-rc4/samples/kprobes/Makefile
> @@ -1,5 +1,5 @@
>  # builds the kprobes example kernel modules;
>  # then to use one (as root):  insmod <module_name.ko>
>  
> -obj-$(CONFIG_SAMPLE_KPROBES) += kprobe_example.o jprobe_example.o \
> -		kretprobe_example.o
> +obj-$(CONFIG_SAMPLE_KPROBES) += kprobe_example.o jprobe_example.o
> +obj-$(CONFIG_SAMPLE_KRETPROBES) += kretprobe_example.o
> Index: linux-2.6.24-rc4/samples/Kconfig
> ===================================================================
> --- linux-2.6.24-rc4.orig/samples/Kconfig
> +++ linux-2.6.24-rc4/samples/Kconfig
> @@ -28,5 +28,10 @@ config SAMPLE_KPROBES
>  	help
>  	  This build several kprobes example modules.
>  
> +config SAMPLE_KRETPROBES
> +	tristate "Build kretprobes example -- loadable modules only"
> +	default m
> +	depends on SAMPLE_KPROBES && KRETPROBES
> +
>  endif # SAMPLES
>  

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
