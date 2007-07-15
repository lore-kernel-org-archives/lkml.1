Return-Path: <linux-kernel-owner+w=401wt.eu-S1757610AbXGOUBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610AbXGOUBb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 16:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755406AbXGOUAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 16:00:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39919 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342AbXGOUAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 16:00:12 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] fix return type of skb_checksum_complete()
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net
Message-Id: <E1IAAGJ-00054e-Uk@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 15 Jul 2007 21:00:11 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


It returns __sum16, not unsigned int

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/skbuff.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9391e4a..ce25643 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1639,7 +1639,7 @@ static inline int skb_csum_unnecessary(const struct sk_buff *skb)
  *	if skb->ip_summed is CHECKSUM_UNNECESSARY which indicates that the
  *	hardware has already verified the correctness of the checksum.
  */
-static inline unsigned int skb_checksum_complete(struct sk_buff *skb)
+static inline __sum16 skb_checksum_complete(struct sk_buff *skb)
 {
 	return skb_csum_unnecessary(skb) ?
 	       0 : __skb_checksum_complete(skb);
-- 
1.5.3.GIT


