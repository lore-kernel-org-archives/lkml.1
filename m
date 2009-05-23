Return-Path: <linux-kernel-owner+w=401wt.eu-S1757029AbZEWXim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029AbZEWXim (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 19:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbZEWXif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 19:38:35 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:42637 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468AbZEWXie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 19:38:34 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@suse.de>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] fix detection of CONFIG_FRAME_WARN=0
Date: Sat, 23 May 2009 19:38:35 -0400
Message-Id: <1243121915-10775-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The checking of CONFIG_FRAME_WARN in the top level Makefile forgot to
actually derefence the variable thus leading to an always true check.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
CC: Andi Kleen <ak@suse.de>
CC: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 739fd34..47c8d11 100644
--- a/Makefile
+++ b/Makefile
@@ -533,7 +533,7 @@ endif
 
 include $(srctree)/arch/$(SRCARCH)/Makefile
 
-ifneq (CONFIG_FRAME_WARN,0)
+ifneq ($(CONFIG_FRAME_WARN),0)
 KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
 endif
 
-- 
1.6.3

