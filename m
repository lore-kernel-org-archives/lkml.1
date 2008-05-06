Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbYEFDpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbYEFDpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 23:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbYEFDow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 23:44:52 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:52794 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbYEFDov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 23:44:51 -0400
Message-ID: <481FD3FC.4010407@linux.vnet.ibm.com>
Date: Tue, 06 May 2008 09:13:56 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, skumar@linux.vnet.ibm.com, yamamoto@valinux.co.jp,
       menage@google.com, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       rientjes@google.com, xemul@openvz.org, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [-mm][PATCH 2/4] Enhance cgroup mm_owner_changed callback to
 add task information
References: <20080503213726.3140.68845.sendpatchset@localhost.localdomain> <20080503213804.3140.26503.sendpatchset@localhost.localdomain> <20080505151504.98c28f7c.akpm@linux-foundation.org>
In-Reply-To: <20080505151504.98c28f7c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sun, 04 May 2008 03:08:04 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>>
>> This patch adds an additional field to the mm_owner callbacks. This field
>> is required to get to the mm that changed.
>>
>> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
>> ---
>>
>>  include/linux/cgroup.h |    3 ++-
>>  kernel/cgroup.c        |    2 +-
>>  2 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff -puN kernel/cgroup.c~cgroup-add-task-to-mm--owner-callbacks kernel/cgroup.c
>> --- linux-2.6.25/kernel/cgroup.c~cgroup-add-task-to-mm--owner-callbacks	2008-05-04 02:53:05.000000000 +0530
>> +++ linux-2.6.25-balbir/kernel/cgroup.c	2008-05-04 02:53:05.000000000 +0530
>> @@ -2772,7 +2772,7 @@ void cgroup_mm_owner_callbacks(struct ta
>>  			if (oldcgrp == newcgrp)
>>  				continue;
>>  			if (ss->mm_owner_changed)
>> -				ss->mm_owner_changed(ss, oldcgrp, newcgrp);
>> +				ss->mm_owner_changed(ss, oldcgrp, newcgrp, new);
>>  		}
>>  	}
>>  }
>> diff -puN include/linux/cgroup.h~cgroup-add-task-to-mm--owner-callbacks include/linux/cgroup.h
>> --- linux-2.6.25/include/linux/cgroup.h~cgroup-add-task-to-mm--owner-callbacks	2008-05-04 02:53:05.000000000 +0530
>> +++ linux-2.6.25-balbir/include/linux/cgroup.h	2008-05-04 02:53:05.000000000 +0530
>> @@ -310,7 +310,8 @@ struct cgroup_subsys {
>>  	 */
>>  	void (*mm_owner_changed)(struct cgroup_subsys *ss,
>>  					struct cgroup *old,
>> -					struct cgroup *new);
>> +					struct cgroup *new,
>> +					struct task_struct *p);
> 
> If mm_owner_changed() had any documentation I'd suggest that it be updated.
> Sneaky.
> 

No, there's no documentation besides the comments. I'll go ahead and update
cgroups.txt with some documentation.

> The existing comment:
> 
> 	/*
> 	 * This routine is called with the task_lock of mm->owner held
> 	 */
> 	void (*mm_owner_changed)(struct cgroup_subsys *ss,
> 					struct cgroup *old,
> 					struct cgroup *new);
> 
> Is rather mysterious.  To what mm does it refer?

This callback is called when the mm->owner field that points to/owns a cgroup
changes as a result of the owner exiting.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
