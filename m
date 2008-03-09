Return-Path: <linux-kernel-owner+w=401wt.eu-S1764390AbYCGT6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764390AbYCGT6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 14:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbYCGT6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 14:58:05 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:24449 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbYCGT6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 14:58:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding:sender;
        b=qKe6EkfL3KTWI/6fR8nXVED1/RJM85rxoY2hLrfuY0vyg50zNIa1WhVJUQGyWXPbI96UdfHBEkVA8hYHl7ERIzxQ9q1I9PDUnLGrmlwg43PalFFpJ9PFmawI6fy+1Fb2bS8M6hcsKUi6E1v0LKAhSr0IZZREkNi0wELii8t2SC4=
Subject: [PATCH -mm] [NETDEV] smc91x: fix the compiling broken bug - when
	SMC_GET_MAC_ADDR API upgrade
From: Bryan Wu <cooloney@kernel.org>
Reply-To: cooloney@kernel.org
To: linux-kernel@vger.kernel.org, Magnus Damm <damm@igel.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sun, 09 Mar 2008 03:57:43 -0700
Message-Id: <1205060263.7215.4.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From aba13cf58fb2d3ad418e609f1b5fd8620805f27e Mon Sep 17 00:00:00 2001
From: Bryan Wu <cooloney@kernel.org>
Date: Sun, 9 Mar 2008 02:00:21 -0700
Subject: [PATCH -mm] [NETDEV] smc91x: fix the compiling broken bug - when SMC_GET_MAC_ADDR API upgrade

---
 drivers/net/smc91x.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/smc91x.h b/drivers/net/smc91x.h
index 13d3ef4..d1e1d8e 100644
--- a/drivers/net/smc91x.h
+++ b/drivers/net/smc91x.h
@@ -93,14 +93,14 @@
 #define SMC_insw(a, r, p, l) 	insw ((unsigned long *)((a) + (r)), p, l)
 # endif
 /* check if the mac in reg is valid */
-#define SMC_GET_MAC_ADDR(addr)					\
+#define SMC_GET_MAC_ADDR(lp, addr)				\
 	do {							\
 		unsigned int __v;				\
-		__v = SMC_inw(ioaddr, ADDR0_REG);		\
+		__v = SMC_inw(ioaddr, ADDR0_REG(lp));		\
 		addr[0] = __v; addr[1] = __v >> 8;		\
-		__v = SMC_inw(ioaddr, ADDR1_REG);		\
+		__v = SMC_inw(ioaddr, ADDR1_REG(lp));		\
 		addr[2] = __v; addr[3] = __v >> 8;		\
-		__v = SMC_inw(ioaddr, ADDR2_REG);		\
+		__v = SMC_inw(ioaddr, ADDR2_REG(lp));		\
 		addr[4] = __v; addr[5] = __v >> 8;		\
 		if (*(u32 *)(&addr[0]) == 0xFFFFFFFF) {		\
 			random_ether_addr(addr);		\
-- 
1.5.4.3



