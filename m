Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbZGWQQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbZGWQQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 12:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754444AbZGWQQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 12:16:42 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:54180 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbZGWQQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 12:16:40 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ftrace: Fix the conditional that updates $ref_func
Date: Thu, 23 Jul 2009 17:16:14 +0100
Message-Id: <1248365775-25196-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.6.4.rc0
In-Reply-To: <alpine.DEB.2.00.0907231043330.20997@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0907231043330.20997@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the conditional that checks if we already have a $ref_func and that
the new function is weak. The code as previously checking whether either
condition was false, and we really need to only update $ref_func is both
cconditions are false.

Signed-off-by: Matt Fleming <matt@console-pimps.org>
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
1.6.4.rc0

