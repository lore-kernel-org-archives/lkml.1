Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbZHULTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbZHULTE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 07:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbZHULTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 07:19:03 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:59176 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbZHULTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 07:19:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sdq/BgssciVwMrmITO7ahHQ7ZngQ5hmtVz3f78qUzxJ7PbvcecWrM8NecA5PRHNSvJ
         bB3dJeMi1N5wTxxExbqr58i4Tm9/XI351hC4zGBIG0CoNXWqaeofgxV5vG5lVp8rVhLc
         RQ73JJuyNi4Uh+kdLPIODJn8dDanjSq0yvq0Q=
MIME-Version: 1.0
In-Reply-To: <4A8C98DD.9030500@redhat.com>
References: <20090820085544.faed1ca4.minchan.kim@barrios-desktop>
	 <4A8C98DD.9030500@redhat.com>
Date: Fri, 21 Aug 2009 20:19:02 +0900
X-Google-Sender-Auth: ed9c3569ffb1da2f
Message-ID: <2f11576a0908210419u2feadeaxc40ffda1cd7f6b2d@mail.gmail.com>
Subject: Re: [PATCH] mm: Fix to infinite churning of mlocked page
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, linux-mm <linux-mm@kvack.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/20 Rik van Riel <riel@redhat.com>:
> Minchan Kim wrote:
>>
>> Mlocked page might lost the isolatation race.
>> It cause the page to clear PG_mlocked while it remains
>> in VM_LOCKED vma. It means it can be put [in]active list.
>> We can rescue it by try_to_unmap in shrink_page_list.
>>
>> But now, As Wu Fengguang pointed out, vmscan have a bug.
>> If the page has PG_referenced, it can't reach try_to_unmap
>> in shrink_page_list but put into active list. If the page
>> is referenced repeatedly, it can remain [in]active list
>> without moving unevictable list.
>>
>> This patch can fix it.
>>
>> Reported-by: Wu Fengguang <fengguang.wu@intel.com>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>> Cc: KOSAKI Motohiro <<kosaki.motohiro@jp.fujitsu.com>
>> Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
>> Cc: Rik van Riel <riel@redhat.com>
>
> Acked-by: Rik van Riel <riel@redhat.com>

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
