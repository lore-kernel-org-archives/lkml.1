Return-Path: <linux-kernel-owner+w=401wt.eu-S1758700AbZBXDPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700AbZBXDPN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 22:15:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757600AbZBXDNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 22:13:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:58478 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757550AbZBXDNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 22:13:16 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, nickpiggin@yahoo.com.au, ink@jurassic.park.msu.ru
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/10] percpu: fix pcpu_chunk_struct_size
Date: Tue, 24 Feb 2009 12:11:32 +0900
Message-Id: <1235445101-7882-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1235445101-7882-1-git-send-email-tj@kernel.org>
References: <1235445101-7882-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Feb 2009 03:11:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix short allocation leading to memory corruption

While dropping rvalue wrapping macros around global parameters,
pcpu_chunk_struct_size was set incorrectly resulting in shorter page
pointer array.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/percpu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 997724c..ed92caa 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -850,7 +850,7 @@ size_t __init pcpu_setup_static(pcpu_populate_pte_fn_t populate_pte_fn,
 	pcpu_chunk_size = num_possible_cpus() * pcpu_unit_size;
 	pcpu_nr_slots = pcpu_size_to_slot(pcpu_unit_size) + 1;
 	pcpu_chunk_struct_size = sizeof(struct pcpu_chunk)
-		+ (1 << pcpu_unit_pages_shift) * sizeof(struct page *);
+		+ num_possible_cpus() * pcpu_unit_pages * sizeof(struct page *);
 
 	/* allocate chunk slots */
 	pcpu_slot = alloc_bootmem(pcpu_nr_slots * sizeof(pcpu_slot[0]));
-- 
1.6.0.2

