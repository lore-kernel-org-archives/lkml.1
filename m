Return-Path: <linux-kernel-owner+w=401wt.eu-S932672AbZHDIKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672AbZHDIKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 04:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932586AbZHDIKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 04:10:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:36968 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932584AbZHDIKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 04:10:48 -0400
Date: Tue, 4 Aug 2009 08:10:27 GMT
From: tip-bot for Matt Fleming <matt@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, matt@console-pimps.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, matt@console-pimps.org, tglx@linutronix.de
In-Reply-To: <1248365775-25196-1-git-send-email-matt@console-pimps.org>
References: <1248365775-25196-1-git-send-email-matt@console-pimps.org>
Subject: [tip:tracing/urgent] ftrace: Fix the conditional that updates $ref_func
Message-ID: <tip-fc4c73554c9d93b3e495f2f7acae1323b0d5db84@git.kernel.org>
Git-Commit-ID: fc4c73554c9d93b3e495f2f7acae1323b0d5db84
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 04 Aug 2009 08:10:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc4c73554c9d93b3e495f2f7acae1323b0d5db84
Gitweb:     http://git.kernel.org/tip/fc4c73554c9d93b3e495f2f7acae1323b0d5db84
Author:     Matt Fleming <matt@console-pimps.org>
AuthorDate: Thu, 23 Jul 2009 17:16:14 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 23 Jul 2009 12:20:08 -0400

ftrace: Fix the conditional that updates $ref_func

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
