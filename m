Return-Path: <linux-kernel-owner+w=401wt.eu-S946198AbXHMTKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S946198AbXHMTKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 15:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762180AbXHMTJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 15:09:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:37275 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760098AbXHMTJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 15:09:05 -0400
Subject: Re: [patch 3/3] genirq: mark io_apic level interrupts to avoid
	resend
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jarek Poplawski <jarkao2@o2.pl>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Stable Team <stable@kernel.org>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       "marcin.slusarz" <marcin.slusarz@gmail.com>
In-Reply-To: <1187006835.12828.112.camel@chaos>
References: <20070812152213.551812576@inhelltoy.tec.linutronix.de>
	 <20070812152303.177006193@inhelltoy.tec.linutronix.de>
	 <20070813112821.GA2863@ff.dom.local>  <1187006835.12828.112.camel@chaos>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 13:42:12 -0500
Message-Id: <1187030532.5330.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> handle_fasteoi_irq is special. It is used by ioapic and weird Powerpc
> hardware. We marked the ioapic level interrupts IRQ_LEVEL, so we wont
> get a resend on them (see kernel/irq/resend.c)

s/weird/sane :-)

More specifically, it's used by "intelligent" PICs that automatically do
the masking of the source (or internally handle priority levels) and
only need an "eoi" when the OS is finished processing the latest
interrupt. (On those PICs, the ack is generally an implicit part of
fetching the next pending interrupt, and the eoi consist of bringing the
current processor priority back to what it was before the interrupt
occured).

I also suspect that any hypervisor using a different method than this
one for paravirt irqs is broken :-)

Ben.


