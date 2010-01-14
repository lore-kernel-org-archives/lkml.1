Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583Ab0ANUV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583Ab0ANUV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 15:21:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264Ab0ANUV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 15:21:27 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:48191 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab0ANUV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 15:21:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=my7MnuwngstYmRjHn8AKuJcadYouyWMaHQCf2SOHPrmIbu8gZEuYNAbyU5MXpajqZJ
         4fphLpcpNARJ/5QzKVkXKuGhCi8l5u0cLbHJNvjjV1lZNwmtzAlVkGH144TkYpSfACr0
         N7N0ZLIyliD3/TLE+N7/4LP09jKRSUPDbi+4w=
Message-ID: <4B4F7DD4.6050102@gmail.com>
Date: Thu, 14 Jan 2010 21:25:56 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, mchehab@redhat.com
Subject: [PATCH] rtl8192u/ieee80211: CurrentMPDUDensity assigned to itself
 in HTUseDefaultSetting()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CurrentMPDUDensity was designed to itself.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Not 100% sure but this appears more logical, right?

diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c b/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c
index 2c4eb38..642635f 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c
@@ -1342,7 +1342,7 @@ void HTUseDefaultSetting(struct ieee80211_device* ieee)
 
 		pHTInfo->CurrentAMPDUFactor = pHTInfo->AMPDU_Factor;
 
-		pHTInfo->CurrentMPDUDensity = pHTInfo->CurrentMPDUDensity;
+		pHTInfo->CurrentMPDUDensity = pHTInfo->MPDU_Density;
 
 		// Set BWOpMode register
 
