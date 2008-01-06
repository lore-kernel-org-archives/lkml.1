Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbYAFRET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbYAFRET (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 12:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756775AbYAFREL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 12:04:11 -0500
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:54473 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755067AbYAFREK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 12:04:10 -0500
Subject: [PATCH] Documentation. add hint about call traces & module symbols
	to BUG-HUNTING
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sun, 06 Jan 2008 17:04:05 +0000
Message-Id: <1199639045.2900.22.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a couple of small additions to BUG-HUNTING.

1. point out that you can list code in gdb with only one command
	(gdb) l *(<symbol> + offset)

2. give a very brief hint how to decode module symbols in call traces 

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

----
It would have saved me some time if I'd known both of these things
earlier, so I thought it might just be of help to anyone else new to the
kernel.

Richard

diff --git a/Documentation/BUG-HUNTING b/Documentation/BUG-HUNTING
index 35f5bd2..aa3e424 100644
--- a/Documentation/BUG-HUNTING
+++ b/Documentation/BUG-HUNTING
@@ -214,7 +214,24 @@ And recompile the kernel with CONFIG_DEBUG_INFO enabled:
   gdb vmlinux
   (gdb) p vt_ioctl
   (gdb) l *(0x<address of vt_ioctl> + 0xda8)
-
+or, as one command
+  (gdb) l *(vt_ioctl + 0xda8)
+
+If you have a call trace, such as :-
+>Call Trace:
+> [<ffffffff8802c8e9>] :jbd:log_wait_commit+0xa3/0xf5
+> [<ffffffff810482d9>] autoremove_wake_function+0x0/0x2e
+> [<ffffffff8802770b>] :jbd:journal_stop+0x1be/0x1ee
+> ... 
+this shows the problem in the :jbd: module. You can load that module in gdb
+and list the relevant code.
+  gdb fs/jbd/jbd.ko
+  (gdb) p log_wait_commit
+  (gdb) l *(0x<address> + 0xa3)
+or
+  (gdb) l *(log_wait_commit + 0xa3)  
+
+ 
 Another very useful option of the Kernel Hacking section in menuconfig is
 Debug memory allocations. This will help you see whether data has been
 initialised and not set before use etc. To see the values that get assigned


