Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbZETKbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbZETKbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 06:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355AbZETKa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 06:30:56 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:35822 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848AbZETKaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 06:30:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=IG34n1H9Sgrwln+gCUVGEcYN9PmY7OJpU8MzPJ9dsNcq8IsAVZf4jN1TKf/x3VNfly
         LGmuGgczYCSLj+5+niJnPOsRAd1FzrIoMYOgod55Wd2K1FOtTFfLa9Aop/8JLh7WylGF
         AnvZai67jNnmniExvra+4nR+jeg6CBKRir7vc=
Date: Wed, 20 May 2009 19:30:45 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/3] clean up setup_per_zone_pages_min
Message-Id: <20090520193045.2070f7fa.minchan.kim@barrios-desktop>
In-Reply-To: <20090520102129.GA12433@csn.ul.ie>
References: <20090520161853.1bfd415c.minchan.kim@barrios-desktop>
	<20090520085416.GA27056@csn.ul.ie>
	<20090520185803.e5b0698a.minchan.kim@barrios-desktop>
	<20090520102129.GA12433@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 May 2009 11:21:29 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> On Wed, May 20, 2009 at 06:58:03PM +0900, Minchan Kim wrote:
> > Hi, Mel. 
> > 
> > On Wed, 20 May 2009 09:54:16 +0100
> > Mel Gorman <mel@csn.ul.ie> wrote:
> > 
> > > On Wed, May 20, 2009 at 04:18:53PM +0900, Minchan Kim wrote:
> > > > 
> > > > Mel changed zone->pages_[high/low/min] with zone->watermark array.
> > > > So, setup_per_zone_pages_min also have to be changed.
> > > > 
> > > 
> > > Just to be clear, this is a function renaming to match the new zone
> > > field name, not something I missed. As the function changes min, low and
> > > max, a better name might have been setup_per_zone_watermarks but whether
> > 
> > At first, I thouht, too. But It's handle of min_free_kbytes.
> > Documentation said, it's to compute a watermark[WMARK_MIN]. 
> > I think many people already used that knob to contorl pages_min to keep the 
> > low pages. 
> 
> Which documentation?

Documentation/sysctl/vm.txt - min_free_kbytes.

> I'm looking at the function comment and see
> 
>  * setup_per_zone_pages_min - called when min_free_kbytes changes.
>  *
>  * Ensures that the pages_{min,low,high} values for each zone are set
>  * correctly with respect to min_free_kbytes.
> 
> So, the values of all the watermarks are updated by that function depending
> on what the new value of min_free_kbytes is. It is a bit wrong I suppose as
> it missed memory hot-add
> 
> setup_per_zone_pages_min - called when min_free_kbytes changes or when memory is hot-added

God!. I changed this function's comments with memory hot plug. 
With my mistake, My patch 3/3 lost it. 
I will add comment about memory hotplug.

Thanks for pointing me out. :)


> > 
> > So, I determined function name is proper now. 
> > If setup_per_zone_watermark is better than it, we also have to change with 
> > documentation. 
> > 
> > > you go with that name or not, this is better than what is there so;
> > > 
> > > Acked-by: Mel Gorman <mel@csn.ul.ie>
> > 
> > 
> > -- 
> > Kinds Regards
> > Minchan Kim
> > 
> 
> -- 
> Mel Gorman
> Part-time Phd Student                          Linux Technology Center
> University of Limerick                         IBM Dublin Software Lab


-- 
Kinds Regards
Minchan Kim
