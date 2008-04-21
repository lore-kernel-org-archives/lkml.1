Return-Path: <linux-kernel-owner+w=401wt.eu-S1758569AbYDUNJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569AbYDUNJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756833AbYDUNJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:09:47 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55716 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772AbYDUNJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:09:46 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <13567392.1208782944657.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 21 Apr 2008 22:02:24 +0900 (JST)
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: Re: [PATCH]Fix usemap for DISCONTIG/FLATMEM with not-aligned zone initilaization.
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, Shi Weihua <shiwh@cn.fujitsu.com>,
       akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0804211250000.16476@blonde.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <Pine.LNX.4.64.0804211250000.16476@blonde.site>
 <20080418161522.GB9147@csn.ul.ie> <48080706.50305@cn.fujitsu.com>
 <48080930.5090905@cn.fujitsu.com> <48080B86.7040200@cn.fujitsu.com>
 <20080418211214.299f91cd.kamezawa.hiroyu@jp.fujitsu.com>
 <21878461.1208539556838.kamezawa.hiroyu@jp.fujitsu.com>
 <20080421112048.78f0ec76.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thank you for review.

>> +		z = page_zone(page);
>
>Does this have to be recalculated for every page?  The function name
>"memmap_init_zone" suggests it could be done just once (but I'm on
>unfamiliar territory here, ignore any nonsense from me).
>
you're right. I will consider this again.

>> -		if ((pfn & (pageblock_nr_pages-1)))
>> +		if ((z->zone_start_pfn < pfn)
>
>Shouldn't that be <= ?
>
yes.

>> +		    && (pfn < z->zone_start_pfn + z->spanned_pages)
>> +		    && !(pfn & (pageblock_nr_pages-1)))
>
>Ah, that line (with the ! in) makes more sense than what was there
>before; but that's an unrelated (minor) bugfix which you ought to
>mention separately in the change comment.
>
Ah, ok. I'll rewrite and post again. thank you.

-Kame
