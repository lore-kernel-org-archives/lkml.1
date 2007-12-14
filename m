Return-Path: <linux-kernel-owner+w=401wt.eu-S935574AbXLNA5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935574AbXLNA5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761373AbXLNA5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 19:57:40 -0500
Received: from adsl-76-243-235-52.dsl.chcgil.sbcglobal.net ([76.243.235.52]:48385
	"EHLO accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753320AbXLNA5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 19:57:38 -0500
Subject: Re: [PATCH] fix page_alloc for larger I/O segments (improved)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Mark Lord <liml@rtr.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, jens.axboe@oracle.com,
       lkml@rtr.ca, matthew@wil.cx, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-mm@kvack.org, mel@csn.ul.ie
In-Reply-To: <4761D279.6050500@rtr.ca>
References: <20071213185326.GQ26334@parisc-linux.org>
	 <4761821F.3050602@rtr.ca>	<20071213192633.GD10104@kernel.dk>
	 <4761883A.7050908@rtr.ca>	<476188C4.9030802@rtr.ca>
	 <20071213193937.GG10104@kernel.dk>	<47618B0B.8020203@rtr.ca>
	 <20071213195350.GH10104@kernel.dk>	<20071213200219.GI10104@kernel.dk>
	 <476190BE.9010405@rtr.ca>	<20071213200958.GK10104@kernel.dk>
	 <20071213140207.111f94e2.akpm@linux-foundation.org>
	 <1197584106.3154.55.camel@localhost.localdomain>
	 <20071213142935.47ff19d9.akpm@linux-foundation.org>
	 <4761B32A.3070201@rtr.ca>	<4761BCB4.1060601@rtr.ca>
	 <4761C8E4.2010900@rtr.ca>	<4761CE88.9070406@rtr.ca>
	 <20071213163726.3bb601fa.akpm@linux-foundation.org>
	 <4761D160.7060603@rtr.ca>  <4761D279.6050500@rtr.ca>
Content-Type: text/plain
Date: Thu, 13 Dec 2007 19:57:29 -0500
Message-Id: <1197593849.3154.62.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-13 at 19:46 -0500, Mark Lord wrote:
> "Improved version", more similar to the 2.6.23 code:
> 
> Fix page allocator to give better chance of larger contiguous segments (again).
> 
> Signed-off-by: Mark Lord <mlord@pobox.com
> ---
> 
> --- old/mm/page_alloc.c	2007-12-13 19:25:15.000000000 -0500
> +++ linux-2.6/mm/page_alloc.c	2007-12-13 19:43:07.000000000 -0500
> @@ -760,7 +760,7 @@
>  		struct page *page = __rmqueue(zone, order, migratetype);
>  		if (unlikely(page == NULL))
>  			break;
> -		list_add(&page->lru, list);
> +		list_add_tail(&page->lru, list);

Could we put a big comment above this explaining to the would be vm
tweakers why this has to be a list_add_tail, so we don't end up back in
this position after another two years?

James


