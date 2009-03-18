Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbZCRIxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbZCRIxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 04:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbZCRIwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 04:52:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:44487 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836AbZCRIwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 04:52:20 -0400
Date: Wed, 18 Mar 2009 08:51:43 GMT
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       travis@sgi.com, rusty@rustcorp.com.au, cpw@sgi.com, stable@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, travis@sgi.com, stable@kernel.org, cpw@sgi.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <200903180822.31196.rusty@rustcorp.com.au>
References: <200903180822.31196.rusty@rustcorp.com.au>
Subject: [tip:x86/uv] x86, uv: fix cpumask iterator in uv_bau_init()
Message-ID: <tip-2c74d66624ddbda8101d54d1e184cf9229b378bc@git.kernel.org>
Git-Commit-ID: 2c74d66624ddbda8101d54d1e184cf9229b378bc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 18 Mar 2009 08:51:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2c74d66624ddbda8101d54d1e184cf9229b378bc
Gitweb:     http://git.kernel.org/tip/2c74d66624ddbda8101d54d1e184cf9229b378bc
Author:     Rusty Russell <rusty@rustcorp.com.au>
AuthorDate: Wed, 18 Mar 2009 08:22:30 +1030
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 18 Mar 2009 09:47:54 +0100

x86, uv: fix cpumask iterator in uv_bau_init()

Impact: fix boot crash on UV systems

Commit 76ba0ecda0de9accea9a91cb6dbde46782110e1c "cpumask: use
cpumask_var_t in uv_flush_tlb_others" used cur_cpu as an iterator;
it was supposed to be zero for the code below it.

Reported-by: Cliff Wickman <cpw@sgi.com>
Original-From: Cliff Wickman <cpw@sgi.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Mike Travis <travis@sgi.com>
Cc: steiner@sgi.com
Cc: <stable@kernel.org>
LKML-Reference: <200903180822.31196.rusty@rustcorp.com.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/tlb_uv.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index d038b9c..79c0732 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -750,7 +750,7 @@ static int __init uv_bau_init(void)
 	int node;
 	int nblades;
 	int last_blade;
-	int cur_cpu = 0;
+	int cur_cpu;
 
 	if (!is_uv_system())
 		return 0;
@@ -760,6 +760,7 @@ static int __init uv_bau_init(void)
 	uv_mmask = (1UL << uv_hub_info->n_val) - 1;
 	nblades = 0;
 	last_blade = -1;
+	cur_cpu = 0;
 	for_each_online_node(node) {
 		blade = uv_node_to_blade_id(node);
 		if (blade == last_blade)
