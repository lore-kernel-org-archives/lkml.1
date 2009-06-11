Return-Path: <linux-kernel-owner+w=401wt.eu-S1763125AbZFKLOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763125AbZFKLOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 07:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762167AbZFKLNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 07:13:48 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58883 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763030AbZFKLNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:13:46 -0400
Message-ID: <4c72e5b8de091845036fe2b5227168f5.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <28c262360906110218t6a3ed908g9a4fba7fa7dd7b22@mail.gmail.com>
References: <20090611165535.cf46bf29.kamezawa.hiroyu@jp.fujitsu.com>
    <20090611170018.c3758488.kamezawa.hiroyu@jp.fujitsu.com>
    <28c262360906110218t6a3ed908g9a4fba7fa7dd7b22@mail.gmail.com>
Date: Thu, 11 Jun 2009 20:13:46 +0900 (JST)
Subject: Re: [PATCH 1/3] remove wrong rotation at lumpy reclaim
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Minchan Kim" <minchan.kim@gmail.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       apw@canonical.com, riel@redhat.com, mel@csn.ul.ie
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
> On Thu, Jun 11, 2009 at 5:00 PM, KAMEZAWA
> Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
>> At lumpy reclaim, a page failed to be taken by __isolate_lru_page() can
>> be pushed back to "src" list by list_move(). But the page may not be
>> from
>> "src" list. And list_move() itself is unnecessary because the page is
>> not on top of LRU. Then, leave it as it is if __isolate_lru_page()
>> fails.
>>
>> This patch doesn't change the logic as "we should exit loop or not" and
>> just fixes buggy list_move().
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> ---
>> ?mm/vmscan.c | ? ?9 +--------
>> ?1 file changed, 1 insertion(+), 8 deletions(-)
>>
>> Index: lumpy-reclaim-trial/mm/vmscan.c
>> ===================================================================
>> --- lumpy-reclaim-trial.orig/mm/vmscan.c
>> +++ lumpy-reclaim-trial/mm/vmscan.c
>> @@ -936,18 +936,11 @@ static unsigned long isolate_lru_pages(u
>> ? ? ? ? ? ? ? ? ? ? ? ?/* Check that we have not crossed a zone
>> boundary. */
>> ? ? ? ? ? ? ? ? ? ? ? ?if (unlikely(page_zone_id(cursor_page) !=
>> zone_id))
>> ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?continue;
>> - ? ? ? ? ? ? ? ? ? ? ? switch (__isolate_lru_page(cursor_page, mode,
>> file)) {
>> - ? ? ? ? ? ? ? ? ? ? ? case 0:
>> + ? ? ? ? ? ? ? ? ? ? ? if (__isolate_lru_page(cursor_page, mode, file)
>> == 0) {
>> ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?list_move(&cursor_page->lru, dst);
>> ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?nr_taken++;
>> ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?scan++;
>> ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?break;
>
> break ??
>
good catch. I'll post updated one tomorrow.
I'm very sorry ;(

Thanks,
-Kame


