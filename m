Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbZCFOnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbZCFOnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 09:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbZCFOnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 09:43:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:51055 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbZCFOnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 09:43:01 -0500
Date: Fri, 6 Mar 2009 14:42:26 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1236265498.31324.12.camel@penberg-laptop>
References: <1236265498.31324.12.camel@penberg-laptop>
Subject: [tip:x86/mm] x86: unify noexec handling, fix
Message-ID: <tip-4b809e98a7f9d88e2cb9574f41efa015844c1470@git.kernel.org>
Git-Commit-ID: 4b809e98a7f9d88e2cb9574f41efa015844c1470
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 06 Mar 2009 14:42:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4b809e98a7f9d88e2cb9574f41efa015844c1470
Gitweb:     http://git.kernel.org/tip/4b809e98a7f9d88e2cb9574f41efa015844c1470
Author:     "Ingo Molnar" <mingo@elte.hu>
AuthorDate: Fri, 6 Mar 2009 15:37:07 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 6 Mar 2009 15:37:07 +0100

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
index e7d8bb5..75e3825 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -25,6 +25,8 @@ int direct_gbpages
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
 static int disable_nx __initdata;
 
+int nx_enabled;
+
 /*
  * noexec = on|off
  *
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
 
