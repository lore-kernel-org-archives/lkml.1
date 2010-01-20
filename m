Return-Path: <linux-kernel-owner+w=401wt.eu-S1753025Ab0ATGwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab0ATGwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 01:52:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008Ab0ATGwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 01:52:12 -0500
Received: from www.tglx.de ([62.245.132.106]:56075 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822Ab0ATGwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 01:52:11 -0500
Date: Wed, 20 Jan 2010 07:51:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Clark Williams <williams@redhat.com>
cc: RT <linux-rt-users@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Carsten Emde <ce@ceag.ch>, John Kacur <jkacur@redhat.com>
Subject: Re: RFC: NUMA modifications to cyclictest
In-Reply-To: <20100119171439.24726f2e@torg>
Message-ID: <alpine.LFD.2.00.1001200741000.2906@localhost.localdomain>
References: <20100119171439.24726f2e@torg>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jan 2010, Clark Williams wrote:
> RT-ers,
> 
> Lately we've been struggling with some performance issues on high-core
> count (>16 cores) NUMA machines with the RT kernel. During the course
> of troubleshooting this issue, we tried using the 'numactl' program to
> constrain our measurement testing tool (rteval) to a particular memory
> node, rather than letting everything float. Doing so showed marked
> improvement in both max latency and jitter.  While this doesn't solve
> our performance problems I thought it might make sense to have a --numa
> mode for cylictest that compliments the --smp mode just added. 
> 
> The big difference here is that when using --numa, each measurement
> thread (one per cpu) has it's stack allocated from the memory node
> associated with it's cpu. Also, the major data structures for each
> thread (parameter block, statistics block and histogram) are allocated
> from the appropriate node. This is done with calls into libnuma,
> which means this will add a dependency on libnuma. 

That might cause some trouble for embedded folks. :(
 
> The intent is to measure latency on a numa system in the same way a
> well-written RT application would run on a NUMA machine, that is
> minimizing the off-node memory references. 

Agreed.

	tglx
