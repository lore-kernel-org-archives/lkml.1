Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbZKJEpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbZKJEpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 23:45:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755282AbZKJEpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 23:45:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43692 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398AbZKJEpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 23:45:14 -0500
Date: Tue, 10 Nov 2009 05:45:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org, chrisw@sous-sol.org,
       dwmw2@infradead.org, joerg.roedel@amd.com
Subject: Re: [PATCH 01/10] Add iommu_init to x86_init_ops
Message-ID: <20091110044507.GB7897@elte.hu>
References: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1256712464-21472-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <84144f020911091202h26dbfad4qf0651ae327444fc0@mail.gmail.com>
 <20091110051037B.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110051037B.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Mon, 9 Nov 2009 22:02:24 +0200
> Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > On Wed, Oct 28, 2009 at 8:47 AM, FUJITA Tomonori
> > <fujita.tomonori@lab.ntt.co.jp> wrote:
> > > We call the detections functions of all the IOMMUs then all their
> > > initialization functions. THe latter is pointless since we don't
> > > detect multiple different IOMMUs. What we need to do is calling the
> > > initialization function of the detected IOMMU.
> > >
> > > This adds iommu_init hook to x86_init_ops so if an IOMMU detection
> > > function can set its initialization function to the hook.
> > >
> > > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > ---
> > > ?arch/x86/include/asm/iommu.h ? ?| ? ?1 +
> > > ?arch/x86/include/asm/x86_init.h | ? ?9 +++++++++
> > > ?arch/x86/kernel/pci-dma.c ? ? ? | ? ?2 ++
> > > ?arch/x86/kernel/x86_init.c ? ? ?| ? ?5 +++++
> > > ?4 files changed, 17 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/arch/x86/include/asm/iommu.h b/arch/x86/include/asm/iommu.h
> > > index fd6d21b..42aa977 100644
> > > --- a/arch/x86/include/asm/iommu.h
> > > +++ b/arch/x86/include/asm/iommu.h
> > > @@ -3,6 +3,7 @@
> > >
> > > ?extern void pci_iommu_shutdown(void);
> > > ?extern void no_iommu_init(void);
> > > +static inline int iommu_init_noop(void) { return 0; }
> > 
> > Why is this function not put in x86_init.c?
> 
> If it's fine by x86 maintainers, I'll do in the next version.

Sure, that looks good to me.

	Ingo
