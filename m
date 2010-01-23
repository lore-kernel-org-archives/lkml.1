Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084Ab0AWGE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab0AWGE4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 01:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068Ab0AWGEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 01:04:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46556 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932068Ab0AWGEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 01:04:50 -0500
Date: Sat, 23 Jan 2010 07:04:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       systemtap@sources.redhat.com, dle-develop@lists.sourceforge.net
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100123060401.GB19399@elte.hu>
References: <20100121013822.28781960.sfr@canb.auug.org.au>
 <20100122111747.3c224dfd.sfr@canb.auug.org.au>
 <20100121163004.8779bd69.akpm@linux-foundation.org>
 <20100121163145.7e958c3f.akpm@linux-foundation.org>
 <20100122005147.GD22003@redhat.com>
 <20100121170541.7425ff10.akpm@linux-foundation.org>
 <20100122012516.GE22003@redhat.com>
 <alpine.LFD.2.00.1001211729080.13231@localhost.localdomain>
 <20100122022255.GF22003@redhat.com>
 <alpine.LFD.2.00.1001211826060.13231@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001211826060.13231@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 21 Jan 2010, Frank Ch. Eigler wrote:
> 
> > Less passionate analysis would identify a long history of contribution by 
> > the the greater affiliated team, including via merged code and by and 
> > passing on requirements and experiences.
> 
> The reason I'm so passionate is that I dislike the turn the discussion was 
> taking, as if "utrace" was somehow _good_ because it allowed various other 
> interfaces to hide behind it. And I'm not at all convinced that is true.
> 
> And I really didn't want to single out system tap, I very much feel the same 
> way abotu some seccomp-replacement "security model that the kernel doesn't 
> even need to know about" thing.
> 
> So don't take the systemtap part to be the important part, it's the bigger 
> issue of "I'd much rather have explicit interfaces than have generic hooks 
> that people can then use in any random way".
> 
> I realize that my argument is very anti-thetical to the normal CS teaching 
> of "general-purpose is good". I often feel that very specific code with very 
> clearly defined (and limited) applicability is a good thing - I'd rather 
> have just a very specific ptrace layer that does nothing but ptrace, than a 
> "generic plugin layer that can be layered under ptrace and other things".

( I think to a certain degree it mirrors the STEAMS hooks situation from a 
  decade ago - and while there were big flamewars back then we never regretted 
  not taking the STREAMS opaque hooks upstream. )

> In one case, you know exactly what the users are, and what the semantics are 
> going to be. In the other, you don't.
> 
> So I really want to see a very big and immediate upside from utrace. Because 
> to me, the "it's a generic layer with any application you want to throw at 
> it" is a _downside_.

One component of the whole utrace/systemtap codebase that i think would make 
sense upstreaming in the near term is the concept of user-space probes. We are 
actively looking into it from a 'perf probe' angle, and PeterZ suggested a few 
ideas already. Allowing apps to transparently improve the standard set of 
events is a plus. (From a pure Linux point of view it's probably more 
important than any kernel-only instrumentation.)

Also, if any systemtap person is interested in helping us create a more 
generic filter engine out of the current ftrace filter engine (which is really 
a precursor of a safe, sandboxed in-kernel script engine), that would be 
excellent as well. Right now we support simple C-syntax expressions like:

   perf record -R -f -e irq:irq_handler_entry --filter 'irq==18 || irq==19'

More could be done - a simple C-like set of function perhaps - some minimal 
per probe local variable state, etc. (perhaps even looping as well, with a 
limit on number of predicament executions per filter invocation.)

( _Such_ a facility, could then perhaps be used to allow applications access 
  to safe syscall sandboxing techniques: i.e. a programmable seccomp concept 
  in essence, controlled via ASCII space filter expressions [broken down into
  predicaments for fast execution], syscall driven and inherited by child 
  tasks so that security restrictions percolate down automatically.

  IMHO that would be a superior concept for security modules too: there's no 
  reason why all the current somewhat opaque security hooks couldnt be 
  expressed in terms of more generic filter expressions, via a facility that
  can be used both for security and for instrumentation. That's all what 
  SELinux boils down to in the end: user-space injected policy rules. )

The opaque hookery all around the core kernel just to push everything outside 
of mainline is one of the biggest downsides of utrace/systemtap - and neither 
uprobes nor the concept of user-defined scripting around existing events is 
affected much by that.

So lots of work is left and all that work is going to be rather utilitarian 
with little downside: specific functionality with an immediately visible 
upside, with no need for opaque hooks.

	Ingo
