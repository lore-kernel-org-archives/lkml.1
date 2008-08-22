Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbYHVSii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbYHVSii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 14:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbYHVSi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 14:38:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751297AbYHVSi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 14:38:29 -0400
Message-ID: <48AF0735.60402@linux-foundation.org>
Date: Fri, 22 Aug 2008 13:36:37 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] smp_call_function: use rwlocks on queues rather	than
 rcu
References: <48AE0883.6050701@goop.org> <20080822062800.GQ14110@elte.hu> <84144f020808220006n25d684b1n9db306ddc4f58c4c@mail.gmail.com> <48AEC6B2.1080701@linux-foundation.org> <20080822151156.GA6744@linux.vnet.ibm.com> <48AEF3FD.70906@linux-foundation.org> <20080822182915.GG6744@linux.vnet.ibm.com>
In-Reply-To: <20080822182915.GG6744@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:

>>> So on your these large boxes, read-only cachelines are preferentially
>>> ejected from the cache, so that one should write to per-CPU data
>>> occasionally to keep it resident?  Or is the issue the long RCU grace
>>> periods which allow the structure being freed to age out of all relevant
>>> caches?  (My guess would be the second.)
>> The issue are the RCU grace period that are generally long enough to make the
>> cacheline fall out of all caches.
> 
> Would it make sense to push the freed-by-RCU memory further up the
> hierarchy, so that such memory is not mistaken for recently freed
> hot-in-cache memory?

That would mean passing a gfp flag like __GFP_COLD on free from RCU? Or how
would that work at the higher levels?


