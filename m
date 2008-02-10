Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbYBJULh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbYBJULh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 15:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbYBJUL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 15:11:29 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:38772 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbYBJUL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 15:11:28 -0500
Date: Sun, 10 Feb 2008 21:11:24 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: e1000-devel@lists.sourceforge.net, cramerj@intel.com,
       john.ronciak@intel.com, jeffrey.t.kirsher@intel.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/8] drivers/net/e1000: Use FIELD_SIZEOF
Message-ID: <Pine.LNX.4.64.0802102110110.23906@ask.diku.dk>
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

diff -u -p a/drivers/net/e1000/e1000_ethtool.c b/drivers/net/e1000/e1000_ethtool.c
--- a/drivers/net/e1000/e1000_ethtool.c 2008-02-02 15:28:19.000000000 +0100
+++ b/drivers/net/e1000/e1000_ethtool.c 2008-02-10 17:58:20.000000000 +0100
@@ -50,7 +50,7 @@ struct e1000_stats {
 	int stat_offset;
 };
 
-#define E1000_STAT(m) sizeof(((struct e1000_adapter *)0)->m), \
+#define E1000_STAT(m) FIELD_SIZEOF(struct e1000_adapter, m), \
 		      offsetof(struct e1000_adapter, m)
 static const struct e1000_stats e1000_gstrings_stats[] = {
 	{ "rx_packets", E1000_STAT(stats.gprc) },
