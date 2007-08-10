Return-Path: <linux-kernel-owner+w=401wt.eu-S1760516AbXHJIGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760516AbXHJIGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 04:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbXHJIFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 04:05:48 -0400
Received: from www.osadl.org ([213.239.205.134]:55492 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752105AbXHJIFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 04:05:45 -0400
Subject: Re: 2.6.23-rc2: WARNING: at kernel/irq/resend.c:70
	check_irq_resend()
From: Thomas Gleixner <tglx@linutronix.de>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: John Stoffel <john@stoffel.org>, linux-kernel@vger.kernel.org,
       shemminger@linux-foundation.org, vignaud@xandmail.fr,
       marcin.slusarz@gmail.com, mingo@elte.hu, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-net@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20070809155445.GA5161@ff.dom.local>
References: <18107.11431.838905.331157@stoffel.org>
	 <20070809155445.GA5161@ff.dom.local>
Content-Type: text/plain
Date: Fri, 10 Aug 2007 10:05:40 +0200
Message-Id: <1186733140.12828.45.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-09 at 17:54 +0200, Jarek Poplawski wrote:
> I'm not sure I don't miss anything (a little in hurry now), but this
> warning's aim was purely diagnostical and nothing wrong is meant!
> Unless there is something wrong... Then please try to be more explicit.
> 
> If you prefer to not see this, there is my patch proposal somewhere
> in this older thread:
> Subject: [patch] genirq: temporary fix for level-triggered IRQ resend
> Date: Wed, 8 Aug 2007 13:00:37 +0200
> 
> On the other hand, if it works OK, it would be better to let it be
> tested more like this...

Hmm. This solution is still just pampering over the real problem. The
delayed disable just re-sends level interrupts unnecessarily. I have a
fix (needs some testing) for this, which I send out tomorrow, when I'm
really back from vacation.

But suppressing the resend is not fixing the driver problem. The problem
can show up with spurious interrupts and with interrupts on a shared PCI
interrupt line at any time. It just might take weeks instead of minutes.

Alan,

is there anything which can be done on the driver level ?

	tglx


