Return-Path: <linux-kernel-owner+w=401wt.eu-S1762967AbYB0XxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762967AbYB0XxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:53:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758811AbYB0Xw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:52:58 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8900 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772AbYB0Xw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:52:57 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5239"; a="857436"
Message-ID: <47C5F7D6.2000203@qualcomm.com>
Date: Wed, 27 Feb 2008 15:52:54 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Rostedt <rostedt@goodmis.org>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 2/4] cpuset: system sets
References: <20080227222103.673194000@chello.nl> <20080227222542.311184000@chello.nl>
In-Reply-To: <20080227222542.311184000@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, shouldn't patches be sent inline ?
Otherwise I need to cut&paste in order to reply.

Anyway. cpu_system_map looks fine. It's identical in functionality (minus the 
notifier) to the ~cpu_isolated_map. Different name works for me.

As I explained in the prev reply I suggest we use CPU hotplug instead of the 
brand new notifier mechanism that requires changes to a bunch of things, and 
at the end of the day ends up doing the same exact thing. ie Moving things out 
of the CPU that is being isolated.

> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -4854,6 +4854,9 @@ asmlinkage long sys_sched_setaffinity(pi
>  cpumask_t cpu_present_map __read_mostly;
>  EXPORT_SYMBOL(cpu_present_map);
>  
> +cpumask_t cpu_system_map __read_mostly = CPU_MASK_ALL;
> +EXPORT_SYMBOL(cpu_system_map);
> +
>  #ifndef CONFIG_SMP
>  cpumask_t cpu_online_map __read_mostly = CPU_MASK_ALL;
>  EXPORT_SYMBOL(cpu_online_map);

I beleive those masks belong in kernel/cpu.c instead of kernel/sched.c.
It can be done with a separate patch of course.

Max





