Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbYLJJH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbYLJJH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 04:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754500AbYLJJHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 04:07:43 -0500
Received: from mail.windriver.com ([147.11.1.11]:43763 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731AbYLJJHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 04:07:42 -0500
Message-ID: <493F82DE.8060909@windriver.com>
Date: Wed, 10 Dec 2008 16:50:38 +0800
From: Wang Liming <liming.wang@windriver.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] tracing/function-graph-tracer: signal interrupt triggering
 on output
References: <493EF64D.50804@gmail.com>	 <alpine.DEB.1.10.0812092111510.19875@gandalf.stny.rr.com> <c62985530812100046l69ca7019j545fed604c373efa@mail.gmail.com>
In-Reply-To: <c62985530812100046l69ca7019j545fed604c373efa@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 10 Dec 2008 09:06:55.0301 (UTC) FILETIME=[A6024F50:01C95AA6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frédéric Weisbecker wrote:
> 2008/12/10 Steven Rostedt <rostedt@goodmis.org>:
>> On Tue, 9 Dec 2008, Frederic Weisbecker wrote:
>>
>>> This patchset adds all the features to draw hardirq triggering on output
>>> for the function graph tracer.
>>> An example is given on the third patch.
>>>
>>> Just one question, on recordmcount.pl:
>>>
>>> my %text_sections = (
>>>       ".text" => 1,
>>>       ".sched.text" => 1,
>>>       ".spinlock.text" => 1,
>>>
>>> The .sched.text section is included inside .text, it's a subsection, I'm not sure
>>> it's necessary to add it in text_sections. In doubt I added the new .irqentry.text
>>>
>> Matters what objdump -dr shows.
>>
>> $ objdump -dr kernel/sched.o | grep 'Disassembly'
>> Disassembly of section .text:
>> Disassembly of section .cpuinit.text:
>> Disassembly of section .init.text:
>> Disassembly of section .sched.text:
>>
>> Yep, .sched.text is needed.  It is not about what gets linked by the
>> linker. It is about what objdump shows, which is what recordmcount.pl uses
>> to determine whether or not to record the mcount callers in that section.
> 
> 
> Ok. I looked at a disassembly objdump on vmlinux to find those
> subsections and didn't find it.
> But I didn't see that recordmcount did its work on each build folder,
You can see "scripts/Makefile.build" file, which uses recordmcount.pl to deal 
with each .o file when building.

Liming Wang
> I guess that these sections are
> visible on the objects found in the subdirectories....
> 
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

