Return-Path: <linux-kernel-owner+w=401wt.eu-S1756498AbYBKJvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbYBKJvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 04:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbYBKJuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 04:50:23 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:30318 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbYBKJuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 04:50:20 -0500
From: Andi Kleen <ak@suse.de>
References: <200802111050.372086035@suse.de>
In-Reply-To: <200802111050.372086035@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/8] CPA: Fix some incorrect comments in the debug pagealloc code
Message-Id: <20080211095018.6AF7E1B41CE@basil.firstfloor.org>
Date: Mon, 11 Feb 2008 10:50:18 +0100 (CET)
X-OriginalArrivalTime: 11 Feb 2008 09:43:57.0266 (UTC) FILETIME=[9F3D0320:01C86C92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Even with the pool cpa in debug_pagealloc can fail (e.g. consider memory hotplug) 
Also the code does not clear PSE anymore as the comment claims.

Replace wrong comment with correct one.
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c
+++ linux/arch/x86/mm/pageattr.c
@@ -864,10 +864,7 @@ void kernel_map_pages(struct page *page,
 	if (!debug_pagealloc_enabled)
 		return;
 
-	/*
-	 * The return value is ignored - the calls cannot fail,
-	 * large pages are disabled at boot time:
-	 */
+	/* This can fail in theory but then you're out of luck */
 	if (enable)
 		__set_pages_p(page, numpages);
 	else
