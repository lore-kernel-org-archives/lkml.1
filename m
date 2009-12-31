Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbZLaMZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbZLaMZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 07:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbZLaMZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 07:25:22 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:50383 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbZLaMZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 07:25:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=UClMGcnvfR1jLt9dYkSM7dS7U9fTM24KE6+xKQREX5rsKuMtRKOJ4RP8qBZfPa175s
         BYrxL5lt47TJTKqVRjhROr2UcI6GrcwY0nGlrNKQmh5PnOzogR1DweMhWbMUABuqrJ+p
         tXDBFRvkHw1LhrocPnUlxtVsC/OAvB8MC2lqg=
Message-ID: <4B3C98F0.9060309@gmail.com>
Date: Thu, 31 Dec 2009 13:28:32 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] 80211core: Fix &&/|| confusion
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This always evaluates to true.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/staging/otus/80211core/cmmsta.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/otus/80211core/cmmsta.c b/drivers/staging/otus/80211core/cmmsta.c
index a11d559..5c0dea7 100644
--- a/drivers/staging/otus/80211core/cmmsta.c
+++ b/drivers/staging/otus/80211core/cmmsta.c
@@ -2808,7 +2808,7 @@ void zfStaProcessProbeReq(zdev_t* dev, zbuf_t* buf, u16_t* src)
     zmw_get_wlan_dev(dev);
 
     /* check mode : AP/IBSS */
-    if ((wd->wlanMode != ZM_MODE_AP) || (wd->wlanMode != ZM_MODE_IBSS))
+    if ((wd->wlanMode != ZM_MODE_AP) && (wd->wlanMode != ZM_MODE_IBSS))
     {
         zm_msg0_mm(ZM_LV_3, "Ignore probe req");
         return;
