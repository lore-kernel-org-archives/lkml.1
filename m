Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbZESMi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbZESMi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 08:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbZESMix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 08:38:53 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:34524 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677AbZESMix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 08:38:53 -0400
Date: Tue, 19 May 2009 05:38:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: add trace_event_read_lock()
Message-ID: <20090519123853.GC7159@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4A114806.7090302@cn.fujitsu.com> <20090518135930.GC4704@nowhere> <20090519003505.GK6768@linux.vnet.ibm.com> <4A124080.7010400@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A124080.7010400@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 01:15:44PM +0800, Lai Jiangshan wrote:
> Paul E. McKenney wrote:
> > On Mon, May 18, 2009 at 03:59:31PM +0200, Frederic Weisbecker wrote:
> >> On Mon, May 18, 2009 at 07:35:34PM +0800, Lai Jiangshan wrote:
> >>> I found that there is nothing to protect event_hash in
> >>> ftrace_find_event().
> >> Actually, rcu protects it, but not enough. We have neither
> >> synchronize_rcu() nor rcu_read_lock.
> >>
> >> So we protect against concurrent hlist accesses.
> >> But the event can be removed when a module is unloaded,
> >> and that can happen between the time we get the event output
> >> callback and the time we actually use it.
> > 
> > I will ask the stupid question...  Would invoking rcu_barrier() in the
> > module-exit function take care of this?  The rcu_barrier() primitive
> > waits for all in-flight RCU callbacks to complete execution.
> > 
> > 							Thanx, Paul
> > 
> 
> We have no call_rcu* in it.

OK, I will ask the next stupid question...  Is it possible to use the
same trick rcu_barrier() uses, but for your events?

							Thanx, Paul
