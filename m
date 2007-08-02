Return-Path: <linux-kernel-owner+w=401wt.eu-S1760050AbXHBTrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050AbXHBTrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 15:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755251AbXHBTrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 15:47:41 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:33558 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653AbXHBTrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 15:47:40 -0400
Subject: Re: [PATCH] Apply memory policies to top two highest zones when
	highest zone is ZONE_MOVABLE
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Mel Gorman <mel@skynet.ie>
Cc: akpm@linux-foundation.org, clameter@sgi.com,
       kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070802172118.GD23133@skynet.ie>
References: <20070802172118.GD23133@skynet.ie>
Content-Type: text/plain
Organization: HP/OSLO
Date: Thu, 02 Aug 2007 15:41:51 -0400
Message-Id: <1186083711.5040.74.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-02 at 18:21 +0100, Mel Gorman wrote:
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
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>


And an ia_64 NUMA platform with some ad hoc, interactive functional
testing with memtoy and an overnight run of a usex job mix.  Job mix
included a 32-way kernel build, several povray tracing apps, IO tests,
sequential and random vm fault tests and a number of 'bin' tests that
simulate a half a dozen crazed monkeys pounding away at keyboards
entering surprisingly error-free commands.  All of these loop until
stopped or the system hangs/crashes--which it didn't...


Acked-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
Tested-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>



