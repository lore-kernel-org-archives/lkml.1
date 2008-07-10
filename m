Return-Path: <linux-kernel-owner+w=401wt.eu-S1755864AbYGJMh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbYGJMh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 08:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbYGJMht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 08:37:49 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:41933 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbYGJMhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 08:37:48 -0400
Date: Thu, 10 Jul 2008 20:34:46 +0800
From: Joe Jin <joe.jin@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <andi@firstfloor.org>
Cc: greg.marsden@oracle.com, tao.ma@oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64: reserve crashkernel bootmem before reserve dma32 bootmem
Message-ID: <20080710123446.GA1595@joejin-pc.cn.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before reserve_crashkernel, dma32_reserve_bootmem would reserve 128M memory.
this cuased crashkernel end address must less than 64M or start address must
more than 192M except crashkernel memory reserved before dma32 memory reserved.

This patch against 2.6.26-rc9

Signed-off-by: Joe Jin <joe.jin@oracle.com>
---
 setup_64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.26-rc9/arch/x86/kernel/setup_64.c.orig	2008-07-10 16:34:12.000000000 +0800
+++ linux-2.6.26-rc9/arch/x86/kernel/setup_64.c	2008-07-10 16:35:00.000000000 +0800
@@ -444,8 +444,6 @@ void __init setup_arch(char **cmdline_p)
 	contig_initmem_init(0, end_pfn);
 #endif
 
-	dma32_reserve_bootmem();
-
 #ifdef CONFIG_ACPI_SLEEP
 	/*
 	 * Reserve low memory region for sleep support.
@@ -486,6 +484,8 @@ void __init setup_arch(char **cmdline_p)
 #endif
 	reserve_crashkernel();
 
+	dma32_reserve_bootmem();
+
 	reserve_ibft_region();
 
 	paging_init();

