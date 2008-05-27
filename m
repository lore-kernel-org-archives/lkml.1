Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbYE0Hrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbYE0Hrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 03:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbYE0Hri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 03:47:38 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:54309 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528AbYE0Hri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 03:47:38 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH] avr32: Fix cpufreq oops when ondemand governor is default
Date: Tue, 27 May 2008 09:47:42 +0200
Message-Id: <1211874462-29287-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.1
X-OriginalArrivalTime: 27 May 2008 07:47:37.0051 (UTC) FILETIME=[EE7E3AB0:01C8BFCD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the AP7 cpufreq driver to late_initcall() so that we don't try to
bring up cpufreq until the governor is ready. x86 also uses
late_initcall() for this.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
While looking around, I spotted lots of other architectures using
arch_initcall() for their cpufreq drivers. I would expect them to have
the same problem when a non-trivial default governor is selected.

 arch/avr32/mach-at32ap/cpufreq.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/avr32/mach-at32ap/cpufreq.c b/arch/avr32/mach-at32ap/cpufreq.c
index 235524b..5dd8d25 100644
--- a/arch/avr32/mach-at32ap/cpufreq.c
+++ b/arch/avr32/mach-at32ap/cpufreq.c
@@ -108,5 +108,4 @@ static int __init at32_cpufreq_init(void)
 {
 	return cpufreq_register_driver(&at32_driver);
 }
-
-arch_initcall(at32_cpufreq_init);
+late_initcall(at32_cpufreq_init);
-- 
1.5.5.1

