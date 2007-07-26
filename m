Return-Path: <linux-kernel-owner+w=401wt.eu-S964929AbXGZSlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964929AbXGZSlz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934973AbXGZSln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:41:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:43967 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934438AbXGZSll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:41:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=WvM2NSXhhUsLYsf/KiJRas7bXoxuPvAU71aPUb4hP8bW6FFjrQ3lDV4C1M72o8tjHVYvfd9caYH/juCQT17nvIai8INMqj49firlcUbelVAN0Jieqa7PLoGu73SEc5PF1cbT4JxX55yjRkXyzA0pruNLYXFPtn2IV38/c0hfqA4=
Message-ID: <46A8EA0B.4000602@googlemail.com>
Date: Thu, 26 Jul 2007 20:38:03 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] ACPI patches for 2.6.23-rc1
References: <200707251238.50218.lenb@kernel.org> <200707260026.08183.lenb@kernel.org> <46A8727F.3030005@googlemail.com> <200707261405.09278.lenb@kernel.org>
In-Reply-To: <200707261405.09278.lenb@kernel.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown wrote:
> On Thursday 26 July 2007 06:07, Gabriel C wrote:
> 
>>> If you feel that your system has been degraded
>>> because it now includes what used to be excluded under
>>> CONFIG_ACPI_SLEEP=n, please let me know how.
>> Even if I want to SUSPEND* to <something> I can't on my Dell Precision 530 boxes , 
>> SCSI is broken with suspend therefore all these boxes have the whole SUSPEND* off, 
>> all I need is ACPI.
> 
> Linux is already way behind the competition on both STR and STD.
> Disabling it because it doesn't work will makes this situation
> worse, not better.

Heh what else can I do ? The _bug_(s) are reporter for ages.

See this one as example ( this kills all my Dells ) and there are a lot more reported.

http://bugzilla.kernel.org/show_bug.cgi?id=3062

...

 Description From Nathan Bryant 2004-07-13 18:14

...

Notice '2004' and still no one really cares .. 
So all I can do for now is to disable it.

> 
>> So why you think I want to have this all enabled by default now ? 
>> Just to bloat the kernel with something doesn't even work for me ?
> 
> Can you be specific about how much additional "bloat" your system
> must endure with CONFIG_ACPI_SLEEP=y

At least I was not forced to use HOTPLUG_CPU .. 

Really I just enable what I need / works on my box(es).

> 
>>>> config ACPI_SLEEP
>>>>          select HOTPLUG_CPU if X86 && SMP
>>>>          select SUSPEND_SMP if X86 && SMP
>>>>
>>>> instead of makeing it dependant on ACPI.
>>> If more config options where better, then this
>>> would indeed be an improvement over 2.6.22.
>>> But more config options isn't better -- except for "some people":-)
>> But in this case some config / new config is better.
>>
>> I do not need ACPI to SUSPEND but to make the box work properly.
> 
> You also don't need a lot of other code in your kernel.
> 
> At some point the complexity of supporting more configuration options
> out-weights the benefits of having them.  I have a pretty good idea
> of the cost of maintaining the code.  So my question to you is
> is what, exactly, is the benefit of having 2.6.22 CONFIG_ACPI_SLEEP=y
> that is now lost in 2.6.23-git?
> 
>> Ohh and isn't better to make 'ACPI_PROCESSOR  select SUSPEND_SMP and HOTPLUG_CPU if X86 && SMP' ?
>>
>> ...
>>
>> config ACPI_PROCESSOR
>>         tristate "Processor"
>>         default y
>>         help
>>           This driver installs ACPI as the idle handler for Linux, and uses
>>           ACPI C2 and C3 processor states to save power, on systems that
>>           support it.  It is required by several flavors of cpufreq
>>           Performance-state drivers.
>>
>> ...
>>
>> Is more logical for me to do it here but I may be wrong.
> 
> ACPI_PROCESSOR supports C-states and P-states and is not directly
> related to support for system sleep states.  If your system is recent,
> then it is likely that you want to enable this (and cpufreq) to save power --
> even if you are not interested in system-wide sleep states.

Oh ok.

Well then add a dummy config onpion, ACPI_DESKTOP_SUSPEND or something , move the 2 selects to there ,
make it visible in the menu and make it even default y but that way one can disable it.

You have a config option more even you hate that =) but no #ifdef's in code.

> 
> -Len
> 


Gabriel
