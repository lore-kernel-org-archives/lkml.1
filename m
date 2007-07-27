Return-Path: <linux-kernel-owner+w=401wt.eu-S964883AbXG0Js2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964883AbXG0Js2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 05:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935858AbXG0JqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 05:46:16 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:35955 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765544AbXG0JqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 05:46:14 -0400
Date: Fri, 27 Jul 2007 11:44:48 +0200 (MEST)
Message-Id: <200707270944.LAA17213@ifs.emn.fr>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH 08/68] 0 -> NULL, for arch/m68k
Cc: geert@linux-m68k.org, zippel@linux-m68k.org, linux-m68k@vger.kernel.org,
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
Cc: geert@linux-m68k.org
Cc: zippel@linux-m68k.org
Cc: linux-m68k@lists.linux-m68k.org
Cc: akpm@linux-foundation.org
---

 stram.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/m68k/atari/stram.c b/arch/m68k/atari/stram.c
index bf4588c..a37b985 100644
--- a/arch/m68k/atari/stram.c
+++ b/arch/m68k/atari/stram.c
@@ -130,7 +130,7 @@ void __init atari_stram_init(void)
 	/* determine whether kernel code resides in ST-RAM (then ST-RAM is the
 	 * first memory block at virtual 0x0) */
 	stram_start = phys_to_virt(0);
-	kernel_in_stram = (stram_start == 0);
+	kernel_in_stram = (stram_start == NULL);
 
 	for( i = 0; i < m68k_num_memory; ++i ) {
 		if (m68k_memory[i].addr == 0) {

