Return-Path: <linux-kernel-owner+w=401wt.eu-S1758001AbYBXR75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001AbYBXR75 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 12:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbYBXR7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 12:59:47 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:52436 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbYBXR7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 12:59:46 -0500
Date: Sun, 24 Feb 2008 18:59:55 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Pekka Paalanen <pq@iki.fi>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Roskin <proski@gnu.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] mmiotrace full patch, preview 1
Message-ID: <20080224175955.GB10712@uranus.ravnborg.org>
References: <20080224190323.77adf683@daedalus.pq.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080224190323.77adf683@daedalus.pq.iki.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka.

A small nitpick..
>  
> +config MMIOTRACE_HOOKS
> +	bool
> +	default n
n is default so no need to be explicit.
If you prefer being explcit then use:

	def_bool n

> +config MMIOTRACE
> +	tristate "Memory mapped IO tracing"
> +	depends on DEBUG_KERNEL && RELAY && DEBUG_FS
> +	select MMIOTRACE_HOOKS
> +	default n
Same here.


> +	help
> +	  This will build a kernel module called mmiotrace.
> +	  Making this a built-in is heavily discouraged.
> +
> +	  Mmiotrace traces Memory Mapped I/O access and is meant for debugging
> +	  and reverse engineering. The kernel module offers wrapped
> +	  versions of the ioremap family of functions. The driver to be traced
> +	  must be modified to call these wrappers. A user space program is
> +	  required to collect the MMIO data.
> +
> +	  See http://nouveau.freedesktop.org/wiki/MmioTrace
> +	  If you are not helping to develop drivers, say N.
> +
> +config MMIOTRACE_TEST
> +	tristate "Test module for mmiotrace"
> +	depends on MMIOTRACE && m
> +	default n
> +	help
> +	  This is a dumb module for testing mmiotrace. It is very dangerous
> +	  as it will write garbage to IO memory starting at a given address.
> +	  However, it should be safe to use on e.g. unused portion of VRAM.
> +
> +	  Say N, unless you absolutely know what you are doing.
> +
>  #
>  # IO delay types:
>  #
> diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
> index 9832910..e182f6d 100644
> --- a/arch/x86/mm/Makefile
> +++ b/arch/x86/mm/Makefile
> @@ -3,3 +3,8 @@ include ${srctree}/arch/x86/mm/Makefile_32
>  else
>  include ${srctree}/arch/x86/mm/Makefile_64
>  endif
> +
> +obj-$(CONFIG_MMIOTRACE_HOOKS)	+= kmmio.o
> +obj-$(CONFIG_MMIOTRACE) 	+= mmiotrace.o
> +mmiotrace-objs			:= pf_in.o mmio-mod.o

Do not use '-objs' - '-y' is preferred as below:
> +mmiotrace-y				:= pf_in.o mmio-mod.o


	Sam
