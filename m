Return-Path: <linux-kernel-owner+w=401wt.eu-S1756238AbXIZJRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbXIZJRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 05:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbXIZJRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 05:17:25 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:39991 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753482AbXIZJRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 05:17:24 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Silent drivers/char/hpet.c build warnings on i386
Date: Wed, 26 Sep 2007 12:15:33 +0300
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: tglx@linutronix.de, torvalds@linux-foundation.org, johnstul@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200709261215.35596.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following patch silents;

...
drivers/char/hpet.c:72: warning: 'clocksource_hpet' defined but not used
drivers/char/hpet.c:81: warning: 'hpet_clocksource' defined but not used
...

build warnings on i386, they appeared after commit 3b2b64fd311c92f2137eb7cee7025794cd854057

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

 drivers/char/hpet.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 7ecffc9..b86d84a 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -62,6 +62,8 @@
 
 static u32 hpet_nhpet, hpet_max_freq = HPET_USER_FREQ;
 
+/* This clocksource driver currently only works on ia64 */
+#ifdef CONFIG_IA64
 static void __iomem *hpet_mctr;
 
 static cycle_t read_hpet(void)
@@ -79,6 +81,7 @@ static struct clocksource clocksource_hpet = {
         .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
 };
 static struct clocksource *hpet_clocksource;
+#endif
 
 /* A lock for concurrent access by app and isr hpet activity. */
 static DEFINE_SPINLOCK(hpet_lock);


Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
