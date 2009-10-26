Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbZJZLjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbZJZLjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 07:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906AbZJZLjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 07:39:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:57317 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755879AbZJZLjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 07:39:46 -0400
Date: Mon, 26 Oct 2009 11:38:46 GMT
From: tip-bot for Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, rusty@rustcorp.com.au,
       arjan@infradead.org, jeremy@goop.org, tglx@linutronix.de, mingo@elte.hu,
       js@sig21.net
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, torvalds@linux-foundation.org,
       arjan@infradead.org, jeremy@goop.org, tglx@linutronix.de, mingo@elte.hu,
       js@sig21.net
In-Reply-To: <200910261426.05769.rusty@rustcorp.com.au>
References: <200910261426.05769.rusty@rustcorp.com.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Side-step lguest problem by only building cmpxchg8b_emu for pre-Pentium
Message-ID: <tip-ae1b22f6e46c03cede7cea234d0bf2253b4261cf@git.kernel.org>
Git-Commit-ID: ae1b22f6e46c03cede7cea234d0bf2253b4261cf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ae1b22f6e46c03cede7cea234d0bf2253b4261cf
Gitweb:     http://git.kernel.org/tip/ae1b22f6e46c03cede7cea234d0bf2253b4261cf
Author:     Rusty Russell <rusty@rustcorp.com.au>
AuthorDate: Mon, 26 Oct 2009 14:26:04 +1030
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 26 Oct 2009 12:33:02 +0100

x86: Side-step lguest problem by only building cmpxchg8b_emu for pre-Pentium

Commit 79e1dd05d1a22 "x86: Provide an alternative() based
cmpxchg64()" broke lguest, even on systems which have cmpxchg8b
support.  The emulation code gets used until alternatives get
run, but it contains native instructions, not their paravirt
alternatives.

The simplest fix is to turn this code off except for 386 and 486
builds.

Reported-by: Johannes Stezenbach <js@sig21.net>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: lguest@ozlabs.org
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <200910261426.05769.rusty@rustcorp.com.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig.cpu |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index f2824fb..2649840 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -400,7 +400,7 @@ config X86_TSC
 
 config X86_CMPXCHG64
 	def_bool y
-	depends on X86_PAE || X86_64 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MATOM
+	depends on !M386 && !M486
 
 # this should be set for all -march=.. options where the compiler
 # generates cmov.
