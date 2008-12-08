Return-Path: <linux-kernel-owner+w=401wt.eu-S1751697AbYLHKQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697AbYLHKQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 05:16:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbYLHKQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 05:16:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:33005 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbYLHKQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 05:16:20 -0500
Subject: Re: [RFC PATCH] hrtimer: removing all ur callback modes
From: Peter Zijlstra <peterz@infradead.org>
To: Oliver Hartkopp <oliver@hartkopp.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <493BC8A8.2030200@hartkopp.net>
References: <1227613431.4259.1537.camel@twins>
	 <1228385830.5092.43.camel@twins> <493BB1EB.5000004@hartkopp.net>
	 <493BC8A8.2030200@hartkopp.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 08 Dec 2008 11:15:59 +0100
Message-Id: <1228731359.5778.18.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-12-07 at 13:59 +0100, Oliver Hartkopp wrote:
> Oliver Hartkopp wrote:
> > Peter Zijlstra wrote:
> >> On Tue, 2008-11-25 at 12:43 +0100, Peter Zijlstra wrote:
> >>  
> >>> Hi,
> >>>
> >>> This is an attempt at removing some of the hrtimer complexity by
> >>> reducing the number of callback modes to 1.
> >>>
> >>> This means that all hrtimer callback functions will be ran from 
> >>> HARD-irq
> >>> context.
> >>>
> >>> I went through all the 30 odd hrtimer callback functions in the kernel
> >>> and saw only one that I'm not quite sure of, which is the one in
> >>> net/can/bcm.c - hence I'm CC-ing the folks responsible for that code.
> >>>     
> >
> > Thanks Peter.
> >
> > Indeed i assumed my hrtimer callbacks to run in soft-irq. I tried the 
> > can-bcm protocol with Ingos current linux-2.6-sched-devel.git 
> > including your patches and i did not see any issues so far. And i do 
> > not expect any (recursion) problems with hrtimer_forward() in my code 
> > either.
> >
> > But i'm not that familiar with the timer context's stuff, that i would 
> > like guaranty that the functions i use in bcm_send_user() and in 
> > bcm_can_tx() are always safe to be used in hard-irq context.
> >
> > It would be nice, if you could give me some support by double checking 
> > the correctness of the hard-irq context in the given functions.
> 
> Hi Peter,
> 
> i ran a heavy load test, which get's (reproducible) the attached outputs ...
> 
> Maybe it's not that good to define the hrtimer context to be always 
> hard-irq.

Thing is, this 'cleanup' removes quite a bit of complexity from the core
hrtimer code, and afaict your bit is the only thing that cannot seem to
cope. So I'd rather look at fixing your site than re-introduce softirqs
to hrtimers.

> Any idea?

What are the timing constraints of your problem? - I assume they are not
too aggressive, otherwise you'd not be able to run from softirq, could
you run from keventd?

