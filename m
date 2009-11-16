Return-Path: <linux-kernel-owner+w=401wt.eu-S1752792AbZKPPrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbZKPPrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 10:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbZKPPrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 10:47:11 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:54535 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbZKPPrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 10:47:10 -0500
Message-ID: <4B0173FD.4000104@monstr.eu>
Date: Mon, 16 Nov 2009 16:47:09 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Wu Zhangjin <wuzhangjin@gmail.com>, rostedt@goodmis.org,
       Ralf Baechle <ralf@linux-mips.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Patrik Kluba <kpajko79@gmail.com>,
       "Maciej W . Rozycki" <macro@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, zhangfx@lemote.com, zhouqg@gmail.com
Subject: Re: [PATCH v8 01/16] tracing: convert trace_clock_local() as weak
 function
References: <cover.1258177321.git.wuzhangjin@gmail.com> <9dc81a7a9e5a292cccdf465c533a2b08d19d6021.1258177321.git.wuzhangjin@gmail.com> <alpine.LFD.2.00.0911161559280.24119@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0911161559280.24119@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Sat, 14 Nov 2009, Wu Zhangjin wrote:
> 
>> From: Wu Zhangjin <wuzhangjin@gmail.com>
>>
>> trace_clock_local() is based on the arch-specific sched_clock(), in X86,
>> it is tsc(64bit) based, which can give very high precision(about 1ns
>> with 1GHz). but in MIPS, the sched_clock() is jiffies based, which can
>> give only 10ms precison with 1000 HZ. which is not enough for tracing,
>> especially for Real Time system.
>>
>> so, we need to implement a MIPS specific sched_clock() to get higher
>> precision. There is a tsc like clock counter register in MIPS, whose
>> frequency is half of the processor, so, if the cpu frequency is 800MHz,
>> the time precision reaches 2.5ns, which is very good for tracing, even
>> for Real Time system.
>>
>> but 'Cause it is only 32bit long, which will rollover quickly, so, such
>> a sched_clock() will bring with extra load, which is not good for the
>> whole system. so, we only need to implement a arch-specific
>> trace_clock_local() for tracing. as a preparation, we convert it as a
>> weak function.
> 
> Hmm, I'm not convinced that this is really a huge overhead. 
> 
> First of all the rollover happens once every 10 seconds on a 800MHz
> machine. 
> 
> Secondly we have a lockless implementation of extending 32bit counters
> to 63 bit which is used at least by ARM to provide a high resolution
> sched_clock implementation. See include/linux/cnt32_63.h and the users
> in arch/
> 
> But that's a problem which can be discussed seperately and does not
> affect the rest of the tracing infrastructure. I really would
> recommend that you implement a sched_clock for the r4k machines based
> on cnt32_63 and measure the overhead. Having a fine granular
> sched_clock in general is probably not a bad thing.

please cc me on this discuss too. I have working ftrace implementation 
in my tree and I need improve timing too. I have similar patch as MIPS 
use. But I am not able to use it via timecounters. Something is weird 
there that's why I am open to find out any sensible and accepted solution.

Thanks,
Michal

> 
> Thanks,
> 
> 	tglx


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
