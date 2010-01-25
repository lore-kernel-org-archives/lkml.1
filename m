Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777Ab0AYTWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab0AYTWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 14:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723Ab0AYTWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 14:22:39 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:58865 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab0AYTWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 14:22:38 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zzab9bh936eMzz1202hzzz32i6bh87h63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KWTHT0-01-1ES-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH] oprofile/x86: fix crash when profiling more than 28 events
Date: Mon, 25 Jan 2010 19:26:44 +0100
Message-ID: <1264444004-4769-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.6
X-OriginalArrivalTime: 25 Jan 2010 19:22:24.0209 (UTC) FILETIME=[B921BC10:01CA9DF3]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

With multiplexing enabled oprofile crashs when profiling more than 28
events. This patch fixes this.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index cb88b1a..76d4f56 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -222,7 +222,7 @@ static void nmi_cpu_switch(void *dummy)
 
 	/* move to next set */
 	si += model->num_counters;
-	if ((si > model->num_virt_counters) || (counter_config[si].count == 0))
+	if ((si >= model->num_virt_counters) || (counter_config[si].count == 0))
 		per_cpu(switch_index, cpu) = 0;
 	else
 		per_cpu(switch_index, cpu) = si;
-- 
1.6.6


