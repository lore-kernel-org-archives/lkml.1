Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619Ab0BXXsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 18:48:24 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36868 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758553Ab0BXXsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 18:48:23 -0500
Date: Thu, 25 Feb 2010 10:48:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tony Lindgren <tony@atomide.com>, Russell King <rmk@arm.linux.org.uk>,
       Kukjin Kim <kgene.kim@samsung.com>,
       Adityapratap Sharma <aditya.ps@samsung.com>,
       Atul Dahiya <atul.dahiya@samsung.com>
Subject: linux-next: manual merge of the samsung tree with the arm tree
Message-Id: <20100225104819.6d117587.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

Today's linux-next merge of the samsung tree got a conflict in
arch/arm/mach-s5p6442/include/mach/debug-macro.S between commit
4e6d488af37980d224cbf298224db6173673f362 ("ARM: 5910/1: ARM: Add tmp
register for addruart and loadsp") from the arm tree and commit
5f7f6a4a0df9b43051d57fdb8ea96c083247a08f ("ARM: S5P6442: Add Samsung
S5P6442 CPU support") from the samsung tree.

This conflict is a bit strange since this is a new file, but git is a bit
too clever :-)

I fixed it up (see the change from the samsung tree below) and can carry
the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/arch/arm/mach-s5p6442/include/mach/debug-macro.S b/arch/arm/mach-s5p6442/include/mach/debug-macro.S
index 1aae691..441962c 100644
--- a/arch/arm/mach-s5p6442/include/mach/debug-macro.S
+++ b/arch/arm/mach-s5p6442/include/mach/debug-macro.S
@@ -15,7 +15,7 @@
 #include <mach/map.h>
 #include <plat/regs-serial.h>
 
-	.macro addruart, rx
+	.macro addruart, rx, tmp
 		mrc	p15, 0, \rx, c1, c0
 		tst	\rx, #1
 		ldreq	\rx, = S3C_PA_UART
