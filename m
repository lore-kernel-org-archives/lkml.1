Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbZFJKg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbZFJKg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 06:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758339AbZFJKgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 06:36:24 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34815 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756073AbZFJKgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 06:36:22 -0400
Date: Wed, 10 Jun 2009 11:36:22 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>, yanmin.zhang@intel.com,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] Count the number of times zone_reclaim() scans and
	fails
Message-ID: <20090610103622.GI25943@csn.ul.ie>
References: <1244566904-31470-1-git-send-email-mel@csn.ul.ie> <1244566904-31470-4-git-send-email-mel@csn.ul.ie> <20090610104635.DDA6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090610104635.DDA6.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 10:47:20AM +0900, KOSAKI Motohiro wrote:
> Hi
> 
> I like this patch. thank you mel.
> 
> > @@ -2489,6 +2489,10 @@ int zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
> >  	ret = __zone_reclaim(zone, gfp_mask, order);
> >  	zone_clear_flag(zone, ZONE_RECLAIM_LOCKED);
> >  
> > +	if (!ret) {
> > +		count_vm_events(PGSCAN_ZONERECLAIM_FAILED, 1);
> > +	}
> > +
> >  	return ret;
> 
> count_vm_event(PGSCAN_ZONERECLAIM_FAILED)?
> 

/me slaps self

Yes, that makes more sense.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
