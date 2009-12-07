Return-Path: <linux-kernel-owner+w=401wt.eu-S935069AbZLGNeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935069AbZLGNeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 08:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935042AbZLGNeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 08:34:20 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:40951 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934911AbZLGNeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 08:34:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=ACk9XeY7WO2Z7YIVlkR7tleEcM9x6vNRV5FX0qc6pCp1AcioPzTsfi3hJUnpXg2FP1
         ifNsRCVW/H/C/ANI7uMh0bF5COvFaL6UsPZhnY48fcwVp+q+YP18AEcDYPrhnMh4lAv/
         LKa+IWOOdqi0n+VYy76igfKzOwrWhhj0hefYE=
Message-ID: <4B1D04A4.7070407@gmail.com>
Date: Mon, 07 Dec 2009 14:35:32 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Richard Purdie <rpurdie@rpsys.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] backlight: PTR_ERR return of wrong pointer in cr_backlight_probe()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the PTR_ERR of the correct pointer.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/video/backlight/cr_bllcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/cr_bllcd.c b/drivers/video/backlight/cr_bllcd.c
index b9fe62b..c2d1e25 100644
--- a/drivers/video/backlight/cr_bllcd.c
+++ b/drivers/video/backlight/cr_bllcd.c
@@ -201,7 +201,7 @@ static int cr_backlight_probe(struct platform_device *pdev)
 	if (IS_ERR(ldp)) {
 		backlight_device_unregister(bdp);
 		pci_dev_put(lpc_dev);
-		return PTR_ERR(bdp);
+		return PTR_ERR(ldp);
 	}
 
 	pci_read_config_dword(lpc_dev, CRVML_REG_GPIOBAR,
