Return-Path: <linux-kernel-owner+w=401wt.eu-S932355Ab0A2Je2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab0A2Je2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:34:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932348Ab0A2JeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:34:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:36814 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932346Ab0A2JeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:34:21 -0500
Date: Fri, 29 Jan 2010 09:33:49 GMT
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de
In-Reply-To: <1264738844-21935-1-git-send-email-johnstul@us.ibm.com>
References: <1264738844-21935-1-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] ntp: Cleanup xtime references in ntp.c
Message-ID: <tip-7e1b584774c6168ca5b27c340fbeff8f67651e4f@git.kernel.org>
Git-Commit-ID: 7e1b584774c6168ca5b27c340fbeff8f67651e4f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Jan 2010 09:33:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7e1b584774c6168ca5b27c340fbeff8f67651e4f
Gitweb:     http://git.kernel.org/tip/7e1b584774c6168ca5b27c340fbeff8f67651e4f
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Thu, 28 Jan 2010 20:20:44 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 29 Jan 2010 10:15:19 +0100

ntp: Cleanup xtime references in ntp.c

ntp.c doesn't need to access timekeeping internals directly, so change
xtime references to use the get_seconds() timekeeping interface.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: richard@rsk.demon.co.uk
LKML-Reference: <1264738844-21935-1-git-send-email-johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/ntp.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 74b1b37..7c0f180 100644
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
