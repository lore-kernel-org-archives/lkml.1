Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbZCCB32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbZCCB32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 20:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbZCCB3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 20:29:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:46620 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754749AbZCCB3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 20:29:09 -0500
Message-ID: <49AC87AE.60001@kernel.org>
Date: Mon, 02 Mar 2009 17:28:14 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Brian Maly <bmaly@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix e820 end address with EFI
References: <49A965AD.10701@redhat.com>	 <86802c440902282142p14f623b8td8a88600ff2a6bbe@mail.gmail.com>	 <49AAEC79.3000808@redhat.com>	 <1235956068.6204.143.camel@yhuang-dev.sh.intel.com>	 <49AB38E7.60305@redhat.com>	 <1235960016.6204.170.camel@yhuang-dev.sh.intel.com>	 <49AB4171.7000508@kernel.org>	 <1235960708.6204.176.camel@yhuang-dev.sh.intel.com>	 <49AB4521.8010909@kernel.org>	 <1235961428.6204.190.camel@yhuang-dev.sh.intel.com>	 <86802c440903011851t17e240eu9dc25116a40ca85e@mail.gmail.com>	 <1235979959.6204.212.camel@yhuang-dev.sh.intel.com>	 <49AC51D7.1080203@kernel.org> <1236042459.6204.226.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1236042459.6204.226.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> On Tue, 2009-03-03 at 05:38 +0800, Yinghai Lu wrote:
>> Huang Ying wrote:
>>> On Mon, 2009-03-02 at 10:51 +0800, Yinghai Lu wrote:
>>>> On Sun, Mar 1, 2009 at 6:37 PM, Huang Ying <ying.huang@intel.com> wrote:
>>>>>> so 64bit could use ioremap_cache() too?
>>>>>> we may keep 32bit and 64bit a bit consistent.
>>>>> If we use ioremap_cache(), kexec runtime service will not work in kexec
>>>>> situation, which needs EFI runtime memory area to be mapped at exact
>>>>> same location across kexec. I think we should support kexec if possible.
>>>> sure.
>>>>
>>>> please don't touch max_low_pfn_mapped, because some range may not
>>>> directly mapped under those efi run-time code
>>> Find an issue to use init_memory_mapping() here.
>>>
>>> If the memory range to be mapped is less than 2M, the last mapped
>>> address may be next 2M aligned position, this may lead mapping
>>> overlapping between memory range. Such as:
>>>
>>> 0x3f388000 - 0x3f488000: real mapped	0x3f388000 - 0x3f600000
>>> 0x3f590000 - 0x3f5bb000: real mapped	0x3f590000 - 0x3f600000
>>>
>>> The problem is that the memory range 0x3f400000 - 0x3f590000 is left not
>>> mapped!
>> what is max_low_pfn_mapped before that?
> 
> I don't know exactly what you mean. Can you elaborate a little?
> 
> 0 ~ max_low_pfn_mapped ~ max_pfn_mapped can be mapped with
> init_memory_mapping() properly.
> 
> The issue of above example is that 0x3f400000 ~ 0x3f488000 is a
> sub-range of 0x3f388000 ~ 0x3f488000, which should be mapped but is left
> not mapped.
what is max_low_pfn_mapped?

what is init_memory_mapping() printout?

YH
