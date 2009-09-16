Return-Path: <linux-kernel-owner+w=401wt.eu-S1758850AbZIPKab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850AbZIPKab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758840AbZIPKaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:30:12 -0400
Received: from mga14.intel.com ([143.182.124.37]:4140 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758550AbZIPK3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:29:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,397,1249282800"; 
   d="scan'208";a="188224419"
Message-Id: <20090916100657.740347494@intel.com>
References: <20090916100119.275066569@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 16 Sep 2009 18:01:26 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 7/8] page-types: introduce kpageflags_flags()
Content-Disposition: inline; filename=page-types-flags.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Andi Kleen <andi@firstfloor.org> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 Documentation/vm/page-types.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- linux-mm.orig/Documentation/vm/page-types.c	2009-09-16 17:54:06.000000000 +0800
+++ linux-mm/Documentation/vm/page-types.c	2009-09-16 17:54:35.000000000 +0800
@@ -436,6 +436,16 @@ static uint64_t well_known_flags(uint64_
 	return flags;
 }
 
+static uint64_t kpageflags_flags(uint64_t flags)
+{
+	flags = expand_overloaded_flags(flags);
+
+	if (!opt_raw)
+		flags = well_known_flags(flags);
+
+	return flags;
+}
+
 /*
  * page frame walker
  */
@@ -470,10 +480,7 @@ static int hash_slot(uint64_t flags)
 static void add_page(unsigned long voffset,
 		     unsigned long offset, uint64_t flags)
 {
-	flags = expand_overloaded_flags(flags);
-
-	if (!opt_raw)
-		flags = well_known_flags(flags);
+	flags = kpageflags_flags(flags);
 
 	if (!bit_mask_ok(flags))
 		return;

-- 

