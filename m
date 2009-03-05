Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbZCENmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbZCENmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453AbZCENiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:38:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:50017 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755978AbZCENiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:38:50 -0500
Date: Thu, 5 Mar 2009 13:38:18 GMT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1236257708-27269-13-git-send-email-penberg@cs.helsinki.fi>
References: <1236257708-27269-13-git-send-email-penberg@cs.helsinki.fi>
Subject: [tip:x86/mm] x86: add stub init_gbpages() for 32-bit init_memory_mapping()
Message-ID: <tip-0c0f756fd679d9747d52dad51fce3a5bb362eec3@git.kernel.org>
Git-Commit-ID: 0c0f756fd679d9747d52dad51fce3a5bb362eec3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 05 Mar 2009 13:38:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0c0f756fd679d9747d52dad51fce3a5bb362eec3
Gitweb:     http://git.kernel.org/tip/0c0f756fd679d9747d52dad51fce3a5bb362eec3
Author:     "Pekka Enberg" <penberg@cs.helsinki.fi>
AuthorDate: Thu, 5 Mar 2009 14:55:04 +0200
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 5 Mar 2009 14:17:16 +0100

x86: add stub init_gbpages() for 32-bit init_memory_mapping()

Impact: cleanup

This patch adds an empty static inline init_gbpages() for the 32-bit
version of init_memory_mapping() making both versions identical.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <1236257708-27269-13-git-send-email-penberg@cs.helsinki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init_32.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index f59e9b8..cd3c24b 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -922,6 +922,10 @@ static int save_mr(struct map_range *mr, int nr_range,
 	return nr_range;
 }
 
+static inline void init_gbpages(void)
+{
+}
+
 /*
  * Setup the direct mapping of the physical memory at PAGE_OFFSET.
  * This runs before bootmem is initialized and gets pages directly from
@@ -941,6 +945,9 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 
 	printk(KERN_INFO "init_memory_mapping: %016lx-%016lx\n", start, end);
 
+	if (!after_bootmem)
+		init_gbpages();
+
 #ifdef CONFIG_DEBUG_PAGEALLOC
 	/*
 	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
