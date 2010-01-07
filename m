Return-Path: <linux-kernel-owner+w=401wt.eu-S932963Ab0AGCCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963Ab0AGCCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 21:02:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932690Ab0AGCCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 21:02:06 -0500
Received: from mail.gmx.net ([213.165.64.20]:36652 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932554Ab0AGCCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 21:02:04 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+iPLE7V3OiRHgRJMaqZxfdy64vGQXy4D00DaU9/f
	EGeoz1gARtwJrP
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] mtd/nand: Fix build failure caused by typo
Date: Thu, 7 Jan 2010 03:01:58 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27-05415-g69a8594; KDE/4.3.3; x86_64; ; )
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
       Nicolas Pitre <nico@marvell.com>,
       "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201001070301.58260.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>
Date: Thu, 7 Jan 2010 02:51:13 +0100

This patch fixes a build failure[1] introduced by the patch
    mtd: orion_nand.c: add error handling and use resource_size()
    by H Hartley Sweeten [2]
The patch assigns something to a undeclared variable 'err', whereas the
rest of the code uses 'ret' for this task.

This patch fixes this typo and thus removes the build failure.

References:
[1] http://kisskb.ellerman.id.au/kisskb/buildresult/1983354/
[2] http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commitdiff;h=e99030609e27abff7e1a868cb56384c678b09984

Patch against linux-next of Do 7. Jan 02:58:41 CET 2010

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/mtd/nand/orion_nand.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/orion_nand.c b/drivers/mtd/nand/orion_nand.c
index 9903460..f16050c 100644
--- a/drivers/mtd/nand/orion_nand.c
+++ b/drivers/mtd/nand/orion_nand.c
@@ -92,7 +92,7 @@ static int __init orion_nand_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
-		err = -ENODEV;
+		ret = -ENODEV;
 		goto no_res;
 	}
 
-- 
1.6.4.4

