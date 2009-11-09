Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbZKIUL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbZKIUL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 15:11:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbZKIULz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 15:11:55 -0500
Received: from sh.osrg.net ([192.16.179.4]:58874 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923AbZKIULz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 15:11:55 -0500
Date: Tue, 10 Nov 2009 05:11:20 +0900
To: penberg@cs.helsinki.fi
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, dwmw2@infradead.org, joerg.roedel@amd.com,
       mingo@elte.hu
Subject: Re: [PATCH 01/10] Add iommu_init to x86_init_ops
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <84144f020911091202h26dbfad4qf0651ae327444fc0@mail.gmail.com>
References: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1256712464-21472-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<84144f020911091202h26dbfad4qf0651ae327444fc0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-Id: <20091110051037B.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 10 Nov 2009 05:11:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Nov 2009 22:02:24 +0200
Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Wed, Oct 28, 2009 at 8:47 AM, FUJITA Tomonori
> <fujita.tomonori@lab.ntt.co.jp> wrote:
> > We call the detections functions of all the IOMMUs then all their
> > initialization functions. THe latter is pointless since we don't
> > detect multiple different IOMMUs. What we need to do is calling the
> > initialization function of the detected IOMMU.
> >
> > This adds iommu_init hook to x86_init_ops so if an IOMMU detection
> > function can set its initialization function to the hook.
> >
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  arch/x86/include/asm/iommu.h    |    1 +
> >  arch/x86/include/asm/x86_init.h |    9 +++++++++
> >  arch/x86/kernel/pci-dma.c       |    2 ++
> >  arch/x86/kernel/x86_init.c      |    5 +++++
> >  4 files changed, 17 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/iommu.h b/arch/x86/include/asm/iommu.h
> > index fd6d21b..42aa977 100644
> > --- a/arch/x86/include/asm/iommu.h
> > +++ b/arch/x86/include/asm/iommu.h
> > @@ -3,6 +3,7 @@
> >
> >  extern void pci_iommu_shutdown(void);
> >  extern void no_iommu_init(void);
> > +static inline int iommu_init_noop(void) { return 0; }
> 
> Why is this function not put in x86_init.c?

If it's fine by x86 maintainers, I'll do in the next version.
