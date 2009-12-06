Return-Path: <linux-kernel-owner+w=401wt.eu-S932547AbZLFJPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547AbZLFJPw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 04:15:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932066AbZLFJPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 04:15:51 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:47555 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756049AbZLFJPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 04:15:49 -0500
Date: Sun, 6 Dec 2009 10:15:53 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/5] drivers/clocksource: correct size computation
Message-ID: <Pine.LNX.4.64.0912061015340.20858@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The size argument to ioremap_nocache should be the size of desired
information, not the pointer to it.

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
 drivers/clocksource/cyclone.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -u -p a/drivers/clocksource/cyclone.c b/drivers/clocksource/cyclone.c
--- a/drivers/clocksource/cyclone.c
+++ b/drivers/clocksource/cyclone.c
@@ -50,7 +50,7 @@ static int __init init_cyclone_clocksour
 
 	/* find base address: */
 	offset = CYCLONE_CBAR_ADDR;
-	reg = ioremap_nocache(offset, sizeof(reg));
+	reg = ioremap_nocache(offset, sizeof(*reg));
 	if (!reg) {
 		printk(KERN_ERR "Summit chipset: Could not find valid CBAR register.\n");
 		return -ENODEV;
@@ -65,7 +65,7 @@ static int __init init_cyclone_clocksour
 
 	/* setup PMCC: */
 	offset = base + CYCLONE_PMCC_OFFSET;
-	reg = ioremap_nocache(offset, sizeof(reg));
+	reg = ioremap_nocache(offset, sizeof(*reg));
 	if (!reg) {
 		printk(KERN_ERR "Summit chipset: Could not find valid PMCC register.\n");
 		return -ENODEV;
@@ -75,7 +75,7 @@ static int __init init_cyclone_clocksour
 
 	/* setup MPCS: */
 	offset = base + CYCLONE_MPCS_OFFSET;
-	reg = ioremap_nocache(offset, sizeof(reg));
+	reg = ioremap_nocache(offset, sizeof(*reg));
 	if (!reg) {
 		printk(KERN_ERR "Summit chipset: Could not find valid MPCS register.\n");
 		return -ENODEV;
