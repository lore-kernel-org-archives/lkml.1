Return-Path: <linux-kernel-owner+w=401wt.eu-S1764245AbXGUL36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764245AbXGUL36 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 07:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761744AbXGUL3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 07:29:50 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:39466 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761228AbXGUL3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 07:29:49 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: dougthompson@xmission.com
Subject: [PATCH] Remove unusued edac_reset_delay_period function
Date: Sat, 21 Jul 2007 14:28:42 +0300
User-Agent: KMail/1.9.7
Cc: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200707211428.45973.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

Following patch removes unused [1] edac_reset_delay_period function to silent

drivers/edac/edac_mc.c:334: warning: 'edac_reset_delay_period' defined but not used

compile warning.

[1] 
caglar@zangetsu linux-2.6 $ grep edac_reset_delay_period * -r
drivers/edac/edac_mc.c: * edac_reset_delay_period
drivers/edac/edac_mc.c:static void edac_reset_delay_period(struct mem_ctl_info *mci, unsigned long value)

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

 drivers/edac/edac_mc.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 4471be3..c36a19a 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -327,23 +327,6 @@ static void edac_mc_workq_teardown(struct mem_ctl_info *mci)
 	}
 }
 
-/*
- * edac_reset_delay_period
- */
-static void edac_reset_delay_period(struct mem_ctl_info *mci, unsigned long value)
-{
-	/* cancel the current workq request */
-	edac_mc_workq_teardown(mci);
-
-	/* lock the list of devices for the new setup */
-	mutex_lock(&mem_ctls_mutex);
-
-	/* restart the workq request, with new delay value */
-	edac_mc_workq_setup(mci, value);
-
-	mutex_unlock(&mem_ctls_mutex);
-}
-
 /* Return 0 on success, 1 on failure.
  * Before calling this function, caller must
  * assign a unique value to mci->mc_idx.

Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
