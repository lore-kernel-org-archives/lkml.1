Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbYACPsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbYACPsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756693AbYACPmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:42:33 -0500
Received: from ns1.suse.de ([195.135.220.2]:48639 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756643AbYACPmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:42:32 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103442.621670000@suse.de>
In-Reply-To: <20080103442.621670000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH x86] [16/16] Mark memory_setup __init
Message-Id: <20080103154231.0856214EFF@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:42:30 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Otherwise

WARNING: vmlinux.o(.text+0x64a9): Section mismatch: reference to .init.text:machine_specific_memory_setup (between 'memory_setup' and 'show_cpuinfo')

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/setup_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86/kernel/setup_64.c
===================================================================
--- linux.orig/arch/x86/kernel/setup_64.c
+++ linux/arch/x86/kernel/setup_64.c
@@ -244,7 +244,7 @@ static inline void __init reserve_crashk
 #endif
 
 /* Overridden in paravirt.c if CONFIG_PARAVIRT */
-void __attribute__((weak)) memory_setup(void)
+void __attribute__((weak)) __init memory_setup(void)
 {
        machine_specific_memory_setup();
 }
