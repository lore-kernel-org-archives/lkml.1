Return-Path: <linux-kernel-owner+w=401wt.eu-S1760333AbZFRHmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760333AbZFRHmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 03:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758412AbZFRHmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 03:42:10 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:47388 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492AbZFRHmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 03:42:07 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 07/13] Char: cyclades, sleep instead busy-wait
Date: Thu, 18 Jun 2009 09:41:42 +0200
Message-Id: <1245310908-27691-7-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1245310908-27691-1-git-send-email-jirislaby@gmail.com>
References: <1245310908-27691-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid long busy loops (5 ms) which may be replaced by sleeps.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/cyclades.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 1510506..1fca273 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -388,7 +388,7 @@ static unsigned detect_isa_irq(void __iomem *address)
 
 	irqs = probe_irq_on();
 	/* Wait ... */
-	udelay(5000L);
+	msleep(5);
 
 	/* Enable the Tx interrupts on the CD1400 */
 	local_irq_save(flags);
@@ -401,7 +401,7 @@ static unsigned detect_isa_irq(void __iomem *address)
 	local_irq_restore(flags);
 
 	/* Wait ... */
-	udelay(5000L);
+	msleep(5);
 
 	/* Check which interrupt is in use */
 	irq = probe_irq_off(irqs);
-- 
1.6.3.2

