Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbZFEIWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbZFEIWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755921AbZFEIG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:56 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37482 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177AbZFEIGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:06:09 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 46/62] Blackfin: fix command line corruption with DEBUG_DOUBLEFAULT
Date: Fri,  5 Jun 2009 04:04:55 -0400
Message-Id: <1244189111-19639-47-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6b3087c6 (which introduced Blackfin SMP) broke command line passing
when the DEBUG_DOUBLEFAULT config option was enabled.  Switch the code to
using a scratch register and not R7 which holds the command line.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-common/head.S |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/blackfin/mach-common/head.S b/arch/blackfin/mach-common/head.S
index 01d62ff..f826f6b 100644
--- a/arch/blackfin/mach-common/head.S
+++ b/arch/blackfin/mach-common/head.S
@@ -124,25 +124,25 @@ ENTRY(__start)
 	 * below
 	 */
 	GET_PDA(p0, r0);
-	r7 = [p0 + PDA_RETX];
+	r6 = [p0 + PDA_RETX];
 	p1.l = _init_saved_retx;
 	p1.h = _init_saved_retx;
-	[p1] = r7;
+	[p1] = r6;
 
-	r7 = [p0 + PDA_DCPLB];
+	r6 = [p0 + PDA_DCPLB];
 	p1.l = _init_saved_dcplb_fault_addr;
 	p1.h = _init_saved_dcplb_fault_addr;
-	[p1] = r7;
+	[p1] = r6;
 
-	r7 = [p0 + PDA_ICPLB];
+	r6 = [p0 + PDA_ICPLB];
 	p1.l = _init_saved_icplb_fault_addr;
 	p1.h = _init_saved_icplb_fault_addr;
-	[p1] = r7;
+	[p1] = r6;
 
-	r7 = [p0 + PDA_SEQSTAT];
+	r6 = [p0 + PDA_SEQSTAT];
 	p1.l = _init_saved_seqstat;
 	p1.h = _init_saved_seqstat;
-	[p1] = r7;
+	[p1] = r6;
 #endif
 
 	/* Initialize stack pointer */
-- 
1.6.3.1

