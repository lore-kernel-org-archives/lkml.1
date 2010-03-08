Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab0CHGyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 01:54:54 -0500
Received: from sh.osrg.net ([192.16.179.4]:52211 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab0CHGys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 01:54:48 -0500
Date: Mon, 8 Mar 2010 15:54:36 +0900
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] Documentation: fix block/biodoc.txt dma mapping description
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100308155252Z.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 08 Mar 2010 15:54:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- It looks incorrect to use blk_rq_map_sg with pci_map_page here about
  DMA mappings. dma_map_sg?

- better to use dma_map_page instead of pci_map_page.
  http://marc.info/?l=linux-kernel&m=126596737604808&w=2

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 Documentation/block/biodoc.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/block/biodoc.txt b/Documentation/block/biodoc.txt
index 6fab97e..508b5b2 100644
--- a/Documentation/block/biodoc.txt
+++ b/Documentation/block/biodoc.txt
@@ -1162,8 +1162,8 @@ where a driver received a request ala this before:
 
 As mentioned, there is no virtual mapping of a bio. For DMA, this is
 not a problem as the driver probably never will need a virtual mapping.
-Instead it needs a bus mapping (pci_map_page for a single segment or
-use blk_rq_map_sg for scatter gather) to be able to ship it to the driver. For
+Instead it needs a bus mapping (dma_map_page for a single segment or
+use dma_map_sg for scatter gather) to be able to ship it to the driver. For
 PIO drivers (or drivers that need to revert to PIO transfer once in a
 while (IDE for example)), where the CPU is doing the actual data
 transfer a virtual mapping is needed. If the driver supports highmem I/O,
-- 
1.6.5

