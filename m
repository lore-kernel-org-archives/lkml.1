Return-Path: <linux-kernel-owner+w=401wt.eu-S1758307AbXFRGXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307AbXFRGXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 02:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbXFRGXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 02:23:00 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:38945 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754890AbXFRGXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 02:23:00 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: [patch] use __asm__ rather than asm in asm-s390/ptrace.h
Date: Mon, 18 Jun 2007 02:23:06 -0400
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706180223.07122.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since asm-s390/ptrace.h is exported to userspace, we need to make sure we use
__asm__() rather than asm() as the latter is disabled when gcc compiles with
GNU extensions turned off (like -std=c99).

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/include/asm-s390/ptrace.h b/include/asm-s390/ptrace.h
index fa6ca87..4add355 100644
--- a/include/asm-s390/ptrace.h
+++ b/include/asm-s390/ptrace.h
@@ -475,7 +475,7 @@ extern void show_regs(struct pt_regs * regs);
 static inline void
 psw_set_key(unsigned int key)
 {
-	asm volatile("spka 0(%0)" : : "d" (key));
+	__asm__ __volatile__("spka 0(%0)" : : "d" (key));
 }
 
 #endif /* __ASSEMBLY__ */
