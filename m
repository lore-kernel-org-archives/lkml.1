Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbYCLUJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbYCLUJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 16:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbYCLUI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 16:08:59 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18118 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbYCLUI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 16:08:58 -0400
X-IronPort-AV: E=McAfee;i="5100,188,5250"; a="1250710"
Message-ID: <47D83858.4030806@qualcomm.com>
Date: Wed, 12 Mar 2008 13:08:56 -0700
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: menage@google.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: boot cgroup questions
References: <47D73086.2030008@qualcomm.com>	<6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>	<47D7411E.1000009@qualcomm.com>	<6599ad830803111936jd940deam8584bc971c3b6f41@mail.gmail.com>	<47D74595.4080100@qualcomm.com>	<6599ad830803112009y18d9e43ft8e3fc4a551d891da@mail.gmail.com>	<20080311235939.1ebee8e3.pj@sgi.com>	<47D81FE1.6030205@qualcomm.com>	<20080312135746.89456f2a.pj@sgi.com>	<47D82AD2.1070108@qualcomm.com> <20080312143253.3dd72c7f.pj@sgi.com>
In-Reply-To: <20080312143253.3dd72c7f.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Max wrote:
>> I was talking about running on the _cpus_ that belong to the "sets A and B but 
>> not C" and not that a task must belong to more than one cpuset.
> 
> This doesn't make sense to me.
> 
> If a task is to run on the CPUs in both sets A and B, then it has to be
> in both those cpusets, which isn't allowed, or in some super set of both
> A and B (that is, in this example, in the top cpuset), which doesn't
> restrict the task to just A or B or their union.
> 
> I have no idea what distinction you are seeing between what _cpus_ a task
> can run on, and what cpuset it belongs to.

Paul, we are in 100% agreement here about the tasks. All I'm saying is that 
the same exact thing applies to the irqs. Again let me try your example.

Suppose we have
	/dev/cpuset/A
	/dev/cpuset/B
	/dev/cpuset/C

Now suppose that for whatever reason I must run task1 on the cpus that belong 
to sets A and B but not C. The only way to do that with cpusets is

	/dev/cpuset/X
         	  |-- A
	          `-- B
	/dev/cpuset/C

i.e. create parent cpuset X and assign task1 into cpuset X.
Of course if A and B are not cpu_exclusive then X does not have to be their 
parent.

Makes sense so far ?

Now the same exact thing can be said about the irqs. If I need to assign irq1 
to the cpus in sets A and B but not C I have to create set X that is the union 
of A and B, and assign irq1 to the set X.

This is what I meant by "deeper hierarchies" in the earlier emails.

Did I do a better job explaining this time :) ?

Max






