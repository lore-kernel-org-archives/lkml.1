Return-Path: <linux-kernel-owner+w=401wt.eu-S1764624AbXEULCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764624AbXEULCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 07:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757072AbXEULAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 07:00:46 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:34396 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757092AbXEULAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 07:00:39 -0400
Message-Id: <20070521110108.873941496@de.ibm.com>
References: <20070521105118.955425052@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:51:22 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Maneesh Soni <maneesh@in.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 4/5] Make use of kretprobe_assert.
Content-Disposition: inline; filename=004-kprobes.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

s390 change for git commit 0f95b7fc839bc3272b1bf2325d8748a649bd3534.
That is print kprobes debug data before BUG().

Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Maneesh Soni <maneesh@in.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/kprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: quilt-2.6/arch/s390/kernel/kprobes.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/kprobes.c
+++ quilt-2.6/arch/s390/kernel/kprobes.c
@@ -413,7 +413,7 @@ static int __kprobes trampoline_probe_ha
 			break;
 		}
 	}
-	BUG_ON(!orig_ret_address || (orig_ret_address == trampoline_address));
+	kretprobe_assert(ri, orig_ret_address, trampoline_address);
 	regs->psw.addr = orig_ret_address | PSW_ADDR_AMODE;
 
 	reset_current_kprobe();

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

