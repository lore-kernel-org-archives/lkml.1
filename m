Return-Path: <linux-kernel-owner+w=401wt.eu-S1759818AbZEFMTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759818AbZEFMTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759035AbZEFMTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:19:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:59724 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755070AbZEFMS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:18:59 -0400
Date: Wed, 6 May 2009 12:18:21 GMT
From: tip-bot for Tim Abbott <tabbott@mit.edu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, tabbott@mit.edu, hpa@zytor.com,
       mingo@redhat.com, sam@ravnborg.org, rostedt@goodmis.org,
       tabbott@mit.edu, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, tabbott@mit.edu,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org, sam@ravnborg.org,
       tabbott@mit.edu, tglx@linutronix.de
In-Reply-To: <1241136371-10768-1-git-send-email-tabbott@mit.edu>
References: <1241136371-10768-1-git-send-email-tabbott@mit.edu>
Subject: [tip:tracing/core] ftrace: use .sched.text, not .text.sched in recordmcount.pl
Message-ID: <tip-31b6e76e21b2ffd3cb2f6fe4149790a9fdadce2d@git.kernel.org>
Git-Commit-ID: 31b6e76e21b2ffd3cb2f6fe4149790a9fdadce2d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 06 May 2009 12:18:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  31b6e76e21b2ffd3cb2f6fe4149790a9fdadce2d
Gitweb:     http://git.kernel.org/tip/31b6e76e21b2ffd3cb2f6fe4149790a9fdadce2d
Author:     Tim Abbott <tabbott@MIT.EDU>
AuthorDate: Thu, 30 Apr 2009 20:06:11 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 5 May 2009 19:17:22 -0400

ftrace: use .sched.text, not .text.sched in recordmcount.pl

The only references in the kernel to the .text.sched section are in
recordmcount.pl.  Since the code it has is intended to be example code
it should refer to real kernel sections.  So change it to .sched.text
instead.

[ Impact: consistency in comments ]

Signed-off-by: Tim Abbott <tabbott@mit.edu>
LKML-Reference: <1241136371-10768-1-git-send-email-tabbott@mit.edu>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


---
 scripts/recordmcount.pl |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 409596e..0fae7da 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -26,7 +26,7 @@
 # which will also be the location of that section after final link.
 # e.g.
 #
-#  .section ".text.sched"
+#  .section ".sched.text", "ax"
 #  .globl my_func
 #  my_func:
 #        [...]
@@ -39,7 +39,7 @@
 #        [...]
 #
 # Both relocation offsets for the mcounts in the above example will be
-# offset from .text.sched. If we make another file called tmp.s with:
+# offset from .sched.text. If we make another file called tmp.s with:
 #
 #  .section __mcount_loc
 #  .quad  my_func + 0x5
@@ -51,7 +51,7 @@
 # But this gets hard if my_func is not globl (a static function).
 # In such a case we have:
 #
-#  .section ".text.sched"
+#  .section ".sched.text", "ax"
 #  my_func:
 #        [...]
 #        call mcount  (offset: 0x5)
