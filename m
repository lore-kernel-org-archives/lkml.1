Return-Path: <linux-kernel-owner+w=401wt.eu-S1757629AbZC2CGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629AbZC2CGk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 22:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756679AbZC2CEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 22:04:13 -0400
Received: from ozlabs.org ([203.10.76.45]:46572 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbZC2CEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 22:04:07 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sun, 29 Mar 2009 00:25:52 +1030
Subject: [PATCH 2/10] cpumask: fix seq_bitmap_*() functions.
Message-Id: <20090329020405.B8364DDE25@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) seq_bitmap_list() should take a const.
2) All the seq_bitmap should use cpumask_bits().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 fs/seq_file.c            |    2 +-
 include/linux/seq_file.h |    9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -513,7 +513,7 @@ int seq_bitmap(struct seq_file *m, const
 }
 EXPORT_SYMBOL(seq_bitmap);
 
-int seq_bitmap_list(struct seq_file *m, unsigned long *bits,
+int seq_bitmap_list(struct seq_file *m, const unsigned long *bits,
 		unsigned int nr_bits)
 {
 	if (m->count < m->size) {
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -55,7 +55,7 @@ int seq_bitmap(struct seq_file *m, const
 				   unsigned int nr_bits);
 static inline int seq_cpumask(struct seq_file *m, const struct cpumask *mask)
 {
-	return seq_bitmap(m, mask->bits, nr_cpu_ids);
+	return seq_bitmap(m, cpumask_bits(mask), nr_cpu_ids);
 }
 
 static inline int seq_nodemask(struct seq_file *m, nodemask_t *mask)
@@ -63,12 +63,13 @@ static inline int seq_nodemask(struct se
 	return seq_bitmap(m, mask->bits, MAX_NUMNODES);
 }
 
-int seq_bitmap_list(struct seq_file *m, unsigned long *bits,
+int seq_bitmap_list(struct seq_file *m, const unsigned long *bits,
 		unsigned int nr_bits);
 
-static inline int seq_cpumask_list(struct seq_file *m, cpumask_t *mask)
+static inline int seq_cpumask_list(struct seq_file *m,
+				   const struct cpumask *mask)
 {
-	return seq_bitmap_list(m, mask->bits, NR_CPUS);
+	return seq_bitmap_list(m, cpumask_bits(mask), nr_cpu_ids);
 }
 
 static inline int seq_nodemask_list(struct seq_file *m, nodemask_t *mask)

