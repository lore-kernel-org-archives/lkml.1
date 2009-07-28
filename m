Return-Path: <linux-kernel-owner+w=401wt.eu-S1755599AbZG1WYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbZG1WYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 18:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755296AbZG1WYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 18:24:42 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:34503 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005AbZG1WYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 18:24:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=l85yM7K33cAv0QRYucoqJvXptaHNflXOBr4iLsXf0j97L9J5kmnf2ER1ZX3zZTGm/T
         ir0oxAgQWhRXk1vQ55CD6kwRx8yJkQaE0DGL8cIzYGcUnwcXVbdGyO8/EVrFBCQqWRPV
         Vj9pwEvY9MC1VmvRyhnz1aG/cQX9w48VbFmgI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] cyclades: allow overriding ISA defaults also when the driver is built-in
Date: Wed, 29 Jul 2009 00:23:47 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4-next-20090728-04869-gdae50fe-dirty; KDE/4.2.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907290023.48870.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] cyclades: allow overriding ISA defaults also when the driver is built-in

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/char/cyclades.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

Index: b/drivers/char/cyclades.c
===================================================================
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -158,13 +158,11 @@ static unsigned int cy_isa_addresses[] =
 
 #define NR_ISA_ADDRS ARRAY_SIZE(cy_isa_addresses)
 
-#ifdef MODULE
 static long maddr[NR_CARDS];
 static int irq[NR_CARDS];
 
 module_param_array(maddr, long, NULL, 0);
 module_param_array(irq, int, NULL, 0);
-#endif
 
 #endif				/* CONFIG_ISA */
 
@@ -3319,13 +3317,10 @@ static int __init cy_detect_isa(void)
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
@@ -3335,7 +3330,6 @@ static int __init cy_detect_isa(void)
 		if (!maddr[i])
 			break;
 	}
-#endif
 
 	/* scan the address table probing for Cyclom-Y/ISA boards */
 	for (i = 0; i < NR_ISA_ADDRS; i++) {
@@ -3356,11 +3350,10 @@ static int __init cy_detect_isa(void)
 			iounmap(cy_isa_address);
 			continue;
 		}
-#ifdef MODULE
+
 		if (isparam && irq[i])
 			cy_isa_irq = irq[i];
 		else
-#endif
 			/* find out the board's irq by probing */
 			cy_isa_irq = detect_isa_irq(cy_isa_address);
 		if (cy_isa_irq == 0) {
