Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab0BAQaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 11:30:18 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48224 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab0BAQaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 11:30:15 -0500
Subject: Re: [patch 2/3] scheduler: add full memory barriers upon task
 switch at runqueue lock/unlock
From: Peter Zijlstra <peterz@infradead.org>
To: rostedt@goodmis.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
In-Reply-To: <1265041477.29013.54.camel@gandalf.stny.rr.com>
References: <20100131205254.407214951@polymtl.ca>
	 <20100131210013.446503342@polymtl.ca>
	 <alpine.LFD.2.00.1002010722350.4206@localhost.localdomain>
	 <20100201160929.GA3032@Krystal>
	 <1265041477.29013.54.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 17:29:34 +0100
Message-ID: <1265041774.24455.209.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 11:24 -0500, Steven Rostedt wrote:
> 
> Doesn't set_bit imply a wmb()? If so couldn't we do:

Nope, that's what we have smp_mb__{before,after}_set_bit() for.

On x86 its a LOCK'ed op, so sure it implies a full membarrier, but not
in generic.

on x86 we have plenty serializing instructions before and after rq->curr
is set so none of the crazyness is needed at all. The only thing is !
x86.



