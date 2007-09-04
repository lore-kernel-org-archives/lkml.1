Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbXIDKXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbXIDKXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 06:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbXIDKW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 06:22:59 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:34987 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbXIDKW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 06:22:58 -0400
Message-ID: <46DD30CC.4060907@aitel.hist.no>
Date: Tue, 04 Sep 2007 12:17:48 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Clemens Kolbitsch <clemens.kol@gmx.at>
CC: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Subject: Re: Forbid deletion of memory mappings
References: <200708301844.10532.clemens.kol@gmx.at> <200708302341.09459.clemens.kol@gmx.at> <30071.1188510621@turing-police.cc.vt.edu> <200708310005.53587.clemens.kol@gmx.at>
In-Reply-To: <200708310005.53587.clemens.kol@gmx.at>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Clemens Kolbitsch wrote:
> On Thursday 30 August 2007 23:50:21 Valdis.Kletnieks@vt.edu wrote:
>   
>> On Thu, 30 Aug 2007 23:41:09 +0200, Clemens Kolbitsch said:
>>     
>>> On Thursday 30 August 2007 23:34:52 you wrote:
>>>       
>>>> On Thu, 30 Aug 2007, Clemens Kolbitsch wrote:
>>>>         
>>>>> is there no way to tell the kernel, that a certain mapping must not
>>>>> be removed, no matter what (except of course an explicit call to
>>>>> sys_unmap, of course)?
>>>>>           
>>>> I don't seem to get what is the issue here. Your mapping is not
>>>> removed, only the VMAs are merged together into one larger VMA if they
>>>> have neighbouring address ranges and compatible protection bits. See
>>>> vma_merge().
>>>>         
>>> the thing is that they are not. the kernel chooses to REPLACE my mapping.
>>>
>>> consider the user-space code:
>>>
>>> mmap(0xaaaa0000, 0x3000, MAP_FIXED, ...);
>>> mmap(0xaaaa1000, 0x4000, MAP_FIXED, ...);
>>>
>>> here, the second call to mmap will shorten the first mapping to 0x1000
>>> bytes and create one big vma with size 0x5000 bytes.
>>>
>>> is there a way to tell it that the second mmap MUST fail?
>>>       
>> There's an LSM exit point for mmap, you could perhaps do something there.
>>
>> What are you trying to achieve by forcing the second one to fail?
>>     
>
> puh... that is a good question :-)
>
> I'm writing my master's thesis on a new model of memory protection and need to 
> have every memory mapping in userspace duplicated. I also have kind of a 
> second PGD/PTD that allows finding this mirrored mapping.
>
> However, as the number of original mappings grows, I suddenly have the problem 
> that the kernel tries to allocate a new mapping and picks the address of a 
> mirrored memory page, which it shouldn't.
>
> Honestly, I don't understand why it does so, 
The "why" is easy: Having many mappings is expensive,
so merging them (when this cause no problems) is
a smart thing to do. So that is what linux does.
It means fewer mappings to keep track of. Less resources in
use means that linux moves faster.

If you are doing research, consider these methods:
1. Change vma_merge() so it always fail to merge mappings

or

2. Set up your "mappings duplicated in userspace" so
    they too merge in the same way.

Helge Hafting
