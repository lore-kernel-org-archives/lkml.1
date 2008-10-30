Return-Path: <linux-kernel-owner+w=401wt.eu-S1758467AbYJ3WRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467AbYJ3WRJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 18:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbYJ3WQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 18:16:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46328 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343AbYJ3WQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 18:16:51 -0400
Date: Thu, 30 Oct 2008 23:16:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix ACPI induced voyager compile failure
Message-ID: <20081030221645.GL30303@elte.hu>
References: <1225400518.19324.11.camel@localhost.localdomain> <20081030215819.GI30303@elte.hu> <1225404299.19324.47.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225404299.19324.47.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Thu, 2008-10-30 at 22:58 +0100, Ingo Molnar wrote:
> > * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > 
> > > >From c339b7cdc39399855ec07dfbff67304f9c7fa49a Mon Sep 17 00:00:00 2001
> > > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > > Date: Wed, 29 Oct 2008 10:58:13 -0500
> > > Subject: [VOYAGER] x86: don't pull asm/acpi.h into fixmap_32.h
> > > 
> > > If it's not needed it causes compile failures.
> > > 
> > > Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> > > ---
> > >  arch/x86/include/asm/fixmap_32.h |    2 ++
> > >  1 files changed, 2 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/arch/x86/include/asm/fixmap_32.h b/arch/x86/include/asm/fixmap_32.h
> > > index 09f29ab..c3302ee 100644
> > > --- a/arch/x86/include/asm/fixmap_32.h
> > > +++ b/arch/x86/include/asm/fixmap_32.h
> > > @@ -25,7 +25,9 @@ extern unsigned long __FIXADDR_TOP;
> > >  
> > >  #ifndef __ASSEMBLY__
> > >  #include <linux/kernel.h>
> > > +#ifdef CONFIG_ACPI
> > >  #include <asm/acpi.h>
> > > +#endif
> > 
> > hm, that's quite ugly - such headers are supposed to be safe even if 
> > CONFIG_APIC is not turned on.
> > 
> > What kind of compiler failures are you getting, could you send the 
> > .config that triggers it? I'm curious what the real cause of the build 
> > failure is - the #ifdef you are adding seems to fix a symptom, not a 
> > real bug - and maybe we can do a better fix.
> 
> It's the problem of voyager wanting its own definition of
> phys_cpu_present_map.  acpi.h pulls in mpspec.h which contaminates the
> voyager_smp.c build.

i guess voyager could use physid_mask_t just fine?

physid_mask_t is MAX_APICS derived - but it should work out fine 
because AFAICS voyager has a maximum of 4 cpus (but definitely less 
than say 32), while MAX_APICS never goes below 256.

	Ingo
