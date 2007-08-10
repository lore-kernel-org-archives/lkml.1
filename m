Return-Path: <linux-kernel-owner+w=401wt.eu-S1762839AbXHJIXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762839AbXHJIXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 04:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbXHJIXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 04:23:17 -0400
Received: from mx2.go2.pl ([193.17.41.42]:53878 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752828AbXHJIXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 04:23:11 -0400
Date: Fri, 10 Aug 2007 10:23:46 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stoffel <john@stoffel.org>, linux-kernel@vger.kernel.org,
       shemminger@linux-foundation.org, vignaud@xandmail.fr,
       marcin.slusarz@gmail.com, mingo@elte.hu, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-net@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.23-rc2: WARNING: at kernel/irq/resend.c:70 check_irq_resend()
Message-ID: <20070810082346.GD1764@ff.dom.local>
References: <18107.11431.838905.331157@stoffel.org> <20070809155445.GA5161@ff.dom.local> <1186733140.12828.45.camel@chaos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186733140.12828.45.camel@chaos>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 10:05:40AM +0200, Thomas Gleixner wrote:
> On Thu, 2007-08-09 at 17:54 +0200, Jarek Poplawski wrote:
> > I'm not sure I don't miss anything (a little in hurry now), but this
> > warning's aim was purely diagnostical and nothing wrong is meant!
> > Unless there is something wrong... Then please try to be more explicit.
> > 
> > If you prefer to not see this, there is my patch proposal somewhere
> > in this older thread:
> > Subject: [patch] genirq: temporary fix for level-triggered IRQ resend
> > Date: Wed, 8 Aug 2007 13:00:37 +0200
> > 
> > On the other hand, if it works OK, it would be better to let it be
> > tested more like this...
> 
> Hmm. This solution is still just pampering over the real problem. The
> delayed disable just re-sends level interrupts unnecessarily. I have a
> fix (needs some testing) for this, which I send out tomorrow, when I'm
> really back from vacation.
> 
> But suppressing the resend is not fixing the driver problem. The problem
> can show up with spurious interrupts and with interrupts on a shared PCI
> interrupt line at any time. It just might take weeks instead of minutes.

Doesn't it look like a little change of mind? Well, there are probably
(but need more testing) two other solutions: _SW_RESEND and disabling
without delay for levels only...

Jarek P.
