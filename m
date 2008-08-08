Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbYHHSf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbYHHSf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 14:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbYHHSfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 14:35:10 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:41483 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968AbYHHSfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 14:35:09 -0400
Date: Fri, 8 Aug 2008 21:33:34 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jie Yang <jie.yang@atheros.com>, jgarzik@pobox.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] uninline atl1e_setup_mac_ctrl()
Message-ID: <20080808183334.GZ14495@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There doesn't seem to be a compelling reason why atl1e_setup_mac_ctrl() 
is marked as "inline":

It's not used in any place where speed would matter much, and as long as 
it has only one caller non-ancient gcc versions anyway inline it 
automatically.

This patch fixes the following compile error with gcc 3.4:

<--  snip  -->

...
  CC      drivers/net/atl1e/atl1e_main.o
atl1e_main.c: In function `atl1e_check_link':
atl1e_main.c:50: sorry, unimplemented: inlining failed in call to 
atl1e_main.c:196: sorry, unimplemented: called from here
make[4]: *** [drivers/net/atl1e/atl1e_main.o] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
9b6daf38d2e48b275573fc54e7d2a498fac277cf 
diff --git a/drivers/net/atl1e/atl1e_main.c b/drivers/net/atl1e/atl1e_main.c
index 35264c2..82d7be1 100644
--- a/drivers/net/atl1e/atl1e_main.c
+++ b/drivers/net/atl1e/atl1e_main.c
@@ -47,7 +47,7 @@ MODULE_DESCRIPTION("Atheros 1000M Ethernet Network Driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 
-static inline void atl1e_setup_mac_ctrl(struct atl1e_adapter *adapter);
+static void atl1e_setup_mac_ctrl(struct atl1e_adapter *adapter);
 
 static const u16
 atl1e_rx_page_vld_regs[AT_MAX_RECEIVE_QUEUE][AT_PAGE_NUM_PER_QUEUE] =
@@ -1037,7 +1037,7 @@ static inline void atl1e_configure_dma(struct atl1e_adapter *adapter)
 	return;
 }
 
-static inline void atl1e_setup_mac_ctrl(struct atl1e_adapter *adapter)
+static void atl1e_setup_mac_ctrl(struct atl1e_adapter *adapter)
 {
 	u32 value;
 	struct atl1e_hw *hw = &adapter->hw;

