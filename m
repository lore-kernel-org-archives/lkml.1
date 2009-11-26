Return-Path: <linux-kernel-owner+w=401wt.eu-S1760144AbZKZOpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760144AbZKZOpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 09:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620AbZKZOpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 09:45:10 -0500
Received: from james.oetiker.ch ([213.144.138.195]:54538 "EHLO
	james.oetiker.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbZKZOpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 09:45:08 -0500
Date: Thu, 26 Nov 2009 15:45:13 +0100 (CET)
From: Tobias Oetiker <tobi@oetiker.ch>
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       linux-kernel@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [PATCH] vmscan: Stop kswapd waiting on congestion when the min
 watermark is not being met V2
In-Reply-To: <20091113200357.GO29804@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.0911261542500.21450@sebohet.brgvxre.pu>
References: <20091113142608.33B9.A69D9226@jp.fujitsu.com> <20091113135443.GF29804@csn.ul.ie> <20091114023138.3DA5.A69D9226@jp.fujitsu.com> <20091113181557.GM29804@csn.ul.ie> <2f11576a0911131033w4a9e6042k3349f0be290a167e@mail.gmail.com>
 <20091113200357.GO29804@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

Nov 13 Mel Gorman wrote:

> The last version has a stupid bug in it. Sorry.
>
> Changelog since V1
>   o Fix incorrect negation
>   o Rename kswapd_no_congestion_wait to kswapd_skip_congestion_wait as
>     suggested by Rik
>
> If reclaim fails to make sufficient progress, the priority is raised.
> Once the priority is higher, kswapd starts waiting on congestion.  However,
> if the zone is below the min watermark then kswapd needs to continue working
> without delay as there is a danger of an increased rate of GFP_ATOMIC
> allocation failure.
>
> This patch changes the conditions under which kswapd waits on
> congestion by only going to sleep if the min watermarks are being met.

I finally got around to test this together with the whole series on
2.6.31.6. after running it for a day I have not yet seen a single
order:5 allocation problem ... (while I had several an hour before)

for the record, my kernel is now running with the following
patches:

patch1:Date: Thu, 12 Nov 2009 19:30:31 +0000
patch1:Subject: [PATCH 1/5] page allocator: Always wake kswapd when restarting an allocation attempt after direct reclaim failed

patch2:Date: Thu, 12 Nov 2009 19:30:32 +0000
patch2:Subject: [PATCH 2/5] page allocator: Do not allow interrupts to use ALLOC_HARDER

patch3:Date: Thu, 12 Nov 2009 19:30:33 +0000
patch3:Subject: [PATCH 3/5] page allocator: Wait on both sync and async congestion after direct reclaim

patch4:Date: Thu, 12 Nov 2009 19:30:34 +0000
patch4:Subject: [PATCH 4/5] vmscan: Have kswapd sleep for a short interval and double check it should be asleep

patch5:Date: Fri, 13 Nov 2009 20:03:57 +0000
patch5:Subject: [PATCH] vmscan: Stop kswapd waiting on congestion when the min watermark is not being met V2

patch6:Date: Tue, 17 Nov 2009 10:34:21 +0000
patch6:Subject: [PATCH] vmscan: Have kswapd sleep for a short interval and double check it should be asleep fix 1

cheers
tobi

-- 
Tobi Oetiker, OETIKER+PARTNER AG, Aarweg 15 CH-4600 Olten, Switzerland
http://it.oetiker.ch tobi@oetiker.ch ++41 62 775 9902 / sb: -9900
