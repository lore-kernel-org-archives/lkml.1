Return-Path: <linux-kernel-owner+w=401wt.eu-S1752504AbZKHIXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbZKHIXH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 03:23:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbZKHIXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 03:23:06 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:48218 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbZKHIXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 03:23:05 -0500
Date: Sun, 8 Nov 2009 09:23:07 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Corey Thomas <coreythomas@charter.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/net/wireless: correct check on CCS_START_NETWORK
Message-ID: <Pine.LNX.4.64.0911080922360.2465@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

CCS_START_NETWORK is declared in drivers/net/wireless/rayctl.h with the
comment Values for cmd.  status is previously compared to
CCS_COMMAND_COMPLETE, which is declared in the same file with the comment
Values for buffer_status.  Finally, it is possible at this point that cmd
is CCS_START_NETWORK, because it is compared to that value in an enclosing
switch that has CCS_START_NETWORK as one of two case labels around this code.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/wireless/ray_cs.c       |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 1c88c2e..5ee9d2a 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -2074,7 +2074,7 @@ static irqreturn_t ray_interrupt(int irq, void *dev_id)
 				del_timer(&local->timer);
 				local->timer.expires = jiffies + HZ * 5;
 				local->timer.data = (long)local;
-				if (status == CCS_START_NETWORK) {
+				if (cmd == CCS_START_NETWORK) {
 					DEBUG(0,
 					      "ray_cs interrupt network \"%s\" start failed\n",
 					      local->sparm.b4.a_current_ess_id);
