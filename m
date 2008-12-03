Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbYLCBJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbYLCBJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 20:09:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbYLCBJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 20:09:37 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57232 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbYLCBJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 20:09:36 -0500
Message-ID: <4935DC68.5030109@cn.fujitsu.com>
Date: Wed, 03 Dec 2008 09:10:00 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 2/3] cgroups: add inactive subsystems to 	rootnode.root_list
References: <492FC1BD.4010705@cn.fujitsu.com>	 <6599ad830812011735i565087dfg7ebad01a1f0400ad@mail.gmail.com>	 <4934AA53.4000308@cn.fujitsu.com> <6599ad830812021453m44e948b1p83f6e02aa7e9068@mail.gmail.com>
In-Reply-To: <6599ad830812021453m44e948b1p83f6e02aa7e9068@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> @@ -2522,6 +2522,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
>>>>        printk(KERN_INFO "Initializing cgroup subsys %s\n", ss->name);
>>>>
>>>>        /* Create the top cgroup state for this subsystem */
>>>> +       list_add(&ss->sibling, &rootnode.root_list);
>>> This is wrong. cgroup_subsys.sibling is a member of the list of
>>> subsystems attached to a given root, and rootnode.root_list is a
>>> member of the list of hierarchies. Did you actually meant
>>> &rootnode.subsys_list?
>>>
>> I thought I corrected all the s/root_list/subsys_list/ in patch v2. :(
>>
>> If this patch makes sense, I'll fix it, otherwise we'll going to ask Andrew to drop it from -mm.
> 
> Looking at the existing code, it's not actually broken - but only by accident.
> 

Yes, since it's not broken, I didn't claim this patch as a bug fix that
should go into 2.6.28.

> We aim to add a link for each cgroup, which we do by finding the first
> subsystem in each hierarchy and adding a link for its cgroup, and then
> adding a link for dummytop if there weren't any subsystems in the
> inactive hierarchy.
> 
> But since rootnode.subsys_list is always empty, we always skip the
> inactive hierarchy in the main loop (if it has any subsystems), and
> always add the inactive hierarchy afterwards. So everything works out
> OK (all hierarchies do get linked), but it's horribly unreadable.
> 

I found this confusion when I was trying to understand this part of code.

> Having the subsys_list be correct for the inactive hierarchy is
> probably a good thing, so this patch should go ahead (once the typos
> is fixed).
> 

I'll fix it. :)

