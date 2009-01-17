Return-Path: <linux-kernel-owner+w=401wt.eu-S1760146AbZAQNpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146AbZAQNpl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 08:45:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbZAQNpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 08:45:33 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:64291 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbZAQNpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 08:45:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=SxTDtZsIGStFIAvSBqaVn8ZbL545i15eD+jy6sQFC3v37kTJ3+hU+HrpG0SbFHXiz5
         OgSW/DgE1SEFOtVx4YgoXs7CEGRVHSqRuIUxn6EbE4KhlHZGyXSQP29lVjY7hnQIg3nR
         lQHjJT0+ErsENc60hCzuLWBIYxqUvNaVxYYB4=
Message-ID: <4971E0F9.508@gmail.com>
Date: Sat, 17 Jan 2009 14:45:29 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: lrodriguez@atheros.com, Greg KH <gregkh@suse.de>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] Staging: logical/bit and confusion
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix logical/bit and confusion

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Is this what was intended?

// vi drivers/staging/otus/80211core/struct.h +598
#define ExtHtCap_ExtChannelOffsetAbove  0x01

// vi drivers/staging/otus/80211core/struct.h +600
#define ExtHtCap_RecomTxWidthSet        0x04

// vi drivers/staging/otus/80211core/struct.h +525
#define HTCAP_SupChannelWidthSet    0x0002

diff --git a/drivers/staging/otus/80211core/cwm.c b/drivers/staging/otus/80211core/cwm.c
index 80f1141..1bd0b1f 100644
--- a/drivers/staging/otus/80211core/cwm.c
+++ b/drivers/staging/otus/80211core/cwm.c
@@ -75,9 +75,9 @@ void zfCoreCwmBusy(zdev_t* dev, u16_t busy)
 
     if((wd->wlanMode == ZM_MODE_INFRASTRUCTURE || wd->wlanMode == ZM_MODE_PSEUDO ||
         wd->wlanMode == ZM_MODE_IBSS)) {
-        if (wd->sta.ie.HtCap.HtCapInfo && HTCAP_SupChannelWidthSet != 0 &&
-            wd->sta.ie.HtInfo.ChannelInfo && ExtHtCap_RecomTxWidthSet != 0 &&
-            (wd->sta.ie.HtInfo.ChannelInfo && ExtHtCap_ExtChannelOffsetAbove) == 1) {
+        if ((wd->sta.ie.HtCap.HtCapInfo & HTCAP_SupChannelWidthSet) &&
+            (wd->sta.ie.HtInfo.ChannelInfo & ExtHtCap_RecomTxWidthSet) &&
+            (wd->sta.ie.HtInfo.ChannelInfo & ExtHtCap_ExtChannelOffsetAbove)) {
 
             wd->cwm.cw_width = CWM_WIDTH40;
         }
