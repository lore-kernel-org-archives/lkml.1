Return-Path: <linux-kernel-owner+w=401wt.eu-S1760375AbYAJTLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760375AbYAJTLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760703AbYAJTKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:10:55 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:36773 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760659AbYAJTKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:10:54 -0500
Date: Thu, 10 Jan 2008 14:10:46 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 01/22 -v2] Add basic support for gcc profiler
 instrumentation
In-Reply-To: <20080110182828.GA19399@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.58.0801101406040.15391@gandalf.stny.rr.com>
References: <20080109232914.676624725@goodmis.org> <20080109233042.386384204@goodmis.org>
 <20080110182828.GA19399@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Sam,

On Thu, 10 Jan 2008, Sam Ravnborg wrote:

> Hi Steven.
>
> > Index: linux-compile-i386.git/arch/x86/Kconfig
> > ===================================================================
> > --- linux-compile-i386.git.orig/arch/x86/Kconfig	2008-01-09 14:09:36.000000000 -0500
> > +++ linux-compile-i386.git/arch/x86/Kconfig	2008-01-09 14:10:07.000000000 -0500
> > @@ -28,6 +28,10 @@ config GENERIC_CMOS_UPDATE
> >  	bool
> >  	default y
> >
> > +config ARCH_HAS_MCOUNT
> > +       bool
> > +       default y
> > +
>
> Please use the following scheme:
>
> arch/x86/Kconfig:
>  config X86
> +	select HAVE_MCOUNT
>
> lib/tracing/Kconfig
>
> + # ARCH shall select HAVE_MCOUNT if they provide this function
> + config HAVE_MCOUNT
> +	bool
> +
> + config MCOUNT
> +	bool
> +	select FRAME_POINTER
>
> And then in your later patches:
> +config MCOUNT_TRACER
> +       bool "Profiler instrumentation based tracer"
> +       depends on DEBUG_KERNEL && HAVE_MCOUNT
> +       select MCOUNT
> +       help
> +         Use profiler....

Thanks, this does look like a cleaner approach. I'll implement it into
my next series.

-- Steve

