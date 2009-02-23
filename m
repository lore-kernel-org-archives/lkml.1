Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbZBWHOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbZBWHOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 02:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbZBWHOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 02:14:09 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44104 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbZBWHOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 02:14:07 -0500
Date: Mon, 23 Feb 2009 09:14:03 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH 07/20] Simplify the check on whether cpusets are a factor
 or not
In-Reply-To: <1235344649-18265-8-git-send-email-mel@csn.ul.ie>
Message-ID: <Pine.LNX.4.64.0902230913080.20371@melkki.cs.Helsinki.FI>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
 <1235344649-18265-8-git-send-email-mel@csn.ul.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Feb 2009, Mel Gorman wrote:
> The check whether cpuset contraints need to be checked or not is complex
> and often repeated.  This patch makes the check in advance to the comparison
> is simplier to compute.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

You can do that in a cleaner way by defining ALLOC_CPUSET to be zero when 
CONFIG_CPUSETS is disabled. Something like following untested patch:

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5675b30..18b687d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1135,7 +1135,12 @@ failed:
 #define ALLOC_WMARK_HIGH	0x08 /* use pages_high watermark */
 #define ALLOC_HARDER		0x10 /* try to alloc harder */
 #define ALLOC_HIGH		0x20 /* __GFP_HIGH set */
+
+#ifdef CONFIG_CPUSETS
 #define ALLOC_CPUSET		0x40 /* check for correct cpuset */
+#else
+#define ALLOC_CPUSET		0x00
+#endif
 
 #ifdef CONFIG_FAIL_PAGE_ALLOC
 
