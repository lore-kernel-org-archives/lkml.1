Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbYLSW5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbYLSW5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbYLSW5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 17:57:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49080 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbYLSW5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 17:57:30 -0500
Date: Fri, 19 Dec 2008 23:57:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Paalanen <pq@iki.fi>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Pekka J Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@gmail.com>
Subject: Re: ftrace behaviour (was: [PATCH] ftrace: introduce
	tracing_reset_online_cpus() helper)
Message-ID: <20081219225717.GK13409@elte.hu>
References: <Pine.LNX.4.64.0812191207130.6888@melkki.cs.Helsinki.FI> <c62985530812190247i705d9c3er7662a1b133c6eb29@mail.gmail.com> <alpine.DEB.1.10.0812191216190.26432@gandalf.stny.rr.com> <20081220004453.50aec846@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081220004453.50aec846@daedalus.pq.iki.fi>
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


* Pekka Paalanen <pq@iki.fi> wrote:

> > I'm actually against the idea of reseting a trace everytime we enable it.
> > That is:
> > 
> > echo 1 > /debug/tracing/tracing_enabled
> > 
> > This should not reset the tracer. I actually do tracing where I disable 
> > and enable it around areas I am interested in. I want all tracing, not 
> > just the last one.
> 
> But doesn't this go against the fact, that you need to write 0 there to 
> be able to change the ring buffer size?

hm, that ftrace behavior is silly. Steve, i think i mentioned this a long 
time ago and i thought it got fixed? Changing the ring buffer size is a 
slow op, it should include an implicit reset and should be plug-and-play 
with no dependencies of having to stop the trace or something.

	Ingo
