Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636Ab0AEEtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab0AEEtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 23:49:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280Ab0AEEtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 23:49:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:43734 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945Ab0AEEtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 23:49:09 -0500
Date: Tue, 5 Jan 2010 04:48:39 GMT
From: tip-bot for Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rusty@rustcorp.com.au, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, tglx@linutronix.de
In-Reply-To: <201001051248.49700.rusty@rustcorp.com.au>
References: <201001051248.49700.rusty@rustcorp.com.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] Revert "x86: Side-step lguest problem by only building cmpxchg8b_emu for pre-Pentium"
Message-ID: <tip-f4b825bde98938f160315d655597bc9731521cae@git.kernel.org>
Git-Commit-ID: f4b825bde98938f160315d655597bc9731521cae
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f4b825bde98938f160315d655597bc9731521cae
Gitweb:     http://git.kernel.org/tip/f4b825bde98938f160315d655597bc9731521cae
Author:     Rusty Russell <rusty@rustcorp.com.au>
AuthorDate: Tue, 5 Jan 2010 12:48:49 +1030
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 4 Jan 2010 19:35:49 -0800

Revert "x86: Side-step lguest problem by only building cmpxchg8b_emu for pre-Pentium"

This reverts commit ae1b22f6e46c03cede7cea234d0bf2253b4261cf.

As Linus said in 982d007a6ee: "There was something really messy about
cmpxchg8b and clone CPU's, so if you enable it on other CPUs later, do it
carefully."

This breaks lguest for those configs, but we can fix that by emulating
if we have to.

Fixes: http://bugzilla.kernel.org/show_bug.cgi?id=14884
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
LKML-Reference: <201001051248.49700.rusty@rustcorp.com.au>
Cc: stable@kernel.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/Kconfig.cpu |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 08e442b..f20ddf8 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -396,7 +396,7 @@ config X86_TSC
 
 config X86_CMPXCHG64
 	def_bool y
-	depends on !M386 && !M486
+	depends on X86_PAE || X86_64 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MATOM
 
 # this should be set for all -march=.. options where the compiler
 # generates cmov.
