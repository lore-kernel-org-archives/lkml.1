Return-Path: <linux-kernel-owner+w=401wt.eu-S1756294AbZJPRSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294AbZJPRSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756243AbZJPRSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:18:49 -0400
Received: from kroah.org ([198.145.64.141]:48683 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755948AbZJPRSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:46 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:12:09 2009
Message-Id: <20091016171208.894637208@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [42/46] Staging: rt2860sta: prevent a panic when disabling when associated
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=staging-rt2860sta-prevent-a-panic-when-disabling-when-associated.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Darren Salt <linux@youmustbejoking.demon.co.uk>

commit 0af49167b1e5ba154e90d2c454bf4624ee47df80 upstream.

This fixes a panic which is triggered when the hardware "disappears" from
beneath the driver, i.e. when wireless is toggled off via Fn-F2 on various
EeePC models.

Ref. bug report http://bugzilla.kernel.org/show_bug.cgi?id=13390
          panic http://bugzilla.kernel.org/attachment.cgi?id=21928

Signed-off-by: Darren Salt <linux@youmustbejoking.demon.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rt2860/common/cmm_data_2860.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/staging/rt2860/common/cmm_data_2860.c
+++ b/drivers/staging/rt2860/common/cmm_data_2860.c
@@ -363,6 +363,8 @@ int RtmpPCIMgmtKickOut(
 	ULONG			SwIdx = pAd->MgmtRing.TxCpuIdx;
 
 	pTxD  = (PTXD_STRUC) pAd->MgmtRing.Cell[SwIdx].AllocVa;
+	if (!pTxD)
+		return 0;
 
 	pAd->MgmtRing.Cell[SwIdx].pNdisPacket = pPacket;
 	pAd->MgmtRing.Cell[SwIdx].pNextNdisPacket = NULL;


