Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbZFLPP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbZFLPP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 11:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbZFLPPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 11:15:15 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:41145 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbZFLPPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 11:15:14 -0400
Message-ID: <4A3270FE.4090602@linux.vnet.ibm.com>
Date: Fri, 12 Jun 2009 20:45:10 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, hannes@cmpxchg.org,
       torvalds@linux-foundation.org, yinghai@kernel.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [BUGFIX][PATCH] memcg: fix page_cgroup fatal error in FLATMEM
 v2
References: <Pine.LNX.4.64.0906110820170.2258@melkki.cs.Helsinki.FI> <4A31C258.2050404@cn.fujitsu.com> <20090612115501.df12a457.kamezawa.hiroyu@jp.fujitsu.com> <20090612124408.721ba2ae.kamezawa.hiroyu@jp.fujitsu.com> <4A31D326.3030206@cn.fujitsu.com> <20090612143429.76ef2357.kamezawa.hiroyu@jp.fujitsu.com> <84144f020906112321x9912476sb42b5d811741e646@mail.gmail.com> <20090612152922.0e7d1221.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090612152922.0e7d1221.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Fri, 12 Jun 2009 09:21:52 +0300
> Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>>> In future,
>>> We stop to support FLATMEM (if no users) or rewrite codes for flatmem
>>> completely. But this will adds more messy codes and (big) overheads.
>>>
>>> Reported-by: Li Zefan <lizf@cn.fujitsu.com>
>>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> Looks good to me!
>>
>> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
>>
>> Do you want me to push this to Linus or will you take care of it?
>>
> Could you please push this one ? Typos pointed out by Li Zefan is fixed.
> 
> Thank you all.
> -Kame
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Now, SLAB is configured in very early stage and it can be used in
> init routine now.
> 
> But replacing alloc_bootmem() in FLAT/DISCONTIGMEM's page_cgroup()
> initialization breaks the allocation, now.
> (Works well in SPARSEMEM case...it supports MEMORY_HOTPLUG and
>  size of page_cgroup is in reasonable size (< 1 << MAX_ORDER.)
> 
> This patch revive FLATMEM+memory cgroup by using alloc_bootmem.
> 
> In future,
> We stop to support FLATMEM (if no users) or rewrite codes for flatmem
> completely.But this will adds more messy codes and overheads.
> 
> Changelog: v1->v2
>  - fixed typos.
> 
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> Tested-by: Li Zefan <lizf@cn.fujitsu.com>
> Reported-by: Li Zefan <lizf@cn.fujitsu.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

I see you've responded already, Thanks!

The diff is a bit confusing, was Pekka's patch already integrated, in my version
of mmotm, I don't see the alloc_pages_node() change in my source base.

But overall I agree with the change.


-- 
	Balbir
