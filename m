Return-Path: <linux-kernel-owner+w=401wt.eu-S938389AbXG0XDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938389AbXG0XDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 19:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937513AbXG0XDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 19:03:36 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:46957 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761029AbXG0XDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 19:03:35 -0400
Date: Sat, 28 Jul 2007 01:03:07 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       david@lang.hm, Andrew Morton <akpm@linux-foundation.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [2.6 patch] let SUSPEND select HOTPLUG_CPU
Message-ID: <20070727230307.GC15129@stusta.de>
References: <200707251238.50218.lenb@kernel.org> <200707262117.26353.rjw@sisk.pl> <alpine.LFD.0.999.0707261255380.3442@woody.linux-foundation.org> <200707262248.09187.rjw@sisk.pl> <alpine.LFD.0.999.0707261351430.3442@woody.linux-foundation.org> <20070727222503.GB15129@stusta.de> <46AA7609.1040900@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46AA7609.1040900@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 28, 2007 at 12:47:37AM +0200, Stefan Richter wrote:
> Adrian Bunk wrote:
> > The dependency of SUSPEND_SMP on HOTPLUG_CPU is quite unintuitive,
> 
> It's not entirely unintuitive.  That option's full name is "Support for
> suspend on SMP and hot-pluggable CPUs".
> 
> Only the place where you find the option is unintuitive, as far as its
> first application is concerned.  (It lives in the "Processor type and
> features" menu which is OK for the 2nd application of this option.)  And
> the variable name of that option is unintuitive because it covers only
> the 2nd application of the option, I suppose for historical reasons.

We can figure out ourselves when HOTPLUG_CPU is required, so there's no 
reason to bother the user with it.

> > +config SUSPEND_SMP_POSSIBLE
> > +	bool
> > +	depends on (X86 && !X86_VOYAGER) || (PPC64 && (PPC_PSERIES || PPC_PMAC))
> > +	depends on SMP
> > +	default y
> > +
> > +config SUSPEND_SMP
> > +	bool
> > +	depends on SUSPEND_SMP_POSSIBLE && SOFTWARE_SUSPEND
> > +	select HOTPLUG_CPU
> > +	default y
> 
> Yes, that's the price to pay if you want to select something that in
> turn depends on a number of other things.

Yes, but a good user interface is worth it.

> Wait, doesn't HOTPLUG_CPU also depend on EXPERIMENTAL?

Damn, I started thinking about it, and then forgot about it when 
finishing the patch.

My thoughts were:
Is HOTPLUG_CPU still an experimental feature, or has it become a 
well-tested no longer experimental feature now that it's used on
most recent laptops?

> Stefan Richter

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

