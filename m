Return-Path: <linux-kernel-owner+w=401wt.eu-S1756662AbYF0EyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662AbYF0EyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 00:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbYF0Exz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 00:53:55 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64871 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbYF0Exy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 00:53:54 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5326"; a="4096126"
Message-ID: <48647267.3030606@qualcomm.com>
Date: Thu, 26 Jun 2008 21:53:59 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: ego@in.ibm.com
CC: Paul Menage <menage@google.com>, Vegard Nossum <vegard.nossum@gmail.com>,
       Paul Jackson <pj@sgi.com>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [RFC][PATCH] CPUSets: Move most calls to	rebuild_sched_domains()
 to the workqueue
References: <48634BC1.8@google.com> <20080627032228.GA3419@in.ibm.com> <20080627032317.GB3419@in.ibm.com>
In-Reply-To: <20080627032317.GB3419@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gautham R Shenoy wrote:
> On Fri, Jun 27, 2008 at 08:52:28AM +0530, Gautham R Shenoy wrote:
>> On Thu, Jun 26, 2008 at 12:56:49AM -0700, Paul Menage wrote:
>>> CPUsets: Move most calls to rebuild_sched_domains() to the workqueue
>>>
>>> In the current cpusets code the lock nesting between cgroup_mutex and
>>> cpuhotplug.lock when calling rebuild_sched_domains is inconsistent -
>>> in the CPU hotplug path cpuhotplug.lock nests outside cgroup_mutex,
>>> and in all other paths that call rebuild_sched_domains() it nests
>>> inside.
>>>
>>> This patch makes most calls to rebuild_sched_domains() asynchronous
>>> via the workqueue, which removes the nesting of the two locks in that
>>> case. In the case of an actual hotplug event, cpuhotplug.lock nests
>>> outside cgroup_mutex as now.
>>>
>> Using a multithreaded workqueue(kevent here) for this is not such a
>> great idea this,since currently we cannot call
>> get_online_cpus() from a workitem executed by a multithreaded workqueue.
>>
>> Can one use a single threaded workqueue here instead ?
We could certainly do it in the single threaded workqueue. It won't help to
avoid circular locking dependencies though.
Did you get a chance to read entire thread on this topic ? There were some
questions that you might be able to answer.

Max
