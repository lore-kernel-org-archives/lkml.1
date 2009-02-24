Return-Path: <linux-kernel-owner+w=401wt.eu-S1759576AbZBXRfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576AbZBXRfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:35:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756176AbZBXRfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:35:44 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:55113 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754584AbZBXRfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:35:43 -0500
Date: Tue, 24 Feb 2009 12:27:02 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 08/19] Simplify the check on whether cpusets are a factor
 or not
In-Reply-To: <1235477835-14500-9-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0902241226280.32227@qirst.com>
References: <1235477835-14500-1-git-send-email-mel@csn.ul.ie> <1235477835-14500-9-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009, Mel Gorman wrote:

> @@ -1420,8 +1429,8 @@ zonelist_scan:
>  		if (NUMA_BUILD && zlc_active &&
>  			!zlc_zone_worth_trying(zonelist, z, allowednodes))
>  				continue;
> -		if ((alloc_flags & ALLOC_CPUSET) &&
> -			!cpuset_zone_allowed_softwall(zone, gfp_mask))
> +		if (alloc_cpuset)
> +			if (!cpuset_zone_allowed_softwall(zone, gfp_mask))
>  				goto try_next_zone;

Hmmm... Why remove the && here? Looks more confusing to me.

