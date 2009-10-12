Return-Path: <linux-kernel-owner+w=401wt.eu-S932640AbZJLPqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640AbZJLPqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932619AbZJLPqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:46:09 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:49342 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932611AbZJLPqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:46:08 -0400
Date: Mon, 12 Oct 2009 11:38:25 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tejun Heo <tj@kernel.org>, Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu
Subject: Re: [this_cpu_xx V5 19/19] SLUB: Experimental new fastpath w/o
 interrupt disable
In-Reply-To: <20091012153844.GA29116@Krystal>
Message-ID: <alpine.DEB.1.10.0910121137100.21558@gentwo.org>
References: <20091008171750.GA3370@Krystal> <alpine.DEB.1.10.0910081342540.7735@gentwo.org> <20091008191754.GA12729@Krystal> <alpine.DEB.1.10.0910081520210.8030@gentwo.org> <20091008203724.GA15798@Krystal> <alpine.DEB.1.10.0910081652190.8030@gentwo.org>
 <20091012135600.GB15605@Krystal> <alpine.DEB.1.10.0910121049580.32595@gentwo.org> <20091012152627.GA27835@Krystal> <alpine.DEB.1.10.0910121122400.21558@gentwo.org> <20091012153844.GA29116@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009, Mathieu Desnoyers wrote:

> local_irq_enable();
> preempt_enable(); <- barrier()
>
> In the first scenario, the compiler barrier is at the beginning of the
> slow path function, which should impose less restrictions on the compiler
> optimizations.

Again: The next statement is a call to a function that calls the page
allocator. Its one call vs two for me. Plus the flow of things is much
cleaner and less obfuscated.



