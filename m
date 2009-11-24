Return-Path: <linux-kernel-owner+w=401wt.eu-S933304AbZKXPJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304AbZKXPJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933279AbZKXPJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:09:29 -0500
Received: from relay1.sgi.com ([192.48.179.29]:57707 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933277AbZKXPHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:07:52 -0500
Message-Id: <20091124150758.004423000@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 24 Nov 2009 09:06:21 -0600
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 24/29] GRU - Update GRU structures to match latest hardware spec
References: <20091124150557.082648000@sgi.com>
Content-Disposition: inline; filename=uv_gru_new_handle_defines
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Add a few new  definitions for chipset MMR field names.
This matches rev 0.7 of the hardware spec.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 drivers/misc/sgi-gru/gru_instructions.h |    5 ++++-
 drivers/misc/sgi-gru/gruhandles.h       |   11 +++++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

Index: linux/drivers/misc/sgi-gru/gru_instructions.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gru_instructions.h	2009-11-20 09:32:34.000000000 -0600
+++ linux/drivers/misc/sgi-gru/gru_instructions.h	2009-11-20 09:32:37.000000000 -0600
@@ -265,6 +265,7 @@ struct gru_instruction {
 #define CBE_CAUSE_PROTOCOL_STATE_DATA_ERROR	(1 << 16)
 #define CBE_CAUSE_RA_RESPONSE_DATA_ERROR	(1 << 17)
 #define CBE_CAUSE_HA_RESPONSE_DATA_ERROR	(1 << 18)
+#define CBE_CAUSE_FORCED_ERROR			(1 << 19)
 
 /* CBE cbrexecstatus bits */
 #define CBR_EXS_ABORT_OCC_BIT			0
@@ -273,13 +274,15 @@ struct gru_instruction {
 #define CBR_EXS_QUEUED_BIT			3
 #define CBR_EXS_TLB_INVAL_BIT			4
 #define CBR_EXS_EXCEPTION_BIT			5
+#define CBR_EXS_CB_INT_PENDING_BIT		6
 
 #define CBR_EXS_ABORT_OCC			(1 << CBR_EXS_ABORT_OCC_BIT)
 #define CBR_EXS_INT_OCC				(1 << CBR_EXS_INT_OCC_BIT)
 #define CBR_EXS_PENDING				(1 << CBR_EXS_PENDING_BIT)
 #define CBR_EXS_QUEUED				(1 << CBR_EXS_QUEUED_BIT)
-#define CBR_TLB_INVAL				(1 << CBR_EXS_TLB_INVAL_BIT)
+#define CBR_EXS_TLB_INVAL			(1 << CBR_EXS_TLB_INVAL_BIT)
 #define CBR_EXS_EXCEPTION			(1 << CBR_EXS_EXCEPTION_BIT)
+#define CBR_EXS_CB_INT_PENDING			(1 << CBR_EXS_CB_INT_PENDING_BIT)
 
 /*
  * Exceptions are retried for the following cases. If any OTHER bits are set
Index: linux/drivers/misc/sgi-gru/gruhandles.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gruhandles.h	2009-11-20 09:32:35.000000000 -0600
+++ linux/drivers/misc/sgi-gru/gruhandles.h	2009-11-20 09:32:37.000000000 -0600
@@ -252,6 +252,17 @@ enum gru_tgh_state {
 	TGHSTATE_RESTART_CTX,
 };
 
+enum gru_tgh_cause {
+	TGHCAUSE_RR_ECC,
+	TGHCAUSE_TLB_ECC,
+	TGHCAUSE_LRU_ECC,
+	TGHCAUSE_PS_ECC,
+	TGHCAUSE_MUL_ERR,
+	TGHCAUSE_DATA_ERR,
+	TGHCAUSE_SW_FORCE
+};
+
+
 /*
  * TFH - TLB Global Handle
  * 	Used for TLB dropins into the GRU TLB.

