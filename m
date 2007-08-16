Return-Path: <linux-kernel-owner+w=401wt.eu-S1760678AbXHPNU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760678AbXHPNU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 09:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761958AbXHPNTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 09:19:50 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1271 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761938AbXHPNTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 09:19:49 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>, Andrew Morton <akpm@osdl.org>,
       Andy Whitcroft <apw@shadowen.org>, Andy Whitcroft <apw@shadowen.org>,
       Paul Mundt <lethal@linux-sh.org>, linuxsh-dev@lists.sourceforge.net
Subject: [PATCH 3/6] sh: remove extraneous ; on scif_sercon_putc wait loop
References: <exportbomb.1187270320@pinky>
InReply-To: <exportbomb.1187270320@pinky>
Message-ID: <1495a7af981296bd422ef293e96ad167@pinky>
Date: Thu, 16 Aug 2007 14:18:56 +0100
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


It seems we have gained an extraneous trailing ';' on one of the
wait loops in scif_sercon_putc().  Although this is completely
benign as the apparent payload is also the empty statement, it
invites error in the future.  Clean it up now.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: linuxsh-dev@lists.sourceforge.net
---
 arch/sh/kernel/early_printk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
diff --git a/arch/sh/kernel/early_printk.c b/arch/sh/kernel/early_printk.c
index 9833493..80b637c 100644
--- a/arch/sh/kernel/early_printk.c
+++ b/arch/sh/kernel/early_printk.c
@@ -76,7 +76,7 @@ static void scif_sercon_putc(int c)
 	sci_in(&scif_port, SCxSR);
 	sci_out(&scif_port, SCxSR, 0xf3 & ~(0x20 | 0x40));
 
-	while ((sci_in(&scif_port, SCxSR) & 0x40) == 0);
+	while ((sci_in(&scif_port, SCxSR) & 0x40) == 0)
 		;
 
 	if (c == '\n')
