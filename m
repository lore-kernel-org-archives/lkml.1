Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbYBJVRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbYBJVRa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 16:17:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756742AbYBJVRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 16:17:07 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:54488 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756464AbYBJVRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 16:17:05 -0500
Date: Sun, 10 Feb 2008 21:13:11 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dale@farnsworth.org, mlachwani@mvista.com, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 5/8] drivers/net/mv643xx_eth.c: Use FIELD_SIZEOF
Message-ID: <Pine.LNX.4.64.0802102112330.23906@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Robert P.J. Day proposed to use the macro FIELD_SIZEOF in replace of code
that matches its definition.

The modification was made using the following semantic patch
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
type t;
identifier f;
@@

- (sizeof(((t*)0)->f))
+ FIELD_SIZEOF(t, f)

@depends on haskernel@
type t;
identifier f;
@@

- sizeof(((t*)0)->f)
+ FIELD_SIZEOF(t, f)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/drivers/net/mv643xx_eth.c b/drivers/net/mv643xx_eth.c
--- a/drivers/net/mv643xx_eth.c 2008-02-08 08:58:12.000000000 +0100
+++ b/drivers/net/mv643xx_eth.c 2008-02-10 18:00:09.000000000 +0100
@@ -3155,7 +3155,7 @@ struct mv643xx_stats {
 	int stat_offset;
 };
 
-#define MV643XX_STAT(m) sizeof(((struct mv643xx_private *)0)->m), \
+#define MV643XX_STAT(m) FIELD_SIZEOF(struct mv643xx_private, m), \
 					offsetof(struct mv643xx_private, m)
 
 static const struct mv643xx_stats mv643xx_gstrings_stats[] = {
