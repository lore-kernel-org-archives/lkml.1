Return-Path: <linux-kernel-owner+w=401wt.eu-S1761274AbYB1RsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761274AbYB1RsX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 12:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754189AbYB1RsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 12:48:14 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1434 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbYB1RsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 12:48:13 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5240"; a="979321"
Message-ID: <47C6F3DB.8070309@qualcomm.com>
Date: Thu, 28 Feb 2008 09:48:11 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/4] CPUSET driven CPU isolation
References: <20080227222103.673194000@chello.nl> <20080228075010.GA28781@elte.hu>
In-Reply-To: <20080228075010.GA28781@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
>> My vision on the direction we should take wrt cpu isolation.
>>
>> Next on the list would be figuring out a nice solution to the 
>> workqueue flush issue.
> 
> nice work Peter, i find this "system sets" extension to cpusets a much 
> more elegant (and much more future-proof) solution than the proposed 
> spreadout of the limited hack of isolcpus/cpu_isolated_map. It 
> concentrates us on a single API and on a single mechanism to handle 
> isolation matters. (be that for clustering/supercomputing or real-time 
> purposes)
Come on Ingo. You make it sounds like it's radically different solution.
At the end of the day we have a bitmap that represents which CPUs can be used 
for the kernel stuff. How is that different ?
I was saying all along that cpusets is a higher level API and was discussing 
or trying to discuss (people were ignoring my questions) ways to integrate it.

> Thanks for insisting on using cpusets for this!
> 
> i've queued up your patches in sched-devel.git, and lets make sure this 
> has no side-effects on existing functionality. (it shouldnt)
Hmm, that was easy. Not a single ack. Even the core part is not complete yet. 
I pointed out several issues. Like the fact that it does not provide full 
isolation because it does not move timers, does not handle workqueues.
I did not even get a chance to test this stuff properly and see if it actually 
solves the usecase I was solving with my patches.
_Obviously_ we could not have taken my tested solution and evolved it in the 
direction people wanted to see it evolve, ie integration with the cpusets :(.

My main concern is that it introduces a whole new set of notifiers that 
perform similar functions to what CPU hotplut already does.

Max
