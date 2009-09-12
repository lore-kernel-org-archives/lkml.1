Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbZILRjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbZILRjp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 13:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbZILRjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 13:39:42 -0400
Received: from fifo99.com ([67.223.236.141]:33891 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbZILRjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 13:39:41 -0400
From: Daniel Walker <dwalker@fifo99.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Julia Lawall <julia@diku.dk>, linux-kernel@vger.kernel.org,
       Daniel Walker <dwalker@fifo99.com>
Subject: [PATCH] x86: apic: convert BUG() to BUG_ON()
Date: Sat, 12 Sep 2009 10:40:20 -0700
Message-Id: <1252777220-30796-1-git-send-email-dwalker@fifo99.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was done using Coccinelle's BUG_ON semantic patch.

Signed-off-by: Daniel Walker <dwalker@fifo99.com>
---
 arch/x86/kernel/apic/apic.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index a34601f..e3d467e 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1197,8 +1197,7 @@ void __cpuinit setup_local_APIC(void)
 	 * Double-check whether this APIC is really registered.
 	 * This is meaningless in clustered apic mode, so we skip it.
 	 */
-	if (!apic->apic_id_registered())
-		BUG();
+	BUG_ON(!apic->apic_id_registered());
 
 	/*
 	 * Intel recommends to set DFR, LDR and TPR before enabling
-- 
1.5.6.3

