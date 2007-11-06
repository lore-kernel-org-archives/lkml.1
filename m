Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbXKFKtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbXKFKtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 05:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbXKFKtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 05:49:31 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60561 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755426AbXKFKta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 05:49:30 -0500
Date: Tue, 6 Nov 2007 11:49:06 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] x86: unification of cfufreq/Kconfig
Message-ID: <20071106104906.GG26163@stusta.de>
References: <11941338801315-git-send-email-sam@ravnborg.org> <20071106073821.GA12733@redhat.com> <20071106081339.GA5687@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071106081339.GA5687@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 09:13:39AM +0100, Sam Ravnborg wrote:
> >  > +	depends on X86_32 && X86_ELAN
> >  >  	---help---
> >  >  	  This adds the CPUFreq driver for AMD Elan SC520 processor.
> > 
> > X86_ELAN should depend on X86_32 rather than adding this everywhere.
> 
> ...
> 
> >  >  	bool
> >  >  	depends on X86_POWERNOW_K7 && ACPI_PROCESSOR
> >  >  	depends on !(X86_POWERNOW_K7 = y && ACPI_PROCESSOR = m)
> >  > +	depends on X86_32
> >  >  	default y
> > 
> > This 2nd hunk shouldn't be necessary, as it depends on X86_POWERNOW_K7
> > which you just added the 32bit dependancy to. 
> > 
> >  >  config X86_SPEEDSTEP_RELAXED_CAP_CHECK
> >  >  	bool "Relaxed speedstep capability checks"
> >  > -	depends on (X86_SPEEDSTEP_SMI || X86_SPEEDSTEP_ICH)
> >  > +	depends on X86_32 && (X86_SPEEDSTEP_SMI || X86_SPEEDSTEP_ICH)
> > 
> > Should also be unnecessary due to those items now being 32bit dependant.
> 
> In several cases the "depends on X86_32 were added not as a necessity
> but just to make it obvious that a given symbol is 32 bit specific.
> I can drop doing it this way if it is anyway obvious from the context.
> 
> Will try to do so in next patch-set, due tonigt if things goes OK.

Please keep them for now (and also add them for the other cases like 
RWSEM_XCHGADD_ALGORITHM).

My impression of the whole x86 merge is that a quite mechanical approach 
is the best one for avoiding to introduce bugs, and cleaning such 
harmless stuff later is not a problem.

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

