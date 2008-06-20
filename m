Return-Path: <linux-kernel-owner+w=401wt.eu-S1758108AbYFTOUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108AbYFTOUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 10:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755802AbYFTOUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 10:20:08 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:34340 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755713AbYFTOUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 10:20:06 -0400
Message-ID: <485BBC74.70505@linux.vnet.ibm.com>
Date: Fri, 20 Jun 2008 19:49:32 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>
Subject: Re: [RFC] [PATCH] cgroup: add "procs" control file
References: <4858C111.8050806@cn.fujitsu.com> <20080619091436.0a441351.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080619091436.0a441351.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Wed, 18 Jun 2008 16:02:25 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> This control file is the equivalent of the "tasks" control file, but
>> acting/reporting on entire thread groups.
>>
>> For example, we have a process with pid 1000 and its sub-thread with
>> tid 1001, to attach them into a cgroup:
>>  # echo 1000 > procs
>> Then show the process list and the task list respectively:
>>  # cat procs
>>  1000
>>  # cat tasks
>>  1000
>>  1001
>>
>> Questions:
>> - What to do if the attaching of a thread failed? continue to attach
>>   other threads, or stop and return error?
>> - When a sub-thread of a process is in the cgroup, but not its thread
>>   cgroup leader, what to do when 'cat procs'? just skip those threads?
>>
> I think this feature make sense. But not meets a theory that cgroup handles
> a thread not a process. So, how about changing the definition of this interface
> from
>   - showing procs
> to
>   - showing threads which is thread-group-leader.
> 
> One possible problem is a case that thread-group-leader exits while other
> members are alive. In such case, thread-group-leader calls cgroup_exit()
> but will be still alive until all sub-threads exit. So, this interface
> cannot show correct information. 
> (right ??? please point out if I miss something)
> 

It can show the thread group leader in zombie state with [TID]?

> So, how about this kind of interface ? showing both of TID and PID.
> 
> %/cat/procs
> TID  PID
> 1001 1001
> 1234 1001
> 3856 1001
> 728  728
> ....
> ....
> 
> nonsense ?

This information is also available from other means /proc/pid/tasks for example.
I like Li's original interface for procs and tasks. I would also suggest adding
groups.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
