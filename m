Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbYH2XrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbYH2XrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 19:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbYH2Xq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 19:46:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:30113 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbYH2Xq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 19:46:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QiVKFxp09iKyVl7VrifBdKDBC2Ywkirk+gItgEHl9YJ9JCkdsOfEtA0bIZKju8FK16
         bFkwkPObcSHmTBE29qOhwqN9bhD35MJcBx8bIjIoA53Ayu5C9qz9kO4RqQCBD/wkiNwY
         qmGtV8BycZYCMtgjkIIAz3vPHE8eZRGM/mKm0=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] dyn_array: fix typo
Date: Fri, 29 Aug 2008 16:46:00 -0700
Message-Id: <1220053560-15803-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew found the typo could break some platforms

also fix one checkpatch warning

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/init/dyn_array.c b/init/dyn_array.c
index c4cd902..8192a1c 100644
--- a/init/dyn_array.c
+++ b/init/dyn_array.c
@@ -54,7 +54,7 @@ void __init pre_alloc_dyn_array(void)
 			da->init_work(da);
 	}
 #else
-#ifdef CONFIF_GENERIC_HARDIRQS
+#ifdef CONFIG_GENERIC_HARDIRQS
 	unsigned int i;
 
 	for (i = 0; i < NR_IRQS; i++)
@@ -116,9 +116,8 @@ void __init per_cpu_alloc_dyn_array(int cpu, char *ptr)
 
 		phys += size;
 
-		if (da->init_work) {
+		if (da->init_work)
 			da->init_work(da);
-		}
 	}
 #endif
 }
