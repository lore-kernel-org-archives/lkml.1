Return-Path: <linux-kernel-owner+w=401wt.eu-S1161043AbXBTWsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161043AbXBTWsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 17:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161049AbXBTWsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 17:48:23 -0500
Received: from numenor.qualcomm.com ([129.46.51.58]:54965 "EHLO
	numenor.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161052AbXBTWsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 17:48:21 -0500
Message-ID: <45DB7AB1.5010304@qualcomm.com>
Date: Tue, 20 Feb 2007 14:48:17 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: linux-kernel@vger.kernel.org
Subject: SLAB cache reaper on isolated cpus
References: <20070129011301.GA844@tv-sign.ru> <Pine.LNX.4.64.0701290852390.28200@schroedinger.engr.sgi.com> <20070129171923.GA138@tv-sign.ru> <Pine.LNX.4.64.0701290922390.28330@schroedinger.engr.sgi.com> <20070129182742.GA158@tv-sign.ru> <45DB404C.4070305@qualcomm.com> <Pine.LNX.4.64.0702201041340.14643@schroedinger.engr.sgi.com> <20070220200550.GA85@tv-sign.ru> <45DB669B.2010307@qualcomm.com> <Pine.LNX.4.64.0702201334361.17198@schroedinger.engr.sgi.com> <45DB6FC7.60502@qualcomm.com> <Pine.LNX.4.64.0702201402420.17433@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0702201402420.17433@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 20 Feb 2007, Max Krasnyansky wrote:
> 
>> Ok. Sounds like disabling cache_reaper is a better option for now. Like you said
>> it's unlikely that slabs will grow much if that cpu is not heavily used by the kernel.
> 
> Running for prolonged times without cache_reaper is no good.
> 
> What we are talking about here is to disable the cache_reaper during cpu 
> shutdown. The slab cpu shutdown will clean the per cpu caches anyways so 
> we really do not need the slab_reaper running during cpu shutdown.

Ok. Let me restart the thread so that we're not confusing two issues :).

I'm not talking about CPU shutdown or CPU hotplug in general. My proposal seemed related
to the CPU shutdown issue that you guys were discussing, but it turns out it's not.

Suppose I need to isolate a CPU. We already support at the scheduler and irq levels (irq affinity).
But I want to go a bit further and avoid doing kernel work on isolated cpus as much as possible.
For example I would not want to schedule work queues and stuff on them.
Currently there are just a few users of the schedule_delayed_work_on(). cpufreq (don't care for
isolation purposes), oprofile (same here) and slab.
For the slab it'd be nice to run the reaper on some other CPU. But you're saying that locking
depends on CPU pinning. Is there any other option besides disabling cache reap ? Is there a way
for example to constraint the slabs on CPU X to not exceed N megs ?

Max




