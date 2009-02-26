Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbZBZH62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbZBZH62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 02:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbZBZH6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 02:58:19 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51848 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbZBZH6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 02:58:18 -0500
Message-ID: <49A64BAA.7050401@cn.fujitsu.com>
Date: Thu, 26 Feb 2009 15:58:34 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] cpuset: cleanups and fixes
References: <49A63E77.9060603@cn.fujitsu.com> <20090226163954.db4af9fc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090226163954.db4af9fc.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Thu, 26 Feb 2009 15:02:15 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> This patchset mainly simplifies update_tasks_nodemask() and makes it
>> return void (won't fail), thus fix a case that writing to cpuset.mems
>> returns -ENOMEM but its mems_allowed has been changed.
>>
>> [PATCH 1/4] cgroups: add 'data' field to struct cgroup_scanner
>> [PATCH 2/4] cpuset: rewrite update_tasks_nodemask()
>> [PATCH 3/4] cpuset: avoid changing cpuset's mems when errno returned
>> [PATCH 4/4] cpuset: remove struct cpuset_hotplug_scanner
>>
> Thank you. I think there is no problematic in your patch.
> 
> After reading your patch, I wonder we can improve this migration by
> filter for cgroup_scan_tasks().
> 
> Assume a task with tons of threads in a cgroup and
>   - change nodemask
>   - migrate=1
> 
> Under current implemntation, cpuset_migrate_mm=>do_migrate_mm is called per
> threads. This implies there will be big overhead, useless scanning of page
> tables.
> 
> Can we add some checks as "Is this mm already migrated ?", anywhere ?
> (we may need to add some another array, again...)
> 

cpuset's memory_migrate flag is disabled by default, and I guess migrating mm
in cpuset is not frequently used? I tend to not optimise it unless it becomes
a problem in real-life. :)



