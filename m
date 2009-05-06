Return-Path: <linux-kernel-owner+w=401wt.eu-S1758817AbZEFKmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817AbZEFKmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 06:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbZEFKmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 06:42:44 -0400
Received: from [192.16.179.4] ([192.16.179.4]:59646 "EHLO sh.osrg.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752981AbZEFKmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 06:42:44 -0400
Date: Wed, 6 May 2009 19:39:29 +0900
To: optimusgd@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, grundler@google.com
Subject: Re: [Bug #13001] PCI-DMA: Out of IOMMU space
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <db2b43030905032227u73a41ec3wa511efcef6a22169@mail.gmail.com>
References: <db2b43030904280218v61fded68rc585ce9c58ba1cce@mail.gmail.com>
	<20090428184431Z.fujita.tomonori@lab.ntt.co.jp>
	<db2b43030905032227u73a41ec3wa511efcef6a22169@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090506194012M.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 06 May 2009 19:39:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 May 2009 10:27:11 +0500
**UNKNOWN CHARSET** <optimusgd@gmail.com> wrote:

> 2009/4/28 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>:
> > On Tue, 28 Apr 2009 14:18:57 +0500
> > **UNKNOWN CHARSET** <optimusgd@gmail.com> wrote:
> >
> >> No, it is regression. I can reproduce that without allowdac and any
> >> other unnecessary boot options.
> >
> > Hmm, in the bug repport, you said that you can't reproduce the problem:
> >
> > http://bugzilla.kernel.org/show_bug.cgi?id=13001#c15
> >
> > I can't find your comment like, "I can reproduce that without
> > allowdac".
> 
> I was under a misapprehension. Later discussion was been in linux-pci
> mailing list
> http://markmail.org/message/pbng73ojpllln5fl

You didn't CC to me so it was impossible for me to track this bug.


> >> In later discussion Grant Grundler ask
> >> me apply patch that show 32 bit dma devices in my system. Results I
> >> attached to bugreport. Looks like only one 32 bit dma device in my
> >> system is ata controller, sata-nv.
> >
> > Hmm, looks like http://bugzilla.kernel.org/attachment.cgi?id=20895
> > said that pata_amd and sata_nv use 32bit dma mask.
> >
> >
> >> I can stable reproduce IOMMU out of space when I write data to sata
> >> drive.
> >
> > Ok, let's figure out what's wrong.
> >
> > First, can you test v2.6.30-rc3 with the following patch?
> >
> > http://www.kernel.org/pub/linux/kernel/people/tomo/misc/gart-debug.diff
> >
> >
> > Note that please enable CONFIG_DMA_API_DEBUG, CONFIG_IOMMU_DEBUG, and
> > CONFIG_IOMMU_LEAK and see if you can reproduce the problem (of course,
> > don't use any kernel option).
> >
> > When the kernel is out of IOMMU space, it prints some useful
> > information.
> >
> 
> I can't reproduce bug in 2.6.30-rc3. I read and wrote ~ 100gb data
> from and to sata drive. Dmesg has two warnings during boot,

Thanks, then let's debug 2.6.29.2.

http://www.kernel.org/pub/linux/kernel/people/tomo/misc/gart-debug-2.6.29.diff

As you did with 2.6.30-rc3, enable CONFIG_DMA_API_DEBUG,
CONFIG_IOMMU_DEBUG, and CONFIG_IOMMU_LEAK and don't use any kernel
boot option.
