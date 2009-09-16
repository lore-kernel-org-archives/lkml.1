Return-Path: <linux-kernel-owner+w=401wt.eu-S1758865AbZIPK30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865AbZIPK30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758848AbZIPK3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:29:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:4145 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758846AbZIPK3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:29:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,397,1249282800"; 
   d="scan'208";a="188224446"
Message-Id: <20090916100657.141427239@intel.com>
References: <20090916100119.275066569@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 16 Sep 2009 18:01:21 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Izik Eidus <ieidus@redhat.com>, Chris Wright <chrisw@redhat.com>
Subject: [PATCH 2/8] pagemap: document KPF_KSM and show it in page-types
Content-Disposition: inline; filename=kpageflags-ksm.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It indicates to the system admin that processes mapping such pages may be
eating less physical memory than the reported numbers by legacy tools.

CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Izik Eidus <ieidus@redhat.com>
Acked-by: Chris Wright <chrisw@redhat.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 Documentation/vm/page-types.c |    2 ++
 Documentation/vm/pagemap.txt  |    4 ++++
 2 files changed, 6 insertions(+)

--- linux-mm.orig/Documentation/vm/pagemap.txt	2009-09-16 17:12:50.000000000 +0800
+++ linux-mm/Documentation/vm/pagemap.txt	2009-09-16 17:13:24.000000000 +0800
@@ -59,6 +59,7 @@ There are three components to pagemap:
     18. UNEVICTABLE
     19. HWPOISON
     20. NOPAGE
+    21. KSM
 
 Short descriptions to the page flags:
 
@@ -93,6 +94,9 @@ Short descriptions to the page flags:
 20. NOPAGE
     no page frame exists at the requested address
 
+21. KSM
+    identical memory pages dynamically shared between one or more processes
+
     [IO related page flags]
  1. ERROR     IO error occurred
  3. UPTODATE  page has up-to-date data
--- linux-mm.orig/Documentation/vm/page-types.c	2009-09-16 17:12:50.000000000 +0800
+++ linux-mm/Documentation/vm/page-types.c	2009-09-16 17:13:24.000000000 +0800
@@ -71,6 +71,7 @@
 #define KPF_UNEVICTABLE		18
 #define KPF_HWPOISON		19
 #define KPF_NOPAGE		20
+#define KPF_KSM			21
 
 /* [32-] kernel hacking assistances */
 #define KPF_RESERVED		32
@@ -119,6 +120,7 @@ static char *page_flag_names[] = {
 	[KPF_UNEVICTABLE]	= "u:unevictable",
 	[KPF_HWPOISON]		= "X:hwpoison",
 	[KPF_NOPAGE]		= "n:nopage",
+	[KPF_KSM]		= "x:ksm",
 
 	[KPF_RESERVED]		= "r:reserved",
 	[KPF_MLOCKED]		= "m:mlocked",

-- 

