Return-Path: <linux-kernel-owner+w=401wt.eu-S1762981AbXHWNHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762981AbXHWNHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 09:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759398AbXHWNHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 09:07:35 -0400
Received: from gir.skynet.ie ([193.1.99.77]:58304 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757595AbXHWNHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 09:07:34 -0400
Date: Thu, 23 Aug 2007 14:07:32 +0100
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org
Subject: Re: [BUG] 2.6.23-rc3-mm1 kernel BUG at mm/page_alloc.c:2876!
Message-ID: <20070823130732.GC18456@skynet.ie>
References: <46CC9A7A.2030404@linux.vnet.ibm.com> <20070822134800.ce5a5a69.akpm@linux-foundation.org> <20070822135024.dde8ef5a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070822135024.dde8ef5a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (22/08/07 13:50), Andrew Morton didst pronounce:
> On Wed, 22 Aug 2007 13:48:00 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > This:
> > 
> > --- a/mm/page_alloc.c~a
> > +++ a/mm/page_alloc.c
> > @@ -2814,6 +2814,8 @@ static int __cpuinit process_zones(int c
> >  	return 0;
> >  bad:
> >  	for_each_zone(dzone) {
> > +		if (!populated_zone(zone))
> > +			continue;		
> >  		if (dzone == zone)
> >  			break;
> >  		kfree(zone_pcp(dzone, cpu));
> > _
> > 
> > might help avoid the crash
> 
> err, make that
> 

We're already in the error path at this point and it's going to blow up.
The real problem is kmalloc_node() returning NULL for whatever reason.

> --- a/mm/page_alloc.c~a
> +++ a/mm/page_alloc.c
> @@ -2814,6 +2814,8 @@ static int __cpuinit process_zones(int c
>  	return 0;
>  bad:
>  	for_each_zone(dzone) {
> +		if (!populated_zone(dzone))
> +			continue;
>  		if (dzone == zone)
>  			break;
>  		kfree(zone_pcp(dzone, cpu));
> _
> 
> 

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
