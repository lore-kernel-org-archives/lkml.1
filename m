Return-Path: <linux-kernel-owner+w=401wt.eu-S1759088AbYGPV6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759088AbYGPV6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 17:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbYGPV54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 17:57:56 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:58171 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbYGPV5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 17:57:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ILJewGwoezupbKaxAJ5wJ2TR/KU+llqQ8d0+NDzYNo1mi6Li7YA0wDd5jkWBN6irvZ
         /TbsdmvTEUVBm4QRcFFdLkNeoA8q0N4QOBwvMwYrtBwMH3vaUKUOfqHUmT8lQzMUoSfW
         hLfrvfmjUYKaExEU4Z62dj4B+gLMkwWqtqIso=
Message-ID: <487E6EDF.7050905@gmail.com>
Date: Wed, 16 Jul 2008 23:57:51 +0200
From: =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: Takashi Iwai <tiwai@suse.de>,
       =?UTF-8?B?VMO2csO2ayBFZHdpbg==?= <edwintorok@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: today's linux-next fails to boot
References: <4877400B.1000400@gmail.com>  <s5hy747rvpr.wl%tiwai@suse.de> <1216242664.3218.14.camel@dhcppc2>
In-Reply-To: <1216242664.3218.14.camel@dhcppc2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer a écrit :
> Am Samstag, den 12.07.2008, 17:03 +0200 schrieb Takashi Iwai:
>   
>> At Fri, 11 Jul 2008 14:12:11 +0300,
>> Török Edwin wrote:
>>     
>>> Today's linux-next tree (commit
>>> 93847083e4791567931bd17c039cc35881cdad29) fails to boot:
>>> [built with gcc-4.2.4-3]
>>>
>>> BUG: Int 14: CR2 b0049dea
>>>      EDI 00000082 ESI 00000000 EBP c059be88 ESP c059be5c
>>>      EBX f000ec62 EDX 0000000e ECX c0595480 EAX f000ec62
>>>      err 00000000 EIP c0181ca0  CS 00000060 flg 00010082
>>> Stack:   00000040 c06a2ba0 000080d0 c0595480 c0000f19c c000f180 c0581120
>>> c059bea8
>>>          c02bf19b 00000000 00000080 c059beb8 c0000f194 c000f180 0000000a
>>> c059beb8
>>>          c03a1059 00000000 00000000 c059bed8 c05c4c7c  0009efff 00000000
>>> c04f4df4
>>>
>>> I get this as soon as I boot from grub2, strangely the error message is
>>> at the bottom of the screen, and I can't see the full message (scrolling
>>> won't work).
>>>
>>> The last kernel I built & booted was 2.6.26-rc8 from Linus's tree. I
>>> will try to built&boot 2.6.26-rc9, and then bisect.
>>>
>>> This happens on 32-bit Dell Inspiron 6400 (Intel Core Duo T2300 @1.66
>>> Ghz CPU),  Intel ICH-7 chipset, and a seagate SATA drive. 
>>> I will provide  full hardware details once I bisected the problem.
>>>
>>> Meanwhile, if somebody has an idea as to what is wrong?
>>>       
>> [Added Ingo to Cc]
>>
>> I get the boot problem on i386 with 2008-07-11 linux-next tree, too.
>> In my case, no error appears on the screen, just staying blank and
>> dead.  It seems stopping at the very beginning, soon after GRUB, so
>> could be the same reason.
>>
>> The same config worked fine with yesterday's tree (2008-07-10) on the
>> same machine. 
>> Also, today's tree works on x86-64 (but on another machine).
>>
>>     
>
> I have got the same problem as Edwin TÖRÖK: From next-20080710 to next-20080711 the kernel fails to boot.
> EIP seems to be in function kmem_cache_alloc.
>
> This is also true for next-20080716.
> I didn't try the kernels > next-20080711 and < next-20080716.
>
> Any news on this bug?
>   
Yes a fix has been released:
http://article.gmane.org/gmane.linux.kernel.kexec/1882

But I don't know when it will be applied....
