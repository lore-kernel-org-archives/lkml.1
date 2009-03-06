Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbZCFKGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbZCFKGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 05:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbZCFKGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 05:06:22 -0500
Received: from gate.crashing.org ([63.228.1.57]:57164 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547AbZCFKGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 05:06:21 -0500
Subject: Re: [RFC][PATCH] irq: remove IRQF_DISABLED
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1236333543.7260.138.camel@pasglop>
References: <1235996477.5330.174.camel@laptop>
	 <alpine.LFD.2.00.0903020852220.3111@localhost.localdomain>
	 <1236329922.7260.127.camel@pasglop>  <1236330733.6326.15.camel@laptop>
	 <1236333543.7260.138.camel@pasglop>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 21:05:09 +1100
Message-Id: <1236333909.7260.141.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> No, you don't get unlimited IRQ nesting, at least not on sane archs with
> a decent PIC that does things like what I described above :-)

Note that if unlimited nesting is what you are afraid of, you can do
something along the lines of:

-        if (!(action->flags & IRQF_DISABLED))
+        if (arch_nest_irq() && !(action->flags & IRQF_DISABLED))
                local_irq_enable_in_hardirq();

With arch_nest_irq() then set to always return 0 if you want, or be
smarter and check how much stack space is left, and return 1 only if
above a reasonable threshold.

Cheers,
Ben.


