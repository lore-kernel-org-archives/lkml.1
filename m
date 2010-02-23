Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab0BWPk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 10:40:28 -0500
Received: from ernst.netinsight.se ([194.16.221.21]:13441 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752544Ab0BWPk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 10:40:27 -0500
Date: Tue, 23 Feb 2010 16:40:19 +0100
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: linux-kernel@vger.kernel.org
Cc: wim@iguana.be, seth.heasley@intel.com
Subject: [PATCH] iTCO_wdt: Don't stop on shutdown with nowayout
Message-ID: <20100223164019.60a6de1a@marrow.netinsight.se>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the watchdog is turned off when the system shuts down or the
module is unloaded. If nowayout has been selected, this makes no sense
and fails to restart the system if it hangs during reboot, so make it
conditional.

Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
---
We have a system which has such a hang, and therefore want the watchdog
to be on until the bitter end.

 drivers/watchdog/iTCO_wdt.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 4bdb7f1..927df26 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -839,7 +839,8 @@ static int __devexit iTCO_wdt_remove(struct platform_device *dev)
 
 static void iTCO_wdt_shutdown(struct platform_device *dev)
 {
-	iTCO_wdt_stop();
+	if (!nowayout)
+		iTCO_wdt_stop();
 }
 
 #define iTCO_wdt_suspend NULL
-- 
1.6.0.4

