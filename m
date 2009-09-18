Return-Path: <linux-kernel-owner+w=401wt.eu-S1756888AbZIRLtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbZIRLtL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 07:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756618AbZIRLtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 07:49:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:37230 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756583AbZIRLtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 07:49:09 -0400
Date: Fri, 18 Sep 2009 11:48:40 GMT
From: tip-bot for Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, julia@diku.dk, dwalker@fifo99.com,
       hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, dwalker@fifo99.com, julia@diku.dk,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1252777220-30796-1-git-send-email-dwalker@fifo99.com>
References: <1252777220-30796-1-git-send-email-dwalker@fifo99.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: apic: Convert BUG() to BUG_ON()
Message-ID: <tip-c2777f98c205148f1a0d4f9ac03b9cb20b39b2da@git.kernel.org>
Git-Commit-ID: c2777f98c205148f1a0d4f9ac03b9cb20b39b2da
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 18 Sep 2009 11:48:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c2777f98c205148f1a0d4f9ac03b9cb20b39b2da
Gitweb:     http://git.kernel.org/tip/c2777f98c205148f1a0d4f9ac03b9cb20b39b2da
Author:     Daniel Walker <dwalker@fifo99.com>
AuthorDate: Sat, 12 Sep 2009 10:40:20 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Sep 2009 13:45:33 +0200

x86: apic: Convert BUG() to BUG_ON()

This was done using Coccinelle's BUG_ON semantic patch.

Signed-off-by: Daniel Walker <dwalker@fifo99.com>
Cc: Julia Lawall <julia@diku.dk>
LKML-Reference: <1252777220-30796-1-git-send-email-dwalker@fifo99.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/apic.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 159740d..79e5b92 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1196,8 +1196,7 @@ void __cpuinit setup_local_APIC(void)
 	 * Double-check whether this APIC is really registered.
 	 * This is meaningless in clustered apic mode, so we skip it.
 	 */
-	if (!apic->apic_id_registered())
-		BUG();
+	BUG_ON(!apic->apic_id_registered());
 
 	/*
 	 * Intel recommends to set DFR, LDR and TPR before enabling
