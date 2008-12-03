Return-Path: <linux-kernel-owner+w=401wt.eu-S1753010AbYLCOWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbYLCOWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 09:22:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750918AbYLCOWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 09:22:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37570 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbYLCOWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 09:22:35 -0500
Date: Wed, 3 Dec 2008 15:22:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tim Bird <tim.bird@am.sony.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/function-graph-tracer: improve duration
	output
Message-ID: <20081203142225.GA32267@elte.hu>
References: <4935E19C.3090501@gmail.com> <4935E226.3060906@gmail.com> <20081203081906.GH21006@elte.hu> <alpine.DEB.1.10.0812030649480.29045@gandalf.stny.rr.com> <c62985530812030511p7768dba0gce8cf84655b9ac35@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530812030511p7768dba0gce8cf84655b9ac35@mail.gmail.com>
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

> 2008/12/3 Steven Rostedt <rostedt@goodmis.org>:
> > Actually, I was also thinking of keeping the CPU number in front:
> >
> >  ------------------------------------------
> >  0)    cat-2796    =>   events/-9
> >  ------------------------------------------
> >
> > This way we can easily grep for a common CPU and still get the context
> > switches:
> >
> > grep '^0)' trace > /tmp/trace0
> 
> I agree. More easy to grep. Ingo, Peter, others, what do you think?

sure.

> > Of course it will probably also work without the '^' now, but then it 
> > might grab ftrace_printks with a '0)' if we add those.
> 
> 
> I proposed a solution for ftrace_printk (which I planned to implement 
> this evening). Since we are in a C-style output, that would be good to 
> put the ftrace_printk as /* C comments */ inside just below the 
> function that called it. Like this:
> 
> func_that_called_ftrace_printk {
>     /* Message from ftrace_printk */
> }
> 
> This way we keep the idea of comment which comes along the role of
> ftrace_printk and we know
> which function called it, at which depth.....
> 
> Do you like it this way?

yeah, that would be lovely to have too.

	Ingo
