Return-Path: <linux-kernel-owner+w=401wt.eu-S1752849AbYKMHn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbYKMHn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 02:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbYKMHnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 02:43:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56805 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbYKMHnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 02:43:17 -0500
Date: Thu, 13 Nov 2008 08:43:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mark Nelson <markn@au1.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: commit "genirq: record trigger type" and powerpc
Message-ID: <20081113074300.GC1723@elte.hu>
References: <200811131730.11506.markn@au1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811131730.11506.markn@au1.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mark Nelson <markn@au1.ibm.com> wrote:

> Hi Ingo,
> 
> I noticed that after commit 0c5d1eb77a8be917b638344a22afe1398236482b 
> (genirq: record trigger type), several of our powerpc platforms now 
> spew out warnings about "No set_type function for IRQ..." (in 
> particular our Cell blades). This is because in our generic platform 
> code we call set_irq_type() with information from the device tree 
> when we establish the interrupt mappings; but we do this regardless 
> of whether the PIC can actually set a type (it might irrelevant 
> because the type is essentially hardcoded or as in the case for Cell 
> the interrupts are just messages being past around that have no real 
> concept of type, or we could even be dealing with a virtual PIC as 
> on the PS3).
> 
> So, would it be possible to turn the:
> 
> 	pr_warning("No set_type function... 
> 
> into a pr_debug() in kernel/irq/manage.c so when our users upgrade 
> to newer kernels they don't get scared by a whole bunch of new 
> warnings?

Sure, please send a patch with a changelog.

	Ingo
