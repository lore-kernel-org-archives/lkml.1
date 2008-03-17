Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbYCQC65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbYCQC65 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 22:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbYCQC6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 22:58:48 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:45995 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbYCQC6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 22:58:48 -0400
Message-ID: <47DDDE0B.4010809@linux.vnet.ibm.com>
Date: Mon, 17 Mar 2008 08:27:15 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: linux-mm@kvack.org, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][2/3] Account and control virtual address space allocations
References: <20080316172942.8812.56051.sendpatchset@localhost.localdomain> <20080316173005.8812.88290.sendpatchset@localhost.localdomain> <6599ad830803161902r8f9a274t246a25b3d337fee8@mail.gmail.com>
In-Reply-To: <6599ad830803161902r8f9a274t246a25b3d337fee8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Mon, Mar 17, 2008 at 1:30 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>   /*
>>  + * Check if the current cgroup exceeds its address space limit.
>>  + * Returns 0 on success and 1 on failure.
>>  + */
>>  +int mem_cgroup_update_as(struct mm_struct *mm, long nr_pages)
>>  +{
>>  +       int ret = 0;
>>  +       struct mem_cgroup *mem;
>>  +       if (mem_cgroup_subsys.disabled)
>>  +               return ret;
>>  +
>>  +       rcu_read_lock();
>>  +       mem = rcu_dereference(mm->mem_cgroup);
>>  +       css_get(&mem->css);
>>  +       rcu_read_unlock();
>>  +
> 
> How about if this function avoided charging the root cgroup? You'd
> save 4 atomic operations on a global data structure on every
> mmap/munmap when the virtual address limit cgroup wasn't in use, which
> could be significant on a large system. And I don't see situations
> where you really need to limit the address space of the root cgroup.

4 atomic operations is very tempting, but we want to account for root usage due
to the following reasons:

1. We want to be able to support hierarchial accounting and control
2. We want to track usage of the root cgroup and report it back to the user
3. We don't want to treat the root cgroup as a special case.



-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
