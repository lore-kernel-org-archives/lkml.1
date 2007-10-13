Return-Path: <linux-kernel-owner+w=401wt.eu-S932914AbXJMTBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914AbXJMTBB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 15:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756944AbXJMTAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 15:00:54 -0400
Received: from mail.arklinux.osuosl.org ([140.211.166.26]:34479 "EHLO
	mail.arklinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbXJMTAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 15:00:53 -0400
From: Bernhard Rosenkraenzer <bero@arklinux.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] 2.6.23-mm1 gdth doesn't compile with CONFIG_ISA && !CONFIG_EISA
Date: Sat, 13 Oct 2007 20:56:04 +0200
User-Agent: KMail/1.9.7
Cc: akpm@osdl.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710132056.05009.bero@arklinux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

gdth_irq_tab is defined only in #ifdef CONFIG_EISA, but used in 
gdth_init_isa()

Signed-off-by: Bernhard Rosenkraenzer <bero@arklinux.org>
--- linux-2.6.23/drivers/scsi/gdth.c.ark	2007-10-13 20:51:32.000000000 +0200
+++ linux-2.6.23/drivers/scsi/gdth.c	2007-10-13 20:52:05.000000000 +0200
@@ -288,7 +288,7 @@ static struct timer_list gdth_timer;
 #ifdef CONFIG_ISA
 static unchar   gdth_drq_tab[4] = {5,6,7,7};            /* DRQ table */
 #endif
-#ifdef CONFIG_EISA
+#if defined(CONFIG_EISA) || defined(CONFIG_ISA)
 static unchar   gdth_irq_tab[6] = {0,10,11,12,14,0};    /* IRQ table */
 #endif
 static unchar   gdth_polling;                           /* polling if TRUE */
