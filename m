Return-Path: <linux-kernel-owner+w=401wt.eu-S1760287AbZFKJSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760287AbZFKJSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 05:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbZFKJSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 05:18:09 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:23841 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbZFKJSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 05:18:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=W5PKhafQFJwzwO9q6rUizh4vZWoivrusGHwajxv3UWL/Z7q0PxEmj3k+YP2DOhRdEq
         9ktL5hX0XqTJFOAX/1H5AzakrSz8L7mAH1SFzDzUtpCQyMrJBCK80Z1rlLm6QoeDWEy7
         OtXOWKQ3y859qyFan7hOVjgeXgo2oJMHMhX/Q=
MIME-Version: 1.0
In-Reply-To: <20090611170018.c3758488.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090611165535.cf46bf29.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090611170018.c3758488.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 11 Jun 2009 18:18:10 +0900
Message-ID: <28c262360906110218t6a3ed908g9a4fba7fa7dd7b22@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n5B9Is54017404

On Thu, Jun 11, 2009 at 5:00 PM, KAMEZAWAHiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>>> At lumpy reclaim, a page failed to be taken by __isolate_lru_page() can> be pushed back to "src" list by list_move(). But the page may not be from> "src" list. And list_move() itself is unnecessary because the page is> not on top of LRU. Then, leave it as it is if __isolate_lru_page() fails.>> This patch doesn't change the logic as "we should exit loop or not" and> just fixes buggy list_move().>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>> ---> Â mm/vmscan.c | Â  Â 9 +--------> Â 1 file changed, 1 insertion(+), 8 deletions(-)>> Index: lumpy-reclaim-trial/mm/vmscan.c> ===================================================================> --- lumpy-reclaim-trial.orig/mm/vmscan.c> +++ lumpy-reclaim-trial/mm/vmscan.c> @@ -936,18 +936,11 @@ static unsigned long isolate_lru_pages(u> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â /* Check that we have not crossed a zone boundary. */> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â if (unlikely(page_zone_id(cursor_page) != zone_id))> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â continue;> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  switch (__isolate_lru_page(cursor_page, mode, file)) {> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  case 0:> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  if (__isolate_lru_page(cursor_page, mode, file) == 0) {> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â list_move(&cursor_page->lru, dst);> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â nr_taken++;> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â scan++;> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â break;
break ??
-- Kinds regards,Minchan Kimÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
