Return-Path: <linux-kernel-owner+w=401wt.eu-S1754371AbZGWS5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbZGWS5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 14:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbZGWS5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 14:57:53 -0400
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:52805 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754196AbZGWS5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 14:57:52 -0400
From: Frans Pop <elendil@planet.nl>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH] um: minor Makefile simplification through use of cc-ifversion
Date: Thu, 23 Jul 2009 20:57:51 +0200
User-Agent: KMail/1.9.9
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907232057.51827.elendil@planet.nl>
X-OriginalArrivalTime: 23 Jul 2009 18:57:52.0343 (UTC) FILETIME=[7AFF4E70:01CA0BC7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Frans Pop <elendil@planet.nl>
---

Change was suggested by Sam Ravnborg; see http://lkml.org/lkml/2009/7/18/15.
Untested, but a similar patch for x86 was tested to work.

diff --git a/arch/um/Makefile-i386 b/arch/um/Makefile-i386
index 302cbe5..2c3e658 100644
--- a/arch/um/Makefile-i386
+++ b/arch/um/Makefile-i386
@@ -35,8 +35,9 @@ cflags-y += -ffreestanding
 # Disable unit-at-a-time mode on pre-gcc-4.0 compilers, it makes gcc use
 # a lot more stack due to the lack of sharing of stacklots.  Also, gcc
 # 4.3.0 needs -funit-at-a-time for extern inline functions.
-KBUILD_CFLAGS += $(shell if [ $(call cc-version) -lt 0400 ] ; then \
-			echo $(call cc-option,-fno-unit-at-a-time); \
-			else echo $(call cc-option,-funit-at-a-time); fi ;)
+KBUILD_CFLAGS += $(call cc-ifversion, -lt, 0400, \
+			$(call cc-option,-fno-unit-at-a-time))
+KBUILD_CFLAGS += $(call cc-ifversion, -ge, 0400, \
+			$(call cc-option,-funit-at-a-time))
 
 KBUILD_CFLAGS += $(cflags-y)
