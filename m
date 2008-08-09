Return-Path: <linux-kernel-owner+w=401wt.eu-S1758212AbYHIBnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbYHIBnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 21:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYHIBni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 21:43:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbYHIBnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 21:43:37 -0400
Message-ID: <489CF599.8050601@redhat.com>
Date: Fri, 08 Aug 2008 21:40:41 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: jbarnes@virtuousgeek.org, muli@il.ibm.com, joro@8bytes.org,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jakub@redhat.com
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
References: <20080808071244.GB6931@il.ibm.com>	<489C63D1.1000407@redhat.com>	<200808080915.52459.jbarnes@virtuousgeek.org> <20080809061348V.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080809061348V.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



FUJITA Tomonori wrote:
> On Fri, 8 Aug 2008 09:15:51 -0700
> Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>
>   
>> On Friday, August 8, 2008 8:18 am Prarit Bhargava wrote:
>>     
>>> --- a/include/linux/dma-mapping.h
>>> +++ b/include/linux/dma-mapping.h
>>> @@ -78,7 +78,7 @@ static inline unsigned int dma_set_max_seg_size(struct
>>> device
>>>  static inline unsigned long dma_get_seg_boundary(struct device *dev)
>>>  {
>>>         return dev->dma_parms ?
>>> -               dev->dma_parms->segment_boundary_mask : 0xffffffff;
>>> +               dev->dma_parms->segment_boundary_mask : 0xffffffffUL;
>>>  }
>>>       
>> Yeah generally you need to cast values like this when working with real 
>> unsigned long values rather than ints, but this *should* still be safe 
>> (barring a compiler bug).  The return type is unsigned long, so even if you 
>> just return 0xffffffff the right thing should still happen...
>>     
>
> I told Prarid that the overflow should not happen here again and
> again...
>   

I misunderstood what was going on here.

P.
