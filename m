Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbYJXL0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbYJXL0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 07:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbYJXLZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 07:25:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41719 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbYJXLZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 07:25:50 -0400
Date: Fri, 24 Oct 2008 13:25:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Pekka Paalanen <pq@iki.fi>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] trace: add the MMIO-tracer to the tracer menu
Message-ID: <20081024112535.GA19786@elte.hu>
References: <1224845357.4075.0.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224845357.4075.0.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> Subject: trace: add the MMIO-tracer to the tracer menu
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Fri Oct 24 12:46:04 CEST 2008
> 
> Add the MMIO-tracer to the tracer menu.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Pekka Paalanen <pq@iki.fi>
> ---
>  arch/x86/Kconfig.debug |   28 ++--------------------------
>  kernel/trace/Kconfig   |   28 ++++++++++++++++++++++++++++
>  2 files changed, 30 insertions(+), 26 deletions(-)
> 
> Index: linux-2.6/arch/x86/Kconfig.debug
> ===================================================================
> --- linux-2.6.orig/arch/x86/Kconfig.debug
> +++ linux-2.6/arch/x86/Kconfig.debug
> @@ -175,32 +175,8 @@ config IOMMU_LEAK
>  	  Add a simple leak tracer to the IOMMU code. This is useful when you
>  	  are debugging a buggy device driver that leaks IOMMU mappings.
>  
> -config MMIOTRACE_HOOKS
> -	bool
> -
> -config MMIOTRACE
> -	bool "Memory mapped IO tracing"
> -	depends on DEBUG_KERNEL && PCI
> -	select TRACING
> -	select MMIOTRACE_HOOKS
> -	help
> -	  Mmiotrace traces Memory Mapped I/O access and is meant for
> -	  debugging and reverse engineering. It is called from the ioremap
> -	  implementation and works via page faults. Tracing is disabled by
> -	  default and can be enabled at run-time.
> -
> -	  See Documentation/tracers/mmiotrace.txt.
> -	  If you are not helping to develop drivers, say N.
> -
> -config MMIOTRACE_TEST
> -	tristate "Test module for mmiotrace"
> -	depends on MMIOTRACE && m
> -	help
> -	  This is a dumb module for testing mmiotrace. It is very dangerous
> -	  as it will write garbage to IO memory starting at a given address.
> -	  However, it should be safe to use on e.g. unused portion of VRAM.
> -
> -	  Say N, unless you absolutely know what you are doing.
> +config HAVE_MMIOTRACE_SUPPORT
> +	def_bool y
>  
>  #
>  # IO delay types:
> Index: linux-2.6/kernel/trace/Kconfig
> ===================================================================
> --- linux-2.6.orig/kernel/trace/Kconfig
> +++ linux-2.6/kernel/trace/Kconfig
> @@ -194,4 +194,32 @@ config FTRACE_STARTUP_TEST
>  	  functioning properly. It will do tests on all the configured
>  	  tracers of ftrace.
>  
> +config MMIOTRACE_HOOKS
> +	bool
> +
> +config MMIOTRACE
> +	bool "Memory mapped IO tracing"
> +	depends on HAVE_MMIOTRACE_SUPPORT && DEBUG_KERNEL && PCI
> +	select TRACING
> +	select MMIOTRACE_HOOKS

change makes sense, but isnt MMIOTRACE_HOOKS basically overlapping 
HAVE_MMIOTRACE_SUPPORT? So i think we could get rid of MMIOTRACE_HOOKS 
altogether and just use HAVE_MMIOTRACE_SUPPORT.

Pekka?

	Ingo
