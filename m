Return-Path: <linux-kernel-owner+w=401wt.eu-S933300AbXGZILJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300AbXGZILJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 04:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765809AbXGZIKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 04:10:38 -0400
Received: from www.osadl.org ([213.239.205.134]:56405 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764235AbXGZIKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 04:10:34 -0400
Subject: Re: 2.6.20->2.6.21 - networking dies after random time
From: Thomas Gleixner <tglx@linutronix.de>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Marcin =?UTF-8?Q?=C5=9Alusarz?= <marcin.slusarz@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20070726081326.GA3197@ff.dom.local>
References: <JKE37W$0126317E099DF36884CC046B6F8A7AA9@xandmail.com>
	 <20070629150759.GC2771@ff.dom.local>
	 <4bacf17f0707222244p664e7a6ap850b3357a57d73c@mail.gmail.com>
	 <20070724080534.GC18740@elte.hu> <20070724094202.GA11610@elte.hu>
	 <alpine.LFD.0.999.0707241228291.3607@woody.linux-foundation.org>
	 <20070724200431.GA22190@elte.hu> <1185322771.4175.102.camel@chaos>
	 <4bacf17f0707260016x14fc1c92s628ae64353663833@mail.gmail.com>
	 <20070726081326.GA3197@ff.dom.local>
Content-Type: text/plain
Date: Thu, 26 Jul 2007 10:10:31 +0200
Message-Id: <1185437431.3227.21.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-26 at 10:13 +0200, Jarek Poplawski wrote:
> > I wanted to test them all on 2.6.22.1, but I didn't have enough time.
> > I've verified only that 2.6.22.1 has the same problem. I can test it
> > later, but I can report results back at beginning of next week.
> 
> 
> So, everything is clear - any changes are good!
> Except the signed-off ones... 
> 
> Thanks Marcin,
> Jarek P.
> 
> PS: Now, it seems to me Thomas could be the nearest. BTW, could somebody
> give me some tip, how these re-triggered interrupts are skipped on dev's
> reset before enable_irq?

I think the correct solution is really not to resend level type
interrupts. If the interrupt line is still active, then the interrupt
comes up by itself. I'm cooking a patch for that.

The other question is: 

Is the driver confused by the resent irq or is the chip-set unhappy
about the resend ?

We could figure the latter out by activating the software based resend
method.

	tglx


