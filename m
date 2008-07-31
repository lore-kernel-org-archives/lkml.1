Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbYGaU54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbYGaU54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 16:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbYGaU5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 16:57:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48058 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbYGaU5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 16:57:47 -0400
Date: Thu, 31 Jul 2008 22:57:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86: Is there still value in having a special tlb flush IPI
	vector?
Message-ID: <20080731205726.GE25138@elte.hu>
References: <488E534F.2030204@goop.org> <200807291430.08220.nickpiggin@yahoo.com.au> <1217325288.7563.2.camel@twins> <200807292000.30690.nickpiggin@yahoo.com.au> <1217328351.7563.12.camel@twins> <4891FB0A.907@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4891FB0A.907@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Peter Zijlstra wrote:
> > How about using just arch_send_call_function_single_ipi() to implement
> > smp_send_reschedule() ?
> >
> > The overhead of that is a smp_mb() and a list_empty() check in
> > generic_smp_call_function_single_interrupt() if there is indeed no work
> > to do.
> 
> Is doing a no-op interrupt sufficient on all architectures?  Is there 
> some change a function call IPI might not go through the normal 
> reschedule interrupt exit path?

We'd still use the smp_send_reschdule(cpu) API, so it's an architecture 
detail. On x86 we'd use arch_send_call_function_single_ipi().

	Ingo
