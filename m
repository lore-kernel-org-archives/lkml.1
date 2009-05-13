Return-Path: <linux-kernel-owner+w=401wt.eu-S1760851AbZEMSiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760851AbZEMSiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 14:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758764AbZEMSh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 14:37:58 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:64981 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759278AbZEMSh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 14:37:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=uFTq+ESSymur3Nd52KkEJ4mwWeYz9WiKIkcFXRQcfwy/T+teNOzirQTjUSC+NHkUI3
         wVdv7e73eumu0oG9OIubSk8JPDtlIK6G54nqvDQ5S2haC3RtnF7SVFIuJc5C9Njk5XPV
         JNoMYw2pV+xLV4SCwToNqPzjuftFfQvXZlNjw=
Message-ID: <4A0B1382.6040501@gmail.com>
Date: Wed, 13 May 2009 20:37:54 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] staging: off by one in AsicSendCommandToMcu() and NDIS_STATUS
 NICLoadFirmware()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a postfix increment i/Index is incremented beyond 100/1000 so the
message will be displayed too soon.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
This could occur almost never.

 drivers/staging/rt2860/common/mlme.c      |    2 +-
 drivers/staging/rt2860/common/rtmp_init.c |    2 +-
 drivers/staging/rt2870/common/mlme.c      |    2 +-
 drivers/staging/rt2870/common/rtmp_init.c |    2 +-
 drivers/staging/rt3070/common/mlme.c      |    2 +-
 drivers/staging/rt3070/common/rtmp_init.c |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rt2860/common/mlme.c b/drivers/staging/rt2860/common/mlme.c
index c00f9ab..b76eecc 100644
--- a/drivers/staging/rt2860/common/mlme.c
+++ b/drivers/staging/rt2860/common/mlme.c
@@ -7611,7 +7611,7 @@ BOOLEAN AsicSendCommandToMcu(
 		RTMPusecDelay(2);
 	} while(i++ < 100);
 
-	if (i >= 100)
+	if (i > 100)
 	{
 #ifdef RALINK_ATE
 		if (pAd->ate.bFWLoading == TRUE)
diff --git a/drivers/staging/rt2860/common/rtmp_init.c b/drivers/staging/rt2860/common/rtmp_init.c
index 8a00cee..6321352 100644
--- a/drivers/staging/rt2860/common/rtmp_init.c
+++ b/drivers/staging/rt2860/common/rtmp_init.c
@@ -2867,7 +2867,7 @@ NDIS_STATUS NICLoadFirmware(
 		RTMPusecDelay(1000);
 	} while (Index++ < 1000);
 
-    if (Index >= 1000)
+    if (Index > 1000)
 	{
 		Status = NDIS_STATUS_FAILURE;
 		DBGPRINT(RT_DEBUG_ERROR, ("NICLoadFirmware: MCU is not ready\n\n\n"));
diff --git a/drivers/staging/rt2870/common/mlme.c b/drivers/staging/rt2870/common/mlme.c
index 8a82cee..8598c6e 100644
--- a/drivers/staging/rt2870/common/mlme.c
+++ b/drivers/staging/rt2870/common/mlme.c
@@ -7575,7 +7575,7 @@ BOOLEAN AsicSendCommandToMcu(
 		RTMPusecDelay(2);
 	} while(i++ < 100);
 
-	if (i >= 100)
+	if (i > 100)
 	{
 		{
 		DBGPRINT_ERR(("H2M_MAILBOX still hold by MCU. command fail\n"));
diff --git a/drivers/staging/rt2870/common/rtmp_init.c b/drivers/staging/rt2870/common/rtmp_init.c
index 099b6a8..2940ca3 100644
--- a/drivers/staging/rt2870/common/rtmp_init.c
+++ b/drivers/staging/rt2870/common/rtmp_init.c
@@ -3016,7 +3016,7 @@ NDIS_STATUS NICLoadFirmware(
 		RTMPusecDelay(1000);
 	} while (Index++ < 1000);
 
-    if (Index >= 1000)
+    if (Index > 1000)
 	{
 		Status = NDIS_STATUS_FAILURE;
 		DBGPRINT(RT_DEBUG_ERROR, ("NICLoadFirmware: MCU is not ready\n\n\n"));
diff --git a/drivers/staging/rt3070/common/mlme.c b/drivers/staging/rt3070/common/mlme.c
index 0ffbfa3..3e697cd 100644
--- a/drivers/staging/rt3070/common/mlme.c
+++ b/drivers/staging/rt3070/common/mlme.c
@@ -7959,7 +7959,7 @@ BOOLEAN AsicSendCommandToMcu(
 		RTMPusecDelay(2);
 	} while(i++ < 100);
 
-	if (i >= 100)
+	if (i > 100)
 	{
 		{
 		DBGPRINT_ERR(("H2M_MAILBOX still hold by MCU. command fail\n"));
diff --git a/drivers/staging/rt3070/common/rtmp_init.c b/drivers/staging/rt3070/common/rtmp_init.c
index 4503f6c..8791b7b 100644
--- a/drivers/staging/rt3070/common/rtmp_init.c
+++ b/drivers/staging/rt3070/common/rtmp_init.c
@@ -3181,7 +3181,7 @@ NDIS_STATUS NICLoadFirmware(
 		RTMPusecDelay(1000);
 	} while (Index++ < 1000);
 
-    if (Index >= 1000)
+    if (Index > 1000)
 	{
 		Status = NDIS_STATUS_FAILURE;
 		DBGPRINT(RT_DEBUG_ERROR, ("NICLoadFirmware: MCU is not ready\n\n\n"));
