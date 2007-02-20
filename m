Return-Path: <linux-kernel-owner+w=401wt.eu-S1030480AbXBTWCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030480AbXBTWCZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 17:02:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030479AbXBTWCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 17:02:25 -0500
Received: from ithilien.qualcomm.com ([129.46.51.59]:41348 "EHLO
	ithilien.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030480AbXBTWCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 17:02:24 -0500
Message-ID: <45DB6FC7.60502@qualcomm.com>
Date: Tue, 20 Feb 2007 14:01:43 -0800
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
References: <20070129011301.GA844@tv-sign.ru> <Pine.LNX.4.64.0701290852390.28200@schroedinger.engr.sgi.com> <20070129171923.GA138@tv-sign.ru> <Pine.LNX.4.64.0701290922390.28330@schroedinger.engr.sgi.com> <20070129182742.GA158@tv-sign.ru> <45DB404C.4070305@qualcomm.com> <Pine.LNX.4.64.0702201041340.14643@schroedinger.engr.sgi.com> <20070220200550.GA85@tv-sign.ru> <45DB669B.2010307@qualcomm.com> <Pine.LNX.4.64.0702201334361.17198@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0702201334361.17198@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 20 Feb 2007, Max Krasnyansky wrote:
> 
>> I guess I kind of hijacked the thread. The second part of my first email was
>> dropped. Basically I was saying that I'm working on CPU isolation extensions.
>> Where an isolated CPU is not supposed to do much kernel work. In which case
>> you'd want to run slab cache reaper on some other CPU on behalf of the
>> isolated
>> one. Hence the proposal to explicitly pass cpu_id to the reaper. I guess now
>> that you guys fixed the hotplug case it does not help in that scenario.
> 
> A cpu must have a per cpu cache in order to do slab allocations. The 
> locking in the slab allocator depends on it.
> 
> If the isolated cpus have no need for slab allocations then you will also 
> not need to run the slab_reaper().

Ok. Sounds like disabling cache_reaper is a better option for now. Like you said
it's unlikely that slabs will grow much if that cpu is not heavily used by the
kernel.

Thanks
Max
