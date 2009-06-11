Return-Path: <linux-kernel-owner+w=401wt.eu-S932172AbZFKL2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbZFKL2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 07:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbZFKL2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 07:28:42 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:61188 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbZFKL2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:28:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=k4iuUDYskA5RPTs93q689mFY/s2RllLICx2qrhG2CCGEdeNYZ0GiwAPrJ7lRaJJXjM
         CwDZDGrrNBYRB+RMoSGrK5gftFFZDCLWE8LCPV9Q874nBE0Qub0gZN8u/Lm4PS9T6Jgq
         OY3WxylOJgPGARMzod6EZkJrouZQPXYbLn5s0=
MIME-Version: 1.0
In-Reply-To: <4c72e5b8de091845036fe2b5227168f5.squirrel@webmail-b.css.fujitsu.com>
References: <20090611165535.cf46bf29.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090611170018.c3758488.kamezawa.hiroyu@jp.fujitsu.com>
	 <28c262360906110218t6a3ed908g9a4fba7fa7dd7b22@mail.gmail.com>
	 <4c72e5b8de091845036fe2b5227168f5.squirrel@webmail-b.css.fujitsu.com>
Date: Thu, 11 Jun 2009 20:20:42 +0900
Message-ID: <28c262360906110420g666df03cl49d008dd7a608ae6@mail.gmail.com>
Subject: Re: [PATCH 1/3] remove wrong rotation at lumpy reclaim
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       apw@canonical.com, riel@redhat.com, mel@csn.ul.ie
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/11 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
> Minchan Kim wrote:
>> On Thu, Jun 11, 2009 at 5:00 PM, KAMEZAWA
>> Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>>
>>> At lumpy reclaim, a page failed to be taken by __isolate_lru_page() can
>>> be pushed back to "src" list by list_move(). But the page may not be
>>> from
>>> "src" list. And list_move() itself is unnecessary because the page is
>>> not on top of LRU. Then, leave it as it is if __isolate_lru_page()
>>> fails.
>>>
>>> This patch doesn't change the logic as "we should exit loop or not" and
>>> just fixes buggy list_move().
>>>
>>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>> ---
>>> ?mm/vmscan.c | ? ?9 +--------
>>> ?1 file changed, 1 insertion(+), 8 deletions(-)
>>>
>>> Index: lumpy-reclaim-trial/mm/vmscan.c
>>> ===================================================================
>>> --- lumpy-reclaim-trial.orig/mm/vmscan.c
>>> +++ lumpy-reclaim-trial/mm/vmscan.c
>>> @@ -936,18 +936,11 @@ static unsigned long isolate_lru_pages(u
>>> ? ? ? ? ? ? ? ? ? ? ? ?/* Check that we have not crossed a zone
>>> boundary. */
>>> ? ? ? ? ? ? ? ? ? ? ? ?if (unlikely(page_zone_id(cursor_page) !=
>>> zone_id))
>>> ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?continue;
>>> - ? ? ? ? ? ? ? ? ? ? ? switch (__isolate_lru_page(cursor_page, mode,
>>> file)) {
>>> - ? ? ? ? ? ? ? ? ? ? ? case 0:
>>> + ? ? ? ? ? ? ? ? ? ? ? if (__isolate_lru_page(cursor_page, mode, file)
>>> == 0) {
>>> ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?list_move(&cursor_page->lru, dst);
>>> ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?nr_taken++;
>>> ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?scan++;
>>> ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?break;
>>
>> break ??
>>
> good catch. I'll post updated one tomorrow.
> I'm very sorry ;(

Never mind.  :)

> Thanks,
> -Kame
>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>



-- 
Kinds regards,
Minchan Kim
