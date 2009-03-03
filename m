Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbZCCOhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbZCCOhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 09:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbZCCOhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 09:37:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:52144 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbZCCOhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 09:37:07 -0500
Date: Tue, 3 Mar 2009 14:36:31 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1236082212.2675.24.camel@penberg-laptop>
References: <1236082212.2675.24.camel@penberg-laptop>
Subject: [tip:x86/mm] x86: set_highmem_pages_init() cleanup, fix !CONFIG_NUMA && CONFIG_HIGHMEM=y
Message-ID: <tip-03787ceed8f7bf06af29f3b213017d89f8e9423d@git.kernel.org>
Git-Commit-ID: 03787ceed8f7bf06af29f3b213017d89f8e9423d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 03 Mar 2009 14:36:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  03787ceed8f7bf06af29f3b213017d89f8e9423d
Gitweb:     http://git.kernel.org/tip/03787ceed8f7bf06af29f3b213017d89f8e9423d
Author:     "Ingo Molnar" <mingo@elte.hu>
AuthorDate: Tue, 3 Mar 2009 15:32:24 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 3 Mar 2009 15:32:24 +0100

x86: set_highmem_pages_init() cleanup, fix !CONFIG_NUMA && CONFIG_HIGHMEM=y

Impact: build fix

 arch/x86/mm/highmem_32.c:187: error: static declaration of 'set_highmem_pages_init' follows non-static declaration
 arch/x86/include/asm/numa_32.h:8: error: previous declaration of 'set_highmem_pages_init' was here

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
LKML-Reference: <1236082212.2675.24.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/highmem_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index 13a823c..00f127c 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -183,7 +183,7 @@ void __init set_highmem_pages_init(void)
 	totalram_pages += totalhigh_pages;
 }
 #else
-static void __init set_highmem_pages_init(void)
+void __init set_highmem_pages_init(void)
 {
 	add_highpages_with_active_regions(0, highstart_pfn, highend_pfn);
 
