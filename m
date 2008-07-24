Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbYGXHrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbYGXHrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 03:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbYGXHq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 03:46:57 -0400
Received: from 8bytes.org ([88.198.83.132]:57127 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbYGXHq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 03:46:57 -0400
Date: Thu, 24 Jul 2008 09:46:55 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, ed.pollard@ibm.com, epollard@redhat.com
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
Message-ID: <20080724074655.GM31439@8bytes.org>
References: <20080723111928.15828.42561.sendpatchset@prarit.bos.redhat.com> <20080723221033.GD13662@8bytes.org> <20080724081528F.fujita.tomonori@lab.ntt.co.jp> <4887C2F7.6040506@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4887C2F7.6040506@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 07:47:03PM -0400, Prarit Bhargava wrote:
> 
> >>Interesting. Have you experienced any problems because of that
> >>misbehavior in the GART code? AMD IOMMU currently also violates this
> >>requirement. I will send a patch to fix that there too.
> >>    
> >
> >  
> 
> Joerg,  yes I can see misbehavior caused by this code.  O/w I wouldn't 
> be spending my time fixing it :) :)
> 
> See below ....
> 
> >IIRC, only PARISC and POWER IOMMUs follow the above rule. So I also
> >wondered what problem he hit.
> >  
> 
> I wonder if IBM's Calgary IOMMU needs this fix? ... I've added Ed 
> Pollard to find out.
> 
> On big memory footprint (16G or above) systems it is possible that the 
> e820 map reserves most of the lower 4G of memory for system use*.  So 
> it's possible that the 4G region is almost completely reserved at boot 
> time and so the kernel starts using the IOMMU for DMA (see 
> dma_alloc_coherent()).  The addresses returned are not properly aligned, 
> and this causes serious problems for some drivers that require a 
> physical aligned address for the device.

Do you have a list of driver which require this? I would like to
reproduce this issue. Does it also happen when you start the kernel with
iommu=force (GART should then be used for all DMA remapping) too?

Joerg
