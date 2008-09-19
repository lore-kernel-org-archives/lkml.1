Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939AbYISSps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbYISSps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 14:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbYISSpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 14:45:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:17250 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbYISSpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 14:45:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QtYgR9l31r4rpgaXer3fiWcMqdVcdrdRLu3GIVngz46RoTnm/ZBAQyq+9kSox5Fsvn
         1Uec0ezYjBVqnS6TWhnkuotVjFfwHx0+eP8qNgvmT+HgOV07DAXbv/Oql07X+sfV57MU
         OtpxNJ0YMa8QV3EEx0y4gem6i1QTKVUgXIw28=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: use WARN_ONCE in workaround for mtrr mask
Date: Fri, 19 Sep 2008 11:45:04 -0700
Message-Id: <1221849904-8856-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so could help to catch attention about bug in bios about mtrr mask setting

WARN_ONCE get into mainline already. let use it.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/cpu/mtrr/generic.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/generic.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c
@@ -401,12 +401,7 @@ static void generic_get_mtrr(unsigned in
 		tmp |= ~((1<<(hi - 1)) - 1);
 
 		if (tmp != mask_lo) {
-			static int once = 1;
-
-			if (once) {
-				printk(KERN_INFO "mtrr: your BIOS has set up an incorrect mask, fixing it up.\n");
-				once = 0;
-			}
+			WARN_ONCE(1, KERN_INFO "mtrr: your BIOS has set up an incorrect mask, fixing it up.\n");
 			mask_lo = tmp;
 		}
 	}
