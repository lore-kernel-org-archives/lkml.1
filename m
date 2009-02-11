Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbZBKM7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbZBKM7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 07:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754496AbZBKM7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 07:59:05 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51802 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbZBKM7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:59:04 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: MinChan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] shrink_all_memory() use sc.nr_reclaimed
Cc: kosaki.motohiro@jp.fujitsu.com, Johannes Weiner <hannes@cmpxchg.org>,
       Rik van Riel <riel@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       William Lee Irwin III <wli@movementarian.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20090211214324.6a9cfb58.minchan.kim@barrios-desktop>
References: <20090211204453.C3C3.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090211214324.6a9cfb58.minchan.kim@barrios-desktop>
Message-Id: <20090211215654.C3D6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed, 11 Feb 2009 21:58:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm, I think old bale-out code is right. 
> In shrink_all_memory, As more reclaiming with pass progressing, 
> the smaller nr_to_scan is. The nr_to_scan is the number of page shrinking which
> user want. 
> The shrink_all_zones have to reclaim nr_to_scan's page by doing best effort.
> So, If you use accumulation of reclaim, it can break bale-out in shrink_all_zones.

you are right. thanks.
shrink_all_zones()'s nr_pages != shrink_all_memory()'s nr_pages.
(I don't like this misleading variable name scheme ;)


> I mean here.
> 
> '
>               NR_LRU_BASE + l)); 
>         ret += shrink_list(l, nr_to_scan, zone,
>                 sc, prio);
>         if (ret >= nr_pages)
>           return ret; 
>       }    
> '
> 
> I have to make patch again so that it will keep on old bale-out behavior. 

Sure.
thanks.



