Return-Path: <linux-kernel-owner+w=401wt.eu-S936621AbXG0JrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936621AbXG0JrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 05:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932796AbXG0Jp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 05:45:56 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:35810 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765256AbXG0Jpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 05:45:54 -0400
Date: Fri, 27 Jul 2007 11:44:25 +0200 (MEST)
Message-Id: <200707270944.LAA17140@ifs.emn.fr>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH 05/68] 0 -> NULL, for arch/cris
Cc: starvik@axis.com, dev-etrax@axis.com, akpm@linux-foundation.org,
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
Cc: starvik@axis.com
Cc: dev-etrax@axis.com
Cc: akpm@linux-foundation.org
---

 fault.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/cris/mm/fault.c b/arch/cris/mm/fault.c
index 8672ab7..d5b1e3d 100644
--- a/arch/cris/mm/fault.c
+++ b/arch/cris/mm/fault.c
@@ -448,7 +448,7 @@ find_fixup_code(struct pt_regs *regs)
 {
 	const struct exception_table_entry *fixup;
 
-	if ((fixup = search_exception_tables(instruction_pointer(regs))) != 0) {
+	if ((fixup = search_exception_tables(instruction_pointer(regs))) != NULL) {
 		/* Adjust the instruction pointer in the stackframe. */
 		instruction_pointer(regs) = fixup->fixup;
 		arch_fixup(regs);

