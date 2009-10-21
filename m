Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbZJUUob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbZJUUob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 16:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbZJUUo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 16:44:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:47755 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbZJUUo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 16:44:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=dKRxsxxtXBdNMwved762xre88zluUKh3UH/RwIQFGwrE+UMXJje1cu1gXraeRvNQMt
         hYsRlBdGSCg29hn7aT3ZGFdCnkv4Hz2H/LTugdvsMYlWqiv+crdSSwleV/W88MVyaQXG
         io37iV7/69RRJ71aSYLTZ1N++1A12mLXeu2nI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 21 Oct 2009 22:44:12 +0200
Message-Id: <20091021204412.4593.80397.sendpatchset@localhost.localdomain>
In-Reply-To: <20091021204344.4593.99070.sendpatchset@localhost.localdomain>
References: <20091021204344.4593.99070.sendpatchset@localhost.localdomain>
Subject: [PATCH 04/12] Staging: rt28x0: remove private RTPRIV_IOCTL_GSITESURVEY ioctl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt28x0: remove private RTPRIV_IOCTL_GSITESURVEY ioctl

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/common/cmm_info.c |   57 -------------------------------
 drivers/staging/rt2860/rtmp.h            |   12 ------
 drivers/staging/rt2860/sta_ioctl.c       |    4 --
 3 files changed, 1 insertion(+), 72 deletions(-)

Index: b/drivers/staging/rt2860/common/cmm_info.c
===================================================================
--- a/drivers/staging/rt2860/common/cmm_info.c
+++ b/drivers/staging/rt2860/common/cmm_info.c
@@ -1970,63 +1970,6 @@ VOID	RTMPCommSiteSurveyData(
 	return;
 }
 
-VOID RTMPIoctlGetSiteSurvey(
-	IN	PRTMP_ADAPTER	pAdapter,
-	IN	struct iwreq	*wrq)
-{
-	PSTRING		msg;
-	INT		i=0;
-	INT			WaitCnt;
-	INT		Status=0;
-    INT         max_len = LINE_LEN;
-	PBSS_ENTRY	pBss;
-
-
-	os_alloc_mem(NULL, (PUCHAR *)&msg, sizeof(CHAR)*((MAX_LEN_OF_BSS_TABLE)*max_len));
-
-	if (msg == NULL)
-	{
-		DBGPRINT(RT_DEBUG_TRACE, ("RTMPIoctlGetSiteSurvey - msg memory alloc fail.\n"));
-		return;
-	}
-
-	memset(msg, 0 ,(MAX_LEN_OF_BSS_TABLE)*max_len );
-	sprintf(msg,"%s","\n");
-	sprintf(msg+strlen(msg),"%-4s%-33s%-20s%-23s%-9s%-7s%-7s%-3s\n",
-	    "Ch", "SSID", "BSSID", "Security", "Siganl(%)", "W-Mode", " ExtCH"," NT");
-
-
-
-	WaitCnt = 0;
-	pAdapter->StaCfg.bScanReqIsFromWebUI = TRUE;
-	while ((ScanRunning(pAdapter) == TRUE) && (WaitCnt++ < 200))
-		OS_WAIT(500);
-
-	for(i=0; i<pAdapter->ScanTab.BssNr ;i++)
-	{
-		pBss = &pAdapter->ScanTab.BssEntry[i];
-
-		if( pBss->Channel==0)
-			break;
-
-		if((strlen(msg)+max_len ) >= IW_SCAN_MAX_DATA)
-			break;
-
-
-		RTMPCommSiteSurveyData(msg, pBss);
-
-
-	}
-
-	pAdapter->StaCfg.bScanReqIsFromWebUI = FALSE;
-	wrq->u.data.length = strlen(msg);
-	Status = copy_to_user(wrq->u.data.pointer, msg, wrq->u.data.length);
-
-	DBGPRINT(RT_DEBUG_TRACE, ("RTMPIoctlGetSiteSurvey - wrq->u.data.length = %d\n", wrq->u.data.length));
-	os_free_mem(NULL, (PUCHAR)msg);
-}
-
-
 #define	MAC_LINE_LEN	(14+4+4+10+10+10+6+6)	// Addr+aid+psm+datatime+rxbyte+txbyte+current tx rate+last tx rate
 VOID RTMPIoctlGetMacTable(
 	IN PRTMP_ADAPTER pAd,
Index: b/drivers/staging/rt2860/rtmp.h
===================================================================
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -4991,18 +4991,6 @@ PNDIS_PACKET RTMPDeFragmentDataFrame(
 	IN	PRTMP_ADAPTER	pAd,
 	IN	RX_BLK			*pRxBlk);
 
-////////////////////////////////////////
-
-VOID RTMPIoctlGetSiteSurvey(
-	IN	PRTMP_ADAPTER	pAdapter,
-	IN	struct iwreq	*wrq);
-
-
-
-
-
-
-
 enum {
 	DIDmsg_lnxind_wlansniffrm		= 0x00000044,
 	DIDmsg_lnxind_wlansniffrm_hosttime	= 0x00010044,
Index: b/drivers/staging/rt2860/sta_ioctl.c
===================================================================
--- a/drivers/staging/rt2860/sta_ioctl.c
+++ b/drivers/staging/rt2860/sta_ioctl.c
@@ -2979,6 +2979,7 @@ INT rt28xx_sta_ioctl(
 		case RT_PRIV_IOCTL:
 		case RT_PRIV_IOCTL_EXT:
 		case RTPRIV_IOCTL_SET:
+		case RTPRIV_IOCTL_GSITESURVEY:
 			Status = -EOPNOTSUPP;
 			break;
 		case SIOCGIWPRIV:
@@ -2991,9 +2992,6 @@ INT rt28xx_sta_ioctl(
 					Status = -EFAULT;
 			}
 			break;
-		case RTPRIV_IOCTL_GSITESURVEY:
-			RTMPIoctlGetSiteSurvey(pAd, wrq);
-		    break;
         case SIOCETHTOOL:
                 break;
 		default:
