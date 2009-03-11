Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZCKV6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZCKV6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 17:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbZCKV6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 17:58:03 -0400
Received: from smtp110.biz.mail.mud.yahoo.com ([68.142.201.179]:33613 "HELO
	smtp110.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754200AbZCKV6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 17:58:01 -0400
X-Yahoo-SMTP: Y9aU0H6swBAqsiryRZEA7xtDWlgllPfq7He2xMk-
X-YMail-OSG: TLPfNPUVM1ka3XNBqbGVOsVbh2CF1TtRJ7Zaeqfv2ANWrdNFw467rlo3._1qhA.pmeJGz3nfvKotpX8vGBMqybHgb5VI8cW9d9o28M2GeL3wO2I9se2ybqkDSzBpCaMDm0qZascn2jiuq9xPUd21_G2xuJLsMxNTZanBqdvyya8dPPH9uAvNSEJgJJE_OTLWvpaaQz5nL9ROLVB6aOGRIO9LPfSshR6DBMXcooxaOJdbjoM-
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
To: uClinux development list <uclinux-dev@uclinux.org>
Subject: [RFC 02/14] Coldfire generic GPIO (m68knommu)
Date: Wed, 11 Mar 2009 13:55:46 -0800
User-Agent: KMail/1.9.10
Organization: fdwdc.com
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@snapgear.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200903111455.46718.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Steven King <sfking@fdwdc.com>

diff --git a/arch/m68knommu/Kconfig b/arch/m68knommu/Kconfig
index 4beb59d..0eb0302 100644
--- a/arch/m68knommu/Kconfig
+++ b/arch/m68knommu/Kconfig
@@ -46,6 +46,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_GPIO
+	bool
+	default n
+
 config GENERIC_HWEIGHT
 	bool
 	default y
@@ -181,6 +185,8 @@ config M527x
 config COLDFIRE
 	bool
 	depends on (M5206 || M5206e || M520x || M523x || M5249 || M527x || M5272 || 
M528x || M5307 || M532x || M5407)
+	select GENERIC_GPIO
+	select ARCH_REQUIRE_GPIOLIB
 	default y
 
 config CLOCK_SET
diff --git a/arch/m68knommu/platform/coldfire/Makefile 
b/arch/m68knommu/platform/coldfire/Makefile
index 4f416a9..25de150 100644
--- a/arch/m68knommu/platform/coldfire/Makefile
+++ b/arch/m68knommu/platform/coldfire/Makefile
@@ -27,4 +27,5 @@ obj-$(CONFIG_M5307)	+= timers.o
 obj-$(CONFIG_M532x)	+= timers.o
 obj-$(CONFIG_M5407)	+= timers.o
 
+obj-y			+= pinmux.o gpio.o
 extra-y := head.o

