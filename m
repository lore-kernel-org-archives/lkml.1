Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbZBWMMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbZBWMMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 07:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbZBWMMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 07:12:22 -0500
Received: from cantor.suse.de ([195.135.220.2]:54897 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbZBWMMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 07:12:21 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] fix unused variable without softlock detection and highmem
Date: Mon, 23 Feb 2009 17:39:51 +0530
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902231739.51863.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When both CONFIG_DETECT_SOFTLOCKUP and CONFIG_HIGHMEM are not defined
avoid defining the constant for one fixing the 'define but not used' warning.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c5ef44f..f172d9f 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -95,12 +95,15 @@ static int sixty = 60;
 static int neg_one = -1;
 #endif
 
+#if defined(CONFIG_DETECT_SOFTLOCKUP) || defined(CONFIG_HIGHMEM)
+static int one = 1;
+#endif
+
 #if defined(CONFIG_MMU) && defined(CONFIG_FILE_LOCKING)
 static int two = 2;
 #endif
 
 static int zero;
-static int one = 1;
 static unsigned long one_ul = 1;
 static int one_hundred = 100;
 

