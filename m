Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbZBWSBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbZBWSBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 13:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbZBWSBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 13:01:41 -0500
Received: from gir.skynet.ie ([193.1.99.77]:54405 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbZBWSBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 13:01:40 -0500
Date: Mon, 23 Feb 2009 18:01:35 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH] mm: clean up __GFP_* flags a bit
Message-ID: <20090223180134.GR6740@csn.ul.ie>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie> <1235344649-18265-5-git-send-email-mel@csn.ul.ie> <1235390101.4645.79.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1235390101.4645.79.camel@laptop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 12:55:01PM +0100, Peter Zijlstra wrote:
> Subject: mm: clean up __GFP_* flags a bit
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Mon Feb 23 12:28:33 CET 2009
> 
> re-sort them and poke at some whitespace alignment for easier reading.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

It didn't apply because we are working off different trees. I was on
git-latest from last Wednesday and this looks to be -mm based on the presense
of CONFIG_KMEMCHECK. I rebased and ended up with the patch below. Thanks

====
>From 37990226c22063d6304106cdd5aae9b73f484d76 Mon Sep 17 00:00:00 2001
From: Mel Gorman <mel@csn.ul.ie>
Date: Mon, 23 Feb 2009 17:56:22 +0000
Subject: [PATCH] Re-sort GFP flags and fix whitespace alignment for easier reading.

Resort the GFP flags after __GFP_MOVABLE got redefined so how the bits
are used are a bit cleared.

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
--- 

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 581f8a9..8f7d176 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -25,6 +25,8 @@ struct vm_area_struct;
 #define __GFP_HIGHMEM	((__force gfp_t)0x02u)
 #define __GFP_DMA32	((__force gfp_t)0x04u)
 
+#define __GFP_MOVABLE	((__force gfp_t)0x08u)  /* Page is movable */
+
 /*
  * Action modifiers - doesn't change the zoning
  *
@@ -50,11 +52,10 @@ struct vm_area_struct;
 #define __GFP_NORETRY	((__force gfp_t)0x1000u)/* See above */
 #define __GFP_COMP	((__force gfp_t)0x4000u)/* Add compound page metadata */
 #define __GFP_ZERO	((__force gfp_t)0x8000u)/* Return zeroed page on success */
-#define __GFP_NOMEMALLOC ((__force gfp_t)0x10000u) /* Don't use emergency reserves */
-#define __GFP_HARDWALL   ((__force gfp_t)0x20000u) /* Enforce hardwall cpuset memory allocs */
-#define __GFP_THISNODE	((__force gfp_t)0x40000u)/* No fallback, no policies */
+#define __GFP_NOMEMALLOC  ((__force gfp_t)0x10000u) /* Don't use emergency reserves */
+#define __GFP_HARDWALL    ((__force gfp_t)0x20000u) /* Enforce hardwall cpuset memory allocs */
+#define __GFP_THISNODE	  ((__force gfp_t)0x40000u) /* No fallback, no policies */
 #define __GFP_RECLAIMABLE ((__force gfp_t)0x80000u) /* Page is reclaimable */
-#define __GFP_MOVABLE	((__force gfp_t)0x08u)  /* Page is movable */
 
 #define __GFP_BITS_SHIFT 21	/* Room for 21 __GFP_FOO bits */
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
