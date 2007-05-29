Return-Path: <linux-kernel-owner+w=401wt.eu-S1759915AbXE2PMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915AbXE2PMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 11:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbXE2PMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 11:12:30 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:2504 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbXE2PMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 11:12:30 -0400
Date: Tue, 29 May 2007 16:12:22 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jgarzik@pobox.com>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] defxx: Fix the handling of ioremap() failures
Message-ID: <Pine.LNX.4.64N.0705291508300.14456@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 If ioremap_nocache() is unfortunate enough to fail, the error code is not 
set correctly leading to a false success from dfx_register().  This change 
fixes the problem.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---

 Please apply.

  Maciej

patch-mips-2.6.21-20070502-defxx-ioremap-0
diff -up --recursive --new-file linux-mips-2.6.21-20070502.macro/drivers/net/defxx.c linux-mips-2.6.21-20070502/drivers/net/defxx.c
--- linux-mips-2.6.21-20070502.macro/drivers/net/defxx.c	2007-02-21 05:56:25.000000000 +0000
+++ linux-mips-2.6.21-20070502/drivers/net/defxx.c	2007-05-16 21:26:43.000000000 +0000
@@ -566,6 +566,7 @@ static int __devinit dfx_register(struct
 		bp->base.mem = ioremap_nocache(bar_start, bar_len);
 		if (!bp->base.mem) {
 			printk(KERN_ERR "%s: Cannot map MMIO\n", print_name);
+			err = -ENOMEM;
 			goto err_out_region;
 		}
 	} else {
