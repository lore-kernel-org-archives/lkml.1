Return-Path: <linux-kernel-owner+w=401wt.eu-S936688AbXJSTuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936688AbXJSTuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 15:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935574AbXJSTuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 15:50:04 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:24613 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933103AbXJSTt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 15:49:59 -0400
Date: Fri, 19 Oct 2007 13:17:23 -0600
From: dougthompson@xmission.com
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 3/8] drivers-edac-add Cell XDR memory types
Message-ID: <471902c3.PlcyPNqneZ/IU4GK%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

This patch adds the definitions for the Rambus XDR memory type
used by the Cell processor. It's a pre-requisite for the followup
Cell EDAC patch.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC:     Alan Cox <alan@lxorguk.ukuu.org.uk
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
---

 drivers/edac/edac_core.h     |    2 ++
 drivers/edac/edac_mc_sysfs.c |    3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6.23/drivers/edac/edac_core.h
===================================================================
--- linux-2.6.23.orig/drivers/edac/edac_core.h
+++ linux-2.6.23/drivers/edac/edac_core.h
@@ -138,6 +138,7 @@ enum mem_type {
 	MEM_DDR2,		/* DDR2 RAM */
 	MEM_FB_DDR2,		/* fully buffered DDR2 */
 	MEM_RDDR2,		/* Registered DDR2 RAM */
+	MEM_XDR,		/* Rambus XDR */
 };
 
 #define MEM_FLAG_EMPTY		BIT(MEM_EMPTY)
@@ -154,6 +155,7 @@ enum mem_type {
 #define MEM_FLAG_DDR2           BIT(MEM_DDR2)
 #define MEM_FLAG_FB_DDR2        BIT(MEM_FB_DDR2)
 #define MEM_FLAG_RDDR2          BIT(MEM_RDDR2)
+#define MEM_FLAG_XDR            BIT(MEM_XDR)
 
 /* chipset Error Detection and Correction capabilities and mode */
 enum edac_type {
Index: linux-2.6.23/drivers/edac/edac_mc_sysfs.c
===================================================================
--- linux-2.6.23.orig/drivers/edac/edac_mc_sysfs.c
+++ linux-2.6.23/drivers/edac/edac_mc_sysfs.c
@@ -73,7 +73,8 @@ static const char *mem_types[] = {
 	[MEM_RMBS] = "RMBS",
 	[MEM_DDR2] = "Unbuffered-DDR2",
 	[MEM_FB_DDR2] = "FullyBuffered-DDR2",
-	[MEM_RDDR2] = "Registered-DDR2"
+	[MEM_RDDR2] = "Registered-DDR2",
+	[MEM_XDR] = "XDR"
 };
 
 static const char *dev_types[] = {
