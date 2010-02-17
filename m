Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934115Ab0BQIAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 03:00:49 -0500
Received: from mx2.zhaw.ch ([160.85.104.51]:50174 "EHLO mx2.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934078Ab0BQIAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 03:00:48 -0500
From: Tobias Klauser <tklauser@distanz.ch>
To: galak@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCH] cpm_uart: Use resource_size()
Date: Wed, 17 Feb 2010 09:00:36 +0100
Message-Id: <1266393636-6309-1-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 1.6.3.3
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.2.17.74822
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 BODY_SIZE_1100_1199 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, TO_NO_NAME 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NS '
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the resource_size function instead of manually calculating the
resource size. This reduces the chance of introducing off-by-one errors.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/serial/cpm_uart/cpm_uart_cpm2.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/cpm_uart/cpm_uart_cpm2.c b/drivers/serial/cpm_uart/cpm_uart_cpm2.c
index a9802e7..722eac1 100644
--- a/drivers/serial/cpm_uart/cpm_uart_cpm2.c
+++ b/drivers/serial/cpm_uart/cpm_uart_cpm2.c
@@ -61,7 +61,7 @@ void __iomem *cpm_uart_map_pram(struct uart_cpm_port *port,
 	void __iomem *pram;
 	unsigned long offset;
 	struct resource res;
-	unsigned long len;
+	resource_size_t len;
 
 	/* Don't remap parameter RAM if it has already been initialized
 	 * during console setup.
@@ -74,7 +74,7 @@ void __iomem *cpm_uart_map_pram(struct uart_cpm_port *port,
 	if (of_address_to_resource(np, 1, &res))
 		return NULL;
 
-	len = 1 + res.end - res.start;
+	len = resource_size(&res);
 	pram = ioremap(res.start, len);
 	if (!pram)
 		return NULL;
-- 
1.6.3.3

