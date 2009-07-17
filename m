Return-Path: <linux-kernel-owner+w=401wt.eu-S933789AbZGQAG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933789AbZGQAG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933740AbZGQAGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:06:04 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39132 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933726AbZGQAF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:05:59 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <robin.getz@analog.com>
Subject: [PATCH 14/21] Blackfin: fix handling of IPEND in interrupt context save
Date: Thu, 16 Jul 2009 20:05:39 -0400
Message-Id: <1247789146-18786-15-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
References: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <robin.getz@analog.com>

The interrupt context save logic incorrectly stored the address of the
IPEND register rather than its value due to a missing dereference.  While
we're here, also enable this code for all kernel debugging scenarios and
not just when KGDB is enabled.

Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/context.S |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/blackfin/include/asm/context.S b/arch/blackfin/include/asm/context.S
index 16561ab..f8a664f 100644
--- a/arch/blackfin/include/asm/context.S
+++ b/arch/blackfin/include/asm/context.S
@@ -223,9 +223,10 @@
 	[--sp] = RETN;
 	[--sp] = RETE;
 	[--sp] = SEQSTAT;
-#ifdef CONFIG_KGDB
-	r1.l = lo(IPEND);
-	r1.h = hi(IPEND);
+#ifdef CONFIG_DEBUG_KERNEL
+	p1.l = lo(IPEND);
+	p1.h = hi(IPEND);
+	r1 = [p1];
 	[--sp] = r1;
 #else
 	[--sp] = r0;	/* Skip IPEND as well. */
-- 
1.6.3.3

