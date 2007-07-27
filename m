Return-Path: <linux-kernel-owner+w=401wt.eu-S935558AbXG0Jpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935558AbXG0Jpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 05:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762247AbXG0JpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 05:45:24 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:35583 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760462AbXG0JpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 05:45:23 -0400
Date: Fri, 27 Jul 2007 11:43:44 +0200 (MEST)
Message-Id: <200707270943.LAA17019@ifs.emn.fr>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH 01/68] 0 -> NULL, for arch/alpha
Cc: rth@twiddle.net, ink@jurassic.park.msu.ru, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
From: Yoann Padioleau <padator@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When comparing a pointer, it's clearer to compare it to NULL than to 0.

Here is an excerpt of the semantic patch: 

@@
expression *E;
@@

  E ==
- 0
+ NULL

@@
expression *E;
@@

  E !=
- 0
+ NULL

Signed-off-by: Yoann Padioleau <padator@wanadoo.fr>
Cc: rth@twiddle.net
Cc: ink@jurassic.park.msu.ru
Cc: akpm@linux-foundation.org
---

 kernel/smp.c   |    4 ++--
 kernel/traps.c |    2 +-
 mm/fault.c     |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index b287314..4317a7c 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -270,7 +270,7 @@ recv_secondary_console_msg(void)
 			cp2 = buf;
 			strcpy(cp2, cp1);
 			
-			while ((cp2 = strchr(cp2, '\r')) != 0) {
+			while ((cp2 = strchr(cp2, '\r')) != NULL) {
 				*cp2 = ' ';
 				if (cp2[1] == '\n')
 					cp2[1] = ' ';
@@ -597,7 +597,7 @@ pointer_lock (void *lock, void *data, in
 	: "r"(data)
 	: "memory");
 
-	if (old == 0)
+	if (old == NULL)
 		return 0;
 	if (! retry)
 		return -EBUSY;
diff --git a/arch/alpha/kernel/traps.c b/arch/alpha/kernel/traps.c
index ec0f05e..48b4015 100644
--- a/arch/alpha/kernel/traps.c
+++ b/arch/alpha/kernel/traps.c
@@ -628,7 +628,7 @@ do_entUna(void * va, unsigned long opcod
 got_exception:
 	/* Ok, we caught the exception, but we don't want it.  Is there
 	   someone to pass it along to?  */
-	if ((fixup = search_exception_tables(pc)) != 0) {
+	if ((fixup = search_exception_tables(pc)) != NULL) {
 		unsigned long newpc;
 		newpc = fixup_exception(una_reg, fixup, pc);
 
diff --git a/arch/alpha/mm/fault.c b/arch/alpha/mm/fault.c
index a0e18da..dffca85 100644
--- a/arch/alpha/mm/fault.c
+++ b/arch/alpha/mm/fault.c
@@ -171,7 +171,7 @@ #endif
 
  no_context:
 	/* Are we prepared to handle this fault as an exception?  */
-	if ((fixup = search_exception_tables(regs->pc)) != 0) {
+	if ((fixup = search_exception_tables(regs->pc)) != NULL) {
 		unsigned long newpc;
 		newpc = fixup_exception(dpf_reg, fixup, regs->pc);
 		regs->pc = newpc;

