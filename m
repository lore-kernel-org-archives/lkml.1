Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841AbZCET71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbZCET71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 14:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbZCET7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 14:59:18 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:59602 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754751AbZCET7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 14:59:18 -0500
Subject: Re: [patch 3/4] genirq: add a quick check handler
From: Sven-Thorsten Dietrich <sdietrich@novell.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jon Masters <jonathan@jonmasters.org>
In-Reply-To: <20090228222408.GB7797@infradead.org>
References: <20090226131336.423054348@linutronix.de>
	 <20090226131719.640887792@linutronix.de>
	 <20090228222408.GB7797@infradead.org>
Content-Type: text/plain
Organization: Novell
Date: Thu, 05 Mar 2009 11:59:09 -0800
Message-Id: <1236283149.20484.31.camel@sven.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-02-28 at 17:24 -0500, Christoph Hellwig wrote:
> I really disagree with the notation of the pre-handler.  Instead of
> adding an additional pre handler method you should add a new threadfn
> method.  The handler could just as now handle/not handle the interrupt,
> or as a third option defer it to the thread.  That makes the different
> semantics a lot clearer, and means ->handler and ->threadfn both have
> very well defined contexts, instead of sometimes calling ->handler
> sometimes from irq and sometimes from thread context.  This also
> makes it much easier for complex hardware that might have simple and
> fast interrupts that it may want to handle directly from hardirq context
> in just a couple of cycles or complex interrupts that might be deferred
> to process context.
> 

Most of the IRQ handler, whether run in a thread or IRQ context, will be
the same code - so what you are proposing would have to eliminate code
duplication as well as heavy runtime branching overhead.

Ultimately, no matter how its done, the concept of disabling IRQ assert
at the device level, rather than the apic level, is the optimal
"correct" implementation.

Formulating that into the code, as Thomas proposed with the quickcheck,
supplies structural demarcation for semi as well as software design.

Things just get quite ugly - as-is- when you try to add runtime thread
enable and disable.

Sven


