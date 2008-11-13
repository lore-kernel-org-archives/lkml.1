Return-Path: <linux-kernel-owner+w=401wt.eu-S1753223AbYKMBfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbYKMBfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 20:35:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbYKMBfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 20:35:10 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:53346 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbYKMBfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 20:35:09 -0500
Message-ID: <491B8423.3080304@linux.vnet.ibm.com>
Date: Thu, 13 Nov 2008 07:04:27 +0530
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
 (v3)
References: <20081111123314.6566.54133.sendpatchset@balbir-laptop> <20081111123448.6566.55973.sendpatchset@balbir-laptop> <491B82B7.5030002@cn.fujitsu.com>
In-Reply-To: <491B82B7.5030002@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
>> +	/*
>> +	 * If parent's use_hiearchy is set, we can't make any modifications
>> +	 * in the child subtrees. If it is unset, then the change can
>> +	 * occur, provided the current cgroup has no children.
>> +	 *
>> +	 * For the root cgroup, parent_mem is NULL, we allow value to be
>> +	 * set if there are no children.
>> +	 */
>> +	if (!parent_mem || (!parent_mem->use_hierarchy &&
>> +				(val == 1 || val == 0))) {
>> +		if (list_empty(&cont->children))
>> +			mem->use_hierarchy = val;
>> +		else
>> +			retval = -EBUSY;
>> +	} else
>> +		retval = -EINVAL;
>> +
>> +	return retval;
>> +}
> 
> As I mentioned there is a race here. :(
> 
> echo 1 > /memcg/memory.use_hierarchy
>  =>if (list_empty(&cont->children))
>                                       mkdir /memcg/0
>                                        => mem->use_hierarchy = 0
>        mem->use_hierarchy = 1;
> 

Hi, Li,

I thought I had the cgroup_lock() around that check, but I seemed to have missed
it. I'll fix that in v4.

-- 
	Balbir
