Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbYHYPu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbYHYPu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 11:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbYHYPuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 11:50:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40133 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752957AbYHYPuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 11:50:14 -0400
Message-ID: <48B2D343.4020100@linux-foundation.org>
Date: Mon, 25 Aug 2008 10:44:03 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] smp_call_function: use rwlocks on queues rather	than
 rcu
References: <84144f020808220006n25d684b1n9db306ddc4f58c4c@mail.gmail.com> <48AEC6B2.1080701@linux-foundation.org> <20080822151156.GA6744@linux.vnet.ibm.com> <48AEF3FD.70906@linux-foundation.org> <20080822182915.GG6744@linux.vnet.ibm.com> <48AF0735.60402@linux-foundation.org> <20080822195226.GJ6744@linux.vnet.ibm.com> <48AF1B81.3050806@linux-foundation.org> <20080822205339.GK6744@linux.vnet.ibm.com> <1219660291.8515.20.camel@twins> <20080825151220.GA6745@linux.vnet.ibm.com>
In-Reply-To: <20080825151220.GA6745@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:

> But I am not sure that this gets the grace periods to go fast enough to
> cover Christoph's use case -- he seems to be in a "faster is better"
> space rather than in an "at least this fast" space.  Still, it would
> likely help in some important cases.

I think there was an AIM9 regression in the close/open tests when the struct
file was switched to RCU. That test could be run with various intervals to
figure out if a shorter RCU period is beneficial and how short an RCU period
is needed to avoid the regression.


