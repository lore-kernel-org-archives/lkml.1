Return-Path: <linux-kernel-owner+w=401wt.eu-S1757795AbYHVSbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795AbYHVSbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 14:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbYHVSbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 14:31:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60636 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbYHVSbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 14:31:41 -0400
Date: Fri, 22 Aug 2008 20:33:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] smp_call_function: use rwlocks on queues rather than rcu
Message-ID: <20080822183346.GS23334@one.firstfloor.org>
References: <48AE0883.6050701@goop.org> <20080822062800.GQ14110@elte.hu> <84144f020808220006n25d684b1n9db306ddc4f58c4c@mail.gmail.com> <48AEC6B2.1080701@linux-foundation.org> <20080822151156.GA6744@linux.vnet.ibm.com> <48AEF3FD.70906@linux-foundation.org> <20080822182915.GG6744@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080822182915.GG6744@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Would it make sense to push the freed-by-RCU memory further up the
> hierarchy, so that such memory is not mistaken for recently freed
> hot-in-cache memory?

Right now my impression is that it is not well understood why
the kmalloc makes the IPI that much slower. In theory a kmalloc
shouldn't be all that slow, it's essentially just a 
"disable interrupts; unlink object from cpu cache; enable interrupts"
with some window dressing. kfree() is similar.

Does it bounce a cache line on freeing perhaps?

-Andi
