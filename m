Return-Path: <linux-kernel-owner+w=401wt.eu-S932453AbZLFJPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453AbZLFJPe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 04:15:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932066AbZLFJPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 04:15:30 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:47547 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755806AbZLFJP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 04:15:28 -0500
Date: Sun, 6 Dec 2009 10:15:32 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/5] arch/xtensa/platforms/iss: correct size computation
Message-ID: <Pine.LNX.4.64.0912061015030.20858@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The size argument to alloc_bootmem should be the size of desired structure,
not the pointer to it.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@expression@
expression *x;
@@

x =
 <+...
-sizeof(x)
+sizeof(*x)
...+>// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/xtensa/platforms/iss/network.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/xtensa/platforms/iss/network.c b/arch/xtensa/platforms/iss/network.c
index 2f0b86b..54a0868 100644
--- a/arch/xtensa/platforms/iss/network.c
+++ b/arch/xtensa/platforms/iss/network.c
@@ -780,7 +780,8 @@ static int iss_net_setup(char *str)
 		return 1;
 	}
 
-	if ((new = alloc_bootmem(sizeof new)) == NULL) {
+	new = alloc_bootmem(sizeof(*new));
+	if (new == NULL) {
 		printk("Alloc_bootmem failed\n");
 		return 1;
 	}
