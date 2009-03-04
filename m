Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375AbZCDTWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbZCDTWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 14:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755573AbZCDTWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 14:22:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:54525 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755412AbZCDTWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 14:22:06 -0500
Date: Wed, 4 Mar 2009 19:21:28 GMT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, mel@csn.ul.ie, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, mel@csn.ul.ie, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1236154567.29024.23.camel@penberg-laptop>
References: <1236154567.29024.23.camel@penberg-laptop>
Subject: [tip:x86/mm] x86: set_highmem_pages_init() cleanup, #2
Message-ID: <tip-6298e719cf388f43b674f43799af467d3e4e5aa7@git.kernel.org>
Git-Commit-ID: 6298e719cf388f43b674f43799af467d3e4e5aa7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 04 Mar 2009 19:21:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6298e719cf388f43b674f43799af467d3e4e5aa7
Gitweb:     http://git.kernel.org/tip/6298e719cf388f43b674f43799af467d3e4e5aa7
Author:     "Pekka Enberg" <penberg@cs.helsinki.fi>
AuthorDate: Wed, 4 Mar 2009 10:16:07 +0200
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Mar 2009 19:00:51 +0100

x86: set_highmem_pages_init() cleanup, #2

Impact: cleanup

The zones are set up at this stage so there's a highmem zone
available even for the UMA case.

The only difference there is that for machines that have
CONFIG_HIGHMEM enabled but don't have any highmem available,
->zone_start_pfn is zero whereas highstart_pfn is non-zero).

The field is left zeroed because of the !size test in
free_area_init_core() but shouldn't be a problem because
add_highpages_with_active_regions() handles empty ranges just
fine.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mel Gorman <mel@csn.ul.ie>
LKML-Reference: <1236154567.29024.23.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/highmem_32.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index 00f127c..d117453 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -158,7 +158,6 @@ EXPORT_SYMBOL(kunmap);
 EXPORT_SYMBOL(kmap_atomic);
 EXPORT_SYMBOL(kunmap_atomic);
 
-#ifdef CONFIG_NUMA
 void __init set_highmem_pages_init(void)
 {
 	struct zone *zone;
@@ -182,11 +181,3 @@ void __init set_highmem_pages_init(void)
 	}
 	totalram_pages += totalhigh_pages;
 }
-#else
-void __init set_highmem_pages_init(void)
-{
-	add_highpages_with_active_regions(0, highstart_pfn, highend_pfn);
-
-	totalram_pages += totalhigh_pages;
-}
-#endif /* CONFIG_NUMA */
