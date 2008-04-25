Return-Path: <linux-kernel-owner+w=401wt.eu-S933890AbYDYTLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933890AbYDYTLe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932413AbYDYTCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 15:02:45 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:27126 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765714AbYDYTCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 15:02:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=ClFtpOk1Zzr7GdRosSeVu4IXo2P12trtEfgVVBPndz03bV6EYDLHvwcr2LFvW3X6eEQkv1riQyclW6fZQkW4h/ciwT+m1j5z1qjbBUqkiox5+bm2Hz1H+LfF8a5ZwQ9ShWweBeAoGd7gkPSKPpDnaNIlQYk2xT2eefvKpCsovnI=
Date: Fri, 25 Apr 2008 21:02:34 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: fix early-BUG message
Message-ID: <20080425190234.GA9525@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e7402e1c6b56dfb8d389f1faf04b3f03a9ecad33 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 25 Apr 2008 20:58:34 +0200
Subject: [PATCH] x86: fix early-BUG message

The .asciz directive takes any number of strings, but each one is zero-
terminated, and string pasting is not done as in C. That results in only the
first line being output.

Replace .asciz with multiple .ascii directives and terminate with .asciz.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/kernel/head_32.S |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 74d87ea..51c973e 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -657,15 +657,16 @@ int_msg:
 	.asciz "Unknown interrupt or fault at EIP %p %p %p\n"
 
 fault_msg:
-	.asciz								\
-/* fault info: */	"BUG: Int %d: CR2 %p\n"				\
-/* pusha regs: */	"     EDI %p  ESI %p  EBP %p  ESP %p\n"		\
-			"     EBX %p  EDX %p  ECX %p  EAX %p\n"		\
-/* fault frame: */	"     err %p  EIP %p   CS %p  flg %p\n"		\
-									\
-			"Stack: %p %p %p %p %p %p %p %p\n"		\
-			"       %p %p %p %p %p %p %p %p\n"		\
-			"       %p %p %p %p %p %p %p %p\n"
+/* fault info: */
+	.ascii "BUG: Int %d: CR2 %p\n"
+/* pusha regs: */
+	.ascii "     EDI %p  ESI %p  EBP %p  ESP %p\n"
+	.ascii "     EBX %p  EDX %p  ECX %p  EAX %p\n"
+/* fault frame: */
+	.ascii "     err %p  EIP %p   CS %p  flg %p\n"
+	.ascii "Stack: %p %p %p %p %p %p %p %p\n"
+	.ascii "       %p %p %p %p %p %p %p %p\n"
+	.asciz "       %p %p %p %p %p %p %p %p\n"
 
 #include "../../x86/xen/xen-head.S"
 
-- 
1.5.4.1

