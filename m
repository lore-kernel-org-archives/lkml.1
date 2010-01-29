Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679Ab0A2EVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab0A2EVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 23:21:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756667Ab0A2EVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 23:21:10 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:34988 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756628Ab0A2EVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 23:21:09 -0500
From: John Stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>, richard@rsk.demon.co.uk,
       lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>
Subject: [PATCH] time: Cleanup xtime references in ntp.c
Date: Thu, 28 Jan 2010 20:20:44 -0800
Message-Id: <1264738844-21935-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ntp.c doesn't need to access timekeeping internals directly, so
change xtime references to use the get_seconds() timekeeping interface.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 kernel/time/ntp.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 4800f93..0470927 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -142,11 +142,11 @@ static void ntp_update_offset(long offset)
 	 * Select how the frequency is to be controlled
 	 * and in which mode (PLL or FLL).
 	 */
-	secs = xtime.tv_sec - time_reftime;
+	secs = get_seconds() - time_reftime;
 	if (unlikely(time_status & STA_FREQHOLD))
 		secs = 0;
 
-	time_reftime = xtime.tv_sec;
+	time_reftime = get_seconds();
 
 	offset64    = offset;
 	freq_adj    = (offset64 * secs) <<
@@ -368,7 +368,7 @@ static inline void process_adj_status(struct timex *txc, struct timespec *ts)
 	 * reference time to current time.
 	 */
 	if (!(time_status & STA_PLL) && (txc->status & STA_PLL))
-		time_reftime = xtime.tv_sec;
+		time_reftime = get_seconds();
 
 	/* only set allowed bits */
 	time_status &= STA_RONLY;
-- 
1.6.0.4

