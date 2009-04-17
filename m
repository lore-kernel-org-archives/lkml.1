Return-Path: <linux-kernel-owner+w=401wt.eu-S1758279AbZDQUrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279AbZDQUrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 16:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757267AbZDQUqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 16:46:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:35982 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757445AbZDQUqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 16:46:48 -0400
Date: Fri, 17 Apr 2009 20:46:18 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       sam@ravnborg.org, jaswinder@kernel.org, jaswinderrajput@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, jaswinder@kernel.org, jaswinderrajput@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1239991281.3153.4.camel@ht.satnam>
References: <1239991281.3153.4.camel@ht.satnam>
Subject: [tip:x86/urgent] x86: mm/numa_32.c calculate_numa_remap_pages should use __init
Message-ID: <tip-a81b6314e0aa480b8ac6dd02779d44cd0bee0a34@git.kernel.org>
Git-Commit-ID: a81b6314e0aa480b8ac6dd02779d44cd0bee0a34
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 17 Apr 2009 20:46:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a81b6314e0aa480b8ac6dd02779d44cd0bee0a34
Gitweb:     http://git.kernel.org/tip/a81b6314e0aa480b8ac6dd02779d44cd0bee0a34
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Fri, 17 Apr 2009 23:31:20 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 17 Apr 2009 22:43:13 +0200

x86: mm/numa_32.c calculate_numa_remap_pages should use __init

calculate_numa_remap_pages() is called only by __init initmem_init()
further calculate_numa_remap_pages is calling:
	__init find_e820_area() and __init reserve_early()

So calculate_numa_remap_pages() should be __init calculate_numa_remap_pages().

 WARNING: arch/x86/built-in.o(.text+0x82ea3): Section mismatch in reference from the function calculate_numa_remap_pages() to the function .init.text:find_e820_area()
 The function calculate_numa_remap_pages() references
 the function __init find_e820_area().
 This is often because calculate_numa_remap_pages lacks a __init
 annotation or the annotation of find_e820_area is wrong.

 WARNING: arch/x86/built-in.o(.text+0x82f5f): Section mismatch in reference from the function calculate_numa_remap_pages() to the function .init.text:reserve_early()
 The function calculate_numa_remap_pages() references
 the function __init reserve_early().
 This is often because calculate_numa_remap_pages lacks a __init
 annotation or the annotation of reserve_early is wrong.

[ Impact: save memory, address Section mismatch warning ]

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
LKML-Reference: <1239991281.3153.4.camel@ht.satnam>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/numa_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 3daefa0..d253006 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -257,7 +257,7 @@ void resume_map_numa_kva(pgd_t *pgd_base)
 }
 #endif
 
-static unsigned long calculate_numa_remap_pages(void)
+static __init unsigned long calculate_numa_remap_pages(void)
 {
 	int nid;
 	unsigned long size, reserve_pages = 0;
