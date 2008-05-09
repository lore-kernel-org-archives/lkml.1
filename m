Return-Path: <linux-kernel-owner+w=401wt.eu-S934526AbYEIA1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934526AbYEIA1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 20:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762663AbYEIA05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 20:26:57 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:60300 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758491AbYEIA04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 20:26:56 -0400
Date: Fri, 9 May 2008 09:23:29 +0900
To: alexisb@us.ibm.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       muli@il.ibm.com
Subject: Re: [RFC][PATCH] x86 calgary: add fallback dma_ops]]
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1210290111.6114.214.camel@alexis>
References: <1210282820.6114.209.camel@alexis>
	<20080509081322J.tomof@acm.org>
	<1210290111.6114.214.camel@alexis>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080509092313S.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 May 2008 16:41:51 -0700
Alexis Bruemmer <alexisb@us.ibm.com> wrote:

> On Fri, 2008-05-09 at 08:13 +0900, FUJITA Tomonori wrote:
> > On Thu, 08 May 2008 14:40:20 -0700
> > Alexis Bruemmer <alexisb@us.ibm.com> wrote:
> > 
> > > Currently the calgary code can give drivers addresses above 4GB which is
> > > very bad for hardware that is only 32bit DMA addressable.  This patch
> > > "teaches" calgary to fallback to the appropriate dma_ops when it
> > > encounters a device/bus which is not behind the Calgary/CalIOC2.  I
> > > believe there is a better way to do this and am open for ideas, but for
> > > now this certainly fixes the badness.
> > 
> > I'm not sure that I correctly understand what you want. You mean that
> > the Calgary IOMMU code ignores device's dma_mask and gives addresses
> > above 4GB or the Calgary IOMMU code wrongly handles devices that are
> > not behind the Calgary?
> The real issue is the latter-- the Calgary IOMMU code does not properly
> handle devices that are not behind the Calgary/CalIO2.

Thanks, now I see why you use swiotlb for such devices in the case of
end_pfn > MAX_DMA32_PFN and no_dma_ops works for them in the case of
of end_pfn < MAX_DMA32_PFN.

Can we put a pointer to dma_ops in struct device (archdata) like POWER
does? The way to setup and handle x86 IOMMUs seems to become hacky day
by day.
