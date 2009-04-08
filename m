Return-Path: <linux-kernel-owner+w=401wt.eu-S1759819AbZDHBAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759819AbZDHBAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 21:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbZDHBAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 21:00:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49349 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbZDHBAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 21:00:36 -0400
Message-ID: <49DBF653.7070101@cn.fujitsu.com>
Date: Wed, 08 Apr 2009 08:56:51 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Menage <menage@google.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-MM <linux-mm@kvack.org>, Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 0/3] cpuset,mm: fix memory spread bug
References: <49DB306A.8070407@cn.fujitsu.com> <alpine.DEB.1.10.0904071703340.12192@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0904071703340.12192@qirst.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2009-4-8 5:04 Christoph Lameter wrote:
> Interesting patch set but I cannot find parts 2 and 3. The locking changes
> get rid of the generation scheme in cpusets which is a good thing if it
> works right.

Sorry for the late reply and my mistake. The following URLs is the patches'
address.

patch 1: restructure the function cpuset_update_task_memory_state()
http://marc.info/?l=linux-kernel&m=123910183705576&w=2

patch 2: update tasks' page/slab spread flags in time
http://marc.info/?l=linux-kernel&m=123910199505770&w=2

patch 3: update tasks' mems_allowed in time
http://marc.info/?l=linux-mm&m=123910199605776&w=2

Thanks
Miao

> 
> On Tue, 7 Apr 2009, Miao Xie wrote:
> 
>> The kernel still allocated the page caches on old node after modifying its
>> cpuset's mems when 'memory_spread_page' was set, or it didn't spread the page
>> cache evenly over all the nodes that faulting task is allowed to usr after
>> memory_spread_page was set. it is caused by the old mem_allowed and flags
>> of the task, the current kernel doesn't updates them unless some function
>> invokes cpuset_update_task_memory_state(), it is too late sometimes.We must
>> update the mem_allowed and the flags of the tasks in time.
>>
>> Slab has the same problem.
>>
>> The following patches fix this bug by updating tasks' mem_allowed and spread
>> flag after its cpuset's mems or spread flag is changed.
>>
>> patch 1: restructure the function cpuset_update_task_memory_state()
>> patch 2: update tasks' page/slab spread flags in time
>> patch 3: update tasks' mems_allowed in time
>>
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>>
> 
> 
> 


