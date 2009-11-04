Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbZKDEvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbZKDEvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 23:51:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbZKDEvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 23:51:31 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:59061 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbZKDEvb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 23:51:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=eCHo3OzHpTb0BS90gtNH1sA0byZRib+U4XD5tY64G0ZNvhc8wk9wsZfiO7EX4VHN8M
         JqXLmROejqRplOBZAYnbDystjI76sYGiIWC1qcIvN3V0i8zO9BlPlXt3PCCKJNf8HZqL
         bvgoD1nLsnBEQEJuB40NcTEOqNra5KCzN3698=
MIME-Version: 1.0
In-Reply-To: <20091103155734.b5ee1fed.akpm@linux-foundation.org>
References: <1256182910.2842.36.camel@2710p.home>
	 <1256192928.2990.10.camel@macbook.infradead.org>
	 <1256214241.2842.50.camel@2710p.home>
	 <1256222867.2990.47.camel@macbook.infradead.org>
	 <1256223676.3615.68.camel@8530w.home>
	 <1256226541.2990.87.camel@macbook.infradead.org>
	 <20091103155734.b5ee1fed.akpm@linux-foundation.org>
Date: Tue, 3 Nov 2009 21:51:35 -0700
X-Google-Sender-Auth: ff801d3e6bc4a03c
Message-ID: <7162ab20911032051p497b8525k73d2e2a80462fcb3@mail.gmail.com>
Subject: Re: [PATCH] intel-iommu: Fix alloc_coherent for pass-through devices
From: Alex Williamson <alex.williamson@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       "Miller, Mike (OS Dev)" <mike.miller@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, iommu@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 3, 2009 at 4:57 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 23 Oct 2009 00:49:01 +0900
> David Woodhouse <dwmw2@infradead.org> wrote:
>> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
>> index b1e97e6..773a662 100644
>> --- a/drivers/pci/intel-iommu.c
>> +++ b/drivers/pci/intel-iommu.c
>> @@ -2765,6 +2765,10 @@ static void *intel_alloc_coherent(struct device *hwdev, size_t size,
>>       void *vaddr;
>>       int order;
>>
>> +     if (iommu_no_mapping(hwdev))
>> +             return dma_generic_alloc_coherent(hwdev, size, dma_handle,
>> +                                               flags);
>> +
>>       size = PAGE_ALIGN(size);
>>       order = get_order(size);
>>       flags &= ~(GFP_DMA | GFP_DMA32);
>>
>> (That won't build on IA64)
>>
>
> This is a box-killing post-2.6.31 regression, yes?
>
> Alex appears to have disappeared on us, making it rather hard to fix
> this up promptly.

Nope, I'm still here.  David and I chatted about some of the issues
and I sent out a series of patches last week to address them.  See
this thread:

https://lists.linux-foundation.org/pipermail/iommu/2009-October/001851.html

The first patch, attempting to implement the above was a non-starter
and dropped.  I believe the other patches in the series are valid and
I'd certainly like to see at least the alloc_coherent part fixed for
.32.  I'll be happy to send out a revised set if there's any confusion
of where things stand.  Thanks,

Alex
