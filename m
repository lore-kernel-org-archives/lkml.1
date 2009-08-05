Return-Path: <linux-kernel-owner+w=401wt.eu-S933071AbZHEBW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071AbZHEBW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 21:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932998AbZHEBW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 21:22:57 -0400
Received: from wg.visionengravers.com ([67.136.234.194]:17925 "EHLO
	visionfs1.visionengravers.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932956AbZHEBW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 21:22:56 -0400
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] net/ipv4/raw.c: Fix sparse noise about context imbalance
Date: Tue, 4 Aug 2009 18:23:00 -0700
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908041823.00511.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse noise due to context imbalance by annotating the functions.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 2979f14..e83f7c5 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -896,6 +896,7 @@ static struct sock *raw_get_idx(struct seq_file *seq, loff_t pos)
 }
 
 void *raw_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(&state->h->lock)
 {
 	struct raw_iter_state *state = raw_seq_private(seq);
 
@@ -918,6 +919,7 @@ void *raw_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 EXPORT_SYMBOL_GPL(raw_seq_next);
 
 void raw_seq_stop(struct seq_file *seq, void *v)
+	__releases(&state->h->lock)
 {
 	struct raw_iter_state *state = raw_seq_private(seq);
 
