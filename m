Return-Path: <linux-kernel-owner+w=401wt.eu-S932386AbZHDO3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386AbZHDO3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932347AbZHDO3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:29:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:57767 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492AbZHDO3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:29:14 -0400
Message-Id: <20090804142709.911355735@suse.com>
User-Agent: quilt/0.47-14.9
Date: Tue, 04 Aug 2009 10:26:19 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: Greg KH <gregkh@suse.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 1/5] rtl8192su: compile fixes
References: <20090804142618.455591385@suse.com>
Content-Disposition: inline; filename=patches.rpmify/rtl8192su-kill-fp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch removes -fhard-float and the software float helpers. In-kernel
 floating point is not allowed.

Acked-by: Jeff Mahoney <jeffm@suse.com>
---
 drivers/staging/rtl8192su/Makefile      |    1 -
 drivers/staging/rtl8192su/r8192U_core.c |   22 ++++++++--------------
 2 files changed, 8 insertions(+), 15 deletions(-)

--- a/drivers/staging/rtl8192su/Makefile
+++ b/drivers/staging/rtl8192su/Makefile
@@ -2,7 +2,6 @@ NIC_SELECT = RTL8192SU
 
 EXTRA_CFLAGS += -std=gnu89
 EXTRA_CFLAGS += -O2
-EXTRA_CFLAGS += -mhard-float -DCONFIG_FORCE_HARD_FLOAT=y
 
 EXTRA_CFLAGS += -DJACKSON_NEW_RX
 EXTRA_CFLAGS += -DTHOMAS_BEACON -DTHOMAS_TURBO
--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -24,14 +24,6 @@
  * Jerry chuang <wlanfae@realtek.com>
  */
 
-#ifndef CONFIG_FORCE_HARD_FLOAT
-double __floatsidf (int i) { return i; }
-unsigned int __fixunsdfsi (double d) { return d; }
-double __adddf3(double a, double b) { return a+b; }
-double __addsf3(float a, float b) { return a+b; }
-double __subdf3(double a, double b) { return a-b; }
-double __extendsfdf2(float a) {return a;}
-#endif
 
 #undef LOOP_TEST
 #undef DUMP_RX


