Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945AbZLBKqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbZLBKqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 05:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZLBKqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 05:46:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:45044 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005AbZLBKqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 05:46:17 -0500
Date: Wed, 2 Dec 2009 10:45:50 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4B0FF8AA0200007800022703@vpn.id2.novell.com>
References: <4B0FF8AA0200007800022703@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86/alternatives: Check replacementlen <= instrlen at build time
Message-ID: <tip-01be50a308be466e122c3a8b3d535f1b673ecbd2@git.kernel.org>
Git-Commit-ID: 01be50a308be466e122c3a8b3d535f1b673ecbd2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  01be50a308be466e122c3a8b3d535f1b673ecbd2
Gitweb:     http://git.kernel.org/tip/01be50a308be466e122c3a8b3d535f1b673ecbd2
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Fri, 27 Nov 2009 15:04:58 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 2 Dec 2009 11:39:45 +0100

x86/alternatives: Check replacementlen <= instrlen at build time

Having run into the run-(boot-)time check a couple of times lately,
I finally took time to find a build-time check so that one doesn't
need to analyze the register/stack dump and resolve this (through
manual lookup in vmlinux) to the offending construct.

The assembler will emit a message like "Error: value of <num> too
large for field of 1 bytes at <offset>", which while not pointing
out the source location still makes analysis quite a bit easier.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <4B0FF8AA0200007800022703@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/alternative.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index c240efc..69b74a7 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -84,6 +84,7 @@ static inline void alternatives_smp_switch(int smp) {}
       "	 .byte " __stringify(feature) "\n"	/* feature bit     */	\
       "	 .byte 662b-661b\n"			/* sourcelen       */	\
       "	 .byte 664f-663f\n"			/* replacementlen  */	\
+      "	 .byte 0xff + (664f-663f) - (662b-661b)\n" /* rlen <= slen */	\
       ".previous\n"							\
       ".section .altinstr_replacement, \"ax\"\n"			\
       "663:\n\t" newinstr "\n664:\n"		/* replacement     */	\
