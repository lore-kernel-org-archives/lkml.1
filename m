Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbYLSAyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbYLSAyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 19:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbYLSAym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 19:54:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56297 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbYLSAym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 19:54:42 -0500
Message-ID: <494AF085.3000802@cn.fujitsu.com>
Date: Fri, 19 Dec 2008 08:53:25 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Bharata B Rao <bharata.rao@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       libcg-devel <libcg-devel@lists.sourceforge.net>
Subject: Re: [BUG][PANIC] cgroup panics with mmotm for 2.6.28-rc7
References: <20081215113253.GL18403@balbir.in.ibm.com> <6599ad830812151757t5362ae16y81b469b06022135c@mail.gmail.com> <49471540.8090304@cn.fujitsu.com> <4947183C.6010606@cn.fujitsu.com> <20081218191839.GI26572@balbir.in.ibm.com>
In-Reply-To: <20081218191839.GI26572@balbir.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> kernel BUG at kernel/cgroup.c:392!
>> In latest -mm, this BUG_ON is line 398, and before the below 2 fixlet patches,
>> the BUG_ON is line 392, so I guess you were using older -mm:
>>
>> cgroups-add-inactive-subsystems-to-rootnodesubsys_list-fix.patch
>> cgroups-introduce-link_css_set-to-remove-duplicate-code-fix.patch
>>
>> Could you try the latest -mm kernel, or apply
>> cgroups-add-inactive-subsystems-to-rootnodesubsys_list-fix.patch ?
>>
>> diff -puN kernel/cgroup.c~cgroups-add-inactive-subsystems-to-rootnodesubsys_list-fix kernel/cgroup.c
>> --- a/kernel/cgroup.c~cgroups-add-inactive-subsystems-to-rootnodesubsys_list-fix
>> +++ a/kernel/cgroup.c
>> @@ -2521,7 +2521,7 @@ static void __init cgroup_init_subsys(st
>>  	printk(KERN_INFO "Initializing cgroup subsys %s\n", ss->name);
>>
>>  	/* Create the top cgroup state for this subsystem */
>> -	list_add(&ss->sibling, &rootnode.root_list);
>> +	list_add(&ss->sibling, &rootnode.subsys_list);
>>  	ss->root = &rootnode;
>>  	css = ss->create(ss, dummytop);
>>  	/* We don't handle early failures gracefully */
>>
> 
> Yes, this fix does work for me,
>  

Thanks! And sorry for the silly mistake I made.

