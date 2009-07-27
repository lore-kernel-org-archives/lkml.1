Return-Path: <linux-kernel-owner+w=401wt.eu-S1752451AbZG0OiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbZG0OiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 10:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbZG0OiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 10:38:09 -0400
Received: from relay1.sgi.com ([192.48.179.29]:53399 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750756AbZG0OiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 10:38:08 -0400
Date: Mon, 27 Jul 2009 09:38:08 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: Subject: [PATCH] x86, UV: Fix macros for accessing large node numbers
Message-ID: <20090727143808.GA8076@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The UV chipset automatically supplies the upper bits on nodes being
referenced by MMR accesses. These bit can be deleted from the
hub addressing macros.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 arch/x86/include/asm/uv/uv_hub.h |    2 +-
 arch/x86/kernel/apic/io_apic.c   |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

Index: linux/arch/x86/include/asm/uv/uv_hub.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_hub.h	2009-06-22 08:41:31.000000000 -0500
+++ linux/arch/x86/include/asm/uv/uv_hub.h	2009-06-22 10:10:14.000000000 -0500
@@ -175,7 +175,7 @@ DECLARE_PER_CPU(struct uv_hub_info_s, __
 #define UV_GLOBAL_MMR32_PNODE_BITS(p)	((p) << (UV_GLOBAL_MMR32_PNODE_SHIFT))
 
 #define UV_GLOBAL_MMR64_PNODE_BITS(p)					\
-	((unsigned long)(UV_PNODE_TO_GNODE(p)) << UV_GLOBAL_MMR64_PNODE_SHIFT)
+	(((unsigned long)(p)) << UV_GLOBAL_MMR64_PNODE_SHIFT)
 
 #define UV_APIC_PNODE_SHIFT	6
 
