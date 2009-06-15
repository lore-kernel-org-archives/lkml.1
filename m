Return-Path: <linux-kernel-owner+w=401wt.eu-S1765663AbZFOSa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765663AbZFOSa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765603AbZFOSak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:30:40 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:55936 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765614AbZFOSai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:30:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=tgb0jY9ldnIFeGfAGJHR8B0n5K/NDbAFeoxYtnPXFS4D3/SE1L2d6Ukeg30iTrr7Zi
         Npexeoq2qmNlEZkCaFR4iU5LNYF5o2cVBjOPe9a53nm3Mm4RGejfDcsTsIJwOumbG9oC
         FfN0JCA5WT8oJCRMUJ7v3S+RwhvkoO94bhVT8=
Message-ID: <4A36AF6F.6060005@gmail.com>
Date: Mon, 15 Jun 2009 22:30:39 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: lrg@slimlogic.co.uk
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] regulator: add check index of wm8350->pmic.pdev[]
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that reg is within the bounds of array wm8350->pmic.pdev[].

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index 771eca1..c806259 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -1419,6 +1419,8 @@ int wm8350_register_regulator(struct wm8350 *wm8350, int reg,
 {
 	struct platform_device *pdev;
 	int ret;
+	if (reg < 0 || reg >= NUM_WM8350_REGULATORS)
+		return -EINVAL;
 
 	if (wm8350->pmic.pdev[reg])
 		return -EBUSY;
