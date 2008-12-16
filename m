Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758785AbYLPWAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785AbYLPWAB (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 17:00:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbYLPV7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 16:59:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56000 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbYLPV7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 16:59:50 -0500
Date: Tue, 16 Dec 2008 22:59:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/ftrace: use preempt_enable_no_resched_notrace
	in ring_buffer_time_stamp()
Message-ID: <20081216215941.GA14787@elte.hu>
References: <494818EA.7080807@gmail.com> <20081216212028.GP14787@elte.hu> <c62985530812161339p6296f032rdc3c74650331f3d8@mail.gmail.com> <alpine.DEB.1.10.0812161642530.25356@gandalf.stny.rr.com> <c62985530812161355l11edbb9cg6dd4e7e4291ab7b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530812161355l11edbb9cg6dd4e7e4291ab7b@mail.gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2008/12/16 Steven Rostedt <rostedt@goodmis.org>:
> >
> >
> > On Tue, 16 Dec 2008, Fr?d?ric Weisbecker wrote:
> >>
> >> The hard reboots I've seen are related to x86-64 while
> >> disabling/reenabling a CPU through /sys/device/system/cpu
> >> No tracer was enabled at these times (the problem still remains with
> >> latest updates on -tip for half an hour).
> >
> > Do you have STACK_TRACER enabled?
> >
> > -- Steve
> >
> 
> You were right. I've just built a kernel without STACK_TRACER and the 
> problem disappears...

i noticed high stack-tracer overhead too. Which is understandable i guess: 
the stack tracer keeps the mcount callbacks running all the time and can 
save the stack backtrace of the highest-stack-usage point in time that the 
kernel ever has hit in the past. That is a pretty powerful debug 
capability, with appropriate costs.

	Ingo
