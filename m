Return-Path: <linux-kernel-owner+w=401wt.eu-S1759123AbZCBCRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123AbZCBCRV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 21:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbZCBCRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 21:17:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:55934 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913AbZCBCRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 21:17:12 -0500
Message-ID: <49AB4171.7000508@kernel.org>
Date: Sun, 01 Mar 2009 18:16:17 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Brian Maly <bmaly@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix e820 end address with EFI
References: <49A965AD.10701@redhat.com>	 <86802c440902282014he17bb6an1f59872ef30db0c5@mail.gmail.com>	 <86802c440902282142p14f623b8td8a88600ff2a6bbe@mail.gmail.com>	 <49AAEC79.3000808@redhat.com>	 <1235956068.6204.143.camel@yhuang-dev.sh.intel.com>	 <49AB38E7.60305@redhat.com> <1235960016.6204.170.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1235960016.6204.170.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> On Mon, 2009-03-02 at 09:39 +0800, Brian Maly wrote:
>> Huang Ying wrote: 
>>> Hi, Brian,
>>>
>>> On Mon, 2009-03-02 at 04:13 +0800, Brian Maly wrote:
>>>   
>>>> I was able verify the kernel that does not boot on the MacBook (vanilla 
>>>> 2.6.29-rc4) does call efi_ioremap() which bails out early returning 
>>>> NULL. So no remapping happens in this case.  I have no idea if 
>>>> efi_ioremap ever does succeed in mapping any ranges though being I have 
>>>> no video or console this early in the boot and have to rely on triple 
>>>> faulting as a means of debugging.
>>>>     
>>> Please attach your dmesg of successful boot, so we can take a look at
>>> the EFI memory map.
>>>
>>> Best Regards,
>>> Huang Ying
>>>   
>> This dmesg is from a 2.6.25 kernel which works fine. I can gather
>> other debugging info from the booting kernels if needed. But its a
>> challenge to debug the bad kernel being efifb is initialized very late
>> (so you never even get to the video initialization and cant see any
>> logged messages) and since its a MacBook I dont have a real serial
>> port for serial console. The efi map is for MacBook has a different
>> layout from other EFI systems I have to test on. 2.6.29 kernel works
>> on every EFI system I have except MacBook.
> 
> It seems that you have an EFI system which has too big runtime area.
> 
> EFI: mem44: type=0, attr=0x8000000000000000, range=[0x000000007ff00000-0x0000000080000000) (1MB)
> 
> efi_ioremap() can map only memory range < 400k now.
> 
> It seems that efi_ioremap is the bottle net now. Can we just use
> init_memory_mapping() instead of efi_ioremap() for EFI runtime area?
> 
> Yinghai, how about your opinion?

you could call init_memory_maping() in that efi_ioremap position?

problems is how about 32bit?

YH
