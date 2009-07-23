Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbZGWVCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbZGWVCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 17:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbZGWVCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 17:02:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41537 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbZGWVCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 17:02:22 -0400
Message-Id: <20090723210220.680604358@goodmis.org>
References: <20090723210047.294710482@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 23 Jul 2009 17:00:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Matt Fleming <matt@console-pimps.org>
Subject: [PATCH 3/4] ftrace: Fix the conditional that updates $ref_func
Content-Disposition: inline; filename=0003-ftrace-Fix-the-conditional-that-updates-ref_func.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt@console-pimps.org>

Fix the conditional that checks if we already have a $ref_func and that
the new function is weak. The code as previously checking whether either
condition was false, and we really need to only update $ref_func is both
cconditions are false.

Signed-off-by: Matt Fleming <matt@console-pimps.org>
LKML-Reference: <1248365775-25196-1-git-send-email-matt@console-pimps.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 7109e2b..16c5563 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -414,7 +414,7 @@ while (<IN>) {
 	    $read_function = 0;
 	} else {
 	    # if we already have a function, and this is weak, skip it
-	    if (!defined($ref_func) || !defined($weak{$text})) {
+	    if (!defined($ref_func) && !defined($weak{$text})) {
 		$ref_func = $text;
 	    }
 	}
-- 
1.6.3.3

-- 
