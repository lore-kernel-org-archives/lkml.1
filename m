Return-Path: <linux-kernel-owner+w=401wt.eu-S1763676AbXHFKg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763676AbXHFKg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 06:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932089AbXHFKgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 06:36:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56065 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760570AbXHFKgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 06:36:16 -0400
Date: Mon, 6 Aug 2007 12:36:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] genirq: support multiple interrupt priorities
Message-ID: <20070806103609.GA17495@elte.hu>
References: <20070806103027.GA4624@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070806103027.GA4624@linux-sh.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mundt <lethal@linux-sh.org> wrote:

> This is a simple patch for adding trivial interrupt priority support.
> 
> I've added a ->set_prio() to the irq_chip which is implemented 
> effectively the same way as ->set_type(), it's an optional component 
> for those that really care about it.

i have no fundamental objections but it would be nice to actually 
prototype this by implementing real priority support in the hardware: 
both the i8259A and the IO-APIC/local-apic has such IRQ prioritization 
features.

> + * IRQF_PRIO_HIGH - Give IRQ a high priority
> + * IRQF_PRIO_LOW - Give IRQ a low priority

this should be a numeric scale. (Preferably in the 1-99 range (the 
hardware can then do a lower-resolution thing out of it), so that we can 
directly map this to IRQ threads and SCHED_FIFO priorities in -rt.)

	Ingo
