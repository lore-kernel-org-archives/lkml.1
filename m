Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467AbYKMKeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbYKMKeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 05:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbYKMKd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 05:33:59 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:51499 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbYKMKd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 05:33:58 -0500
Date: Thu, 13 Nov 2008 11:33:54 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/pcmcia/cistpl.c: introduce missing braces
Message-ID: <Pine.LNX.4.64.0811131133010.9563@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The indentation and behavior of the code below suggests that braces are
intended around the if branch.

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,l;
position p1,p2;
expression *ptr != NULL;
@@

(
if ((x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...)) == NULL) S
|
x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
)
<... when != x
     when != if (...) { <+...x...+> }
x->f = E
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 drivers/pcmcia/cistpl.c       |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/pcmcia/cistpl.c b/drivers/pcmcia/cistpl.c
index dcce9f5..4a110b7 100644
--- a/drivers/pcmcia/cistpl.c
+++ b/drivers/pcmcia/cistpl.c
@@ -351,10 +351,11 @@ int verify_cis_cache(struct pcmcia_socket *s)
 	char *buf;
 
 	buf = kmalloc(256, GFP_KERNEL);
-	if (buf == NULL)
+	if (buf == NULL) {
 		dev_printk(KERN_WARNING, &s->dev,
 			   "no memory for verifying CIS\n");
 		return -ENOMEM;
+	}
 	list_for_each_entry(cis, &s->cis_cache, node) {
 		int len = cis->len;
 
