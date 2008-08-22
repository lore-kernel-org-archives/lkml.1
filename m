Return-Path: <linux-kernel-owner+w=401wt.eu-S1757500AbYHVS3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500AbYHVS3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 14:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbYHVS3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 14:29:33 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:48089 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbYHVS3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 14:29:32 -0400
Date: Fri, 22 Aug 2008 11:29:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] smp_call_function: use rwlocks on queues rather
	than rcu
Message-ID: <20080822182915.GG6744@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <48AE0883.6050701@goop.org> <20080822062800.GQ14110@elte.hu> <84144f020808220006n25d684b1n9db306ddc4f58c4c@mail.gmail.com> <48AEC6B2.1080701@linux-foundation.org> <20080822151156.GA6744@linux.vnet.ibm.com> <48AEF3FD.70906@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AEF3FD.70906@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 12:14:37PM -0500, Christoph Lameter wrote:
> Paul E. McKenney wrote:
> 
> >> RCU is problematic because it lets cachelines get cold. A hot cacheline that
> >> is used frequently read and written to by the same cpu is very good thing for
> >> performace.
> > 
> > So on your these large boxes, read-only cachelines are preferentially
> > ejected from the cache, so that one should write to per-CPU data
> > occasionally to keep it resident?  Or is the issue the long RCU grace
> > periods which allow the structure being freed to age out of all relevant
> > caches?  (My guess would be the second.)
> 
> The issue are the RCU grace period that are generally long enough to make the
> cacheline fall out of all caches.

Would it make sense to push the freed-by-RCU memory further up the
hierarchy, so that such memory is not mistaken for recently freed
hot-in-cache memory?

							Thanx, Paul
