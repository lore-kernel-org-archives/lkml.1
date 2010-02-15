Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab0BOStM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 13:49:12 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:13458 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010Ab0BOStI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 13:49:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=cCOaI7r15Fm0Ke8WpmMdJfaapkZyaYvWZnv0LZgMUxrXepcAlvhfV2qVPZ9pCW+o7V
         Y1v00Sh7gYM89CD5LIRUHQYOr4Q0+qvjR976etpB9Qst0UH8OmnuvaLMZN/WwnxhSV1o
         iAYYMq2frWhAkiZ4JmL+XxAKrPmpDtVpEZ6q0=
Subject: Subject: [PATCH] w1: mxc_w1: move probe and remove to the dev*
 text area.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Sascha linux-arm <s.hauer@pengutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Feb 2010 19:49:01 +0100
Message-ID: <1266259741.2551.64.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the section mismatch warning for mxc_w1_probe()
---

This patch apply to linus 2.6.33-rc8 tree.
I think that could be marked for stable releases.

 drivers/w1/masters/mxc_w1.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/w1/masters/mxc_w1.c b/drivers/w1/masters/mxc_w1.c
index 65244c0..4926703 100644
--- a/drivers/w1/masters/mxc_w1.c
+++ b/drivers/w1/masters/mxc_w1.c
@@ -102,7 +102,7 @@ static u8 mxc_w1_ds2_touch_bit(void *data, u8 bit)
 	return ((__raw_readb(ctrl_addr)) >> 3) & 0x1;
 }
 
-static int __init mxc_w1_probe(struct platform_device *pdev)
+static int __devinit mxc_w1_probe(struct platform_device *pdev)
 {
 	struct mxc_w1_device *mdev;
 	struct resource *res;
@@ -166,7 +166,7 @@ failed_clk:
 /*
  * disassociate the w1 device from the driver
  */
-static int mxc_w1_remove(struct platform_device *pdev)
+static int __devexit mxc_w1_remove(struct platform_device *pdev)
 {
 	struct mxc_w1_device *mdev = platform_get_drvdata(pdev);
 	struct resource *res;
-- 
1.6.3.3




