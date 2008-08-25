Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbYHYUF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbYHYUF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 16:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755213AbYHYUFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 16:05:14 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:55343 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbYHYUFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 16:05:13 -0400
Date: Mon, 25 Aug 2008 13:05:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] smp_call_function: use rwlocks on queues rather
	than rcu
Message-ID: <20080825200509.GH6745@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080822151156.GA6744@linux.vnet.ibm.com> <48AEF3FD.70906@linux-foundation.org> <20080822182915.GG6744@linux.vnet.ibm.com> <48AF0735.60402@linux-foundation.org> <20080822195226.GJ6744@linux.vnet.ibm.com> <48AF1B81.3050806@linux-foundation.org> <20080822205339.GK6744@linux.vnet.ibm.com> <1219660291.8515.20.camel@twins> <20080825151220.GA6745@linux.vnet.ibm.com> <48B2D343.4020100@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B2D343.4020100@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 10:44:03AM -0500, Christoph Lameter wrote:
> Paul E. McKenney wrote:
> 
> > But I am not sure that this gets the grace periods to go fast enough to
> > cover Christoph's use case -- he seems to be in a "faster is better"
> > space rather than in an "at least this fast" space.  Still, it would
> > likely help in some important cases.
> 
> I think there was an AIM9 regression in the close/open tests when the struct
> file was switched to RCU. That test could be run with various intervals to
> figure out if a shorter RCU period is beneficial and how short an RCU period
> is needed to avoid the regression.

Well, with some luck, I can get an RCU implementation that allows the
grace-period duration to be varied, which would allow someone to check
the AIM9 regression.

							Thanx, Paul
