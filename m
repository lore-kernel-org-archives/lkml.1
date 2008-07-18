Return-Path: <linux-kernel-owner+w=401wt.eu-S1756715AbYGRHl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbYGRHl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 03:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755591AbYGRHk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 03:40:27 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:50116 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544AbYGRHkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 03:40:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=grCK2bl7+zfrSFxiaq0Mp0RfXAgX+XbbZD8dEWul/mmCqAj0qDET8e3ygot5y8I3HE
         Q1Arwlan1oeQRhKiS840TNkpZfYSfTwbwwDTcJkNG8UzJCjGalRYBpuOF6aTqKHio3XD
         pOm4nDyrSe7LZ+M23I2LGQJy6HFoX43ha+f1Q=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, gregkh@suse.de, lethal@linux-sh.org,
       i2c@lm-sensors.org, Magnus Damm <magnus.damm@gmail.com>,
       akpm@linux-foundation.org
Date: Fri, 18 Jul 2008 16:40:36 +0900
Message-Id: <20080718074036.32713.92629.sendpatchset@rx1.opensource.se>
In-Reply-To: <20080718074002.32713.73442.sendpatchset@rx1.opensource.se>
References: <20080718074002.32713.73442.sendpatchset@rx1.opensource.se>
Subject: [PATCH 04/05] i2c-sh_mobile: IORESOURCE_CLK support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

This patch makes the i2c-sh_mobile driver get the clock name from the
struct resource with type IORESOURCE_CLK provided by the platform data.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/i2c/busses/i2c-sh_mobile.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- 0001/drivers/i2c/busses/i2c-sh_mobile.c
+++ work/drivers/i2c/busses/i2c-sh_mobile.c	2008-07-18 14:56:40.000000000 +0900
@@ -390,13 +390,19 @@ static int sh_mobile_i2c_probe(struct pl
 	int size;
 	int ret;
 
+	res = platform_get_resource(dev, IORESOURCE_CLK, 0);
+	if (res == NULL || res->name == NULL) {
+		dev_err(&dev->dev, "cannot find CLK resource\n");
+		return -ENOENT;
+	}
+
 	pd = kzalloc(sizeof(struct sh_mobile_i2c_data), GFP_KERNEL);
 	if (pd == NULL) {
 		dev_err(&dev->dev, "cannot allocate private data\n");
 		return -ENOMEM;
 	}
 
-	pd->clk = clk_get(&dev->dev, "peripheral_clk");
+	pd->clk = clk_get(&dev->dev, res->name);
 	if (IS_ERR(pd->clk)) {
 		dev_err(&dev->dev, "cannot get peripheral clock\n");
 		ret = PTR_ERR(pd->clk);
