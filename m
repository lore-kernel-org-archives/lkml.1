Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbYGVTY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbYGVTY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYGVTXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:23:53 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:15925 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752001AbYGVTXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:23:51 -0400
X-BigFish: VPS24(z37d4jzzz10d3izzz32i87il66h)
X-Spam-TCS-SCL: 5:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4F9VE-01-8PR-01
From: Robert Richter <robert.richter@amd.com>
To: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 20/24] x86/oprofile: op_model_athlon.c: Fix counter reset when reenabling IBS OP
Date: Tue, 22 Jul 2008 21:09:04 +0200
Message-ID: <1216753748-11261-21-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jul 2008 19:23:40.0870 (UTC) FILETIME=[72CD4660:01C8EC30]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_athlon.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/oprofile/op_model_athlon.c b/arch/x86/oprofile/op_model_athlon.c
index a3a2058..9c8c8c5 100644
--- a/arch/x86/oprofile/op_model_athlon.c
+++ b/arch/x86/oprofile/op_model_athlon.c
@@ -251,6 +251,7 @@ op_amd_handle_ibs(struct pt_regs * const regs,
 						(unsigned int *)&ibs_op,
 						IBS_OP_BEGIN);
 			rdmsr(MSR_AMD64_IBSOPCTL, low, high);
+			high = 0;
 			low &= ~IBS_OP_LOW_VALID_BIT;
 			low |= IBS_OP_LOW_ENABLE;
 			wrmsr(MSR_AMD64_IBSOPCTL, low, high);
-- 
1.5.5.4


