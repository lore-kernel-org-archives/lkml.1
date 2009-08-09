Return-Path: <linux-kernel-owner+w=401wt.eu-S1752767AbZHIHnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbZHIHnZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 03:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbZHIHnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 03:43:24 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:60920 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbZHIHnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 03:43:22 -0400
Date: Sun, 9 Aug 2009 09:43:20 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Karsten Keil <isdn@linux-pingi.de>, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/3] drivers/isdn/hisax: Correct use of request_region/request_mem_region
Message-ID: <Pine.LNX.4.64.0908090942560.13271@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

request_region should be used with release_region, not request_mem_region.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r1@
expression start;
@@

request_region(start,...)

@b1@
expression r1.start;
@@

request_mem_region(start,...)

@depends on !b1@
expression r1.start;
expression E;
@@

- release_mem_region
+ release_region
  (start,E)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/isdn/hisax/isurf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/isdn/hisax/isurf.c b/drivers/isdn/hisax/isurf.c
--- a/drivers/isdn/hisax/isurf.c
+++ b/drivers/isdn/hisax/isurf.c
@@ -125,7 +125,7 @@ release_io_isurf(struct IsdnCardState *c
 {
 	release_region(cs->hw.isurf.reset, 1);
 	iounmap(cs->hw.isurf.isar);
-	release_mem_region(cs->hw.isurf.phymem, ISURF_IOMEM_SIZE);
+	release_region(cs->hw.isurf.phymem, ISURF_IOMEM_SIZE);
 }
 
 static void
