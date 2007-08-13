Return-Path: <linux-kernel-owner+w=401wt.eu-S945417AbXHMMfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S945417AbXHMMfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932194AbXHMHDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 03:03:46 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:60900 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933460AbXHMHDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 03:03:43 -0400
Message-ID: <46BFEE72.9080209@linux.vnet.ibm.com>
Date: Mon, 13 Aug 2007 11:08:58 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
CC: akpm@linux-foundation.org, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, ebiederm@xmission.com, containers@lists.osdl.org,
       menage@google.com, xemul@openvz.org
Subject: Re: [-mm PATCH 8/9] Memory controller add switch to control what
 type of pages to limit (v4)
References: <20070727201103.31565.3104.sendpatchset@balbir-laptop> <20070813003348.91E3E1BF943@siro.lan>
In-Reply-To: <20070813003348.91E3E1BF943@siro.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

YAMAMOTO Takashi wrote:
>> Choose if we want cached pages to be accounted or not. By default both
>> are accounted for. A new set of tunables are added.
>>
>> echo -n 1 > mem_control_type
>>
>> switches the accounting to account for only mapped pages
>>
>> echo -n 2 > mem_control_type
>>
>> switches the behaviour back
> 
> MEM_CONTAINER_TYPE_ALL is 3, not 2.
> 

Thanks, I'll fix the comment on the top.

> YAMAMOTO Takashi
> 
>> +enum {
>> +	MEM_CONTAINER_TYPE_UNSPEC = 0,
>> +	MEM_CONTAINER_TYPE_MAPPED,
>> +	MEM_CONTAINER_TYPE_CACHED,
>> +	MEM_CONTAINER_TYPE_ALL,
>> +	MEM_CONTAINER_TYPE_MAX,
>> +} mem_control_type;
>> +
>> +static struct mem_container init_mem_container;
> 
>> +	mem = rcu_dereference(mm->mem_container);
>> +	if (mem->control_type == MEM_CONTAINER_TYPE_ALL)
>> +		return mem_container_charge(page, mm);
>> +	else
>> +		return 0;


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
