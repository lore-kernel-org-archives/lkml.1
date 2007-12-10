Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbXLJA6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbXLJA6g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 19:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbXLJA6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 19:58:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079AbXLJA6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 19:58:14 -0500
Message-ID: <475C8EE9.2040608@redhat.com>
Date: Sun, 09 Dec 2007 19:57:13 -0500
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Balbir Singh <balbir@in.ibm.com>, vatsa@linux.vnet.ibm.com,
       LKML Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RT Load balance changes in sched-devel
References: <20071130145939.GN5681@linux.vnet.ibm.com> <b647ffbd0712011156p252ae29dnfa75494e4d2c845c@mail.gmail.com> <20071203182223.GA4133@linux.vnet.ibm.com> <47556B23.2060909@redhat.com> <20071204153542.GC3388@linux.vnet.ibm.com> <b647ffbd0712040828l51a26a82jc0f38d3f4aa2291e@mail.gmail.com> <20071205134036.GA21933@linux.vnet.ibm.com> <4756B8E9.3080709@redhat.com> <20071205164800.GA24767@linux.vnet.ibm.com> <4756D709.1020901@redhat.com> <b647ffbd0712090916l4eb9a944r4726680a5fdcae46@mail.gmail.com> <475BEE6B.BA47.005A.0@novell.com>
In-Reply-To: <475BEE6B.BA47.005A.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
>> btw., both cases would be addressed by placing load-balance points
>> into sched_class_rt->{enqueue,dequeue}_task_rt()... push_rt_tasks()
>> and pull_rt_tasks() respectively. As a side effect (I think,
>> technically, it would be possible), 3 out of 4 *_balance_rt() calls
>> (the exception: schedule_tail_balance_rt()) in schedule() would become
>> unnecessary.
>>
>> _BUT_
>>
>> the enqueue/dequeue() interface would become less straightforward,
>> logically-wise.
>> Something like:

Also push and pull_rt use activate,deactivate as well. So this would 
make that code a bit more complex.

>>
>> rq = activate_task(rq, ...) ; /* may unlock rq and lock/return another one 
>> */
>>
>> would complicate the existing use cases.
>>
> 
> I think I would prefer to just fix the setscheduler/setprio cases for the class transition than change the behavior of these enqueue/dequeue calls.  But I will keep an open mind as I look into this issue.

I agree with Gregory on this. I prefer to fix the two you found. I 
thought about them before, but somehow they were missed :-/

Anyway, I'll be working on adding some more patches on Monday. There may 
be other ways to clean this up.

> 
> Thanks for the review!

Yeah, thanks from me too!

-- Steve

