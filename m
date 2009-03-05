Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbZCEXFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbZCEXFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:05:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754346AbZCEXEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:04:53 -0500
Received: from mail-fx0-f164.google.com ([209.85.220.164]:42158 "EHLO
	mail-fx0-f164.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbZCEXEw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:04:52 -0500
MIME-Version: 1.0
In-Reply-To: <20090305144210.e40ef501.akpm@linux-foundation.org>
References: <20090305190954.30062.44759.stgit@f10box.hanneseder.net>
	 <20090305191839.30062.91081.stgit@f10box.hanneseder.net>
	 <20090305144210.e40ef501.akpm@linux-foundation.org>
Date: Fri, 6 Mar 2009 00:04:49 +0100
Message-ID: <154e089b0903051504v451f2421jae561c58984946ad@mail.gmail.com>
Subject: Re: [PATCH v2 15/15] NULL noise: mm/memcontrol.c
From: Hannes Eder <hannes@hanneseder.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 5, 2009 at 11:42 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 05 Mar 2009 20:18:44 +0100
> Hannes Eder <hannes@hanneseder.net> wrote:
>
>> Fix this sparse warning:
>>   mm/memcontrol.c:1637:32: warning: Using plain integer as NULL pointer
>>
>> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
>> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> ---
>> v2: other subject, as suggested by Al Viro
>>
>>  mm/memcontrol.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 8e4be9c..09d6650 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -1634,7 +1634,7 @@ static int mem_cgroup_force_empty_list(struct mem_cgroup *mem,
>>               pc = list_entry(list->prev, struct page_cgroup, lru);
>>               if (busy == pc) {
>>                       list_move(&pc->lru, list);
>> -                     busy = 0;
>> +                     busy = NULL;
>>                       spin_unlock_irqrestore(&zone->lru_lock, flags);
>>                       continue;
>>               }
>
> I have to say that I wish sparse didn't do this.  Initialising a
> pointer with literal zero is perfectly clear and is idiomatic C.

We could turn it off with '-Wno-non-pointer-null', but then it is not
reported in other might useful cases either. Well, it's really a minor
thing, but fixing it, isn't a big deal either. Or is there any
drawback that I am not aware of?
