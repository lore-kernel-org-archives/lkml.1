Return-Path: <linux-kernel-owner+w=401wt.eu-S1757048AbZFILUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048AbZFILUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 07:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756792AbZFILUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 07:20:30 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36529 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756547AbZFILU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 07:20:29 -0400
Message-ID: <e8f208a7c6bec1818947c24658dc1561.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <28c262360906090300s13f4ee09mcc9622c1e477eaad@mail.gmail.com>
References: <20090609181505.4083a213.kamezawa.hiroyu@jp.fujitsu.com>
    <28c262360906090300s13f4ee09mcc9622c1e477eaad@mail.gmail.com>
Date: Tue, 9 Jun 2009 20:20:29 +0900 (JST)
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
> On Tue, Jun 9, 2009 at 6:15 PM, KAMEZAWA
> Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>
>> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
>> In lumpty reclaim, "cursor_page" is found just by pfn. Then, we don't
>> know
>> from which LRU "cursor" page came from. Then, putback it to "src" list
>> is BUG.
>> Just leave it as it is.
>> (And I think rotate here is overkilling even if "src" is correct.)
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> ---
>> mm/vmscan.c | 5 ++---
>> 1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> Index: mmotm-2.6.30-Jun4/mm/vmscan.c
>> ===================================================================
>> --- mmotm-2.6.30-Jun4.orig/mm/vmscan.c
>> +++ mmotm-2.6.30-Jun4/mm/vmscan.c
>> @@ -940,10 +940,9 @@ static unsigned long isolate_lru_pages(u
>> nr_taken++;
>> scan++;
>> break;
>> -
>>case -EBUSY:
>
> We can remove case -EBUSY itself, too.
> It is meaningless.
>
Sure, will post v2 and remove EBUSY case.
(I'm sorry my webmail system converts a space to a multibyte char...
 then I cut some.)

>> - /* else it is being freed
>> elsewhere */
>> -
>> list_move(&cursor_page->lru, src);
>> +  /* Do nothing because we
>> don't know where
>> + cusrsor_page comes
>> from */
>>default:
>> break; /* ! on LRU or
>> wrong list */
>
> Hmm.. what meaning of this break ?
> We are in switch case.
> This "break" can't go out of loop.
yes.

> But comment said "abort this block scan".
>
Where ? the comment says the cursor_page is not on lru (PG_lru is unset)
> If I understand it properly , don't we add goto phrase ?
>
No.

Just try next page on list.

Thank you for review, I'll post updated one tomorrow.
-Kame

