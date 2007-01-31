Return-Path: <linux-kernel-owner+w=401wt.eu-S1030306AbXAaRM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030306AbXAaRM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030307AbXAaRM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:12:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54405 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030306AbXAaRM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:12:27 -0500
Date: Wed, 31 Jan 2007 18:10:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 14/23] clocksource: increase initcall priority
Message-ID: <20070131171042.GB4468@elte.hu>
References: <20070131033710.420168478@mvista.com> <20070131033807.427331295@mvista.com> <20070131115055.GD1847@elte.hu> <1170261775.9781.100.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170261775.9781.100.camel@imap.mvista.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> On Wed, 2007-01-31 at 12:50 +0100, Ingo Molnar wrote:
> > * Daniel Walker <dwalker@mvista.com> wrote:
> > 
> > > -module_init(init_acpi_pm_clocksource);
> > > +/*
> > > + * This clocksource is removed from the clocksource_initcall
> > > + * macro since it's mandatory for it to be in fs_initcall as the
> > > + * highest initcall level, or else it doesn't work properly with
> > > + * it's PCI fix ups.
> > > + */
> > > +fs_initcall(init_acpi_pm_clocksource);
> > 
> > ugh - this bit looks quite interesting.
> > 
> > what's the purpose of this patch? Switching to high-res timers 
> > should be done late in the bootup - in case there's a problem it's 
> > more debuggable, etc.
> 
> The timekeeping code, and hrt/dynamic tick both wait till after boot 
> up to switch to high res mode ..

again, let me repeat the question: what's the purpose of this (whole!) 
patch. Not just of this chunk - the whole patch. You change around 
initcall levels - why? It makes no sense to me. The explanation in the 
patch header makes no sense to me.

Please if possible try to build clear arguments: first outlining "this 
is how it worked before: <X>", then outlining "this is how it will work 
after my change: <Y>", and then maybe a small blurb about "Y is better 
than X, because: <Z>". That X, Y, Z analysis is what is needed to accept 
a patch.

> The specific code block you commented on above was added cause acpi_pm 
> has special pci fixups that don't function properly earlier in boot 
> up. So it can't be arbitrarily raised to order in the initcall 
> sequence ..

i think you misunderstood my comment. In the chunk above you used 
fs_initcall() initcall instead of clocksource_initcall(). (Which is 
funny even ignoring the bad hack that clocksource_initcall is defined to 
fs_initcall.)

	Ingo
