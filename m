Return-Path: <linux-kernel-owner+w=401wt.eu-S1758668AbZBKV2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbZBKV2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 16:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757962AbZBKV05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 16:26:57 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:43480 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757929AbZBKV04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 16:26:56 -0500
Date: Wed, 11 Feb 2009 13:18:22 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de
Subject: [PATCH 5/9] staging/rt2860: fix printk format warnings
Message-Id: <20090211131822.4ba1a6bc.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.49934299.02A6:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix staging/rt28x0 printk format warnings:

linux-next-20090209/drivers/staging/rt2860/common/spectrum.c:1599: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
linux-next-20090209/drivers/staging/rt2860/rt_linux.c:857: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'

linux-next-20090209/drivers/staging/rt2870/common/spectrum.c:1598: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
linux-next-20090209/drivers/staging/rt2870/rt_linux.c:898: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/rt2860/common/spectrum.c |    2 +-
 drivers/staging/rt2860/rt_linux.c        |    2 +-
 drivers/staging/rt2870/common/spectrum.c |    2 +-
 drivers/staging/rt2870/rt_linux.c        |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- mmotm-2009-0210-1635.orig/drivers/staging/rt2860/common/spectrum.c
+++ mmotm-2009-0210-1635/drivers/staging/rt2860/common/spectrum.c
@@ -1596,7 +1596,7 @@ static VOID PeerMeasureReportAction(
 
 	if ((pMeasureReportInfo = kmalloc(sizeof(MEASURE_RPI_REPORT), GFP_ATOMIC)) == NULL)
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s unable to alloc memory for measure report buffer (size=%d).\n", __func__, sizeof(MEASURE_RPI_REPORT)));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s unable to alloc memory for measure report buffer (size=%zu).\n", __func__, sizeof(MEASURE_RPI_REPORT)));
 		return;
 	}
 
--- mmotm-2009-0210-1635.orig/drivers/staging/rt2860/rt_linux.c
+++ mmotm-2009-0210-1635/drivers/staging/rt2860/rt_linux.c
@@ -854,7 +854,7 @@ void send_monitor_packets(
 
     if (pRxBlk->DataSize + sizeof(wlan_ng_prism2_header) > RX_BUFFER_AGGRESIZE)
     {
-        DBGPRINT(RT_DEBUG_ERROR, ("%s : Size is too large! (%d)\n", __func__, pRxBlk->DataSize + sizeof(wlan_ng_prism2_header)));
+        DBGPRINT(RT_DEBUG_ERROR, ("%s : Size is too large! (%zu)\n", __func__, pRxBlk->DataSize + sizeof(wlan_ng_prism2_header)));
 		goto err_free_sk_buff;
     }
 
--- mmotm-2009-0210-1635.orig/drivers/staging/rt2870/common/spectrum.c
+++ mmotm-2009-0210-1635/drivers/staging/rt2870/common/spectrum.c
@@ -1595,7 +1595,7 @@ static VOID PeerMeasureReportAction(
 
 	if ((pMeasureReportInfo = kmalloc(sizeof(MEASURE_RPI_REPORT), GFP_ATOMIC)) == NULL)
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s unable to alloc memory for measure report buffer (size=%d).\n", __func__, sizeof(MEASURE_RPI_REPORT)));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s unable to alloc memory for measure report buffer (size=%zu).\n", __func__, sizeof(MEASURE_RPI_REPORT)));
 		return;
 	}
 
--- mmotm-2009-0210-1635.orig/drivers/staging/rt2870/rt_linux.c
+++ mmotm-2009-0210-1635/drivers/staging/rt2870/rt_linux.c
@@ -895,7 +895,7 @@ void send_monitor_packets(
 
     if (pRxBlk->DataSize + sizeof(wlan_ng_prism2_header) > RX_BUFFER_AGGRESIZE)
     {
-        DBGPRINT(RT_DEBUG_ERROR, ("%s : Size is too large! (%d)\n", __func__, pRxBlk->DataSize + sizeof(wlan_ng_prism2_header)));
+        DBGPRINT(RT_DEBUG_ERROR, ("%s : Size is too large! (%zu)\n", __func__, pRxBlk->DataSize + sizeof(wlan_ng_prism2_header)));
 		goto err_free_sk_buff;
     }
 
