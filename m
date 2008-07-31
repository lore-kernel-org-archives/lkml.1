Return-Path: <linux-kernel-owner+w=401wt.eu-S1754975AbYGaQsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbYGaQsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 12:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbYGaQsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 12:48:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49753 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbYGaQso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 12:48:44 -0400
Date: Thu, 31 Jul 2008 18:48:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86: Is there still value in having a special tlb flush IPI
	vector?
Message-ID: <20080731164826.GH26393@elte.hu>
References: <488E534F.2030204@goop.org> <200807291430.08220.nickpiggin@yahoo.com.au> <1217325288.7563.2.camel@twins> <200807292000.30690.nickpiggin@yahoo.com.au> <1217328351.7563.12.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217328351.7563.12.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2008-07-29 at 20:00 +1000, Nick Piggin wrote:
> > On Tuesday 29 July 2008 19:54, Peter Zijlstra wrote:
> > > On Tue, 2008-07-29 at 14:30 +1000, Nick Piggin wrote:
> > > > Not to mention the minor problem that it still deadlocks when called with
> > > > interrupts disabled ;)
> > >
> > > __smp_call_function_single has potential though..
> > 
> > For reschedule interrupt? I don't really agree.
> 
> How about using just arch_send_call_function_single_ipi() to implement 
> smp_send_reschedule() ?

agreed, that's just a single IPI which kicks the need_resched logic on 
return-from-interrupt.

> The overhead of that is a smp_mb() and a list_empty() check in 
> generic_smp_call_function_single_interrupt() if there is indeed no 
> work to do.

that would be a miniscule cost - cacheline is read-shared amongst cpus 
so there's no real bouncing there. So i'm all for it ...

	Ingo
