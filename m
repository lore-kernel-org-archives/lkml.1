Return-Path: <linux-kernel-owner+w=401wt.eu-S1030398AbXBTVGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030398AbXBTVGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 16:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030394AbXBTVGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 16:06:36 -0500
Received: from ithilien.qualcomm.com ([129.46.51.59]:35955 "EHLO
	ithilien.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030399AbXBTVGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 16:06:35 -0500
X-Greylist: delayed 8772 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Feb 2007 16:06:35 EST
Message-ID: <45DB62B3.8060905@qualcomm.com>
Date: Tue, 20 Feb 2007 13:05:55 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Gautham shenoy <ego@in.ibm.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: slab: start_cpu_timer/cache_reap CONFIG_HOTPLUG_CPU problems
References: <20070129011301.GA844@tv-sign.ru> <Pine.LNX.4.64.0701290852390.28200@schroedinger.engr.sgi.com> <20070129171923.GA138@tv-sign.ru> <Pine.LNX.4.64.0701290922390.28330@schroedinger.engr.sgi.com> <20070129182742.GA158@tv-sign.ru> <45DB404C.4070305@qualcomm.com> <Pine.LNX.4.64.0702201041340.14643@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0702201041340.14643@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 20 Feb 2007, Max Krasnyansky wrote:
> 
>>>> Well seems that we have a set of unresolved issues with workqueues and cpu
>>>> hotplug.
>> How about storing 'cpu' explicitly in the work queue instead of relying on the
>> smp_processor_id() and friends ? That way there is no ambiguity when
>> threads/timers get
>> moved around.
> 
> The slab functionality is designed to work on the processor with the 
> queue. These tricks will only cause more trouble in the future. The 
> cache_reaper needs to be either disabled or run on the right processor. It 
> should never run on the wrong processor.
> The cache_reaper() is of no importance to hotplug. You just need to make 
> sure that it is not in the way (disable it and if its running wait 
> until the cache_reaper has finished).

I agree that running the reaper on the wrong CPU is not the best way to go about it.
But it seems like disabling it is even worse, unless I missing something. ie wasting
memory.

btw What kind of troubles were you talking about ? Performance or robustness ?
As I said performance wise it does not make sense to run reaper on the wrong CPU but
it does seems to work just fine from the correctness (locking, etc) perspective. Again
it's totally possible that I'm missing something here :).

Thanks
Max
