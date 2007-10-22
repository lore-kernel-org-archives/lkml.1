Return-Path: <linux-kernel-owner+w=401wt.eu-S1753608AbXJVOxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbXJVOxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 10:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbXJVOxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 10:53:10 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:57091 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbXJVOxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 10:53:08 -0400
Date: Mon, 22 Oct 2007 23:54:58 +0900 (JST)
Message-Id: <20071022.235458.111209400.anemo@mba.ocn.ne.jp>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, akpm@linux-foundation.org
Subject: [PATCH] clocksource: Make CLOCKSOURCE_MASK bullet-proof
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 107787a..07b4215 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -103,7 +103,7 @@ struct clocksource {
 #define CLOCK_SOURCE_VALID_FOR_HRES		0x20
 
 /* simplify initialization of mask field */
-#define CLOCKSOURCE_MASK(bits) (cycle_t)(bits<64 ? ((1ULL<<bits)-1) : -1)
+#define CLOCKSOURCE_MASK(bits) (cycle_t)((bits) < 64 ? ((1ULL<<(bits))-1) : -1)
 
 /**
  * clocksource_khz2mult - calculates mult from khz and shift

