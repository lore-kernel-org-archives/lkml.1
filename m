Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbZEVJ45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbZEVJ45 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 05:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755119AbZEVJ4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 05:56:25 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:33100 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbZEVJ4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 05:56:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18966.28798.540702.311966@cargo.ozlabs.ibm.com>
Date: Fri, 22 May 2009 19:29:31 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] perf_counter: optimize context switch between
 identical inherited contexts
In-Reply-To: <1242981131.26820.620.camel@twins>
References: <18966.10075.781053.231153@cargo.ozlabs.ibm.com>
	<18966.10666.517218.332164@cargo.ozlabs.ibm.com>
	<1242981131.26820.620.camel@twins>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> Suppose someone writes a malicious proglet that inherits the counters,
> puts the child to sleep, does 2^32 mods on the counter set, and then
> wakes up the child.
> 
> Would that merely corrupt the results, or make the kernel explode?

You'd have to do something like create some counters on yourself,
fork, do the 2^32 counter creations and deletions, then do another
fork.  All that would happen is that some of the counters would count
on one of the child processes when they should be counting on the
other.

But it would be easy and cheap to make the generation count be 64
bits, and then it won't overflow in my lifetime at least, and after
that I don't care. :)  So I agree with Ingo that we should just do
that.

Paul.
