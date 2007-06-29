Return-Path: <linux-kernel-owner+w=401wt.eu-S933319AbXF2OLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933319AbXF2OLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 10:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765765AbXF2OLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 10:11:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43272 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765749AbXF2OLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 10:11:21 -0400
Date: Fri, 29 Jun 2007 16:10:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Thomas Sattler <tsattler@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Daniel Mack <daniel@qanu.de>,
       Holger Waechtler <holger@qanu.de>, Dmitry Torokhov <dtor@insightbb.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       v4l-dvb-maintainer@linuxtv.org
Subject: Re: 2.6.22-rc6 spurious hangs
Message-ID: <20070629141059.GA8995@elte.hu>
References: <20070628144741.GA437@tv-sign.ru> <4683CC89.80406@gmx.de> <20070628150826.GA487@tv-sign.ru> <4683F145.2060705@gmx.de> <4683F48F.9010603@gmx.de> <20070628181044.GA613@tv-sign.ru> <4684B132.2070405@gmx.de> <20070629130955.GA284@tv-sign.ru> <20070629131605.GA25964@elte.hu> <20070629135848.GA332@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070629135848.GA332@tv-sign.ru>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@tv-sign.ru> wrote:

> > > ->disconnect_pending is used without any locks/barriers, perhaps 
> > > this is the reason.
> 
> I misread cinergyt2_release, it checks !->disconnect_pending, so it is 
> very clear why cinergyt2_query_rc() tries to take the mutex.
> 
> > > I'll try to look further tomorrow. In any case, cinergyT2 should not 
> > > use flush_scheduled_work() at all.
> > 
> > would the hack below be worth trying, to see whether there are any 
> > further problems?
[...]
> I don't think we can just kill flush_scheduled_work(). We can use 
> cancel_rearming_delayed_work() instead of 
> cancel_delayed_work()+flush_scheduled_work()
> 
> Still we can't do this under cinergyt2->sem, because cinergyt2_query() 
> takes it too. This all looks very wrong to me, I hope maintaners can 
> explain.

i've Cc:-ed the maintainers.

	Ingo
