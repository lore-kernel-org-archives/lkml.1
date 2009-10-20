Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068AbZJTGoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbZJTGoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 02:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbZJTGoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 02:44:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50168 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716AbZJTGoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 02:44:00 -0400
Date: Tue, 20 Oct 2009 08:43:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip tracing/kprobes 0/9] tracing/kprobes, perf: perf
	probe and kprobe-tracer bugfixes
Message-ID: <20091020064334.GK8550@elte.hu>
References: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com> <20091017080203.GA4155@elte.hu> <20091017103427.GA31238@elte.hu> <4ADAAF50.9040604@redhat.com> <20091019075103.GF17960@elte.hu> <20091019110055.GA5549@nowhere> <20091019112125.GA12829@elte.hu> <20091019193248.GB4880@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091019193248.GB4880@nowhere>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

[...]
>
> I think absolute and relative line modes are not colliding/contending 
> at all but actually fit two different needs.

Definitely so.

> - absolute is nice when you are lonely doing kernel debugging.
>   (can be expanded at will once you imagine user probes)
>   You are stuck in your code editor, trying to figure out the
>   origin of your problem and then you think it would be nice
>   to set a probe in branch 1 and in branch 2 inside func_foo().
>   Then you already have absolute lines and relying in
>   perf probe --list func_foo() to resolve an absolute line into
>   a relative one is a very undesired middle step.

Of course - absolute numbers definitely rule for everything that works 
on a whole-file basis. (I'd argue that if you do that from an editor 
then you want a short macro that just sets a probe there - much like a 
breakpoint. Such an editor macro would want to use absolute numbers.))

> - relative is nice in some other cases. When you already have
>   the function target in mind, you even don't need to check your
>   editor, just a quick check to this command and get the relative
>   line. But also when you want to transmit a probe reference
>   in a mailing list because of its better lifetime.

also useful for command line workflows: 'perf probe --list' output - i 
think we users to generate func_symbol+rel_position kind of probes.

Plus a relative position is more intuitive as well. If you see 
'schedule+10' versus 'schedule+102', you'll know it immediate that the 
first one is early in the function while the second one is near the end.

If you see 'schedule@2465' versus 'schedule@2555' that kind of 'where in 
the function is the probe, roughly' subjective impression is lost.

	Ingo
