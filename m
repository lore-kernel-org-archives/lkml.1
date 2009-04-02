Return-Path: <linux-kernel-owner+w=401wt.eu-S1764401AbZDBPIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764401AbZDBPIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758667AbZDBPIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 11:08:24 -0400
Received: from mail.vyatta.com ([76.74.103.46]:57909 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760133AbZDBPIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 11:08:23 -0400
Date: Thu, 2 Apr 2009 08:08:06 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, davej@redhat.com,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [Bug 487894] New: sky2 0000:06:00.0: DMA-API: device driver
 frees DMA memory with different size
Message-ID: <20090402080806.047e2716@nehalam>
In-Reply-To: <20090402143142.GA4776@amd.com>
References: <20090402105415.GD21083@amd.com>
	<20090402200634I.fujita.tomonori@lab.ntt.co.jp>
	<20090402111839.GE21083@amd.com>
	<20090402230346B.fujita.tomonori@lab.ntt.co.jp>
	<20090402143142.GA4776@amd.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Apr 2009 16:31:42 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Thu, Apr 02, 2009 at 11:03:58PM +0900, FUJITA Tomonori wrote:
> > On Thu, 2 Apr 2009 13:18:39 +0200
> > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > 
> > > On Thu, Apr 02, 2009 at 08:06:26PM +0900, FUJITA Tomonori wrote:
> > > > On Thu, 2 Apr 2009 12:54:15 +0200
> > > > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > > > 
> > > > > On Wed, Apr 01, 2009 at 11:02:45AM -0700, Stephen Hemminger wrote:
> > > > > > 
> > > > > > The sky2 driver uses pci_unmap_len and pci_unmap_len_set which on 32 bit
> > > > > > platforms are meaningless so they are stubbed out. 
> > > > > > Basically, DMA-API checks are wrong/bogus to enforce on 32bit x86 as is.
> > > > > 
> > > > > As far as I know the VT-d driver is available on 32 bit x86 too. So this should
> > > > > not always be a nop.
> > > > 
> > > > VT-d is available on only x86_64.
> > > 
> > > At least there was a patch to enable it on 32 bit too. See
> > > 
> > > https://lists.linux-foundation.org/pipermail/iommu/2009-February/001080.html
> > > 
> > > It seems not to be upstream yet.
> > 
> > It's not in upstream.
> > 
> > 
> > Anyway, about the original problem, I think that the best fix is not
> > to stub out the dma API; using the dma API properly is always a good
> > thing.
> 
> True.
> 
> For the real fix I prepared this fix. We still should find a better #ifdef
> condition but that should not be a seperate patch. Does that look ok to
> everyone? If yes, I send it to Ingo.
> 
> commit e8cdd3b8d2fc3ec2a1dd337cba94feb7a7442751
> Author: Joerg Roedel <joerg.roedel@amd.com>
> Date:   Thu Apr 2 15:55:55 2009 +0200
> 
>     x86/dma: unify definition of pci_unmap_addr* and pci_unmap_len macros
>     
>     Impact: unification of pci-dma macros and pci_32h removal
>     
>     This patch unifies the definition of the pci_unmap_addr*, pci_unmap_len*
>     and DECLARE_PCI_UNMAP* macros. This makes sense because the pci_unmap
>     functions are no longer no-ops anymore when the kernel runs with
>     CONFIG_DMA_API_DEBUG. This also simplifies the port of x86_64 iommu
>     drivers to 32 bit x86 and let us get rid of pci_32.h.
>     
>     Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

Would also like some more comments to explain to the kernel neophytes why
the 32 bit version is no-op.  Do other arch have same issue?


Acked-by: Stephen Hemminger <shemminger@vyatta.com>
