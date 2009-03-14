Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbZCNPcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbZCNPcL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 11:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbZCNPbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 11:31:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60434 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbZCNPbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 11:31:55 -0400
Date: Sat, 14 Mar 2009 16:31:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: cpu/intel.c cleanup
Message-ID: <20090314153138.GA19459@elte.hu>
References: <1237034492.4546.1.camel@ht.satnam> <20090314131142.GA29582@uranus.ravnborg.org> <20090314132004.GD17727@elte.hu> <1237037822.4546.8.camel@ht.satnam> <19f34abd0903140700r6c23da9aq6747fbcce7bcc4b2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <19f34abd0903140700r6c23da9aq6747fbcce7bcc4b2@mail.gmail.com>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> 2009/3/14 Jaswinder Singh Rajput <jaswinder@kernel.org>:
> > From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > Date: Sat, 14 Mar 2009 17:47:38 +0530
> > Subject: [PATCH] x86: cpu/intel.c cleanup
> >
> > - fix various style problems
> >  - fix header files issues
> >
> 
> [...]
> 
> >  static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
> >  {
> > +       u64 misc_enable;
> > +
> >        /* Unmask CPUID levels if masked: */
> >        if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
> > -               u64 misc_enable;
> >
> >                rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
> >
> > @@ -44,16 +45,16 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
> >        }
> >
> >        if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
> > -               (c->x86 == 0x6 && c->x86_model >= 0x0e))
> > +           (c->x86 == 0x6 && c->x86_model >= 0x0e))
> >                set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
> >
> >  #ifdef CONFIG_X86_64
> >        set_cpu_cap(c, X86_FEATURE_SYSENTER32);
> > -#else
> > +#else /* CONFIG_X86_64 */
> >        /* Netburst reports 64 bytes clflush size, but does IO in 128 bytes */
> >        if (c->x86 == 15 && c->x86_cache_alignment == 64)
> >                c->x86_cache_alignment = 128;
> > -#endif
> > +#endif /* CONFIG_X86_64 */
> >
> >        /* CPUID workaround for 0F33/0F34 CPU */
> >        if (c->x86 == 0xF && c->x86_model == 0x3
> > @@ -96,19 +97,18 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
> >         * Ingo Molnar reported a Pentium D (model 6) and a Xeon
> >         * (model 2) with the same problem.
> >         */
> > -       if (c->x86 == 15) {
> > -               u64 misc_enable;
> > +       if (c->x86 != 15)
> > +               return;
> >
> > -               rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
> > +       rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
> >
> > -               if (misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING) {
> > -                       printk(KERN_INFO "kmemcheck: Disabling fast string operations\n");
> > +       if (misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING) {
> > +               pr_info("kmemcheck: Disabling fast string operations\n");
> >
> > -                       misc_enable &= ~MSR_IA32_MISC_ENABLE_FAST_STRING;
> > -                       wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
> > -               }
> > +               misc_enable &= ~MSR_IA32_MISC_ENABLE_FAST_STRING;
> > +               wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
> >        }
> > -#endif
> > +#endif /* CONFIG_KMEMCHECK */
> >  }
> 
> I don't really like this change (last hunk). Doesn't it seem a 
> bit pointless? It breaks the symmetry with the masked CPUID 
> levels at the beginning of the function. If somebody wants to 
> add something else to this function, it might have to be 
> reindented again. Or is there a problem with too long lines 
> here?

yes, it would be cleaner to put the whole family 15 branch into 
a helper inline function instead.

	Ingo
