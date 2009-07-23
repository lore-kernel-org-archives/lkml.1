Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZGWS4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZGWS4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 14:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbZGWS4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 14:56:53 -0400
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:49901 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753658AbZGWS4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 14:56:52 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-ia64@vger.kernel.org
Subject: [PATCH] ia64: minor Makefile simplification through use of cc-ifversion
Date: Thu, 23 Jul 2009 20:56:50 +0200
User-Agent: KMail/1.9.9
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907232056.51064.elendil@planet.nl>
X-OriginalArrivalTime: 23 Jul 2009 18:56:51.0541 (UTC) FILETIME=[56C1A850:01CA0BC7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Frans Pop <elendil@planet.nl>
---

Change was suggested by Sam Ravnborg; see http://lkml.org/lkml/2009/7/18/15.
Untested.

diff --git a/arch/ia64/Makefile b/arch/ia64/Makefile
index 58a7e46..2bf6107 100644
--- a/arch/ia64/Makefile
+++ b/arch/ia64/Makefile
@@ -41,10 +41,8 @@ $(error Sorry, you need a newer version of the assember, one that is built from
 		ftp://ftp.hpl.hp.com/pub/linux-ia64/gas-030124.tar.gz)
 endif
 
-ifeq ($(call cc-version),0304)
-	cflags-$(CONFIG_ITANIUM)	+= -mtune=merced
-	cflags-$(CONFIG_MCKINLEY)	+= -mtune=mckinley
-endif
+cflags-$(CONFIG_ITANIUM)  += $(call cc-ifversion, -eq, 0304, -mtune=merced)
+cflags-$(CONFIG_MCKINLEY) += $(call cc-ifversion, -eq, 0304, -mtune=mckinley)
 
 KBUILD_CFLAGS += $(cflags-y)
 head-y := arch/ia64/kernel/head.o arch/ia64/kernel/init_task.o
