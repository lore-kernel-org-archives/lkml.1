Return-Path: <linux-kernel-owner+w=401wt.eu-S1755605AbXKFIMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbXKFIMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 03:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbXKFIMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 03:12:03 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:45143 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbXKFIMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 03:12:01 -0500
Date: Tue, 6 Nov 2007 09:13:39 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] x86: unification of cfufreq/Kconfig
Message-ID: <20071106081339.GA5687@uranus.ravnborg.org>
References: <11941338801315-git-send-email-sam@ravnborg.org> <20071106073821.GA12733@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071106073821.GA12733@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  > +	depends on X86_32 && X86_ELAN
>  >  	---help---
>  >  	  This adds the CPUFreq driver for AMD Elan SC520 processor.
> 
> X86_ELAN should depend on X86_32 rather than adding this everywhere.

...

>  >  	bool
>  >  	depends on X86_POWERNOW_K7 && ACPI_PROCESSOR
>  >  	depends on !(X86_POWERNOW_K7 = y && ACPI_PROCESSOR = m)
>  > +	depends on X86_32
>  >  	default y
> 
> This 2nd hunk shouldn't be necessary, as it depends on X86_POWERNOW_K7
> which you just added the 32bit dependancy to. 
> 
>  >  config X86_SPEEDSTEP_RELAXED_CAP_CHECK
>  >  	bool "Relaxed speedstep capability checks"
>  > -	depends on (X86_SPEEDSTEP_SMI || X86_SPEEDSTEP_ICH)
>  > +	depends on X86_32 && (X86_SPEEDSTEP_SMI || X86_SPEEDSTEP_ICH)
> 
> Should also be unnecessary due to those items now being 32bit dependant.

In several cases the "depends on X86_32 were added not as a necessity
but just to make it obvious that a given symbol is 32 bit specific.
I can drop doing it this way if it is anyway obvious from the context.

Will try to do so in next patch-set, due tonigt if things goes OK.

	Sam
