Return-Path: <linux-kernel-owner+w=401wt.eu-S1759854AbZFILr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759854AbZFILr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 07:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbZFILrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 07:47:49 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39088 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142AbZFILrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 07:47:48 -0400
Message-ID: <7ca0521d9b798ef8b56212e5b17ea713.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <28c262360906090430p21125c51g10cfdc377a78d07b@mail.gmail.com>
References: <20090609181505.4083a213.kamezawa.hiroyu@jp.fujitsu.com>
    <28c262360906090300s13f4ee09mcc9622c1e477eaad@mail.gmail.com>
    <e8f208a7c6bec1818947c24658dc1561.squirrel@webmail-b.css.fujitsu.com>
    <28c262360906090430p21125c51g10cfdc377a78d07b@mail.gmail.com>
Date: Tue, 9 Jun 2009 20:47:45 +0900 (JST)
Subject: Re: [BUGFIX][PATCH] fix wrong lru rotate back at lumpty reclaim
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Minchan Kim" <minchan.kim@gmail.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       riel@redhat.com
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minchan Kim wrote:

> I mean follow as
>  908         /*
>  909          * Attempt to take all pages in the order aligned region
>  910          * surrounding the tag page.  Only take those pages of
>  911          * the same active state as that tag page.  We may safely
>  912          * round the target page pfn down to the requested order
>  913          * as the mem_map is guarenteed valid out to MAX_ORDER,
>  914          * where that page is in a different zone we will detect
>  915          * it from its zone id and abort this block scan.
>  916          */
>  917         zone_id = page_zone_id(page);
>
But what this code really do is.
==
931                         /* Check that we have not crossed a zone
boundary. */
 932                         if (unlikely(page_zone_id(cursor_page) !=
zone_id))
 933                                 continue;
==
continue. I think this should be "break"
I wonder what "This block scan" means is "scanning this aligned block".

But I think the whoe code is not written as commented.

>
>>> If I understand it properly , don't we add goto phrase ?
>>>
>> No.
>
> If it is so, the break also is meaningless.
>
yes. I'll remove it. But need to add "exit from for loop" logic again.

I'm sorry that the wrong logic of this loop was out of my sight.
I'll review and rewrite this part all, tomorrow.

Thanks,
-Kame

