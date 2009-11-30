Return-Path: <linux-kernel-owner+w=401wt.eu-S1752367AbZK3UPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbZK3UPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 15:15:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbZK3UPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 15:15:33 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:35639 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbZK3UPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 15:15:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jYWk6y3L4fCiUCSTfulk3HkDRCGr2Gzh5iKkYhUxaFBzhAhAF/eVsfmdB+GphgCB3l
         4E689QowFa2vkM4AmJwB4CdG18d2xks+BZT+ziTYNvC7c/M3mtjItqwLryH3niTvhHr8
         BUi2a1645r8twG+8IvOX61Rzzi262JVS8yDto=
MIME-Version: 1.0
In-Reply-To: <20091130150100.GB7028@n2100.arm.linux.org.uk>
References: <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1259578067-29169-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <alpine.LFD.2.00.0911301225110.24119@localhost.localdomain>
	 <1259589780.26472.18.camel@laptop>
	 <alpine.LFD.2.00.0911301519120.24119@localhost.localdomain>
	 <20091130144702.14bea0ee@lxorguk.ukuu.org.uk>
	 <20091130150100.GB7028@n2100.arm.linux.org.uk>
Date: Mon, 30 Nov 2009 22:15:38 +0200
Message-ID: <cd73a99e0911301215i7a61b468w3b49325bd1fda3ac@mail.gmail.com>
Subject: Re: Get rid of IRQF_DISABLED - (was [PATCH] genirq: warn about 
	IRQF_SHARED|IRQF_DISABLED)
From: Andrew Victor <avictor.za@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Eric Miao <eric.y.miao@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jamie Lokier <jamie@shareable.org>, LKML <linux-kernel@vger.kernel.org>,
       Remy Bohmer <linux@bohmer.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Andrea Gallo <andrea.gallo@stericsson.com>,
       =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>, Nicolas Pitre <nico@marvell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

> There is hardware out there (AT91) where
> the timer interrupt is shared with other peripherals, and you end
> up with a mixture of irqs-disabled and irqs-enabled handlers sharing
> the same interrupt.

For the AT91 case I don't think this shouldn't matter.

The AT91's have a priority-level interrupt controller, so:
  1. a lower-priority interrupt won't interrupt a higher-priority
  2. shared interrupts cannot interrupt each other until irq_finish()
is called (a write to AIC_EOICR)

Since the Timer, DBGU serial port (and other system peripherals) are
on the same priority level they cannot interrupt each other.
(ie, basically as-if always irqs-disabled).

The case of irqs-enabled does means that a higher-priority interrupt
could interrupt [*], but it's not a shared-IRQ in that case.

([*] The system peripherals have the highest priority by default, so
the user would need to override the defaults for this to occur)


Regards,
 Andrew Victor
