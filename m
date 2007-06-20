Return-Path: <linux-kernel-owner+w=401wt.eu-S1763405AbXFTK0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763405AbXFTK0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 06:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760888AbXFTKXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 06:23:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:36160 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757486AbXFTKXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 06:23:38 -0400
From: Andi Kleen <ak@suse.de>
References: <200706201223.443613000@suse.de>
In-Reply-To: <200706201223.443613000@suse.de>
To: torvalds@osdl.org, linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: [PATCH for 2.6.22] [9/10] i386: Disable alternative() patching after boot with DEBUG_RODATA
Message-Id: <20070620102338.18BF914AD0@wotan.suse.de>
Date: Wed, 20 Jun 2007 12:23:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Kernel text is protected now so this won't work.

We'll fix it better next time.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/alternative.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux/arch/i386/kernel/alternative.c
===================================================================
--- linux.orig/arch/i386/kernel/alternative.c
+++ linux/arch/i386/kernel/alternative.c
@@ -308,6 +308,11 @@ void alternatives_smp_switch(int smp)
 	printk("lockdep: not fixing up alternatives.\n");
 	return;
 #endif
+#ifdef CONFIG_DEBUG_RODATA
+	/* To be fixed properly post 2.6.22 -- need to get writable
+ 	   mappings of the kernel text */
+	return;
+#endif
 
 	if (noreplace_smp || smp_alt_once)
 		return;
