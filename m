Return-Path: <linux-kernel-owner+w=401wt.eu-S1751623AbXDDVPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbXDDVPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 17:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbXDDVPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 17:15:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43769 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbXDDVPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 17:15:33 -0400
Date: Wed, 4 Apr 2007 23:15:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
       johnstul@us.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       heiko.carstens@de.ibm.com
Subject: Re: + clocksource-driver-initialize-list-value.patch added to -mm tree
Message-ID: <20070404211514.GA18600@elte.hu>
References: <200704010523.l315NXJP004063@shell0.pdx.osdl.net> <1175417035.28263.42.camel@localhost.localdomain> <1175704712.15973.35.camel@imap.mvista.com> <20070404125853.1cf9b7b7.akpm@linux-foundation.org> <1175717425.15973.61.camel@imap.mvista.com> <20070404203647.GA12563@elte.hu> <1175719489.15973.66.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175719489.15973.66.camel@imap.mvista.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> > > This is a prerequisite for simplifying the clocksource 
> > > registration process.
> > 
> > why? This patch only pushes some unnecessary code into the 
> > clocksource drivers:
> > 
> > +       .list           = LIST_HEAD_INIT(clocksource_avr32.list),
> > 
> > NACK unless you can give an explanation of why this is unavoidable. A 
> > NULL initializer is just as good as an initialized list entry. (in fact 
> > it's slightly better because it's in the kernel's BSS)
> 
> This is only 1 of 9 patches . The 9th patch requires the .list value 
> to be initialized .. The description change above was suppose to make 
> that clearer .. By forcing the .list value to be initialized we can 
> simplify the clocksource registration .

but why do you call that a simplification? Remove 5 lines of code from 
the generic code, by adding +1 line to every clocksource driver, 
totalling to like +20 lines at the moment?

	Ingo
