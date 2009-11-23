Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbZKWLw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbZKWLw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757071AbZKWLwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:52:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:55933 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756968AbZKWLwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:52:25 -0500
Date: Mon, 23 Nov 2009 11:51:47 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B07A739.3030104@kernel.org>
References: <4B07A739.3030104@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: apic: Remove not needed #ifdef
Message-ID: <tip-e670761f12f4069d204f433bf547d9c679a4fd05@git.kernel.org>
Git-Commit-ID: e670761f12f4069d204f433bf547d9c679a4fd05
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e670761f12f4069d204f433bf547d9c679a4fd05
Gitweb:     http://git.kernel.org/tip/e670761f12f4069d204f433bf547d9c679a4fd05
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sat, 21 Nov 2009 00:23:37 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Nov 2009 09:54:15 +0100

x86: apic: Remove not needed #ifdef

Suresh made dmar_table_init() already have that protection.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4B07A739.3030104@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/apic.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 4c689f4..ad8c75b 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1377,14 +1377,11 @@ void __init enable_IR_x2apic(void)
 	unsigned long flags;
 	struct IO_APIC_route_entry **ioapic_entries = NULL;
 	int ret, x2apic_enabled = 0;
-	int dmar_table_init_ret = 0;
+	int dmar_table_init_ret;
 
-#ifdef CONFIG_INTR_REMAP
 	dmar_table_init_ret = dmar_table_init();
-	if (dmar_table_init_ret)
-		pr_debug("dmar_table_init() failed with %d:\n",
-				dmar_table_init_ret);
-#endif
+	if (dmar_table_init_ret && !x2apic_supported())
+		return;
 
 	ioapic_entries = alloc_ioapic_entries();
 	if (!ioapic_entries) {
