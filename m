Return-Path: <linux-kernel-owner+w=401wt.eu-S1757004AbYDAIS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004AbYDAIS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 04:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077AbYDAIRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 04:17:47 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:59419 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbYDAIRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 04:17:45 -0400
Message-ID: <47F1EE8F.2050508@linux.vnet.ibm.com>
Date: Tue, 01 Apr 2008 13:43:03 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>, YAMAMOTO Takashi <yamamoto@valinux.co.jp>
CC: balbir@linux.vnet.ibm.com, Pavel Emelianov <xemul@openvz.org>,
       Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][-mm] Add an owner to the mm_struct (v3)
References: <20080401054324.829.4517.sendpatchset@localhost.localdomain> <6599ad830803312316m17f9e6f1mf7f068c0314a789e@mail.gmail.com> <47F1D4F3.3040207@linux.vnet.ibm.com> <6599ad830803312348u3ee4d815i2e24c130978f8e04@mail.gmail.com> <47F1E3C1.6050802@linux.vnet.ibm.com>
In-Reply-To: <47F1E3C1.6050802@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> Paul Menage wrote:
>> On Mon, Mar 31, 2008 at 11:23 PM, Balbir Singh
>> <balbir@linux.vnet.ibm.com> wrote:
>>>  > Here we'll want to call vm_cgroup_update_mm_owner(), to adjust the
>>>  > accounting. (Or if in future we end up with more than a couple of
>>>  > subsystems that want notification at this time, we'll want to call
>>>  > cgroup_update_mm_owner() and have it call any interested subsystems.
>>>  >
>>>
>>>  I don't think we need to adjust accounting, since only mm->owner is changing and
>>>  not the cgroup to which the task/mm belongs. Do we really need to notify? I
>>>  don't want to do any notifications under task_lock().
>> It's possible but unlikely that the new owner is in a different cgroup.
> 
> Hmmm... that can never happen with thread groups, since mm->owner is
> p->group_leader and that never exits unless all threads are gone (it can
> explicitly change groups though). Without thread groups, the new owner can
> belong to a different cgroup, so we might need notification.
> 
> 

Thinking out aloud

If mm->owner changes and belongs to a different cgroup, we have a whole new
problem. We need to determine all tasks that share the mm and belong to a
particular cgroup, which changed since the new owner belongs to a different
cgroup and then update the charge.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
