Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbYGVT0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbYGVT0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbYGVTX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:23:57 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:16203 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754222AbYGVTX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:23:56 -0400
X-BigFish: VPS22(zzzz10d3izzz32i87il)
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4F9VC-02-3LT-01
From: Robert Richter <robert.richter@amd.com>
To: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 18/24] OProfile: Fix IBS build error for UP
Date: Tue, 22 Jul 2008 21:09:02 +0200
Message-ID: <1216753748-11261-19-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jul 2008 19:23:40.0449 (UTC) FILETIME=[728D0910:01C8EC30]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_athlon.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/x86/oprofile/op_model_athlon.c b/arch/x86/oprofile/op_model_athlon.c
index 0d83903..1acb067 100644
--- a/arch/x86/oprofile/op_model_athlon.c
+++ b/arch/x86/oprofile/op_model_athlon.c
@@ -361,6 +361,26 @@ static void op_amd_shutdown(struct op_msrs const * const msrs)
 	}
 }
 
+#ifndef CONFIG_SMP
+
+/* no IBS support */
+
+static void setup_ibs(void)
+{
+	ibs_allowed = 0;
+}
+
+static void clear_ibs_nmi(void) {}
+
+static int op_amd_init(struct oprofile_operations *ops)
+{
+	return 0;
+}
+
+static void op_amd_exit(void) {}
+
+#else
+
 static u8 ibs_eilvt_off;
 
 static inline void apic_init_ibs_nmi_per_cpu(void *arg)
@@ -505,6 +525,8 @@ static void op_amd_exit(void)
 	clear_ibs_nmi();
 }
 
+#endif
+
 struct op_x86_model_spec const op_amd_spec = {
 	.init = op_amd_init,
 	.exit = op_amd_exit,
-- 
1.5.5.4


