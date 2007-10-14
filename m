Return-Path: <linux-kernel-owner+w=401wt.eu-S1762253AbXJNRvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762253AbXJNRvx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 13:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759845AbXJNRur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 13:50:47 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35252 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760353AbXJNRup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 13:50:45 -0400
Date: Sun, 14 Oct 2007 19:51:15 +0200
From: Adrian Bunk <bunk@kernel.org>
To: yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] iwl4965-base.c: fix off-by-one errors
Message-ID: <20071014175115.GL4211@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes two off-by-one errors resulting in array overflows 
spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/net/wireless/iwlwifi/iwl4965-base.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6/drivers/net/wireless/iwlwifi/iwl4965-base.c.old	2007-10-14 16:52:21.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl4965-base.c	2007-10-14 16:59:37.000000000 +0200
@@ -4489,23 +4489,23 @@ static u8 ratio2dB[100] = {
 	39, 39, 39, 39, 39, 40, 40, 40, 40, 40  /* 90 - 99 */
 };
 
 /* Calculates a relative dB value from a ratio of linear
  *   (i.e. not dB) signal levels.
  * Conversion assumes that levels are voltages (20*log), not powers (10*log). */
 int iwl_calc_db_from_ratio(int sig_ratio)
 {
-	/* Anything above 1000:1 just report as 60 dB */
-	if (sig_ratio > 1000)
+	/* 1000:1 or higher just report as 60 dB */
+	if (sig_ratio >= 1000)
 		return 60;
 
-	/* Above 100:1, divide by 10 and use table,
+	/* 100:1 or higher, divide by 10 and use table,
 	 *   add 20 dB to make up for divide by 10 */
-	if (sig_ratio > 100)
+	if (sig_ratio >= 100)
 		return (20 + (int)ratio2dB[sig_ratio/10]);
 
 	/* We shouldn't see this */
 	if (sig_ratio < 1)
 		return 0;
 
 	/* Use table for ratios 1:1 - 99:1 */
 	return (int)ratio2dB[sig_ratio];

