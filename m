Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbYCMPrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbYCMPrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 11:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbYCMPrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 11:47:09 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:26879 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbYCMPrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 11:47:08 -0400
X-Greylist: delayed 2165 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Mar 2008 11:47:07 EDT
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: kernel@avr32linux.org
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Brownell <david-b@pacbell.net>
Subject: [PATCH 05/10] avr32: Enable SDRAMC clock at startup
Date: Thu, 13 Mar 2008 15:39:40 +0100
Message-Id: <1205419185-26395-6-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1205419185-26395-5-git-send-email-hskinnemoen@atmel.com>
References: <>
 <1205419185-26395-1-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-2-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-3-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-4-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-5-git-send-email-hskinnemoen@atmel.com>
X-OriginalArrivalTime: 13 Mar 2008 14:39:46.0446 (UTC) FILETIME=[156132E0:01C88518]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SDRAM controller needs a clock in order to respond to our
commands, and suspend doesn't work very well without the SDRAM in
self-refresh mode.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 arch/avr32/mach-at32ap/at32ap700x.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index 1af9c1d..ca5ee7a 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -682,6 +682,14 @@ static struct clk hramc_clk = {
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
@@ -1887,6 +1895,7 @@ struct clk *at32_clock_list[] = {
 	&hmatrix_clk,
 	&ebi_clk,
 	&hramc_clk,
+	&sdramc_clk,
 	&smc0_pclk,
 	&smc0_mck,
 	&pdc_hclk,
-- 
1.5.4.3

