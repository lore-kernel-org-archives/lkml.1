Return-Path: <linux-kernel-owner+w=401wt.eu-S1756929AbYISHMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbYISHMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 03:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbYISHMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 03:12:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:9125 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbYISHM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 03:12:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AHO3k0B7KSfvB9MEFikoNd8tvPYdThI5N6bUEqiUKVwATDdviL8IRnigETU14qALR0
         kgThJlCen2H/UwxrfnThqqLn212Kwn3LzfdXF6GdeyNBN5eXmVobkoKLVwlpy15z16w0
         Z32fXBYOt+f/vVW8e/lgIEL0BEDca0GZL1kek=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86/mtrr: fix compiling warning
Date: Fri, 19 Sep 2008 00:11:50 -0700
Message-Id: <1221808310-15759-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 58ac5d3..90f0531 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -1218,11 +1218,10 @@ static int __init mtrr_cleanup(unsigned address_bits)
 
 	memset(range, 0, sizeof(range));
 	extra_remove_size = 0;
-	if (mtrr_tom2) {
-		extra_remove_base = 1 << (32 - PAGE_SHIFT);
+	extra_remove_base = 1 << (32 - PAGE_SHIFT);
+	if (mtrr_tom2)
 		extra_remove_size =
 			(mtrr_tom2 >> PAGE_SHIFT) - extra_remove_base;
-	}
 	nr_range = x86_get_mtrr_mem_range(range, 0, extra_remove_base,
 					  extra_remove_size);
 	range_sums = sum_ranges(range, nr_range);
