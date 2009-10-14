Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbZJNC2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbZJNC2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 22:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbZJNC2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 22:28:45 -0400
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:46949 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751071AbZJNC2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 22:28:44 -0400
X-Greylist: delayed 3608 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Oct 2009 22:28:44 EDT
Date: Wed, 14 Oct 2009 02:19:22 +0100
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: gregkh@suse.de, stable@kernel.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.31, 2.6.32] Staging: rt2860sta: prevent a panic when disabling when associated
Message-ID: <50AF4AEA98%linux@youmustbejoking.demon.co.uk>
Mail-Followup-To: gregkh@suse.de, devel@driverdev.osuosl.org, 
 linux-kernel@vger.kernel.org, Darren Salt <linux@youmustbejoking.demon.co.uk>
User-Agent: Messenger-Pro/2.60.0.3101 (Qt/4.5.2) (Linux-x86_64)
X-NuLabour-Date: Wed, 9084 Dec 1984 02:19:22 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 192.168.0.5
X-SA-Exim-Mail-From: linux@youmustbejoking.demon.co.uk
X-SA-Exim-Scanned: No (on pentagram.youmustbejoking.demon.co.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a panic which is triggered when the hardware "disappears" from
beneath the driver, i.e. when wireless is toggled off via Fn-F2 on various
EeePC models.

Ref. bug report http://bugzilla.kernel.org/show_bug.cgi?id=13390
          panic http://bugzilla.kernel.org/attachment.cgi?id=21928

Signed-off-by: Darren Salt <linux@youmustbejoking.demon.co.uk>

--- a/drivers/staging/rt2860/common/cmm_data_2860.c	2009-09-09 23:13:59.000000000 +0100
+++ b/drivers/staging/rt2860/common/cmm_data_2860.c	2009-10-13 02:07:32.136049782 +0100
@@ -363,6 +363,8 @@ int RtmpPCIMgmtKickOut(
 	ULONG			SwIdx = pAd->MgmtRing.TxCpuIdx;
 
 	pTxD  = (PTXD_STRUC) pAd->MgmtRing.Cell[SwIdx].AllocVa;
+	if (!pTxD)
+		return 0;
 
 	pAd->MgmtRing.Cell[SwIdx].pNdisPacket = pPacket;
 	pAd->MgmtRing.Cell[SwIdx].pNextNdisPacket = NULL;

-- 
| Darren Salt            | linux at youmustbejoking | nr. Ashington, | Doon
| using Debian GNU/Linux | or ds    ,demon,co,uk    | Northumberland | Army
| + Buy local produce. Try to walk or cycle. TRANSPORT CAUSES GLOBAL WARMING.

Please do not shoot the pianist. He is doing his best.
