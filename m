Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbZEKKye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbZEKKye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 06:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbZEKKyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 06:54:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44418 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbZEKKyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 06:54:03 -0400
Date: Mon, 11 May 2009 12:53:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH -tip v5 4/7] tracing: add kprobe-based event tracer
Message-ID: <20090511105337.GF4648@elte.hu>
References: <20090509004829.5505.38720.stgit@localhost.localdomain> <20090509004859.5505.18729.stgit@localhost.localdomain> <20090511093224.GC23875@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090511093224.GC23875@infradead.org>
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


* Christoph Hellwig <hch@infradead.org> wrote:

> On Fri, May 08, 2009 at 08:48:59PM -0400, Masami Hiramatsu wrote:
> > Add kprobes based event tracer on ftrace.
> > 
> > This tracer is similar to the events tracer which is based on 
> > Tracepoint infrastructure. Instead of Tracepoint, this tracer is 
> > based on kprobes(kprobe and kretprobe). It probes anywhere where 
> > kprobes can probe(this means, all functions body except for 
> > __kprobes functions).
> 
> That's some pretty cool functionality, especially together with 
> patch 7.

Yes. I insisted on this model, because this is essentially 
kprobes-done-right. Exposing unsafe kernel instrumentation APIs was 
a big mistake to merge upstream, it delayed the proper design of 
this stuff by almost a decade.

There's two more details to be solved before this can go into the 
tracing tree.

> But as with so many tracing bits in the kernel it's just lowlevel 
> bits without a good user interface.  We'd really need some 
> high-level way for sysadmins/developers to use it.  E.g. a version 
> of the systemtap compiler that doesn't build a kernel module but 
> instead uses the event tracer + the kprobes tracer.

Yes, exactly.

> Or a model like Tom's zedtrace where a perl script would do the 
> dwarf lookups and generates these probes in addition to the 
> filtered event traces.

Correct, that's the other, IMHO superior direction that is being 
pursued. If you look at the evolution of the filter code it gives 
the seeds for safe scripting done in the kernel.

Such filters/scripts can then be reused for a whole lot more stuff, 
such as security rules. (netfilters could use it too, etc.)

	Ingo
