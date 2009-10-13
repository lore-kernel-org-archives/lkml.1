Return-Path: <linux-kernel-owner+w=401wt.eu-S933666AbZJMHSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933666AbZJMHSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933626AbZJMHSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:18:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43952 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933613AbZJMHSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 03:18:50 -0400
Date: Tue, 13 Oct 2009 09:18:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Luming Yu <luming.yu@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [trivial PATCH] fix typo in nmi.c of apic
Message-ID: <20091013071805.GC13175@elte.hu>
References: <3877989d0909102303m31066b01he38e8a295995c430@mail.gmail.com> <alpine.LSU.2.00.0910091706350.19284@wotan.suse.de> <20091012202613.GB7648@elte.hu> <alpine.LSU.2.00.0910130031420.19284@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0910130031420.19284@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Kosina <jkosina@suse.cz> wrote:

> On Mon, 12 Oct 2009, Ingo Molnar wrote:
> 
> > > > I came across x86/kernel/apic/nmi.c and found several typo.
> > > > It's trivial in terms of doing nothing on changing execution logic.
> > > I'd rather go this through x86 tree. Adding Ingo.
> > > 
> > > > Ps. The patch is enclosed in attachment. The inline one
> > > > is c&p of it for reading.
> > > > 
> > > > 
> > > > Thanks,
> > > > Luming
> > > > 
> > > > Signed-off-by: Yu Luming <luming.yu@intel.com>
> > > > 
> > > >  nmi.c |   18 +++++++++---------
> > > >  1 file changed, 9 insertions(+), 9 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
> > > > index b3025b4..9ff1f6d 100644
> > > > --- a/arch/x86/kernel/apic/nmi.c
> > > > +++ b/arch/x86/kernel/apic/nmi.c
> > > > @@ -121,7 +121,7 @@ static void report_broken_nmi(int cpu, unsigned
> > > > int *prev_nmi_count)
> > > >  	atomic_dec(&nmi_active);
> > > >  }
> > > > 
> > > > -static void __acpi_nmi_disable(void *__unused)
> > > > +static void __apic_nmi_disable(void *__unused)
> > 
> > that's correctly named, as a 'git grep acpi_nmi_disable' should reveal.
> 
> I actually think that Luming Yu is right that the function is misnamed. 
> What does it have to do with ACPI?

It's not misnamed - it is a facility provided by architecture code to 
the ACPI subsystem and hence named acpi_*(). See:

  5d0e600: [PATCH] x86: fix laptop bootup hang in init_acpi()

Other architectures could opt to implement the same quirk - but it has 
nothing to do with APIC.

Yes, on x86 we use the local APIC to disable NMIs, but that has no 
effect on the naming of the facility ...

	Ingo
