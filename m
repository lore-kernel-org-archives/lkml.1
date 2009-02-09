Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbZBINnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbZBINnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756059AbZBINk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:40:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:37873 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755734AbZBINk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:40:57 -0500
From: Tejun Heo <tj@kernel.org>
To: hpa@zytor.com, jeremy@goop.org, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/11] x86: no stack protector for vdso
Date: Mon,  9 Feb 2009 22:39:54 +0900
Message-Id: <1234186798-16820-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1234186798-16820-1-git-send-email-tj@kernel.org>
References: <1234186798-16820-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 09 Feb 2009 13:40:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: avoid crash on vsyscall

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/vdso/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 4d6ef0a..16a9020 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -38,7 +38,7 @@ $(obj)/%.so: $(obj)/%.so.dbg FORCE
 	$(call if_changed,objcopy)
 
 CFL := $(PROFILING) -mcmodel=small -fPIC -O2 -fasynchronous-unwind-tables -m64 \
-       $(filter -g%,$(KBUILD_CFLAGS))
+       $(filter -g%,$(KBUILD_CFLAGS)) $(call cc-option, -fno-stack-protector)
 
 $(vobjs): KBUILD_CFLAGS += $(CFL)
 
-- 
1.6.0.2

