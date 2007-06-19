Return-Path: <linux-kernel-owner+w=401wt.eu-S1757358AbXFSIp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358AbXFSIp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 04:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755260AbXFSIpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 04:45:18 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:11373 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbXFSIpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 04:45:13 -0400
Message-Id: <20070619084641.563238581@de.ibm.com>
References: <20070619084516.457715754@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 19 Jun 2007 10:45:18 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Michael Holzheu <holzheu@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 2/6] Fix zfcpdump header
Content-Disposition: inline; filename=002-zfcp-dumphdr.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@de.ibm.com>

Added members for volume number and real memory size to header information.

Signed-off-by: Michael Holzheu <holzheu@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/char/zcore.c |    3 +++
 1 file changed, 3 insertions(+)

Index: quilt-2.6/drivers/s390/char/zcore.c
===================================================================
--- quilt-2.6.orig/drivers/s390/char/zcore.c
+++ quilt-2.6/drivers/s390/char/zcore.c
@@ -267,7 +267,9 @@ struct zcore_header {
 	u64 tod;
 	cpuid_t cpu_id;
 	u32 arch_id;
+	u32 volnr;
 	u32 build_arch;
+	u64 rmem_size;
 	char pad2[4016];
 } __attribute__((packed,__aligned__(16)));
 
@@ -559,6 +561,7 @@ static void __init zcore_header_init(int
 	else
 		hdr->arch_id = DUMP_ARCH_S390;
 	hdr->mem_size = sys_info.mem_size;
+	hdr->rmem_size = sys_info.mem_size;
 	hdr->mem_end = sys_info.mem_size;
 	hdr->num_pages = sys_info.mem_size / PAGE_SIZE;
 	hdr->tod = get_clock();

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

