Return-Path: <linux-kernel-owner+w=401wt.eu-S1753631AbZEKGnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbZEKGnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 02:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbZEKGna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 02:43:30 -0400
Received: from araneidae.co.uk ([62.3.233.233]:3821 "EHLO araneidae.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbZEKGn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 02:43:29 -0400
Date: Mon, 11 May 2009 07:43:29 +0100 (BST)
From: Michael Abbott <michael@araneidae.co.uk>
To: linux-arm-kernel@lists.arm.linux.org.uk
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Export GPIO control symbols from mfp-pxa2xx.c
Message-ID: <Pine.LNX.4.64.0905110740230.7176@venus.araneidae.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With very lightweight board support providing a number of uncommitted GPIO 
pins I found that my out of kernel driver needs to call symbols that 
aren't actually exported.  This patch adds these exports.


Date: Wed, 6 May 2009 12:47:22 +0100
Subject: [PATCH] Export GPIO control symbols from mfp-pxa2xx.c

This allows modules to configure their own GPIO settings if this hasn't
been done at the board level.

Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>
---
 arch/arm/mach-pxa/mfp-pxa2xx.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-pxa/mfp-pxa2xx.c b/arch/arm/mach-pxa/mfp-pxa2xx.c
index 33626de..3f2007a 100644
--- a/arch/arm/mach-pxa/mfp-pxa2xx.c
+++ b/arch/arm/mach-pxa/mfp-pxa2xx.c
@@ -384,3 +384,8 @@ static int __init pxa2xx_mfp_init(void)
 	return sysdev_class_register(&pxa2xx_mfp_sysclass);
 }
 postcore_initcall(pxa2xx_mfp_init);
+
+
+EXPORT_SYMBOL(pxa2xx_mfp_config);
+EXPORT_SYMBOL(pxa2xx_mfp_set_lpm);
+EXPORT_SYMBOL(gpio_set_wake);
-- 
1.6.1.3

