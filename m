Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbXJXIvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbXJXIvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 04:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbXJXIvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 04:51:06 -0400
Received: from il.qumranet.com ([82.166.9.18]:45188 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbXJXIvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 04:51:05 -0400
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, bunk@kernel.org, Andrew Morton <akpm@osdl.org>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH] Define smp_call_function_mask() on uniprocessor builds
Date: Wed, 24 Oct 2007 10:51:25 +0200
Message-Id: <11932158852325-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than #ifdef users of smp_call_function_mask(), define it as an
empty macro to avoid build errors.  The function explicitly prohibits
callers from specifying the current cpu, so nothing needs to be done.

This unbreaks uniprocessor KVM builds.

Signed-off-by: Avi Kivity <avi@qumranet.com>

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 259a13c..24e2e31 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -108,6 +108,9 @@ static inline void smp_send_reschedule(int cpu) { }
 	0;			\
 })
 
+#define smp_call_function_mask(mask, func, info, wait) \
+	do { (void)(mask); (void)(func); (void)(info); (void)(wait); } while (0)
+
 #endif /* !SMP */
 
 /*
