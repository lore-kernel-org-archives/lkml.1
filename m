Return-Path: <linux-kernel-owner+w=401wt.eu-S1756069AbYIPQQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbYIPQQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 12:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754653AbYIPQQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 12:16:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33268 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352AbYIPQQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 12:16:13 -0400
Date: Tue, 16 Sep 2008 18:20:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, andi@firstfloor.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] fix GART to respect device's dma_mask about virtual mappings
Message-ID: <20080916162029.GD25711@one.firstfloor.org>
References: <1221216155-17640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <87hc8grjuf.fsf@basil.nowhere.org> <20080916222032O.fujita.tomonori@lab.ntt.co.jp> <20080916155211.GW24392@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080916155211.GW24392@amd.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 05:52:11PM +0200, Joerg Roedel wrote:
> On Tue, Sep 16, 2008 at 10:20:40PM +0900, FUJITA Tomonori wrote:
> > On Tue, 16 Sep 2008 02:54:32 +0200
> > Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> writes:
> > > 
> > > > Currently, gart IOMMU ignores device's dma_mask when it does virtual
> > > > mappings. So it could give a device a virtual address that the device
> > > > can't access to.
> > > 
> > > Huh? That is what the need_iommu() logic in gart_map_sg()
> > > does. An I'm not aware of any bugs in this area.
> > 
> > What the need_iommu() does is seeing if GART needs to do virtual
> > mappings or not.
> > 
> > (After need_iommu() checking) What this patchset does is to guarantee
> > that GART provides a virtual address that a device can access to.
> > 
> > 
> > > Did you actually see that failure in practice? I don't see
> > > how it could happen.
> > 
> > No, I did not. This patchset does the right thing theoretically, I
> > think, but if such problem never happens for GART, I'll drop the patch
> > for GART. Joerg?
> 
> I am not aware of any failures which are fixed by these patches. 

AFAIK all subsystems deal with it on their own. That is because i386
is the same (no remapping pci_map_* at all) and subsystems are usually 
written to i386 semantics.

> But in
> theory there could be failures.

They will stay failures because GFP_DMA bouncing can not be really
done today in the pci_map_* layer. With a lot of effort you could
probably fix all that, but I doubt it would be worth the effort for
the few devices left with DMA masks < 32bit. 

-Andi

> 
> Joerg
> 
> -- 
>            |           AMD Saxony Limited Liability Company & Co. KG
>  Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
>  System    |                  Register Court Dresden: HRA 4896
>  Research  |              General Partner authorized to represent:
>  Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
>            | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy
> 

-- 
ak@linux.intel.com
