Return-Path: <linux-kernel-owner+w=401wt.eu-S1031201AbXECUX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031201AbXECUX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 16:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031217AbXECUX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 16:23:29 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:43357 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031201AbXECUX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 16:23:28 -0400
Subject: Re: [PATCH -rt] wrong usage of smp_processor_id()
From: Daniel Walker <dwalker@mvista.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <463A421C.4080507@redhat.com>
References: <20070503200822.696754319@mvista.com>
	 <463A421C.4080507@redhat.com>
Content-Type: text/plain
Date: Thu, 03 May 2007 13:21:47 -0700
Message-Id: <1178223708.7997.0.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-03 at 16:12 -0400, Steven Rostedt wrote:
> Daniel Walker wrote:
> 
> > ---
> >  kernel/latency_trace.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Index: linux-2.6.21/kernel/latency_trace.c
> > ===================================================================
> > --- linux-2.6.21.orig/kernel/latency_trace.c
> > +++ linux-2.6.21/kernel/latency_trace.c
> > @@ -105,7 +105,7 @@ static inline int DEBUG_WARN_ON(int cond
> >  #ifdef CONFIG_CRITICAL_IRQSOFF_TIMING
> >  # ifdef CONFIG_CRITICAL_PREEMPT_TIMING
> >     static DEFINE_PER_CPU(int, trace_cpu_idle);
> > -#  define irqs_off_preempt_count() (!__get_cpu_var(trace_cpu_idle) && preempt_count())
> > +#  define irqs_off_preempt_count() (preempt_count() && !__get_cpu_var(trace_cpu_idle))
> >  # else
> >  #  define irqs_off_preempt_count() 0
> >  # endif
> 
> Ingo,
> 
> This is on top of one of my patches that I sent you (the cpu idle one). 
> So it's not for the 2.6.21-rt1, but if you apply my patch, this needs to 
> be added too.

Isn't it a generic problem? It doesn't look specific to your change
unless you made some changes to entry.S .

Daniel

