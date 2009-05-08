Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbZEHORI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbZEHORI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 10:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757795AbZEHOQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 10:16:54 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:33212 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756562AbZEHOQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 10:16:53 -0400
Date: Fri, 8 May 2009 10:16:10 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Peter Zijlstra <peterz@infradead.org>, Alok Kataria <akataria@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86: Reduce the default HZ value
In-Reply-To: <20090508125023.GA6935@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.1.10.0905081012420.23875@qirst.com>
References: <4A00ADDE.9000908@zytor.com> <1241560625.8665.17.camel@alok-dev1> <alpine.DEB.1.10.0905071010170.24528@qirst.com> <1241716053.6311.1514.camel@laptop> <1241716422.6311.1524.camel@laptop> <1241716718.6311.1531.camel@laptop> <20090507173608.GC6693@linux.vnet.ibm.com>
 <1241717904.6311.1558.camel@laptop> <20090507180112.GE6693@linux.vnet.ibm.com> <1241778776.6311.2585.camel@laptop> <20090508125023.GA6935@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 May 2009, Paul E. McKenney wrote:

> > Can't you simply enter idle state after a grace period completes and
> > finds no pending callbacks for the next period. And leave idle state at
> > the next call_rcu()?
>
> If there were no RCU callbacks -globally- across all CPUs, yes.  But
> the check at the end of rcu_irq_exit() is testing only on the current
> CPU.  Checking across all CPUs is expensive and racy.
>
> So what happens instead is that there is rcu_needs_cpu(), which gates
> entry into dynticks-idle mode.  This function returns 1 if there are
> callbacks on the current CPU.  So, if no CPU has an RCU callback, then
> all CPUs can enter dynticks-idle mode so that the entire system is
> quiescent from an RCU viewpoint -- no RCU processing at all.

Did not follow RCU developments. But wasnt there a time when RCU periods
were processor specific and a global RCU period was done when all the
processors went through their rcu periods?

Cpu cache hotness may not be relevant to RCU since rcu involves long time
periods in which cachelines cool down. Can the RCU callbacks all be done
on processor 0 (or a so designated processor)? That would avoiding
disturbances of the other processors.



