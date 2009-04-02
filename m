Return-Path: <linux-kernel-owner+w=401wt.eu-S1762997AbZDBP31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762997AbZDBP31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760947AbZDBP3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 11:29:00 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:33327 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760804AbZDBP27 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 11:28:59 -0400
X-BigFish: VPS-22(z34a4jz1432R98dR1805M936fK4cd6kzz1202hzzz32i6bh66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KHHCBQ-02-OKD-01
Date: Thu, 2 Apr 2009 17:29:17 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Stephen Hemminger <shemminger@vyatta.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, davej@redhat.com,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [Bug 487894] New: sky2 0000:06:00.0: DMA-API: device driver
	frees DMA memory with different size
Message-ID: <20090402152917.GC4776@amd.com>
References: <20090402105415.GD21083@amd.com> <20090402200634I.fujita.tomonori@lab.ntt.co.jp> <20090402111839.GE21083@amd.com> <20090402230346B.fujita.tomonori@lab.ntt.co.jp> <20090402143142.GA4776@amd.com> <20090402080806.047e2716@nehalam>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090402080806.047e2716@nehalam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 02 Apr 2009 15:28:44.0091 (UTC) FILETIME=[B56400B0:01C9B3A7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 08:08:06AM -0700, Stephen Hemminger wrote:
> On Thu, 2 Apr 2009 16:31:42 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> > Author: Joerg Roedel <joerg.roedel@amd.com>
> > Date:   Thu Apr 2 15:55:55 2009 +0200
> > 
> >     x86/dma: unify definition of pci_unmap_addr* and pci_unmap_len macros
> >     
> >     Impact: unification of pci-dma macros and pci_32h removal
> >     
> >     This patch unifies the definition of the pci_unmap_addr*, pci_unmap_len*
> >     and DECLARE_PCI_UNMAP* macros. This makes sense because the pci_unmap
> >     functions are no longer no-ops anymore when the kernel runs with
> >     CONFIG_DMA_API_DEBUG. This also simplifies the port of x86_64 iommu
> >     drivers to 32 bit x86 and let us get rid of pci_32.h.
> >     
> >     Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> 
> Would also like some more comments to explain to the kernel neophytes why
> the 32 bit version is no-op.  Do other arch have same issue?
> 
> 
> Acked-by: Stephen Hemminger <shemminger@vyatta.com>

Ok, changed the patch description to

x86/dma: unify definition of pci_unmap_addr* and pci_unmap_len macros

Impact: unification of pci-dma macros and pci_32.h removal

This patch unifies the definition of the pci_unmap_addr*, pci_unmap_len*
and DECLARE_PCI_UNMAP* macros. This makes sense because the pci_unmap
functions are no longer no-ops anymore when the kernel runs with
CONFIG_DMA_API_DEBUG. Without an iommu or DMA_API_DEBUG it is a no-op on 32 bit
because the dma mapping path returns a physical address and therefore the
dma-api implementation has no internal state which needs to be destroyed with
an unmap call.
This unification also simplifies the port of x86_64 iommu drivers to 32 bit x86
and let us get rid of pci_32.h.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Acked-by: Stephen Hemminger <shemminger@vyatta.com>


Joerg


-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

