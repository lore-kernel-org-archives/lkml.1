Return-Path: <linux-kernel-owner+w=401wt.eu-S1757195AbZCCLTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbZCCLTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 06:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbZCCLTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 06:19:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44771 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbZCCLTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 06:19:35 -0500
Date: Tue, 3 Mar 2009 12:19:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       tglx@linutronix.de
Subject: Re: lockdep and threaded IRQs (was: ...)
Message-ID: <20090303111903.GA21902@elte.hu>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200903021633.08736.david-b@pacbell.net> <20090303004427.GA8638@elte.hu> <200903021837.08635.david-b@pacbell.net> <1236072446.18955.44.camel@twins> <20090303094743.030b2507@lxorguk.ukuu.org.uk> <20090303100329.GA5050@elte.hu> <20090303103041.0ba4aebd@lxorguk.ukuu.org.uk> <20090303104836.GA11532@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090303104836.GA11532@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > > _without_ IRQF_ENABLED: where an IRQ handler can take a long 
> > > time to execute, the handler can be converted to a threaded 
> > > IRQ handler - where it's fine to enable IRQs as there are no 
> > > stack nesting issues.
> > 
> > Only if you can mask the interrupt on the APIC without 
> > losing it or having the APIC throw a fit.
> 
> Hm, that reads like the boot IRQ erratas of certain chipsets - 
> the APIC could throw a fit essentially locking up the system. 
> FYI, we have fixes for that upstream already.
> 
> Do you have any description about that problem, which hardware 
> it affects, whether it's manufactured today and any (ballpark 
> figure) estimation about the Linux installed base on it? Can 
> they live with the quirk flag?

btw., i definitely do not say that threaded IRQ handlers will 
work in each an every case (it changes the hardware programming 
pattern and as such it can bring out new erratas) so i 
definitely agree with the argument that the conversion has to be 
careful and case by case.

The plan Peter outlined looks sane. In case you worry about a 
forced removal of irq-enable - you should not.

	Ingo
