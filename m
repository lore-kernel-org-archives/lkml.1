Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274AbZJZRhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbZJZRhg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 13:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbZJZRhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 13:37:35 -0400
Received: from james.oetiker.ch ([213.144.138.195]:37150 "EHLO
	james.oetiker.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbZJZRhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 13:37:33 -0400
Date: Mon, 26 Oct 2009 18:37:36 +0100 (CET)
From: Tobias Oetiker <tobi@oetiker.ch>
To: Mel Gorman <mel@csn.ul.ie>
cc: Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, David Miller <davem@davemloft.net>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Kalle Valo <kalle.valo@iki.fi>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org\\\"" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/5] Candidate fix for increased number of GFP_ATOMIC
 failures V2
In-Reply-To: <1256221356-26049-1-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.0910261835440.24625@wbuna.brgvxre.pu>
References: <1256221356-26049-1-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

I have no done additional tests ... and can report the following

Thursday Mel Gorman wrote:

>   1/5 page allocator: Always wake kswapd when restarting an allocation attempt after direct reclaim failed
>   2/5 page allocator: Do not allow interrupts to use ALLOC_HARDER
>
>
> 	These patches correct problems introduced by me during the 2.6.31-rc1
> 	merge window. The patches were not meant to introduce any functional
> 	changes but two were missed.
>
> 	If your problem goes away with just these two patches applied,
> 	please tell me.

1+2 do not help

> Test 3: If you are getting allocation failures, try with the following patch
>
>   3/5 vmscan: Force kswapd to take notice faster when high-order watermarks are being hit
>
> 	This is a functional change that causes kswapd to notice sooner
> 	when high-order watermarks have been hit. There have been a number
> 	of changes in page reclaim since 2.6.30 that might have delayed
> 	when kswapd kicks in for higher orders
>
> 	If your problem goes away with these three patches applied, please
> 	tell me

1+2+3 do not help either

> Test 4: If you are still getting failures, apply the following
>   4/5 page allocator: Pre-emptively wake kswapd when high-order watermarks are hit
>
> 	This patch is very heavy handed and pre-emptively kicks kswapd when
> 	watermarks are hit. It should only be necessary if there has been
> 	significant changes in the timing and density of page allocations
> 	from an unknown source. Tobias, this patch is largely aimed at you.
> 	You reported that with patches 3+4 applied that your problems went
> 	away. I need to know if patch 3 on its own is enough or if both
> 	are required
>
> 	If your problem goes away with these four patches applied, please
> 	tell me

3 allone does not help
3+4 does ...

cheers
tobi
-- 
Tobi Oetiker, OETIKER+PARTNER AG, Aarweg 15 CH-4600 Olten, Switzerland
http://it.oetiker.ch tobi@oetiker.ch ++41 62 775 9902 / sb: -9900
