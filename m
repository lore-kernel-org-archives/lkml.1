Return-Path: <linux-kernel-owner+w=401wt.eu-S1759521AbZEKVsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521AbZEKVsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759865AbZEKVry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:47:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38103 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759435AbZEKVrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:47:53 -0400
Date: Mon, 11 May 2009 23:47:12 +0200
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
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       Tom Zanussi <zanussi@comcast.net>
Subject: Re: [PATCH -tip v5 0/7] tracing: kprobe-based event tracer and x86
	instruction decoder
Message-ID: <20090511214712.GF21232@elte.hu>
References: <20090509004829.5505.38720.stgit@localhost.localdomain> <20090509044302.GH8007@elte.hu> <4A0838E6.2000309@redhat.com> <alpine.DEB.2.00.0905111054490.2492@gandalf.stny.rr.com> <4A088523.6080003@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A088523.6080003@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Steven Rostedt wrote:
> > On Mon, 11 May 2009, Masami Hiramatsu wrote:
> >>> Two high-level comments:
> >>>
> >>>  - There's no self-test - would it be possible to add one? See 
> >>>    trace_selftest* in kernel/trace/
> >> I'm not so sure. Currently, it seems that those self-tests are
> >> only for tracers which define new event-entry on ring-buffer.
> >> Since this tracer just use ftrace_bprintk, it might need
> >> another kind of selftest. e.g. comparing outputs with
> >> expected patterns.
> >> In that case, would it be better to make a user-space self test
> >> including filters and tracepoints?
> > 
> > Or have the workings in the selftest in kernel. As if a user started it. 
> > It does not need to write to the ring buffer, that is just what I did. The 
> > event selftests don't check if anything was written to the ring buffer, 
> > they just make sure that the tests don't crash the system.
> 
> Would you mean that it is enough to enable some probes and just
> see what happened at boot time?
> That's so easy to add.

Yes, that's the idea!

Try to think of regressions/crashes/misbehavior you generally 
trigger while you developed kprobes, and try to add a reasonable set 
of probes that test the code from those angles.

It doesnt have to be a full, complex test-suite, but even just 80% 
of coverage of functionality keeps 4/5th of all regressions out of 
the kernel at a very early stage ...

	Ingo
