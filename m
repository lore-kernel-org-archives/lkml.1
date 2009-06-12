Return-Path: <linux-kernel-owner+w=401wt.eu-S1762914AbZFLNOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762914AbZFLNOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756728AbZFLNOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:14:25 -0400
Received: from sg2ehsobe002.messaging.microsoft.com ([207.46.51.76]:7281 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758410AbZFLNOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:14:24 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KL4MQM-03-HW6-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 13/23] x86/oprofile: remove unused macros for AMD virtualization profiling
Date: Fri, 12 Jun 2009 14:35:30 +0200
Message-ID: <1244810140-20595-14-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
References: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 12 Jun 2009 12:59:07.0279 (UTC) FILETIME=[921F71F0:01C9EB5D]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of the macros has no effect. The oprofilefs has to be extended
first to support these features.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index c6181c2..aaa7ffa 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -31,8 +31,6 @@
 #define CTRL_CLEAR_HI(x) (x &= 0xfffffcf0)
 #define CTRL_SET_EVENT_LOW(val, e) (val |= (e & 0xff))
 #define CTRL_SET_EVENT_HIGH(val, e) (val |= ((e >> 8) & 0xf))
-#define CTRL_SET_HOST_ONLY(val, h) (val |= ((h & 1) << 9))
-#define CTRL_SET_GUEST_ONLY(val, h) (val |= ((h & 1) << 8))
 
 static unsigned long reset_value[NUM_COUNTERS];
 
@@ -125,9 +123,6 @@ static void op_amd_setup_ctrs(struct op_msrs const * const msrs)
 			CTRL_SET_UM(low, counter_config[i].unit_mask);
 			CTRL_SET_EVENT_LOW(low, counter_config[i].event);
 			CTRL_SET_EVENT_HIGH(high, counter_config[i].event);
-			CTRL_SET_HOST_ONLY(high, 0);
-			CTRL_SET_GUEST_ONLY(high, 0);
-
 			wrmsr(msrs->controls[i].addr, low, high);
 		} else {
 			reset_value[i] = 0;
-- 
1.6.3.1


