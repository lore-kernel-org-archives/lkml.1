Return-Path: <linux-kernel-owner+w=401wt.eu-S1759866AbYFWVMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759866AbYFWVMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 17:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755942AbYFWVMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 17:12:36 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:42817 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395AbYFWVMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 17:12:35 -0400
Date: Mon, 23 Jun 2008 23:12:31 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: florian.fainelli@telecomint.eu, jgarzik@pobox.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/net/r6040.c: Eliminate double sizeof
Message-ID: <Pine.LNX.4.64.0806232311570.13402@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Taking sizeof the result of sizeof is quite strange and does not seem to be
what is wanted here.

This was fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression E;
@@

- sizeof (
  sizeof (E)
- )
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p a/drivers/net/r6040.c b/drivers/net/r6040.c
--- a/drivers/net/r6040.c 2008-06-17 19:46:52.000000000 +0200
+++ b/drivers/net/r6040.c 2008-06-23 22:55:11.000000000 +0200
@@ -273,7 +273,7 @@ static void r6040_init_ring_desc(struct 
 	dma_addr_t mapping = desc_dma;
 
 	while (size-- > 0) {
-		mapping += sizeof(sizeof(*desc));
+		mapping += sizeof(*desc);
 		desc->ndesc = cpu_to_le32(mapping);
 		desc->vndescp = desc + 1;
 		desc++;
