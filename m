Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbYKSUB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbYKSUB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 15:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbYKSUBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 15:01:50 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6269 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbYKSUBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 15:01:49 -0500
X-IronPort-AV: E=McAfee;i="5100,188,5439"; a="13280497"
Message-ID: <492470AB.5060306@qualcomm.com>
Date: Wed, 19 Nov 2008 12:01:47 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nish Aravamudan <nish.aravamudan@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Dimitri Sivanich <sivanich@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Using cpusets for configuration/isolation [Was Re: RT sched:
 cpupri_vec lock contention with def_root_domain and no load balance]
References: <29495f1d0811071123x37d910a8w6c1604b8159954ec@mail.gmail.com> <4923731E.7010601@qualcomm.com> <20081119125135.GB20475@elte.hu> <49243F7C.9090109@qualcomm.com> <20081119174448.GB31560@elte.hu>
In-Reply-To: <20081119174448.GB31560@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Max Krasnyansky <maxk@qualcomm.com> wrote:
> 
>> Ingo Molnar wrote:
>>> * Max Krasnyansky <maxk@qualcomm.com> wrote:
>>>
>>>> What you described is almost exactly what I did in my original 
>>>> cpu isolation patch, which did get NAKed :). Basically I used 
>>>> global cpu_isolated_map and exposed 'isolated' bit, etc.
>>> Please extend cpusets according to the plan outlined by PeterZ a 
>>> few months ago - that's the right place to do partitioning.
>> Already did. It's all in mainline. The part you quoted was just 
>> pointing out that the original approach was not correct.
> 
> Yeah, we have bits of it (i merged them, and i still remember them ;-) 
> - but we still dont have the "system set" concept suggested by Peter 
> though. We could go further and make it really easy to partition all 
> scheduling and irq aspects of the system via cpusets.

Actually we (or maybe just me) gave up on those for now. We went back an forth
on the 'system set' and what it supposed to mean. Both Paul J. and Paul M.
were against the concept and especially backward compatibility with existing
user-space tools that use cpusets. Plus it's really really easy to setup the
'system' set from user-space and I just ended up writing 'syspart' thing that
I mentioned before.

Similar thing happened to "managing irqs via cpusets" idea. Peter and I wanted
to represent them ask tasks and Paul J. was very vocally :) opposed to it.
What we settled on was that we will manage irqs via proc for now. I added a
notion of 'default' irq affinity (ie /proc/irq/default_smp_affinity) which is
already in mainline.

We can probably revisit irq management and 'system' cpuset again. At this
point I'm swamped with other stuff though.

Max
