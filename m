Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbZITSbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbZITSbQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755420AbZITSbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:31:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:52200 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471AbZITSap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:30:45 -0400
Date: Sun, 20 Sep 2009 18:30:06 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4AA0E95F0200007800013707@vpn.id2.novell.com>
References: <4AA0E95F0200007800013707@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Correct segment permission flags in 64-bit linker script
Message-ID: <tip-8d0cc631f6dd0a9283ceb7d61d8b85ecbcd355ea@git.kernel.org>
Git-Commit-ID: 8d0cc631f6dd0a9283ceb7d61d8b85ecbcd355ea
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 20 Sep 2009 18:30:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d0cc631f6dd0a9283ceb7d61d8b85ecbcd355ea
Gitweb:     http://git.kernel.org/tip/8d0cc631f6dd0a9283ceb7d61d8b85ecbcd355ea
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Fri, 4 Sep 2009 09:18:07 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 20 Sep 2009 20:23:47 +0200

x86: Correct segment permission flags in 64-bit linker script

While these don't get actively used (afaict), it still doesn't hurt
for them to properly reflect what how respective segments will get
mapped/ accessed.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <4AA0E95F0200007800013707@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/vmlinux.lds.S |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 0ccb57d..a46accc 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -45,9 +45,9 @@ PHDRS {
 	text PT_LOAD FLAGS(5);          /* R_E */
 	data PT_LOAD FLAGS(7);          /* RWE */
 #ifdef CONFIG_X86_64
-	user PT_LOAD FLAGS(7);          /* RWE */
+	user PT_LOAD FLAGS(5);          /* R_E */
 #ifdef CONFIG_SMP
-	percpu PT_LOAD FLAGS(7);        /* RWE */
+	percpu PT_LOAD FLAGS(6);        /* RW_ */
 #endif
 	init PT_LOAD FLAGS(7);          /* RWE */
 #endif
