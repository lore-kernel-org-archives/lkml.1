Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbZKMLx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbZKMLx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 06:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbZKMLxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 06:53:24 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:47936 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912AbZKMLxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 06:53:23 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 13 Nov 2009 12:53:08 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] ieee1394: Use hweight32
To: Akinobu Mita <akinobu.mita@gmail.com>
cc: linux1394-devel@lists.sourceforge.net,
       Ben Collins <ben.collins@ubuntu.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1258095851-13301-1-git-send-email-akinobu.mita@gmail.com>
Message-ID: <tkrat.057b967e5b8e4c33@s5r6.in-berlin.de>
References: <1258095851-13301-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>

Use hweight32 instead of counting for each bit

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de> (add required include)
---

You forgot to include <linux/bitops.h>, probably also in some of the
other hweight patches which you sent today or yesterday.

 drivers/ieee1394/ohci1394.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

Index: linux-2.6.31.4/drivers/ieee1394/ohci1394.c
===================================================================
--- linux-2.6.31.4.orig/drivers/ieee1394/ohci1394.c
+++ linux-2.6.31.4/drivers/ieee1394/ohci1394.c
@@ -82,6 +82,7 @@
  *
  */
 
+#include <linux/bitops.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/slab.h>
@@ -434,7 +435,6 @@ static void initialize_dma_trm_ctx(struc
 /* Count the number of available iso contexts */
 static int get_nb_iso_ctx(struct ti_ohci *ohci, int reg)
 {
-	int i,ctx=0;
 	u32 tmp;
 
 	reg_write(ohci, reg, 0xffffffff);
@@ -443,11 +443,7 @@ static int get_nb_iso_ctx(struct ti_ohci
 	DBGMSG("Iso contexts reg: %08x implemented: %08x", reg, tmp);
 
 	/* Count the number of contexts */
-	for (i=0; i<32; i++) {
-	    	if (tmp & 1) ctx++;
-		tmp >>= 1;
-	}
-	return ctx;
+	return hweight32(tmp);
 }
 
 /* Global initialization */

-- 
Stefan Richter
-=====-==--= =-== -==-=
http://arcgraph.de/sr/

