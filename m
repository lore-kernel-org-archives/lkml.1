Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235Ab0AGQMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab0AGQMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 11:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208Ab0AGQMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 11:12:48 -0500
Received: from relay3.sgi.com ([192.48.152.1]:38776 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751021Ab0AGQMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 11:12:47 -0500
Date: Thu, 7 Jan 2010 10:12:40 -0600
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86, UV - uv_global_gru_mmr_address() macro fix
Message-ID: <20100107161240.GA2610@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix bug in uv_global_gru_mmr_address macro.  Macro failed
to cast an int value to a long prior to a left shift > 32.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: <stable@kernel.org>

---
 arch/x86/include/asm/uv/uv_hub.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/arch/x86/include/asm/uv/uv_hub.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_hub.h	2010-01-07 01:54:31.000000000 -0600
+++ linux/arch/x86/include/asm/uv/uv_hub.h	2010-01-07 09:43:02.000000000 -0600
@@ -329,7 +329,8 @@ static inline unsigned long uv_read_glob
  */
 static inline unsigned long uv_global_gru_mmr_address(int pnode, unsigned long offset)
 {
-	return UV_GLOBAL_GRU_MMR_BASE | offset | (pnode << uv_hub_info->m_val);
+	return UV_GLOBAL_GRU_MMR_BASE | offset |
+		((unsigned long)pnode << uv_hub_info->m_val);
 }
 
 static inline void uv_write_global_mmr8(int pnode, unsigned long offset, unsigned char val)
