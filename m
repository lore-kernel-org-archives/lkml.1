Return-Path: <linux-kernel-owner+w=401wt.eu-S1755597AbZHDPcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbZHDPcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 11:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbZHDPco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 11:32:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:39955 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755079AbZHDPcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 11:32:43 -0400
Date: Tue, 4 Aug 2009 15:32:14 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4A71DD2A020000780000D482@vpn.id2.novell.com>
References: <4A71DD2A020000780000D482@vpn.id2.novell.com>
Subject: [tip:x86/urgent] x86, 32-bit: Fix double accounting in reserve_top_address()
Message-ID: <tip-6abf65510944d33b47575d151c6b318993c8d2b5@git.kernel.org>
Git-Commit-ID: 6abf65510944d33b47575d151c6b318993c8d2b5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 04 Aug 2009 15:32:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6abf65510944d33b47575d151c6b318993c8d2b5
Gitweb:     http://git.kernel.org/tip/6abf65510944d33b47575d151c6b318993c8d2b5
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Thu, 30 Jul 2009 16:49:30 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 4 Aug 2009 16:27:29 +0200

x86, 32-bit: Fix double accounting in reserve_top_address()

With VMALLOC_END included in the calculation of MAXMEM (as of
2.6.28) it is no longer correct to also bump __VMALLOC_RESERVE
in reserve_top_address(). Doing so results in needlessly small
lowmem.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <4A71DD2A020000780000D482@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/pgtable.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index af8f965..ed34f5e 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -329,7 +329,6 @@ void __init reserve_top_address(unsigned long reserve)
 	printk(KERN_INFO "Reserving virtual address space above 0x%08x\n",
 	       (int)-reserve);
 	__FIXADDR_TOP = -reserve - PAGE_SIZE;
-	__VMALLOC_RESERVE += reserve;
 #endif
 }
 
