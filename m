Return-Path: <linux-kernel-owner+w=401wt.eu-S1030440AbXAaRXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030440AbXAaRXE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:23:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030377AbXAaRWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:22:36 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:38412 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030331AbXAaRWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:22:23 -0500
Subject: Re: [PATCH 14/23] clocksource: increase initcall priority
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070131171042.GB4468@elte.hu>
References: <20070131033710.420168478@mvista.com>
	 <20070131033807.427331295@mvista.com> <20070131115055.GD1847@elte.hu>
	 <1170261775.9781.100.camel@imap.mvista.com> <20070131171042.GB4468@elte.hu>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 09:20:52 -0800
Message-Id: <1170264052.9781.130.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-31 at 18:10 +0100, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > On Wed, 2007-01-31 at 12:50 +0100, Ingo Molnar wrote:
> > > * Daniel Walker <dwalker@mvista.com> wrote:
> > > 
> > > > -module_init(init_acpi_pm_clocksource);
> > > > +/*
> > > > + * This clocksource is removed from the clocksource_initcall
> > > > + * macro since it's mandatory for it to be in fs_initcall as the
> > > > + * highest initcall level, or else it doesn't work properly with
> > > > + * it's PCI fix ups.
> > > > + */
> > > > +fs_initcall(init_acpi_pm_clocksource);
> > > 
> > > ugh - this bit looks quite interesting.
> > > 
> > > what's the purpose of this patch? Switching to high-res timers 
> > > should be done late in the bootup - in case there's a problem it's 
> > > more debuggable, etc.
> > 
> > The timekeeping code, and hrt/dynamic tick both wait till after boot 
> > up to switch to high res mode ..
> 
> again, let me repeat the question: what's the purpose of this (whole!) 
> patch. Not just of this chunk - the whole patch. You change around 
> initcall levels - why? It makes no sense to me. The explanation in the 
> patch header makes no sense to me.
> 
> Please if possible try to build clear arguments: first outlining "this 
> is how it worked before: <X>", then outlining "this is how it will work 
> after my change: <Y>", and then maybe a small blurb about "Y is better 
> than X, because: <Z>". That X, Y, Z analysis is what is needed to accept 
> a patch.

I don't know that I could explain it better than what's in the patch
header .. I'll think about it.

> > The specific code block you commented on above was added cause acpi_pm 
> > has special pci fixups that don't function properly earlier in boot 
> > up. So it can't be arbitrarily raised to order in the initcall 
> > sequence ..
> 
> i think you misunderstood my comment. In the chunk above you used 
> fs_initcall() initcall instead of clocksource_initcall(). (Which is 
> funny even ignoring the bad hack that clocksource_initcall is defined to 
> fs_initcall.)

The purpose of clocksource_initcall is so the initcall can be increased
without changing all the individual clocksources .. So I have to
disconnect that from the acpi_pm because it can't tolerate it.

Daniel

