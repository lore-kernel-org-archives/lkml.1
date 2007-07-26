Return-Path: <linux-kernel-owner+w=401wt.eu-S1765160AbXGZJC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765160AbXGZJC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 05:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756807AbXGZJCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 05:02:45 -0400
Received: from mx12.go2.pl ([193.17.41.142]:42529 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754090AbXGZJCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 05:02:43 -0400
Date: Thu, 26 Jul 2007 11:11:57 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Marcin =?iso-8859-2?Q?=A6lusarz?= <marcin.slusarz@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.20->2.6.21 - networking dies after random time
Message-ID: <20070726091157.GB3423@ff.dom.local>
References: <20070629150759.GC2771@ff.dom.local> <4bacf17f0707222244p664e7a6ap850b3357a57d73c@mail.gmail.com> <20070724080534.GC18740@elte.hu> <20070724094202.GA11610@elte.hu> <alpine.LFD.0.999.0707241228291.3607@woody.linux-foundation.org> <20070724200431.GA22190@elte.hu> <1185322771.4175.102.camel@chaos> <4bacf17f0707260016x14fc1c92s628ae64353663833@mail.gmail.com> <20070726081326.GA3197@ff.dom.local> <1185437431.3227.21.camel@chaos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185437431.3227.21.camel@chaos>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 10:10:31AM +0200, Thomas Gleixner wrote:
> On Thu, 2007-07-26 at 10:13 +0200, Jarek Poplawski wrote:
...
> > PS: Now, it seems to me Thomas could be the nearest. BTW, could somebody
> > give me some tip, how these re-triggered interrupts are skipped on dev's
> > reset before enable_irq?
> 
> I think the correct solution is really not to resend level type
> interrupts. If the interrupt line is still active, then the interrupt
> comes up by itself. I'm cooking a patch for that.
> 
> The other question is: 
> 
> Is the driver confused by the resent irq or is the chip-set unhappy
> about the resend ?
> 
> We could figure the latter out by activating the software based resend
> method.

Probably I miss something, but isn't there any problem with level type,
when APIC re-triggers an interrupt, which is not acked by driver nor
card (after some hw reset/clear)?

Jarek P.
