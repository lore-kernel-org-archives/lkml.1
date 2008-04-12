Return-Path: <linux-kernel-owner+w=401wt.eu-S1760865AbYDLL32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760865AbYDLL32 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 07:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757460AbYDLL3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 07:29:18 -0400
Received: from proxy1.bredband.net ([195.54.101.71]:45787 "EHLO
	proxy1.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757447AbYDLL3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 07:29:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsQ7ANo5AEhT48OPPGdsb2JhbACBXY9sAQEBATCYUA
Message-ID: <48009D04.3000509@coderworld.net>
Date: Sat, 12 Apr 2008 13:29:08 +0200
From: Richard Jonsson <richie@coderworld.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [rc8] Regression: key repeats and skips in music during compilation
References: <200804041222.35025.elendil@planet.nl> <200804071229.27113.rjw@sisk.pl> <20080407112459.GA11532@linux.vnet.ibm.com> <200804071403.59500.elendil@planet.nl>
In-Reply-To: <200804071403.59500.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop skrev:
> On Monday 07 April 2008, Dhaval Giani wrote:
>> On Mon, Apr 07, 2008 at 12:29:26PM +0200, Rafael J. Wysocki wrote:
>>> On Monday, 7 of April 2008, Frans Pop wrote:
>>>> On Monday 07 April 2008, Rafael J. Wysocki wrote:
>>>>> On Sunday, 6 of April 2008, Rafael J. Wysocki wrote:
>>>>>> On Friday, 4 of April 2008, Frans Pop wrote:
>>>>>>> While compiling glibc I am getting frequent short skips in
>>>>>>> music play anddddddddddddddddd I have now three times seen key
>>>>>>> repeats (as in this sentence). When there is a skip in the
>>>>>>> music, there is also a delay in characters being typed
>>>>>>> appearing on the screen.
>>>>>> Can you test with CONFIG_GROUP_SCHED unset, please?
>>>>> I was able to reproduce this issue with -rc8 on one of my test
>>>>> systems,
>>>> In the mean time I have verified that the issue also existed in rc6,
>>>> so it's not a recent regression.
>>>>
>>>>> but I'm not any more with the current Linus' tree and
>>>>> CONFIG_GROUP_SCHED unset, FWIW.
>>>> Hmm. Does that mean that you _can_ reproduce it with git HEAD and
>>>> CONFIG_GROUP_SCHED set? That would mean it is still an issue in HEAD
>>>> and group scheduling is the culprit.
>>> Well, CONFIG_GROUP_SCHED is known to cause problems, AFAICS, and some
>>> fixes are scheduled for the 2.6.26 time frame.
>> I thought we had most of the issues ironed out.
> 
> Note that I can also reproduce the issue with a kernel that does *not* have 
> CONFIG_GROUP_SCHED set. I still get the music skips (maybe less frequently, 
> but that's hard to measure), and I've have also seen key repeats once.
> 
> Anything I can do to provide additional info on this?
> 
> Cheers,
> FJP
> 
> # CONFIG_CGROUPS is not set
> # CONFIG_GROUP_SCHED is not set
> (config otherwise identical to my initial mail)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Hi

I reported about this problem a while back [1], and have been busy 
bisecting. I have verified the issue in v2.6.25-rc6 and I'm about 99% 
certain that the issue is not present in v2.6.25-rc5-300-gb663c6f.

I've been running this kernel for 3 days now with no problems.

It's a bit worrying to me that it's more frequent in builds between rc6 
and rc7 than vanilla rc6. Newer builds than rc7 not tested.

I've not noticed stuttering audio, but at one time I saw stuttering 
video in a way I don't normally see. May be incidence.

Maybe relevant config:
# CONFIG_CGROUPS is not set
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_CGROUP_SCHED is not set

[1]: http://lkml.org/lkml/2008/3/29/96
