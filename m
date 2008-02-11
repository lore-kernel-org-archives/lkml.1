Return-Path: <linux-kernel-owner+w=401wt.eu-S1760703AbYBKVpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760703AbYBKVpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 16:45:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759419AbYBKVpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 16:45:20 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:41141 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758545AbYBKVpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 16:45:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jZkJ2iIZfQScClQN7DYV6ezuIP4haK2lY8AR+YVST9COihVEOsdVuiQI3eGm+eu6LpWUm/guWYIwujHxI7jYWJfhlwMrxTtwd/33j/klfqUblraDb91tjyIDXdp7ZiA9rxHMPKi11VWhHpHqt7uvaHNRPtSG4xeP2hhLTQb33H0=
Subject: [PATCH 4/3] Documentation: Remove references to FASTCALL/fastcall
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>
In-Reply-To: <20080211131738.dda66683.akpm@linux-foundation.org>
References: <1202755123.6313.16.camel@brick>
	 <20080211131738.dda66683.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 13:45:00 -0800
Message-Id: <1202766300.10004.21.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An example function prototype and description of options that
modify how arguments are passed had references to fastcall.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Andrew, I don't have the knowledge to deal with the rcupdate.c
wrapper function, hopefully Paul will be able to have a look.

Also, the UML reference is to a config option UM_FASTCALL, not
the FASTCALL macro.

 Documentation/RCU/NMI-RCU.txt |    2 +-
 Documentation/kprobes.txt     |   11 +++++------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/Documentation/RCU/NMI-RCU.txt b/Documentation/RCU/NMI-RCU.txt
index d0634a5..c64158e 100644
--- a/Documentation/RCU/NMI-RCU.txt
+++ b/Documentation/RCU/NMI-RCU.txt
@@ -25,7 +25,7 @@ the NMI handler to take the default machine-specific action.
 This nmi_callback variable is a global function pointer to the current
 NMI handler.
 
-	fastcall void do_nmi(struct pt_regs * regs, long error_code)
+	void do_nmi(struct pt_regs * regs, long error_code)
 	{
 		int cpu;
 
diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
index 30c1017..83f515c 100644
--- a/Documentation/kprobes.txt
+++ b/Documentation/kprobes.txt
@@ -92,9 +92,8 @@ handler has run.  Up to MAX_STACK_SIZE bytes are copied -- e.g.,
 64 bytes on i386.
 
 Note that the probed function's args may be passed on the stack
-or in registers (e.g., for x86_64 or for an i386 fastcall function).
-The jprobe will work in either case, so long as the handler's
-prototype matches that of the probed function.
+or in registers.  The jprobe will work in either case, so long as the
+handler's prototype matches that of the probed function.
 
 1.3 Return Probes
 
@@ -270,9 +269,9 @@ Kprobes runs the handler whose address is jp->entry.
 The handler should have the same arg list and return type as the probed
 function; and just before it returns, it must call jprobe_return().
 (The handler never actually returns, since jprobe_return() returns
-control to Kprobes.)  If the probed function is declared asmlinkage,
-fastcall, or anything else that affects how args are passed, the
-handler's declaration must match.
+control to Kprobes.)  If the probed function is declared asmlinkage
+or anything else that affects how args are passed, the handler's
+declaration must match.
 
 register_jprobe() returns 0 on success, or a negative errno otherwise.
 
-- 
1.5.4.1219.g65b9



