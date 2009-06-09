Return-Path: <linux-kernel-owner+w=401wt.eu-S932246AbZFIMHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246AbZFIMHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 08:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932199AbZFIMHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 08:07:17 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:34445 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183AbZFIMHO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 08:07:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Fx3RjAmItY+Sg8/WFRr9uY3hQjf/Iha2XtUnQ4m77RDFdiNzBOpf1VKVl3/yJq6MmB
         84qfNTfDsgh7A12pcuqvLU8LcNqFz2/G8hMeL1/tRkmk+ZyzxhVnG37Mezk1RMXLMAV/
         GkxMg7d0ZqSIUdxCZLpRaltSKPHaoV8cwSAJw=
MIME-Version: 1.0
In-Reply-To: <7ca0521d9b798ef8b56212e5b17ea713.squirrel@webmail-b.css.fujitsu.com>
References: <20090609181505.4083a213.kamezawa.hiroyu@jp.fujitsu.com>
	 <28c262360906090300s13f4ee09mcc9622c1e477eaad@mail.gmail.com>
	 <e8f208a7c6bec1818947c24658dc1561.squirrel@webmail-b.css.fujitsu.com>
	 <28c262360906090430p21125c51g10cfdc377a78d07b@mail.gmail.com>
	 <7ca0521d9b798ef8b56212e5b17ea713.squirrel@webmail-b.css.fujitsu.com>
Date: Tue, 9 Jun 2009 21:07:16 +0900
Message-ID: <28c262360906090507u75f5b594o71906777a91efa1@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH] fix wrong lru rotate back at lumpty reclaim
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andy Whitcroft <apw@canonical.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       riel@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/9 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
> Minchan Kim wrote:
>
>> I mean follow as
>>  908         /*
>>  909          * Attempt to take all pages in the order aligned region
>>  910          * surrounding the tag page.  Only take those pages of
>>  911          * the same active state as that tag page.  We may safely
>>  912          * round the target page pfn down to the requested order
>>  913          * as the mem_map is guarenteed valid out to MAX_ORDER,
>>  914          * where that page is in a different zone we will detect
>>  915          * it from its zone id and abort this block scan.
>>  916          */
>>  917         zone_id = page_zone_id(page);
>>
> But what this code really do is.
> ==
> 931                         /* Check that we have not crossed a zone
> boundary. */
>  932                         if (unlikely(page_zone_id(cursor_page) !=
> zone_id))
>  933                                 continue;
> ==
> continue. I think this should be "break"
> I wonder what "This block scan" means is "scanning this aligned block".

It is to find first page in same zone with target page when we have
crossed a zone.
so it shouldn't stop due to that.

I think 'abort' means stopping only the page.
If it is right, it would be better to change follow as.
"and continue scanning next page"

Let's Cced Andy Whitcroft.

> But I think the whoe code is not written as commented.
>
>>
>>>> If I understand it properly , don't we add goto phrase ?
>>>>
>>> No.
>>
>> If it is so, the break also is meaningless.
>>
> yes. I'll remove it. But need to add "exit from for loop" logic again.
>
> I'm sorry that the wrong logic of this loop was out of my sight.
> I'll review and rewrite this part all, tomorrow.

Yes. I will review tomorrow, too. :)

> Thanks,
> -Kame
>
>



-- 
Kinds regards,
Minchan Kim
