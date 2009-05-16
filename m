Return-Path: <linux-kernel-owner+w=401wt.eu-S1757324AbZEPJvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324AbZEPJvv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 05:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755819AbZEPJv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 05:51:27 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:53290 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998AbZEPJvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 05:51:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rKj0+gDSyBkVRbe2vVBcSidv+28DAoqFjVK8SO9fMUMXZk3vmVdS3NSPA3c22qB7HI
         XC3wkS/S9qSKH1x9tUv2Sb9N7N2aXrtN7Rz0mIpxao1QJg4BjtqUahyzeAs8ytUmqEx4
         +0YVKqW0dlepg7BKsB3+QZDTPBW4qgTV/DEZ8=
From: Vegard Nossum <vegard.nossum@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/4] kmemcheck: add __GFP_NOTRACK_FALSE_POSITIVE flag
Date: Sat, 16 May 2009 11:51:18 +0200
Message-Id: <1242467480-14378-2-git-send-email-vegard.nossum@gmail.com>
X-Mailer: git-send-email 1.6.2.rc0.61.g5cd12
In-Reply-To: <1242467480-14378-1-git-send-email-vegard.nossum@gmail.com>
References: <1242467480-14378-1-git-send-email-vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In contrast to __GFP_NOTRACK, this flag indicates that the allocation
should not be tracked _because_ it would produce a false positive.
Their values are identical, but need not be so in the future (for
example, we could now enable/disable false positives with a config
option).

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 include/linux/gfp.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 2700097..3885e7f 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -58,6 +58,12 @@ struct vm_area_struct;
 #define __GFP_NOTRACK	((__force gfp_t)0)
 #endif
 
+/*
+ * This may seem redundant, but it's a way of annotating false positives vs.
+ * allocations that simply cannot be supported (e.g. page tables).
+ */
+#define __GFP_NOTRACK_FALSE_POSITIVE (__GFP_NOTRACK)
+
 #define __GFP_BITS_SHIFT 22	/* Room for 22 __GFP_FOO bits */
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
-- 
1.6.0.6

