Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab0CIB3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 20:29:15 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55507 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755513Ab0CIB3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 20:29:12 -0500
Message-ID: <4B95A462.2040201@cn.fujitsu.com>
Date: Tue, 09 Mar 2010 09:29:06 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Nick Piggin <npiggin@suse.de>, Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Paul Menage <menage@google.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 3/4] cpuset: alloc nodemask_t at heap not stack
References: <4B94CC6D.2070502@cn.fujitsu.com> <alpine.DEB.2.00.1003081324550.14689@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1003081324550.14689@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2010-3-9 5:27, David Rientjes wrote:
> On Mon, 8 Mar 2010, Miao Xie wrote:
> 
>> Changes from V1 to V2:
>> - None
>>
> 
> Both this and patch 2/4 are already in -mm, so please rebase this series 
> on mmotm-2010-03-04-18-05.

ok, I'll do it.

> 
>> @@ -1381,39 +1394,46 @@ static void cpuset_attach(struct cgroup_subsys *ss, struct cgroup *cont,
>>  			  struct cgroup *oldcont, struct task_struct *tsk,
>>  			  bool threadgroup)
>>  {
>> -	nodemask_t from, to;
>>  	struct mm_struct *mm;
>>  	struct cpuset *cs = cgroup_cs(cont);
>>  	struct cpuset *oldcs = cgroup_cs(oldcont);
>> +	NODEMASK_ALLOC(nodemask_t, from, GFP_KERNEL);
>> +	NODEMASK_ALLOC(nodemask_t, to, GFP_KERNEL);
>> +
>> +	if (from == NULL || to == NULL)
>> +		return;
>>  
> 
> You're potentially leaking one of the allocated nodemasks there if the 
> other is -ENOMEM.

Sorry for my mistake. I'll fix it in the next version.

Thanks!
Miao

> 
> 
> 


