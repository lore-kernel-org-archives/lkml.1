Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbXE0NIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbXE0NIJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 09:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbXE0NH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 09:07:56 -0400
Received: from mail.tmr.com ([64.65.253.246]:48277 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbXE0NHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 09:07:55 -0400
Message-ID: <4659834E.4070506@tmr.com>
Date: Sun, 27 May 2007 09:10:38 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: David Greaves <david@dgreaves.com>
CC: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.21.1] resume doesn't run suspended kernel?
References: <4658B7DD.3060309@tmr.com> <4659442E.2060307@dgreaves.com>
In-Reply-To: <4659442E.2060307@dgreaves.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Greaves wrote:
> Bill Davidsen wrote:
>> Anyway, I pulled the plug on the UPS, and the system shut down. But when
>> it powered up, it booted the default kernel rather than the test kernel,
>> decided that it couldn't resume, and then did a cold boot.
> 
> Booting the machine isn't the kernel's job, it's the bootloader's job.
> 
And resume is not the the bootloader's job... if memory and registers 
are restored, and a jump is made to the resume address, a resumed system 
should result. clearly some part of that didn't happen :-(

>> I can bypass this by making the debug kernel the default, but WHY? Is
>> the kernel not saved such that any kernel can be rolled back into memory
>> and run? Actually, the answer is HELL NO, so I really ask if this is the
>> intended mode of operation, that only the default boot kernel will restore.
> 
> Yes.
> 
> It is very dangerous to attempt a resume with a different kernel than the one
> that has gone to sleep.
> Different kernels may be compiled with different options that affect where or
> how in-memory structures are saved.
> 
If the mainline resume is depending on that no wonder resume is so 
fragile. User action can change order of module loads, kmalloc calls 
move allocated structures, etc. Counting on anything to be locked in 
place seems naive.

> So you suspend with a kernel which holds your filesystem data/cache/inodes at
> 0x1234000 and restore with a kernel that expects to see your filesystem data at
> 0x1235000.
> 
> Ouch.
> 
I would hope that the data used by the resumed kernel would be the same 
data that was suspended, not something from another kernel.

> Personally I think the kernel suspend should write a signature - similar to a
> hash of the bzImage - into the suspend image so it won't even attempt a resume
> if there's a mismatch. (Yes, I made this mistake once whilst playing with suspend).
> 
Someone else dropped a note saying the FC kernels use suspend2, and work 
fine. I'm off to look at the FC source and see if that's the case. That 
would explain why suspend works and resume doesn't, hopefully there's a 
2.6.21 suspend2 patch in that case.

Thanks for the feedback in any case.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
