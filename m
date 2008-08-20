Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbYHTRkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbYHTRkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 13:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbYHTRk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 13:40:26 -0400
Received: from outbound-mail-130.bluehost.com ([67.222.38.30]:45473 "HELO
	outbound-mail-130.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752299AbYHTRkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 13:40:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=HPg2EXvmzDkEEMIMH++BKhiWILGa0vFRxDFCM6YYRJ3ztVB/0tI01IZBg/SmtjywFatz6EHYpmKMkJrMPBylWLtLJs+0bd9OEcgRNyBFxeIP/Duiv0JvGY+9fioVxEo7;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/8] x86 dma_*_coherent rework patchset v2
Date: Wed, 20 Aug 2008 10:39:56 -0700
User-Agent: KMail/1.9.9
Cc: Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, mingo@redhat.com,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, muli@il.ibm.com
References: <1219156366-32498-1-git-send-email-joerg.roedel@amd.com> <20080820094612.GA28492@elte.hu>
In-Reply-To: <20080820094612.GA28492@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808201039.56887.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 20, 2008 2:46 am Ingo Molnar wrote:
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> > Hi,
> >
> > this patchset reworks the dma_*_coherent functions in the DMA layer
> > for the x86 architecture. The patch series extends the existing DMA
> > backends with missing *coherent callbacks and simplifies the generic
> > function to basically only call the registered backend. This allows
> > future optimizations in hardware specific IOMMU implementations. The
> > code ist tested on AMD64 with AMD IOMMU, GART, SWIOTLB and NOMMU as
> > well as on my old 486 box. Muli tested the Calgary specific patch.
> >
> > Joerg
> >
> > Changes since v1:
> >
> > - fixed wrong logic in the pci-nommu alloc_coherent code
> > - moved dma_*_coherent to include/asm-x86/dma-mapping.h
> >
> > git diff --stat tip/master.. :
> >
> >  arch/x86/kernel/amd_iommu.c      |    2 -
> >  arch/x86/kernel/pci-calgary_64.c |   14 ++++
> >  arch/x86/kernel/pci-dma.c        |  146
> > +------------------------------------- arch/x86/kernel/pci-gart_64.c    |
> >   35 +++++++++-
> >  arch/x86/kernel/pci-nommu.c      |   62 ++++++++++++++++
> >  include/asm-x86/dma-mapping.h    |   47 ++++++++++---
> >  6 files changed, 149 insertions(+), 157 deletions(-)
>
> applied to tip/x86/iommu - thanks Joerg!
>
> Jesse, Fujita-san, do these changes look fine to you?

Yeah, I'll let you push this time. :)

Signed-off-by:  Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
