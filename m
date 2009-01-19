Return-Path: <linux-kernel-owner+w=401wt.eu-S1761294AbZASNG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761294AbZASNG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761256AbZASNEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:04:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37234 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761250AbZASNEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:04:49 -0500
Date: Mon, 19 Jan 2009 14:04:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace based hard lockup detector
Message-ID: <20090119130442.GA6876@elte.hu>
References: <4973cff5.05a0660a.650c.2f54@mx.google.com> <alpine.DEB.1.10.0901190757330.17050@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901190757330.17050@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1358]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Sun, 18 Jan 2009, Frederic Weisbecker wrote:
> 
> > Like the NMI watchdog, this feature try to detect hard lockups by
> > lurking at the non-progress of the timer interrupts.
> > 
> > You can enable it at boot time by passing the ftrace_hardlockup parameter.
> > I plan to add a debugfs file to enable/disable at runtime.
> > 
> > When a hardlockup is detected, it will print a backtrace. Perhaps it
> > would be good to print the locks held from lockdep too?
> > 
> > It only support x86 for the moment, because a kind of generic timer interrupt
> > counter is needed on all archs to have it generic.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Hi Frederic,
> 
> This seems like a rewrite of the NMI lockup code. In my debugging, I 
> simply put ftrace_dump in the NMI lockup, which gives me a ftrace dump 
> as soon as NMI detects a lockup. I'm a bit confused at what this gives 
> us over that?

this is different from the NMI watchdog in a number of ways:

 - it works on all platforms and in all situations where the NMI watchdog 
   does not work.

 - in theory it can detect hard lockups in situations where the NMI 
   watchdog is disabled, such as suspend/resume or early bootup. 
   (especially early bootup lockups are nasty and the NMI watchdog is 
    enabled relatively late)

 - it could be extended to detect 'soft' lockups too - i.e. we could have 
   a one-stop facility to detect all kinds of "kernel does not seem to 
   progress" lockups.

But it's not as complete as the NMI watchdog: it relies on instrumented 
function calls rolling on and on during the lockup - that's not the case 
when we get a hard lockup due to a tight, infinite loop somewhere.

	Ingo
