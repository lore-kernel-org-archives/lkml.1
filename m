Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbZCFP2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbZCFP2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754390AbZCFP2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:28:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:45126 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888AbZCFP2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:28:02 -0500
Date: Fri, 6 Mar 2009 15:27:27 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1236265498.31324.12.camel@penberg-laptop>
References: <1236265498.31324.12.camel@penberg-laptop>
Subject: [tip:x86/mm] x86: unify noexec handling, fix
Message-ID: <tip-b517d59e8e80c506c0809d76dbec8354b7de6c5c@git.kernel.org>
Git-Commit-ID: b517d59e8e80c506c0809d76dbec8354b7de6c5c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 06 Mar 2009 15:27:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b517d59e8e80c506c0809d76dbec8354b7de6c5c
Gitweb:     http://git.kernel.org/tip/b517d59e8e80c506c0809d76dbec8354b7de6c5c
Author:     "Ingo Molnar" <mingo@elte.hu>
AuthorDate: Fri, 6 Mar 2009 15:37:07 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 6 Mar 2009 16:25:00 +0100

x86: unify noexec handling, fix

Impact: build fix

Move the nx_enabled variable to mm/init.c too.

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
LKML-Reference: <1236265498.31324.12.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init.c    |    2 ++
 arch/x86/mm/init_32.c |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index e7d8bb5..4b799e8 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -22,6 +22,8 @@ int direct_gbpages
 #endif
 ;
 
+int nx_enabled;
+
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
 static int disable_nx __initdata;
 
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 8ff1173..07bfd60 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -587,8 +587,6 @@ void zap_low_mappings(void)
 	flush_tlb_all();
 }
 
-int nx_enabled;
-
 pteval_t __supported_pte_mask __read_mostly = ~(_PAGE_NX | _PAGE_GLOBAL | _PAGE_IOMAP);
 EXPORT_SYMBOL_GPL(__supported_pte_mask);
 
