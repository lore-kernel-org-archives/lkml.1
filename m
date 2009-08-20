Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbZHTK4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbZHTK4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 06:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZHTK4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 06:56:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36005 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbZHTK4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 06:56:51 -0400
Date: Thu, 20 Aug 2009 12:56:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Marton Balint <cus@fazekas.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Andreas Mohr <andi@lisas.de>,
       linux-kernel@vger.kernel.org
Subject: Re: CPU scheduler weirdness?
Message-ID: <20090820105645.GA23635@elte.hu>
References: <20090813084257.GA761@rhlx01.hs-esslingen.de> <alpine.LNX.2.00.0908131720050.8321@cinke.fazekas.hu> <20090813155812.GA15714@rhlx01.hs-esslingen.de> <alpine.LNX.2.00.0908171758340.2764@cinke.fazekas.hu> <1250665455.7583.326.camel@twins> <alpine.LNX.2.00.0908191353100.19120@cinke.fazekas.hu> <1250683834.7583.360.camel@twins> <alpine.LNX.2.00.0908191428300.20409@cinke.fazekas.hu> <1250707331.7154.1.camel@laptop> <alpine.LNX.2.00.0908192125180.4364@cinke.fazekas.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0908192125180.4364@cinke.fazekas.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Marton Balint <cus@fazekas.hu> wrote:

>
> On Wed, 19 Aug 2009, Peter Zijlstra wrote:
>
>> On Wed, 2009-08-19 at 14:34 +0200, Marton Balint wrote:
>>>
>>> On Wed, 19 Aug 2009, Peter Zijlstra wrote:
>>>
>>>> On Wed, 2009-08-19 at 14:01 +0200, Marton Balint wrote:
>>>>> On Wed, 19 Aug 2009, Peter Zijlstra wrote:
>>>>>> On Tue, 2009-08-18 at 21:49 +0200, Marton Balint wrote:
>>>>>>
>>>>>>> In the meantime, I was able to create a tiny C program which always
>>>>>>> succesfully reproduces the bug. It's basically an endless loop which does
>>>>>>> not stop while the process is running on the last CPU core. The program
>>>>>>> creates multiple instances of itself, to be able to keep all of the CPU
>>>>>>> cores busy. After 1 second, the processes running on other than the last
>>>>>>> CPU core die, the processes running on the last CPU core remain stuck
>>>>>>> there...
>>>>>>>
>>>>>>> I tested it on my dual core system, if someone could test it on a quad
>>>>>>> core and report back that would probably be useful.
>>>>>>>
>>>>>>> Usage: ./schedtest <number of CPU cores>
>>>>>>>
>>>>>>> And don't forget to kill the stuck processes after using the program! :)
>>>>>>
>>>>>> So what's the bug? Sure one task will stay on the cpu, and because there
>>>>>> is no contention it doesn't get migrated, and therefore won't quit,
>>>>>> how's that a problem?
>>>>>
>>>>> Problem is that more than one processes remain on that CPU core, and none
>>>>> of them get migrated to other (idle) cores. I tested it with my E8400
>>>>> processor and 2.6.31-rc5-git3 kernel.
>>>>
>>>> Only one remains here.. on a c2q running 2.6.31-rc6-tip
>>>>
>>>> Do you have a .config handy?
>>>>
>>>
>>> Yes it's in my original post:
>>>
>>> http://marc.info/?l=linux-kernel&m=125012584709800&w=2
>>
>> Right you are,.. so I build a kernel with the cgroup scheduler in and
>> tested it on a dual-core opteron machine, but I can't seem to reproduce
>> this.
>>
>> Are you using cgroups in any way, or do you simply have it enabled in
>> your config?
>
> No, it's just enabled. Actually the kernel is from the 
> openSUSE build service:
>
> http://download.opensuse.org/repositories/Kernel:/HEAD/openSUSE_11.1/x86_64/
>
> But the problem is present for both the kernel-default 
> kernel and the kernel-vanilla kernel which does not 
> contain any suse-specific patches.
>
> This evening I had a bit more time to test, and I've 
> made a surprising discovery: I can only reproduce the 
> bug if the kernel module of my TV tuner card is loaded. 
> I have a Leadtek Winfast 2000 XP Expert TV card, it 
> uses the cx8800 kernel module. It seems that the 
> problem is somehow related to the infrared sensor of 
> the TV card, because I recompiled the module with the 
> 'case CX88_BOARD_WINFAST2000XP_EXPERT:' line removed 
> from cx88-input.c and I couldn't reproduce the bug with 
> the new kernel module.

Extremely weird. Are timers somehow busted?

	Ingo
