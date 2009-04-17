Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbZDQUqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbZDQUqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 16:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756429AbZDQUqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 16:46:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:35973 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455AbZDQUqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 16:46:32 -0400
Date: Fri, 17 Apr 2009 20:46:06 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       sam@ravnborg.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, tglx@linutronix.de
In-Reply-To: <20090415234642.GA28531@uranus.ravnborg.org>
References: <20090415234642.GA28531@uranus.ravnborg.org>
Subject: [tip:x86/urgent] x86, kbuild: make "make install" not depend on vmlinux
Message-ID: <tip-1648e4f805063137b55b869666e936ffd4419cdf@git.kernel.org>
Git-Commit-ID: 1648e4f805063137b55b869666e936ffd4419cdf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 17 Apr 2009 20:46:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1648e4f805063137b55b869666e936ffd4419cdf
Gitweb:     http://git.kernel.org/tip/1648e4f805063137b55b869666e936ffd4419cdf
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 17 Apr 2009 10:46:37 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 17 Apr 2009 22:43:12 +0200

x86, kbuild: make "make install" not depend on vmlinux

It is common to use "make install" in restricted environments which
differ from the one which was actually used to build the kernel.  In
such environments it is highly undesirable to trigger a rebuild of any
part of the system.  Worse, the rebuild may be spurious, triggered by
differences in the environment.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
LKML-Reference: <20090415234642.GA28531@uranus.ravnborg.org>


---
 arch/x86/Makefile |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index f05d8c9..8c86b72 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -153,7 +153,7 @@ endif
 
 boot := arch/x86/boot
 
-BOOT_TARGETS = bzlilo bzdisk fdimage fdimage144 fdimage288 isoimage install
+BOOT_TARGETS = bzlilo bzdisk fdimage fdimage144 fdimage288 isoimage
 
 PHONY += bzImage $(BOOT_TARGETS)
 
@@ -171,6 +171,10 @@ bzImage: vmlinux
 $(BOOT_TARGETS): vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $@
 
+PHONY += install
+install:
+	$(Q)$(MAKE) $(build)=$(boot) $@
+
 PHONY += vdso_install
 vdso_install:
 	$(Q)$(MAKE) $(build)=arch/x86/vdso $@
