Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbYEJOr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbYEJOr7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 10:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbYEJOrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 10:47:49 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43645 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751390AbYEJOrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 10:47:48 -0400
Subject: Re: build issue #380 for v2.6.26-rc1-279-g28a4acb : mach-voyager:
	multiple definition of `phys_cpu_present_map'
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, toralf.foerster@gmx.de,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Travis <travis@sgi.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
In-Reply-To: <1210428108.4002.5.camel@localhost.localdomain>
References: <200805091114.00244.toralf.foerster@gmx.de>
	 <20080509095244.GJ2543@hacking> <20080509095837.GB19617@elte.hu>
	 <1210342946.3069.4.camel@localhost.localdomain>
	 <20080509144722.GA20566@elte.hu>  <20080510131752.GA888@elte.hu>
	 <1210428108.4002.5.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 10 May 2008 09:21:24 -0500
Message-Id: <1210429284.4002.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-05-10 at 09:01 -0500, James Bottomley wrote:
> On Sat, 2008-05-10 at 15:17 +0200, Ingo Molnar wrote:
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > > I already told you that this was incorrect.  This is what I sent as 
> > > > the replacement on 28 April and I didn't hear back from you.
> > > > 
> > > > http://marc.info/?l=linux-kernel&m=120941111400620
> > > 
> > > ok - picked it up for testing - could you please send a signoff line 
> > > as well?
> > 
> > Alexey, the patch from James failed in testing on visws:
> > 
> >  arch/x86/kernel/built-in.o: In function `init_apic_mappings':
> >  : undefined reference to `boot_cpu_physical_apicid'
> >  arch/x86/kernel/built-in.o: In function `init_apic_mappings':
> >  : undefined reference to `boot_cpu_physical_apicid'
> >  arch/x86/kernel/built-in.o: In function `APIC_init_uniprocessor':
> >  : undefined reference to `boot_cpu_physical_apicid'
> >  arch/x86/kernel/built-in.o: In function `APIC_init_uniprocessor':
> > 
> > config is at:
> > 
> >   http://redhat.com/~mingo/misc/config-Sat_May_10_15_05_47_CEST_2008.bad
> 
> OK, so these symbols are required on visws as well.  So that makes the
> gating config symbol X86_LOCAL_APIC.
> 
> Could you run this through the same config to verify; thanks!

By the way, if this patch survives all the randconfig testing, it shows
the symbols don't belong in setup.c; they should be in apic.c (the
beginnings of the unified apic files).  I'll redo the patch that way on
testing confirmation.

Thanks,

James


