Return-Path: <linux-kernel-owner+w=401wt.eu-S1753789AbZDRHYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbZDRHYo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 03:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbZDRHYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 03:24:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59103 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbZDRHYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 03:24:35 -0400
Date: Sat, 18 Apr 2009 09:24:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Han, Weidong" <weidong.han@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "Kay, Allen M" <allen.m.kay@intel.com>,
       "Yu, Fenghua" <fenghua.yu@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH 3/5] x86, intr-remap: enable interrupt remapping early
Message-ID: <20090418072414.GF7678@elte.hu>
References: <1239957736-6161-1-git-send-email-weidong.han@intel.com> <1239957736-6161-4-git-send-email-weidong.han@intel.com> <20090417141310.GD23493@elte.hu> <1240011743.27006.8496.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240011743.27006.8496.camel@localhost.localdomain>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Fri, 2009-04-17 at 07:13 -0700, Ingo Molnar wrote:
> > * Weidong Han <weidong.han@intel.com> wrote:
> > 
> > > --- a/arch/x86/kernel/apic/apic.c
> > > +++ b/arch/x86/kernel/apic/apic.c
> > > @@ -118,6 +118,8 @@ static int x2apic_preenabled;
> > >  static int disable_x2apic;
> > >  static __init int setup_nox2apic(char *str)
> > >  {
> > > +	if (x2apic_enabled())
> > > +		panic("Bios already enabled x2apic, can't enforce nox2apic");
> > 
> > Could you please turn that into something like:
> 
> I have couple of patches cleaning these up(including some 
> warnings). I will post them shortly.

ok!

> > > +ir_failed:
> > > +	if (x2apic_preenabled)
> > > +		panic("x2apic enabled by bios. But IR enabling failed");
> > 
> > What is the likelyhood that we can continue in compat mode? If 
> > there's some chance, we should rather print a KERN_WARNING and 
> > should try to continue. If IRQs are not coming we'll hang shortly 
> > afterwards anyway.
> 
> Typically only on high end platforms we will see x2apic enabled by 
> BIOS before OS handover. And in these cases, BIOS should have 
> already enabled interrupt-remapping in extended interrupt mode, 
> before handing over control to OS. If the extended interrupt mode 
> is set, HW will block the compatibility format interrupts anyway. 
> And I think its better to panic rather than hanging at random 
> places(depending on which interrupts are already in remapped 
> format and which are not). This way, it will be easy for anyone to 
> figure out what is happening.

fair enough.

	Ingo
