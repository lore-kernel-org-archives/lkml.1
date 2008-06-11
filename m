Return-Path: <linux-kernel-owner+w=401wt.eu-S1753634AbYFKKi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbYFKKi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 06:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbYFKKiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 06:38:51 -0400
Received: from as3.cineca.com ([130.186.84.211]:48501 "EHLO as3.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbYFKKiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 06:38:50 -0400
Message-ID: <484FAB04.2010800@gmail.com>
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com, containers@lists.osdl.org,
       menage@google.com, xemul@openvz.org
Subject: Re: [RFC PATCH 5/5] refresh VM committed space after a task migration
References: <>  <1213054383-18137-6-git-send-email-righi.andrea@gmail.com> <1213119688.13882.13.camel@nimitz>
In-Reply-To: <1213119688.13882.13.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 11 Jun 2008 12:37:57 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Tue, 2008-06-10 at 01:33 +0200, Andrea Righi wrote:
>> +       preempt_disable();
>> +       committed = atomic_long_read(&p->vm_committed_space);
>> +       atomic_long_sub(committed, &old_mem->vmacct.vm_committed_space);
>> +       atomic_long_add(committed, &mem->vmacct.vm_committed_space);
>> +       preempt_enable();
>>  out:
>>         mmput(mm);
>>  }
> 
> Why bother with the preempt stuff here?  What does the actually protect
> against?  I assume that you're trying to keep other tasks that might run
> on this CPU from seeing weird, inconsistent numbers in here.  Is there
> some other looks that keeps *other* cpus from seeing this?
> 
> In any case, I think it needs a big, fat comment.

Yes, true, mem_cgroup_move_task() is called after the task->cgroups
pointer has been changed. So, even if task changes its committed space
between the atomic_long_sub() and atomic_long_add() it will be correctly
accounted in the new cgroup.

-Andrea
