Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab0CBXvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:51:36 -0500
Received: from kroah.org ([198.145.64.141]:51585 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835Ab0CBXgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:36:54 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/36] serial: cyclades: allow overriding ISA defaults also when the driver is built-in
Date: Tue,  2 Mar 2010 15:36:18 -0800
Message-Id: <1267573003-782-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230956.GC32287@kroah.com>
References: <20100302230956.GC32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/cyclades.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 274e965..e026f24 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -158,13 +158,11 @@ static unsigned int cy_isa_addresses[] = {
 
 #define NR_ISA_ADDRS ARRAY_SIZE(cy_isa_addresses)
 
-#ifdef MODULE
 static long maddr[NR_CARDS];
 static int irq[NR_CARDS];
 
 module_param_array(maddr, long, NULL, 0);
 module_param_array(irq, int, NULL, 0);
-#endif
 
 #endif				/* CONFIG_ISA */
 
@@ -3310,13 +3308,10 @@ static int __init cy_detect_isa(void)
 	unsigned short cy_isa_irq, nboard;
 	void __iomem *cy_isa_address;
 	unsigned short i, j, cy_isa_nchan;
-#ifdef MODULE
 	int isparam = 0;
-#endif
 
 	nboard = 0;
 
-#ifdef MODULE
 	/* Check for module parameters */
 	for (i = 0; i < NR_CARDS; i++) {
 		if (maddr[i] || i) {
@@ -3326,7 +3321,6 @@ static int __init cy_detect_isa(void)
 		if (!maddr[i])
 			break;
 	}
-#endif
 
 	/* scan the address table probing for Cyclom-Y/ISA boards */
 	for (i = 0; i < NR_ISA_ADDRS; i++) {
@@ -3347,11 +3341,10 @@ static int __init cy_detect_isa(void)
 			iounmap(cy_isa_address);
 			continue;
 		}
-#ifdef MODULE
+
 		if (isparam && i < NR_CARDS && irq[i])
 			cy_isa_irq = irq[i];
 		else
-#endif
 			/* find out the board's irq by probing */
 			cy_isa_irq = detect_isa_irq(cy_isa_address);
 		if (cy_isa_irq == 0) {
-- 
1.7.0.1

