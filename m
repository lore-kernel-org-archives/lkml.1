Return-Path: <linux-kernel-owner+w=401wt.eu-S1761070AbYDCRRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761070AbYDCRRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 13:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762243AbYDCRPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 13:15:39 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:59719 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760037AbYDCRPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 13:15:37 -0400
Message-ID: <47F5109D.8060606@linux.vnet.ibm.com>
Date: Thu, 03 Apr 2008 22:45:09 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Pavel Emelianov <xemul@openvz.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm] Add an owner to the mm_struct (v6)
References: <20080403073043.3563.63717.sendpatchset@localhost.localdomain> <6599ad830804030845m71d56d88u3508a252fc134ba5@mail.gmail.com>
In-Reply-To: <6599ad830804030845m71d56d88u3508a252fc134ba5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Thu, Apr 3, 2008 at 12:30 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>  +         This option enables mm_struct's to have an owner. The advantage
>>  +         of this approach is that it allows for several independent memory
>>  +         based cgorup controllers to co-exist independently without too
> 
> cgorup -> cgroup
> 

yes, typo

>>  +       if (need_mm_owner_callback) {
>>  +               int i;
>>  +               for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
>>  +                       struct cgroup_subsys *ss = subsys[i];
>>  +                       oldcgrp = task_cgroup(old, ss->subsys_id);
>>  +                       newcgrp = task_cgroup(new, ss->subsys_id);
>>  +                       if (oldcgrp == newcgrp)
>>  +                               continue;
>>  +                       if (ss->mm_owner_changed)
>>  +                               ss->mm_owner_changed(ss, oldcgrp, newcgrp);
> 
> Even better, maybe just pass in the relevant cgroup_subsys_state
> objects here, rather than the cgroup objects?
> 

Is that better than passing the cgroups? All the callbacks I see usually pass
either task_struct or cgroup. Won't it be better, consistent use of API to pass
either of those?

>>         css_get(&mem->css);
>>  -       rcu_assign_pointer(mm->mem_cgroup, mem);
>>         css_put(&old_mem->css);
> 
> These get/put calls are now unwanted?
> 

Yes, will remove them

> Could you also add comments in mm_need_new_owner(), in particular the
> reason for checking for delay_group_leader() ?

Yep, will do

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
