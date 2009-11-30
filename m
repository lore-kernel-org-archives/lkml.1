Return-Path: <linux-kernel-owner+w=401wt.eu-S1753109AbZK3OvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbZK3OvD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 09:51:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbZK3OvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 09:51:03 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48975 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752557AbZK3OvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 09:51:01 -0500
Date: Mon, 30 Nov 2009 14:51:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Uwe =?ISO-8859-14?B?S2xlaW5lLUv2?= =?ISO-8859-14?B?bmln?= 
	<u.kleine-koenig@pengutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Eric Miao <eric.y.miao@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       John Stultz <johnstul@us.ibm.com>, Nicolas Pitre <nico@marvell.com>,
       Jamie Lokier <jamie@shareable.org>, LKML <linux-kernel@vger.kernel.org>,
       Remy Bohmer <linux@bohmer.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       linux-arm-kernel@lists.infradead.org,
       Andrea Gallo <andrea.gallo@stericsson.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Get rid of IRQF_DISABLED - (was [PATCH] genirq: warn about
 IRQF_SHARED|IRQF_DISABLED)
Message-ID: <20091130145122.7057a1e3@lxorguk.ukuu.org.uk>
In-Reply-To: <20091130143703.GA7028@n2100.arm.linux.org.uk>
References: <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<1259578067-29169-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<alpine.LFD.2.00.0911301225110.24119@localhost.localdomain>
	<20091130143703.GA7028@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> However, I think we still have a number of corner cases.  The SMC91x
> driver comes to mind, with its stupidly small FIFOs, where the majority
> of implementations have to have the packets loaded via PIO - and this
> seems to generally happen from IRQ context.

Everything 8390 based is in the same boat. It relies on being able to
use disable_irq_nosync/enable_irq and knows all about the joys of
interrupt bus asynchronicity internally. That does however allow it to
get sane results by using the irq controller to mask the potentially
shared IRQ at source.


