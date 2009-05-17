Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbZEQVR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbZEQVR4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 17:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbZEQVRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 17:17:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:62540 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481AbZEQVRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 17:17:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] asm-generic: make get_rtc_time overridable
Date: Sun, 17 May 2009 21:17:45 +0000
Message-Id: <1242595065-24210-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.0.4
X-Provags-ID: V01U2FsdGVkX1/F2ZYVmpkYALcce985rdcXMoLmKtYNJ/ynU0j
 ZIE6SlsbBCDRP7bBEEn07ipuWEKbM/DMMI5TMqBFdihoGpIMgg
 pEa9ZFMFk/Wv/2bdeXkZg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evidently, set_rtc_time is supposed to be overridable
by architectures that define their own version, but
unfortunately, get_rtc_ss would in that case still
use the generic version.

This makes get_rtc_ss call the real set_rtc_time
to let architectures define their own version.
The change should fix the "Extended RTC operation"
on Alpha, which uses the incorrect get_rtc_ss
call. It also allows PowerPC to use the asm-generic/rtc.h
file in the future.

Cc: Richard Henderson <rth@twiddle.net>
Cc: linux-alpha@vger.kernel.org
Cc: Tom Rini <trini@mvista.com>
Cc: rtc-linux@googlegroups.com
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/rtc.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/rtc.h b/include/asm-generic/rtc.h
index 763e3b0..fa86f24 100644
--- a/include/asm-generic/rtc.h
+++ b/include/asm-generic/rtc.h
@@ -202,7 +202,7 @@ static inline unsigned int get_rtc_ss(void)
 {
 	struct rtc_time h;
 
-	__get_rtc_time(&h);
+	get_rtc_time(&h);
 	return h.tm_sec;
 }
 
-- 
1.6.0.4

