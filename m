Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbYIZF6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbYIZF6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 01:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbYIZF6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 01:58:42 -0400
Received: from mga06.intel.com ([134.134.136.21]:20888 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752242AbYIZF6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 01:58:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,310,1220252400"; 
   d="scan'208";a="443870147"
Date: Fri, 26 Sep 2008 13:54:33 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: arjan@linux.intel.com
Cc: linux-kernel@vger.kernel.org, qi.wang@intel.com
Subject: [PATCH] fastboot: Enter the initcall loop only once for all async
	initcalls
Message-ID: <20080926055433.GB11353@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fastboot: Enter the initcall loop only once for all async initcalls

Only need to enter the initcall loop once for all async initcalls since
they have been submitted to async work queue all together when the loop
is entered for the first async initcall.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>
Signed-off-by: Qi Wang <qi.wang@intel.com>
---
 init/main.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/init/main.c b/init/main.c
index 8967835..672dabf 100644
--- a/init/main.c
+++ b/init/main.c
@@ -788,6 +788,7 @@ static void __init do_initcalls(void)
 #else
 			do_async_initcalls(NULL);
 #endif
+			call = __async_initcall_end - 1;
 		}
 		if (phase == 1 && call >= __async_initcall_end)
 			phase = 2;
