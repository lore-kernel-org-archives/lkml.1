Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbXGJMiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbXGJMiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 08:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbXGJMiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 08:38:04 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1034 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262AbXGJMiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 08:38:01 -0400
Message-ID: <46937DA2.4040302@shadowen.org>
Date: Tue, 10 Jul 2007 13:37:54 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <clameter@sgi.com>
Subject: clam
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
In-Reply-To: <20070710013152.ef2cd200.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

[...]
> lumpy-reclaim-v4.patch
> have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
> only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
> 
>  Lumpy reclaim.  In a similar situation to Mel's patches.  Stuck due to
>  general lack or interest and effort.

The lumpy reclaim patches originally came out of work to support Mel's
anti-fragmentation work.  As such I think they have become somewhat
attached to those patches.  Whilst lumpy is most effective where
placement controls are in place as offered by Mel's work, we see benefit
from reduction in the "blunderbuss" effect when we reclaim at higher
orders.  While placement control is pretty much required for the very
highest orders such as huge page size, lower order allocations are
benefited in terms of lower collateral damage.

There are now a few areas other than huge page allocations which can
benefit.  Stacks are still order 1.  Jumbo frames want higher order
contiguous pages for there incoming hardware buffers.  SLUB is showing
performance benefits from moving to a higher allocation order.  All of
these should benefit from more aggressive targeted reclaim, indeed I
have been surprised just how often my test workloads trigger lumpy at
order 1 to get new stacks.

Truly representative work loads are hard to generate for some of these.
 Though we have heard some encouraging noises from those who can
reproduce these problems.

[...]

-apw
