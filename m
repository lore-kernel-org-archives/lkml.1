Return-Path: <linux-kernel-owner+w=401wt.eu-S1752742AbZLIJUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbZLIJUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:20:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbZLIJUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:20:16 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50187 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbZLIJUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:20:14 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] irq: handle irq0 special only on x86
Date: Wed,  9 Dec 2009 10:20:01 +0100
Message-Id: <1260350401-9858-1-git-send-email-u.kleine-koenig@pengutronix.de>
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

I just noticed this when digging in the irq handling.  At least for arm
this doesn't make sense.  Not sure if x86 is the only arch this test
is valid for, but probably it is.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 kernel/irq/spurious.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 22b0a6e..4996b66 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -199,8 +199,10 @@ try_misrouted_irq(unsigned int irq, struct irq_desc *desc,
 	if (irqfixup < 2)
 		return 0;
 
+#if defined(CONFIG_ARCH_X86)
 	if (!irq)
 		return 1;
+#endif
 
 	/*
 	 * Since we don't get the descriptor lock, "action" can
-- 
1.6.5.2

