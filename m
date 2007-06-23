Return-Path: <linux-kernel-owner+w=401wt.eu-S1755633AbXFWKYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633AbXFWKYP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 06:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbXFWKYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 06:24:00 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:19620 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbXFWKX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 06:23:59 -0400
Date: Fri, 22 Jun 2007 17:35:30 -0700
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andi Kleen <ak@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86-64: disable the GART before allocate aperture
Message-ID: <20070623003530.GA4505@rhun.smartcity.com>
References: <200706221219.16243.yinghai.lu@sun.com> <m18xabbrp6.fsf@ebiederm.dsl.xmission.com> <20070622231951.4d516215@the-village.bc.nu> <200706230214.02535.ak@suse.de> <467C6906.6020105@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467C6906.6020105@sun.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 05:27:50PM -0700, Yinghai Lu wrote:
> Andi Kleen wrote:
> >On Saturday 23 June 2007 00:19:51 Alan Cox wrote:
> >The kdump kernel should be normally all <4GB anyways. You won't
> >need any IOMMU for its IO unless you O_DIRECT/sendfile out of /proc/kcore.
> >Just don't do that (but I suspect it won't work anyways)
> >
> >If it's not then swiotlb will also not work because it won't get 
> >any memory <4GB.
> >
> >But I doubt this was YH's problem - the panic kernel memory
> >is always reserved and there shouldn't be any ongoing DMAs in this
> >area anyways. And what happens outside the kdump kernel shouldn't matter.
> >
> >I suspect he rather saw problems with non kdump kexec where we
> >can just shut down the GART properly beforehand.
> 
> current I only test kexec only. So clean shut GART in first kernel will 
> help.
> 
> where is hook for shutdown? add one in dma_ops?

I was wondering the same thing. I think it should hook into the
standard device model. It definitely should *not* be in the dma_ops
(it has nothing to do with DMA...) - if needed for this or something
else we should add a struct iommu_ops which includes a dma_ops member.

Cheers,
Muli
