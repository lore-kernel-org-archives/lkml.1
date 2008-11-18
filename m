Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbYKRPNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbYKRPNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 10:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbYKRPNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 10:13:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41174 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbYKRPNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 10:13:38 -0500
Date: Tue, 18 Nov 2008 16:13:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/function-return-tracer: add the overrun
	field
Message-ID: <20081118151326.GH30358@elte.hu>
References: <4920D571.4050007@gmail.com> <20081117084923.GD28786@elte.hu> <4921BA25.3090704@gmail.com> <20081118084755.GK17838@elte.hu> <alpine.DEB.1.10.0811180922370.15003@gandalf.stny.rr.com> <20081118145154.GC30358@elte.hu> <alpine.DEB.1.10.0811181006010.15003@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811181006010.15003@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Tue, 18 Nov 2008, Ingo Molnar wrote:
> 
> > 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > 
> > > On Tue, 18 Nov 2008, Ingo Molnar wrote:
> > > > > 
> > > > > Ok I will try with 50. If there are still a lot and often missing 
> > > > > traces with this depth, perhaps should we consider a hybrid solution 
> > > > > between ret stack and trampolines? We could use the normal ret stack 
> > > > > on struct info for most common cases and the trampoline when we are 
> > > > > exceeding the depth....
> > > > 
> > > > dunno, trampolines make me feel uneasy.
> > > > 
> > > > Could you set it to some really large value (200) and add a "max 
> > > > depth seen" variable perhaps, and see the maximum depth?
> > > 
> > > Don't run that on a box you care about ;-) But hopefully the stacks 
> > > will not collide. This should also depend on IRQSTACKS.
> > 
> > that reminds me: ti->ret_stack[] should be moved to task->ret_stack[]. 
> > That way we decouple its size from any kernel stack size limits. 
> > (thread-info resides at one end of the kernel stack, on x86)
> 
> Yeah, I recommended that to Frederic to save space. But that can be 
> dangerous. Using task instead would be safer with the downside of 
> making the task struct even bigger.

We almost never put new stuff into thread_info - we have the lockdep 
lock stack in the task structure too, for similar reasons.

	Ingo
