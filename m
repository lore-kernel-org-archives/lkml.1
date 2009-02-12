Return-Path: <linux-kernel-owner+w=401wt.eu-S1760986AbZBLVwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760986AbZBLVwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 16:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756130AbZBLVwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 16:52:36 -0500
Received: from relay2.sgi.com ([192.48.179.30]:53955 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753178AbZBLVwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 16:52:36 -0500
Date: Thu, 12 Feb 2009 15:52:34 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] UV: set full apicid in uv_hub_send_ipi
Message-ID: <20090212215234.GA9808@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The uv_hub_send_ipi() function needs to set the full apicid in the
UVH_IPI_INT mmr.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Acked-by: Jack Steiner <steiner@sgi.org>

---

 arch/x86/include/asm/uv/uv_hub.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86/include/asm/uv/uv_hub.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_hub.h	2009-02-11 09:26:35.000000000 -0600
+++ linux/arch/x86/include/asm/uv/uv_hub.h	2009-02-12 15:06:04.000000000 -0600
@@ -411,7 +411,7 @@ static inline void uv_hub_send_ipi(int p
 	unsigned long val;
 
 	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
-			((apicid & 0x3f) << UVH_IPI_INT_APIC_ID_SHFT) |
+			(apicid << UVH_IPI_INT_APIC_ID_SHFT) |
 			(vector << UVH_IPI_INT_VECTOR_SHFT);
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
 }
