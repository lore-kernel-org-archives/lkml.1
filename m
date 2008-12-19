Return-Path: <linux-kernel-owner+w=401wt.eu-S1758846AbYLSWMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846AbYLSWMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:12:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756584AbYLSWGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 17:06:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54264 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756666AbYLSWGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 17:06:12 -0500
Date: Fri, 19 Dec 2008 23:05:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Pekka J Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Pekka Paalanen <pq@iki.fi>, Markus Metzger <markus.t.metzger@gmail.com>
Subject: Re: [PATCH] ftrace: introduce tracing_reset_online_cpus() helper
Message-ID: <20081219220556.GK2351@elte.hu>
References: <Pine.LNX.4.64.0812191207130.6888@melkki.cs.Helsinki.FI> <c62985530812190247i705d9c3er7662a1b133c6eb29@mail.gmail.com> <alpine.DEB.1.10.0812191216190.26432@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812191216190.26432@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Fri, 19 Dec 2008, Fr?d?ric Weisbecker wrote:
> > 
> > 
> > That's looks good.
> > By the past, I also suggested Steven to automatically reset the traces
> > buffer each time a tracer is started, that
> > would factor out the code a bit more. I don't think one tracer would
> > avoid to reset the buffer once it is started, and
> > I don't think it is needed to reset twice on tracer switching: on stop
> > of the old tracer and on start on the new. Only
> > on start should be enough.
> 
> I'm actually against the idea of reseting a trace everytime we enable it.
> That is:
> 
> echo 1 > /debug/tracing/tracing_enabled
> 
> This should not reset the tracer. I actually do tracing where I disable 
> and enable it around areas I am interested in. I want all tracing, not 
> just the last one.
> 
> Now we have recently added /debug/tracing/tracing_on which can quickly 
> stop tracing. I may be able to use that, and we can let the 
> tracing_enable" reset it too.
> 
> I'll have to take a look at my scripts to see if that would work.

yep, using /debug/tracing/tracing_enabled is the right model to quickly 
toggle tracing without losing the buffer.

The 'switch tracer' op is really a slow thing anyway. It can involve 
unpatching/repatching functions, etc. etc. - and while it works, it 
shouldnt really be encouraged as a dynamic tool coding pattern.

	Ingo
