Return-Path: <linux-kernel-owner+w=401wt.eu-S1751139AbZGFPTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751139AbZGFPTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 11:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbZGFPTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 11:19:47 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:60715 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbZGFPTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 11:19:46 -0400
Message-ID: <4A521612.3030607@petalogix.com>
Date: Mon, 06 Jul 2009 17:19:46 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Paul Mundt <lethal@linux-sh.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       LTP <ltp-list@lists.sourceforge.net>,
       John Williams <john.williams@petalogix.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Grant Likely <grant.likely@secretlab.ca>, subrata@linux.vnet.ibm.com
Subject: Re: mmap syscall problem
References: <4A4DFB77.1080700@petalogix.com> <200907061616.12220.arnd@arndb.de> <4A520DA6.2040107@petalogix.com> <200907061705.50308.arnd@arndb.de>
In-Reply-To: <200907061705.50308.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Monday 06 July 2009, Michal Simek wrote:
>   
>>>       *p1 = 0xaa; *p2 = 0x55;
>>>   
>>>       
>> I closed fd too.
>>     close(fd);
>>     
>>>       return *p1; /* returns 0xaa if broken, 0x55 if correct */
>>> }
>>>       
>
> If you close the fd between the assignment and reading
> from the pointer again, the test case becomes invalid because of
> timing. Closing the fd before the '*p1 = 0xaa' should be fine,
> but unnecessary.
>
> I also realized that you might need to mark the pointers
> as 'volatile' so that the compiler has to do the operations
> in order.
>
>   
The result are the same. I tried to run mmap test which are in LTP and
only first one failed.

Do you have any ideas what buffer could caused that problems?
>>>   
>>>       
>> # ls -la existing-4k-file
>> -rw-rw-r--    1 monstr   monstr       4096 Jul  6  2009 existing-4k-file
>>
>> # ./test-arnd
>> # echo $?
>> 85
>>     
>
> Ok, so inside a single task, this does not happen.
>   
I print output in that task and there is 0x55 too.
>   
>> # dd if=existing-4k-file of=/dev/console count=1 2>/dev/null
>> U#
>>
>> in file is first char U (0x55) which is IMO correct.
>>     
>
> Right, though that was not part of the test, I'd expect this in
> the file even if the return value was broken.
>   
Not in case that mmap is completely broken. This test confirm that mmap
map that fd and is possible to write there.

Thanks,
Michal


> 	Arnd <><
>   


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

