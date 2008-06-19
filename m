Return-Path: <linux-kernel-owner+w=401wt.eu-S1755903AbYFSDI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbYFSDI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 23:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYFSDIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 23:08:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54568 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbYFSDIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 23:08:46 -0400
Message-ID: <4859CD62.8090402@cn.fujitsu.com>
Date: Thu, 19 Jun 2008 11:07:14 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Jackson <pj@sgi.com>
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
> 

Then the left column is exactly the same with the contents of `cat tasks`, so IMO
it won't be useful. Besides, the tasks of pids listed in the right column may not
all belongs to that group, so how we can make use of this column?
