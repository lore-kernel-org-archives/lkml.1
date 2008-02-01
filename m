Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbYBANwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbYBANwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 08:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbYBANwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 08:52:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50807 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755113AbYBANwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 08:52:13 -0500
Date: Fri, 1 Feb 2008 14:51:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Ian Campbell <ijc@hellion.org.uk>,
       Mika Penttil? <mika.penttila@kolumbus.fi>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
	format.
Message-ID: <20080201135125.GA16249@elte.hu>
References: <1201167544.30671.64.camel@cthulhu.hellion.org.uk> <20080128150022.GE27928@elte.hu> <20080128161239.GA28906@elte.hu> <200801281802.01748.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801281802.01748.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> >  arch/x86/kernel/built-in.o: In function `wakeup_start':
> >  : undefined reference to `swsusp_pg_dir'
> > 
> > config attached.
> 
> I see.  CONFIG_HIBERNATION && CONFIG_ACPI -> CONFIG_ACPI_SLEEP and the 
> Makefile in arch/x86/kernel/acpi/ wants to build wakeup.S, which is 
> not necessary.  Hmm.
> 
> We can do a couple of things:
> (1) make wakeup_$(BITS).o depend on CONFIG_SUSPEND (alone)
>     This will build it if CONFIG_SUSPEND is set, but CONFIG_ACPI is not
>     (still, that's consistent with the change in question).
> (2) make wakeup_$(BITS).o depend on CONFIG_SUSPEND and CONFIG_ACPI
> (3) define CONFIG_ACPI_SUSPEND depending on ACPI and SUSPEND and
>     make wakeup_$(BITS).o as well as swsusp_pg_dir depend on that (most
>     elegant)
> 
> Which one do you prefer?

no strong preference here - pick the one you like best and send a patch 
please :-)

	Ingo
