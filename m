Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbZEOTwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbZEOTwh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 15:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbZEOTw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 15:52:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:40422 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbZEOTw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 15:52:28 -0400
Message-ID: <4A0DC7DC.7000204@kernel.org>
Date: Fri, 15 May 2009 12:51:56 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: [PATCH] x86: update_mptable need pci_routeirq
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


to get all device irq routing and save them

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/mpparse.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -17,6 +17,7 @@
 #include <linux/acpi.h>
 #include <linux/module.h>
 #include <linux/smp.h>
+#include <linux/pci.h>
 
 #include <asm/mtrr.h>
 #include <asm/mpspec.h>
@@ -961,6 +962,7 @@ static int __initdata enable_update_mpta
 static int __init update_mptable_setup(char *str)
 {
 	enable_update_mptable = 1;
+	pci_routeirq = 1;
 	return 0;
 }
 early_param("update_mptable", update_mptable_setup);
@@ -973,6 +975,7 @@ static int __initdata alloc_mptable;
 static int __init parse_alloc_mptable_opt(char *p)
 {
 	enable_update_mptable = 1;
+	pci_routeirq = 1;
 	alloc_mptable = 1;
 	if (!p)
 		return 0;
