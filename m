Return-Path: <linux-kernel-owner+w=401wt.eu-S1030404AbXBTVXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030404AbXBTVXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 16:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030419AbXBTVXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 16:23:23 -0500
Received: from numenor.qualcomm.com ([129.46.51.58]:47581 "EHLO
	numenor.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030404AbXBTVXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 16:23:23 -0500
Message-ID: <45DB669B.2010307@qualcomm.com>
Date: Tue, 20 Feb 2007 13:22:35 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Gautham shenoy <ego@in.ibm.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: slab: start_cpu_timer/cache_reap CONFIG_HOTPLUG_CPU problems
References: <20070129011301.GA844@tv-sign.ru> <Pine.LNX.4.64.0701290852390.28200@schroedinger.engr.sgi.com> <20070129171923.GA138@tv-sign.ru> <Pine.LNX.4.64.0701290922390.28330@schroedinger.engr.sgi.com> <20070129182742.GA158@tv-sign.ru> <45DB404C.4070305@qualcomm.com> <Pine.LNX.4.64.0702201041340.14643@schroedinger.engr.sgi.com> <20070220200550.GA85@tv-sign.ru>
In-Reply-To: <20070220200550.GA85@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 02/20, Christoph Lameter wrote:
>> On Tue, 20 Feb 2007, Max Krasnyansky wrote:
>>
>>>>> Well seems that we have a set of unresolved issues with workqueues and cpu
>>>>> hotplug.
>>> How about storing 'cpu' explicitly in the work queue instead of relying on the
>>> smp_processor_id() and friends ? That way there is no ambiguity when
>>> threads/timers get
>>> moved around.
>> The slab functionality is designed to work on the processor with the 
>> queue. These tricks will only cause more trouble in the future. The 
>> cache_reaper needs to be either disabled or run on the right processor. It 
>> should never run on the wrong processor.
> 
> I personally agree. Besides, cache_reaper is not alone. Note the comment
> in debug_smp_processor_id() about cpu-bound processes. The slab does correct
> thing right now, stops the timer on CPU_DEAD. Other problems imho should be
> solved by fixing cpu-hotplug. Gautham and Srivatsa are working on that.

I guess I kind of hijacked the thread. The second part of my first email was
dropped. Basically I was saying that I'm working on CPU isolation extensions.
Where an isolated CPU is not supposed to do much kernel work. In which case
you'd want to run slab cache reaper on some other CPU on behalf of the isolated
one. Hence the proposal to explicitly pass cpu_id to the reaper. I guess now
that you guys fixed the hotplug case it does not help in that scenario.

Max
