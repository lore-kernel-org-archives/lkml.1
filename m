Return-Path: <linux-kernel-owner+w=401wt.eu-S1752489AbYHAPRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbYHAPRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 11:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYHAPRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 11:17:40 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:59975 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbYHAPRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 11:17:39 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: spi-devel-general@lists.sourceforge.net, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 1/4] avr32: Reduce DataFlash bus speed to 8 MHz on ATNGW100
Date: Fri,  1 Aug 2008 17:17:13 +0200
Message-Id: <1217603836-21243-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.3
X-OriginalArrivalTime: 01 Aug 2008 15:17:17.0502 (UTC) FILETIME=[AF5BD5E0:01C8F3E9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doing this in combination with "atmel_spi: fix hang due to missed
interrupt" appears to eliminate the overruns I'm seeing when using
JFFS2-on-DataFlash as /usr filesystem on the ATNGW100.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
The "atmel" releases have been running the DataFlash at 8 MHz for a
while, so this brings mainline in sync with them.

I think the only way to increase the bus speed beyond this is to use
faster RAM. I'll look into using SRAM bounce buffers next.

I'll apply this patch to my avr32 tree. David, I'll let you decide
whether the other three patches are important/safe enough for 2.6.27.
I've verified that they don't break DataFlash on ATNGW100, but they
could use some testing on other setups, in particular AT91RM9200 and
other AT91 chips.

 arch/avr32/boards/atngw100/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/avr32/boards/atngw100/setup.c b/arch/avr32/boards/atngw100/setup.c
index c7fe94d..12b21ac 100644
--- a/arch/avr32/boards/atngw100/setup.c
+++ b/arch/avr32/boards/atngw100/setup.c
@@ -47,7 +47,7 @@ static struct eth_platform_data __initdata eth_data[2];
 static struct spi_board_info spi0_board_info[] __initdata = {
 	{
 		.modalias	= "mtd_dataflash",
-		.max_speed_hz	= 10000000,
+		.max_speed_hz	= 8000000,
 		.chip_select	= 0,
 	},
 };
-- 
1.5.6.3

