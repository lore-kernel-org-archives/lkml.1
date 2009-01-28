Return-Path: <linux-kernel-owner+w=401wt.eu-S1752313AbZA1RZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbZA1RZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 12:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbZA1RYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 12:24:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56078 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbZA1RYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 12:24:50 -0500
Date: Wed, 28 Jan 2009 12:24:48 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, jens.axboe@oracle.com
Subject: Re: Buggy IPI and MTRR code on low memory
In-Reply-To: <1233161182.10992.52.camel@laptop>
Message-ID: <alpine.DEB.1.10.0901281221450.25359@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com> <1233161182.10992.52.camel@laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 28 Jan 2009, Peter Zijlstra wrote:
> ---
> Subject: x86: fix potential deadlock in set_mtrr()
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Wed Jan 28 17:17:32 CET 2009
> 
> smp_call_function() can fall-back to waiting on completion in case of
> low memory (GFP_ATOMIC). set_mtrr() relies on the async behaviour of !wait.
> 
> This would deadlock.
> 
> Fix this by providing per-cpu csd's and using __smp_call_function_single().

I applied the patch but it still locked up in the testing NMI 
watchdog code. Not saying your patch is at fault, because we never made it 
to your code. This is probably not an issue, since if we have low memory 
at bootup, we have much bigger problems to deal with.

I'll have skip the NMI test and see if it locks up any place else.

-- Steve


