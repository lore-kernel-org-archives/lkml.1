Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbYJ3MaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbYJ3MaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 08:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbYJ3MaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 08:30:03 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:53410 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbYJ3MaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 08:30:01 -0400
Date: Thu, 30 Oct 2008 14:28:40 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86: simplify X86_MPPARSE config option
Message-ID: <20081030122840.GB22188@cs181140183.pp.htv.fi>
References: <49099CB0.76E4.0078.0@novell.com> <20081030105146.GG3569@elte.hu> <4909A212.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4909A212.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 11:01:22AM +0000, Jan Beulich wrote:
> >>> Ingo Molnar <mingo@elte.hu> 30.10.08 11:51 >>>
> >
> >* Jan Beulich <jbeulich@novell.com> wrote:
> >
> >> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> >> 
> >> ---
> >>  arch/x86/Kconfig |   12 ++----------
> >>  1 file changed, 2 insertions(+), 10 deletions(-)
> >> 
> >> --- linux-2.6.28-rc2/arch/x86/Kconfig	2008-10-30 11:03:18.000000000 +0100
> >> +++ 2.6.28-rc2-x86-kconfig-cleanup/arch/x86/Kconfig	2008-10-21 13:57:07.000000000 +0200
> >> @@ -235,21 +235,13 @@ config X86_FIND_SMP_CONFIG
> >>  	def_bool y
> >>  	depends on X86_MPPARSE || X86_VOYAGER
> >>  
> >> -if ACPI
> >>  config X86_MPPARSE
> >> -	def_bool y
> >> -	bool "Enable MPS table"
> >> +	bool "Enable MPS table" if ACPI
> >> +	default y
> >>  	depends on X86_LOCAL_APIC
> >>  	help
> >>  	  For old smp systems that do not have proper acpi support. Newer systems
> >>  	  (esp with 64bit cpus) with acpi support, MADT and DSDT will override it
> >> -endif
> >> -
> >> -if !ACPI
> >> -config X86_MPPARSE
> >> -	def_bool y
> >> -	depends on X86_LOCAL_APIC
> >> -endif
> >
> >hm, that's not an equivalent change. But i guess we can do this, it 
> >sure looks like a cleaner construct.
> 
> Why is it not equivalent (apart from the help portion, which doesn't
> matter when the prompt isn't visible)?

Don't trust Ingo on kconfig issues, you are right.

> Jan

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

