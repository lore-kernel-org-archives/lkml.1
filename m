Return-Path: <linux-kernel-owner+w=401wt.eu-S933430AbXJPHuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933430AbXJPHuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 03:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763386AbXJPHtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 03:49:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42415 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759294AbXJPHty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 03:49:54 -0400
Date: Tue, 16 Oct 2007 09:49:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, shemminger@linux-foundation.org
Subject: Re: [patch] forcedeth: fix the NAPI poll function
Message-ID: <20071016074943.GA24481@elte.hu>
References: <20071015112430.GA30006@elte.hu> <20071015.125731.79447899.davem@davemloft.net> <20071015220357.GA7174@elte.hu> <20071015220720.GA16101@elte.hu> <20071015223009.GA27425@elte.hu> <4713EC59.4010106@pobox.com> <20071016054236.GA27906@elte.hu> <47145075.1080003@garzik.org> <20071016064026.GA9578@elte.hu> <47146593.2060909@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47146593.2060909@garzik.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Garzik <jeff@garzik.org> wrote:

> >FYI, looks good so far, ontop of Linus' latest -git tree.
> >
> >btw., one thing i always found weird about forcedeth is that it 
> >generates an extra ~100 irqs per second even when there's no network 
> >traffic:
> >
> > 11:      89752    XT-PIC-XT        eth0
> > 11:      89854    XT-PIC-XT        eth0
> > 11:      89955    XT-PIC-XT        eth0
> > 11:      90056    XT-PIC-XT        eth0
> > 11:      90157    XT-PIC-XT        eth0
> >
> >(irq count snapshot every second). Just in case it's easy to fix ...
> 
> 
> May I presume that behavior occurs in both mainline and my fe-lock 
> branch?

correct.

> That is likely the NIC's timer irq, which is programmed to kick the 
> irq handler every so often.  DEV_NEED_TIMERIRQ is a starting point, as 
> well as "Known bugs" at the top of forcedeth.c, if you're curious.
> 
> I'm _betting_ that some of that can be eliminated, but we'll see...

ok. Was just a FYI - you were looking for feedback :-)

	Ingo
