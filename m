Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab0CLKhj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 05:37:39 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:43771 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100Ab0CLKhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 05:37:38 -0500
Message-ID: <4B9A196E.1040501@monstr.eu>
Date: Fri, 12 Mar 2010 11:37:34 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Michal Simek <monstr@monstr.eu>, linux-kernel@vger.kernel.org,
       microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH] microblaze: Fix Makefile to delete build generated files
References: <1268383016-18270-1-git-send-email-arun@bhanu.net> <4B9A010C.2010501@monstr.eu> <20100312102040.GA7371@icd1rh0718.eee.ntu.edu.sg>
In-Reply-To: <20100312102040.GA7371@icd1rh0718.eee.ntu.edu.sg>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arun Bhanu wrote:
> * Michal Simek (monstr@monstr.eu) wrote:
>> Arun Bhanu wrote:
>>> 'make mrproper' does not to delete the following build generated files:
>>>        arch/microblaze/boot/linux.bin.ub
>>>        arch/microblaze/boot/simpleImage.system
>>>        arch/microblaze/boot/simpleImage.system.ub
>>>
>>> Fix the Makefile to delete these build generated files.
>> The problem is that if you run make clean it will delete all simpleImage  
>> files too. The best will be just delete them if you run make mrproper as  
>> you wrote above. Make clean should keep them or just remove .unstrip  
>> because of size.
>>
>> Michal
> 
> I thought 'make clean' was supposed to remove simpleImage.* files.
> PowerPC (see arch/powerpc/boot/Makefile) seems to be deleting
> simpleImage.* upon 'make clean' invocation.

It can be truth but this is Microblaze.

> 
> 'make help' says:
>   clean           - Remove most generated files but keep the config and
>                     enough build support to build external modules
> 
> Are the simpleImage.* files needed to build external modules? If not,
> can you explain why we should keep simpleImage.* file after a 'make
> clean' run?

nice is that there is written most files.

> 
> What am I missing?

The reason is that I am configuring several platforms with different DTS 
files and I am retesting that generated files. That's why I need to have 
simpleImage.xxx and simpleImage.xxx.ub in boot folder which have 
different names. I am doing several clean-ups but I need to store that 
files.

mrproper        - Remove all generated files + config + various backup files

If you look at help for mrproper we can call that files like backup files.


I agree with you that will be good to remove them but only for make 
mrproper as was written in your commit message.

Michal


> 
>>
>>> Signed-off-by: Arun Bhanu <arun@bhanu.net>
>>> ---
>>>  arch/microblaze/boot/Makefile |    4 ++--
>>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/microblaze/boot/Makefile b/arch/microblaze/boot/Makefile
>>> index 902cf98..73a3263 100644
>>> --- a/arch/microblaze/boot/Makefile
>>> +++ b/arch/microblaze/boot/Makefile
>>> @@ -62,6 +62,6 @@ quiet_cmd_dtc = DTC     $@
>>>  $(obj)/%.dtb: $(dtstree)/%.dts FORCE
>>>  	$(call if_changed,dtc)
>>>  -clean-kernel += linux.bin linux.bin.gz simpleImage.*
>>> +clean-kernel += linux.bin linux.bin.gz
>>>  -clean-files += *.dtb simpleImage.*.unstrip
>>> +clean-files += *.dtb *.ub simpleImage.*
>>
>> -- 
>> Michal Simek, Ing. (M.Eng)
>> w: www.monstr.eu p: +42-0-721842854
>> Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
>> Microblaze U-BOOT custodian
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 
> -Arun


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
