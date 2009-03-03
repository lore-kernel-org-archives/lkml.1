Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbZCCLKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbZCCLKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 06:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbZCCLKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 06:10:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:59557 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbZCCLKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 06:10:07 -0500
Date: Tue, 3 Mar 2009 11:09:35 GMT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1236077704.2675.4.camel@penberg-laptop>
References: <1236077704.2675.4.camel@penberg-laptop>
Subject: [tip:x86/mm] x86: move __VMALLOC_RESERVE to pgtable_32.c
Message-ID: <tip-2b688dfd0a93cf3b17c38feef693361da47b0606@git.kernel.org>
Git-Commit-ID: 2b688dfd0a93cf3b17c38feef693361da47b0606
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 03 Mar 2009 11:09:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2b688dfd0a93cf3b17c38feef693361da47b0606
Gitweb:     http://git.kernel.org/tip/2b688dfd0a93cf3b17c38feef693361da47b0606
Author:     "Pekka Enberg" <penberg@cs.helsinki.fi>
AuthorDate: Tue, 3 Mar 2009 12:55:04 +0200
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 3 Mar 2009 12:06:59 +0100

x86: move __VMALLOC_RESERVE to pgtable_32.c

Impact: cleanup

The __VMALLOC_RESERVE global variable is not used in init_32.c. Move that to
pgtable_32.c to reduce the diff between init_32.c and init_64.c.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
LKML-Reference: <1236077704.2675.4.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init_32.c    |    2 --
 arch/x86/mm/pgtable_32.c |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 06708ee..5b06a2f 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -50,8 +50,6 @@
 #include <asm/setup.h>
 #include <asm/cacheflush.h>
 
-unsigned int __VMALLOC_RESERVE = 128 << 20;
-
 unsigned long max_low_pfn_mapped;
 unsigned long max_pfn_mapped;
 
diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
index 0951db9..e4032c8 100644
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -20,6 +20,8 @@
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
 
+unsigned int __VMALLOC_RESERVE = 128 << 20;
+
 /*
  * Associate a virtual page frame with a given physical page frame 
  * and protection flags for that frame.
