Return-Path: <linux-kernel-owner+w=401wt.eu-S1759550AbYB0X5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759550AbYB0X5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbYB0X5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:57:23 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37443 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbYB0X5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:57:22 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5239"; a="857650"
Message-ID: <47C5F8E0.3060708@qualcomm.com>
Date: Wed, 27 Feb 2008 15:57:20 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Rostedt <rostedt@goodmis.org>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 1/4] sched: remove isolcpus
References: <20080227222103.673194000@chello.nl> <20080227222542.056473000@chello.nl>
In-Reply-To: <20080227222542.056473000@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:

> cpu isolation doesn't offer anything over cpusets, hence remove it.

Works for me. That's what I suggested in my reply to your comments.
Here is the quote from the previous thread:

>>>> This also allows for isolated groups, there are good reasons to isolate groups,
>>>> esp. now that we have a stronger RT balancer. SMP and hard RT are not
>>>> exclusive. A design that does not take that into account is too rigid.
>> 
>>> You're thinking scheduling only. Paul had the same confusion ;-)
>> 
>> I'm not, I'm thinking it ought to allow for it.
> One way I can think of how to support groups and allow for RT balancer is 
> this: Make scheduler ignore cpu_isolated_map and give cpusets full control of 
> the scheduler domains. Use cpu_isolated_map to only for hw irq and other 
> kernel sub-systems. That way cpusets could mark cpus in the group as isolated 
> to get rid of the  kernel activity and build sched domain such that tasks get 
> balanced in it.
> The thing I do not like about it is that there is no way to boot the system 
> with CPU N isolated from the beginning. Also dynamic isolation currently 
> relies on the cpu hotplug to clear pending irqs, softirqs, kernel timers and 
> threads. So cpusets would have to simulate the cpu hotplug event I guess.

Max

