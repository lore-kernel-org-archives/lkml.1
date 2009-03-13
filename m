Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790AbZCMIwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbZCMIwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 04:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbZCMIwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 04:52:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:55620 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbZCMIwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:52:45 -0400
Subject: Re: [PATCH, resend] eliminate spurious pointless WARN_ON()s
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090312134822.GI11935@one.firstfloor.org>
References: <49B91A7E.76E4.0078.0@novell.com>
	 <20090312134822.GI11935@one.firstfloor.org>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 09:52:35 +0100
Message-Id: <1236934355.5188.203.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-12 at 14:48 +0100, Andi Kleen wrote:
> On Thu, Mar 12, 2009 at 01:21:50PM +0000, Jan Beulich wrote:
> > Namely during early boot, the panic() or BUG() paths may end up in
> > smp_call_function_*() with just a single online CPU. In that situation
> > the warnings generated are not only meaningless, but also result in
> > relevant output being cluttered.
> 
> I actually have patches that just fix panic/shutdown to never call
> smp_call_function(), but use an own vector. It does all kinds of other things
> too that are not appropiate in panic, like allocating memory.

Oh? The only allocation that it does it at cpu-hotplug, where it
allocates a cpu-mask thingy, and that's only a real allocation on
NR_CPUS>64.



