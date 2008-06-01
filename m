Return-Path: <linux-kernel-owner+w=401wt.eu-S1753585AbYFAQQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbYFAQQY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 12:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbYFAQQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 12:16:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36475 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbYFAQQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 12:16:09 -0400
Date: Sun, 1 Jun 2008 18:25:17 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Marin Mitov <mitov@issp.bas.bg>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, akpm@osdl.org,
       Ingo Molnar <mingo@elte.hu>, Clark Williams <clark.williams@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [PATCH][resubmit] x86: enable preemption in delay
Message-ID: <20080601162517.GH20824@one.firstfloor.org>
References: <200805252108.25011.mitov@issp.bas.bg> <alpine.LFD.1.10.0805260006110.3295@apollo.tec.linutronix.de> <200806011901.23619.mitov@issp.bas.bg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806011901.23619.mitov@issp.bas.bg>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  static void delay_tsc(unsigned long loops)
>  {
> -	unsigned long bclock, now;
> +	unsigned prev, prev_1, now;
> +	unsigned left = loops;
> +	unsigned prev_cpu, cpu;
> +
> +	preempt_disable();
> +	rdtscl(prev);


The unsigneds should be probably u64  and the rdtsc rdtscll.
Otherwise this will all overflow for longer waits on a very
fast systems (e.g. a 5Ghz system wraps 32bit in ~1.1 seconds)
Normally such delays shouldn't be that long, but why risk
overflow even in extreme cases?

-Andi
