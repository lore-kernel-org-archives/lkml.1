Return-Path: <linux-kernel-owner+w=401wt.eu-S1752545Ab0AVTNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab0AVTNv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 14:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300Ab0AVTNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 14:13:50 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52892 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab0AVTNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 14:13:50 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-pcmcia@lists.infradead.org
Cc: linux-arm-kernel@lists.infradead.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] pcmcia/at91_cf: don't redefine SZ_2K
Date: Fri, 22 Jan 2010 20:13:27 +0100
Message-Id: <1264187607-14468-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <cd73a99e1001221050w398bd9epfd4fc79f91d36189@mail.gmail.com>
References: <cd73a99e1001221050w398bd9epfd4fc79f91d36189@mail.gmail.com>
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

This fixes:

	drivers/pcmcia/at91_cf.c:55:1: warning: "SZ_2K" redefined

Since

	c1191b0 ([ARM] Kirkwood: create a mapping for the Security Accelerator SRAM)

SZ_2K is defined in arch/arm/include/asm/sizes.h.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Andrew Victor <linux@maxim.org.za>
---
 drivers/pcmcia/at91_cf.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/pcmcia/at91_cf.c b/drivers/pcmcia/at91_cf.c
index e1dcced..5d22807 100644
--- a/drivers/pcmcia/at91_cf.c
+++ b/drivers/pcmcia/at91_cf.c
@@ -52,8 +52,6 @@ struct at91_cf_socket {
 	unsigned long		phys_baseaddr;
 };
 
-#define	SZ_2K			(2 * SZ_1K)
-
 static inline int at91_cf_present(struct at91_cf_socket *cf)
 {
 	return !gpio_get_value(cf->board->det_pin);
-- 
1.6.6

