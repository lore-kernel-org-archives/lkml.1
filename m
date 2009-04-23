Return-Path: <linux-kernel-owner+w=401wt.eu-S1758504AbZDWIIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758504AbZDWIIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 04:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760698AbZDWIBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 04:01:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:46780 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991AbZDWIBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 04:01:16 -0400
Date: Thu, 23 Apr 2009 08:00:42 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49EF89DF.9090404@kernel.org>
References: <49EF89DF.9090404@kernel.org>
Subject: [tip:x86/urgent] x86: check boundary in setup_node_bootmem()
Message-ID: <tip-4c31e92b97b6d7e7b19ee5e54a22571ffdebb305@git.kernel.org>
Git-Commit-ID: 4c31e92b97b6d7e7b19ee5e54a22571ffdebb305
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 23 Apr 2009 08:00:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4c31e92b97b6d7e7b19ee5e54a22571ffdebb305
Gitweb:     http://git.kernel.org/tip/4c31e92b97b6d7e7b19ee5e54a22571ffdebb305
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 22 Apr 2009 14:19:27 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 23 Apr 2009 09:58:56 +0200

x86: check boundary in setup_node_bootmem()

Commit dc09855 ("x86/uv: fix init of memory-less nodes") causes a
two sockets system (where node-1 doesn't have RAM installed) to crash.

That commit makes node_possible include cpu nodes that do not have memory.
So check boundary in setup_node_bootmem().

[ Impact: fix boot crash on RAM-less NUMA node system ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Jack Steiner <steiner@sgi.com>
LKML-Reference: <49EF89DF.9090404@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/numa_64.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index d73aaa8..2d05a12 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -188,6 +188,9 @@ void __init setup_node_bootmem(int nodeid, unsigned long start,
 	const int pgdat_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
 	int nid;
 
+	if (!end)
+		return;
+
 	start = roundup(start, ZONE_ALIGN);
 
 	printk(KERN_INFO "Bootmem setup node %d %016lx-%016lx\n", nodeid,
