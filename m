Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbZGCIiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbZGCIiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZGCIiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:38:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62533 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbZGCIiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:38:04 -0400
Message-ID: <4A4DC358.7030900@cn.fujitsu.com>
Date: Fri, 03 Jul 2009 16:37:44 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] cgroup: Fix indent for /proc/cgroups
References: <4A4DBBC2.8010805@cn.fujitsu.com> <4A4DBF50.8090408@cn.fujitsu.com>
In-Reply-To: <4A4DBF50.8090408@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> CC: container list
> 
> Gui Jianfeng wrote:
>> Currently, /proc/cgroups outputs is fairly ugly as following,
>> #subsys_name    hierarchy       num_cgroups     enabled
>> cpuset  0       1       1
>> debug   0       1       1
>> ns      0       1       1
>>
>> indent it in a good-looking way.
>> #subsys_name    hierarchy       num_cgroups     enabled
>> cpuset          0               1               1
>> debug           0               1               1
>> ns              0               1               1
>>
> 
> But if there's a subsystem with name length >= 8,
> it won't be aligned properly..

  Yeap, but there isn't such a case at least by now.

> 
>> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
>> ---
>>  kernel/cgroup.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>> index 3737a68..99fc160 100644
>> --- a/kernel/cgroup.c
>> +++ b/kernel/cgroup.c
>> @@ -2963,7 +2963,7 @@ static int proc_cgroupstats_show(struct seq_file *m, void *v)
>>  	mutex_lock(&cgroup_mutex);
>>  	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
>>  		struct cgroup_subsys *ss = subsys[i];
>> -		seq_printf(m, "%s\t%lu\t%d\t%d\n",
>> +		seq_printf(m, "%s\t\t%lu\t\t%d\t\t%d\n",
>>  			   ss->name, ss->root->subsys_bits,
>>  			   ss->root->number_of_cgroups, !ss->disabled);
>>  	}
> 
> 
> 
> 

-- 
Regards
Gui Jianfeng

