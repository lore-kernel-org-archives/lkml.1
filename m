Return-Path: <linux-kernel-owner+w=401wt.eu-S966955AbXILVWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966955AbXILVWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 17:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765521AbXILVRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 17:17:36 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:34109 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933945AbXILVRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 17:17:34 -0400
Date: Wed, 12 Sep 2007 14:17:32 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Lee.Schermerhorn@hp.com, kamezawa.hiroyu@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/6] Have zonelist contains structs with both a zone
 pointer and zone_idx
In-Reply-To: <20070912210605.31625.85794.sendpatchset@skynet.skynet.ie>
Message-ID: <Pine.LNX.4.64.0709121415350.3130@schroedinger.engr.sgi.com>
References: <20070912210444.31625.65810.sendpatchset@skynet.skynet.ie>
 <20070912210605.31625.85794.sendpatchset@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007, Mel Gorman wrote:

>  /*
> + * This struct contains information about a zone in a zonelist. It is stored
> + * here to avoid dereferences into large structures and lookups of tables
> + */
> +struct zoneref {
> +	struct zone *zone;	/* Pointer to actual zone */
> +	int zone_idx;		/* zone_idx(zoneref->zone) */
> +};


Well the structure is going to be 12 bytes wide. Since pointers have to be 
aligned to 8 bytes we will effectively have to use 16 bytes anyways. There 
is no additional memory use if we would be adding another 4 bytes.

But lets get this merged. We can sort this out later. Too many 
oscillations already.
