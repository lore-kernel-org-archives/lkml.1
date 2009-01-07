Return-Path: <linux-kernel-owner+w=401wt.eu-S1761023AbZAGW1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761023AbZAGW1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762249AbZAGWXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:23:21 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:21285 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762183AbZAGWXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:23:18 -0500
X-BigFish: VPS1(zzzzzzz32i62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KD4GU9-02-XTE-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 08/18] oprofile: simplify sync_buffer()
Date: Wed, 7 Jan 2009 23:17:25 +0100
Message-ID: <1231366655-17837-9-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
References: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 07 Jan 2009 22:22:59.0366 (UTC) FILETIME=[7F2D3C60:01C97116]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make code more readable. No functional changes.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/buffer_sync.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index 0abe29e..22cdb51 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -579,12 +579,20 @@ void sync_buffer(int cpu)
 				add_user_ctx_switch(new, cookie);
 				break;
 			}
-		} else if (state >= sb_bt_start &&
-			   !add_sample(mm, s, in_kernel)) {
-			if (state == sb_bt_start) {
-				state = sb_bt_ignore;
-				atomic_inc(&oprofile_stats.bt_lost_no_mapping);
-			}
+			continue;
+		}
+
+		if (state < sb_bt_start)
+			/* ignore sample */
+			continue;
+
+		if (add_sample(mm, s, in_kernel))
+			continue;
+
+		/* ignore backtraces if failed to add a sample */
+		if (state == sb_bt_start) {
+			state = sb_bt_ignore;
+			atomic_inc(&oprofile_stats.bt_lost_no_mapping);
 		}
 	}
 	release_mm(mm);
-- 
1.6.0.1


