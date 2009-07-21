Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbZGUK2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbZGUK2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755286AbZGUK2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:28:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:37095 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755190AbZGUK2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:28:09 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       benh@kernel.crashing.org, davem@davemloft.net, dhowells@redhat.com,
       npiggin@suse.de, JBeulich@novell.com, cl@linux-foundation.org,
       rusty@rustcorp.com.au, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, x86@kernel.org, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/20] percpu: improve boot messages
Date: Tue, 21 Jul 2009 19:26:01 +0900
Message-Id: <1248171979-29166-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1248171979-29166-1-git-send-email-tj@kernel.org>
References: <1248171979-29166-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Jul 2009 10:26:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve percpu boot messages such that they're uniform and contain
more information.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/percpu.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index c44a5b2..80317dc 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1488,8 +1488,9 @@ ssize_t __init pcpu_embed_first_chunk(size_t static_size, size_t reserved_size,
 	}
 
 	/* we're ready, commit */
-	pr_info("PERCPU: Embedded %zu pages at %p, static data %zu bytes\n",
-		size_sum >> PAGE_SHIFT, base, static_size);
+	pr_info("PERCPU: Embedded %zu pages/cpu @%p s%zu r%zu d%zu u%zu\n",
+		PFN_DOWN(size_sum), base, static_size, reserved_size, dyn_size,
+		unit_size);
 
 	return pcpu_setup_first_chunk(static_size, reserved_size, dyn_size,
 				      unit_size, base, NULL);
@@ -1579,8 +1580,8 @@ ssize_t __init pcpu_4k_first_chunk(size_t static_size, size_t reserved_size,
 	}
 
 	/* we're ready, commit */
-	pr_info("PERCPU: %d 4k pages per cpu, static data %zu bytes\n",
-		unit_pages, static_size);
+	pr_info("PERCPU: %d 4k pages/cpu @%p s%zu r%zu\n",
+		unit_pages, vm.addr, static_size, reserved_size);
 
 	ret = pcpu_setup_first_chunk(static_size, reserved_size, -1,
 				     unit_pages << PAGE_SHIFT, vm.addr, NULL);
@@ -1898,8 +1899,8 @@ ssize_t __init pcpu_lpage_first_chunk(size_t static_size, size_t reserved_size,
 		       static_size);
 
 	/* we're ready, commit */
-	pr_info("PERCPU: Remapped at %p with large pages, static data "
-		"%zu bytes\n", vm.addr, static_size);
+	pr_info("PERCPU: large pages @%p s%zu r%zu d%zu u%zu\n",
+		vm.addr, static_size, reserved_size, dyn_size, unit_size);
 
 	ret = pcpu_setup_first_chunk(static_size, reserved_size, dyn_size,
 				     unit_size, vm.addr, unit_map);
-- 
1.6.0.2

