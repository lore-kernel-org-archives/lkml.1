Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbZGORso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbZGORso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 13:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827AbZGORso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 13:48:44 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:53743 "EHLO
	master.douglaskthompson" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755227AbZGORsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 13:48:43 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Jul 2009 13:48:43 EDT
Date: Wed, 15 Jul 2009 11:38:49 -0600
From: dougthompson@xmission.com
To: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 3/4] edac: x83 fix mchbar high register addr
Message-ID: <4a5e1429.OX+oQC2MDfnTvrEI%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lu Zhihe <tombowfly@gmail.com>

Intel X38  MCHBAR is a 64bits register, base from 0x48, 
so its higher base is 0x4C.

Signed-off-by: Lu Zhihe <tombowfly@gmail.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
---
diff -uprN linux-2.6.31-rc2.orig/drivers/edac/x38_edac.c linux-2.6.31-rc2/drivers/edac/x38_edac.c
--- linux-2.6.31-rc2.orig/drivers/edac/x38_edac.c	2009-07-08 22:36:26.000000000 +0000
+++ linux-2.6.31-rc2/drivers/edac/x38_edac.c	2009-07-10 22:23:42.000000000 +0000
@@ -30,7 +30,7 @@
 /* Intel X38 register addresses - device 0 function 0 - DRAM Controller */
 
 #define X38_MCHBAR_LOW	0x48	/* MCH Memory Mapped Register BAR */
-#define X38_MCHBAR_HIGH	0x4b
+#define X38_MCHBAR_HIGH	0x4c
 #define X38_MCHBAR_MASK	0xfffffc000ULL	/* bits 35:14 */
 #define X38_MMR_WINDOW_SIZE	16384
