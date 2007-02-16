Return-Path: <linux-kernel-owner+w=401wt.eu-S932313AbXBPNhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313AbXBPNhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 08:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932314AbXBPNho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 08:37:44 -0500
Received: from smtp-105-friday.nerim.net ([62.4.16.105]:2521 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932313AbXBPNho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 08:37:44 -0500
Date: Fri, 16 Feb 2007 14:38:13 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Antonino Daplas <adaplas@pol.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] i810fb: Fix i810_check_params section mismatch
Message-Id: <20070216143813.e7de85ef.khali@linux-fr.org>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: drivers/video/i810/i810fb.o - Section mismatch: reference
to .init.data: from .text between 'i810_check_params' (at offset
0x1123) and 'encode_fix'

yres cannot be declared __devinitdata as it is used in
i810_check_params(), which isn't __devinit.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
This patch was already sent on December 17th, 2006.

 drivers/video/i810/i810_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.20-rc1.orig/drivers/video/i810/i810_main.c	2006-12-17 16:02:06.000000000 +0100
+++ linux-2.6.20-rc1/drivers/video/i810/i810_main.c	2006-12-17 16:04:01.000000000 +0100
@@ -142,7 +142,7 @@
 static int vsync1     __devinitdata;
 static int vsync2     __devinitdata;
 static int xres       __devinitdata;
-static int yres       __devinitdata;
+static int yres;
 static int vyres      __devinitdata;
 static int sync       __devinitdata;
 static int extvga     __devinitdata;


-- 
Jean Delvare
