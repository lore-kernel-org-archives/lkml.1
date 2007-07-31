Return-Path: <linux-kernel-owner+w=401wt.eu-S934402AbXGaVcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934402AbXGaVcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759991AbXGaVcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:32:07 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2246 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757028AbXGaVcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:32:05 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 58] net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 23:32:04 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       netfilter-devel@lists.netfilter.org, coreteam@netfilter.org
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312332.05176.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c | 10333 -> 10273 (-60 bytes)
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.o | 116092 -> 115996 (-96 bytes)

 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-2.6.23-rc1-mm1-a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c	2007-07-26 13:07:44.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c	2007-07-31 15:18:28.000000000 +0200
@@ -294,15 +294,14 @@ static int exp_open(struct inode *inode,
 	struct ct_expect_iter_state *st;
 	int ret;

-	st = kmalloc(sizeof(struct ct_expect_iter_state), GFP_KERNEL);
-	if (st == NULL)
+	st = kzalloc(sizeof(struct ct_expect_iter_state), GFP_KERNEL);
+	if (!st)
 		return -ENOMEM;
 	ret = seq_open(file, &exp_seq_ops);
 	if (ret)
 		goto out_free;
 	seq          = file->private_data;
 	seq->private = st;
-	memset(st, 0, sizeof(struct ct_expect_iter_state));
 	return ret;
 out_free:
 	kfree(st);
