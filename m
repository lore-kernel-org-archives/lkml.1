Return-Path: <linux-kernel-owner+w=401wt.eu-S1751782AbZAKFQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbZAKFQS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 00:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbZAKFQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 00:16:06 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56111 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbZAKFQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 00:16:04 -0500
Date: Sat, 10 Jan 2009 21:16:04 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] rcu: convert rcupreempt trace to seq file
Message-ID: <20090111051604.GF7061@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <496852DE.7080802@cn.fujitsu.com> <20090110223151.GD7061@linux.vnet.ibm.com> <20090111013940.GL12885@elte.hu> <20090111050129.GA6131@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090111050129.GA6131@nowhere>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 06:01:31AM +0100, Frederic Weisbecker wrote:
> On Sun, Jan 11, 2009 at 02:39:40AM +0100, Ingo Molnar wrote:
> > 
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > On Sat, Jan 10, 2009 at 03:48:46PM +0800, Li Zefan wrote:
> > > > Impact: also fix a bug in show_rcustats()
> > > > 
> > > > Use seq file for simplification, and the global buffer and mutex can be
> > > > removed.
> > > 
> > > Looks very good, and passes my tests.
> > > 
> > > > While doing this, I found rcustats will never show 'ggp' and 'rcc' fields
> > > > due to a bug in show_rcustats().
> > > 
> > > Good eyes!
> > > 
> > > The only change I ask is that you pull the contents of
> > > rcupreempt_debugfs_init() into the now-one-line rcupreempt_trace_init().
> > > 
> > > With that change:
> > > 
> > > Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > >
> > > > ---
> > > >  kernel/rcupreempt_trace.c |  155 ++++++++++++++++++++-------------------------
> > 
> > i think the whole kernel/rcupreempt_trace.c file might be a good candidate 
> > for the 'statistical tracing' extensions to ftrace that Frederice is 
> > working on.
> > 
> > That way there would just be a few tracepoints, and the rest would be done 
> > in kernel/tracing/trace_rcupreempt.c, or so.
> > 	Ingo
> 
> Indeed!
> 
> The debugfs and seqfile handling and handled in the statistical
> tracing engine.
> 
> You just have to provide an iterator for your stat entries through two callbacks:
> 
> _ stat_start() -> gives the first entry
> _ stat_next() -> iterates over the next entry
> 
> And an output callback
> 
> _ stat_show() -> print one entry from your stat list
> 
> And two optional things:
> 
> _ stat_cmp() -> compare two entries, useful if you want your stats to be sorted
> _ stat_headers() -> provide the first line in your stat file, typically to describe your columns
> 
> The last thing you need is to give a name to your trace file.
> You will retrieve it into /debugfs/tracing/trace_stat/your_file_name as a current snapshot
> of your stats.
> 
> It is currently used by the branch tracer, and by a pending patch for a new workqueue
> tracer which will provide you a simple example.
> 
> If you have any question about how to use it, don't hesitate to ask.

Li Zefan, is this something you would be willing to try?  Sounds like
it might be a good addition.

							Thanx, Paul
