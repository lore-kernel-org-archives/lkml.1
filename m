Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab0BXJg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 04:36:29 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64630 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755072Ab0BXJg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 04:36:28 -0500
Message-ID: <4B84F2FD.6030605@cn.fujitsu.com>
Date: Wed, 24 Feb 2010 17:35:57 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [regression] cpuset,mm: update tasks' mems_allowed in time (58568d2)
References: <20100218134921.GF9738@laptop> <alpine.DEB.2.00.1002181302430.13707@chino.kir.corp.google.com> <20100219033126.GI9738@laptop> <alpine.DEB.2.00.1002190143040.6293@chino.kir.corp.google.com> <4B827043.3060305@cn.fujitsu.com> <alpine.DEB.2.00.1002221339160.14426@chino.kir.corp.google.com> <4B838490.1050908@cn.fujitsu.com> <alpine.DEB.2.00.1002230046160.12015@chino.kir.corp.google.com> <4B839E9D.8020604@cn.fujitsu.com> <alpine.DEB.2.00.1002231427190.8693@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1002231427190.8693@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2010-2-24 6:31, David Rientjes wrote:
> On Tue, 23 Feb 2010, Miao Xie wrote:
> 
>>> Cpu hotplug sets top_cpuset's cpus_allowed to cpu_active_mask by default, 
>>> regardless of what was onlined or offlined.  cpus_attach in the context of 
>>> your patch (in cpuset_attach()) passes cpu_possible_mask to 
>>> set_cpus_allowed_ptr() if the task is being attached to top_cpuset, my 
>>> question was why don't we pass cpu_active_mask instead?  In other words, I 
>>> think we should do
>>>
>>> 	cpumask_copy(cpus_attach, cpu_active_mask);
>>>
>>> when attached to top_cpuset like my patch did.
>>
>> If we pass cpu_active_mask to set_cpus_allowed_ptr(), task->cpus_allowed just contains
>> the online cpus. In this way, if we do cpu hotplug(such as: online some cpu), we must
>> update cpus_allowed of all tasks in the top cpuset.
>>
>> But if we pass cpu_possible_mask, we needn't update cpus_allowed of all tasks in the
>> top cpuset. And when the kernel looks for a cpu for task to run, the kernel will use
>> cpu_active_mask to filter out offline cpus in task->cpus_allowed. Thus, it is safe.
>>
> 
> That is terribly inconsistent between top_cpuset and all descendants; all 
> other cpusets require that task->cpus_allowed be a subset of 
> cpu_online_mask, including those descendants that allow all cpus (and all 
> mems).
 
I think it is not a big deal because it is safe and doesn't cause any problem.
Beside that, task->cpus_allowed is initialized to cpu_possible_mask on the no-cpuset
kernel, so using cpu_possible_mask to initialize task->cpus_allowed is reasonable.
(top cpuset is a special cpuset, isn't it?)
 


