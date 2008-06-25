Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbYFYXPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbYFYXPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 19:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbYFYXOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 19:14:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:23368 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630AbYFYXOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 19:14:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lA30yIuDkNqZ+g54k7uGofaY1R3TsOWuoCubEDxUVw6fmEBd76V9PLXW//+l4jmfQX
         he8YK0Uv8aYKQ2XuhcZGg2/3SwfZDVADJJPmAQAWsNijEVbG3eO20WMvn5u5W/SNi1C0
         8XVXDUrL1W9X5tgIufbkfUbFGQN2l43pqFKQA=
Message-ID: <86802c440806251614t68ec7bf9o8f39b8c31b245977@mail.gmail.com>
Date: Wed, 25 Jun 2008 16:14:54 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH] x86: remove end_pfn in 64bit
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4862C4DA.9060004@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806242213.15310.yhlu.kernel@gmail.com>
	 <200806242214.09503.yhlu.kernel@gmail.com>
	 <20080625154138.GC18796@elte.hu> <4862B915.3010001@goop.org>
	 <86802c440806251457y134de928rb496da66becbe5cd@mail.gmail.com>
	 <4862C4DA.9060004@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 3:21 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Yinghai Lu wrote:
>>
>> On Wed, Jun 25, 2008 at 2:31 PM, Jeremy Fitzhardinge <jeremy@goop.org>
>> wrote:
>>
>>>
>>> Ingo Molnar wrote:
>>>
>>>>
>>>> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>>>
>>>>
>>>>
>>>>>
>>>>> and use max_pfn directly.
>>>>>
>>>>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>>>>
>>>>>
>>>>
>>>> applied to tip/x86/setup-memory - thanks Yinghai. I have picked up these
>>>> patches:
>>>>
>>>> Ingo Molnar (1):
>>>>     Merge branch 'x86/setup-memory'
>>>>
>>>> Yinghai Lu (6):
>>>>     x86: fix e820_update_range size when overlapping
>>>>     x86: get max_pfn_mapped in init_memory_mapping
>>>>     x86: add table_top check for alloc_low_page in 64 bit
>>>>     x86: change size if e820_update/remove_range
>>>>     x86: numa 32 using apicid_2_node to get node for logical_apicid
>>>>     x86: remove end_pfn in 64bit
>>>>
>>>>
>>>
>>> Did you CC: this to me to indicate that "x86_64: replace end_pfn with
>>> num_physpages" conflicts massively with this patch?  Fortunately I don't
>>> depend on it, so I don't mind much.
>>>
>>> How does "max_pfn" differ from "num_physpages"?  Should one of them go as
>>> well?
>>>
>>
>> 64bit setup_arch assign num_physpages with end_pfn...
>>
>
> I posted a patch to remove end_pfn and replace it with num_physpages
> everywhere, which obviously clashed badly with your patch ;)

32bit has max_pfn, max_low_pfn, max_pfn_mapped...and min_low_pfn.

>
>> and max_pfn is defined in linux/bootmem.h
>> num_physpages  is defined in linux/mm.h
>
> Do they contain separate values?  Do they mean different things?

x86 64 bit that they are same. num_phypages = max_pfn
32 bit when HIGHMEM=y, it is same.num_phypages = max_pfn
         when HIGHMEM=n, num_phypages = max_low_pfn

YH
