Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbZKSRcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbZKSRcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:32:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbZKSRcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:32:04 -0500
Received: from relay1.sgi.com ([192.48.179.29]:53341 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753269AbZKSRcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:32:01 -0500
From: Robin Holt <holt@sgi.com>
Message-Id: <20091119173206.875021000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 19 Nov 2009 11:32:00 -0600
To: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de
Cc: Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [patch 3/8] x86: UV - Introduce uv_gpa_is_mmr.
References: <20091119173157.337874000@alcatraz.americas.sgi.com>
Content-Disposition: inline; filename=uv_gpa_is_mmr_space
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Provide a mechanism for determining if a global physical address is
pointing to a UV hub MMR.

To: Ingo Molnar <mingo@elte.hu>
To: tglx@linutronix.de
Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>

---

 arch/x86/include/asm/uv/uv_hub.h |    7 +++++++
 1 file changed, 7 insertions(+)
Index: linux-x86/arch/x86/include/asm/uv/uv_hub.h
===================================================================
--- linux-x86.orig/arch/x86/include/asm/uv/uv_hub.h	2009-11-09 08:50:25.000000000 -0600
+++ linux-x86/arch/x86/include/asm/uv/uv_hub.h	2009-11-09 08:52:14.000000000 -0600
@@ -232,6 +232,13 @@ static inline unsigned long uv_gpa(void 
 	return uv_soc_phys_ram_to_gpa(__pa(v));
 }
 
+/* Top two bits indicate the requested address is in MMR space.  */
+static inline int
+uv_gpa_in_mmr_space(unsigned long gpa)
+{
+	return (gpa >> 62) == 0x3UL;
+}
+
 /* UV global physical address --> socket phys RAM */
 static inline unsigned long uv_gpa_to_soc_phys_ram(unsigned long gpa)
 {

