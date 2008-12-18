Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752356AbYLRLQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbYLRLQl (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 06:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbYLRLQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 06:16:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46015 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbYLRLQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 06:16:28 -0500
Date: Thu, 18 Dec 2008 12:16:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tracing/function-graph-tracer: prevent from hrtimer
	interrupt infinite loop
Message-ID: <20081218111612.GD14332@elte.hu>
References: <4949A2CC.6040209@gmail.com> <20081218103459.GD10513@elte.hu> <c62985530812180251k7fde4f13tce5118a3eac4975b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530812180251k7fde4f13tce5118a3eac4975b@mail.gmail.com>
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

> 2008/12/18 Ingo Molnar <mingo@elte.hu>:
> >
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >
> >> Impact: fix a system hang on slow systems
> >>
> >> While testing the function graph tracer on VirtualBox, I had a system hang
> >> immediatly after enabling the tracer.
> >>
> >> If hrtimer is enabled on kernel, a slow system can spend too much time
> >> during tracing the hrtimer_interrupt which will do eternal loops,
> >> assuming it always have to retry its process because too much time
> >> elapsed during its time update. Now we provide a feature which lurks at
> >> the number of retries on hrtimer_interrupt. After 10 retries, the
> >> function graph tracer will definetly stop its tracing.
> >
> > hm, i dont really like this solution - it just works around the problem by
> > 'speeding up' the system. If we have a _real_ slow system, there's no such
> > way for us to speed it up.
> 
> 
> It doesn' speed up the system actually. That's not the goal of this 
> patch.

i meant that abstractly. The "solution" here is that your patch turns off 
the function-graph-tracer. The practical effect of that is: the system 
gets much faster at processing hrtimer IRQs and effectively "speeds up".

ok?

	Ingo
