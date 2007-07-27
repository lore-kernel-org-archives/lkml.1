Return-Path: <linux-kernel-owner+w=401wt.eu-S936930AbXG0Jtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936930AbXG0Jtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 05:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936515AbXG0Jqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 05:46:36 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:36086 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764350AbXG0Jqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 05:46:35 -0400
Date: Fri, 27 Jul 2007 11:45:05 +0200 (MEST)
Message-Id: <200707270945.LAA17250@ifs.emn.fr>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH 11/68] 0 -> NULL, for arch/parisc
Cc: matthew@wil.cx, grundler@parisc-linux.org, kyle@parisc-linux.org,
       parisc-linux@parisc-linux.org, akpm@linux-foundation.org,
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
Cc: matthew@wil.cx
Cc: grundler@parisc-linux.org
Cc: kyle@parisc-linux.org
Cc: parisc-linux@parisc-linux.org
Cc: akpm@linux-foundation.org
---

 smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
index 04c7e1d..16fccbe 100644
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -333,7 +333,7 @@ smp_call_function (void (*func) (void *i
 
 	if (retry) {
 		spin_lock (&lock);
-		while (smp_call_function_data != 0)
+		while (smp_call_function_data != NULL)
 			barrier();
 	}
 	else {

