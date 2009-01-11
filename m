Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbZAKBkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbZAKBkI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 20:40:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbZAKBj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 20:39:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42811 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbZAKBj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 20:39:56 -0500
Date: Sun, 11 Jan 2009 02:39:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] rcu: convert rcupreempt trace to seq file
Message-ID: <20090111013940.GL12885@elte.hu>
References: <496852DE.7080802@cn.fujitsu.com> <20090110223151.GD7061@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090110223151.GD7061@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Sat, Jan 10, 2009 at 03:48:46PM +0800, Li Zefan wrote:
> > Impact: also fix a bug in show_rcustats()
> > 
> > Use seq file for simplification, and the global buffer and mutex can be
> > removed.
> 
> Looks very good, and passes my tests.
> 
> > While doing this, I found rcustats will never show 'ggp' and 'rcc' fields
> > due to a bug in show_rcustats().
> 
> Good eyes!
> 
> The only change I ask is that you pull the contents of
> rcupreempt_debugfs_init() into the now-one-line rcupreempt_trace_init().
> 
> With that change:
> 
> Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>
> > ---
> >  kernel/rcupreempt_trace.c |  155 ++++++++++++++++++++-------------------------

i think the whole kernel/rcupreempt_trace.c file might be a good candidate 
for the 'statistical tracing' extensions to ftrace that Frederice is 
working on.

That way there would just be a few tracepoints, and the rest would be done 
in kernel/tracing/trace_rcupreempt.c, or so.
	Ingo
