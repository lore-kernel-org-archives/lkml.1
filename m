Return-Path: <linux-kernel-owner+w=401wt.eu-S2993131AbXCIRVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993131AbXCIRVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 12:21:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992494AbXCIRVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 12:21:12 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:42491 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752700AbXCIRVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 12:21:07 -0500
Date: Fri, 9 Mar 2007 09:21:00 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@csn.ul.ie>
cc: akpm@osdl.org, Marcelo Tosatti <marcelo@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>, mpm@selenic.com,
       Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [SLUB 0/3] SLUB: The unqueued slab allocator V4
In-Reply-To: <Pine.LNX.4.64.0703091503580.16052@skynet.skynet.ie>
Message-ID: <Pine.LNX.4.64.0703090907330.7315@schroedinger.engr.sgi.com>
References: <20070307023502.19658.39217.sendpatchset@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0703081022040.1615@skynet.skynet.ie>
 <Pine.LNX.4.64.0703080836300.27191@schroedinger.engr.sgi.com>
 <20070308174004.GB12958@skynet.ie> <Pine.LNX.4.64.0703081135280.3130@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0703091503580.16052@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007, Mel Gorman wrote:

> The results without slub_debug were not good except for IA64. x86_64 and ppc64
> both blew up for a variety of reasons. The IA64 results were

Yuck that is the dst issue that Adrian is also looking at. Likely an issue 
with slab merging and RCU frees.
 
> KernBench Comparison
> --------------------
>                           2.6.21-rc2-mm2-clean       2.6.21-rc2-mm2-slub
> %diff
> User   CPU time                        1084.64                   1032.93 4.77%
> System CPU time                          73.38                     63.14 13.95%
> Total  CPU time                        1158.02                   1096.07 5.35%
> Elapsed    time                         307.00                    285.62 6.96%

Wow! The first indication that we are on the right track with this.

> AIM9 Comparison
>  2 page_test               2097119.26                 3398259.27 1301140.01 62.04% System Allocations & Pages/second

Wow! Must have all stayed within slab boundaries.

>  8 link_test                 64776.04                    7488.13  -57287.91 -88.44% Link/Unlink Pairs/second

Crap. Maybe we straddled a slab boundary here?
