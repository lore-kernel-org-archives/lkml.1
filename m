Return-Path: <linux-kernel-owner+w=401wt.eu-S1760086AbYFXMIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086AbYFXMIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 08:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755191AbYFXMI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 08:08:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40120 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755089AbYFXMI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 08:08:28 -0400
Date: Tue, 24 Jun 2008 14:08:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alok Kataria <akataria@vmware.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, "Brown, Len" <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] cleanup e820_setup_gap
Message-ID: <20080624120810.GC10550@elte.hu>
References: <1213916250.27983.35.camel@promb-2n-dhcp368.eng.vmware.com> <20080620153220.GD17373@elte.hu> <1213990711.31598.22.camel@promb-2n-dhcp368.eng.vmware.com> <86802c440806201250g706bb062t2d472ee0637cac4e@mail.gmail.com> <1213993734.31598.27.camel@promb-2n-dhcp368.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213993734.31598.27.camel@promb-2n-dhcp368.eng.vmware.com>
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


* Alok Kataria <akataria@vmware.com> wrote:

> On Fri, 2008-06-20 at 12:50 -0700, Yinghai Lu wrote:
> > On Fri, Jun 20, 2008 at 12:38 PM, Alok Kataria <akataria@vmware.com> wrote:
> > > Here is the patch based on tip/master
> > >
> > > Please have a look
> > >
> > > --
> > >
> > > This is a preparatory patch for the next patch in series.
> > > Moves some code from e820_setup_gap to a new function e820_search_gap.
> > > This patch is a part of a bug fix where we walk the ACPI table to calculate
> > > a gap for PCI optional devices.
> > >
> > > Signed-off-by: Alok N Kataria <akataria@vmware.com>
> > >
> > > Index: linux-trees.git/arch/x86/kernel/e820.c
> > > ===================================================================
> > > --- linux-trees.git.orig/arch/x86/kernel/e820.c 2008-06-20 10:32:44.000000000 -0700
> > > +++ linux-trees.git/arch/x86/kernel/e820.c      2008-06-20 12:27:58.000000000 -0700
> > > @@ -442,26 +442,22 @@
> > >  }
> > >
> > >  /*
> > > - * Search for the biggest gap in the low 32 bits of the e820
> > > - * memory space.  We pass this space to PCI to assign MMIO resources
> > > - * for hotplug or unconfigured devices in.
> > > - * Hopefully the BIOS let enough space left.
> > > + * Search for a gap in the e820 memory space from start_addr to 2^32.
> > >  */
> > > -__init void e820_setup_gap(void)
> > > +__init int e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
> > > +               unsigned long start_addr)
> > >  {
> > > -       unsigned long gapstart, gapsize, round;
> > > -       unsigned long long last;
> > > -       int i;
> > > +       unsigned long last = 0x100000000ull;
> > 
> > why changing "unsigned long long" to "unsigned long" ?
> > it will overflow on 32bit
> > 
> 
> Oops...my bad, it was unsigned long in e820_64.c. Should be more careful
> with these cross ports.
> Thanks for catching it.

ok, could you please resend the fixed up series? This breakage would be 
a nasty bisection point which we want to avoid.

	Ingo
