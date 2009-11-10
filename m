Return-Path: <linux-kernel-owner+w=401wt.eu-S1757207AbZKJQuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbZKJQuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 11:50:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757172AbZKJQuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 11:50:35 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:18151 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757142AbZKJQue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 11:50:34 -0500
Message-ID: <4AF99848.9090000@caviumnetworks.com>
Date: Tue, 10 Nov 2009 08:43:52 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: wuzhangjin@gmail.com
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       zhangfx@lemote.com, zhouqg@gmail.com,
       Ralf Baechle <ralf@linux-mips.org>, rostedt@goodmis.org,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Patrik Kluba <kpajko79@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH v7 04/17] tracing: add static function tracer support
 for MIPS
References: <9dc81a7a9e5a292cccdf465c533a2b08d19d6021.1257779502.git.wuzhangjin@gmail.com>	 <b99c08397d9ff92ac5a72bda9131df41b702fc71.1257779502.git.wuzhangjin@gmail.com>	 <8f579e2cece16cd22358a4ec143ef6a8c462639b.1257779502.git.wuzhangjin@gmail.com>	 <cefe074f5eb3cfbc2e0bb41b0c1f61fcd0190d90.1257779502.git.wuzhangjin@gmail.com>	 <4AF8B31C.5030802@caviumnetworks.com> <1257814817.2822.3.camel@falcon.domain.org>
In-Reply-To: <1257814817.2822.3.camel@falcon.domain.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Nov 2009 16:43:53.0557 (UTC) FILETIME=[FCF26850:01CA6224]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Zhangjin wrote:
> Hi,
> 
> On Mon, 2009-11-09 at 16:26 -0800, David Daney wrote: 
>> Wu Zhangjin wrote:
>>
>>>  
>>> +ifndef CONFIG_FUNCTION_TRACER
>>>  cflags-y := -ffunction-sections
>>> +else
>>> +cflags-y := -mlong-calls
>>> +endif
>>>  cflags-y += $(call cc-option, -mno-check-zero-division)
>>>  
>> That doesn't make sense to me.  Modules are already compiled with 
>> -mlong-calls.  The only time you would need the entire kernel compiled 
>> with -mlong-calls is if the tracer were in a module.  The logic here 
>> doesn't seem to reflect that.
> 
> Yes, I knew the module have gotten the -mlong-calls, Here we just want
> to use -mlong-calls for the whole kernel, and then we get the same
> _mcount stuff in the whole kernel, at last, we can use the same
> scripts/recordmcount.pl and ftrace_make_nop & ftrace_make_call for the
> dynamic ftracer.
> 

-mlong-calls really degrades performance.  I have seen things like 6% 
drop in network packet forwarding rates with -mlong-calls.

It would be better to fix all the tools so that they could handle both 
-mlong-calls and -mno-long-calls code.


David Daney
