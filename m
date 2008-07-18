Return-Path: <linux-kernel-owner+w=401wt.eu-S1760137AbYGRQjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137AbYGRQjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 12:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbYGRQjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 12:39:24 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:54552 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756085AbYGRQjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 12:39:22 -0400
Message-ID: <4880C731.6090904@linux.vnet.ibm.com>
Date: Fri, 18 Jul 2008 11:39:13 -0500
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080515)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Vivek Goyal <vgoyal@redhat.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Libcg Devel Mailing List <libcg-devel@lists.sourceforge.net>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, Peter Zijlstra <pzijlstr@redhat.com>,
       Kazunaga Ikeno <k-ikeno@ak.jp.nec.com>,
       Morton Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] How to handle the rules engine for cgroups
References: <20080701191126.GA17376@redhat.com> <20080718185226.f809281d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080718185226.f809281d.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Tue, 1 Jul 2008 15:11:26 -0400
> Vivek Goyal <vgoyal@redhat.com> wrote:
> 
>> Hi,
>>
>> While development is going on for cgroup and various controllers, we also
>> need a facility so that an admin/user can specify the group creation and
>> also specify the rules based on which tasks should be placed in respective
>> groups. Group creation part will be handled by libcg which is already
>> under development. We still need to tackle the issue of how to specify
>> the rules and how these rules are enforced (rules engine).
>>
> 
> A different topic.
> 
> Recently I'm interested in "How to write userland daemon program
> to control group subsystem." To implement that effectively, we need
> some notifier between user <-> kernel.
> 
> Can we use "inotify" to catch changes in cgroup (by daemon program) ?
> 
> For example, create a new file under memory cgroup
> ==
>   /opt/memory_cgroup/group_A/notify_at_memory_reach_limit
> ==
> And a user watches the file by inotify.
> The kernel modify modified-time of notify_at_memory_reach_limit file and call
> fs/notify_user.c::notify_change() against this inode. He can catchthe event
> by inotify.

Won't the time latency be an issue (time between exceeding the limit and the
user space being notified?). Since the notification does not use user memory at
the moment (it will not stress the limits futher :)), provided the notification
handler is not running under the group that has exceeded its limit. Do we expect
the user space application to ACK that it's seen the notification? We could use
a netlink channel as well (in the case that we need two way communication).

I would prefer to notify on memory.failcnt, if we do use this interface.

> (I think he can also catch removal of this file, etc...)
> 
> Is there some difficulty or problem ? (I'm sorry if we can do this now.)



-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
