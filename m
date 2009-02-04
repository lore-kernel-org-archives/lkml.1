Return-Path: <linux-kernel-owner+w=401wt.eu-S1752467AbZBDPIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbZBDPIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 10:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbZBDPIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 10:08:37 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:60206 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751755AbZBDPIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 10:08:36 -0500
Date: Wed, 4 Feb 2009 18:08:35 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: [PATCH 1/3] Makefile: Include arch Makefiles as late as possible
Message-ID: <20090204150835.GA30027@oksana.dev.rtsoft.ru>
References: <20090204150755.GA24163@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090204150755.GA24163@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch gives arches more freedom on overwriting CFLAGS, specifically
on PowerPC we want to remove -fno-omit-frame-pointer flag.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 7715b2c..d1ba93f 100644
--- a/Makefile
+++ b/Makefile
@@ -525,8 +525,6 @@ else
 KBUILD_CFLAGS	+= -O2
 endif
 
-include $(srctree)/arch/$(SRCARCH)/Makefile
-
 ifneq (CONFIG_FRAME_WARN,0)
 KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
 endif
@@ -555,6 +553,8 @@ ifdef CONFIG_DEBUG_SECTION_MISMATCH
 KBUILD_CFLAGS += $(call cc-option, -fno-inline-functions-called-once)
 endif
 
+include $(srctree)/arch/$(SRCARCH)/Makefile
+
 # arch Makefile may override CC so keep this after arch Makefile is included
 NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)
 CHECKFLAGS     += $(NOSTDINC_FLAGS)
-- 
1.5.6.5

