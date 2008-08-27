Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbYH0WDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbYH0WDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 18:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbYH0WDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 18:03:08 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:54829 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbYH0WDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 18:03:07 -0400
Date: Thu, 28 Aug 2008 01:02:12 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Karsten Keil <kkeil@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] mISDN/dsp_cmx.c: fix size checks
Message-ID: <20080827220212.GK11734@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The checks for ensuring that the array indices are inside the range
were flipped.

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
1743b2c1c483c8f1e5c6f706b8937136359f5aeb 
diff --git a/drivers/isdn/mISDN/dsp_cmx.c b/drivers/isdn/mISDN/dsp_cmx.c
index e92b1ba..c2f51cc 100644
--- a/drivers/isdn/mISDN/dsp_cmx.c
+++ b/drivers/isdn/mISDN/dsp_cmx.c
@@ -452,10 +452,10 @@ one_member:
 			if (finddsp->features.pcm_id == dsp->features.pcm_id) {
 				if (finddsp->pcm_slot_rx >= 0 &&
 				    finddsp->pcm_slot_rx < sizeof(freeslots))
-					freeslots[finddsp->pcm_slot_tx] = 0;
+					freeslots[finddsp->pcm_slot_rx] = 0;
 				if (finddsp->pcm_slot_tx >= 0 &&
 				    finddsp->pcm_slot_tx < sizeof(freeslots))
-					freeslots[finddsp->pcm_slot_rx] = 0;
+					freeslots[finddsp->pcm_slot_tx] = 0;
 			}
 		}
 		i = 0;

