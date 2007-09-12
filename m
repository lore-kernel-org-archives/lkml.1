Return-Path: <linux-kernel-owner+w=401wt.eu-S934549AbXILVY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934549AbXILVY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 17:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763739AbXILVXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 17:23:22 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:34491 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934029AbXILVXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 17:23:20 -0400
Date: Wed, 12 Sep 2007 14:23:19 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Lee.Schermerhorn@hp.com, kamezawa.hiroyu@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/6] Filter based on a nodemask as well as a gfp_mask
In-Reply-To: <20070912210625.31625.36220.sendpatchset@skynet.skynet.ie>
Message-ID: <Pine.LNX.4.64.0709121420010.3130@schroedinger.engr.sgi.com>
References: <20070912210444.31625.65810.sendpatchset@skynet.skynet.ie>
 <20070912210625.31625.36220.sendpatchset@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007, Mel Gorman wrote:

> -			z++)
> -		;
> +	if (likely(nodes == NULL))
> +		for (; zonelist_zone_idx(z) > highest_zoneidx;
> +				z++)
> +			;
> +	else
> +		for (; zonelist_zone_idx(z) > highest_zoneidx ||
> +				(z->zone && !zref_in_nodemask(z, nodes));
> +				z++)
> +			;
>  

Minor nitpick here: "for (;" should become "for ( ;" to have correct 
whitespace. However, it would be clearer to use a while here.

while (zonelist_zone_idx(z)) > highest_zoneidx)
		z++;

etc.
