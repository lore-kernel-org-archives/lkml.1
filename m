Return-Path: <linux-kernel-owner+w=401wt.eu-S933963AbZHWN36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933963AbZHWN36 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933960AbZHWN34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:29:56 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:58451 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933937AbZHWN3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:29:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=YIZKIANJVwkDTP0cNU9OXqoCOLlgm03WbjOO9zAQqUAR9b2HCWH6C2QMgMZOzMzbOi
         y5uIyjh0HP85Ib/LZsTJK2iLpuQ8fuffGtEHh401nzH/j4/yg4lFwSNOpelP05/M3y1S
         unJffRlGQwMvj+g3kJvEJ/8L50aUBCxXsdS8k=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:30:24 +0200
Message-Id: <20090823133024.17784.30169.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 15/33] Staging: rt28x0: fix BPP_R66 register handling
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt28x0: fix BPP_R66 register handling

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/common/cmm_data.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: b/drivers/staging/rt2860/common/cmm_data.c
===================================================================
--- a/drivers/staging/rt2860/common/cmm_data.c
+++ b/drivers/staging/rt2860/common/cmm_data.c
@@ -1951,7 +1951,6 @@ VOID RTMPResumeMsduTransmission(
 {
 	DBGPRINT(RT_DEBUG_TRACE,("SCAN done, resume MSDU transmission ...\n"));
 
-#ifdef RT30xx
 	// After finish BSS_SCAN_IN_PROGRESS, we need to restore Current R66 value
 	// R66 should not be 0
 	if (pAd->BbpTuning.R66CurrentValue == 0)
@@ -1959,7 +1958,7 @@ VOID RTMPResumeMsduTransmission(
 		pAd->BbpTuning.R66CurrentValue = 0x38;
 		DBGPRINT_ERR(("RTMPResumeMsduTransmission, R66CurrentValue=0...\n"));
 	}
-#endif
+
 	RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R66, pAd->BbpTuning.R66CurrentValue);
 
 	RTMP_CLEAR_FLAG(pAd, fRTMP_ADAPTER_BSS_SCAN_IN_PROGRESS);
