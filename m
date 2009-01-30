Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbZA3QFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbZA3QFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 11:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZA3QFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 11:05:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751525AbZA3QFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 11:05:05 -0500
Date: Fri, 30 Jan 2009 08:04:01 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <peterz@infradead.org>
cc: Jens Axboe <jens.axboe@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, npiggin@suse.de,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH -v3] use per cpu data for single cpu ipi calls
In-Reply-To: <1233318733.4495.174.camel@laptop>
Message-ID: <alpine.LFD.2.00.0901300800350.3150@localhost.localdomain>
References: <alpine.DEB.1.10.0901281916400.9203@gandalf.stny.rr.com>  <20090128173039.cbc29e81.akpm@linux-foundation.org>  <1233218954.7835.11.camel@twins>  <alpine.DEB.1.10.0901290958170.13065@gandalf.stny.rr.com>  <alpine.LFD.2.00.0901290912320.3123@localhost.localdomain>
  <alpine.DEB.1.10.0901291232570.27527@gandalf.stny.rr.com>  <alpine.LFD.2.00.0901290959540.3123@localhost.localdomain>  <1233253380.4495.123.camel@laptop>  <alpine.LFD.2.00.0901291030510.3123@localhost.localdomain>  <1233254680.4495.126.camel@laptop> 
 <20090130112310.GI30821@kernel.dk> <1233318733.4495.174.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 Jan 2009, Peter Zijlstra wrote:
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Acked-by: Linus Torvalds <torvalds@linux-foundation.org>

My only question is whetherr we might even drop the kmalloc() some day: 
I suspect that the CSD_FLAG_LOCK is essentially never a contention point, 
and the cost (and occasional synchronization) of kmalloc() quite possibly 
overwhelms any theoretical scaling ability.

If another CPU hasn't even received its IPI before the same CPU sends the 
next one, I'm not sure we _want_ to send one, in fact.

But that's a secondary issue, and isn't a correctness thing, just a "do we 
really need three different allocations?" musing..

		Linus
