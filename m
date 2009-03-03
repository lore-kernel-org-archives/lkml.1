Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbZCCLeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbZCCLeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 06:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbZCCLdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 06:33:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56318 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369AbZCCLdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 06:33:53 -0500
Date: Tue, 3 Mar 2009 12:33:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       tglx@linutronix.de
Subject: Re: lockdep and threaded IRQs (was: ...)
Message-ID: <20090303113313.GA23980@elte.hu>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200903021633.08736.david-b@pacbell.net> <20090303004427.GA8638@elte.hu> <200903021837.08635.david-b@pacbell.net> <1236072446.18955.44.camel@twins> <20090303094743.030b2507@lxorguk.ukuu.org.uk> <20090303100329.GA5050@elte.hu> <20090303103041.0ba4aebd@lxorguk.ukuu.org.uk> <20090303104836.GA11532@elte.hu> <20090303111353.5d9e4a8d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090303111353.5d9e4a8d@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Hm, that reads like the boot IRQ erratas of certain chipsets 
> > - the APIC could throw a fit essentially locking up the 
> > system. FYI, we have fixes for that upstream already.
> 
> Good - certainly it used to be the case that masking APIC IRQs 
> and leaving them masked from the IRQ handled used to do funny 
> things sometimes.

I think being careful is definitely warranted in the case of 
IDE. I'd not be surprised if not all chipsets are mapped via the 
boot-IRQ quirks: those quirks are opt-in based on PCI IDs - 
those tend to be the quirk mechanisms with the least coverage. 
(The IDs were also derived from enterprise testing of -rt, which 
tends to under-emphasise cheap broken chipsets.)

Plus the erratum you described about doing an IRQ masking 
mid-PIO-transfer confusing the chipset can also be a separate 
standalone bug not permitting an irq-masking based IRQ flow at 
all on such hardware.

So your worries are spot on IMO and are not being dismissed 
forcibly.

> > i think you severely over-estimate the importance and ratio 
> > of drivers that enable irqs within irq handlers. (Nor does 
> > anyone want to break them really - we want to have a sane 
> > default and we want to flag the broken cases as broken.)
> 
> IDE. A lot less people use the IDE stack nowdays but its a big 
> item and getting it wrong tends to eat your files.
> 
> I do object to the attitude shown about "forcing" people. It's 
> a community project built by a large number of people on a mix 
> of pragmatic and elegant design balances. Maybe it's just 
> unfortunate choice of wording but it is the wrong sentiment.

It was in the heat of the argument i think ...

(I do think we need to be somewhat less permissive in terms of 
weird driver practices, but that's just my opinion and not 
'enforced' via any artificial way.)

	Ingo
