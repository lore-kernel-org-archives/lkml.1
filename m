Return-Path: <linux-kernel-owner+w=401wt.eu-S1762149AbZD1QrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762149AbZD1QrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 12:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756753AbZD1QrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 12:47:05 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:60994 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992AbZD1QrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 12:47:04 -0400
Date: Tue, 28 Apr 2009 12:37:22 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH] Properly account for freed pages in free_pages_bulk()
 and when allocating high-order pages in buffered_rmqueue()
In-Reply-To: <20090428103159.GB23540@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0904281236350.21913@qirst.com>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie> <1240819119.2567.884.camel@ymzhang> <20090427143845.GC912@csn.ul.ie> <1240883957.2567.886.camel@ymzhang> <20090428103159.GB23540@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009, Mel Gorman wrote:

> @@ -1151,6 +1151,7 @@ again:
>  	} else {
>  		spin_lock_irqsave(&zone->lock, flags);
>  		page = __rmqueue(zone, order, migratetype);
> +		__mod_zone_page_state(zone, NR_FREE_PAGES, -(1UL << order));
>  		spin_unlock(&zone->lock);
>  		if (!page)
>  			goto failed;

__mod_zone_page_state takes an signed integer argument. Not sure what is
won by the UL suffix here.

