Return-Path: <linux-kernel-owner+w=401wt.eu-S1755101AbZHNLVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101AbZHNLVB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 07:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754907AbZHNLVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 07:21:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33104 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753943AbZHNLVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 07:21:00 -0400
Date: Fri, 14 Aug 2009 12:20:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>,
       Brian Swetland <swetland@google.com>,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       David Brownell <david-b@pacbell.net>, Daniel Ribeiro <drwyrm@gmail.com>,
       arve@android.com, Barry Song <21cnbao@gmail.com>
Subject: Re: [RFC patch 2/3] genirq: Add buslock support for irq chips on
 slow busses
Message-ID: <20090814112059.GB17755@rakim.wolfsonmicro.main>
References: <20090813191535.945521006@linutronix.de>
 <20090813193116.509070851@linutronix.de>
 <20090814101739.GA32418@elf.ucw.cz>
 <alpine.LFD.2.00.0908141220190.1283@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0908141220190.1283@localhost.localdomain>
X-Cookie: Reactor error - core dumped!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 12:20:49PM +0200, Thomas Gleixner wrote:
> On Fri, 14 Aug 2009, Pavel Machek wrote:

> > AFAICT this means that driver would need to know what kind of IRQ it
> > is hooked to, right? That will lead to some ugly code in drivers that
> > can handle both normal and slowbus irqs, right?

> Are there such drivers in reality ?

Yes.  The GPIO based stuff is the prime example but there's other
examples - one is the WM831x touchscreen (no driver in mainline yet)
which can use interrupts via the main interrupt controller on the CPU
but also has the option of bringing the interrupt signals out to
dedicated pins on the chip for direct connection to the CPU precisely to
avoid the overheads of these slow interrupt controllers.
