Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbXKDTdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbXKDTdI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 14:33:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbXKDTc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 14:32:57 -0500
Received: from anyanka.rfc1149.net ([81.56.47.149]:60764 "EHLO
	mail2.rfc1149.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbXKDTc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 14:32:56 -0500
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Nov 2007 14:32:56 EST
From: Samuel Tardieu <sam@rfc1149.net>
Date: Sun, 4 Nov 2007 20:20:23 +0100
Subject: [PATCH] watchdog: Stop looking for device as soon as one is found
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org
Message-Id: <20071104192459.E5CC2C405B@mail2.rfc1149.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If no address is given for the W83697HF/HG watchdog IO port, stop looping
through possible locations when a watchdog device has been found.

Signed-off-by: Samuel Tardieu <sam@rfc1149.net>
---
 drivers/watchdog/w83697hf_wdt.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/w83697hf_wdt.c b/drivers/watchdog/w83697hf_wdt.c
index c622a0e..6ea125e 100644
--- a/drivers/watchdog/w83697hf_wdt.c
+++ b/drivers/watchdog/w83697hf_wdt.c
@@ -382,8 +382,10 @@ wdt_init(void)
 		/* we will autodetect the W83697HF/HG watchdog */
 		for (i = 0; ((!found) && (w83697hf_ioports[i] != 0)); i++) {
 			wdt_io = w83697hf_ioports[i];
-			if (!w83697hf_check_wdt())
+			if (!w83697hf_check_wdt()) {
 				found++;
+				break;
+			}
 		}
 	} else {
 		if (!w83697hf_check_wdt())
-- 
1.5.3.5

