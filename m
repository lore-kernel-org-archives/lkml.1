Return-Path: <linux-kernel-owner+w=401wt.eu-S1753768AbZI0KIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbZI0KIc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 06:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbZI0KIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 06:08:31 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:40571 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702AbZI0KIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 06:08:31 -0400
Date: Sun, 27 Sep 2009 12:08:32 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: minyard@acm.org, openipmi-developer@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/char/ipmi: Use KCS_IDLE_STATE
Message-ID: <Pine.LNX.4.64.0909271208010.7197@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

KCS_IDLE and KCS_IDLE state have the same value, but in this function the
constants ending in _STATE are compared to the state variable.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/char/ipmi/ipmi_kcs_sm.c     |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_kcs_sm.c b/drivers/char/ipmi/ipmi_kcs_sm.c
index 8070487..cf82fed 100644
--- a/drivers/char/ipmi/ipmi_kcs_sm.c
+++ b/drivers/char/ipmi/ipmi_kcs_sm.c
@@ -370,7 +370,7 @@ static enum si_sm_result kcs_event(struct si_sm_data *kcs, long time)
 			return SI_SM_IDLE;
 
 	case KCS_START_OP:
-		if (state != KCS_IDLE) {
+		if (state != KCS_IDLE_STATE) {
 			start_error_recovery(kcs,
 					     "State machine not idle at start");
 			break;
