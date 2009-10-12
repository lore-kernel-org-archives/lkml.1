Return-Path: <linux-kernel-owner+w=401wt.eu-S933552AbZJLWhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933552AbZJLWhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933533AbZJLWhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:37:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38946 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933526AbZJLWho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:37:44 -0400
Date: Tue, 13 Oct 2009 00:37:07 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Luming Yu <luming.yu@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [trivial PATCH] fix typo in nmi.c of apic
In-Reply-To: <20091012202613.GB7648@elte.hu>
Message-ID: <alpine.LSU.2.00.0910130031420.19284@wotan.suse.de>
References: <3877989d0909102303m31066b01he38e8a295995c430@mail.gmail.com> <alpine.LSU.2.00.0910091706350.19284@wotan.suse.de> <20091012202613.GB7648@elte.hu>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009, Ingo Molnar wrote:

> > > I came across x86/kernel/apic/nmi.c and found several typo.
> > > It's trivial in terms of doing nothing on changing execution logic.
> > I'd rather go this through x86 tree. Adding Ingo.
> > 
> > > Ps. The patch is enclosed in attachment. The inline one
> > > is c&p of it for reading.
> > > 
> > > 
> > > Thanks,
> > > Luming
> > > 
> > > Signed-off-by: Yu Luming <luming.yu@intel.com>
> > > 
> > >  nmi.c |   18 +++++++++---------
> > >  1 file changed, 9 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
> > > index b3025b4..9ff1f6d 100644
> > > --- a/arch/x86/kernel/apic/nmi.c
> > > +++ b/arch/x86/kernel/apic/nmi.c
> > > @@ -121,7 +121,7 @@ static void report_broken_nmi(int cpu, unsigned
> > > int *prev_nmi_count)
> > >  	atomic_dec(&nmi_active);
> > >  }
> > > 
> > > -static void __acpi_nmi_disable(void *__unused)
> > > +static void __apic_nmi_disable(void *__unused)
> 
> that's correctly named, as a 'git grep acpi_nmi_disable' should reveal.

I actually think that Luming Yu is right that the function is misnamed. 
What does it have to do with ACPI?

All we do here is disable the NMI/LVT flags on the corresponding APIC. No 
ACPI involved.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
