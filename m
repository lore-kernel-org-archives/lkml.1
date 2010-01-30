Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653Ab0A3P7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab0A3P7z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 10:59:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888Ab0A3P7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 10:59:54 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:53837 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab0A3P7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 10:59:54 -0500
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Jan 2010 10:59:54 EST
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, tglx@linutronix.de, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH -stable 2.6.32.7] clocksource: fix compilation if no GENERIC_TIME
Date: Sat, 30 Jan 2010 17:56:13 +0200
Message-Id: <1264866973-9474-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a9238ce3bb0fda6e760780b702c6cbd3793087d3 broke compilation on
platforms that do not implement GENERIC_TIME (e.g. iop32x):

  kernel/time/clocksource.c: In function 'clocksource_register':
  kernel/time/clocksource.c:556: error: implicit declaration of function 'clocksource_max_deferment'

Provide a dummy implementation of clocksource_max_deferment() for such
platforms.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 kernel/time/clocksource.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 5155dc3..7b3a9d0 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -502,6 +502,11 @@ static void clocksource_select(void)
 
 #else /* CONFIG_GENERIC_TIME */
 
+static inline u64 clocksource_max_deferment(struct clocksource *cs)
+{
+	return 0;
+}
+
 static inline void clocksource_select(void) { }
 
 #endif
-- 
1.5.6.5

