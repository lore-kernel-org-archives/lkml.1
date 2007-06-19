Return-Path: <linux-kernel-owner+w=401wt.eu-S1761147AbXFSWxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761147AbXFSWxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 18:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759265AbXFSWw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 18:52:28 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:54854 "EHLO
	outbound8-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761193AbXFSWw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 18:52:26 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Wed, 20 Jun 2007 00:51:45 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 10/12] SLOB: fix build error if SLOB && !NUMA
Message-ID: <20070619225145.GL5193@alberich.amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Jun 2007 22:50:48.0983 (UTC)
 FILETIME=[47B69270:01C7B2C4]
X-WSS-ID: 6A66825923K845854-04-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build error:

  LD      .tmp_vmlinux1
  arch/x86_64/kernel/built-in.o: In function `__cpu_up':
  : undefined reference to `kmalloc_node'
  kernel/built-in.o: In function `build_sched_domains':
  sched.c:(.text+0x41e7): undefined reference to `kmalloc_node'
  sched.c:(.text+0x42b5): undefined reference to `kmalloc_node'
  kernel/built-in.o: In function `timer_cpu_notify':
  timer.c:(.init.text+0x1163): undefined reference to `kmalloc_node'
  mm/built-in.o: In function `mempool_create_node':
  : undefined reference to `kmalloc_node'
  mm/built-in.o:: more undefined references to `kmalloc_node' follow

... hmm, SLOB currently does not provide kmalloc_node() and friends.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 init/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index a9e99f8..d4a68f6 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -576,7 +576,7 @@ config SLUB
 	   and has enhanced diagnostics.
 
 config SLOB
-	depends on EMBEDDED && !SPARSEMEM
+	depends on EMBEDDED && !SPARSEMEM && !NUMA
 	bool "SLOB (Simple Allocator)"
 	help
 	   SLOB replaces the SLAB allocator with a drastically simpler
-- 
1.5.0.7




