Return-Path: <linux-kernel-owner+w=401wt.eu-S1761107AbXHFGPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761107AbXHFGPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 02:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbXHFGPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 02:15:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57704 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbXHFGPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 02:15:21 -0400
Date: Mon, 6 Aug 2007 08:14:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, marcin.slusarz@gmail.com
Subject: Re: [patch (take 2)] genirq: fix simple and fasteoi irq handlers
Message-ID: <20070806061459.GA26046@elte.hu>
References: <20070726081326.GA3197@ff.dom.local> <1185437431.3227.21.camel@chaos> <20070726083120.GA26910@elte.hu> <20070726085523.GA3423@ff.dom.local> <20070726091254.GA8063@elte.hu> <4bacf17f0707300029g5116e70bq4808059dc8b069f1@mail.gmail.com> <20070731155843.GA7033@elte.hu> <46B20E47.6020403@googlemail.com> <20070802201126.GA27000@elte.hu> <20070806060723.GA981@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070806060723.GA981@ff.dom.local>
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


* Jarek Poplawski <jarkao2@o2.pl> wrote:

> Subject: genirq: fix simple and fasteoi irq handlers
> 
> After the "genirq: do not mask interrupts by default" patch interrupts 
> should be disabled not immediately upon request, but after they 
> happen. But, handle_simple_irq() and handle_fasteoi_irq() can skip 
> this once or more if an irq is just serviced (IRQ_INPROGRESS), 
> possibly disrupting a driver's work.

nice fix. I think this is exactly the type of bug we were hoping to be 
able to identify and fix, and it could explain the regression in its 
entirety. The big question - does it fix Marcin's regression?

	Ingo
