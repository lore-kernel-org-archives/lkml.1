Return-Path: <linux-kernel-owner+w=401wt.eu-S1762422AbYDNTUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762422AbYDNTUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 15:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbYDNTUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 15:20:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbYDNTUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 15:20:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64 vDSO: compile with -g
X-Fcc: ~/Mail/linus
X-Zippy-Says: If I pull this SWITCH I'll be RITA HAYWORTH!!  Or a SCIENTOLOGIST!
Message-Id: <20080414191930.B2D9F26FA5F@magilla.localdomain>
Date: Mon, 14 Apr 2008 12:19:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 64-bit vDSO's sources are compiled with -g0 for no good reason.
Using -g when enabled lets their separate debug files be used at
runtime via build ID matching, same as we can see 32-bit vDSO's
assembly sources.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/vdso/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 0a8f474..e5745a6 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -37,7 +37,8 @@ $(obj)/%.so: OBJCOPYFLAGS := -S
 $(obj)/%.so: $(obj)/%.so.dbg FORCE
 	$(call if_changed,objcopy)
 
-CFL := $(PROFILING) -mcmodel=small -fPIC -g0 -O2 -fasynchronous-unwind-tables -m64
+CFL := $(PROFILING) -mcmodel=small -fPIC -O2 -fasynchronous-unwind-tables -m64 \
+       $(filter -g%,$(KBUILD_CFLAGS))
 
 $(vobjs): KBUILD_CFLAGS = $(CFL)
 
