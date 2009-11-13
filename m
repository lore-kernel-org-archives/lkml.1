Return-Path: <linux-kernel-owner+w=401wt.eu-S1755944AbZKMAUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbZKMAUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 19:20:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755908AbZKMAUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 19:20:34 -0500
Received: from lucidpixels.com ([75.144.35.66]:43516 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755893AbZKMAUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 19:20:34 -0500
Date: Thu, 12 Nov 2009 19:20:39 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
cc: Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: RE: 2.6.31.4: WARNING: at arch/x86/kernel/hpet.c:390
 hpet_next_event+0x70/0x80() [occurs when ACPI_PROCESSOR=y]
In-Reply-To: <7E82351C108FA840AB1866AC776AEC467647ABBD@orsmsx505.amr.corp.intel.com>
Message-ID: <alpine.DEB.2.00.0911121916590.31209@p34.internal.lan>
References: <alpine.DEB.2.00.0911080932590.4556@p34.internal.lan>  <20091111195016.GB22225@redhat.com>  <alpine.DEB.2.00.0911111608020.5456@p34.internal.lan>  <alpine.DEB.2.00.0911121120330.6976@p34.internal.lan>  <alpine.DEB.2.00.0911121127500.6976@p34.internal.lan>
  <1f1b08da0911121513l32d47b4x8b9722ad3440ceb6@mail.gmail.com>  <alpine.DEB.2.00.0911121824290.2852@p34.internal.lan> <1258069232.14894.9.camel@localhost.localdomain> <alpine.LFD.2.00.0911130045070.24119@localhost.localdomain> <alpine.DEB.2.00.0911121855170.5147@p34.internal.lan>
 <7E82351C108FA840AB1866AC776AEC467647ABBD@orsmsx505.amr.corp.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 12 Nov 2009, Pallipadi, Venkatesh wrote:

>
>> On Fri, 13 Nov 2009, Thomas Gleixner wrote:
>>
>>> On Thu, 12 Nov 2009, john stultz wrote:
>>>
>>>> Forgot to CC lkml, re-adding.
>>>
>>> Added more CCs
>>>
>>>> On Thu, 2009-11-12 at 18:25 -0500, Justin Piszcz wrote:
>>>>> On Thu, 12 Nov 2009, john stultz wrote:
>>>>>> On Thu, Nov 12, 2009 at 8:33 AM, Justin Piszcz
>> <jpiszcz@lucidpixels.com> wrote:
>>>>>>> On Thu, 12 Nov 2009, Justin Piszcz wrote:
>>>>>>>> On Wed, 11 Nov 2009, Justin Piszcz wrote:
>>>>>>>> Again, the problem:
>>>>>>>> [    3.318770] cpuidle: using governor ladder
>>>>>>>> [    3.321556] ------------[ cut here ]------------
>>>>>>>> [    3.321560] WARNING: at arch/x86/kernel/hpet.c:390
>>>>>>>> hpet_next_event+0x70/0x80()
>>>>>>>> [    3.321561] Hardware name:
>>>>>>>> [    3.321562] Modules linked in:
>>>>>>>> [    3.321564] Pid: 0, comm: swapper Not tainted 2.6.31.5 #17
>>>>>>>> [    3.321565] Call Trace:
>>>>>>>> [    3.321567]  [<ffffffff81042f00>] ? hpet_next_event+0x70/0x80
>>>>>>>> [    3.321568]  [<ffffffff81042f00>] ? hpet_next_event+0x70/0x80
>>>>>>>> [    3.321571]  [<ffffffff81056724>] ?
>> warn_slowpath_common+0x74/0xd0
>>>>>>>> [    3.321573]  [<ffffffff81042f00>] ? hpet_next_event+0x70/0x80
>>>>>>>> [    3.321576]  [<ffffffff81077696>] ?
>> tick_dev_program_event+0x36/0xb0
>>>>>>>> [    3.321578]  [<ffffffff81077079>] ?
>>>>>>>> tick_broadcast_oneshot_control+0x119/0x120
>>>>>>>> [    3.321579]  [<ffffffff8107683d>] ? tick_notify+0x22d/0x420
>>>>>>>> [    3.321581]  [<ffffffff8106fe37>] ?
>> notifier_call_chain+0x37/0x70
>>>>>>>> [    3.321583]  [<ffffffff8107612b>] ?
>> clockevents_notify+0x2b/0x90
>>>>>>>> [    3.321586]  [<ffffffff81244848>] ?
>> acpi_idle_enter_bm+0x15f/0x2d3
>>>>>>>> [    3.321587]  [<ffffffff812446de>] ?
>> acpi_idle_enter_c1+0xf1/0xfc
>>>>>>>> [    3.321590]  [<ffffffff812e6d7a>] ?
>> cpuidle_idle_call+0xba/0x120
>>>>>>>> [    3.321593]  [<ffffffff8102b832>] ? cpu_idle+0x62/0xc0
>>>>>>>> [    3.321596] ---[ end trace cac202f11005305c ]---
>>>>>>>> [    3.553852] cpuidle: using governor menu
>>>>>>>
>>>> Huh. That's sort of crazy. It almost seems as though you
>> have two offset
>>>> HPET timers at one timer location that are switching back and forth.
>>>> Looks like either very busted hardware, or something new the kernel
>>>> doesn't expect.
>>>>
>>>>> When I do not load processor.ko though, the error does not occur?
>
> Yes. Yes. This is a hardware errata. I have a patch to workaround this and
> waiting on the errata description to get published..
When will the patch be publicly available?

>
> processor.ko part may be a red-herring as we do not use hpet when deep
> C-states are not enabled and hence we won't go through this code path.
Can you clarify something in relation to C-states?  Without processor.ko 
(along with ACPI_CPUFREQ etc) loaded, turbo boost will not be enabled, 
correct (the CPU will not be able to change stages)?

Processor.ko loaded (even w/ the bug) = bzip2 of 2.6.31.tar = 40 seconds.
Processor.ko not loaded               = bzip2 of 2.6.31.tar = 50 seconds.

Thanks.


>
> Thanks,
> Venki
>
