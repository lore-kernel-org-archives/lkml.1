Return-Path: <linux-kernel-owner+w=401wt.eu-S1758408AbYHVSg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408AbYHVSg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 14:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758089AbYHVSgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 14:36:00 -0400
Received: from gw.goop.org ([64.81.55.164]:52882 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757860AbYHVSfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 14:35:51 -0400
Message-ID: <48AF0702.8040303@goop.org>
Date: Fri, 22 Aug 2008 11:35:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] smp_call_function: use rwlocks on queues rather than
 rcu
References: <48AE0883.6050701@goop.org> <20080822062800.GQ14110@elte.hu> <84144f020808220006n25d684b1n9db306ddc4f58c4c@mail.gmail.com> <48AEC6B2.1080701@linux-foundation.org> <20080822151156.GA6744@linux.vnet.ibm.com> <48AEF3FD.70906@linux-foundation.org> <20080822182915.GG6744@linux.vnet.ibm.com> <20080822183346.GS23334@one.firstfloor.org>
In-Reply-To: <20080822183346.GS23334@one.firstfloor.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Right now my impression is that it is not well understood why
> the kmalloc makes the IPI that much slower. In theory a kmalloc
> shouldn't be all that slow, it's essentially just a 
> "disable interrupts; unlink object from cpu cache; enable interrupts"
> with some window dressing. kfree() is similar.
>
> Does it bounce a cache line on freeing perhaps?

I think it's just an assumption that it would be slower.  Has anyone
measured it?

(Note: The measurements I posted do not cover this path, because it was
on a two cpu system, and it was always using the call-single path.)

    J
