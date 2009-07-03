Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbZGCISX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbZGCISX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbZGCISI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:18:08 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:60325 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736AbZGCISH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:18:07 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19021.48828.428272.100850@cargo.ozlabs.ibm.com>
Date: Fri, 3 Jul 2009 18:18:04 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6 -tip] perf stat: treat same behaviour for all
	CYCLES and CLOCKS
In-Reply-To: <20090701113915.GG15958@elte.hu>
References: <1246440815.3403.3.camel@hpdv5.satnam>
	<1246440909.3403.5.camel@hpdv5.satnam>
	<1246440977.3403.7.camel@hpdv5.satnam>
	<20090701113915.GG15958@elte.hu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> Other 'compound' events might be possible too: for example a new 
> cache-hits field could be is cache-refs minus cache-misses.

Hmmm, on the MPC7450 family there are events for cache-hits and
cache-misses, so there it would be nice to be able to ask for
cache-refs and have it compute cache-hits plus cache-misses.

> I.e. the simplest model for 'compound' events would be:
> 
>   X = A / B
>   X = A - B
>   X = A + B
> 
> We could list them in the event table, with a flag that specifies 
> which arithmetic operation connects two 'atomic' counters.
> 
> Then the adding of a new compound event would only be the matter of 
> adding one more line to the event table.

Sounds nice.  If we do this we should ensure that the two events
get put into one group if possible.

Paul.
