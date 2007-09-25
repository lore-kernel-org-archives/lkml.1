Return-Path: <linux-kernel-owner+w=401wt.eu-S1759694AbXIYU7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759694AbXIYU7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 16:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbXIYU7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 16:59:17 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:15085 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbXIYU7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 16:59:16 -0400
Date: Tue, 25 Sep 2007 13:58:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Sam Ravnborg <sam@ravnborg.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 3/5] Add samples subdir (updated)
Message-Id: <20070925135813.bbaa8dff.randy.dunlap@oracle.com>
In-Reply-To: <20070925205021.GB16652@Krystal>
References: <20070925121145.262664884@polymtl.ca>
	<20070925121251.954162366@polymtl.ca>
	<20070925190036.GA14579@uranus.ravnborg.org>
	<20070925133234.cdd9edf1.randy.dunlap@oracle.com>
	<20070925205021.GB16652@Krystal>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 16:50:21 -0400 Mathieu Desnoyers wrote:

> Randy, since I did big changes to the patch, I removed your
> Signed-off-by. Tell me if you want me to add it back... (Is the From:
> still valid ?)
> 
> Mathieu

Heck, I dunno.
Just make it from you and SOB by me, if that works_for_you.


> 
> Add samples subdir (updated)
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Begin infrastructure for kernel code samples in the samples/ directory.
> Add its Kconfig and Kbuild files.
> 
> Changelog:
> - Move menu to Kernel Hacking
> - Don't build with the kernel image
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> ---
>  Makefile          |    3 +++
>  lib/Kconfig.debug |    2 ++
>  samples/Kconfig   |   11 +++++++++++
>  3 files changed, 16 insertions(+)
> 
> Index: linux-2.6-lttng/Makefile
> ===================================================================
> --- linux-2.6-lttng.orig/Makefile	2007-09-25 16:44:44.000000000 -0400
> +++ linux-2.6-lttng/Makefile	2007-09-25 16:45:13.000000000 -0400
> @@ -770,6 +770,9 @@ vmlinux: $(vmlinux-lds) $(vmlinux-init) 
>  ifdef CONFIG_HEADERS_CHECK
>  	$(Q)$(MAKE) -f $(srctree)/Makefile headers_check
>  endif
> +ifdef CONFIG_SAMPLES
> +	$(Q)$(MAKE) $(build)=samples
> +endif
>  	$(call vmlinux-modpost)
>  	$(call if_changed_rule,vmlinux__)
>  	$(Q)rm -f .old_version
> Index: linux-2.6-lttng/samples/Kconfig
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/samples/Kconfig	2007-09-25 16:45:13.000000000 -0400
> @@ -0,0 +1,11 @@
> +# samples/Kconfig
> +
> +menuconfig SAMPLES
> +	bool "Sample kernel code"
> +	help
> +	  You can build and test sample kernel code here.
> +
> +if SAMPLES
> +
> +
> +endif # SAMPLES
> Index: linux-2.6-lttng/lib/Kconfig.debug
> ===================================================================
> --- linux-2.6-lttng.orig/lib/Kconfig.debug	2007-09-25 16:44:44.000000000 -0400
> +++ linux-2.6-lttng/lib/Kconfig.debug	2007-09-25 16:45:13.000000000 -0400
> @@ -558,3 +558,5 @@ config FAULT_INJECTION_STACKTRACE_FILTER
>  	  Provide stacktrace filter for fault-injection capabilities
>  
>  source "lib/Kconfig.kgdb"
> +
> +source "samples/Kconfig"
> 
> -- 

---
~Randy
Phaedrus says that Quality is about caring.
