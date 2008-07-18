Return-Path: <linux-kernel-owner+w=401wt.eu-S1759350AbYGRXTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350AbYGRXTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 19:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761279AbYGRXSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 19:18:45 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49641 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761210AbYGRXSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 19:18:43 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <25575357.1216422624453.kamezawa.hiroyu@jp.fujitsu.com>
Date: Sat, 19 Jul 2008 08:10:24 +0900 (JST)
To: balbir@linux.vnet.ibm.com
Subject: Re: Re: [RFC] How to handle the rules engine for cgroups
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Vivek Goyal <vgoyal@redhat.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Libcg Devel Mailing List <libcg-devel@lists.sourceforge.net>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>, Peter Zijlstra <pzijlstr@redhat.com>,
       Kazunaga Ikeno <k-ikeno@ak.jp.nec.com>,
       Morton Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4880C731.6090904@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <4880C731.6090904@linux.vnet.ibm.com>
 <20080701191126.GA17376@redhat.com> <20080718185226.f809281d.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
>KAMEZAWA Hiroyuki wrote:
>> On Tue, 1 Jul 2008 15:11:26 -0400
>> Vivek Goyal <vgoyal@redhat.com> wrote:
>> 
>>> Hi,
>>>
>>> While development is going on for cgroup and various controllers, we also
>>> need a facility so that an admin/user can specify the group creation and
>>> also specify the rules based on which tasks should be placed in respective
>>> groups. Group creation part will be handled by libcg which is already
>>> under development. We still need to tackle the issue of how to specify
>>> the rules and how these rules are enforced (rules engine).
>>>
>> 
>> A different topic.
>> 
>> Recently I'm interested in "How to write userland daemon program
>> to control group subsystem." To implement that effectively, we need
>> some notifier between user <-> kernel.
>> 
>> Can we use "inotify" to catch changes in cgroup (by daemon program) ?
>> 
>> For example, create a new file under memory cgroup
>> ==
>>   /opt/memory_cgroup/group_A/notify_at_memory_reach_limit
>> ==
>> And a user watches the file by inotify.
>> The kernel modify modified-time of notify_at_memory_reach_limit file and ca
ll
>> fs/notify_user.c::notify_change() against this inode. He can catchthe event
>> by inotify.
>
>Won't the time latency be an issue (time between exceeding the limit and the
>user space being notified?). Since the notification does not use user memory 
at
>the moment (it will not stress the limits futher :)), provided the notificati
on
>handler is not running under the group that has exceeded its limit. Do we exp
ect
>the user space application to ACK that it's seen the notification? We could u
se
>a netlink channel as well (in the case that we need two way communication).
>
>I would prefer to notify on memory.failcnt, if we do use this interface.
>
Maybe we need some technique "How to run a daemon in proper way."
(use special daemon cgroup etc...)
I don't think the user space has to do ACK to the kernel. The user space
can modify control file when he get events, but that's all he can do, anyway.

Thanks,
-Kame 

