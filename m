Return-Path: <linux-kernel-owner+w=401wt.eu-S1756881AbYG2Kq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbYG2Kq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 06:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbYG2KqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 06:46:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36964 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbYG2KqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 06:46:19 -0400
Subject: Re: x86: Is there still value in having a special tlb flush IPI
	vector?
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <200807292000.30690.nickpiggin@yahoo.com.au>
References: <488E534F.2030204@goop.org>
	 <200807291430.08220.nickpiggin@yahoo.com.au>
	 <1217325288.7563.2.camel@twins>
	 <200807292000.30690.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 12:45:51 +0200
Message-Id: <1217328351.7563.12.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-29 at 20:00 +1000, Nick Piggin wrote:
> On Tuesday 29 July 2008 19:54, Peter Zijlstra wrote:
> > On Tue, 2008-07-29 at 14:30 +1000, Nick Piggin wrote:
> > > Not to mention the minor problem that it still deadlocks when called with
> > > interrupts disabled ;)
> >
> > __smp_call_function_single has potential though..
> 
> For reschedule interrupt? I don't really agree.

How about using just arch_send_call_function_single_ipi() to implement
smp_send_reschedule() ?

The overhead of that is a smp_mb() and a list_empty() check in
generic_smp_call_function_single_interrupt() if there is indeed no work
to do.



