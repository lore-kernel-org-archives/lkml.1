Return-Path: <linux-kernel-owner+w=401wt.eu-S1758595AbZEMNWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595AbZEMNWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 09:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbZEMNWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 09:22:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58664 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127AbZEMNWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 09:22:42 -0400
Date: Wed, 13 May 2009 15:21:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, lkml <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH -tip v5 0/7] tracing: kprobe-based event tracer and x86
	instruction decoder
Message-ID: <20090513132151.GC21052@elte.hu>
References: <20090509004829.5505.38720.stgit@localhost.localdomain> <20090509044302.GH8007@elte.hu> <4A09F216.70203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A09F216.70203@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

> Ingo Molnar wrote:
> > * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> > 
> >> Hi,
> >>
> >> Here are the patches of kprobe-based event tracer for x86, version 
> >> 5, which allows you to probe various kernel events through ftrace 
> >> interface.
> >>
> >> This version supports only x86(-32/-64) (but porting it on other 
> >> arch just needs kprobes/kretprobes and register and stack access 
> >> APIs).
> >>
> >> This patchset also includes x86(-64) instruction decoder which 
> >> supports non-SSE/FP opcodes and includes x86 opcode map. I think 
> >> it will be possible to share this opcode map with KVM's decoder.
> >>
> >> This series can be applied on the latest linux-2.6-tip tree.
> >>
> >> This patchset includes following changes:
> >> - Add x86 instruction decoder [1/7]
> >> - Check insertion point safety in kprobe [2/7]
> >> - Cleanup fix_riprel() with insn decoder [3/7]
> >> - Add kprobe-tracer plugin [4/7]
> >> - Fix kernel_trap_sp() on x86 according to systemtap runtime. [5/7]
> >> - Add arch-dep register and stack fetching functions [6/7]
> >> - Support fetching various status (register/stack/memory/etc.) [7/7]
> >>
> >> Future items:
> >> - .init function tracing support.
> >> - Support primitive types(long, ulong, int, uint, etc) for args.
> > 
> > Ok, this looks pretty complete already.
> > 
> > Two high-level comments:
> > 
> >  - There's no self-test - would it be possible to add one? See 
> >    trace_selftest* in kernel/trace/
> > 
> >  - No generic integration.
> 
> Hmm, Ingo, could you tell me what I can do for the integration? 
> Would you means that I should use filters?

yeah, that - and for the tracepoints to show up under 
/debug/tracing/events/. They'd in essence be 'flexible', dynamic 
event tracepoints that extend upon existing, built-in tracepoints. 
To user-space tools the two would show up in a very similar way and 
with a similar usage (once they are injected).

	Ingo
