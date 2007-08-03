Return-Path: <linux-kernel-owner+w=401wt.eu-S1763782AbXHCWCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763782AbXHCWCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 18:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763685AbXHCWCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 18:02:23 -0400
Received: from mx1.suse.de ([195.135.220.2]:59698 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763625AbXHCWCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 18:02:22 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Mel Gorman <mel@skynet.ie>
Subject: Re: [PATCH] Apply memory policies to top two highest zones when highest zone is ZONE_MOVABLE
Date: Sat, 4 Aug 2007 00:02:17 +0200
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, Lee.Schermerhorn@hp.com, clameter@sgi.com,
       kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <20070802172118.GD23133@skynet.ie>
In-Reply-To: <20070802172118.GD23133@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708040002.18167.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 August 2007 19:21:18 Mel Gorman wrote:
> The NUMA layer only supports NUMA policies for the highest zone. When
> ZONE_MOVABLE is configured with kernelcore=, the the highest zone becomes
> ZONE_MOVABLE. The result is that policies are only applied to allocations
> like anonymous pages and page cache allocated from ZONE_MOVABLE when the
> zone is used.
> 
> This patch applies policies to the two highest zones when the highest zone
> is ZONE_MOVABLE. As ZONE_MOVABLE consists of pages from the highest "real"
> zone, it's always functionally equivalent.
> 
> The patch has been tested on a variety of machines both NUMA and non-NUMA
> covering x86, x86_64 and ppc64. No abnormal results were seen in kernbench,
> tbench, dbench or hackbench. It passes regression tests from the numactl
> package with and without kernelcore= once numactl tests are patched to
> wait for vmstat counters to update.
 
I must honestly say I really hate the patch. It's a horrible hack and makes fast paths
slower. When I designed mempolicies I especially tried to avoid things
like that, please don't add them through the backdoor now.

-Andi
