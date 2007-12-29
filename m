Return-Path: <linux-kernel-owner+w=401wt.eu-S1755998AbXL2Ul4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbXL2Ul4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 15:41:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbXL2UlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 15:41:20 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:44553 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbXL2UlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 15:41:18 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@saturn.ravnborg.org>, Sam Ravnborg <sam@ravnborg.org>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 4/5] x86: teach vdso to clean
Date: Sat, 29 Dec 2007 21:41:15 +0100
Message-Id: <1198960876-21159-4-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <1198960876-21159-3-git-send-email-sam@ravnborg.org>
References: <20071229203836.GA21020@uranus.ravnborg.org>
 <1198960876-21159-1-git-send-email-sam@ravnborg.org>
 <1198960876-21159-2-git-send-email-sam@ravnborg.org>
 <1198960876-21159-3-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@saturn.ravnborg.org>

A few files remained after 'make clean' in arch/x86/vdso/.
Teach vdso to clean up those files in a bit brutal fashion.
The filenames are just hardcoded in the Makefile.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/vdso/Makefile |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 58708f6..b23120d 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -130,3 +130,6 @@ $(vdso-install-y): %.so: $(obj)/%.so.dbg FORCE
 
 PHONY += vdso_install $(vdso-install-y)
 vdso_install: $(vdso-install-y)
+
+clean-dirs  := vdso32
+clean-files := vdso32-syscall* vdso32-sysenter* vdso32-int80*
-- 
1.5.3.7.1112.g9758e

