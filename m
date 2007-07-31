Return-Path: <linux-kernel-owner+w=401wt.eu-S934702AbXGaVyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934702AbXGaVyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758761AbXGaVyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:54:07 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4990 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756155AbXGaVyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:54:00 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 66] net/ipv4/raw.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 23:54:00 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       netdev@vger.kernel.org, davem@davemloft.net
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312354.00650.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 net/ipv4/raw.c | 21650 -> 21628 (-22 bytes)
 net/ipv4/raw.o | 179112 -> 179272 (+160 bytes)

 net/ipv4/raw.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.23-rc1-mm1-a/net/ipv4/raw.c	2007-07-26 13:07:44.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/net/ipv4/raw.c	2007-07-31 15:20:27.000000000 +0200
@@ -900,8 +900,9 @@ static int raw_seq_open(struct inode *in
 {
 	struct seq_file *seq;
 	int rc = -ENOMEM;
-	struct raw_iter_state *s = kmalloc(sizeof(*s), GFP_KERNEL);
-
+	struct raw_iter_state *s;
+
+	s = kzalloc(sizeof(*s), GFP_KERNEL);
 	if (!s)
 		goto out;
 	rc = seq_open(file, &raw_seq_ops);
@@ -910,7 +911,6 @@ static int raw_seq_open(struct inode *in

 	seq = file->private_data;
 	seq->private = s;
-	memset(s, 0, sizeof(*s));
 out:
 	return rc;
 out_kfree:
