Return-Path: <linux-kernel-owner+w=401wt.eu-S1754915AbYFHNqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbYFHNqH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 09:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbYFHNp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 09:45:56 -0400
Received: from ns1.suse.de ([195.135.220.2]:40969 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbYFHNpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 09:45:55 -0400
Message-Id: <20080608134629.414662758@halley.suse.de>
User-Agent: quilt/0.46_cvs20080326-16
Date: Sun, 08 Jun 2008 15:46:29 +0200
From: Bernhard Walle <bwalle@suse.de>
To: kexec@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, vgoyal@redhat.com, anderson@redhat.com
Subject: [patch 1/3] Add return value to reserve_bootmem_node()
References: <20080608134628.757299158@halley.suse.de>
Content-Disposition: inline; filename=reserve-bootmem-node-return
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the function reserve_bootmem_node() from void to int,
returning -ENOMEM if the allocation fails.


Signed-off-by: Bernhard Walle <bwalle@suse.de>;

---
 include/linux/bootmem.h |    2 +-
 mm/bootmem.c            |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -94,7 +94,7 @@ extern unsigned long init_bootmem_node(p
 				       unsigned long freepfn,
 				       unsigned long startpfn,
 				       unsigned long endpfn);
-extern void reserve_bootmem_node(pg_data_t *pgdat,
+extern int reserve_bootmem_node(pg_data_t *pgdat,
 				 unsigned long physaddr,
 				 unsigned long size,
 				 int flags);
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -442,15 +442,17 @@ unsigned long __init init_bootmem_node(p
 	return init_bootmem_core(pgdat, freepfn, startpfn, endpfn);
 }
 
-void __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
+int __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 				 unsigned long size, int flags)
 {
 	int ret;
 
 	ret = can_reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
 	if (ret < 0)
-		return;
+		return -ENOMEM;
 	reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
+
+	return 0;
 }
 
 void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,

