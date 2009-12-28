Return-Path: <linux-kernel-owner+w=401wt.eu-S1752080AbZL1J6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbZL1J6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 04:58:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbZL1J6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 04:58:46 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40267 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbZL1J6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 04:58:46 -0500
Message-ID: <27db4d47e5a95e7a85942c0278892467.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <1261989047.7135.3.camel@laptop>
References: <20091225105140.263180e8.kamezawa.hiroyu@jp.fujitsu.com>
    <1261915391.15854.31.camel@laptop>
    <20091228093606.9f2e666c.kamezawa.hiroyu@jp.fujitsu.com>
    <1261989047.7135.3.camel@laptop>
Date: Mon, 28 Dec 2009 18:58:43 +0900 (JST)
Subject: Re: [RFC PATCH] asynchronous page fault.
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra さんは書きました：
> On Mon, 2009-12-28 at 09:36 +0900, KAMEZAWA Hiroyuki wrote:
>>
>> > The idea is to let the RCU lock span whatever length you need the vma
>> > for, the easy way is to simply use PREEMPT_RCU=y for now,
>>
>> I tried to remove his kind of reference count trick but I can't do that
>> without synchronize_rcu() somewhere in unmap code. I don't like that and
>> use this refcnt.
>
> Why, because otherwise we can access page tables for an already unmapped
> vma? Yeah that is the interesting bit ;-)
>
Without that
  vma->a_ops->fault()
and
  vma->a_ops->unmap()
can be called at the same time. and vma->vm_file can be dropped while
vma->a_ops->fault() is called. etc...
Ah, I may miss something. I'll consider in the next year.

Thanks,
-Kame

