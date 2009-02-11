Return-Path: <linux-kernel-owner+w=401wt.eu-S1759003AbZBKV3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759003AbZBKV3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 16:29:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758102AbZBKV1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 16:27:05 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:23035 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758088AbZBKV1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 16:27:04 -0500
Date: Wed, 11 Feb 2009 13:22:56 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de
Subject: [PATCH 9/9] staging/sxg: fix napi interface build
Message-Id: <20090211132256.6622afb5.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.499342A1.0273:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix staging/sxg napi interface calls:

drivers/staging/sxg/sxg.c:1271: error: implicit declaration of function 'netif_rx_schedule_prep'
linux-next-20090209/drivers/staging/sxg/sxg.c:1272: error: implicit declaration of function '__netif_rx_schedule'
drivers/staging/sxg/sxg.c:1325: error: implicit declaration of function 'netif_rx_complete'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/sxg/sxg.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- mmotm-2009-0210-1635.orig/drivers/staging/sxg/sxg.c
+++ mmotm-2009-0210-1635/drivers/staging/sxg/sxg.c
@@ -1268,8 +1268,8 @@ static void sxg_interrupt(struct adapter
 {
 	WRITE_REG(adapter->UcodeRegs[0].Icr, SXG_ICR(0, SXG_ICR_MASK), TRUE);
 
-	if (netif_rx_schedule_prep(&adapter->napi)) {
-		__netif_rx_schedule(&adapter->napi);
+	if (napi_schedule_prep(&adapter->napi)) {
+		__napi_schedule(&adapter->napi);
 	}
 }
 
@@ -1322,7 +1322,7 @@ static int sxg_poll(struct napi_struct *
 	sxg_handle_interrupt(adapter, &work_done, budget);
 
 	if (work_done < budget) {
-		netif_rx_complete(napi);
+		napi_complete(napi);
 		WRITE_REG(adapter->UcodeRegs[0].Isr, 0, TRUE);
 	}
 	return work_done;
