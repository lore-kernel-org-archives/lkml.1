Return-Path: <linux-kernel-owner+w=401wt.eu-S1758820AbYDHTJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820AbYDHTJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 15:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbYDHTJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 15:09:43 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38442 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751797AbYDHTJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 15:09:43 -0400
Message-ID: <47FBC2F5.600@sgi.com>
Date: Tue, 08 Apr 2008 12:09:41 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alexander van Heukelum <heukelum@mailshack.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       heukelum@fastmail.fm
Subject: Re: [PATCH 1/2] boot: increase stack size for kernel boot loader
 decompressor
References: <20080405013014.478571000@polaris-admin.engr.sgi.com> <20080405013014.693571000@polaris-admin.engr.sgi.com> <20080405134626.GA15894@mailshack.com> <47FA6478.1070301@sgi.com> <20080407214434.GA5296@mailshack.com> <20080408122007.GA11832@mailshack.com> <20080408134112.GA4277@elte.hu> <47FB8AD2.2040201@sgi.com> <20080408153942.GA26932@elte.hu>
In-Reply-To: <20080408153942.GA26932@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Ingo Molnar wrote:
>>> * Alexander van Heukelum <heukelum@mailshack.com> wrote:
>>>
>>>> Hi Ingo,
>>>>
>>>> I see you have applied the following patch to x86#for-akpm. It was 
>>>> really ment for testing only. I think you ment to use this one 
>>>> instead?
>>> yep, i wanted to see how it holds up in testing - it's OK so far. I've 
>>> got your other, fuller one queued up meanwhile - it's not pushed out 
>>> yet.
>>>
>>> 	Ingo
>> I will try it out on my failing case as soon as I can...
> 
> more test results: i just booted an allyesconfig 64-bit (MAXSMP, etc.) 
> kernel on x86 native hardware successfully - that has Alexander's patch 
> included but not your boot tweak. (has all your other patches included)
> 
> would you expect a real 4K CPUs system to boot any differently? So early 
> during bootup all x86 hardware is just a uniprocessor, so i'd be 
> surprised if there was any difference.
> 
> [ in any case, if the tweak still makes a real difference for you we can 
>   still apply it because it does not hurt anyone - but lets try to avoid 
>   black voodoo tweaks as much as possible :) ]

Yes, my patch is not needed.  I booted the akpm2 config with 512 possible
cpus (8 real) on an Intel box with 8gig total ram.  It booted fine and is
running some cpuset and sched-domain tests now.

One problem though, even though it has slots for extra cpus to be brought
online there is no /sys/devices/cpu/cpuXX/online file to actually bring
them online.  This was shown in a simulated run I did with 64 real cpus
and 12 of them disabled.  They showed up in the 'possible' map but no
way to bring them online.  [Unless there's a trick I don't know about.
Nothing is mentioned in Documentation/cpu-hotplug.txt about this.]

> 
> btw,. booting up MAXSMP is pretty impressive:
> 
>   CONFIG_NR_CPUS=4096
> 
> shows how far Linux scalability has come :)
> 
> i've got a bugreport for you though: MAXSMP does not suspend+resume 
> correctly ;-) It gets this far:
> 
> [  146.348790] PM: Syncing filesystems ... done.
> [  146.353488] PM: Preparing system for mem sleep
> [  146.360204] Freezing user space processes ... (elapsed 0.00 seconds) done.
> [  146.367172] Freezing remaining freezable tasks ... (elapsed 0.93 seconds) done.
> [  147.309618] PM: Entering mem sleep
> [  147.313032] Suspending console(s)
> 
> then reboots spontaneously instead of resuming. (I use the 
> suspend+resume self-test feature below to conduct automated 
> suspend/resume tests.)
> 
> 	Ingo

I will try it out.  Yes, please send me any tests I can add to my suite.

Thanks!
Mike


