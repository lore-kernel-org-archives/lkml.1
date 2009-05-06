Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbZEFE1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbZEFE1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 00:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbZEFEXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 00:23:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57630 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbZEFEXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 00:23:36 -0400
Message-Id: <20090506042334.464866551@goodmis.org>
References: <20090506042101.231470089@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 06 May 2009 00:21:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Tim Abbott <tabbott@mit.edu>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 08/11] ftrace: use .sched.text, not .text.sched in recordmcount.pl
Content-Disposition: inline; filename=0008-ftrace-use-.sched.text-not-.text.sched-in-recordmc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Abbott <tabbott@MIT.EDU>

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
-- 
1.6.2.4

-- 
