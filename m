Return-Path: <linux-kernel-owner+w=401wt.eu-S1758840AbZCMITf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840AbZCMITf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 04:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757729AbZCMIMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 04:12:32 -0400
Received: from gw.goop.org ([64.81.55.164]:34826 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757238AbZCMIM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:12:27 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Alex Nixon <alex.nixon@citrix.com>
Subject: [PATCH 13/24] Xen: Add virt_to_pfn helper function
Date: Fri, 13 Mar 2009 01:11:49 -0700
Message-Id: <1236931920-6861-14-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236931920-6861-1-git-send-email-jeremy@goop.org>
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Nixon <alex.nixon@citrix.com>

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
---
 arch/x86/include/asm/xen/page.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index 1a918dd..018a0a4 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -124,7 +124,8 @@ static inline unsigned long mfn_to_local_pfn(unsigned long mfn)
 
 /* VIRT <-> MACHINE conversion */
 #define virt_to_machine(v)	(phys_to_machine(XPADDR(__pa(v))))
-#define virt_to_mfn(v)		(pfn_to_mfn(PFN_DOWN(__pa(v))))
+#define virt_to_pfn(v)          (PFN_DOWN(__pa(v)))
+#define virt_to_mfn(v)		(pfn_to_mfn(virt_to_pfn(v)))
 #define mfn_to_virt(m)		(__va(mfn_to_pfn(m) << PAGE_SHIFT))
 
 static inline unsigned long pte_mfn(pte_t pte)
-- 
1.6.0.6

