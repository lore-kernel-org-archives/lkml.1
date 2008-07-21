Return-Path: <linux-kernel-owner+w=401wt.eu-S1751909AbYGUPq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbYGUPq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 11:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbYGUPqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 11:46:21 -0400
Received: from sh.osrg.net ([192.16.179.4]:52876 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbYGUPqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 11:46:20 -0400
Date: Tue, 22 Jul 2008 00:46:06 +0900
To: prarit@redhat.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH]: iommu fix potential overflow in alloc_iommu()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4884A983.7010709@redhat.com>
References: <20080721141501.3720.4565.sendpatchset@prarit.bos.redhat.com>
	<20080722001317N.fujita.tomonori@lab.ntt.co.jp>
	<4884A983.7010709@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080722004638M.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008 11:21:39 -0400
Prarit Bhargava <prarit@redhat.com> wrote:

> 
> 
> FUJITA Tomonori wrote:
> > On Mon, 21 Jul 2008 10:15:22 -0400
> > Prarit Bhargava <prarit@redhat.com> wrote:
> >
> >   
> >> (This didn't appear on LKML or any of the mirrors ... trying again)
> >>
> >> It is possible that alloc_iommu()'s boundary_size overflows as
> >> dma_get_seg_boundary can return 0xffffffff.  In that case, further usage of
> >> boundary_size triggers a BUG_ON() in the iommu code.
> >>     
> >
> > Did you actually hit this? pci-gart_64.c is used only by X86_64.
> >   
> 
> I hit this by declaring a device struct and not declaring a value for 
> dev->dma_parms->segment_boundary_mask.

What do you mean? You set dev->dma_params but does't set
dev->dma_parms->segment_boundary_mask? If so, you need to fix your
code. If you set dev->dma_parms, dma_parms needs to be initialized
properly.
