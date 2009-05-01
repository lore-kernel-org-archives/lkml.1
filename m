Return-Path: <linux-kernel-owner+w=401wt.eu-S932244AbZEAA1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbZEAA1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762164AbZEAAGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:06:30 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62450 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765613AbZEAAG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:06:29 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Tim Abbott <tabbott@MIT.EDU>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH] ftrace: use .sched.text, not .text.sched in recordmcount.pl.
Date: Thu, 30 Apr 2009 20:06:11 -0400
Message-Id: <1241136371-10768-1-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only references in the kernel to the .text.sched section are in
recordmcount.pl.  Since the code it has is intended to be example code
it should refer to real kernel sections.  So change it to .sched.text
instead.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Steven Rostedt <srostedt@redhat.com>
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
1.6.2.1

