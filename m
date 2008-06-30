Return-Path: <linux-kernel-owner+w=401wt.eu-S1760699AbYF3JXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760699AbYF3JXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 05:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760158AbYF3JWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 05:22:36 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:62559 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755393AbYF3JWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 05:22:35 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: kernel@avr32linux.org
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH 5/8] avr32: Enable SDRAMC clock at startup
Date: Mon, 30 Jun 2008 11:21:13 +0200
Message-Id: <1214817676-30378-6-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1214817676-30378-5-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214817676-30378-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1214817676-30378-2-git-send-email-haavard.skinnemoen@atmel.com>
 <1214817676-30378-3-git-send-email-haavard.skinnemoen@atmel.com>
 <1214817676-30378-4-git-send-email-haavard.skinnemoen@atmel.com>
 <1214817676-30378-5-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 30 Jun 2008 09:21:07.0914 (UTC) FILETIME=[A0DF7AA0:01C8DA92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haavard Skinnemoen <hskinnemoen@atmel.com>

The SDRAM controller needs a clock in order to respond to our
commands, and suspend doesn't work very well without the SDRAM in
self-refresh mode.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 arch/avr32/mach-at32ap/at32ap700x.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index baf4680..3ee5e72 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -675,6 +675,14 @@ static struct clk hramc_clk = {
 	.users		= 1,
 	.index		= 3,
 };
+static struct clk sdramc_clk = {
+	.name		= "sdramc_clk",
+	.parent		= &pbb_clk,
+	.mode		= pbb_clk_mode,
+	.get_rate	= pbb_clk_get_rate,
+	.users		= 1,
+	.index		= 14,
+};
 
 static struct resource smc0_resource[] = {
 	PBMEM(0xfff03400),
@@ -1998,6 +2006,7 @@ struct clk *at32_clock_list[] = {
 	&hmatrix_clk,
 	&ebi_clk,
 	&hramc_clk,
+	&sdramc_clk,
 	&smc0_pclk,
 	&smc0_mck,
 	&pdc_hclk,
-- 
1.5.5.4

