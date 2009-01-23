Return-Path: <linux-kernel-owner+w=401wt.eu-S1761034AbZAWJW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761034AbZAWJW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 04:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbZAWJWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 04:22:41 -0500
Received: from mga12.intel.com ([143.182.124.36]:27104 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752149AbZAWJWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 04:22:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,311,1231142400"; 
   d="scan'208";a="103078378"
Subject: Re: [PATCH] SLUB: revert direct page allocator pass through
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: cl@linux-foundation.org, Andi Kleen <andi@firstfloor.org>,
       Matthew Wilcox <matthew@wil.cx>, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-kernel@vger.kernel.org, akmp@linux-foundation.org
In-Reply-To: <Pine.LNX.4.64.0901231041210.8574@melkki.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0901231041210.8574@melkki.cs.Helsinki.FI>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 17:22:31 +0800
Message-Id: <1232702551.11429.175.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-23 at 10:43 +0200, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> This patch reverts page allocator pass-through logic from the SLUB allocator.
> 
> Commit aadb4bc4a1f9108c1d0fbd121827c936c2ed4217 ("SLUB: direct pass through of
> page size or higher kmalloc requests") added page allocator pass-through to the
> SLUB allocator for large sized allocations. This, however, results in a
> performance regression compared to SLAB in the netperf UDP-U-4k test.
> 
> The regression comes from the kfree(skb->head) call in skb_release_data() that
> is subject to page allocator pass-through as the size passed to __alloc_skb()
> is larger than 4 KB in this test. With this patch, the performance regression
> is almost closed:
> 
>   <insert numbers here>
> 
> Reported-by: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
> Tested-by: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
> Yanmin, do you still have the relevant numbers I could cut and paste to 
> the patch description?
I use 2.6.29-rc2 kernel to run netperf UDP-U-4k CPU_NUM client/server pair loopback testing
on x86-64 machines. Comparing with SLUB, SLAB's result is about 2.3 times of SLUB's.
After applying the reverting patch, the result difference between SLUB and SLAB becomes 1%
which we might consider as fluctuation.

yanmin


