Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417Ab0ARVTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab0ARVTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 16:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320Ab0ARVTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 16:19:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:52559 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085Ab0ARVTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 16:19:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,298,1262592000"; 
   d="scan'208";a="588201434"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, alan@linux.intel.com,
       charles.f.johnson@intel.com
Cc: Mark Allyn <mark.a.allyn@intel.com>
Subject: [PATCH] Remove cflags from Makefile and fix Kconfig
Date: Mon, 18 Jan 2010 13:22:54 -0800
Message-Id: <1263849774-23152-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes bothe the Makefile and the Kconfig file

This is the fourth of seven patches for the rar_register driver
for Sunday, January 17, 2009

The rar stands for restricted access region. The restricted access
region is an area of memory that can be locked from access by the
x86 processor.

The purpose of the restricted access region is to safeguard confidential
information from any unauthorized software running on the x86 processor.

The purpose of this driver is to enable other drivers to obtain
the address ranges of the restricted regions as well as lock them.

This patch is referenced off the linux-next repository as pulled
on Sunday, January 17, 2010

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>

Date: January 17, 2010
---
 drivers/staging/rar/Kconfig  |    8 ++++++--
 drivers/staging/rar/Makefile |    1 -
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rar/Kconfig b/drivers/staging/rar/Kconfig
index 17f8bf3..e923178 100644
--- a/drivers/staging/rar/Kconfig
+++ b/drivers/staging/rar/Kconfig
@@ -8,10 +8,14 @@ menu "RAR Register Driver"
 #
 config RAR_REGISTER
 	tristate "Restricted Access Region Register Driver"
-	default n
 	---help---
 		This driver allows other kernel drivers access to the
 		contents of the restricted access region control
-		registers.
+		registers. The restricted access regions are areas
+		of memory on the Intel ultra mobile platform which the
+		x86 processor (and software running thereupon) cannot
+		access for reading or writing. It is used the protect
+		sensitive information from unauthorized programms running
+		on the x86 processor.
 
 endmenu
diff --git a/drivers/staging/rar/Makefile b/drivers/staging/rar/Makefile
index d5954cc..7f1478b 100644
--- a/drivers/staging/rar/Makefile
+++ b/drivers/staging/rar/Makefile
@@ -1,2 +1 @@
-EXTRA_CFLAGS += -DLITTLE__ENDIAN
 obj-$(CONFIG_RAR_REGISTER) += rar_register.o
-- 
1.6.0.6

