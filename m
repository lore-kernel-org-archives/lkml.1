Return-Path: <linux-kernel-owner+w=401wt.eu-S1757485AbXIVAcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbXIVAcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 20:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbXIVAck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 20:32:40 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35990 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211AbXIVAcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 20:32:39 -0400
Date: Fri, 21 Sep 2007 17:32:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       mingo@elte.hu, akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl, bunk@kernel.org,
       ego@in.ibm.com, oleg@tv-sign.ru, srostedt@redhat.com
Subject: Re: [PATCH RFC 3/9] RCU: Preemptible RCU
Message-ID: <20070922003235.GJ9059@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070910183004.GA3299@linux.vnet.ibm.com> <20070910183412.GC3819@linux.vnet.ibm.com> <20070921152048.GF15697@goodmis.org> <20070921230343.GE9059@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921230343.GE9059@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 04:03:43PM -0700, Paul E. McKenney wrote:
> On Fri, Sep 21, 2007 at 11:20:48AM -0400, Steven Rostedt wrote:
> > On Mon, Sep 10, 2007 at 11:34:12AM -0700, Paul E. McKenney wrote:

[ . . . ]

> > Paul,
> > 
> > Looking further into this, I still think this is a bit of overkill. We
> > go through 20 states from call_rcu to list->func().
> > 
> > On call_rcu we put our stuff on the next list. Before we move stuff from
> > next to wait, we need to go through 4 states. So we have
> > 
> > next -> 4 states -> wait[0] -> 4 states -> wait[1] -> 4 states ->
> > wait[2] -> 4 states -> wait[3] -> 4 states -> done.
> > 
> > That's 20 states that we go through from the time we add our function to
> > the list to the time it actually gets called. Do we really need the 4
> > wait lists?
> > 
> > Seems a bit overkill to me.
> > 
> > What am I missing?
> 
> "Nothing kills like overkill!!!"  ;-)
> 
> Seriously, I do expect to be able to squeeze this down over time, but
> feel the need to be a bit on the cowardly side at the moment.
> 
> In any case, I will be looking at the scenarios more carefully.  If
> it turns out that GP_STAGES can indeed be cranked down a bit, well,
> that is an easy change!  I just fired off a POWER run with GP_STAGES
> set to 3, will let you know how it goes.

The first attempt blew up during boot badly enough that ABAT was unable
to recover the machine (sorry, grahal!!!).  Just for grins, I am trying
it again on a machine that ABAT has had a better record of reviving...

						Thanx, Paul
