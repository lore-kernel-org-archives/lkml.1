Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbZCKWv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbZCKWv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 18:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbZCKWvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 18:51:50 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:36785 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbZCKWvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 18:51:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=AuPxZ7PkJ0Yn243CKOZnl4Kmwli5Dv4xG93zEDfFodr9xUsLSkP96KA8JZZ7jThZjs
         RkIJWkQ99vYSnM/fCKMZQL/GGWUskHwM0xabBL7ONrzBShXf+0HVfPMFAMNBbTis3+KI
         kxiFac1IwxuY3OZ/gsbu62zETvnU+LbP5ANtU=
Date: Wed, 11 Mar 2009 22:51:41 +0000
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH 2.6.29-rc7-git4-gkh] drivers/staging/rt2860: Fix remaining
	build warnings
Message-ID: <20090311225141.GA17034@EeeFedora10>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Einon <mark.einon@gmail.com>

Fixed remaining four build warnings in drivers/staging/rt2860/:
 
drivers/staging/rt2860/common/mlme.c:900: warning: format ‘%d’ expects type ‘int’, but argument 2 has type ‘ULONG’
drivers/staging/rt2860/common/rtmp_init.c:2049: warning: ‘Value’ may be used uninitialized in this function
drivers/staging/rt2860/sta_ioctl.c:361: warning: ‘return’ with a value, in function returning void
drivers/staging/rt2860/sta_ioctl.c:2468: warning: ‘return’ with a value, in function returning void
 
Signed-off-by: Mark Einon <mark.einon@gmail.com>
 
---
 drivers/staging/rt2860/common/mlme.c      |    2 +-
 drivers/staging/rt2860/common/rtmp_init.c |    2 +-
 drivers/staging/rt2860/sta_ioctl.c        |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)
--- a/drivers/staging/rt2860/common/mlme.c
+++ b/drivers/staging/rt2860/common/mlme.c
@@ -897,7 +897,7 @@ VOID MlmePeriodicExec(
 		{
 			if ((pAd->StaCfg.bRadio == TRUE) && (pAd->SameRxByteCount < 700))
 			{
-				DBGPRINT(RT_DEBUG_TRACE, ("--->  SameRxByteCount = %d !!!!!!!!!!!!!!! \n", pAd->SameRxByteCount));
+				DBGPRINT(RT_DEBUG_TRACE, ("--->  SameRxByteCount = %lu !!!!!!!!!!!!!!! \n", pAd->SameRxByteCount));
 				pAd->SameRxByteCount = 700;
 				AsicResetBBP(pAd);
 			}

--- a/drivers/staging/rt2860/common/rtmp_init.c
+++ b/drivers/staging/rt2860/common/rtmp_init.c
@@ -2046,7 +2046,7 @@ VOID NICRestoreBBPValue(
 	IN PRTMP_ADAPTER pAd)
 {
 	UCHAR		index;
-	UCHAR		Value;
+	UCHAR		Value = 0;
 	ULONG		Data;
 
 	DBGPRINT(RT_DEBUG_TRACE, ("--->  NICRestoreBBPValue !!!!!!!!!!!!!!!!!!!!!!!  \n"));

--- a/drivers/staging/rt2860/sta_ioctl.c
+++ b/drivers/staging/rt2860/sta_ioctl.c
@@ -358,7 +358,7 @@ VOID RTMPAddKey(
 		if (pAd->StaCfg.bRadio == FALSE)
 		{
 			RTMP_SET_PSFLAG(pAd, fRTMP_PS_CAN_GO_SLEEP);
-			return (NDIS_STATUS_SUCCESS);
+			return;
 		}
 		DBGPRINT(RT_DEBUG_TRACE,("RTMPWPAAddKeyProc1==>\n"));
 		RTMPPCIeLinkCtrlValueRestore(pAd, RESTORE_HALT);
@@ -2465,7 +2465,7 @@ void fnSetCipherKey(
 		if (pAdapter->StaCfg.bRadio == FALSE)
 		{
 			RTMP_SET_PSFLAG(pAdapter, fRTMP_PS_CAN_GO_SLEEP);
-			return (NDIS_STATUS_SUCCESS);
+			return;
 		}
 		DBGPRINT(RT_DEBUG_TRACE,("RTMPWPAAddKeyProc1==>\n"));
 		RTMPPCIeLinkCtrlValueRestore(pAdapter, RESTORE_HALT);



