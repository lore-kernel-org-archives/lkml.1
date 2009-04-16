Return-Path: <linux-kernel-owner+w=401wt.eu-S1758982AbZDPUFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982AbZDPUFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 16:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757934AbZDPUF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 16:05:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:36683 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757942AbZDPUF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 16:05:28 -0400
Subject: [PATCH -tip] x86: mm/numa_32.c calculate_numa_remap_pages should
 use __init
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 01:34:03 +0530
Message-Id: <1239912243.10567.10.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix Section mismatch warnings
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

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
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
-- 
1.6.0.6



