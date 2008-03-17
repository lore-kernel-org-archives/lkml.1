Return-Path: <linux-kernel-owner+w=401wt.eu-S1752565AbYCQPRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbYCQPRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 11:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbYCQPRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 11:17:22 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:53322 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbYCQPRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 11:17:22 -0400
Message-ID: <47DE8B1E.4010501@linux.vnet.ibm.com>
Date: Mon, 17 Mar 2008 20:45:42 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Li Zefan <lizf@cn.fujitsu.com>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, linux-kernel@vger.kernel.org,
       taka@valinux.co.jp, David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][0/3] Virtual address space control for cgroups
References: <20080316172942.8812.56051.sendpatchset@localhost.localdomain> <6599ad830803161626q1fcf261bta52933bb5e7a6bdd@mail.gmail.com> <47DDCDA7.4020108@cn.fujitsu.com> <6599ad830803161857r6d01f962vfd0f570e6124ab24@mail.gmail.com> <47DDFCEA.3030207@linux.vnet.ibm.com> <6599ad830803162222t6c32f5a1qd4d0af4887dfa910@mail.gmail.com>
In-Reply-To: <6599ad830803162222t6c32f5a1qd4d0af4887dfa910@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Mon, Mar 17, 2008 at 1:08 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>  I understand the per-mm pointer overhead back to the cgroup. I don't understand
>>  the part about adding a per-mm pointer back to the "owning" task. We already
>>  have task->mm.
> 
> Yes, but we don't have mm->owner, which is what I was proposing -
> mm->owner would be a pointer typically to the mm's thread group
> leader. It would remove the need to have to have pointers for the
> various different cgroup subsystems that need to act on an mm rather
> than a task_struct, since then you could use
> mm->owner->cgroups[subsys_id].
> 

Aaahh.. Yes.. mm->owner might be a good idea. The only thing we'll need to
handle is when mm->owner dies (I think the thread group is still kept around).
The other disadvantage is the double dereferencing, which should not be all that
bad.

> But this is kind of orthogonal to whether virtual address space limits
> should be a separate cgroup subsystem.
> 

Yes, sure.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
