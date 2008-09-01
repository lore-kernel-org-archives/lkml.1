Return-Path: <linux-kernel-owner+w=401wt.eu-S1755099AbYIAGZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbYIAGZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 02:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbYIAGZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 02:25:45 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:48267 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbYIAGZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 02:25:44 -0400
Message-ID: <48BB8AE3.7070704@linux.vnet.ibm.com>
Date: Mon, 01 Sep 2008 11:55:39 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, hugh@veritas.com,
       menage@google.com, xemul@openvz.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>
Subject: Re: [RFC][PATCH] Remove cgroup member from struct page
References: <20080831174756.GA25790@balbir.in.ibm.com> <20080901090102.46b75141.kamezawa.hiroyu@jp.fujitsu.com> <48BB6160.4070904@linux.vnet.ibm.com> <20080901130351.f005d5b6.kamezawa.hiroyu@jp.fujitsu.com> <48BB8716.5090805@linux.vnet.ibm.com> <20080901152424.d9adfe47.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080901152424.d9adfe47.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Mon, 01 Sep 2008 11:39:26 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> 
>>> The development of lockless-page_cgroup is not stalled. I'm just waiting for
>>> my 8cpu box comes back from maintainance...
>>> If you want to see, I'll post v3 with brief result on small (2cpu) box.
>>>
>> I understand and I am not pushing you to completing it, but at the same time I
>> don't want to queue up behind it for long. I suspect the cost of porting
>> lockless page cache on top of my patches should not be high, but I'll never know
>> till I try :)
>>
> My point is, your patch adds big lock. Then, I don't have to do meaningless effort
> to reduce lock.

My patch does not add a big lock, it moves the lock from struct
page->page_cgroup to struct page_cgroup. The other locking added is the locking
overhead associated with inserting entries into the radix tree, true. I ran
oprofile along with lockdep and lockstats enabled on my patches. I don't see the
radix_tree or page_cgroup->lock showing up, I see __slab_free and __slab_alloc
showing up. I'll poke a little further.

Please don't let my patch stop you, we'll integrate the best of both worlds and
what is good for memcg.

-- 
	Balbir
