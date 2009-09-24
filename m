Return-Path: <linux-kernel-owner+w=401wt.eu-S1752217AbZIXWEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbZIXWEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 18:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbZIXWEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 18:04:11 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:38196 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbZIXWEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 18:04:09 -0400
Date: Thu, 24 Sep 2009 15:03:50 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Gary Hade <garyhade@us.ibm.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: fixing "pci=use_crs"
Message-ID: <20090924220350.GA7321@us.ibm.com>
References: <200909161715.24376.bjorn.helgaas@hp.com> <200909211520.56800.bjorn.helgaas@hp.com> <4AB95F41.1070500@lwfinger.net> <200909231723.31786.bjorn.helgaas@hp.com> <86802c440909231628t6b35aae4u706c0c35590bc0d3@mail.gmail.com> <1253762502.12653.4.camel@dc7800.home> <86802c440909232142p3e5d4974g51eb519d5d0ef58e@mail.gmail.com> <1253798658.14132.9.camel@dc7800.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253798658.14132.9.camel@dc7800.home>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 07:24:18AM -0600, Bjorn Helgaas wrote:
> On Wed, 2009-09-23 at 21:42 -0700, Yinghai Lu wrote:
> > On Wed, Sep 23, 2009 at 8:21 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > > On Wed, 2009-09-23 at 16:28 -0700, Yinghai Lu wrote:
> > >> On Wed, Sep 23, 2009 at 4:23 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > >
> > >> > P.S.  Yinghai, you posted some patches earlier dealing with "only one
> > >> > HT chain."  You apparently have some insight into what's going on here,
> > >> > but unfortunately, the changelogs mean absolutely nothing to me.  Can
> > >> > you give me any clues?
> > >>
> > >> which commit?
> > >>
> > >> normally we only need to have split root resource into several pieces
> > >> when we have two HT chains or other io chains...
> > >
> > > I meant the patches here:
> > >  http://lkml.org/lkml/2009/6/24/557
> > >
> > > My opinion is that ACPI is there to give us an abstract description of
> > > the machine, and we shouldn't have to introduce knowledge like "this
> > > machine has two HT chains" or add checks in amd_bus.c about
> > > "pci_root_num <= 1".
> > >
> > > But maybe if I knew what an HT chain was and why you think it affects
> > > the description returned by _CRS, it would give me a clue about how to
> > > deal with this in a generic way.
> > 
> > we could use _CRS, but lots of BIOS just provide messed up resources
> > in _CRS to OS.
> 
> We do have to assume there are BIOS defects here, but in most cases, I
> look for Linux deficiencies first.  I'm assuming (without real evidence)
> that Windows does look at the _CRS, so the worst BIOS defects should be
> weeded out by Windows testing.
> 
> > for example, the HW conf register does have mmio high range there, but
> > _CRS doesn't report them.
> 
> On Larry's box, _CRS reports *more* ranges than Linux was prepared for.
> This would be a bug in the other direction, where _CRS reports *less*
> than it should.
> 
> > thought we can use whilelist to use _CRS for them.
> 
> I'm opposed to a whitelist for this issue because it means we have to
> continually update the whitelist for new, correctly working machines.
> If we can't figure out anything better, we could use a date-based
> blacklist (ignore _CRS for all machines older than today).

Unless someone has a strong need other than PCI hot-add for
root bridge _CRS to be used by default, would it possibly make
sense (at least as a first cut) to limit the default use of
_CRS to only those root bridges that (1) are located above
PCI hotplug capable slots and (2) have _CRS that returns a
quantity of ranges that will not overrun the current fixed
size resource arrays?

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

