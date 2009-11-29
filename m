Return-Path: <linux-kernel-owner+w=401wt.eu-S1752559AbZK2P3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbZK2P3K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 10:29:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbZK2P3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 10:29:10 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43261 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbZK2P3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 10:29:09 -0500
Date: Sun, 29 Nov 2009 15:27:57 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jamie Lokier <jamie@shareable.org>
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
Subject: Re: [PATCH] warn about shared irqs requesting IRQF_DISABLED
	registered with setup_irq
Message-ID: <20091129152757.GF11445@n2100.arm.linux.org.uk>
References: <20091127195857.GB28193@n2100.arm.linux.org.uk> <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LFD.2.00.0911272234460.24119@localhost.localdomain> <20091128200344.GA1272@pengutronix.de> <alpine.LFD.2.00.0911282239430.24119@localhost.localdomain> <20091129023118.GA21529@shareable.org> <20091129102635.GA22653@pengutronix.de> <20091129151840.GA30813@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091129151840.GA30813@shareable.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 29, 2009 at 03:18:40PM +0000, Jamie Lokier wrote:
> Or we could do away with this silliness and just switch everything to
> threaded interrupts with RT-priorities ;-)

... thereby needlessly increasing the latency of all interrupt handling
and probably breaking some devices.

Some devices (eg, SMC91x, serial ports, PIO audio - AACI, MMCI) are
_extremely_ sensitive to interrupt latency due to lack of FIFO depth.

MMCI already sees overruns on ARM platforms if you try and clock the
cards at anything over about 500kHz.  Adding any more latency means
reducing the maximum clock rate there, and therefore crippling
throughput even more than it is already.
