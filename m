Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab0BMLGP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 06:06:15 -0500
Received: from 8bytes.org ([88.198.83.132]:49615 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436Ab0BMLGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 06:06:14 -0500
Date: Sat, 13 Feb 2010 12:06:12 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Print AMD virtualization features in /proc/cpuinfo
Message-ID: <20100213110612.GD26388@8bytes.org>
References: <1260792521-15212-1-git-send-email-joerg.roedel@amd.com> <20100205125059.GA16236@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100205125059.GA16236@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping.

On Fri, Feb 05, 2010 at 01:51:00PM +0100, Joerg Roedel wrote:
> Are there any problems with this patch or was it just forgotten :-)
> Please let me know.
> 
> 	Joerg
> 
> On Mon, Dec 14, 2009 at 01:08:41PM +0100, Joerg Roedel wrote:
> > This patch adds code to cpu initialization path to detect
> > the extended virtualization features of AMD cpus to show
> > them in /proc/cpuinfo.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  arch/x86/include/asm/cpufeature.h          |    4 ++++
> >  arch/x86/kernel/cpu/addon_cpuid_features.c |    4 ++++
> >  2 files changed, 8 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> > index 613700f..7dbc1c2 100644
> > --- a/arch/x86/include/asm/cpufeature.h
> > +++ b/arch/x86/include/asm/cpufeature.h
> > @@ -167,6 +167,10 @@
> >  #define X86_FEATURE_FLEXPRIORITY (8*32+ 2) /* Intel FlexPriority */
> >  #define X86_FEATURE_EPT         (8*32+ 3) /* Intel Extended Page Table */
> >  #define X86_FEATURE_VPID        (8*32+ 4) /* Intel Virtual Processor ID */
> > +#define X86_FEATURE_NPT		(8*32+5)  /* AMD Nested Page Table support */
> > +#define X86_FEATURE_LBRV	(8*32+6)  /* AMD LBR Virtualization support */
> > +#define X86_FEATURE_SVML	(8*32+7)  /* "svm_lock" AMD SVM locking MSR */
> > +#define X86_FEATURE_NRIPS	(8*32+8)  /* "nrip_save" AMD SVM next_rip save */
> >  
> >  #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
> >  
> > diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
> > index 468489b..97ad79c 100644
> > --- a/arch/x86/kernel/cpu/addon_cpuid_features.c
> > +++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
> > @@ -32,6 +32,10 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
> >  	static const struct cpuid_bit __cpuinitconst cpuid_bits[] = {
> >  		{ X86_FEATURE_IDA, CR_EAX, 1, 0x00000006 },
> >  		{ X86_FEATURE_ARAT, CR_EAX, 2, 0x00000006 },
> > +		{ X86_FEATURE_NPT,   CR_EDX, 0, 0x8000000a },
> > +		{ X86_FEATURE_LBRV,  CR_EDX, 1, 0x8000000a },
> > +		{ X86_FEATURE_SVML,  CR_EDX, 2, 0x8000000a },
> > +		{ X86_FEATURE_NRIPS, CR_EDX, 3, 0x8000000a },
> >  		{ 0, 0, 0, 0 }
> >  	};
> >  
> > -- 
> > 1.6.5.4
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
