Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbZA1SVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbZA1SVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 13:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbZA1SUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 13:20:53 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48993 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbZA1SUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 13:20:52 -0500
Subject: Re: Buggy IPI and MTRR code on low memory
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, jens.axboe@oracle.com
In-Reply-To: <alpine.DEB.1.10.0901281221450.25359@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com>
	 <1233161182.10992.52.camel@laptop>
	 <alpine.DEB.1.10.0901281221450.25359@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 19:20:34 +0100
Message-Id: <1233166834.10992.61.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-28 at 12:24 -0500, Steven Rostedt wrote:
> On Wed, 28 Jan 2009, Peter Zijlstra wrote:
> > ---
> > Subject: x86: fix potential deadlock in set_mtrr()
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date: Wed Jan 28 17:17:32 CET 2009
> > 
> > smp_call_function() can fall-back to waiting on completion in case of
> > low memory (GFP_ATOMIC). set_mtrr() relies on the async behaviour of !wait.
> > 
> > This would deadlock.
> > 
> > Fix this by providing per-cpu csd's and using __smp_call_function_single().
> 
> I applied the patch but it still locked up in the testing NMI 
> watchdog code. Not saying your patch is at fault, because we never made it 
> to your code. This is probably not an issue, since if we have low memory 
> at bootup, we have much bigger problems to deal with.
> 
> I'll have skip the NMI test and see if it locks up any place else.

Right, the NMI code does exactly the same, in that case your patch might
well be the best way forward.

