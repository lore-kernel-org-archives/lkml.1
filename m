Return-Path: <linux-kernel-owner+w=401wt.eu-S1757451AbZFLNO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbZFLNO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762802AbZFLNOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:14:38 -0400
Received: from sg2ehsobe005.messaging.microsoft.com ([207.46.51.79]:38574 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1763987AbZFLNOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:14:37 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KL4MQK-03-HW3-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 07/23] x86/oprofile: simplify AMD cpu init code
Date: Fri, 12 Jun 2009 14:35:24 +0200
Message-ID: <1244810140-20595-8-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
References: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 12 Jun 2009 12:59:05.0998 (UTC) FILETIME=[915BFAE0:01C9EB5D]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index dd85153..ae0ab03 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -460,27 +460,26 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 		/* Needs to be at least an Athlon (or hammer in 32bit mode) */
 
 		switch (family) {
-		default:
-			return -ENODEV;
 		case 6:
-			model = &op_amd_spec;
 			cpu_type = "i386/athlon";
 			break;
 		case 0xf:
-			model = &op_amd_spec;
-			/* Actually it could be i386/hammer too, but give
-			 user space an consistent name. */
+			/*
+			 * Actually it could be i386/hammer too, but
+			 * give user space an consistent name.
+			 */
 			cpu_type = "x86-64/hammer";
 			break;
 		case 0x10:
-			model = &op_amd_spec;
 			cpu_type = "x86-64/family10";
 			break;
 		case 0x11:
-			model = &op_amd_spec;
 			cpu_type = "x86-64/family11h";
 			break;
+		default:
+			return -ENODEV;
 		}
+		model = &op_amd_spec;
 		break;
 
 	case X86_VENDOR_INTEL:
-- 
1.6.3.1


