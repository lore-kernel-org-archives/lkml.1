Return-Path: <linux-kernel-owner+w=401wt.eu-S965073AbXG0JyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965073AbXG0JyD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 05:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936948AbXG0Jt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 05:49:57 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:36914 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936931AbXG0Jtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 05:49:55 -0400
Date: Fri, 27 Jul 2007 11:45:56 +0200 (MEST)
Message-Id: <200707270945.LAA17372@ifs.emn.fr>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH 18/68] 0 -> NULL, for arch/um
Cc: jdike@karaya.com, user-mode-linux-devel@lists.sourceforge.net,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
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
Cc: jdike@karaya.com
Cc: user-mode-linux-devel@lists.sourceforge.net
Cc: akpm@linux-foundation.org
---

 sys-i386/fault.c   |    2 +-
 sys-x86_64/fault.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/um/sys-i386/fault.c b/arch/um/sys-i386/fault.c
index 745b4fd..8004023 100644
--- a/arch/um/sys-i386/fault.c
+++ b/arch/um/sys-i386/fault.c
@@ -20,7 +20,7 @@ int arch_fixup(unsigned long address, un
 	const struct exception_table_entry *fixup;
 
 	fixup = search_exception_tables(address);
-	if(fixup != 0){
+	if(fixup != NULL){
 		UPT_IP(regs) = fixup->fixup;
 		return(1);
 	}
diff --git a/arch/um/sys-x86_64/fault.c b/arch/um/sys-x86_64/fault.c
index 4636b14..67d4a19 100644
--- a/arch/um/sys-x86_64/fault.c
+++ b/arch/um/sys-x86_64/fault.c
@@ -19,7 +19,7 @@ int arch_fixup(unsigned long address, un
 	const struct exception_table_entry *fixup;
 
 	fixup = search_exception_tables(address);
-	if(fixup != 0){
+	if(fixup != NULL){
 		UPT_IP(regs) = fixup->fixup;
 		return(1);
 	}

