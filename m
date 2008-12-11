Return-Path: <linux-kernel-owner+w=401wt.eu-S1755647AbYLKA6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbYLKA6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 19:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbYLKA6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 19:58:07 -0500
Received: from main.gmane.org ([80.91.229.2]:45806 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840AbYLKA6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 19:58:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] USB: use stack allocation for struct usb_ctrlrequest
Date: Wed, 10 Dec 2008 18:57:47 -0600
Message-ID: <4940658B.9020405@shaw.ca>
References: <20081210073247.GA18630@localhost>	<200812101040.09886.laurent.pinchart@skynet.be>	<20081210124308.GB6772@localhost>	<493FCD12.30000@codefidence.com>	<20081210142301.GA11490@localhost> <20081210170106.d19e568d.zaitcev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: linux-usb@vger.kernel.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <20081210170106.d19e568d.zaitcev@redhat.com>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pete Zaitcev wrote:
> On Wed, 10 Dec 2008 22:23:01 +0800, Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
>> For 64bit systems, we can easily go beyond 4GB physical memory.
>> So at least we should add GFP_DMA32 in addition to GFP_NOIO?
> 
> I am afraid the situation is that we really screwed the pooch while
> creating the USB API. I may be wrong about this, but my understanding
> is that if we get an address above 4GB from kmalloc and then send
> it down to usb_submit_urb(), a random memory corruption is likely
> (this is because we forget to check the result of dma_map_single()).
> 
> The code worked until now because most systems out in the field
> either a) had IOMMU, or b) had 4GB or RAM or less, but not both.
> The case (a) includes all AMD CPUs, all Itanium CPUs, and the
> Intel-based enterprise systems from big vendors, e.g. IBM Calgary,
> HP ZX-1, etc. Also, (a) covers Intel P4 class systems with swiotlb.
> So, we only blow up if a kernel with swiotlb disabled boots on an
> Intel box with more than 4GB of RAM. This is still far from ideal,
> but we kinda pretend not to notice. I heard that Intel has seen
> the error in their ways and is going to come out with IOMMU for
> all their chipsets, so in a few years this is going to be moot.

If you have memory located above 4GB you essentially need either swiotlb 
or one of the other IOMMUs enabled or the system won't work if any of 
your devices have DMA limits. There is no other way that DMA could occur 
to memory above 4GB for those devices.

DMA mapping could still fail if the IOMMU space overflowed, though.

