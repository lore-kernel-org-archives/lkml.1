Return-Path: <linux-kernel-owner+w=401wt.eu-S1765343AbZCaXh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765343AbZCaXh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764248AbZCaXWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:22:37 -0400
Received: from sous-sol.org ([216.99.217.87]:33355 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764256AbZCaXWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:22:36 -0400
Message-Id: <20090331231732.380218200@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:11:22 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Rusty Russell <rusty@rustcorp.com.au>,
       Mike Travis <travis@sgi.com>, steiner@sgi.com,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 37/45] x86, uv: fix cpumask iterator in uv_bau_init()
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=x86-uv-fix-cpumask-iterator-in-uv_bau_init.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Rusty Russell <rusty@rustcorp.com.au>

upstream commit: 2c74d66624ddbda8101d54d1e184cf9229b378bc

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
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/kernel/tlb_uv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -742,7 +742,7 @@ static int __init uv_bau_init(void)
 	int node;
 	int nblades;
 	int last_blade;
-	int cur_cpu = 0;
+	int cur_cpu;
 
 	if (!is_uv_system())
 		return 0;
@@ -752,6 +752,7 @@ static int __init uv_bau_init(void)
 	uv_mmask = (1UL << uv_hub_info->n_val) - 1;
 	nblades = 0;
 	last_blade = -1;
+	cur_cpu = 0;
 	for_each_online_node(node) {
 		blade = uv_node_to_blade_id(node);
 		if (blade == last_blade)

