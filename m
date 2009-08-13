Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbZHMILr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbZHMILr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbZHMILq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:11:46 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:46252 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbZHMILp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:11:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WPATBTaB3V9oHnl6jGBE8cNIQPneDmA8Uixb1WprCF1aLz9PqO4cVwM4aYvdTNQSLf
         ktAg2i2PLrrYTieLx/MWQMhMK+n7idrQRmfH4EaQ5nLwaxRHkhrfIOKDo4+BdAgDYqiJ
         HShqH6ev1g+VNR73hnJlpTqvaSo30HA/OhmFk=
MIME-Version: 1.0
In-Reply-To: <20090813170227V.fujita.tomonori@lab.ntt.co.jp>
References: <3877989d0908130003i295cc7f2q343ad2446d0d51ff@mail.gmail.com>
	 <20090813161407A.fujita.tomonori@lab.ntt.co.jp>
	 <3877989d0908130037j5f9b1594q61e51c544a254b68@mail.gmail.com>
	 <20090813170227V.fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 13 Aug 2009 16:11:46 +0800
Message-ID: <3877989d0908130111m1a7d8625ha84ed1732a7eae81@mail.gmail.com>
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

On Thu, Aug 13, 2009 at 4:03 PM, FUJITA
Tomonori<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Thu, 13 Aug 2009 15:37:54 +0800
> Luming Yu <luming.yu@gmail.com> wrote:
>
>> On Thu, Aug 13, 2009 at 3:14 PM, FUJITA
>> Tomonori<fujita.tomonori@lab.ntt.co.jp> wrote:
>> > On Thu, 13 Aug 2009 15:03:20 +0800
>> > Luming Yu <luming.yu@gmail.com> wrote:
>> >
>> >> Thanks for another workaround, we should be working on deleting wrong
>> >> assumption of"iommu_deteced == iommu working", Not just workaround. My
>> >> patch could break something.. but it is just a start towards right
>> >> goal..
>> >
>> > As I explained, your patch doesn't go toward the right goal.
>>
>> The goal is to decouple dma_ops init and iommu_detect.
>> In that sense, my patch is right.
>
> No, your patch is a workaround too.
>
> If you want swiotlb the default dma_ops for IA64, pci_swiotlb_init()
> is the wrong place for swiotlb_init() because sba needs swiotlb too
> for the same reason. Probably, we should always set platform_dma_init
> to swiotlb_dma_init().
>
>
> You want to fix this problem for 2.6.31? Or you think about 2.6.32 (or
> later)?
>

I treat this as -32 or -33 stuff, because I don't see a real system is blocking
on the problem. I found this problem when I was trying to disable some drhd
for debugging a real iommu issue...that one has priority.
