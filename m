Return-Path: <linux-kernel-owner+w=401wt.eu-S1761140AbYDNOng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761140AbYDNOng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761095AbYDNOnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:43:08 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:37191 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761021AbYDNOnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:43:07 -0400
Message-ID: <48036CF4.7050008@linux.vnet.ibm.com>
Date: Mon, 14 Apr 2008 20:10:52 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Balaji Rao <balajirrao@gmail.com>, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, menage@google.com, balbir@in.ibm.com,
       dhaval@linux.vnet.ibm.com
Subject: Re: [RFC][-mm] [2/2] Simple stats for memory resource controller
References: <200804052340.02386.balajirrao@gmail.com> <48036CB4.5050700@linux.vnet.ibm.com>
In-Reply-To: <48036CB4.5050700@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> Balaji Rao wrote:
>> This patch implements trivial statistics for the memory resource controller.
>>
>> Signed-off-by: Balaji Rao <balajirrao@gmail.com>
>> CC: Balbir Singh <balbir@linux.vnet.ibm.com>
>> CC: Dhaval Giani <dhaval@linux.vnet.ibm.com>
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index a860765..ca98b21 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -47,6 +47,8 @@ enum mem_cgroup_stat_index {
>>  	 */
>>  	MEM_CGROUP_STAT_CACHE, 	   /* # of pages charged as cache */
>>  	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as rss */
>> +	MEM_CGROUP_STAT_PGPGIN_COUNT,	/* # of pages paged in */
>> +	MEM_CGROUP_STAT_PGPGOUT_COUNT,	/* # of pages paged out */
>>
>>  	MEM_CGROUP_STAT_NSTATS,
>>  };
>> @@ -198,6 +200,13 @@ static void mem_cgroup_charge_statistics(struct mem_cgroup *mem, int flags,
>>  		__mem_cgroup_stat_add_safe(stat, MEM_CGROUP_STAT_CACHE, val);
>>  	else
>>  		__mem_cgroup_stat_add_safe(stat, MEM_CGROUP_STAT_RSS, val);
>> +
>> +	if (charge)
>> +		__mem_cgroup_stat_add_safe(stat,
>> +				MEM_CGROUP_STAT_PGPGIN_COUNT, 1);
>> +	else
>> +		__mem_cgroup_stat_add_safe(stat,
>> +				MEM_CGROUP_STAT_PGPGOUT_COUNT, 1);
>>  }
>>
>>  static struct mem_cgroup_per_zone *
>> @@ -897,6 +906,8 @@ static const struct mem_cgroup_stat_desc {
>>  } mem_cgroup_stat_desc[] = {
>>  	[MEM_CGROUP_STAT_CACHE] = { "cache", PAGE_SIZE, },
>>  	[MEM_CGROUP_STAT_RSS] = { "rss", PAGE_SIZE, },
>> +	[MEM_CGROUP_STAT_PGPGIN_COUNT] = {"pgpgin", 1, },
>> +	[MEM_CGROUP_STAT_PGPGOUT_COUNT] = {"pgpgout", 1, },
>>  };
>>
>>  static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
>>
> 
> Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> Hi, Andrew,
> 
> Could you please include these statistics in -mm.
> 
> Balbir
> 
> 

Andrew,

This should have been addressed to you in the first place. Resending.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
