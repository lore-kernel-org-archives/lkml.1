Return-Path: <linux-kernel-owner+w=401wt.eu-S1758923AbXEJSAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923AbXEJSAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 14:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbXEJSAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 14:00:34 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48642 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750755AbXEJSAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 14:00:33 -0400
Date: Thu, 10 May 2007 11:00:31 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Yasunori Goto <y-goto@jp.fujitsu.com>
cc: linux-mm <linux-mm@kvack.org>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC] memory hotremove patch take 2 [01/10] (counter of removable
 page)
In-Reply-To: <20070509120132.B906.Y-GOTO@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0705101058260.10002@schroedinger.engr.sgi.com>
References: <20070509115506.B904.Y-GOTO@jp.fujitsu.com>
 <20070509120132.B906.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007, Yasunori Goto wrote:

>  
> +unsigned int nr_free_movable_pages(void)
> +{
> +	unsigned long nr_pages = 0;
> +	struct zone *zone;
> +	int nid;
> +
> +	for_each_online_node(nid) {
> +		zone = &(NODE_DATA(nid)->node_zones[ZONE_MOVABLE]);
> +		nr_pages += zone_page_state(zone, NR_FREE_PAGES);
> +	}
> +	return nr_pages;
> +}


Hmmmm... This is redoing what the vm counters already provide

Could you add

NR_MOVABLE_PAGES etc.

instead and then let the ZVC counter logic take care of the rest?

With a ZVC you will have the numbers in each zone and also in 
/proc/vmstat.

(Additional ulterior motive: If we ever get away from ZONE_MOVABLE and 
make movable a portion of each zone then this will still work)
