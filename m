Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbYK1Rp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbYK1Rp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 12:45:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbYK1Rpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 12:45:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39181 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbYK1Rpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 12:45:45 -0500
Date: Fri, 28 Nov 2008 18:45:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, stable@kernel.org
Subject: Re: [PATCH] x86: always define DECLARE_PCI_UNMAP* macros
Message-ID: <20081128174510.GJ10487@elte.hu>
References: <1227210596-1196-1-git-send-email-joerg.roedel@amd.com> <20081127114525.GC29013@elte.hu> <200811270904.13730.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811270904.13730.jbarnes@virtuousgeek.org>
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


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Thursday, November 27, 2008 3:45 am Ingo Molnar wrote:
> > * Joerg Roedel <joerg.roedel@amd.com> wrote:
> > > Currently these macros evaluate to a no-op except the kernel is
> > > compiled with GART or Calgary support. But we also need these macros
> > > when we have SWIOTLB, VT-d or AMD IOMMU in the kernel. Since we
> > > always compile at least with SWIOTLB we can define these macros
> > > always. This patch is also for stable backport for the same reason
> > > the SWIOTLB default selection patch is.
> > >
> > > Cc: stable@kernel.org
> > > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > > ---
> > >  arch/x86/include/asm/pci_64.h |   14 --------------
> > >  1 files changed, 0 insertions(+), 14 deletions(-)
> >
> > applied to tip/x86/urgent (for v2.6.28), as this is a DMA mapping 
> > bugfix for IOMMUs. If the AMD IOMMU is turned on in the .config but 
> > CONFIG_GART_IOMMU is off (a rare but possible combo), we'd leak on 
> > unmap and crash the box quickly.
> >
> > Jesse, is that path of upstream merge fine with you?
> 
> Yeah, that's fine with me.  OTOH removing config options generally 
> seems like a good idea too, so maybe this combination should just be 
> disallowed.  Or is there a good reason for this type of config?

well, it's an IOMMU driver, so it's a kernel sizing/configuration thing, 
in line with how we generally allow drivers - with no particular 
dependency between them.

	Ingo
