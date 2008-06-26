Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbYFZHOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbYFZHOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 03:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbYFZHNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 03:13:51 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:35209 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbYFZHNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 03:13:49 -0400
Date: Thu, 26 Jun 2008 10:11:41 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Tim Schmielau <T.Schmielau@shu.ac.uk>
Cc: David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Engelhardt <jengelh@computergmbh.de>, geert@linux-m68k.org,
       zippel@linux-m68k.org
Subject: Re: [PATCH] Speed up "make headers_*"
Message-ID: <20080626071141.GN10285@cs181140183.pp.htv.fi>
References: <5DC8DBC2-AA22-448B-8646-06D5788C00FE@shu.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5DC8DBC2-AA22-448B-8646-06D5788C00FE@shu.ac.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 02:59:21AM +0100, Tim Schmielau wrote:
> [apologies for the late reply, I do not follow lkml anymore]
>
> On Sun, 2008-06-08 at 14:17 +0100, David Woodhouse wrote:
>> On Sun, 2008-06-08 at 13:17 +0200, Sam Ravnborg wrote:
>> > #if !defined(CONFIG_M68K) || !defined(__KERNEL__)
>>
>> That's just scary, and broken for m68k where in userspace neither
>> CONFIG_M68K nor __KERNEL__ will be defined, so the unwanted ac_ahz
>> member will actually show up and break the binary compatibility.
>> Assuming we _don't_ want the ac_ahz member to be included on m68k,  
>> this
>> should fix it (is __mc68000__ the right thing to use?)...
>>
>> diff --git a/include/linux/acct.h b/include/linux/acct.h
>> index e8cae54..228473b 100644
>> --- a/include/linux/acct.h
>> +++ b/include/linux/acct.h
>> @@ -58,8 +58,7 @@ struct acct
>>         comp_t          ac_minflt;              /* Minor Pagefaults */
>>         comp_t          ac_majflt;              /* Major Pagefaults */
>>         comp_t          ac_swaps;               /* Number of Swaps */
>> -/* m68k had no padding here. */
>> -#if !defined(CONFIG_M68K) || !defined(__KERNEL__)
>> +#ifndef __mc68000__ /* m68k had no padding here. */
>>         __u16           ac_ahz;                 /* AHZ */
>>  #endif
>>         __u32           ac_exitcode;            /* Exitcode */

struct acct as provided by the kernel anyway differs from the one 
shipped by glibc in /usr/include/sys/acct.h since your
"BSD accounting format rework" patch back in 2004.

Does the pre-v3 stuff actually work?
My first impression is that it doesn't and should therefore be removed.

> This would make cross-compiled m68k kernels silently write wrong
> accounting files.
>...

Cross-compiling can't make any difference here.

> Tim

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

