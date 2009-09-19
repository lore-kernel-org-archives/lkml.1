Return-Path: <linux-kernel-owner+w=401wt.eu-S1753450AbZISVjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbZISVjH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:39:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbZISVi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:38:57 -0400
Received: from kroah.org ([198.145.64.141]:50931 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223AbZISVi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:38:56 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 14/79] cyclades: sleep instead busy-wait
Date: Sat, 19 Sep 2009 14:36:19 -0700
Message-Id: <1253396244-7885-14-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Avoid long busy loops (5 ms) which may be replaced by sleeps.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/cyclades.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 3884ea4..b6d40ad 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -389,7 +389,7 @@ static unsigned detect_isa_irq(void __iomem *address)
 
 	irqs = probe_irq_on();
 	/* Wait ... */
-	udelay(5000L);
+	msleep(5);
 
 	/* Enable the Tx interrupts on the CD1400 */
 	local_irq_save(flags);
@@ -402,7 +402,7 @@ static unsigned detect_isa_irq(void __iomem *address)
 	local_irq_restore(flags);
 
 	/* Wait ... */
-	udelay(5000L);
+	msleep(5);
 
 	/* Check which interrupt is in use */
 	irq = probe_irq_off(irqs);
-- 
1.6.4.2

