Return-Path: <linux-kernel-owner+w=401wt.eu-S1752959AbZBRKYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbZBRKYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 05:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbZBRKYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 05:24:00 -0500
Received: from cmpxchg.org ([85.214.51.133]:48342 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbZBRKX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 05:23:59 -0500
Date: Wed, 18 Feb 2009 11:26:03 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] vmscan: respect higher order in zone_reclaim()
Message-ID: <20090218102603.GA2160@cmpxchg.org>
References: <20090217194826.GA17415@cmpxchg.org> <20090218101204.GA27970@csn.ul.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218101204.GA27970@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 10:12:04AM +0000, Mel Gorman wrote:
> On Tue, Feb 17, 2009 at 08:48:27PM +0100, Johannes Weiner wrote:
> > zone_reclaim() already tries to free the requested 2^order pages but
> > doesn't pass the order information into the inner reclaim code.
> > 
> > This prevents lumpy reclaim from happening on higher orders although
> > the caller explicitely asked for that.
> > 
> > Fix it up by initializing the order field of the scan control
> > according to the request.
> > 
> 
> I'm fine with the patch but the changelog could have been better.  Optionally
> take this changelog but either way.
> 
> Acked-by: Mel Gorman <mel@csn.ul.ie>
> 
> Optional alternative changelog
> ==============================
> 
> During page allocation, there are two stages of direct reclaim that are applied
> to each zone in the preferred list. The first stage using zone_reclaim()
> reclaims unmapped file backed pages and slab pages if over defined limits as
> these are cheaper to reclaim. The caller specifies the order of the target
> allocation but the scan control is not being correctly initialised.
> 
> The impact is that the correct number of pages are being reclaimed but that
> lumpy reclaim is not being applied. This increases the chances of a full
> direct reclaim via try_to_free_pages() is required.
> 
> This patch initialises the order field of the scan control as requested
> by the caller.

Agreed, this is better.  Thank you, Mel.
