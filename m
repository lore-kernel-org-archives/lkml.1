Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbYKSQ2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbYKSQ2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 11:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbYKSQ2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 11:28:17 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55917 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbYKSQ2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 11:28:15 -0500
X-IronPort-AV: E=McAfee;i="5300,2777,5438"; a="13297739"
Message-ID: <49243E9D.1050209@qualcomm.com>
Date: Wed, 19 Nov 2008 08:28:13 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: Nish Aravamudan <nish.aravamudan@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Dimitri Sivanich <sivanich@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Using cpusets for configuration/isolation [Was Re: RT sched:
 cpupri_vec lock contention with def_root_domain and no load balance]
References: <29495f1d0811071123x37d910a8w6c1604b8159954ec@mail.gmail.com>	 <4923731E.7010601@qualcomm.com> <29495f1d0811181811r1a7476ceyb5cb4a86e11e7651@mail.gmail.com> <4923A0A8.5050009@qualcomm.com> <492406FD.3030001@novell.com>
In-Reply-To: <492406FD.3030001@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Gregory Haskins wrote:
> Max Krasnyansky wrote:
>> Nish Aravamudan wrote:
>>   
>>> On Tue, Nov 18, 2008 at 5:59 PM, Max Krasnyansky <maxk@qualcomm.com> wrote:
>>>     
>>>> I do not see how 'partfs' that you described would be different from
>>>> 'cpusets' that we have now. Just ignore 'tasks' files in the cpusets and you
>>>> already have your 'partfs'. You do _not_ have to use cpuset for assigning
>>>> tasks if you do not want to. Just use them to define sets of cpus and keep
>>>> all the tasks in the 'root' set. You can then explicitly pin your threads
>>>> down with pthread_set_affinity().
>>>>       
>>> I guess you're right. It still feels a bit kludgy, but that is probably just me.
>>>
>>> I have wondered, though, if it makes sense to provide an "isolated"
>>> file in /sys/devices/system/cpu/cpuX/ to do most of the offline
>>> sequence, break sched_domains and remove a CPU from the load balancer
>>> (rather than turning the load balancer off), rather than requiring a
>>> user to explicitly do an offline/online. 
>>>     
>> I do not see any benefits in exposing a special 'isolated' bit and have it do
>> the same thing that the cpu hotplug already does. As I explained in other
>> threads cpu hotplug is a _perfect_ fit for the isolation purposes. In order to
>> isolate a CPU dynamically (ie at runtime) we need to flush pending work, flush
>> chaches, move tasks and timers, etc. Which is _exactly_ what cpu hotplug code
>> does when it brings CPU down. There is no point in reimplementing it.
>>
>> btw It sounds like you misunderstood the meaning of the
>> cpuset.sched_load_balance flag. It's does not turn really turn load balancer
>> off, it simply causes cpus in different cpusets to be put into separate sched
>> domains. In other words it already does exactly what you're asking for.
>>   
> 
> On a related note, please be advised I have a bug in this area:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=12054

Yes, I saw the original thread on this. I'll reply in there.

Max
