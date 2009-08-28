Return-Path: <linux-kernel-owner+w=401wt.eu-S1751877AbZH1O6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbZH1O6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 10:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbZH1O6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 10:58:40 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49047 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbZH1O6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 10:58:40 -0400
Message-ID: <d50640bcbd1bb174caaca9714bbe03e5.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20090828144539.GN4889@balbir.in.ibm.com>
References: <20090828132015.10a42e40.kamezawa.hiroyu@jp.fujitsu.com>
    <20090828132321.e4a497bb.kamezawa.hiroyu@jp.fujitsu.com>
    <20090828072007.GH4889@balbir.in.ibm.com>
    <20090828163523.e51678be.kamezawa.hiroyu@jp.fujitsu.com>
    <20090828132643.GM4889@balbir.in.ibm.com>
    <bfd50d44ff730c2720b882a81b7446c6.squirrel@webmail-b.css.fujitsu.com>
    <20090828144539.GN4889@balbir.in.ibm.com>
Date: Fri, 28 Aug 2009 23:58:39 +0900 (JST)
Subject: Re: [RFC][PATCH 1/5] memcg: change for softlimit.
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
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
> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-08-28
> 23:29:09]:
>
>> Balbir Singh wrote:
>> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-08-28
>> > 16:35:23]:
>> >
>>
>> >>
>> >> Current soft-limit RB-tree will be easily broken i.e. not-sorted
>> >> correctly
>> >> if used under use_hierarchy=1.
>> >>
>> >
>> > Not true, I think the sorted-ness is delayed and is seen when we pick
>> > a tree for reclaim. Think of it as being lazy :)
>> >
>> plz explain how enexpectedly unsorted RB-tree can work sanely.
>>
>>
>
> There are two checks built-in
>
> 1. In the reclaim path (we see how much to reclaim, compared to the
> soft limit)
> 2. In the dequeue path where we check if we really are over soft limit
>
that's not a point.

> I did lot of testing with the time based approach and found no broken
> cases, I;ve been testing it with the mmotm (event based approach and I
> am yet to see a broken case so far).
>
I'm sorry if I don't understand RB-tree.
I think RB-tree is a system which can sort inputs passed by caller
one by one and will be in broken state if value of nodes changed
while it's in tree. Wrong ?
While a subtree is
               7
              / \
             3   9
And, by some magic, the value can be changed without extract
               7
              / \
             13  9
The biggest is 13. But the biggest number which will be selecte will be "9".

Thanks,
-Kame







