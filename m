Return-Path: <linux-kernel-owner+w=401wt.eu-S1763749AbYFFQNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763749AbYFFQNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 12:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758991AbYFFQMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 12:12:22 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:39479 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757405AbYFFQMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 12:12:20 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: linux-mtd@lists.infradead.org, kernel@avr32linux.org
Cc: Andrew Victor <avictor.za@gmail.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Patrice VILCHEZ <patrice.vilchez@atmel.com>,
       linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 5/8] avr32: move hsmc_init() to core_initcall
Date: Fri,  6 Jun 2008 18:04:55 +0200
Message-Id: <1212768298-13614-6-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1212768298-13614-5-git-send-email-haavard.skinnemoen@atmel.com>
References: <1212768298-13614-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1212768298-13614-2-git-send-email-haavard.skinnemoen@atmel.com>
 <1212768298-13614-3-git-send-email-haavard.skinnemoen@atmel.com>
 <1212768298-13614-4-git-send-email-haavard.skinnemoen@atmel.com>
 <1212768298-13614-5-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 06 Jun 2008 16:04:19.0342 (UTC) FILETIME=[FA2C72E0:01C8C7EE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The board init code, typically running from postcore_initcall, may
need to set up SMC timings. We have to make sure the SMC driver is
ready before this happens.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 arch/avr32/mach-at32ap/hsmc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/avr32/mach-at32ap/hsmc.c b/arch/avr32/mach-at32ap/hsmc.c
index fa427ed..b2d9bc6 100644
--- a/arch/avr32/mach-at32ap/hsmc.c
+++ b/arch/avr32/mach-at32ap/hsmc.c
@@ -278,4 +278,4 @@ static int __init hsmc_init(void)
 {
 	return platform_driver_register(&hsmc_driver);
 }
-arch_initcall(hsmc_init);
+core_initcall(hsmc_init);
-- 
1.5.5.1

