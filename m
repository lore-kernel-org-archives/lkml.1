Return-Path: <linux-kernel-owner+w=401wt.eu-S933466AbXG3M7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933466AbXG3M7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 08:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760896AbXG3M7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 08:59:04 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38742 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760057AbXG3M7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 08:59:00 -0400
Date: Mon, 30 Jul 2007 14:05:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jarek Poplawski <jarkao2@o2.pl>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Marcin ??lusarz <marcin.slusarz@gmail.com>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.20->2.6.21 - networking dies after random time
Message-ID: <20070730140517.68babf76@the-village.bc.nu>
In-Reply-To: <20070730084651.GA14146@elte.hu>
References: <JKE37W$0126317E099DF36884CC046B6F8A7AA9@xandmail.com>
	<20070629150759.GC2771@ff.dom.local>
	<4bacf17f0707222244p664e7a6ap850b3357a57d73c@mail.gmail.com>
	<20070724080534.GC18740@elte.hu>
	<20070724094202.GA11610@elte.hu>
	<alpine.LFD.0.999.0707241228291.3607@woody.linux-foundation.org>
	<20070724200431.GA22190@elte.hu>
	<1185322771.4175.102.camel@chaos>
	<20070725135718.GB1843@ff.dom.local>
	<20070725154656.54fd6f13@the-village.bc.nu>
	<20070730084651.GA14146@elte.hu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So the whole locking is to be able to keep irqs enabled for a long time, 
> without risking entry of the same IRQ handler on this same CPU, correct?

As implemented - on any CPU.

We also need to know that the IRQ handler is not doing useful work on
another processor which is why we take the lock after disabling the
interrupt line everywhere. Without that we might be completing an IRQ on
another CPU and that would race the transmit and make a nasty mess.

> So it seems to me that maybe the driver could be surprised via these 
> spurious interrupts that happen right after the irq_enable(). Does the 
> patch below make any sense in your opinion?

For MMIO it does look like that may be needed. Looks sensible.

