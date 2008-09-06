Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772AbYIFR1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbYIFR1D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 13:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbYIFR0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 13:26:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:43354 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbYIFR0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 13:26:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Ph0t+xVZdTGgxkXNgqV2OCG1f1PqsYRx+l1Pin1VRzU1Gr5JFEdwRN4WiiqBj2qk3r
         stGwD+PphnM5AG7nDNgboqMiHQubBPdB6gR27DEYjEeyvyf9gDKnvT2ZuODIUuZJrA6W
         Kk8RbEO5MQ/JF6Nwt/N8HwX/w1pCPtTACE0oc=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] dyn_array: remove one panic
Date: Sat,  6 Sep 2008 10:26:50 -0700
Message-Id: <1220722010-12302-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew said, we don't need duplicated panic.
because __alloc_bootmem already have that.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/init/dyn_array.c b/init/dyn_array.c
index cf1e04c..778d9d5 100644
--- a/init/dyn_array.c
+++ b/init/dyn_array.c
@@ -33,11 +33,9 @@ void __init pre_alloc_dyn_array(void)
 
 	/* allocate them all together */
 	max_align = max_t(unsigned long, max_align, PAGE_SIZE);
-	ptr = __alloc_bootmem_nopanic(total_size, max_align, 0);
-	if (!ptr)
-		panic("Can not alloc dyn_alloc\n");
-
+	ptr = __alloc_bootmem(total_size, max_align, 0);
 	phys = virt_to_phys(ptr);
+
 	for (daa = __dyn_array_start ; daa < __dyn_array_end; daa++) {
 		struct dyn_array *da = *daa;
 
