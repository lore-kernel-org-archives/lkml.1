Return-Path: <linux-kernel-owner+w=401wt.eu-S2993095AbXDRThK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993095AbXDRThK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 15:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993094AbXDRThK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 15:37:10 -0400
Received: from homer.mvista.com ([63.81.120.155]:30213 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2993092AbXDRThI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 15:37:08 -0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
To: bzolnier@gmail.com, codermattie@gmail.com
Subject: [PATCH pata-2.6 fix queue] hpt366: fix kernel oops with HPT302N
Date: Wed, 18 Apr 2007 23:38:00 +0400
User-Agent: KMail/1.5
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200702032309.43867.sshtylyov@ru.mvista.com> <200702040004.24918.sshtylyov@ru.mvista.com> <200702162321.40813.sshtylyov@ru.mvista.com>
In-Reply-To: <200702162321.40813.sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200704182338.00604.sshtylyov@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The driver crashes the kernel on HPT302N chips due to the missing initializer
for 'hpt302n.settings' having been unfortunately overlooked so far. :-<

Much thanks to Mike Mattie for pin-pointing the reason of crash.

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
Posting at last -- please verify...

 drivers/ide/pci/hpt366.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/ide/pci/hpt366.c
===================================================================
--- linux-2.6.orig/drivers/ide/pci/hpt366.c
+++ linux-2.6/drivers/ide/pci/hpt366.c
@@ -1,10 +1,10 @@
 /*
- * linux/drivers/ide/pci/hpt366.c		Version 1.01	Dec 23, 2006
+ * linux/drivers/ide/pci/hpt366.c		Version 1.02	Apr 18, 2007
  *
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
  * Portions Copyright (C) 2003		Red Hat Inc
- * Portions Copyright (C) 2005-2006	MontaVista Software, Inc.
+ * Portions Copyright (C) 2005-2007	MontaVista Software, Inc.
  *
  * Thanks to HighPoint Technologies for their assistance, and hardware.
  * Special Thanks to Jon Burchmore in SanDiego for the deep pockets, his
@@ -494,6 +494,7 @@ static struct hpt_info hpt302n __devinit
 	.chip_type	= HPT302N,
 	.max_mode	= HPT302_ALLOW_ATA133_6 ? 4 : 3,
 	.dpll_clk	= 77,
+	.settings	= hpt37x_settings
 };
 
 static struct hpt_info hpt371n __devinitdata = {

