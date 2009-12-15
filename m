Return-Path: <linux-kernel-owner+w=401wt.eu-S933325AbZLOTFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933325AbZLOTFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760838AbZLOTFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:05:44 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:49247 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758331AbZLOTFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:05:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=k2Xdv11XnDde7IbaVzuOwFhtfeEUFAa0wDdpyKgV3FnUn+fXMijDL8YurQwxSTeTnU
         EKsxCaDTgqmKUFUBTwZTXhMK2q2y5mbMWtfLtXzFgR0rqX5hCoPJvF24n+UMLnP5M9L3
         v1V8Hr+b/rMnFPFCk5iBTxIQoYOGoXPG6NxqA=
Message-ID: <4B27DE73.6060909@gmail.com>
Date: Tue, 15 Dec 2009 20:07:31 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] regulator: wm831x_reg_read() failure unnoticed in wm831x_aldo_get_mode()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ret should be signed to notice a failure in wm831x_reg_read().

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found using coccinelle: http://coccinelle.lip6.fr/

diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index 902db56..61e02ac 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -470,7 +470,7 @@ static unsigned int wm831x_aldo_get_mode(struct regulator_dev *rdev)
 	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
 	struct wm831x *wm831x = ldo->wm831x;
 	int on_reg = ldo->base + WM831X_LDO_ON_CONTROL;
-	unsigned int ret;
+	int ret;
 
 	ret = wm831x_reg_read(wm831x, on_reg);
 	if (ret < 0)
