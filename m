Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbYIWWGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbYIWWGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 18:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbYIWWFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 18:05:52 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:41633 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbYIWWFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 18:05:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=KVVhEShJdfTM3TQblEWtFUCC3XDV7YgAx7nOsxlWjEcNDY4Zo4C7/CwIglmDjLiu3p
         rV+mrRyqyrv5/e1DBnIpcSpR89SNVf85IMq7XJ3Y7ToVKuJb/p7zp15GwiZNkROGso9j
         rh7GyJBclcFSog9fYtTYNUAHPBJv1i/Cigt7M=
Subject: [PATCH] x86: suppress trivial sparse signedness warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 23 Sep 2008 15:05:46 -0700
Message-Id: <1222207546.16003.21.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could just as easily change the three casts to cast to the correct
type...this patch changes the type of ftrace_nop instead.

Supresses sparse warnings:
arch/x86/kernel/ftrace.c:157:14: warning: incorrect type in assignment (different signedness)
arch/x86/kernel/ftrace.c:157:14:    expected long *static [toplevel] ftrace_nop
arch/x86/kernel/ftrace.c:157:14:    got unsigned long *<noident>
arch/x86/kernel/ftrace.c:161:14: warning: incorrect type in assignment (different signedness)
arch/x86/kernel/ftrace.c:161:14:    expected long *static [toplevel] ftrace_nop
arch/x86/kernel/ftrace.c:161:14:    got unsigned long *<noident>
arch/x86/kernel/ftrace.c:165:14: warning: incorrect type in assignment (different signedness)
arch/x86/kernel/ftrace.c:165:14:    expected long *static [toplevel] ftrace_nop
arch/x86/kernel/ftrace.c:165:14:    got unsigned long *<noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/ftrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 082d996..66d9002 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -22,7 +22,7 @@
 
 
 /* Long is fine, even if it is only 4 bytes ;-) */
-static long *ftrace_nop;
+static unsigned long *ftrace_nop;
 
 union ftrace_code_union {
 	char code[MCOUNT_INSN_SIZE];
-- 
1.6.0.2.471.g47a76



