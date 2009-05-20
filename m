Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbZETAgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbZETAgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 20:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbZETAg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 20:36:29 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:39942 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684AbZETAg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 20:36:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=h6k8ePw2LZ3UYTHVMoSfIepdqIwisHUXSS+qMqXp9T/L6EhLmqnCE53JzWDovufbm8
         wc16IZfxL9uYxKhzdX3WaBOvlSHN1snwXmV28n+nWjC/G3/2KlyLKQBIxd4gA0c7dmOy
         6GThWoryfeh+dXdB0alKvsdK4YtVl4sVnxf6Q=
Message-ID: <4A13508D.1070500@gmail.com>
Date: Wed, 20 May 2009 02:36:29 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] [staging] beyond ARRAY_SIZE of wd->ap.wds.encryMode
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not go beyond ARRAY_SIZE of wd->ap.wds.encryMode

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/staging/otus/80211core/coid.c b/drivers/staging/otus/80211core/coid.c
index 88f8d34..0524e1f 100644
--- a/drivers/staging/otus/80211core/coid.c
+++ b/drivers/staging/otus/80211core/coid.c
@@ -2013,7 +2013,7 @@ u16_t zfiConfigWdsPort(zdev_t* dev, u8_t wdsPortId, u16_t flag, u16_t* wdsAddr,
 
     zmw_get_wlan_dev(dev);
 
-    if (wdsPortId > ZM_MAX_WDS_SUPPORT)
+    if (wdsPortId >= ZM_MAX_WDS_SUPPORT)
     {
         return ZM_ERR_WDS_PORT_ID;
     }
