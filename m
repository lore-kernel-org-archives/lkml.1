Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbYGSMN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbYGSMN1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 08:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbYGSMNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 08:13:20 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:49781 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440AbYGSMNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 08:13:19 -0400
Date: Sat, 19 Jul 2008 21:12:56 +0900
To: joro@8bytes.org
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] replace CONFIG_IOMMU with CONFIG_GART_IOMMU in iommu.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080718113105.GA13662@8bytes.org>
References: <20080709162913H.tomof@acm.org>
	<20080718113105.GA13662@8bytes.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080719211303J.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2008 13:31:05 +0200
Joerg Roedel <joro@8bytes.org> wrote:

> On Wed, Jul 09, 2008 at 04:29:41PM +0900, FUJITA Tomonori wrote:
> > Should be CONFIG_GART_IOMMU instead of CONFIG_IOMMU here?
> > 
> > Hmm, looks like it would be nice to have more cleanups of iommu.h and
> > gart.h.
> > 
> > This is against tip/master.
> > 
> > =
> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Subject: [PATCH] replace CONFIG_IOMMU with CONFIG_GART_IOMMU in iommu.h
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  include/asm-x86/iommu.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/asm-x86/iommu.h b/include/asm-x86/iommu.h
> > index 07862fd..cb7e989 100644
> > --- a/include/asm-x86/iommu.h
> > +++ b/include/asm-x86/iommu.h
> > @@ -5,7 +5,7 @@ extern void pci_iommu_shutdown(void);
> >  extern void no_iommu_init(void);
> >  extern int force_iommu, no_iommu;
> >  extern int iommu_detected;
> > -#ifdef CONFIG_IOMMU
> > +#ifdef CONFIG_GART_IOMMU
> >  extern void gart_iommu_init(void);
> >  extern void gart_iommu_shutdown(void);
> >  extern void __init gart_parse_options(char *);
> 
> The asm-x86/iommu.h file is a leftover from some patches I submitted
> last year.  I renamed iommu.h to gart.h but somehow iommu.h still exists
> in mainline. I think we should check again if somebody is using that
> file and remove it if not.

I think that we need a common header file (iommu.h or whatever) for
what everyone needs, pci_iommu_shutdown(), no_iommu_init(), etc.

Anyway, I did more cleanups:

http://lkml.org/lkml/2008/7/10/510

or

tip/x86/gart

Let me know if you think we still need cleanups.

Thanks,
