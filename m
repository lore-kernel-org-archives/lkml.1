Return-Path: <linux-kernel-owner+w=401wt.eu-S1759734AbZDGGlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759734AbZDGGlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 02:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758597AbZDGGk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 02:40:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45133 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759143AbZDGGk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 02:40:56 -0400
Date: Tue, 7 Apr 2009 08:39:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: torvalds@linux-foundation.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] intel-iommu updates for 2.6.30 (second batch)
Message-ID: <20090407063917.GA12410@elte.hu>
References: <1238839639.3560.37.camel@macbook.infradead.org> <20090407053739.GA10500@elte.hu> <1239083045.22733.383.camel@macbook.infradead.org> <20090407054818.GA5557@elte.hu> <20090407055245.GA10406@elte.hu> <1239084280.22733.404.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239084280.22733.404.camel@macbook.infradead.org>
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

> > The patch below fixes it, but it is only an ugly workaround: we 
> > really dont want 'depends on ACPI' dependencies to spread like 
> > that.
> 
> It _does_ depend on ACPI. Much as I wish it didn't, it's 
> fundamentally tied to it for now.
> 
> > ACPI is a hardware discovery mechanism. It might be the only way 
> > to discover these pieces of hardware at the moment, but we 
> > should not tie method of discovery to hardware support. I'd 
> > suggest a dmar_acpi.c splitout of the ACPI bits.
> 
> As I said, DMAR is the name of an ACPI table.  If we ever manage 
> to get non-ACPI discovery of the hardware, we can write new code 
> which mentions _neither_ DMAR nor ACPI. And at that point, we can 
> talk about moving any generic parts out of the existing 'dmar.c'. 
> Perhaps into intel-iommu.c?

Yeah - i kept thinking of dmar.c as being mostly about discovery 
unrelated, genuine hardware support: QI, msi bits / fault handling. 
You are right that it would be bad to name any non-ACPI bits dmar 
...

Would you want to move the non-ACPI bits to within 
drivers/pci/intel-iommu.c perhaps? Or do you consider those bits too 
platform specific? (intel-iommu.c is nicely generic right now.)

> It's a bit premature to do that now, though -- especially given 
> the unfortunate likelihood that a sensible discovery method will 
> never happen.

PCI IDs are actually a pretty good and stable hardware discovery 
method.

And such movement away from BIOS enumeration and towards PCI IDs and 
direct hardware access is happening (albeit slowly and somewhat 
sporadically), we saw it recently for some PCI mmconfig bits - i.e. 
it's not just for downstream PCI hardware but for more 
infrastructure bits too.

But i'd agree with you that Intel-IOMMU bits will take quite some 
time to be discovered via some other method ... and even if they 
will be, it will be EFI - which is a few layers of pointless 
abstractions worse than ACPI so definitely not a step forward.

	Ingo
