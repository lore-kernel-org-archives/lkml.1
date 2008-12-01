Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbYLAM33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbYLAM33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbYLAM3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:29:21 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:41394 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbYLAM3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:29:20 -0500
Subject: [PATCH, resend] mtd: OOPS accessing flash operations over STM
	flash on PXA
From: "Denis V. Lunev" <den@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mtd@lists.infradead.org, ymiao3@marvell.com,
       "Denis V. Lunev" <den@openvz.org>, dwmw2@infradead.org,
       linux-kernel <linux-kernel@vger.kernel.org>
X-Greylist: Sender e-mail whitelisted, not delayed by milter-greylist-2.0.2
	(vzorg.swsoft.net [64.131.90.7]); Mon, 17 Nov 2008 04:23:15 -0500 (EST)
Content-Type: text/plain
Organization: Parallels
Date: Mon, 01 Dec 2008 15:28:18 +0300
Message-Id: <1228134498.10480.16.camel@iris.sw.ru>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

STM 2Gb flash is a large-page NAND flash. Set operations accordingly.
This field is dereferrenced without a check in several places resulting
in OOPS.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Acked-by: Eric Miao <ymiao3@marvell.com>
---
 drivers/mtd/nand/pxa3xx_nand.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
index c0fa9c9..15f0a26 100644
--- a/drivers/mtd/nand/pxa3xx_nand.c
+++ b/drivers/mtd/nand/pxa3xx_nand.c
@@ -269,6 +269,7 @@ static struct pxa3xx_nand_timing stm2GbX16_timing = {
 
 static struct pxa3xx_nand_flash stm2GbX16 = {
 	.timing = &stm2GbX16_timing,
+	.cmdset	= &largepage_cmdset,
 	.page_per_block = 64,
 	.page_size = 2048,
 	.flash_width = 16,
-- 
1.5.6.4


