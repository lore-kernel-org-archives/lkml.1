Return-Path: <linux-kernel-owner+w=401wt.eu-S1756938AbXLBUHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938AbXLBUHM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 15:07:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbXLBUG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 15:06:59 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:50837 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824AbXLBUG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 15:06:57 -0500
Date: Sun, 2 Dec 2007 21:06:54 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: jacmet@sunsite.dk, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 3/3] drivers/serial/uartlite.c: Add missing of_node_put
Message-ID: <Pine.LNX.4.64.0712022105480.3361@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

There should be an of_node_put when breaking out of a loop that iterates
using for_each_compatible_node.

This was detected and fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
identifier d;
type T;
expression e;
iterator for_each_compatible_node;
@@

T *d;
...
for_each_compatible_node(d,...)
  {... when != of_node_put(d)
       when != e = d
(
   return d;
|
+  of_node_put(d);
?  return ...;
)
...}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p a/drivers/serial/uartlite.c b/drivers/serial/uartlite.c
--- a/drivers/serial/uartlite.c 2007-11-12 10:35:57.000000000 +0100
+++ b/drivers/serial/uartlite.c 2007-12-02 17:43:57.000000000 +0100
@@ -393,6 +393,7 @@ static inline void __init ulite_console_
 			continue;
 
 		ulite_ports[id].mapbase = res.start;
+		of_node_put(np);
 		return;
 	}
 }
