Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbZJ2WdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbZJ2WdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 18:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756827AbZJ2WdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 18:33:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52919 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220AbZJ2WdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 18:33:16 -0400
Message-Id: <20091029223320.772935686@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 29 Oct 2009 18:33:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Li Hong <lihong.hi@gmail.com>
Subject: [PATCH 7/8] [PATCH 7/8] tracing: Move conditional into update_funcs() in recordmcount.pl
References: <20091029223254.504427063@goodmis.org>
Content-Disposition: inline; filename=0007-tracing-Move-conditional-into-update_funcs-in-record.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Hong <lihong.hi@gmail.com>

Move all the condition validations into the function update_funcs().
Also update_funcs should not die if $ref_func is undefined for there may be
more than one valid section in an object file.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
LKML-Reference: <20091028050703.GG30758@uhli>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.pl |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 7265a7d..884776a 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -348,9 +348,7 @@ my $offset = 0;		# offset of ref_func to section beginning
 #
 sub update_funcs
 {
-    return if ($#offsets < 0);
-
-    defined($ref_func) || die "No function to reference";
+    return unless ($ref_func and @offsets);
 
     # A section only had a weak function, to represent it.
     # Unfortunately, a weak function may be overwritten by another
@@ -425,7 +423,7 @@ while (<IN>) {
 	    $read_function = 0;
 	}
 	# print out any recorded offsets
-	update_funcs() if (defined($ref_func));
+	update_funcs();
 
 	# reset all markers and arrays
 	$text_found = 0;
@@ -462,7 +460,7 @@ while (<IN>) {
 }
 
 # dump out anymore offsets that may have been found
-update_funcs() if (defined($ref_func));
+update_funcs();
 
 # If we did not find any mcount callers, we are done (do nothing).
 if (!$opened) {
-- 
1.6.3.3


