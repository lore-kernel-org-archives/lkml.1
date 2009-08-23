Return-Path: <linux-kernel-owner+w=401wt.eu-S933913AbZHWN3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913AbZHWN3V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933891AbZHWN3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:29:19 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:58451 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933904AbZHWN3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:29:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Z0/rqIv/xkUbV+V9svAjCC6sRQVvGlFSsmEs2k48ad61ndMP1A/jtd2E5OqWFO2Fzm
         mqFNAfUKdtSJCGFH4pYkBhQyBXOaNkKIchcDjKQwams1AYji6ZWS2fIewmmKUcrVJgcp
         rwCeWT8aDowno8zA5WhGB49xINdY93ms9kQUQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:29:45 +0200
Message-Id: <20090823132945.17784.28456.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 09/33] Staging: rt3070: remove needless EFUSE_TAG register read
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt3070: remove needless EFUSE_TAG register read

* remove write-only EFuseTag field from RTMP_ADAPTER
* remove needless EFUSE_TAG register read

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/common/rtmp_init.c |    8 --------
 drivers/staging/rt2860/rtmp.h             |    1 -
 2 files changed, 9 deletions(-)

Index: b/drivers/staging/rt2860/common/rtmp_init.c
===================================================================
--- a/drivers/staging/rt2860/common/rtmp_init.c
+++ b/drivers/staging/rt2860/common/rtmp_init.c
@@ -1779,14 +1779,6 @@ VOID	NICReadEEPROMParameters(
 
 	RTMPReadTxPwrPerRate(pAd);
 
-#ifdef RT30xx
-	if (IS_RT30xx(pAd))
-	{
-		eFusePhysicalReadRegisters(pAd, EFUSE_TAG, 2, &value);
-		pAd->EFuseTag = (value & 0xff);
-	}
-#endif // RT30xx //
-
 	DBGPRINT(RT_DEBUG_TRACE, ("<-- NICReadEEPROMParameters\n"));
 }
 
Index: b/drivers/staging/rt2860/rtmp.h
===================================================================
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -2669,7 +2669,6 @@ typedef struct _RTMP_ADAPTER
 	USHORT                  EEPROMDefaultValue[NUM_EEPROM_BBP_PARMS];
 #ifdef RT30xx
 	BOOLEAN                 EepromAccess;
-	UCHAR                   EFuseTag;
 #endif
 	ULONG                   FirmwareVersion;        // byte 0: Minor version, byte 1: Major version, otherwise unused.
 
