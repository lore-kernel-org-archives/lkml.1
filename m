Return-Path: <linux-kernel-owner+w=401wt.eu-S1758844AbZIPK3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844AbZIPK3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758836AbZIPK3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:29:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:4140 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616AbZIPK3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:29:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,397,1249282800"; 
   d="scan'208";a="188224411"
Message-Id: <20090916100657.375753309@intel.com>
References: <20090916100119.275066569@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 16 Sep 2009 18:01:23 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 4/8] page-types: introduce checked_open()
Content-Disposition: inline; filename=page-types-checked-open.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This helps merge duplicate code (now and future)
and outstand the main logic.

CC: Andi Kleen <andi@firstfloor.org> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 Documentation/vm/page-types.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- linux-mm.orig/Documentation/vm/page-types.c	2009-09-16 17:13:24.000000000 +0800
+++ linux-mm/Documentation/vm/page-types.c	2009-09-16 17:14:07.000000000 +0800
@@ -211,6 +211,18 @@ static void fatal(const char *x, ...)
 	exit(EXIT_FAILURE);
 }
 
+int checked_open(const char *pathname, int flags)
+{
+	int fd = open(pathname, flags);
+
+	if (fd < 0) {
+		perror(pathname);
+		exit(EXIT_FAILURE);
+	}
+
+	return fd;
+}
+
 
 /*
  * page flag names
@@ -531,11 +543,7 @@ static void walk_addr_ranges(void)
 {
 	int i;
 
-	kpageflags_fd = open(PROC_KPAGEFLAGS, O_RDONLY);
-	if (kpageflags_fd < 0) {
-		perror(PROC_KPAGEFLAGS);
-		exit(EXIT_FAILURE);
-	}
+	kpageflags_fd = checked_open(PROC_KPAGEFLAGS, O_RDONLY);
 
 	if (!nr_addr_ranges)
 		add_addr_range(0, ULONG_MAX);
@@ -628,11 +636,7 @@ static void parse_pid(const char *str)
 	opt_pid = parse_number(str);
 
 	sprintf(buf, "/proc/%d/pagemap", opt_pid);
-	pagemap_fd = open(buf, O_RDONLY);
-	if (pagemap_fd < 0) {
-		perror(buf);
-		exit(EXIT_FAILURE);
-	}
+	pagemap_fd = checked_open(buf, O_RDONLY);
 
 	sprintf(buf, "/proc/%d/maps", opt_pid);
 	file = fopen(buf, "r");

-- 

