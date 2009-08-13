Return-Path: <linux-kernel-owner+w=401wt.eu-S1752172AbZHMGCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbZHMGCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 02:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbZHMGCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 02:02:11 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:35914 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbZHMGCK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 02:02:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=h4ELpL+hMKJfqkGw5fRb+DacZREu7snWgm5tDUXP1WyfYN7Xlk/upJpWqv/GXaxX6u
         d5tNlcDm8QclwZjQTtI8qkuExniGq3SjwP/5dlCVaLRG6F7Jm05dEoK7j+zEzYCAkeve
         tLOzcThaqTaQKhNOm89p76JMv5cImGv6idxVc=
MIME-Version: 1.0
In-Reply-To: <20090813122456P.fujita.tomonori@lab.ntt.co.jp>
References: <3877989d0908122011n27589ff8wfc6d6b50912496c6@mail.gmail.com>
	 <20090813122456P.fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 13 Aug 2009 14:02:11 +0800
Message-ID: <3877989d0908122302x3bfc767agbca663ddbc7b40b5@mail.gmail.com>
Subject: Re: [RFC patch] clean up swiotlb check in intel_iommu_init
From: Luming Yu <luming.yu@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dwmw2@infradead.org, fenghua.yu@intel.com, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> Since swiotlb is an fall back option that might have
>> initialized. We don't need to stop intel_iommu_init
>> because of swiotlb..
>
> I think that this doesn't work on X86; breaks "soft" boot option.

Assumption is that swiotlb is default dma_ops.
I got this patch when working on ia64, will check x86 later.
But it is only needed when most of us agree that swiotlb should be
the default.

>
>
>> Please review. If make sense, please apply.
>>
>> **The patch is enclosed in text attachment*
>> **Using web client to send the patch* *
>> **below is for review, please apply attached  patch*/
>>
>> Thanks,
>> Luming
>>
>> Signed-off-by: Yu Luming <luming.yu@intel.com>
>>
>>  intel-iommu.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>>
>> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
>> index 2314ad7..246acb9 100644
>> --- a/drivers/pci/intel-iommu.c
>> +++ b/drivers/pci/intel-iommu.c
>> @@ -3194,7 +3194,7 @@ int __init intel_iommu_init(void)
>>        * Check the need for DMA-remapping initialization now.
>>        * Above initialization will also be used by Interrupt-remapping.
>>        */
>> -     if (no_iommu || (swiotlb && !iommu_pass_through) || dmar_disabled)
>> +     if (no_iommu || dmar_disabled)
>>               return -ENODEV;
>>
>>       iommu_init_mempool();
>
