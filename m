Return-Path: <linux-kernel-owner+w=401wt.eu-S1762279AbZDQRwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762279AbZDQRwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 13:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760575AbZDQRwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 13:52:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:53235 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759075AbZDQRwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 13:52:11 -0400
Date: Fri, 17 Apr 2009 17:51:37 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       sam@ravnborg.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, tglx@linutronix.de
In-Reply-To: <20090415234642.GA28531@uranus.ravnborg.org>
References: <20090415234642.GA28531@uranus.ravnborg.org>
Subject: [tip:x86/urgent] x86, kbuild: make "make install" not depend on vmlinux
Message-ID: <tip-e56cb7f5e74af194585be4a2a6fc55a88f5be3ad@git.kernel.org>
Git-Commit-ID: e56cb7f5e74af194585be4a2a6fc55a88f5be3ad
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 17 Apr 2009 17:51:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e56cb7f5e74af194585be4a2a6fc55a88f5be3ad
Gitweb:     http://git.kernel.org/tip/e56cb7f5e74af194585be4a2a6fc55a88f5be3ad
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 17 Apr 2009 10:46:37 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 17 Apr 2009 10:46:37 -0700

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
