Return-Path: <linux-kernel-owner+w=401wt.eu-S1751024AbYLAIMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751024AbYLAIMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 03:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbYLAIMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 03:12:08 -0500
Received: from ozlabs.org ([203.10.76.45]:40807 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbYLAIMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 03:12:07 -0500
To: David Miller <davem@davemloft.net>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 1 Dec 2008 18:41:55 +1030
Subject: [PATCH 2/2] cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits: net
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@elte.hu>
Cc: Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011841.56221.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

In future all cpumask ops will only be valid (in general) for bit
numbers < nr_cpu_ids.  So use that instead of NR_CPUS in iterators
and other comparisons.

This is always safe: no cpu number can be >= nr_cpu_ids, and
nr_cpu_ids is initialized to NR_CPUS at boot.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
---
 net/core/neighbour.c                                  |    4 ++--
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c |    4 ++--
 net/ipv4/route.c                                      |    4 ++--
 net/netfilter/nf_conntrack_standalone.c               |    4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff -r bb80787e9617 net/core/neighbour.c
--- a/net/core/neighbour.c	Fri Oct 24 00:27:01 2008 +1100
+++ b/net/core/neighbour.c	Fri Oct 24 00:28:25 2008 +1100
@@ -2423,7 +2423,7 @@ static void *neigh_stat_seq_start(struct
 	if (*pos == 0)
 		return SEQ_START_TOKEN;
 
-	for (cpu = *pos-1; cpu < NR_CPUS; ++cpu) {
+	for (cpu = *pos-1; cpu < nr_cpu_ids; ++cpu) {
 		if (!cpu_possible(cpu))
 			continue;
 		*pos = cpu+1;
@@ -2438,7 +2438,7 @@ static void *neigh_stat_seq_next(struct 
 	struct neigh_table *tbl = pde->data;
 	int cpu;
 
-	for (cpu = *pos; cpu < NR_CPUS; ++cpu) {
+	for (cpu = *pos; cpu < nr_cpu_ids; ++cpu) {
 		if (!cpu_possible(cpu))
 			continue;
 		*pos = cpu+1;
diff -r bb80787e9617 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c	Fri Oct 24 
00:27:01 2008 +1100
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c	Fri Oct 24 
00:28:25 2008 +1100
@@ -291,7 +291,7 @@ static void *ct_cpu_seq_start(struct seq
 	if (*pos == 0)
 		return SEQ_START_TOKEN;
 
-	for (cpu = *pos-1; cpu < NR_CPUS; ++cpu) {
+	for (cpu = *pos-1; cpu < nr_cpu_ids; ++cpu) {
 		if (!cpu_possible(cpu))
 			continue;
 		*pos = cpu+1;
@@ -306,7 +306,7 @@ static void *ct_cpu_seq_next(struct seq_
 	struct net *net = seq_file_net(seq);
 	int cpu;
 
-	for (cpu = *pos; cpu < NR_CPUS; ++cpu) {
+	for (cpu = *pos; cpu < nr_cpu_ids; ++cpu) {
 		if (!cpu_possible(cpu))
 			continue;
 		*pos = cpu+1;
diff -r bb80787e9617 net/ipv4/route.c
--- a/net/ipv4/route.c	Fri Oct 24 00:27:01 2008 +1100
+++ b/net/ipv4/route.c	Fri Oct 24 00:28:25 2008 +1100
@@ -427,7 +427,7 @@ static void *rt_cpu_seq_start(struct seq
 	if (*pos == 0)
 		return SEQ_START_TOKEN;
 
-	for (cpu = *pos-1; cpu < NR_CPUS; ++cpu) {
+	for (cpu = *pos-1; cpu < nr_cpu_ids; ++cpu) {
 		if (!cpu_possible(cpu))
 			continue;
 		*pos = cpu+1;
@@ -440,7 +440,7 @@ static void *rt_cpu_seq_next(struct seq_
 {
 	int cpu;
 
-	for (cpu = *pos; cpu < NR_CPUS; ++cpu) {
+	for (cpu = *pos; cpu < nr_cpu_ids; ++cpu) {
 		if (!cpu_possible(cpu))
 			continue;
 		*pos = cpu+1;
diff -r bb80787e9617 net/netfilter/nf_conntrack_standalone.c
--- a/net/netfilter/nf_conntrack_standalone.c	Fri Oct 24 00:27:01 2008 +1100
+++ b/net/netfilter/nf_conntrack_standalone.c	Fri Oct 24 00:28:25 2008 +1100
@@ -200,7 +200,7 @@ static void *ct_cpu_seq_start(struct seq
 	if (*pos == 0)
 		return SEQ_START_TOKEN;
 
-	for (cpu = *pos-1; cpu < NR_CPUS; ++cpu) {
+	for (cpu = *pos-1; cpu < nr_cpu_ids; ++cpu) {
 		if (!cpu_possible(cpu))
 			continue;
 		*pos = cpu + 1;
@@ -215,7 +215,7 @@ static void *ct_cpu_seq_next(struct seq_
 	struct net *net = seq_file_net(seq);
 	int cpu;
 
-	for (cpu = *pos; cpu < NR_CPUS; ++cpu) {
+	for (cpu = *pos; cpu < nr_cpu_ids; ++cpu) {
 		if (!cpu_possible(cpu))
 			continue;
 		*pos = cpu + 1;


