Return-Path: <linux-kernel-owner+w=401wt.eu-S1752941AbZJGPFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbZJGPFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 11:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbZJGPFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 11:05:07 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:38782 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751215AbZJGPFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 11:05:05 -0400
Date: Wed, 7 Oct 2009 10:42:11 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tejun Heo <tj@kernel.org>, Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu
Subject: Re: [this_cpu_xx V5 19/19] SLUB: Experimental new fastpath w/o
 interrupt disable
In-Reply-To: <20091007124628.GB27363@Krystal>
Message-ID: <alpine.DEB.1.10.0910071039520.5671@gentwo.org>
References: <20091006233654.815079668@gentwo.org> <20091006233733.153341605@gentwo.org> <20091007025440.GB4664@Krystal> <1254906707.26976.225.camel@twins> <20091007124628.GB27363@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Oct 2009, Mathieu Desnoyers wrote:

> Yes, I understood this is what he was doing, but I wonder about the
> impact on the scheduler. If we have:
>
> * Jiffy 1 -- timer interrupt
>
> * preempt disable
> * Jiffy 2 -- timer interrupt
>   -> here, the scheduler is disabled, so the timer interrupt is skipped.
>      The scheduler depends on preempt_check_resched() at preempt_enable()
>      to execute in a bounded amount of time.

preempt disable does not disable interrupts. The timer interrupt will
occur. The scheduler may not reschedule another job on this processor
when the timer interrupt calls the scheduler_tick. It
may not do load balancing.

> Also, preempt_enable here should be replaced with
> preempt_enable_no_resched().

Used to have that in earlier incarnations but I saw a lot of these being
removed lately.



