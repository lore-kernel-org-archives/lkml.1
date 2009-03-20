Return-Path: <linux-kernel-owner+w=401wt.eu-S1756413AbZCTIqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413AbZCTIqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 04:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbZCTIqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 04:46:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37612 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238AbZCTIqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 04:46:22 -0400
Date: Fri, 20 Mar 2009 09:45:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: [RFC][PATCH -tip 0/9] tracing: kprobe-based event tracer
Message-ID: <20090320084544.GA16021@elte.hu>
References: <49C2B4A4.5060109@redhat.com> <20090320002435.GA6895@nowhere> <49C30EA5.5040707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C30EA5.5040707@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Frederic Weisbecker wrote:
> > On Thu, Mar 19, 2009 at 05:09:56PM -0400, Masami Hiramatsu wrote:
> >> Hi,
> >>
> >> This is a series of patches which introduce a proof-of concept of
> >> kprobe-based event tracer to ftrace. I think that we could port some
> >> tracing features from systemtap on this vehicle.
> >> This can be applied on the linux-2.6-tip tree.
> >>
> >> This patchset includes following changes:
> >> - Add kprobe-tracer plugin
> >> - Add kernel_trap_sp() on x86, ia64, power, s390, arm which are
> >>   ported from systemtap runtime.
> >> - Add module_*probe api for repawning/removing kprobes when target
> >>   module is coming/going.
> >>
> >> It's still not unclear that the last module_*probe would better be
> >> provided as APIs or just embed it in trace_kprobe.c.
> >>
> >> Future items:
> >> - Use binary print.
> >> - Add kernel_trap_sp() on other archs.
> >> - Support symbol-based memory fetching (for global variables)
> >> - Support primitive types(long, ulong, int, uint, etc) for args.
> >> - Support indirect memory fetch from register etc.
> >> - Check insertion point safety by using instruction decoder.
> >>
> >> kprobe-based event tracer
> >> ---------------------------
> >>
> >> This tracer is similar to the events tracer which is based on Tracepoint
> >> infrastructure. Instead of Tracepoint, this tracer is based on kprobes(kprobe
> >> and kretprobe). It probes anywhere where kprobes can probe(this means, all
> >> functions body except for __kprobes functions).
> >>
> >> Unlike the function tracer, this tracer can probe instructions inside of
> >> kernel functions. It allows you to check which instruction has been executed.
> >>
> >> Unlike the Tracepoint based events tracer, this tracer can add new probe points
> >> on the fly.
> >>
> >> Similar to the events tracer, this tracer doesn't need to be activated via
> >> current_tracer, instead of that, just set probe points via
> >> /debug/tracing/kprobe_probes.
> >>
> >> Synopsis of kprobe_probes:
> >>   p SYMBOL[+offs|-offs]|MEMADDR [FETCHARGS]     : set a probe
> > 
> > 
> > Ahh, I see this is not only about parameters but also about very low level
> > debugging, such as registers dumps.
> > 
> > This is very powerful.
> 
> Please take care, don't shot your foot :)
> This tracer doesn't have a safety lever(e.g. instruction boundary checker) yet.
> So, currently, we need to use this with objdump -d.

Would be really nice to have this in the future. We could reuse 
existing opcode decoders in the x86 code for that i think. KVM has 
probably the most potent one.

Cool stuff!

	Ingo
