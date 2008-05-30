Return-Path: <linux-kernel-owner+w=401wt.eu-S1755084AbYE3AO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbYE3AO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 20:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbYE3AOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 20:14:47 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:28197 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757571AbYE3AOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 20:14:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=eEL3Z2XYDWwUoAwdRZGAJBR0nc2yiPhEAB77wr3WG4U4fEGePJWY0iXGZdVrxMXgy9mwplwho6zUBCaUo10zK/7wte8wCgM1Fp4pyWR4xDurILOZkCRW747fEJBNYLhA6Ja0bEjgdoiFqLzHPv6Wqnvrb0ZJATqK0MlPkHI6PBw=
From: Kevin Winchester <kjwinchester@gmail.com>
To: mingo@elte.hu
Cc: Kevin Winchester <kjwinchester@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: fix pointer type warning in arch/x86/mm/init_64.c:early_memtest
Date: Thu, 29 May 2008 21:14:35 -0300
Message-Id: <1212106475-3297-1-git-send-email-kjwinchester@gmail.com>
X-Mailer: git-send-email 1.5.5.40.g4cdda
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed the call to find_e820_area_size to pass u64 instead of unsigned long.

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
---
 arch/x86/mm/init_64.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 83ab7f9..94f73c2 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -515,7 +515,7 @@ early_param("memtest", parse_memtest);
 
 static void __init early_memtest(unsigned long start, unsigned long end)
 {
-	unsigned long t_start, t_size;
+	u64 t_start, t_size;
 	unsigned pattern;
 
 	if (!memtest_pattern)
@@ -534,7 +534,7 @@ static void __init early_memtest(unsigned long start, unsigned long end)
 			if (t_start + t_size > end)
 				t_size = end - t_start;
 
-			printk(KERN_CONT "\n  %016lx - %016lx pattern %d",
+			printk(KERN_CONT "\n  %016llx - %016llx pattern %d",
 				t_start, t_start + t_size, pattern);
 
 			memtest(t_start, t_size, pattern);
-- 
1.5.5.40.g4cdda

