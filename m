Return-Path: <linux-kernel-owner+w=401wt.eu-S1753064AbZK3Uju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbZK3Uju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 15:39:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZK3Ujt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 15:39:49 -0500
Received: from mail2.shareable.org ([80.68.89.115]:58483 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbZK3Ujs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 15:39:48 -0500
Date: Mon, 30 Nov 2009 20:39:33 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Eric Miao <eric.y.miao@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       John Stultz <johnstul@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Nicolas Pitre <nico@marvell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] warn about shared irqs requesting IRQF_DISABLED registered with setup_irq
Message-ID: <20091130203933.GC5560@shareable.org>
References: <20091127195857.GB28193@n2100.arm.linux.org.uk> <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LFD.2.00.0911272234460.24119@localhost.localdomain> <20091128200344.GA1272@pengutronix.de> <alpine.LFD.2.00.0911282239430.24119@localhost.localdomain> <20091129023118.GA21529@shareable.org> <20091129102635.GA22653@pengutronix.de> <20091129151840.GA30813@shareable.org> <20091129152757.GF11445@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091129152757.GF11445@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> On Sun, Nov 29, 2009 at 03:18:40PM +0000, Jamie Lokier wrote:
> > Or we could do away with this silliness and just switch everything to
> > threaded interrupts with RT-priorities ;-)
> 
> ... thereby needlessly increasing the latency of all interrupt handling
> and probably breaking some devices.

It's not that cut and dried.  RT gives you priorities where you might
not have had them before, so in some cases can reduce worst-case
latency for critical devices.  IRQF_DISABLED is a cheap two-level
priority scheme; RT threaded interrupts extend it.

The extra processing increases latency, yes, but that is in a sense a
scheduling fast-path problem; it's not _intrinsic_ to threaded
interrupts that they have to have higher latency (you don't have to
use the normal calculation or task switch to get equivalent
behaviour), but undoubtedly trying to optimise that leads to very
twisty code and state representations, and I don't see it happening in
Linux any time soon.

-- Jamie
