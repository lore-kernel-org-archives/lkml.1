Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbZENOyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbZENOyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 10:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbZENOyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 10:54:09 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:54568 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbZENOyI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 10:54:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DRRTmZCbJ7leML2EWbpEjlYky32sViRdhyeMw1Dcw0JrAp4F4UoeIyw9KAw0NIGL/F
         5aLpXkMj0d4Lsp6quuMSVEZlyQTjhS2/Qk0S1ZzH5vW5hvqjWi21hLQV1Jg+FCQWuZZ7
         PBn/oMFhs+55crXo7s6bwRTMsw0/H5XwHWzQY=
MIME-Version: 1.0
In-Reply-To: <44c63dc40905140739n271d3d2w2e0cc364c0012d71@mail.gmail.com>
References: <20090514231555.f52c81eb.minchan.kim@gmail.com>
	 <2f11576a0905140727j5ba02b07t94826f57dd99839c@mail.gmail.com>
	 <44c63dc40905140739n271d3d2w2e0cc364c0012d71@mail.gmail.com>
Date: Thu, 14 May 2009 23:54:07 +0900
X-Google-Sender-Auth: 82cab7ce6885c10e
Message-ID: <2f11576a0905140754v39bbe5efv16b01fe4939c6814@mail.gmail.com>
Subject: Re: [PATCH] mmtom: Prevent shrinking of active anon lru list in case 
	of no swap space V3
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <barrioskmc@gmail.com>
Cc: MinChan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/14 Minchan Kim <barrioskmc@gmail.com>:
> On Thu, May 14, 2009 at 11:27 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
>>>  mm/vmscan.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index 2f9d555..621708f 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -1577,7 +1577,7 @@ static void shrink_zone(int priority, struct zone *zone,
>>>         * Even if we did not try to evict anon pages at all, we want to
>>>         * rebalance the anon lru active/inactive ratio.
>>>         */
>>> -       if (inactive_anon_is_low(zone, sc))
>>> +       if (inactive_anon_is_low(zone, sc) && nr_swap_pages > 0)
>>>                shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
>>
>>
>>       if (nr_swap_pages > 0 && inactive_anon_is_low(zone, sc))
>>
>> is better?
>> compiler can't swap evaluate order around &&.
>
> If GCC optimizes away that branch with CONFIG_SWAP=n as Rik mentioned,
> we don't have a concern.

ok. I ack this.
