Return-Path: <linux-kernel-owner+w=401wt.eu-S1752805AbYLIIMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbYLIIMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 03:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbYLIIMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 03:12:23 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50175 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbYLIIMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 03:12:23 -0500
Subject: Re: [RFC PATCH] hrtimer: removing all ur callback modes
From: Peter Zijlstra <peterz@infradead.org>
To: Oliver Hartkopp <oliver@hartkopp.net>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <493E2725.7090305@hartkopp.net>
References: <1227613431.4259.1537.camel@twins>
	 <1228385830.5092.43.camel@twins> <493BB1EB.5000004@hartkopp.net>
	 <493BC8A8.2030200@hartkopp.net> <1228731359.5778.18.camel@twins>
	 <493E2725.7090305@hartkopp.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 09 Dec 2008 09:12:11 +0100
Message-Id: <1228810331.12729.59.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-09 at 09:07 +0100, Oliver Hartkopp wrote:

> I wouldn't be that sure that all the other sites can cope with it as i 
> only detected the problems with my code under heavy load ...

Most other sites only fiddle some bits and do a wakeup of some task or
other - they usually already did spin_lock_irqsave() to protect the
state they poked at.

But sure, testing is always the best way.

> >> Any idea?
> >>     
> >
> > What are the timing constraints of your problem? - I assume they are not
> > too aggressive, otherwise you'd not be able to run from softirq, could
> > you run from keventd?
> >   
> 
> I browsed some code that's using hrtimers and found some hopefully good 
> example in drivers/s390/crypto/ap_bus.c : They are using the hrtimer to 
> schedule a tasklet which is running in soft-irq context:
> 
> http://lxr.linux.no/linux+v2.6.27.8/drivers/s390/crypto/ap_bus.c#L1150
> 
> This could also be the correct approach for my sock_queue_rcv_skb() 
> problem, right?

In as far as tasklets are correct, yes, that would work for you too.

> Regards,
> Oliver
> 
> ps. What is the intended release for this hrtimer cleanup? 2.6.29?

I think so, Thomas, Ingo?
