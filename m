Return-Path: <linux-kernel-owner+w=401wt.eu-S1763623AbXHQU7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763623AbXHQU7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 16:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756951AbXHQU72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 16:59:28 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47405 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756209AbXHQU71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 16:59:27 -0400
Date: Fri, 17 Aug 2007 13:59:26 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Lee.Schermerhorn@hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 2/6] Use one zonelist that is filtered instead of multiple
 zonelists
In-Reply-To: <20070817201728.14792.42873.sendpatchset@skynet.skynet.ie>
Message-ID: <Pine.LNX.4.64.0708171355580.9635@schroedinger.engr.sgi.com>
References: <20070817201647.14792.2690.sendpatchset@skynet.skynet.ie>
 <20070817201728.14792.42873.sendpatchset@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2007, Mel Gorman wrote:

> +/* Returns the first zone at or below highest_zoneidx in a zonelist */
> +static inline struct zone **first_zones_zonelist(struct zonelist *zonelist,
> +					enum zone_type highest_zoneidx)
> +{
> +	struct zone **z;
> +	for (z = zonelist->zones; zone_idx(*z) > highest_zoneidx; z++);
> +	return z;
> +}

The formatting above is a bit confusing. Add requires empty lines and put 
the ; on a separate line.


> +/* Returns the next zone at or below highest_zoneidx in a zonelist */
> +static inline struct zone **next_zones_zonelist(struct zone **z,
> +					enum zone_type highest_zoneidx)
> +{
> +	for (++z; zone_idx(*z) > highest_zoneidx; z++);

Looks weird too.

++z on an earlier line and then

	for ( ; zone_idx(*z) ...)

?
