Return-Path: <linux-kernel-owner+w=401wt.eu-S1756503AbYKPFEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbYKPFEz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 00:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbYKPFEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 00:04:46 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51716 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbYKPFEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 00:04:46 -0500
Message-ID: <491FA920.1030805@cn.fujitsu.com>
Date: Sun, 16 Nov 2008 13:01:20 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, kamezawa.hiroyu@jp.fujitsu.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] memcontrol: use simple_malloc()/simple_free()
References: <491FA2AA.6060706@cn.fujitsu.com> <20081116045128.GB24624@x200.localdomain>
In-Reply-To: <20081116045128.GB24624@x200.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Sun, Nov 16, 2008 at 12:33:46PM +0800, Lai Jiangshan wrote:
>> use simple_malloc()/simple_free() instead of current codes.
> 
> struct mem_cgroup can't reach the size when kmalloc starts failing.

Good catch! Thanx!

compiler will optimize it and select the correct way.
using "simple_malloc()/simple_free()" here is no sense.

> 
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -1062,11 +1062,7 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
>>  {
>>  	struct mem_cgroup *mem;
>>  
>> -	if (sizeof(*mem) < PAGE_SIZE)
>> -		mem = kmalloc(sizeof(*mem), GFP_KERNEL);
>> -	else
>> -		mem = vmalloc(sizeof(*mem));
>> -
>> +	mem = simple_malloc(sizeof(*mem));
>>  	if (mem)
>>  		memset(mem, 0, sizeof(*mem));
>>  	return mem;
>> @@ -1074,10 +1070,7 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
>>  
>>  static void mem_cgroup_free(struct mem_cgroup *mem)
>>  {
>> -	if (sizeof(*mem) < PAGE_SIZE)
>> -		kfree(mem);
>> -	else
>> -		vfree(mem);
>> +	simple_free(mem);
>>  }
> 
> 
> 


