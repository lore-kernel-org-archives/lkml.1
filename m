Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbZCXAwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbZCXAwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 20:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbZCXAwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 20:52:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58716 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535AbZCXAwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 20:52:01 -0400
Date: Mon, 23 Mar 2009 20:51:57 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Anton Vorontsov <avorontsov@ru.mvista.com>
cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing: Fix TRACING_SUPPORT dependency for PPC32
In-Reply-To: <20090323220724.GA9851@oksana.dev.rtsoft.ru>
Message-ID: <alpine.DEB.2.00.0903232050590.3578@gandalf.stny.rr.com>
References: <20090320150914.GA22769@oksana.dev.rtsoft.ru> <20090320190428.GD6224@elte.hu> <20090320193904.GA13707@oksana.dev.rtsoft.ru> <20090320195743.GA25147@elte.hu> <20090320202247.GA30654@oksana.dev.rtsoft.ru> <20090321161814.GC11183@elte.hu>
 <20090323220724.GA9851@oksana.dev.rtsoft.ru>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 24 Mar 2009, Anton Vorontsov wrote:

> commit 40ada30f9621fbd831ac2437b9a2a399aa ("tracing: clean up menu"),
> despite the "clean up" in its purpose, introduced a behavioural
> change for Kconfig symbols: we no longer able to select tracing
> support on PPC32 (because IRQFLAGS_SUPPORT isn't yet implemented).
> 
> The IRQFLAGS_SUPPORT is not mandatory for most tracers, tracing core
> has a special case for platforms w/o irqflags (which, by the way, has
> become useless as of the commit above).
> 
> Though according to Ingo Molnar, there was periodic build failures on
> weird, unmaintained architectures that had no irqflags-tracing support
> and hence didn't know the raw_irqs_save/restore primitives. Thus we'd
> better not enable irqflags-less tracing for all architectures.
> 
> This patch restores the old behaviour for PPC32, and thus brings the
> tracing back. Other architectures can either add themselves to the
> exception list or (better) implement TRACE_IRQFLAGS_SUPPORT.
> 
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
[..]

> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index ee70841..2246141 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -63,7 +63,11 @@ config TRACING
>  #
>  config TRACING_SUPPORT
>  	bool
> -	depends on TRACE_IRQFLAGS_SUPPORT
> +	# PPC32 has no irqflags tracing support, but it can use most of the
> +	# tracers anyway, they were tested to build and work. Note that new
> +	# exceptions to this list aren't welcomed, better implement the
> +	# irqflags tracing for your architecture.
> +	depends on TRACE_IRQFLAGS_SUPPORT || PPC32
>  	depends on STACKTRACE_SUPPORT
>  	default y
> 

I'm fine with this.

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

