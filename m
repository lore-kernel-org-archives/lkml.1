Return-Path: <linux-kernel-owner+w=401wt.eu-S1755040AbZLHIaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbZLHIaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 03:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbZLHIaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 03:30:15 -0500
Received: from straum.hexapodia.org ([64.81.70.185]:41014 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbZLHIaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 03:30:14 -0500
Date: Tue, 8 Dec 2009 00:30:21 -0800
From: Andy Isaacson <adi@hexapodia.org>
To: linux-kernel@vger.kernel.org
Cc: Robert Hancock <hancockrwd@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Richard Zidlicky <rz@linux-m68k.org>, netdev@vger.kernel.org
Subject: [PATCH 2/2] print DMI_BOARD_NAME as well as DMI_PRODUCT_NAME from __show_regs
Message-ID: <20091208083021.GB27174@hexapodia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1DC4F0.9050708@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock observes that DMI_BOARD_NAME is often more useful
than DMI_PRODUCT_NAME, especially on standalone motherboards.
So, print both.

Signed-off-by: Andy Isaacson <adi@hexapodia.org>
Cc: Robert Hancock <hancockrwd@gmail.com>
LKML-Reference: <4B1DC4F0.9050708@gmail.com>
---
 arch/x86/kernel/process.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index a93f319..520d9d1 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -93,18 +93,21 @@ void exit_thread(void)
 
 void show_regs_common(void)
 {
-	const char *board;
+	const char *board, *product;
 
-	board = dmi_get_system_info(DMI_PRODUCT_NAME);
+	board = dmi_get_system_info(DMI_BOARD_NAME);
 	if (!board)
 		board = "";
+	product = dmi_get_system_info(DMI_PRODUCT_NAME);
+	if (!product)
+		product = "";
 
 	printk("\n");
-	printk(KERN_INFO "Pid: %d, comm: %.20s %s %s %.*s %s\n",
+	printk(KERN_INFO "Pid: %d, comm: %.20s %s %s %.*s %s/%s\n",
 		current->pid, current->comm, print_tainted(),
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version, board);
+		init_utsname()->version, board, product);
 }
 
 void flush_thread(void)
-- 
1.6.5.3
