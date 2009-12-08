Return-Path: <linux-kernel-owner+w=401wt.eu-S1753586AbZLHKVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbZLHKVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 05:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753542AbZLHKVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 05:21:25 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36095 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbZLHKVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 05:21:24 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH] ARM: Convert BUG() to use unreachable()
Date: Tue,  8 Dec 2009 10:55:38 +0100
Message-Id: <1260266138-17684-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new unreachable() macro instead of for(;;);

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: David Daney <ddaney@caviumnetworks.com>
---
 arch/arm/kernel/traps.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 3f361a7..25b50c4 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -681,7 +681,7 @@ void __attribute__((noreturn)) __bug(const char *file, int line)
 	*(int *)0 = 0;
 
 	/* Avoid "noreturn function does return" */
-	for (;;);
+	unreachable();
 }
 EXPORT_SYMBOL(__bug);
 
-- 
1.6.5.2

