Return-Path: <linux-kernel-owner+w=401wt.eu-S1755608AbYBMVFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbYBMVFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbYBMVFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:05:21 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:51754 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147AbYBMVFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:05:20 -0500
Message-ID: <47B35B88.5070300@inria.fr>
Date: Wed, 13 Feb 2008 22:05:12 +0100
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: shannon.nelson@intel.com, dan.j.williams@intel.com
CC: Chris Leech <christopher.leech@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH][I/OAT]: Remove duplicate assignation in dma_skb_copy_datagram_iovec
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[I/OAT]: Remove duplicate assignation in dma_skb_copy_datagram_iovec

No need to compute copy twice in the frags loop in
dma_skb_copy_datagram_iovec().

Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
---
 user_dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/user_dma.c b/net/core/user_dma.c
index 0ad1cd5..c77aff9 100644
--- a/net/core/user_dma.c
+++ b/net/core/user_dma.c
@@ -75,7 +75,7 @@ int dma_skb_copy_datagram_iovec(struct dma_chan *chan,
 
 		end = start + skb_shinfo(skb)->frags[i].size;
 		copy = end - offset;
-		if ((copy = end - offset) > 0) {
+		if (copy > 0) {
 			skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 			struct page *page = frag->page;
 


