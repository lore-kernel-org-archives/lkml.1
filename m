Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbZB0Hsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbZB0Hsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 02:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbZB0Hs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 02:48:28 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55188 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbZB0Hs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 02:48:27 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] new irq tracer
Cc: kosaki.motohiro@jp.fujitsu.com,
       Dominique Toupin <dominique.toupin@ericsson.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, acme@ghostprotocols.net
In-Reply-To: <alpine.DEB.2.00.0902262230130.19122@gandalf.stny.rr.com>
References: <20090227121053.152B.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0902262230130.19122@gandalf.stny.rr.com>
Message-Id: <20090227123806.1537.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri, 27 Feb 2009 16:48:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Fri, 27 Feb 2009, KOSAKI Motohiro wrote:
> > >
> > > In many cases we don't use Linux real-time, we have many systems that
> > > are soft-real-time an non real-time Linux is good enough.
> > >  
> > 
> > Agreed, rt-patch seems off topics. we discuss to mainline kernel.
> 
> The reason I brought up the rt-patch is that Mathieu is concerned about 
> the small latency that happens when we run stop_machine to switch the nops 
> to pointers to trace functions. This latency can be a couple of millisecs, 
> but I can easily make a normal kernel suffer a couple of millisec latency 
> by simply running hackbench (as a normal user).
> 
> The point being, I think Mathieu's point about the latency of enabling the 
> function tracer is frivolous. It is a one time shot that happens when the 
> sysadmin purposely enables the function tracing.  If this is unacceptable, 
> then the system had better be running the rt patch because it will be 
> hitting this unacceptable latency in normal operation.

ok, I missed last thread. thanks.

I think you talk about "ftrace, x86: make kernel text writable only for
conversions" thread, right?
hm, it seems very good discussion.

My concern is, both your and Mathieu's point is fairly reasonable and
good direction.

However, I would bring up another viewpoint. so, 

  - the latency issue can happen actual production server?


Mathieu and Dominique explained ACTUAL production server problem.
but I believe Dominique's server never run hackbench.

In other word, I agree mainline kernel has many latency corner case problems.
but I don't agree corner case existing indicate no need latency improvement.
Generally, actual experience indicate it's valuable to hear them reqirement.



HOWEVER, I still also agree with your disliking messiness.
Then, I would suggest we go into next step.

I mean make the patch of mathieu's plan and mesure it. Then
we can mesure number by number. my number mean,

  (1) How much increasing line and messiness
  (2) How much improving latency

that's fairly comparision and typical lkml discussion style, imho.

What do you think?



