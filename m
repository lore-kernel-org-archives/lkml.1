Return-Path: <linux-kernel-owner+w=401wt.eu-S1760210AbXE1Hq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760210AbXE1Hq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 03:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbXE1HqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 03:46:20 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42107 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbXE1HqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 03:46:19 -0400
Date: Mon, 28 May 2007 10:46:18 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: How to use GDB to decode OOPSes
Message-ID: <Pine.LNX.4.64.0705281046001.30697@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Adds instructions how to use GDB to figure out the exact location of
an OOPS to Documentation/BUG-HUNTING.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 Documentation/BUG-HUNTING |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

Index: 2.6/Documentation/BUG-HUNTING
===================================================================
--- 2.6.orig/Documentation/BUG-HUNTING	2007-02-05 09:46:58.000000000 +0200
+++ 2.6/Documentation/BUG-HUNTING	2007-05-28 10:38:55.000000000 +0300
@@ -191,6 +191,30 @@ >        mov        0xd0(%esp), %ebp    
 >        mov        0x8(%ebp), %ebx         ! %ebx = skb->sk
 >        mov        0x13c(%ebx), %eax       ! %eax = inet_sk(sk)->opt
 
+In addition, you can use GDB to figure out the exact file and line
+number of the OOPS from the vmlinux file. If you have
+CONFIG_DEBUG_INFO enabled, you can simply copy the EIP value from the
+OOPS:
+
+ EIP:    0060:[<c021e50e>]    Not tainted VLI
+
+And use GDB to translate that to human-readable form:
+
+  gdb vmlinux
+  (gdb) l *0xc021e50e
+
+If you don't have CONFIG_DEBUG_INFO enabled, you use the function
+offset from the OOPS:
+
+ EIP is at vt_ioctl+0xda8/0x1482
+
+And recompile the kernel with CONFIG_DEBUG_INFO enabled:
+
+  make vmlinux
+  gdb vmlinux
+  (gdb) p vt_ioctl
+  (gdb) l *(0x<address of vt_ioctl> + 0xda8)
+
 Another very useful option of the Kernel Hacking section in menuconfig is
 Debug memory allocations. This will help you see whether data has been
 initialised and not set before use etc. To see the values that get assigned
