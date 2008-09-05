Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbYIESf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbYIESf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 14:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbYIESfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 14:35:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43039 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbYIESfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 14:35:18 -0400
Date: Fri, 5 Sep 2008 20:34:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, arjan@infradead.org,
       torvalds@linux-foundation.org, sfr@canb.auug.org.au,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] Blacklist DMAR on Intel G31/G33 chipsets
Message-ID: <20080905183459.GC14258@elte.hu>
References: <1220439231.2985.103.camel@pmac.infradead.org> <1220518477.2985.163.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220518477.2985.163.camel@pmac.infradead.org>
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

> Some BIOSes (the Intel DG33BU, for example) wrongly claim to have DMAR
> when they don't. Avoid the resulting crashes when it doesn't work as
> expected.
> 
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> ---
> 
> This time, I build-tested it with CONFIG_DMAR actually enabled. Sorry. 
> I'd still be grateful if someone could test it on a DG33BU with the 
> old BIOS though, since I've killed mine. I tested the DMI version, but 
> not this one.

ok - fixing this makes sense. I have two worries about this patch.

Firstly, the quirk is keyed off an ACPI capability which is quite bad if 
someone boots with ACPI off. (which is still quite possible) The DMAR is 
PCI enumerated so there's nothing inherently ACPI about this. A DMI 
quirk (which will work even if ACPI is disabled) looks more robust.

Secondly, keying off the PCI ID and assuming a BIOS bug based on the 
presence of an ACPI table can indeed get incoherent results as you 
suspect. It's better to single out the specific BIOS as long as the DMI 
info is specific enough. Even if that PCI ID is never supposed to be 
combined with VT-d (because, obviously, VT-d needs a different chipset), 
it's just a sloppy concept in general.

The fact that you've already tested the DMI version and cannot test the 
new version is one more reason to favor the first patch.

Could you please resend the initial DMI version of the 
drivers/pci/intel-iommu.c commit stand-alone, not embedded in a 'misc' 
pull request, and with Jesse Cc:-ed as well? Thanks,

	Ingo
