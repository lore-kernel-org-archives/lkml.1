Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbZGWS4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbZGWS4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 14:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbZGWS4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 14:56:30 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:57411 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752434AbZGWS43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 14:56:29 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: minor Makefile simplification through use of cc-ifversion
Date: Thu, 23 Jul 2009 20:56:27 +0200
User-Agent: KMail/1.9.9
Cc: linux-kbuild@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, x86@kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907232056.28635.elendil@planet.nl>
X-OriginalArrivalTime: 23 Jul 2009 18:56:29.0191 (UTC) FILETIME=[496F5170:01CA0BC7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Frans Pop <elendil@planet.nl>
---

Change was suggested by Sam Ravnborg; see http://lkml.org/lkml/2009/7/18/15.
Tested to work correctly.

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 1b68659..1f3851a 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -32,8 +32,8 @@ ifeq ($(CONFIG_X86_32),y)
 
         # Disable unit-at-a-time mode on pre-gcc-4.0 compilers, it makes gcc use
         # a lot more stack due to the lack of sharing of stacklots:
-        KBUILD_CFLAGS += $(shell if [ $(call cc-version) -lt 0400 ] ; then \
-                echo $(call cc-option,-fno-unit-at-a-time); fi ;)
+        KBUILD_CFLAGS += $(call cc-ifversion, -lt, 0400, \
+				$(call cc-option,-fno-unit-at-a-time))
 
         # CPU-specific tuning. Anything which can be shared with UML should go here.
         include $(srctree)/arch/x86/Makefile_32.cpu
