Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab0BXHij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:38:39 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:42613 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594Ab0BXHig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:38:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=uwX/od0kw3fDvIZxmqEDdcBsP2cjmkABgdm8/Mgs0b+IoDdXIZfT0k6YSb2xudeiNV
         2R0f8DqwwfKN1Z8n5RcCc0QfHs6xJTad0dVucRaryGnd6blWIUFVn1zSiIzs/TxC0Xfv
         4cOtM1PCoWsW4unxkxo6qleIkcEhpj+jKKqw0=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 10/14] Regulators: pcap-regulator - clean up driver data after
	removal
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 23 Feb 2010 23:38:33 -0800
Message-ID: <20100224073833.15964.47638.stgit@localhost.localdomain>
In-Reply-To: <20100224073342.15964.8863.stgit@localhost.localdomain>
References: <20100224073342.15964.8863.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is a good tone to reset driver data after unbinding the device.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/regulator/pcap-regulator.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/pcap-regulator.c b/drivers/regulator/pcap-regulator.c
index 33d7d89..29d0566 100644
--- a/drivers/regulator/pcap-regulator.c
+++ b/drivers/regulator/pcap-regulator.c
@@ -288,16 +288,18 @@ static int __devexit pcap_regulator_remove(struct platform_device *pdev)
 	struct regulator_dev *rdev = platform_get_drvdata(pdev);
 
 	regulator_unregister(rdev);
+	platform_set_drvdata(pdev, NULL);
 
 	return 0;
 }
 
 static struct platform_driver pcap_regulator_driver = {
 	.driver = {
-		.name = "pcap-regulator",
+		.name	= "pcap-regulator",
+		.owner	= THIS_MODULE,
 	},
-	.probe = pcap_regulator_probe,
-	.remove = __devexit_p(pcap_regulator_remove),
+	.probe	= pcap_regulator_probe,
+	.remove	= __devexit_p(pcap_regulator_remove),
 };
 
 static int __init pcap_regulator_init(void)

