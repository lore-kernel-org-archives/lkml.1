Return-Path: <linux-kernel-owner+w=401wt.eu-S1757072AbYGaVPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072AbYGaVPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 17:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbYGaVPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 17:15:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41537 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbYGaVPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:15:40 -0400
Subject: Re: x86: Is there still value in having a special tlb flush IPI
	vector?
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080731205726.GE25138@elte.hu>
References: <488E534F.2030204@goop.org>
	 <200807291430.08220.nickpiggin@yahoo.com.au>
	 <1217325288.7563.2.camel@twins>
	 <200807292000.30690.nickpiggin@yahoo.com.au>
	 <1217328351.7563.12.camel@twins> <4891FB0A.907@goop.org>
	 <20080731205726.GE25138@elte.hu>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 23:15:09 +0200
Message-Id: <1217538909.8157.99.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-31 at 22:57 +0200, Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > Peter Zijlstra wrote:
> > > How about using just arch_send_call_function_single_ipi() to implement
> > > smp_send_reschedule() ?
> > >
> > > The overhead of that is a smp_mb() and a list_empty() check in
> > > generic_smp_call_function_single_interrupt() if there is indeed no work
> > > to do.
> > 
> > Is doing a no-op interrupt sufficient on all architectures?  Is there 
> > some change a function call IPI might not go through the normal 
> > reschedule interrupt exit path?
> 
> We'd still use the smp_send_reschdule(cpu) API, so it's an architecture 
> detail. On x86 we'd use arch_send_call_function_single_ipi().

Also, all interrupts _should_ do the regular interrupt enter/exit paths,
we fixup stuff there, like jiffies and such.

We had a fun NO_HZ bug the other day because some sparc64 IPIs didn't.

