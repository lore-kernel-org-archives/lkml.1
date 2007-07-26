Return-Path: <linux-kernel-owner+w=401wt.eu-S933169AbXGZKLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169AbXGZKLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 06:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757955AbXGZKLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 06:11:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:54821 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbXGZKLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 06:11:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=DDq83O2IxJPpkHGLn8FeGIiGRrKBQuuYiJ+Shrh326jnMrS7y1/WHqFK+SvJndr6xytTOw9fZ00l7viP1tMvaJkwYhIQFGeDKq/bLhxoTSkcDCEUEdw/qfrPrBnrYCIoCn4P2k4eZDZXXPr2ifpnySVLiY+iIymJpu/1fEazsk4=
Message-ID: <46A8727F.3030005@googlemail.com>
Date: Thu, 26 Jul 2007 12:07:59 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] ACPI patches for 2.6.23-rc1
References: <200707251238.50218.lenb@kernel.org> <200707251851.22777.lenb@kernel.org> <Pine.LNX.4.64.0707251917320.21378@asgard.lang.hm> <200707260026.08183.lenb@kernel.org>
In-Reply-To: <200707260026.08183.lenb@kernel.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown wrote:
> On Wednesday 25 July 2007 22:20, david@lang.hm wrote:
>> On Wed, 25 Jul 2007, Len Brown wrote:
>>
>>> On Wednesday 25 July 2007 14:48, Linus Torvalds wrote:
>>>
>>>> ... ACPI now seems to select CPU hotplug. Why?
>>> ACPI=y SMP=y systems require SUSPEND_SMP=y for system sleep support,
>>> and that requires HOTPLUG_CPU=y.
>>>

Well *require* if I want SUSPEND*.

>>> Note that ACPI=y SMP=n systems do not need it,
>>> and thus will not select HOTPLUG_CPU=y
>>>
>>>> That is just *broken*. Sure, if you select STR or hibernation, we need CPU
>>>> hotplug, but just for picking ACPI? Why?
>>> My assumption is that if somebody selects CONFIG_ACPI,
>>> that 99% of the time, they intend that to include support for
>>> the ACPI hooks for system sleep states.
>>>
>>> Conversely, supporting the 1% of people who don't want it
>>> isn't worth messing with the 99% who do, nor is
>>> the burden of yet another config option to maintain and
>>> #ifdefs in the code.
>> so you are saying that you know better then we do what we need?
> 
> Feel free to share what you know about the benefits vs. the costs
> of maintaining CONFIG_ACPI_SLEEP as a build option.
> 
>> some people configure ACPI only becouse their system won't work properly 
>> without it. they have no intention of ever doing a STR or hibernate.
> 
> I agree.
> 
> Further, I expect that 100% - (some people %) = 99%
> 
> If you feel that your system has been degraded
> because it now includes what used to be excluded under
> CONFIG_ACPI_SLEEP=n, please let me know how.

Even if I want to SUSPEND* to <something> I can't on my Dell Precision 530 boxes , 
SCSI is broken with suspend therefore all these boxes have the whole SUSPEND* off, 
all I need is ACPI.

So why you think I want to have this all enabled by default now ? 
Just to bloat the kernel with something doesn't even work for me ?

And I don't get from where you have the '99%' thing ?

 > 
>>> On UP, they'd get ACPI system sleep support 100% of the time
>>> by default, but on SMP this option had become problematic.
>>>
>>> We used to have this:
>>>
>>> if ACPI
>>> ...
>>> config ACPI_SLEEP
>>>        bool "Sleep States"
>>>        depends on X86 && (!SMP || SUSPEND_SMP)
>>>        depends on PM
>>>        default y
>>>
>>> So the poster-child failure was i386/defconfig itself...
>>> It couldn't support suspend to RAM because it didn't include
>>> CONFIG_ACPI_SLEEP.  Not trivial for a user to select it
>>> when it doesn't even appear on the menu.  It doesn't appear
>>> because CONFIG_SUSPEND_SMP isn't enabled, but that doesn't
>>> appear either -- because CONFIG_HOTPLUG_CPU isn't selected.
>> so have something like
>>
>> config ACPI_SLEEP
>>          select HOTPLUG_CPU if X86 && SMP
>>          select SUSPEND_SMP if X86 && SMP
>>
>> instead of makeing it dependant on ACPI.
> 
> If more config options where better, then this
> would indeed be an improvement over 2.6.22.
> But more config options isn't better -- except for "some people":-)

But in this case some config / new config is better.

I do not need ACPI to SUSPEND but to make the box work properly.

Ohh and isn't better to make 'ACPI_PROCESSOR  select SUSPEND_SMP and HOTPLUG_CPU if X86 && SMP' ?

...

config ACPI_PROCESSOR
        tristate "Processor"
        default y
        help
          This driver installs ACPI as the idle handler for Linux, and uses
          ACPI C2 and C3 processor states to save power, on systems that
          support it.  It is required by several flavors of cpufreq
          Performance-state drivers.

...

Is more logical for me to do it here but I may be wrong.

> 
> thanks.
> -Len
> 


Gabriel

