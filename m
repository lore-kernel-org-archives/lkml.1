Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbZBJMb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbZBJMb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 07:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbZBJMbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 07:31:18 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:52315 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbZBJMbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 07:31:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ImrR/z+uynIXjNRGlh0H3GR4zdiCHE+xFTGZZlG4Rq31uqviRksr4HPDW9d57NkF6x
         uI1TXOEDtBeqqmgL7Y2ExOKSJvW8Prjkq4qYkrG00d+I7cw0R8DtuIbZDksUSBm0W1RQ
         uY9bFhaw3zaPpAO/r2jt1SnIsmI+R3t9tNi24=
MIME-Version: 1.0
In-Reply-To: <20090210210520.7004.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20090210204210.6FEF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <28c262360902100403m772576afp3c9212157dc9fcd@mail.gmail.com>
	 <20090210210520.7004.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Date: Tue, 10 Feb 2009 21:31:04 +0900
Message-ID: <28c262360902100431l4a5977e7p9c5152882f09dcf9@mail.gmail.com>
Subject: Re: [RFC] vmscan: initialize sc->nr_reclaimed in do_try_to_free_pages()
From: MinChan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
       William Lee Irwin III <wli@movementarian.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 9:06 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> > static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
>> > {
>> >        /* Minimum pages needed in order to stay on node */
>> >        const unsigned long nr_pages = 1 << order;
>> >        struct task_struct *p = current;
>> >        struct reclaim_state reclaim_state;
>> >        int priority;
>> >        struct scan_control sc = {
>> >                .may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
>> >                .may_swap = !!(zone_reclaim_mode & RECLAIM_SWAP),
>> >                .swap_cluster_max = max_t(unsigned long, nr_pages,
>> >                                        SWAP_CLUSTER_MAX),
>> >                .gfp_mask = gfp_mask,
>> >                .swappiness = vm_swappiness,
>> >                .isolate_pages = isolate_pages_global,
>> > +               .nr_reclaimed = 0;
>> >        };
>>
>> Hmm.. I missed that.  Thanks.
>> There is one in shrink_all_memory.
>
> No.
> __zone_reclaim isn't a part of shrink_all_memory().
> Currently, shrink_all_memory() don't use sc.nr_reclaimed member.
> (maybe, it's another wrong thing ;)

Hmm.. You're right.
As Johannes pointed out,
too many page shrinking can degrade resume performance.

We need to bale out in shrink_all_memory.
Other people, thought ?

-- 
Kinds regards,
MinChan Kim
