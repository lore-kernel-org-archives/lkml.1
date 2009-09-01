Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbZIAIuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbZIAIuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 04:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbZIAIuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 04:50:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:54449 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178AbZIAIuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 04:50:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="182702705"
Date: Tue, 1 Sep 2009 16:00:15 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Josh Triplett <josh@joshtriplett.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Chris Wright <chrisw@redhat.com>, Izik Eidus <ieidus@redhat.com>
Subject: [PATCH -v2] pagemap: document KPF_KSM and show it in page-types
Message-ID: <20090901080015.GC1446@localhost>
References: <20090808173900.GA21009@feather> <20090812065107.GA16363@localhost> <20090831135720.5E53.A69D9226@jp.fujitsu.com> <20090831065659.GA18039@localhost> <20090831071425.GA26634@localhost> <20090831071702.GB26634@localhost> <20090831083911.715b630b.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090831083911.715b630b.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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
