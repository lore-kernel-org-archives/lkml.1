Return-Path: <linux-kernel-owner+w=401wt.eu-S932102AbZJBBeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbZJBBeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756878AbZJBBeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:34:06 -0400
Received: from kroah.org ([198.145.64.141]:33429 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756813AbZJBBd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:59 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:23 2009
Message-Id: <20091002012423.361613736@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [103/136] USB: xhci: Fix slot and endpoint context debugging.
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=usb-xhci-fix-slot-and-endpoint-context-debugging.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 018218d1d9eb06116d24a02dd5e7a390f0353d0f upstream.

Use the virtual address of the memory hardware uses, not the address for
the container of that memory.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-dbg.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-dbg.c
+++ b/drivers/usb/host/xhci-dbg.c
@@ -413,7 +413,8 @@ void xhci_dbg_slot_ctx(struct xhci_hcd *
 	int i;
 
 	struct xhci_slot_ctx *slot_ctx = xhci_get_slot_ctx(xhci, ctx);
-	dma_addr_t dma = ctx->dma + ((unsigned long)slot_ctx - (unsigned long)ctx);
+	dma_addr_t dma = ctx->dma +
+		((unsigned long)slot_ctx - (unsigned long)ctx->bytes);
 	int csz = HCC_64BYTE_CONTEXT(xhci->hcc_params);
 
 	xhci_dbg(xhci, "Slot Context:\n");
@@ -459,7 +460,7 @@ void xhci_dbg_ep_ctx(struct xhci_hcd *xh
 	for (i = 0; i < last_ep_ctx; ++i) {
 		struct xhci_ep_ctx *ep_ctx = xhci_get_ep_ctx(xhci, ctx, i);
 		dma_addr_t dma = ctx->dma +
-			((unsigned long)ep_ctx - (unsigned long)ctx);
+			((unsigned long)ep_ctx - (unsigned long)ctx->bytes);
 
 		xhci_dbg(xhci, "Endpoint %02d Context:\n", i);
 		xhci_dbg(xhci, "@%p (virt) @%08llx (dma) %#08x - ep_info\n",


