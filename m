Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbYIFPuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbYIFPuJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 11:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbYIFPt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 11:49:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47575 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118AbYIFPt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 11:49:56 -0400
Date: Sat, 6 Sep 2008 17:49:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, arjan@infradead.org,
       torvalds@linux-foundation.org, sfr@canb.auug.org.au,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] Blacklist DMAR on Intel G31/G33 chipsets
Message-ID: <20080906154935.GD1774@elte.hu>
References: <1220439231.2985.103.camel@pmac.infradead.org> <1220518477.2985.163.camel@pmac.infradead.org> <20080905183459.GC14258@elte.hu> <1220640430.2985.389.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220640430.2985.389.camel@pmac.infradead.org>
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


* David Woodhouse <dwmw2@infradead.org> wrote:

> On Fri, 2008-09-05 at 20:34 +0200, Ingo Molnar wrote:
> > * David Woodhouse <dwmw2@infradead.org> wrote:
> > 
> > > Some BIOSes (the Intel DG33BU, for example) wrongly claim to have DMAR
> > > when they don't. Avoid the resulting crashes when it doesn't work as
> > > expected.
> > > 
> > > Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> > > ---
> > > 
> > > This time, I build-tested it with CONFIG_DMAR actually enabled. Sorry. 
> > > I'd still be grateful if someone could test it on a DG33BU with the 
> > > old BIOS though, since I've killed mine. I tested the DMI version, but 
> > > not this one.
> > 
> > ok - fixing this makes sense. I have two worries about this patch.
> > 
> > Firstly, the quirk is keyed off an ACPI capability which is quite bad if 
> > someone boots with ACPI off. (which is still quite possible) The DMAR is 
> > PCI enumerated so there's nothing inherently ACPI about this. A DMI 
> > quirk (which will work even if ACPI is disabled) looks more robust.
> 
> No, the intel-iommu code is isn't PCI-enumerated -- it all depends on 
> that ACPI table, unfortunately. [...]

ah, you are right ... and i thought i could trust grep -i acpi 
drivers/pci/intel-iommu.c coming up empty ;-)

Jesse's call obviously, but the DMI thing local to intel-iommu.c still 
looks better to me in all regards. I'm no fan of DMI in general - it 
just doesnt scale - but here a crappy BIOS gets punished with a DMI 
quirk and that's OK.

	Ingo
