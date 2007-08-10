Return-Path: <linux-kernel-owner+w=401wt.eu-S1765609AbXHJIb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765609AbXHJIb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 04:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbXHJIbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 04:31:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47806 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbXHJIbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 04:31:37 -0400
Date: Fri, 10 Aug 2007 10:30:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stoffel <john@stoffel.org>,
       linux-kernel@vger.kernel.org, shemminger@linux-foundation.org,
       vignaud@xandmail.fr, marcin.slusarz@gmail.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-net@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.23-rc2: WARNING: at kernel/irq/resend.c:70
	check_irq_resend()
Message-ID: <20070810083050.GA4545@elte.hu>
References: <18107.11431.838905.331157@stoffel.org> <20070809155445.GA5161@ff.dom.local> <1186733140.12828.45.camel@chaos> <20070810082346.GD1764@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070810082346.GD1764@ff.dom.local>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jarek Poplawski <jarkao2@o2.pl> wrote:

> > Hmm. This solution is still just pampering over the real problem. 
> > The delayed disable just re-sends level interrupts unnecessarily. I 
> > have a fix (needs some testing) for this, which I send out tomorrow, 
> > when I'm really back from vacation.
> > 
> > But suppressing the resend is not fixing the driver problem. The 
> > problem can show up with spurious interrupts and with interrupts on 
> > a shared PCI interrupt line at any time. It just might take weeks 
> > instead of minutes.
> 
> Doesn't it look like a little change of mind? [...]

what change of mind do you mean exactly?

> [...] Well, there are probably (but need more testing) two other 
> solutions: _SW_RESEND and disabling without delay for levels only...

IIRC Marcin tested software-resend and it didnt fix the hang. That 
strongly points in the direction of a driver bug (or a genirq bug) being 
made more prominent by the genirq change - not any hardware detail such 
as the APIC vector-retrigger sequence.

While we'd like to see the suspected driver bug (or any higher level 
genirq bug) fixed, we'll undo the effect of the genirq change (because 
it is causing a regression). We'll also add a separate, optional 
irq-debugging feature that generates high-rate interrupts on any shared 
irq line. (and thus artificially stresses the robustness of the driver 
and the genirq layer against spurious interrupts.)

	Ingo
