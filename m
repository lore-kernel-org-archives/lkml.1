Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbYIZJcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbYIZJcG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 05:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbYIZJbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 05:31:53 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:51698 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbYIZJbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 05:31:51 -0400
Message-ID: <48DCAC02.5050108@linux.vnet.ibm.com>
Date: Fri, 26 Sep 2008 15:01:46 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080725)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "xemul@openvz.org" <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>,
       ryov@valinux.co.jp
Subject: Re: [PATCH 0/12] memcg updates v5
References: <20080925151124.25898d22.kamezawa.hiroyu@jp.fujitsu.com> <48DC9AF2.1050101@linux.vnet.ibm.com> <20080926182253.a62cc2d0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080926182253.a62cc2d0.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Fri, 26 Sep 2008 13:48:58 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> KAMEZAWA Hiroyuki wrote:
>>> Hi, I updated the stack and reflected comments.
>>> Against the latest mmotm. (rc7-mm1)
>>>
>>> Major changes from previous one is 
>>>   - page_cgroup allocation/lookup manner is changed.
>>>     all FLATMEM/DISCONTIGMEM/SPARSEMEM and MEMORY_HOTPLUG is supported.
>>>   - force_empty is totally rewritten. and a problem that "force_empty takes long time"
>>>     in previous version is fixed (I think...)
>>>   - reordered patches.
>>>      - first half are easy ones.
>>>      - second half are big ones.
>>>
>>> I'm still testing with full debug option. No problem found yet.
>>> (I'm afraid of race condition which have not been caught yet.)
>>>
>>> [1/12]  avoid accounting special mappings not on LRU. (fix)
>>> [2/12]  move charege() call to swapped-in page under lock_page() (clean up)
>>> [3/12]  make root cgroup to be unlimited. (change semantics.)
>>> [4/12]  make page->mapping NULL before calling uncharge (clean up)
>>> [5/12]  make page->flags to use atomic ops. (changes in infrastructure)
>>> [6/12]  optimize stat. (clean up)
>>> [7/12]  add support function for moving account. (new function)
>>> [8/12]  rewrite force_empty to use move_account. (change semantics.)
>>> [9/12]  allocate all page_cgroup at boot. (changes in infrastructure)
>>> [10/12] free page_cgroup from LRU in lazy way (optimize)
>>> [11/12] add page_cgroup to LRU in lazy way (optimize)
>>> [12/12] fix race at charging swap  (fix by new logic.)
>>>
>>> *Any* comment is welcome.
>> Kame,
>>
>> I'm beginning to review test the patches now. It would be really nice to split
>> the development patches from the maintenance ones. I think the full patchset has
>> too many things and is confusing to look at.
>>
> I hope I can do....but maybe difficult.
> If you give me ack, 1,2,4,6, can be pushed at early stage.

I think (1) might be OK, except for the accounting issues pointed out (change in
behaviour visible to end user again, sigh! :( ). Is (1) a serious issue? (2)
seems OK, except for the locking change for mark_page_accessed. I am looking at
(4) and (6) currently.

-- 
	Balbir
