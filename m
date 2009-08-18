Return-Path: <linux-kernel-owner+w=401wt.eu-S1751937AbZHRWeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbZHRWeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 18:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbZHRWea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 18:34:30 -0400
Received: from sparc.brc.ubc.ca ([137.82.2.12]:53371 "EHLO sparc.brc.ubc.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbZHRWea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 18:34:30 -0400
Date: Tue, 18 Aug 2009 15:57:00 -0700 (PDT)
From: Vincent Li <macli@brc.ubc.ca>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] page-allocator: Split per-cpu list into
 one-list-per-migrate-type
In-Reply-To: <1250594162-17322-2-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.1.00.0908181550450.31547@mail.selltech.ca>
References: <1250594162-17322-1-git-send-email-mel@csn.ul.ie> <1250594162-17322-2-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Aug 2009, Mel Gorman wrote:

> +	/*
> +	 * We only track unreclaimable, reclaimable and movable on pcp lists.
			 ^^^^^^^^^^^^^  
Is it unmovable? I don't see unreclaimable migrate type on pcp lists. 
Just ask to make sure I undsterstand the comment right.

> +	 * Free ISOLATE pages back to the allocator because they are being
> +	 * offlined but treat RESERVE as movable pages so we can get those
> +	 * areas back if necessary. Otherwise, we may have to free
> +	 * excessively into the page allocator
> +	 */
> +	if (migratetype >= MIGRATE_PCPTYPES) {
> +		if (unlikely(migratetype == MIGRATE_ISOLATE)) {
> +			free_one_page(zone, page, 0, migratetype);
> +			goto out;
> +		}
> +		migratetype = MIGRATE_MOVABLE;
> +	}
> +

Vincent Li
Biomedical Research Center
University of British Columbia
