Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbYCRBRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbYCRBRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 21:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbYCRBRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 21:17:45 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:52177 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbYCRBRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 21:17:44 -0400
Message-ID: <47DF1760.9030908@linux.vnet.ibm.com>
Date: Tue, 18 Mar 2008 06:44:08 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Dave Hansen <haveblue@us.ibm.com>
CC: linux-mm@kvack.org, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][2/3] Account and control virtual address space allocations
References: <20080316172942.8812.56051.sendpatchset@localhost.localdomain> <20080316173005.8812.88290.sendpatchset@localhost.localdomain> <1205772790.18916.17.camel@nimitz.home.sr71.net>
In-Reply-To: <1205772790.18916.17.camel@nimitz.home.sr71.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Sun, 2008-03-16 at 23:00 +0530, Balbir Singh wrote:
>> @@ -787,6 +788,8 @@ static int ptrace_bts_realloc(struct tas
>>         current->mm->total_vm  -= old_size;
>>         current->mm->locked_vm -= old_size;
>>  
>> +       mem_cgroup_update_as(current->mm, -old_size);
>> +
>>         if (size == 0)
>>                 goto out;
> 
> I think splattering these things all over is probably a bad idea.
> 

I agree and I tried to avoid the splattering

> If you're going to do this, I think you need a couple of phases.  
> 
> 1. update the vm_(un)acct_memory() functions to take an mm

There are other problems

1. vm_(un)acct_memory is conditionally dependent on VM_ACCOUNT. Look at
shmem_(un)acct_size for example
2. These routines are not called from all contexts that we care about (look at
insert_special_mapping())

> 2. start using them (or some other abstracted functions in place)
> 3. update the new functions for cgroups
> 
> It's a bit non-obvious why you do the mem_cgroup_update_as() calls in
> the places that you do from context.
> 
> Having some other vm-abstracted functions will also keep you from
> splattering mem_cgroup_update_as() across the tree.  That's a pretty bad
> name. :)  ...update_mapped() or ...update_vm() might be a wee bit
> better. 
> 

I am going to split mem_cgroup_update_as() to two routines with a better name. I
agree with you in principle about splattering, but please see my comments above

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
