Return-Path: <linux-kernel-owner+w=401wt.eu-S1753574AbZIIPlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbZIIPlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 11:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbZIIPlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 11:41:07 -0400
Received: from relay2.sgi.com ([192.48.179.30]:58908 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752833AbZIIPlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 11:41:07 -0400
Date: Wed, 9 Sep 2009 10:41:05 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: SGU UV Fix IPI macros
Message-ID: <20090909154104.GA25083@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UV bios has changed the way interrupt remapping is being done. This
affects the id used for sending IPIs. The upper id bits no longer
need to be masked off.


Signed-off-by: Jack Steiner <steiner@sgi.com>

---

Index: linux/arch/x86/include/asm/uv/uv_hub.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_hub.h	2009-08-06 16:26:40.000000000 -0500
+++ linux/arch/x86/include/asm/uv/uv_hub.h	2009-08-12 11:11:23.000000000 -0500
@@ -422,7 +422,7 @@ static inline void uv_hub_send_ipi(int p
 	unsigned long val;
 
 	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
-			((apicid & 0x3f) << UVH_IPI_INT_APIC_ID_SHFT) |
+			((apicid) << UVH_IPI_INT_APIC_ID_SHFT) |
 			(vector << UVH_IPI_INT_VECTOR_SHFT);
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
 }
