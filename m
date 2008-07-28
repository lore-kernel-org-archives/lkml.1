Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbYG1WXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbYG1WXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 18:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbYG1WXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 18:23:43 -0400
Received: from outbound-mail-09.bluehost.com ([69.89.17.209]:57665 "HELO
	outbound-mail-09.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751323AbYG1WXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:23:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=bdwxedHnw8la2DbfHC5HBUUiplW3yHZxiQPR7hUvRAAhUc8ZqXPw/115PRAzqEdznH5CdXRg7/YVsRLevsCyZnw7mXPGHpKprzp5KwS9i/VUUad2HCswdkmevRRbF3KS;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
Date: Mon, 28 Jul 2008 15:23:35 -0700
User-Agent: KMail/1.9.9
Cc: joro@8bytes.org, prarit@redhat.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
References: <20080723111928.15828.42561.sendpatchset@prarit.bos.redhat.com> <20080723221033.GD13662@8bytes.org> <20080724081528F.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080724081528F.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807281523.35469.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 23, 2008 4:14 pm FUJITA Tomonori wrote:
> On Thu, 24 Jul 2008 00:10:33 +0200
>
> Joerg Roedel <joro@8bytes.org> wrote:
> > On Wed, Jul 23, 2008 at 07:19:43AM -0400, Prarit Bhargava wrote:
> > > pci_alloc_consistent/dma_alloc_coherent does not return size aligned
> > > addresses.
> > >
> > > >From Documentation/DMA-mapping.txt:
> > >
> > > "pci_alloc_consistent returns two values: the virtual address which you
> > > can use to access it from the CPU and dma_handle which you pass to the
> > > card.
> > >
> > > The cpu return address and the DMA bus master address are both
> > > guaranteed to be aligned to the smallest PAGE_SIZE order which
> > > is greater than or equal to the requested size.  This invariant
> > > exists (for example) to guarantee that if you allocate a chunk
> > > which is smaller than or equal to 64 kilobytes, the extent of the
> > > buffer you receive will not cross a 64K boundary."
> >
> > Interesting. Have you experienced any problems because of that
> > misbehavior in the GART code? AMD IOMMU currently also violates this
> > requirement. I will send a patch to fix that there too.
>
> IIRC, only PARISC and POWER IOMMUs follow the above rule. So I also
> wondered what problem he hit.

Prarit, what's the latest here?  The v3 patch I have from you doesn't apply to 
my tree but it looks like a good fix.  Care to send me a new patch against my 
for-linus branch?

Thanks,
Jesse
