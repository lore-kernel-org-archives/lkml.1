Return-Path: <linux-kernel-owner+w=401wt.eu-S1765451AbYEBBU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765451AbYEBBU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 21:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757046AbYEBBUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 21:20:22 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:44551 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376AbYEBBUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 21:20:21 -0400
Message-ID: <481A6BEE.5020705@googlemail.com>
Date: Fri, 02 May 2008 03:18:38 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Mika Fischer <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete
 - auto detect
References: <200804272337.40130.yhlu.kernel@gmail.com>	 <200804290352.33543.yhlu.kernel@gmail.com>	 <200804292025.58268.yhlu.kernel@gmail.com>	 <200805010100.34751.yhlu.kernel@gmail.com>	 <4819AD44.4040200@googlemail.com>	 <86802c440805011706m51f4840dye0191c7e853d5aa@mail.gmail.com>	 <481A6080.8090307@googlemail.com> <86802c440805011735u147860eatd259b3db2fcb93f3@mail.gmail.com>
In-Reply-To: <86802c440805011735u147860eatd259b3db2fcb93f3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 May 2008 01:11:55.0327 (UTC) FILETIME=[82FEE4F0:01C8ABF1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Thu, May 1, 2008 at 5:29 PM, Gabriel C <nix.or.die@googlemail.com> wrote:
>> Yinghai Lu wrote:
>>  > On Thu, May 1, 2008 at 4:45 AM, Gabriel C <nix.or.die@googlemail.com> wrote:
>>  >> Yinghai Lu wrote:
>>  >>  > loop mtrr chunk_size and gran_size from 1M to 2G to find out optimal value.
>>  >>  >
>>  >>  > so user don't need to add mtrr_chunk_size and mtrr_gran_size,
>>  >>  >
>>  >>  > if optimal value is not found, print out all list to help select less optimal
>>  >>  > value.
>>  >>  >
>>  >>  > add mtrr_spare_reg_nr= so user could set 2 instead of 1, if the card need more entries.
>>  >>
>>  >>  WOW :)
>>  >>
>>  >>  With this patch all is working fine , no RAM is lost , X is fast ,
>>  >>  so far everything else seems to work fine. \o/
>>  >>
>>  >>  I will test on 32bit tomorrow and stress the box later on today to be sure everything works fine.
>>  >>
>>  >>  There is my dmesg , meminfo , mtrr output with this patch on top x86-latest :
>>  >>
>>  >>  http://frugalware.org/~crazy/mtrr_x86-latest/
>>  >
>>  > while look at that you boot log, it seems there is one bug about hole
>>  > position. but I look that code, it should already be handled.
>>  >
>>  > Can you send out boot msg and /proc/mtrr when using
>>  > disable_mtrr_cleanup command line?
>>
>>  Sure , there it is :
>>
>>  http://frugalware.org/~crazy/mtrr_x86-latest/dmesg2
>>  http://frugalware.org/~crazy/mtrr_x86-latest/proc_mtrr2
>>
>>  I'm still using this version of your patch , didn't got any time to update to v2.
>>  If you want me to try v2 tell me , I have some free time in about 30 minutes.
>>
> original
> 
> reg00: base=0xd0000000 (3328MB), size= 256MB: uncachable, count=1
> reg01: base=0xe0000000 (3584MB), size= 512MB: uncachable, count=1
> reg02: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
> reg03: base=0x100000000 (4096MB), size= 512MB: write-back, count=1
> reg04: base=0x120000000 (4608MB), size= 128MB: write-back, count=1
> reg05: base=0x128000000 (4736MB), size=  64MB: write-back, count=1
> reg06: base=0xcf600000 (3318MB), size=   2MB: uncachable, count=1
> 
> after clean up
> 
> reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
> reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
> reg02: base=0xc0000000 (3072MB), size= 256MB: write-back, count=1
> reg03: base=0xcfe00000 (3326MB), size=   2MB: uncachable, count=1
> reg04: base=0x100000000 (4096MB), size= 512MB: write-back, count=1
> reg05: base=0x120000000 (4608MB), size= 256MB: write-back, count=1
> reg06: base=0x12c000000 (4800MB), size=  64MB: uncachable, count=1
> 
> so the hole base is not right, it should be at 3318MB instead of 3326MB.
> please hold to test v3 ...

All is still fine here after an quick test ( BTW that version is really chatty :P )

http://frugalware.org/~crazy/mtrr_x86-latest/dmesg_v3

> 
> Thanks
> 
> Yinghai Lu
> 


Gabriel
