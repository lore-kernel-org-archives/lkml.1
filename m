Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbYKHJuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbYKHJuU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 04:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbYKHJuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 04:50:05 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:37425 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbYKHJuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 04:50:04 -0500
Message-ID: <491560C0.50400@linux.vnet.ibm.com>
Date: Sat, 08 Nov 2008 15:19:52 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080715)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: linux-mm@kvack.org, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][mm] [PATCH 4/4] Memory cgroup hierarchy feature selector
 (v2)
References: <20081108091009.32236.26177.sendpatchset@localhost.localdomain> <20081108091113.32236.12390.sendpatchset@localhost.localdomain> <49155E45.3030704@cn.fujitsu.com>
In-Reply-To: <49155E45.3030704@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
>> +static int mem_cgroup_hierarchy_write(struct cgroup *cont, struct cftype *cft,
>> +					u64 val)
>> +{
>> +	int retval = 0;
>> +	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
>> +
>> +	if (val == 1) {
>> +		if (list_empty(&cont->children))
> 
> cgroup_lock should be held before checking cont->children.
> 

Good point, I'll look at that aspect

>> +			mem->use_hierarchy = val;
>> +		else
>> +			retval = -EBUSY;
>> +	} else if (val == 0) {
> 
> And code duplicate.

Yes, this can be optimized better. I'll fix that in v3.

> 
>> +		if (list_empty(&cont->children))
>> +			mem->use_hierarchy nn= val;
>> +		else
>> +			retval = -EBUSY;
>> +	} else
>> +		retval = -EINVAL;
>> +
>> +	return retval;
>> +}
>> +
> 


-- 
	Balbir
