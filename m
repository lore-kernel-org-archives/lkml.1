Return-Path: <linux-kernel-owner+w=401wt.eu-S1756508AbYGRXJC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbYGRXJC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 19:09:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbYGRXIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 19:08:51 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49509 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760674AbYGRXIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 19:08:49 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <9406923.1216422307592.kamezawa.hiroyu@jp.fujitsu.com>
Date: Sat, 19 Jul 2008 08:05:07 +0900 (JST)
To: Paul Menage <menage@google.com>
Subject: Re: Re: [RFC] How to handle the rules engine for cgroups
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Vivek Goyal <vgoyal@redhat.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Libcg Devel Mailing List <libcg-devel@lists.sourceforge.net>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <pzijlstr@redhat.com>,
       Kazunaga Ikeno <k-ikeno@ak.jp.nec.com>,
       Morton Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <6599ad830807180846n11260adft168bddf7c203469c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <6599ad830807180846n11260adft168bddf7c203469c@mail.gmail.com>
 <20080701191126.GA17376@redhat.com>
	 <20080718185226.f809281d.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
>On Fri, Jul 18, 2008 at 2:52 AM, KAMEZAWA Hiroyuki
><kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>
>> For example, create a new file under memory cgroup
>> ==
>>  /opt/memory_cgroup/group_A/notify_at_memory_reach_limit
>> ==
>> And a user watches the file by inotify.
>> The kernel modify modified-time of notify_at_memory_reach_limit file and ca
ll
>> fs/notify_user.c::notify_change() against this inode. He can catchthe event
>> by inotify.
>> (I think he can also catch removal of this file, etc...)
>>
>
>We've been doing something like this to handle OOMs in userspace, with
>pretty good success. The approach that we used so far was a custom
>control file tied to a wait queue, that gets woken when a cgroup
>triggers OOM, but it's a bit hacky. I've been considering some kind of
>more generic approach that could be reused by different subsystems for
>other notifications, maybe using eventfd or maybe netlink.
>
Hmm, eventfd is AIO's one ?
Anyway I agree we need something generic. (hopefully, reuse existing one.)

>inotify would be an option too, but that seems like it might be
>forcing ourselves into filesystem semantics too much.
>
At quick glance, Inotify's good points are

- can be used for any file. for example, even changes in "tasks" file can be
  cathced if it modify modified-time.
- It can be queued.
- It supports ONESHOT, NONBLOCK, etc...
- All memory allocation is done by the waiter (the user).

But yes, we cannot notify other events than "there is some change".

Thanks,
-Kame
>Paul

