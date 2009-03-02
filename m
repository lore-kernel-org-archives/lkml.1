Return-Path: <linux-kernel-owner+w=401wt.eu-S1759748AbZCBQ70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759748AbZCBQ70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 11:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757693AbZCBQ54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 11:57:56 -0500
Received: from mx1.emlix.com ([193.175.82.87]:43091 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758781AbZCBQ5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 11:57:55 -0500
References: <20090302164257.477296438@emlix.com>
User-Agent: quilt/0.46-1
Date: Mon, 02 Mar 2009 17:43:03 +0100
From: Johannes Weiner <jw@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org
Subject: [patch 6/7] xtensa: dont make bootmem bitmap larger than required
Content-Disposition: inline; filename=xtensa-don-t-make-bootmem-bitmap-larger-than-required.patch
Message-Id: <E1LeBSj-0003Z7-4q@mailer.emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If min_low_pfn is non-zero, the bitmap reserved for bootmem is bigger
than needed.  The number of pages bootmem has to maintain is the range
from min_low_pfn to max_low_pfn.

For now it has only been a theoretical mistake, min_low_pfn was always
zero.

Signed-off-by: Johannes Weiner <jw@emlix.com>
---
 arch/xtensa/mm/init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/xtensa/mm/init.c
+++ b/arch/xtensa/mm/init.c
@@ -130,7 +130,8 @@ void __init bootmem_init(void)
 
 	/* Find an area to use for the bootmem bitmap. */
 
-	bootmap_size = bootmem_bootmap_pages(max_low_pfn) << PAGE_SHIFT;
+	bootmap_size = bootmem_bootmap_pages(max_low_pfn - min_low_pfn);
+	bootmap_size <<= PAGE_SHIFT;
 	bootmap_start = ~0;
 
 	for (i=0; i<sysmem.nr_banks; i++)

-- 

