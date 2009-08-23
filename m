Return-Path: <linux-kernel-owner+w=401wt.eu-S933956AbZHWN3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933956AbZHWN3x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933864AbZHWN3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:29:51 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:64177 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933759AbZHWN3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:29:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Ho6NRSX+rMBsdkPjUILsVVJObG1Ggdqb2+6uKZG4k4RuRFn1ZGfC/F5xsZZh6pW3C/
         n/RJ8mgz5xxLiwUfJ85AqInSflYvpVQGSKZ9Ij1jlGcqmIlrnM7dhz+GZeW1NmMmfDO+
         wGdE1LnoFrooqBeD8dufxHXsFMoujUlRc4pL8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:30:17 +0200
Message-Id: <20090823133017.17784.32899.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 14/33] Staging: rt28x0: fix GTK length check in ParseKeyData()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt28x0: fix GTK length check in ParseKeyData()

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/sta/wpa.c |    5 -----
 drivers/staging/rt2860/wpa.h     |    1 -
 2 files changed, 6 deletions(-)

Index: b/drivers/staging/rt2860/sta/wpa.c
===================================================================
--- a/drivers/staging/rt2860/sta/wpa.c
+++ b/drivers/staging/rt2860/sta/wpa.c
@@ -1764,12 +1764,7 @@ BOOLEAN ParseKeyData(
 	// Get GTK length - refer to IEEE 802.11i-2004 p.82
 	GTKLEN = pKDE->Len -6;
 
-#ifdef RT30xx
 	if (GTKLEN < LEN_AES_KEY)
-#endif
-#ifndef RT30xx
-	if (GTKLEN < MIN_LEN_OF_GTK)
-#endif
 	{
 		DBGPRINT(RT_DEBUG_ERROR, ("ERROR: GTK Key length is too short (%d) \n", GTKLEN));
         return FALSE;
Index: b/drivers/staging/rt2860/wpa.h
===================================================================
--- a/drivers/staging/rt2860/wpa.h
+++ b/drivers/staging/rt2860/wpa.h
@@ -90,7 +90,6 @@
 #define TKIP_AP_RXMICK_OFFSET		(TKIP_AP_TXMICK_OFFSET+LEN_TKIP_TXMICK)
 #define TKIP_GTK_LENGTH				((LEN_TKIP_EK)+(LEN_TKIP_RXMICK)+(LEN_TKIP_TXMICK))
 #define LEN_PTK						((LEN_EAP_KEY)+(LEN_TKIP_KEY))
-#define MIN_LEN_OF_GTK				5
 
 // RSN IE Length definition
 #define MAX_LEN_OF_RSNIE         	90
