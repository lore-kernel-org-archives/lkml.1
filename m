Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbZCFO3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbZCFO3b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 09:29:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbZCFO2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 09:28:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:42125 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167AbZCFO2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 09:28:43 -0500
Date: Fri, 6 Mar 2009 14:28:01 GMT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1236266541.31324.14.camel@penberg-laptop>
References: <1236266541.31324.14.camel@penberg-laptop>
Subject: [tip:x86/mm] x86: init_memory_mapping() PSE and PGE setup ifdef removal
Message-ID: <tip-ac4d3bfdd9e27bfcc0b016c7ac364acb166455a1@git.kernel.org>
Git-Commit-ID: ac4d3bfdd9e27bfcc0b016c7ac364acb166455a1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 06 Mar 2009 14:28:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ac4d3bfdd9e27bfcc0b016c7ac364acb166455a1
Gitweb:     http://git.kernel.org/tip/ac4d3bfdd9e27bfcc0b016c7ac364acb166455a1
Author:     "Pekka Enberg" <penberg@cs.helsinki.fi>
AuthorDate: Thu, 5 Mar 2009 17:22:21 +0200
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 6 Mar 2009 15:25:53 +0100

x86: init_memory_mapping() PSE and PGE setup ifdef removal

Impact: cleanup

Section 3.10 ("PAE-Enabled Paging in IA-32e Mode") of the Intel manual
states that The CR4.PSE bit is ignored in IA-32e mode. In 64-bit mode,
PGE is enabled at early boot so there's no need to hide setting them up
in an ifdef.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
LKML-Reference: <1236266541.31324.14.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 5d06d25..e7d8bb5 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -223,7 +223,6 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	if (nx_enabled)
 		printk(KERN_INFO "NX (Execute Disable) protection: active\n");
 
-#ifdef CONFIG_X86_32
 	/* Enable PSE if available */
 	if (cpu_has_pse)
 		set_in_cr4(X86_CR4_PSE);
@@ -233,7 +232,6 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 		set_in_cr4(X86_CR4_PGE);
 		__supported_pte_mask |= _PAGE_GLOBAL;
 	}
-#endif
 
 	if (use_gbpages)
 		page_size_mask |= 1 << PG_LEVEL_1G;
