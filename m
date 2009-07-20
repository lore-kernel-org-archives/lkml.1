Return-Path: <linux-kernel-owner+w=401wt.eu-S1752482AbZGTQN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482AbZGTQN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbZGTQN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:13:27 -0400
Received: from wa4ehsobe003.messaging.microsoft.com ([216.32.181.13]:38813
	"EHLO WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750856AbZGTQNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:13:25 -0400
X-SpamScore: 7
X-BigFish: VPS7(zz990clzz1202hzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KN3921-04-7E2-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 14/14] amd64_edac: decode FR MCEs
Date: Mon, 20 Jul 2009 18:13:05 +0200
Message-ID: <1248106385-27514-15-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
References: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 20 Jul 2009 16:13:16.0218 (UTC) FILETIME=[FD20F9A0:01CA0954]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See Fam10h BKDG (31116, rev. 3.28), Table 101.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 175f95e..a035122 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2406,6 +2406,15 @@ wrong_ls_mce:
 	pr_warning("Corrupted LS MCE info?\n");
 }
 
+static void amd64_decode_fr_mce(u64 mc5_status)
+{
+	/* we have only one error signature so match all fields at once. */
+	if ((mc5_status & 0xffff) == 0x0f0f)
+		pr_emerg(" FR Error: CPU Watchdog timer expire.\n");
+	else
+		pr_warning("Corrupted FR MCE info?\n");
+}
+
 void amd64_decode_nb_mce(struct mem_ctl_info *mci, struct err_regs *regs,
 			 int handle_errors, int ecc)
 {
@@ -2524,6 +2533,10 @@ void decode_mce(struct mce *m)
 		amd64_decode_nb_mce(mci_lookup[0], &regs, 1, ecc);
 		break;
 
+	case 5:
+		amd64_decode_fr_mce(m->status);
+		break;
+
 	default:
 		break;
 	}
-- 
1.6.3.3


