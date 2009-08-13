Return-Path: <linux-kernel-owner+w=401wt.eu-S1752388AbZHMFsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbZHMFsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 01:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbZHMFsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 01:48:45 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:33953 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbZHMFso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 01:48:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZKcnU83XSc6RUE2TqZ+xVOm4ciMicvIepIGdFxGpfo0W/llBqMtqPYylABEG8+cE2T
         rP88/f6nru2F+c5hNO6hGftPffQWtnAgxSlLOKfPkqdmNhFGeow2cL/XRDW6uJI0G3YH
         DHbRJ8eemi4lFyQ4+D0uKmy8lXAKyeL8CnY8Q=
MIME-Version: 1.0
In-Reply-To: <20090813132845R.fujita.tomonori@lab.ntt.co.jp>
References: <3877989d0908120220q5104d2e7rd272ececbc45e377@mail.gmail.com>
	 <20090812181722.GA32653@linux-os.sc.intel.com>
	 <20090813132845R.fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 13 Aug 2009 13:48:45 +0800
Message-ID: <3877989d0908122248s4212ef95w7606a4dca5c7a855@mail.gmail.com>
Subject: Re: [RFC patch] init default dma_ops to prepare intel_iommu_init 
	failure
From: Luming Yu <luming.yu@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: fenghua.yu@intel.com, dwmw2@infradead.org, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> This check can not be removed. Otherwise, swiotlb_dma_ops will always override
>> previous dma_ops value.
>
> Yeah.

I think pci_swiotlb_init needs to be cleaned up for both x86_{32,64} and ia64.
it should be used to init default dma_ops, and the call site of it should be
as early as platform_dma_init in mem_init. SInce swiotlb_dma_ops is pitched as
default dma_ops for x86, ia64, we really don't need to let pci_swiotlb_init
know iommu_deteced, dmar_disabled or iommu_passthrough...and anything
like that..
Please note the major wrong assumption of the current implementation is
"iommu_deteced == iommu working" that I was trying to fix.
