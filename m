Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab0BXHqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:46:07 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:59514 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab0BXHqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:46:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=PbTNnQ4mR7sydHFe7mrLe5MJLxqt+897VpYuxHhh7cVM0cXTA2qVQFBrDQlm2FEt46
         j+1h2B6sC18nVaSUF2IpBaoEIoPnl27ed70Zm1yyv8MCWcFcph74QHq9ZVciZ8NCfOu9
         dRtN1PqF9tvGSMWnZjLLIdzoMfm22yUjhTdgA=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 02/14] Regulators: ab3100 - fix probe and remove annotations
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 23 Feb 2010 23:37:50 -0800
Message-ID: <20100224073750.15964.22427.stgit@localhost.localdomain>
In-Reply-To: <20100224073342.15964.8863.stgit@localhost.localdomain>
References: <20100224073342.15964.8863.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Probe and remove methods should not be marked as __init/__exit but
rather __devinit/__devexit so that the needed sections stay in memory
in presence of CONFIG_HOTPLUG. This is needed even on non hotpluggable
buses.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/regulator/ab3100.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
index b349db4..7de9509 100644
--- a/drivers/regulator/ab3100.c
+++ b/drivers/regulator/ab3100.c
@@ -561,7 +561,7 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
  * for all the different regulators.
  */
 
-static int __init ab3100_regulators_probe(struct platform_device *pdev)
+static int __devinit ab3100_regulators_probe(struct platform_device *pdev)
 {
 	struct ab3100_platform_data *plfdata = pdev->dev.platform_data;
 	struct ab3100 *ab3100 = platform_get_drvdata(pdev);
@@ -641,7 +641,7 @@ static int __init ab3100_regulators_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int __exit ab3100_regulators_remove(struct platform_device *pdev)
+static int __devexit ab3100_regulators_remove(struct platform_device *pdev)
 {
 	int i;
 
@@ -659,7 +659,7 @@ static struct platform_driver ab3100_regulators_driver = {
 		.owner = THIS_MODULE,
 	},
 	.probe = ab3100_regulators_probe,
-	.remove = __exit_p(ab3100_regulators_remove),
+	.remove = __devexit_p(ab3100_regulators_remove),
 };
 
 static __init int ab3100_regulators_init(void)

