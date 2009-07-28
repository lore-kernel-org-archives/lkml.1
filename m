Return-Path: <linux-kernel-owner+w=401wt.eu-S1754332AbZG1PHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbZG1PHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbZG1PG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:06:58 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:15655 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbZG1PGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:06:53 -0400
X-SpamScore: 7
X-BigFish: VPS7(zz990clzz1202hzzz32i203h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KNHZAU-03-5X5-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH 19/20] EDAC, AMD: decode FR MCEs
Date: Tue, 28 Jul 2009 17:06:19 +0200
Message-ID: <1248793580-29899-20-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
References: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 15:06:30.0769 (UTC) FILETIME=[FCFFF610:01CA0F94]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See Fam10h BKDG (31116, rev. 3.28), Table 101.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/edac_mce_amd.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
index 1c4468f..a78d16c 100644
--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -311,6 +311,15 @@ void amd_decode_nb_mce(int node_id, struct err_regs *regs, int handle_errors)
 }
 EXPORT_SYMBOL_GPL(amd_decode_nb_mce);
 
+static void amd_decode_fr_mce(u64 mc5_status)
+{
+	/* we have only one error signature so match all fields at once. */
+	if ((mc5_status & 0xffff) == 0x0f0f)
+		pr_emerg(" FR Error: CPU Watchdog timer expire.\n");
+	else
+		pr_warning("Corrupted FR MCE info?\n");
+}
+
 static inline void amd_decode_err_code(unsigned int ec)
 {
 	if (TLB_ERROR(ec)) {
@@ -391,6 +400,10 @@ void decode_mce(struct mce *m)
 		amd_decode_nb_mce(node, &regs, 1);
 		break;
 
+	case 5:
+		amd_decode_fr_mce(m->status);
+		break;
+
 	default:
 		break;
 	}
-- 
1.6.3.3


