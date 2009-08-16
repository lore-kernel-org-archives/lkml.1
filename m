Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795AbZHPT3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbZHPT3j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 15:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbZHPT3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 15:29:37 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:49711 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137AbZHPT3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 15:29:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=sncRziMXO/J4oUBlt5gG7VVaVZTo4qx8OSWGBQsc03veq8XsmHa+RmqDHAeKqfGRvF
         Kxfn3iu5a4fyjEn9cbiRVebF3184BgOlmT1QNi6KMTurh3qHHYygy6i/0gvhkG8cZM5v
         Z7xRit3EQkvUsxVwDFTb4IeojgpfHPVylXKSQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 16 Aug 2009 21:29:47 +0200
Message-Id: <20090816192947.3789.78773.sendpatchset@localhost.localdomain>
In-Reply-To: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
References: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
Subject: [PATCH 02/22] Staging: rt3070: fix build warnings
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt3070: fix build warnings

In file included from drivers/staging/rt3070/common/../../rt2870/common/cmm_data.c:2,
                 from drivers/staging/rt3070/common/cmm_data.c:2:
drivers/staging/rt3070/common/../../rt2870/common/../../rt2860/common/cmm_data.c: In function ‘RTMP_FillTxBlkInfo’:
drivers/staging/rt3070/common/../../rt2870/common/../../rt2860/common/cmm_data.c:1018: warning: label ‘FillTxBlkErr’ defined but not used

In file included from drivers/staging/rt3070/common/../../rt2870/common/eeprom.c:2,
                 from drivers/staging/rt3070/common/eeprom.c:2:
drivers/staging/rt3070/common/../../rt2870/common/../../rt2860/common/eeprom.c: In function ‘set_eFuseLoadFromBin_Proc’:
drivers/staging/rt3070/common/../../rt2870/common/../../rt2860/common/eeprom.c:1041: warning: unused variable ‘orgfsgid’
drivers/staging/rt3070/common/../../rt2870/common/../../rt2860/common/eeprom.c:1041: warning: unused variable ‘orgfsuid’

In file included from drivers/staging/rt3070/../rt2870/rt_profile.c:2,
                 from drivers/staging/rt3070/rt_profile.c:2:
drivers/staging/rt3070/../rt2870/../rt2860/rt_profile.c: In function ‘RTMPReadParametersHook’:
drivers/staging/rt3070/../rt2870/../rt2860/rt_profile.c:863: warning: unused variable ‘orgfsgid’
drivers/staging/rt3070/../rt2870/../rt2860/rt_profile.c:863: warning: unused variable ‘orgfsuid’

In file included from drivers/staging/rt3070/common/rtusb_io.c:2:
drivers/staging/rt3070/common/../../rt2870/common/rtusb_io.c: In function ‘CMDHandler’:
drivers/staging/rt3070/common/../../rt2870/common/rtusb_io.c:1763: warning: ‘CipherAlg’ may be used uninitialized in this function
drivers/staging/rt3070/common/../../rt2870/common/rtusb_io.c:1758: note: ‘CipherAlg’ was declared here
drivers/staging/rt3070/common/../../rt2870/common/rtusb_io.c:1763: warning: ‘KeyIdx’ may be used uninitialized in this function
drivers/staging/rt3070/common/../../rt2870/common/rtusb_io.c:1757: note: ‘KeyIdx’ was declared here
drivers/staging/rt3070/common/../../rt2870/common/rtusb_io.c:1763: warning: ‘ApIdx’ may be used uninitialized in this function
drivers/staging/rt3070/common/../../rt2870/common/rtusb_io.c:1759: note: ‘ApIdx’ was declared here

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/common/cmm_data.c |    5 -----
 drivers/staging/rt2860/common/eeprom.c   |   14 +++-----------
 drivers/staging/rt2860/rt_profile.c      |   11 +----------
 drivers/staging/rt2870/common/rtusb_io.c |    6 +++---
 4 files changed, 7 insertions(+), 29 deletions(-)

Index: b/drivers/staging/rt2860/common/cmm_data.c
===================================================================
--- a/drivers/staging/rt2860/common/cmm_data.c
+++ b/drivers/staging/rt2860/common/cmm_data.c
@@ -1013,11 +1013,6 @@ BOOLEAN RTMP_FillTxBlkInfo(
 	}
 
 	return TRUE;
-
-#ifdef RT30xx
-FillTxBlkErr:
-	return FALSE;
-#endif
 }
 
 
Index: b/drivers/staging/rt2860/common/eeprom.c
===================================================================
--- a/drivers/staging/rt2860/common/eeprom.c
+++ b/drivers/staging/rt2860/common/eeprom.c
@@ -1038,7 +1038,7 @@ INT	set_eFuseLoadFromBin_Proc(
 {
 	CHAR					*src;
 	struct file				*srcf;
-	INT 					retval, orgfsuid, orgfsgid;
+	INT 					retval;
    	mm_segment_t			orgfs;
 	UCHAR					*buffer;
 	UCHAR					BinFileSize=0;
@@ -1078,12 +1078,7 @@ INT	set_eFuseLoadFromBin_Proc(
 		kfree(buffer);
 		return FALSE;
 	}
-	/* Don't change to uid 0, let the file be opened as the "normal" user */
-#if 0
-	orgfsuid = current->fsuid;
-	orgfsgid = current->fsgid;
-	current->fsuid=current->fsgid = 0;
-#endif
+
     	orgfs = get_fs();
    	 set_fs(KERNEL_DS);
 
@@ -1146,10 +1141,7 @@ INT	set_eFuseLoadFromBin_Proc(
 		DBGPRINT(RT_DEBUG_TRACE, ("--> Error %d closing %s\n", -retval, src));
 	}
 	set_fs(orgfs);
-#if 0
-	current->fsuid = orgfsuid;
-	current->fsgid = orgfsgid;
-#endif
+
 	for(j=0;j<i;j++)
 	{
 		DBGPRINT(RT_DEBUG_TRACE, ("%02X ",buffer[j]));
Index: b/drivers/staging/rt2860/rt_profile.c
===================================================================
--- a/drivers/staging/rt2860/rt_profile.c
+++ b/drivers/staging/rt2860/rt_profile.c
@@ -860,7 +860,7 @@ NDIS_STATUS	RTMPReadParametersHook(
 {
 	PUCHAR					src = NULL;
 	struct file				*srcf;
-	INT 					retval, orgfsuid, orgfsgid;
+	INT 					retval;
    	mm_segment_t			orgfs;
 	CHAR					*buffer;
 	CHAR					*tmpbuf;
@@ -884,15 +884,6 @@ NDIS_STATUS	RTMPReadParametersHook(
 
 	src = STA_PROFILE_PATH;
 
-	// Save uid and gid used for filesystem access.
-	// Set user and group to 0 (root)
-#ifndef RT30xx
-	orgfsuid = current_fsuid();
-	orgfsgid = current_fsgid();
-	/* Hm, can't really do this nicely anymore, so rely on these files
-	 * being set to the proper permission to read them... */
-	/* current->cred->fsuid = current->cred->fsgid = 0; */
-#endif
     orgfs = get_fs();
     set_fs(KERNEL_DS);
 
Index: b/drivers/staging/rt2870/common/rtusb_io.c
===================================================================
--- a/drivers/staging/rt2870/common/rtusb_io.c
+++ b/drivers/staging/rt2870/common/rtusb_io.c
@@ -1754,9 +1754,9 @@ VOID CMDHandler(
 				case RT_CMD_SET_RX_WCID_TABLE: //General call for RTMPAddWcidAttributeEntry()
 				{
 					PMAC_TABLE_ENTRY pEntry;
-					UCHAR KeyIdx;
-					UCHAR CipherAlg;
-					UCHAR ApIdx;
+					UCHAR KeyIdx = 0;
+					UCHAR CipherAlg = 0;
+					UCHAR ApIdx = 0;
 
 					pEntry = (PMAC_TABLE_ENTRY)(pData);
 
