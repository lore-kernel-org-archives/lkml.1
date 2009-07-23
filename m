Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbZGWS5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbZGWS5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 14:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbZGWS5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 14:57:21 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:55350 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752434AbZGWS5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 14:57:20 -0400
From: Frans Pop <elendil@planet.nl>
To: linuxppc-dev@ozlabs.org
Subject: [PATCH] powerpc: minor Makefile simplification through use of cc-ifversion
Date: Thu, 23 Jul 2009 20:57:18 +0200
User-Agent: KMail/1.9.9
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907232057.19942.elendil@planet.nl>
X-OriginalArrivalTime: 23 Jul 2009 18:57:20.0601 (UTC) FILETIME=[6813DC90:01CA0BC7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Frans Pop <elendil@planet.nl>
---

Change was suggested by Sam Ravnborg; see http://lkml.org/lkml/2009/7/18/15.
Untested.

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index bc35f4e..952a396 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -77,7 +77,7 @@ CPP		= $(CC) -E $(KBUILD_CFLAGS)
 CHECKFLAGS	+= -m$(CONFIG_WORD_SIZE) -D__powerpc__ -D__powerpc$(CONFIG_WORD_SIZE)__
 
 ifeq ($(CONFIG_PPC64),y)
-GCC_BROKEN_VEC	:= $(shell if [ $(call cc-version) -lt 0400 ] ; then echo "y"; fi)
+GCC_BROKEN_VEC	:= $(call cc-ifversion, -lt, 0400, y)
 
 ifeq ($(CONFIG_POWER4_ONLY),y)
 ifeq ($(CONFIG_ALTIVEC),y)
