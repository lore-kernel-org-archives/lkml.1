Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbYC1KPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbYC1KPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 06:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbYC1KPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 06:15:38 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:39692 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870AbYC1KPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 06:15:37 -0400
Message-ID: <47ECC45F.3020005@linux.vnet.ibm.com>
Date: Fri, 28 Mar 2008 15:41:43 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>,
       Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm] Add an owner to the mm_struct (v2)
References: <20080328082316.6961.29044.sendpatchset@localhost.localdomain> <47ECBD4A.8080908@gmail.com> <47ECBDAF.9070007@gmail.com>
In-Reply-To: <47ECBDAF.9070007@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 03/28/2008 10:41 AM, Jiri Slaby wrote:
>>> linux-2.6.25-rc5/include/linux/mm_types.h~memory-controller-add-mm-owner   
>>> 2008-03-28 09:30:47.000000000 +0530
>>> +++ linux-2.6.25-rc5-balbir/include/linux/mm_types.h    2008-03-28
>>> 12:26:59.000000000 +0530
>>> @@ -227,8 +227,10 @@ struct mm_struct {
>>>      /* aio bits */
>>>      rwlock_t        ioctx_list_lock;
>>>      struct kioctx        *ioctx_list;
>>> -#ifdef CONFIG_CGROUP_MEM_RES_CTLR
>>> -    struct mem_cgroup *mem_cgroup;
>>> +#ifdef CONFIG_MM_OWNER
>>> +    spinlock_t owner_lock;
>>> +    struct task_struct *owner;    /* The thread group leader that */
>>
>> Doesn't make sense to switch them (spinlock is unsigned int on x86,
>> what's sizeof between and after?)?
> 
> Hmm, doesn't matter, there is another pointer after it, ignore me.

OK :)

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
