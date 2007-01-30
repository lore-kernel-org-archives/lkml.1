Return-Path: <linux-kernel-owner+w=401wt.eu-S965377AbXA3G4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965377AbXA3G4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 01:56:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965398AbXA3G4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 01:56:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52421 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965377AbXA3G4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 01:56:48 -0500
Date: Tue, 30 Jan 2007 07:54:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
Message-ID: <20070130065457.GA23390@elte.hu>
References: <1170101430.29240.34.camel@localhost.localdomain> <20070129133849.1b523226@freekitty> <1170109401.29240.49.camel@localhost.localdomain> <Pine.LNX.4.64.0701291431320.3611@woody.linux-foundation.org> <20070129144055.151cfe52@freekitty> <Pine.LNX.4.64.0701291501180.3611@woody.linux-foundation.org> <20070129154518.40b0b3d3@freekitty> <Pine.LNX.4.64.0701291609180.3611@woody.linux-foundation.org> <20070129161626.33277eb1@freekitty> <Pine.LNX.4.64.0701291623360.3611@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701291623360.3611@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -3.7
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-3.7 required=5.9 tests=ALL_TRUSTED,BAYES_05 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-0.4 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0208]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 29 Jan 2007, Stephen Hemminger wrote:
> > 
> > On one and only one platform. It works fine on others. Don't blame 
> > the driver, stop it in PCI.
> 
> How sure are you that it's only those Sony laptops?

i'm wondering, could we go with Thomas' temporary patch that disables 
sky2 MSI if CONFIG_PM is enabled - we could revert that after 2.6.20. 
It's not like MSI is a life and death feature. On IO-APIC systems 
vectors are abundant and in any case we share irqs just fine. The true 
advantage of MSI is minimal. (MSI-X has the potential to be better by 
being message based, but in reality it still goes through the full IRQ 
layer.) MSI might be useful on really, really large systems - but i 
really hope those really large systems dont rely on CONFIG_PM. Meanwhile 
Thomas' patch maximizes the amount of working hardware (it has the 
chance to produce working systems in 100% of the cases) - which is a few 
orders of magnitude more important than IRQ management micro-costs. Am i 
missing anything?

	Ingo
