Return-Path: <linux-kernel-owner+w=401wt.eu-S1752181AbZIBECp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbZIBECp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 00:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbZIBECo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 00:02:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:38152 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbZIBECl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 00:02:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="183082214"
Message-Id: <20090902035814.828959326@intel.com>
References: <20090902034125.718886329@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 02 Sep 2009 11:41:29 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Izik Eidus <ieidus@redhat.com>, Chris Wright <chrisw@redhat.com>,
       Wu Fengguang <fengguang.wu@intel.com>
cc: Christoph Lameter <cl@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>
CC: "Huang, Ying" <ying.huang@intel.com>
CC: Lin Ming <ming.m.lin@intel.com>
CC: Josh Triplett <josh@joshtriplett.org>, Andi Kleen <andi@firstfloor.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
cc: linux-mm@kvack.org
Subject: [RFC][PATCH 4/4] pagemap: document KPF_KSM and show it in page-types
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
 Documentation/vm/pagemap.txt |    4 ++++
 tools/vm/page-types.c        |    2 ++
 2 files changed, 6 insertions(+)

--- linux-mm.orig/Documentation/vm/pagemap.txt	2009-08-31 15:02:55.000000000 +0800
+++ linux-mm/Documentation/vm/pagemap.txt	2009-09-01 15:54:36.000000000 +0800
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
--- linux-mm.orig/tools/vm/page-types.c	2009-08-31 15:00:24.000000000 +0800
+++ linux-mm/tools/vm/page-types.c	2009-09-01 15:54:16.000000000 +0800
@@ -49,6 +49,7 @@
 #define KPF_UNEVICTABLE		18
 #define KPF_HWPOISON		19
 #define KPF_NOPAGE		20
+#define KPF_KSM			21
 
 /* [32-] kernel hacking assistances */
 #define KPF_RESERVED		32
@@ -97,6 +98,7 @@ static char *page_flag_names[] = {
 	[KPF_UNEVICTABLE]	= "u:unevictable",
 	[KPF_HWPOISON]		= "X:hwpoison",
 	[KPF_NOPAGE]		= "n:nopage",
+	[KPF_KSM]		= "x:ksm",
 
 	[KPF_RESERVED]		= "r:reserved",
 	[KPF_MLOCKED]		= "m:mlocked",

-- 

