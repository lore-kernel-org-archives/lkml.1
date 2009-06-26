Return-Path: <linux-kernel-owner+w=401wt.eu-S1758138AbZFZLEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138AbZFZLEr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 07:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbZFZLEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 07:04:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35938 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbZFZLEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 07:04:37 -0400
Date: Fri, 26 Jun 2009 13:04:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 3/9] x86/moorestown: add moorestown platform flags
Message-ID: <20090626110429.GB12446@elte.hu>
References: <43F901BD926A4E43B106BF17856F07556412B7E2@orsmsx508.amr.corp.intel.com> <20090626071955.GG14078@elte.hu> <20090626101310.4110a290@lxorguk.ukuu.org.uk> <20090626093859.GA12571@elte.hu> <20090626111603.758ec7fb@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090626111603.758ec7fb@lxorguk.ukuu.org.uk>
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > It's an entirely legitimate question, given that many other 
> > current modern subarchitectures detect themselves based on PCI 
> > config space early accesses or (sometimes) BIOS data structures 
> > - and that both of those methods are better than using boot 
> > flags.
> 
> The flags are passed by the boot loader which is the one thing 
> that knows what the platform is only deeply embedded hardware. See 
> the ARM and PPC ports.

And? There's an obvious quality difference between various platform 
enumeration methods - and we strive for the highest quality methods.

Using boot flags is one of the lowest quality enumeration methods 
and the fact that there's precedence for it in other architectures 
is not a technical reason to make the same mistakes on x86 too.

Especially here where there's two other enumeration methods easily 
available: SFI and PCI. Any of those suffices.

> > > - Embedded x86 like devices are going to regularly occur 
> > > without any PCI
> > 
> > This proposed Intel subarchitecture comes with PCI support, 
> > obviously.
> 
> And this is relevant to the fact there will be systems without PCI 
> how ?

It is obviously relevant to the fact that the proposed patches here 
(on which i commented) come for a platform with PCI support. Or do 
you claim that Intel submitted this patch-set for PCI-less MIDs? 
(this was not mentioned anywhere in the patches)

> > > - You need to know the platform in order to know how to access 
> > >   any PCI bus that may or may not hypothetically exist.
> > 
> > Uhm, not really.
> 
> Uhm yes really
> 
> > Have a look at arch/x86/kernel/early-quirks.c. All you generally 
> > need to know is a PCI ID that sits on the root bus.
> 
> How will you probe the root bus without knowing what the PCI 
> configuration mechanism is for your platform

That's very simple really - there's basically a very low number of 
PCI configuration mechanisms/ports on x86, and the MIDs have no 
reason to depart from that standard. There's two that matter in 
practice, and it can all be safely probed.

PCI is really essential to any modern architecture (precisely 
because it's standard and well-known) and i doubt Intel will try to 
engineer out PCI from its systems. If it happens i will comment on 
that kind of braindamage in due course.

But, PCI IDs dont _have_ to be used - there's ample other 
environmental space available via SFI, ACPI or EFI or old-and-proven 
EBDA.

> > Early PCI ID checks are typical and robust way to identify 
> > 'weird' subarchitectures. Sometimes we do it via BIOS data 
> > structures. Only as a last option do we want to use boot loader 
> > mechanisms - it's the most inflexible one really.
> 
> SFI doesn't indicate MRST

So do you claim that this particular patchset supports systems with 
no SFI, no ACPI, just plain bootloader flags?

> > Furtherore, Moorestown comes with SFI and there sure can be a 
> > BIOS table that describes the platform properly. We can read 
> > such tables very early during bootup, well before platform 
> > devices are set up.
> 
> But they don't tell you what the platform is. Again see every 
> platform we currently support which has deeply embedded forms. 
> There is a reason they went that way and it includes fifteen years 
> of finding out which ways don't work for all cases. For example if 
> you don't have standard PC like firmware and you go looking for 
> SFI or ACPI will your box stay up ?

Do you claim that the Intel patchset here deals with systems that 
have no SFI and no ACPI? My question was very specific to this 
patch-set. Bootloader flags suck because they add a needless 
dimension to the already complex boot protocol. Use existing 
mechanisms instead - it's really easy and has other advantages as 
well.

Non-x86 ultra-embedded might use crappier techniques but i'd expect 
Intel has the resources to do better here. Using standard hardware 
or firmware interfaces for that is far better in the x86 space and 
we have no reason to depart from that really.

	Ingo
