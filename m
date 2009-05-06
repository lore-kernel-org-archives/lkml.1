Return-Path: <linux-kernel-owner+w=401wt.eu-S1761009AbZEFWAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761009AbZEFWAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761427AbZEFVyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:54:33 -0400
Received: from kroah.org ([198.145.64.141]:57010 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761168AbZEFVy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:29 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:47:57 2009
Message-Id: <20090506214757.214311770@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:45:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Michael Buesch <mb@bu3sch.de>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 14/58] b44: Use kernel DMA addresses for the kernel DMA API
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=b44-use-kernel-dma-addresses-for-the-kernel-dma-api.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Buesch <mb@bu3sch.de>

commit 37efa239901493694a48f1d6f59f8de17c2c4509 upstream.

We must not use the device DMA addresses for the kernel DMA API, because
device DMA addresses have an additional offset added for the SSB translation.

Use the original dma_addr_t for the sync operation.

Cc: stable@kernel.org
Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/b44.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/b44.c
+++ b/drivers/net/b44.c
@@ -750,7 +750,7 @@ static void b44_recycle_rx(struct b44 *b
 					     dest_idx * sizeof(dest_desc),
 					     DMA_BIDIRECTIONAL);
 
-	ssb_dma_sync_single_for_device(bp->sdev, le32_to_cpu(src_desc->addr),
+	ssb_dma_sync_single_for_device(bp->sdev, dest_map->mapping,
 				       RX_PKT_BUF_SZ,
 				       DMA_FROM_DEVICE);
 }


