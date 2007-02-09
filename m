Return-Path: <linux-kernel-owner+w=401wt.eu-S1946647AbXBIQrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946647AbXBIQrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946671AbXBIQq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:46:58 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51694 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946647AbXBIQjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:39:02 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] uintptr_t is unsigned long, not u32
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org
Message-Id: <E1HFYm4-0006nm-MY@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:39:00 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/r8169.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 577babd..5598d86 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -2016,7 +2016,7 @@ static int rtl8169_alloc_rx_skb(struct pci_dev *pdev, struct sk_buff **sk_buff,
 	if (!skb)
 		goto err_out;
 
-	skb_reserve(skb, (align - 1) & (u32)skb->data);
+	skb_reserve(skb, (align - 1) & (unsigned long)skb->data);
 	*sk_buff = skb;
 
 	mapping = pci_map_single(pdev, skb->data, rx_buf_sz,
@@ -2487,7 +2487,7 @@ static inline int rtl8169_try_rx_copy(struct sk_buff **sk_buff, int pkt_size,
 
 		skb = dev_alloc_skb(pkt_size + align);
 		if (skb) {
-			skb_reserve(skb, (align - 1) & (u32)skb->data);
+			skb_reserve(skb, (align - 1) & (unsigned long)skb->data);
 			eth_copy_and_sum(skb, sk_buff[0]->data, pkt_size, 0);
 			*sk_buff = skb;
 			rtl8169_mark_to_asic(desc, rx_buf_sz);
-- 
1.5.0-rc2.GIT


