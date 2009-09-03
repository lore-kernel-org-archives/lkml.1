Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbZICAaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbZICAaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 20:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbZICAaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 20:30:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41087 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbZICAaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 20:30:06 -0400
Message-ID: <fa721014d75b6e193623349bfde28124.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <661de9470909021302ge86d01s5d107dc2b5cffbc5@mail.gmail.com>
References: <20090902.205137.71100180.ryov@valinux.co.jp>
    <ff13736137802f78cf492d13c43c1af1.squirrel@webmail-b.css.fujitsu.com>
    <661de9470909021302ge86d01s5d107dc2b5cffbc5@mail.gmail.com>
Date: Thu, 3 Sep 2009 09:30:05 +0900 (JST)
Subject: Re: a room for blkio-cgroup in struct page_cgroup
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Ryo Tsuruta" <ryov@valinux.co.jp>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, linux-mm@kvack.org
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> 2009/9/2 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
>> Ryo Tsuruta wrote:
>>> Hi Kamezawa-san,
>>>
>>> As you wrote before (http://lkml.org/lkml/2009/7/22/65)
>>>> To be honest, what I expected in these days for people of blockio
>>>> cgroup is like following for getting room for themselves.
>>> <<snip>>
>>>> --- mmotm-2.6.31-Jul16.orig/include/linux/page_cgroup.h
>>>> +++ mmotm-2.6.31-Jul16/include/linux/page_cgroup.h
>>>> @@ -13,7 +13,7 @@
>>>> &#160;struct page_cgroup {
>>>> &#160; &#160; &#160; unsigned long flags;
>>>> &#160; &#160; &#160; struct mem_cgroup *mem_cgroup;
>>>> - &#160; &#160; struct page *page;
>>>> + &#160; &#160; /* block io tracking will use extra unsigned long
bytes */
>>>> &#160; &#160; &#160; struct list_head lru; &#160; &#160; &#160; /*
per cgroup LRU list */
>>>> };
>>>
>>> Have you already added a room for blkio_cgroup in struct page_cgroup?
>> No.
>>
>
> The diff above is unclear, are you removing struct page from page_cgroup?
>
I said him "if you want a room, plz get by youself, consider more"
And offered this change.
 http://lkml.org/lkml/2009/7/22/65
you were CC'd.
Because page_cgroup's layout is same to memmap, we can use similar function
as
  page_cgroup_to_pfn(), pfn_to_page_cgroup().
And, we don't access page_cgroup->page in fast path. (maybe)
But as I wrote, we're busy. I'll not do this until all performance fixes
go ahead.

Thanks,
-Kame

