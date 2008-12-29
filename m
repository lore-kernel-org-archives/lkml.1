Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbYL2NAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbYL2NAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 08:00:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYL2NAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 08:00:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55165 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbYL2M77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 07:59:59 -0500
Date: Mon, 29 Dec 2008 13:59:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jaswinder Singh Rajput <jaswinder@infradead.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       mj@ucw.cz
Subject: Re: [PATCH] move arch/x86/pci/pci.h to
	arch/x86/include/asm/pci_x86.h
Message-ID: <20081229125921.GB23674@elte.hu>
References: <1230382948.3373.1.camel@jaswinder.satnam> <20081229121218.GB9628@elte.hu> <20081229122251.GA13687@elte.hu> <20081229125411.GA1852@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081229125411.GA1852@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > 
> > btw., you missed to update a couple of places - pci/pci.h was used outside 
> > of arch/x86 as well. Updated patch below.
> > 
> > 	Ingo
> > 
> > ---------------->
> > >From 54a090abe7cb85c724305124f57d2570b7e9adf1 Mon Sep 17 00:00:00 2001
> > From: Jaswinder Singh Rajput <jaswinder@infradead.org>
> > Date: Sat, 27 Dec 2008 18:32:28 +0530
> > Subject: [PATCH] x86, pci: move arch/x86/pci/pci.h to arch/x86/include/asm/pci_x86.h
> > 
> > Impact: cleanup
> > 
> > Now that arch/x86/pci/pci.h is used in a number of other places as well,
> > move the lowlevel x86 pci definitions into the architecture include files.
> > (not to be confused with the existing arch/x86/include/asm/pci.h file,
> > which provides public details about x86 PCI)
> > 
> > Tested on: X86_32_UP, X86_32_SMP and X86_64_SMP
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  arch/x86/include/asm/pci_x86.h     |  165 ++++++++++++++++++++++++++++++++++++
> >  arch/x86/kernel/mmconf-fam10h_64.c |    3 +-
> >  arch/x86/kernel/reboot.c           |    3 +-
> >  arch/x86/pci/acpi.c                |    2 +-
> >  arch/x86/pci/amd_bus.c             |    2 +-
> >  arch/x86/pci/common.c              |    3 +-
> >  arch/x86/pci/direct.c              |    2 +-
> >  arch/x86/pci/early.c               |    2 +-
> >  arch/x86/pci/fixup.c               |    3 +-
> >  arch/x86/pci/i386.c                |    2 +-
> >  arch/x86/pci/init.c                |    2 +-
> >  arch/x86/pci/irq.c                 |    3 +-
> >  arch/x86/pci/legacy.c              |    2 +-
> >  arch/x86/pci/mmconfig-shared.c     |    3 +-
> >  arch/x86/pci/mmconfig_32.c         |    2 +-
> >  arch/x86/pci/mmconfig_64.c         |    3 +-
> >  arch/x86/pci/numaq_32.c            |    2 +-
> >  arch/x86/pci/olpc.c                |    2 +-
> >  arch/x86/pci/pcbios.c              |    5 +-
> >  arch/x86/pci/pci.h                 |  162 -----------------------------------
> >  arch/x86/pci/visws.c               |    3 +-
> >  drivers/pci/hotplug/cpqphp_core.c  |    2 +-
> >  drivers/pci/hotplug/cpqphp_pci.c   |    2 +-
> >  drivers/pci/hotplug/ibmphp_core.c  |    2 +-
> >  24 files changed, 188 insertions(+), 194 deletions(-)
> 
> You should teach your script to use:
> git format-patch -M -B -C 
> 
> With -M -B -C you get a much better picture of what happens when you 
> rename files like in this patch (and copy them).

you mean:

  git format-patch --stdout -1 -M -B -C <sha1>

(otherwise people trying this out will be faced with git creating all 
commits way back to the beginnings of time, as patches in their current 
directory ;-)

	Ingo
