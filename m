Return-Path: <linux-kernel-owner+w=401wt.eu-S1752009AbZGTP5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbZGTP5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 11:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbZGTP5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 11:57:24 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:38462 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbZGTP5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 11:57:23 -0400
Date: Mon, 20 Jul 2009 21:17:19 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 5/5] Memory controller soft limit reclaim on
	contention (v9)
Message-ID: <20090720154719.GH24157@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090710125950.5610.99139.sendpatchset@balbir-laptop> <20090710130021.5610.74850.sendpatchset@balbir-laptop> <20090721001923.AF72.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090721001923.AF72.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2009-07-21 00:20:38]:

> 
> very sorry for the delaying.
>

No problem, thanks for the review and ack
 
> 
> > @@ -1918,6 +1951,7 @@ loop_again:
> >  		for (i = 0; i <= end_zone; i++) {
> >  			struct zone *zone = pgdat->node_zones + i;
> >  			int nr_slab;
> > +			int nid, zid;
> >  
> >  			if (!populated_zone(zone))
> >  				continue;
> > @@ -1932,6 +1966,15 @@ loop_again:
> >  			temp_priority[i] = priority;
> >  			sc.nr_scanned = 0;
> >  			note_zone_scanning_priority(zone, priority);
> > +
> > +			nid = pgdat->node_id;
> > +			zid = zone_idx(zone);
> > +			/*
> > +			 * Call soft limit reclaim before calling shrink_zone.
> > +			 * For now we ignore the return value
> > +			 */
> > +			mem_cgroup_soft_limit_reclaim(zone, order, sc.gfp_mask,
> > +							nid, zid);
> >  			/*
> >  			 * We put equal pressure on every zone, unless one
> >  			 * zone has way too many pages free already.
> 
> 
> In this part:
> 	Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> 
> 

-- 
	Balbir
