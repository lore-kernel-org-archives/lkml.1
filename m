Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbZERHmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbZERHmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 03:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756291AbZERHlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 03:41:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:48981 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756577AbZERHlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 03:41:03 -0400
Date: Mon, 18 May 2009 07:40:26 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, jbarnes@virtuousgeek.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, jbarnes@virtuousgeek.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4A0DB7B4.4060702@kernel.org>
References: <4A0DB7B4.4060702@kernel.org>
Subject: [tip:irq/numa] x86, irq: update_mptable needs pci_routeirq
Message-ID: <tip-629e15d245f46bef9d26199b450f882f9437a8fe@git.kernel.org>
Git-Commit-ID: 629e15d245f46bef9d26199b450f882f9437a8fe
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 18 May 2009 07:40:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  629e15d245f46bef9d26199b450f882f9437a8fe
Gitweb:     http://git.kernel.org/tip/629e15d245f46bef9d26199b450f882f9437a8fe
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 15 May 2009 13:05:16 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 May 2009 09:33:17 +0200

x86, irq: update_mptable needs pci_routeirq

To get all device irq routing and to save them.

This is basically an implicit pci=routeirq enablement if (and on if)
the update_mptable boot option (which is off by default) has been
specified.

[ Impact: extend the update_mptable boot opion's scope ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
LKML-Reference: <4A0DB7B4.4060702@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/mpparse.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index cd2a41a..e6bf9d0 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -17,6 +17,7 @@
 #include <linux/acpi.h>
 #include <linux/module.h>
 #include <linux/smp.h>
+#include <linux/pci.h>
 
 #include <asm/mtrr.h>
 #include <asm/mpspec.h>
@@ -961,6 +962,9 @@ static int __initdata enable_update_mptable;
 static int __init update_mptable_setup(char *str)
 {
 	enable_update_mptable = 1;
+#ifdef CONFIG_PCI
+	pci_routeirq = 1;
+#endif
 	return 0;
 }
 early_param("update_mptable", update_mptable_setup);
@@ -973,6 +977,9 @@ static int __initdata alloc_mptable;
 static int __init parse_alloc_mptable_opt(char *p)
 {
 	enable_update_mptable = 1;
+#ifdef CONFIG_PCI
+	pci_routeirq = 1;
+#endif
 	alloc_mptable = 1;
 	if (!p)
 		return 0;
