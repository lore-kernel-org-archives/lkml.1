Return-Path: <linux-kernel-owner+w=401wt.eu-S1764723AbXGaRdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764723AbXGaRdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbXGaRdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:33:35 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2432 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbXGaRde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:33:34 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 20] net/decnet/dn_route.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 19:33:33 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       netdev@vger.kernel.org, patrick@tykepenguin.com
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311933.33745.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 net/decnet/dn_route.c | 45013 -> 44991 (-22 bytes)
 net/decnet/dn_route.o | 199388 -> 199580 (+192 bytes)

 net/decnet/dn_route.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.23-rc1-mm1-a/net/decnet/dn_route.c	2007-07-26 13:07:44.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/net/decnet/dn_route.c	2007-07-31 15:15:11.000000000 +0200
@@ -1737,8 +1737,9 @@ static int dn_rt_cache_seq_open(struct i
 {
 	struct seq_file *seq;
 	int rc = -ENOMEM;
-	struct dn_rt_cache_iter_state *s = kmalloc(sizeof(*s), GFP_KERNEL);
-
+	struct dn_rt_cache_iter_state *s;
+
+	s = kzalloc(sizeof(*s), GFP_KERNEL);
 	if (!s)
 		goto out;
 	rc = seq_open(file, &dn_rt_cache_seq_ops);
@@ -1746,7 +1747,6 @@ static int dn_rt_cache_seq_open(struct i
 		goto out_kfree;
 	seq		= file->private_data;
 	seq->private	= s;
-	memset(s, 0, sizeof(*s));
 out:
 	return rc;
 out_kfree:
