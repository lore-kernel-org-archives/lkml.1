Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbZA0Mnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbZA0Mnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 07:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbZA0Mng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 07:43:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57419 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847AbZA0Mng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 07:43:36 -0500
Date: Tue, 27 Jan 2009 13:43:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH] create workqueue threads only when needed
Message-ID: <20090127124307.GA12788@elte.hu>
References: <20090127001708.GA4815@nowhere> <20090127030727.GA15101@agk.fab.redhat.com> <20090127085738.GB5498@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127085738.GB5498@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Tue, Jan 27, 2009 at 03:07:27AM +0000, Alasdair G Kergon wrote:
> > On Tue, Jan 27, 2009 at 01:17:11AM +0100, Frederic Weisbecker wrote:
> > > For several reasons:
> > > _ Unneeded built drivers for my system that create workqueue(s) when they init
> > > _ Services which need their own workqueue, for several reasons, but who receive
> > >   very rare jobs (often never)
> > 
> > > I hadn't any problems until now with this patch but I think it needs more testing,
> > > like with cpu hotplug, and some renaming for its functions and structures...
> > > And I would like to receive some comments and feelings before continuing. So this
> > > is just an RFC :-)
> > 
> > Make sure this optimisation also works when the system's running low 
> > on memory if workqueues are involved in "making forward progress".  
> > Doubtless there are other reasons for apparently-unused workqueues 
> > too.
> 
> That's true. But currently, each useless workqueue thread is consuming a 
> task_struct in memory, so this patch makes actually consuming less 
> memory than before. If the system is running low on memory...well 
> perhaps I can reschedule the thread creation after some delays...?

Lets put a warning in there to make sure it's not forgotten - and deal 
with it if it happens.

	Ingo
