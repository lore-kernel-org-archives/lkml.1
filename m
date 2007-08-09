Return-Path: <linux-kernel-owner+w=401wt.eu-S939795AbXHIMph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939795AbXHIMph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939651AbXHIMlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:41:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34963 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938714AbXHIMlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:41:35 -0400
From: Andi Kleen <ak@suse.de>
References: <20070809241.425881000@suse.de>
In-Reply-To: <20070809241.425881000@suse.de>
To: bunk@stusta.de, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [7/12] x86_64: really stop MCEs during code  patching
Message-Id: <20070809124134.E4AD014F3B@wotan.suse.de>
Date: Thu,  9 Aug 2007 14:41:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Adrian Bunk <bunk@stusta.de>
It's CONFIG_X86_MCE, not CONFIG_MCE.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/alternative.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/i386/kernel/alternative.c
===================================================================
--- linux.orig/arch/i386/kernel/alternative.c
+++ linux/arch/i386/kernel/alternative.c
@@ -388,7 +388,7 @@ void __init alternative_instructions(voi
 	   that might execute the to be patched code.
 	   Other CPUs are not running. */
 	stop_nmi();
-#ifdef CONFIG_MCE
+#ifdef CONFIG_X86_MCE
 	stop_mce();
 #endif
 
@@ -426,7 +426,7 @@ void __init alternative_instructions(voi
 	local_irq_restore(flags);
 
 	restart_nmi();
-#ifdef CONFIG_MCE
+#ifdef CONFIG_X86_MCE
 	restart_mce();
 #endif
 }
