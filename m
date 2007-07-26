Return-Path: <linux-kernel-owner+w=401wt.eu-S935904AbXGZSFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935904AbXGZSFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932284AbXGZSEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:04:53 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:51515
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933807AbXGZSEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:04:52 -0400
Date: Thu, 26 Jul 2007 11:02:53 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Len Brown <lenb@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] ACPI patches for 2.6.23-rc1
In-Reply-To: <200707261345.29902.lenb@kernel.org>
Message-ID: <Pine.LNX.4.64.0707261056010.4183@asgard.lang.hm>
References: <200707251238.50218.lenb@kernel.org> <200707260026.08183.lenb@kernel.org>
 <alpine.LFD.0.999.0707252353150.3442@woody.linux-foundation.org>
 <200707261345.29902.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007, Len Brown wrote:

> 
> On Thursday 26 July 2007 02:55, Linus Torvalds wrote:
>>
>> On Thu, 26 Jul 2007, Len Brown wrote:
>
>>> If you feel that your system has been degraded
>>> because it now includes what used to be excluded under
>>> CONFIG_ACPI_SLEEP=n, please let me know how.
>>
>> I feel that I get asked to include a feature that
>>  (a) I have no interest in on that machine
>>  (b) I didn't need to include before.
>>
>> What was the advantage? And what was it that caused something like this to
>> be a post-rc1 thing. That makes me really unhappy. This is a *regression*.
>
> I'm sorry that one fewer config options has offended your feeling of freedom,
> honestly, I am.
>
> I was actually asking how somebody's _system_ has been degraded
> by this change -- but I haven't got an objective answer to that one yet.

how about the fact that Linus found the problem becouse his system didn't 
work right?

> As I said in my pull request, I agree that the D-state fixes ideally
> should have merged a week earlier -- before the rc1 cutoff.
> Indeed, we had a hack that could have gone up much earlier.
> However, we waited for Rafael's more general list-blessed solution --
> and it turned out that solution tripped over CONFIG_ACPI_SLEEP=n.
>
> The reason is because there is a dependency between D-states and S-states.
> In particular, devices which are enabled to be system wakeup devices
> can be limited in what D-states they can enter (else they may
> no longer be able to wake up the system when it is suspended)

you are assuming that people want to suspend

> I figured that rather than adding more ifdefs to solve that problem,
> it was simpler to remove ifdefs.  I was also shocked to find i386 defconfig
> with CONFIG_ACPI_SLEEP=n.  Maybe others are not shocked by this
> and there is a reason that defconfig on x86_64 supports sleep
> and i386 does not.  I assumed it was a bug, maybe I was wrong.
>
> The context for this is the EPA ENERGY STAR specification for Computers,
> which went into effect this month.  This spec says that systems which
> can not automatically go into suspend within 15 minutes of idle
> can _not_ earn a sticker.  No sticker, no client computer sales to governments.
> If Linux can't get STR working, broadly deployed, and enabled by default,
> then our plans for world domination are going to take a significant hit.

isn't the sticker and specification for hardware? but in any case not all 
hardware needs to get that sticker.

> yes, I understand that there are SMP systems that want ACPI and don't
> need sleep or CONFIG_HOGPLUG_CPU.  However, I don't see major distros
> shipping kernels to their server customers that way, so I didn't think
> it would offend a significant part of the community's sense of freedom
> if this config option were removed.  Maybe I was wrong.

distros aren't everything

> Obviously, your vote counts more than the sum total of a lot of the community,
> so if you want me to put a config option in to allow ACPI w/o ACPI_SLEEP,
> I'll simply do it for you.  However, I could do a better job of it
> if I had a clear understanding of what the technical benefit of
> that option is supposed to be, and how it will make Linux better.

the idea is that code that doesn't get compiled into the kernel can't 
cause the system to misbehave.

David Lang
