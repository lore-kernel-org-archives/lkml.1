Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbYJUJr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbYJUJr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 05:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbYJUJru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 05:47:50 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:37186 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbYJUJrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 05:47:49 -0400
Message-ID: <48FDA53C.6030106@fr.ibm.com>
Date: Tue, 21 Oct 2008 11:47:40 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] freezer_cg: remove redundant check in freezer_can_attach()
References: <48FD26F5.1070809@cn.fujitsu.com> <48FD273F.3040505@cn.fujitsu.com> <48FD85A2.8090605@fr.ibm.com> <48FDA0F3.2070306@cn.fujitsu.com>
In-Reply-To: <48FDA0F3.2070306@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> Cedric Le Goater wrote:
>> Li Zefan wrote:
>>> It is sufficient to check if @task is frozen, and no need to check if
>>> the original freezer is frozen.
>> hmm, a task being frozen does not mean that its freezer cgroup is 
>> frozen.
> 
> If a task has being frozen, then can_attach() returns -EBUSY at once.
> If a task isn't frozen, then we have orig_freezer->state == THAWED.
> 
> So we need to check the state of the task only.
> 
>> So the extra check seems valid but looking at the comment :
>>
>> 	/*
>> 	 * The call to cgroup_lock() in the freezer.state write method prevents
>> 	 * a write to that file racing against an attach, and hence the
>> 	 * can_attach() result will remain valid until the attach completes.
>> 	 */
>> 	static int freezer_can_attach(struct cgroup_subsys *ss,
>>
>> how do we know that the task_freezer(task), which is not protected by
>> the cgroup_lock(), is not going to change its state to CGROUP_FROZEN 
>> it looks racy.
>>
> 
> Since freezer_can_attach() is called by cgroup core with cgroup_lock held, there is
> no race with task attaching and state changing.

ok I see. cgroup_mutex is global, I thought it had changed and that we 
were only locking the cgroup the task was being attached to. 

Acked-by: Cedric Le Goater <clg@fr.ibm.com>

thanks,

C. 

 
