Return-Path: <linux-kernel-owner+w=401wt.eu-S1762613AbZGAAw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762613AbZGAAw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761389AbZGAAe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:29 -0400
Received: from kroah.org ([198.145.64.141]:60175 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761336AbZGAAe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:26 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:19 2009
Message-Id: <20090701002419.250025565@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dave Jones <davej@redhat.com>, "David S. Miller" <davem@davemloft.net>
Subject: [patch 022/108] via-velocity: Fix velocity driver unmapping incorrect size.
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=via-velocity-fix-velocity-driver-unmapping-incorrect-size.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Jones <davej@redhat.com>

[ Upstream commit f6b24caaf933a466397915a08e30e885a32f905a ]

When a packet is greater than ETH_ZLEN, we end up assigning the
boolean result of a comparison to the size we unmap.

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/via-velocity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/via-velocity.c
+++ b/drivers/net/via-velocity.c
@@ -1845,7 +1845,7 @@ static void velocity_free_tx_buf(struct 
 	 */
 	if (tdinfo->skb_dma) {
 
-		pktlen = (skb->len > ETH_ZLEN ? : ETH_ZLEN);
+		pktlen = max_t(unsigned int, skb->len, ETH_ZLEN);
 		for (i = 0; i < tdinfo->nskb_dma; i++) {
 #ifdef VELOCITY_ZERO_COPY_SUPPORT
 			pci_unmap_single(vptr->pdev, tdinfo->skb_dma[i], le16_to_cpu(td->tdesc1.len), PCI_DMA_TODEVICE);


