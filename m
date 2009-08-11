Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbZHKMfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbZHKMfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbZHKMfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:35:40 -0400
Received: from mail.gmx.net ([213.165.64.20]:37213 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751479AbZHKMfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:35:39 -0400
X-Authenticated: #20497841
X-Provags-ID: V01U2FsdGVkX1/Nk/BudtLNdzA5KmfstK4GUHSSA1i4EplLZUa1gy
	/dT9WVIJaX5eBy
Date: Tue, 11 Aug 2009 14:36:05 +0200
From: Olaf Dabrunz <Olaf.Dabrunz@gmx.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stefan Assmann <sassmann@redhat.com>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Olaf Dabrunz <Olaf.Dabrunz@gmx.net>
Subject: Re: drivers/pci/quirks.c: irq_reroute_variant is dead code?
Message-ID: <20090811123605.GD14714@santana.dyndns.org>
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>,
	Stefan Assmann <sassmann@redhat.com>, Len Brown <lenb@kernel.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	the arch/x86 maintainers <x86@kernel.org>
References: <4A6F5670.4010405@goop.org> <20090807103318.06ed3ecd@jbarnes-g45> <20090808144520.GB25931@elte.hu> <20090810093228.54406cab@jbarnes-g45> <4A8121FD.1050307@redhat.com> <20090811080622.GA23226@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090811080622.GA23226@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-Aug-09, Ingo Molnar wrote:
> 
> * Stefan Assmann <sassmann@redhat.com> wrote:
> 
> > On 10.08.2009 18:32, Jesse Barnes wrote:
> >> [Corrected Stefan's address.]
> >
> > Thanks Jesse! CCing Olaf as well.
> >
> >> On Sat, 8 Aug 2009 16:45:20 +0200
> >> Ingo Molnar<mingo@elte.hu>  wrote:
> >>
> >>> * Jesse Barnes<jbarnes@virtuousgeek.org>  wrote:
> >>>
> >>>> On Tue, 28 Jul 2009 12:50:08 -0700
> >>>> Jeremy Fitzhardinge<jeremy@goop.org>  wrote:
> >>>>
> >>>>> quirk_reroute_to_boot_interrupts_intel() goes to some effort to
> >>>>> scan for a bunch of Intel devices and set
> >>>>> dev->irq_reroute_variant = INTEL_IRQ_REROUTE_VARIANT.  However,
> >>>>> as far as I can see that's the only reference to
> >>>>> dev->irq_reroute_variant and INTEL_IRQ_REROUTE_VARIANT, so the
> >>>>> whole thing appears to have no effect.
> >>>>>
> >>>>> Is it all dead code?  Is there something else which should be
> >>>>> there missing?
> >>>> Hm my quick look couldn't find a user either.  The initial patch
> >>>> to add that stuff (e1d3a90846b40ad3160bf4b648d36c6badad39ac) had
> >>>> an ACPI component, but it looks like that may have vanished
> >>>> somehow (maybe some of the IOAPIC code got shuffled around and
> >>>> this bit was missed?).
> >>>>
> >>>> Stefan or Ingo?
> >>> I dont remember ioapic interactions. Stefan?
> >>>
> >>> 	Ingo
> >>>
> >
> > Actually the ACPI part of the commit got trashed by some major 
> > ACPI rewrite. [...]
> 
> Yeah, i remember some larger reject resolved by Len i think, about 
> two cycles ago, in this area. So we probably lost those bits there - 
> i've Cc:-ed Len.
> 
> There's no urgency in terms of v2.6.31 (since we never really 
> exposed this new functionality in a new release), but it would be 
> nice to get to the bottom of this.

Yep, that would be nice.

I was made aware of that problem early this year when the ACPI code
change was made. Since then I heard that someone already wrote some
patch for the boot IRQ quirks. But obviously that referred to some other
part of the quirk. Stefan?

As I am currently unemployed, demotivated and trying to get my work on
fctrace going again (as well as to get the rest of my life in order),
it seems I have no time to fix this. I would love to, really. We need to
get these quirks in, and I would like to discuss how to do this The Right
Way with the rewritten ACPI code (and the existing MP code).

Regards,

-- 
Olaf Dabrunz (Olaf.Dabrunz <at> gmx.net)

