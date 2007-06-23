Return-Path: <linux-kernel-owner+w=401wt.eu-S1757507AbXFWLB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbXFWLB0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 07:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756480AbXFWK7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 06:59:38 -0400
Received: from ns2.suse.de ([195.135.220.15]:48218 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756235AbXFWK7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 06:59:36 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: [PATCH] x86-64: disable the GART in shutdown
Date: Sat, 23 Jun 2007 12:59:17 +0200
User-Agent: KMail/1.9.6
Cc: Yinghai Lu <Yinghai.Lu@sun.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200706221219.16243.yinghai.lu@sun.com> <200706221934.59966.yinghai.lu@sun.com> <20070623103947.GA4441@rhun.cust.hotspot.t-mobile.com>
In-Reply-To: <20070623103947.GA4441@rhun.cust.hotspot.t-mobile.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706231259.17946.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I'm going to need exactly the same hook fro Calgary, as well Intel for
> VT-d, and AMD for their upcoming IOMMU, etc. How about we do
> 
> struct iommu_ops {
>   struct dma_ops {
>     ...
>   }
>   void (*shutdown)(void);
> }
> 
> And then pci_iommu_shutdown() becomes
> 
> if (iommu_ops->shutdown)
>   iommu_ops->shutdown();

I think it's cleaner if everybody registers their own shutdown handler in sysfs
Don't see any value in going through a generic layer because there is no
shared code.

-Andi


