Return-Path: <linux-kernel-owner+w=401wt.eu-S1752783AbZHXPme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbZHXPme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 11:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbZHXPmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 11:42:32 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45994 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbZHXPmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 11:42:31 -0400
Date: Mon, 24 Aug 2009 08:42:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josht@linux.vnet.ibm.com,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       rostedt@goodmis.org
Subject: Re: [PATCH -tip] v3 Simplify rcu_pending()/rcu_check_callbacks()
	API
Message-ID: <20090824154230.GE6677@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090727181401.GA14120@linux.vnet.ibm.com> <1251097816.7538.129.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251097816.7538.129.camel@twins>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 09:10:16AM +0200, Peter Zijlstra wrote:
> On Sat, 2009-08-22 at 13:56 -0700, Paul E. McKenney wrote:
> > From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > All calls from outside RCU are of the form:
> > 
> > 	if (rcu_pending(cpu))
> > 		rcu_check_callbacks(cpu, user);
> > 
> > This is silly, instead we put a call to rcu_pending() in
> > rcu_check_callbacks(),
> 
> It could be non-silly if rcu_pending() were a very simple inline
> function, in that case it would avoid the full function call.
> 
> Still in such a case you can make rcu_check_callbacks() the inline
> function which does the same and have the real function called somthing
> else.
> 
> Anyway, its all moot since rcu_pending() wasn't a simple inline function
> anyway, so you've replaced two function calls with one, which seems
> good.

Indeed, there was a time when rcu_pending() was a much simpler function,
but those days are long past.  ;-)

Thank you for looking this over!!!

							Thanx, Paul
