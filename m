Return-Path: <linux-kernel-owner+w=401wt.eu-S1755311AbZBZK3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbZBZK3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 05:29:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbZBZK2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 05:28:55 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55439 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbZBZK2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 05:28:54 -0500
Message-ID: <18f6db017e5d44596e828e0753f28e75.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <344eb09a0902260210y44c0684by9b22f041116d3f7c@mail.gmail.com>
References: <49A6475F.4000502@cn.fujitsu.com>
    <20090226170738.a982057b.kamezawa.hiroyu@jp.fujitsu.com>
    <49A6501B.7040604@cn.fujitsu.com>
    <20090226172234.a931931f.kamezawa.hiroyu@jp.fujitsu.com>
    <49A65455.4030204@cn.fujitsu.com>
    <20090226174033.094e4834.kamezawa.hiroyu@jp.fujitsu.com>
    <344eb09a0902260210y44c0684by9b22f041116d3f7c@mail.gmail.com>
Date: Thu, 26 Feb 2009 19:28:45 +0900 (JST)
Subject: Re: [PATCH] cpuacct: add a branch prediction
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Bharata B Rao" <bharata.rao@gmail.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Li Zefan" <lizf@cn.fujitsu.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Paul Menage" <menage@google.com>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bharata B Rao：
> On Thu, Feb 26, 2009 at 2:10 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> On Thu, 26 Feb 2009 16:35:33 +0800
>> Li Zefan <lizf@cn.fujitsu.com> wrote:
>>
>>> ca is not checked before hierarchy support, and it's a side-effect.
>>>
>>> Before cpuacct is initialized, css ==
>>> task->cgroups->subsys[cpuacct_subsys] == NULL,
>>> but ca = task_ca(tsk) is not necessarily NULL, unless struct
>>> cgroup_subsys_state is the
>>> first member of struct cpuacct.
>>>
>>> And the above code actually should be:
>>>
>>> do {
>>> &#160; &#160; &#160; ...
>>> } while (ca->parent);
>>>
>> I'll send no more objections to this patch itself.
>>
>> But IMHO, this loop is tooo bad, I think. The hierarchy information
>> should be gathered by
>> read-side and the total code should be
>
> How do you take care of accounting when a group gets deleted ?.
propagate accounts to the parent or root group if deleted.

> Wouldn't you loose some information due to deleted groups if you want
> to accumulate hierarchical stats only during read ?
>
Taking hierarchy mutex while reading will make read-side stable.
I haven't considered in detail but I wrote CSS ID and scan hierarchy
code to do this kind of "visit all css object under hierarchy" jobs.
I think you can catch what I mean by reading what memory.stat file of mem
cgroup does. (mmotm)

Thanks,
-Kame


