Return-Path: <linux-kernel-owner+w=401wt.eu-S1755095AbZJVK1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbZJVK1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 06:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755051AbZJVK1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 06:27:32 -0400
Received: from james.oetiker.ch ([213.144.138.195]:37757 "EHLO
	james.oetiker.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023AbZJVK13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 06:27:29 -0400
Date: Thu, 22 Oct 2009 12:27:32 +0200 (CEST)
From: Tobias Oetiker <tobi@oetiker.ch>
To: Mel Gorman <mel@csn.ul.ie>
cc: Frans Pop <elendil@planet.nl>, Pekka Enberg <penberg@cs.helsinki.fi>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>, linux-mm@kvack.org,
       jens.axboe@oracle.com
Subject: Re: [Bug #14141] order 2 page allocation failures (generic)
In-Reply-To: <20091020133957.GG11778@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.0910221226020.23696@sebohet.brgvxre.pu>
References: <alpine.DEB.2.00.0910191538450.8526@sebohet.brgvxre.pu> <20091019140957.GE9036@csn.ul.ie> <alpine.DEB.2.00.0910191613580.8526@sebohet.brgvxre.pu> <20091019145954.GH9036@csn.ul.ie> <alpine.DEB.2.00.0910192211230.27123@sebohet.brgvxre.pu>
 <alpine.DEB.2.00.0910192215450.27123@sebohet.brgvxre.pu> <20091020105746.GD11778@csn.ul.ie> <alpine.DEB.2.00.0910201338530.27123@sebohet.brgvxre.pu> <20091020125139.GF11778@csn.ul.ie> <alpine.DEB.2.00.0910201456540.27618@sebohet.brgvxre.pu>
 <20091020133957.GG11778@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

Tuesday Mel Gorman wrote:
> 4. Does the following patch help by any chance?
>
> Thanks
>
> ==== CUT HERE ====
> vmscan: Force kswapd to take notice faster when high-order watermarks are being hit
>
> When a high-order allocation fails, kswapd is kicked so that it reclaims
> at a higher-order to avoid direct reclaimers stall and to help GFP_ATOMIC
> allocations. Something has changed in recent kernels that affect the timing
> where high-order GFP_ATOMIC allocations are now failing with more frequency,
> particularly under pressure. This patch forces kswapd to notice sooner that
> high-order allocations are occuring by checking when watermarks are hit early
> and by having kswapd restart quickly when the reclaim order is increased.
>
> Not-signed-off-by-because-this-is-a-hatchet-job: Mel Gorman <mel@csn.ul.ie>
> ---

it does seem to help ... I have been running it from 6am to 12am on
our server now and have not yet seen any issues ...

will shout if I do ...

cheers
tobi

-- 
Tobi Oetiker, OETIKER+PARTNER AG, Aarweg 15 CH-4600 Olten, Switzerland
http://it.oetiker.ch tobi@oetiker.ch ++41 62 775 9902 / sb: -9900
