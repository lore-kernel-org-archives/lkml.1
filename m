Return-Path: <linux-kernel-owner+w=401wt.eu-S1762836AbZAGWbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762836AbZAGWbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:31:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762596AbZAGWXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:23:45 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:40104 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762593AbZAGWXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:23:44 -0500
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KD4GUC-01-K3U-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 11/18] oprofile: simplify add_ibs_begin()
Date: Wed, 7 Jan 2009 23:17:28 +0100
Message-ID: <1231366655-17837-12-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
References: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 07 Jan 2009 22:22:59.0459 (UTC) FILETIME=[7F3B6D30:01C97116]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/buffer_sync.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index 22cdb51..7415d2e 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -333,7 +333,7 @@ static void add_ibs_begin(int cpu, int code, struct mm_struct *mm)
 
 	sample = op_cpu_buffer_read_entry(cpu);
 	if (!sample)
-		goto Error;
+		return;
 	rip = sample->eip;
 
 #ifdef __LP64__
@@ -372,15 +372,12 @@ static void add_ibs_begin(int cpu, int code, struct mm_struct *mm)
 	for (i = 0; i < count; i++) {
 		sample = op_cpu_buffer_read_entry(cpu);
 		if (!sample)
-			goto Error;
+			return;
 		add_event_entry(sample->eip);
 		add_event_entry(sample->event);
 	}
 
 	return;
-
-Error:
-	return;
 }
 
 #endif
-- 
1.6.0.1


