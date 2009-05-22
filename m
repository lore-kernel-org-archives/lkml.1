Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbZEVICY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbZEVICY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbZEVICA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:02:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57604 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbZEVICA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:02:00 -0400
Date: Fri, 22 May 2009 10:01:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ftrace: Add task_comm support for trace_event
Message-ID: <20090522080144.GB11438@elte.hu>
References: <4A14FDFE.2080402@cn.fujitsu.com> <alpine.DEB.2.00.0905210915080.4632@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905210915080.4632@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Thu, 21 May 2009, Zhaolei wrote:
> 
> > If we use trace_event alone(without function trace, .etc),
> > it can't output enough task command information.
> > 
> > Before patch:
> >  # echo 1 > debugfs/tracing/events/sched/sched_switch/enable
> >  # cat debugfs/tracing/trace
> >  # tracer: nop
> >  #
> >  #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> >  #              | |       |          |         |
> >             <...>-2289  [000] 526276.724790: sched_switch: task bash:2289 [120] ==> sshd:2287 [120]
> >             <...>-2287  [000] 526276.725231: sched_switch: task sshd:2287 [120] ==> bash:2289 [120]
> >             <...>-2289  [000] 526276.725452: sched_switch: task bash:2289 [120] ==> sshd:2287 [120]
> >             <...>-2287  [000] 526276.727181: sched_switch: task sshd:2287 [120] ==> swapper:0 [140]
> >            <idle>-0     [000] 526277.032734: sched_switch: task swapper:0 [140] ==> events/0:5 [115]
> >             <...>-5     [000] 526277.032782: sched_switch: task events/0:5 [115] ==> swapper:0 [140]
> >  ...
> > 
> > After patch:
> >  # tracer: nop
> >  #
> >  #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> >  #              | |       |          |         |
> >              bash-2269  [000] 527347.989229: sched_switch: task bash:2269 [120] ==> sshd:2267 [120]
> >              sshd-2267  [000] 527347.990960: sched_switch: task sshd:2267 [120] ==> bash:2269 [120]
> >              bash-2269  [000] 527347.991143: sched_switch: task bash:2269 [120] ==> sshd:2267 [120]
> >              sshd-2267  [000] 527347.992959: sched_switch: task sshd:2267 [120] ==> swapper:0 [140]
> >            <idle>-0     [000] 527348.531989: sched_switch: task swapper:0 [140] ==> events/0:5 [115]
> >          events/0-5     [000] 527348.532115: sched_switch: task events/0:5 [115] ==> swapper:0 [140]
> 
> Heh, this was on my todo list today. [...]

yeah, it annoyed me too for some time :)

> [...] Thanks, I'll suck up this patch, if Ingo doesn't get to it 
> first. If he does.
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>

I pulled it from your tree - thanks guys.

	Ingo
