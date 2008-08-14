Return-Path: <linux-kernel-owner+w=401wt.eu-S1759618AbYHNSm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618AbYHNSm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 14:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbYHNSmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 14:42:47 -0400
Received: from cpsmtpo-eml03.kpnxchange.com ([213.75.38.152]:57451 "EHLO
	cpsmtpo-eml03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379AbYHNSmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 14:42:46 -0400
To: linux-kernel@vger.kernel.org
Subject: [regression?] [resend] Memory zone info seems incomplete in boottime dmesg output
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Disposition: inline
From: Frans Pop <elendil@planet.nl>
Date: Thu, 14 Aug 2008 20:42:23 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200808142042.24606.elendil@planet.nl>
X-OriginalArrivalTime: 14 Aug 2008 18:42:44.0851 (UTC) FILETIME=[8A66C430:01C8FE3D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 2.6.26 I get:
<snip>
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[4] active PFN ranges
    0:        0 ->      159
    0:      256 ->   521844
    0:   521961 ->   521964
    0:   521983 ->   521984
On node 0 totalpages: 521751
  DMA zone: 56 pages used for memmap
  DMA zone: 1271 pages reserved
  DMA zone: 2672 pages, LIFO batch:0
  DMA32 zone: 7081 pages used for memmap
  DMA32 zone: 510671 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
</snip>

With 2.6.27-rc1 I only get pages listed for 2 zones (bottom part):
<snip>
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[4] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0007f674
    0: 0x0007f6e9 -> 0x0007f6ec
    0: 0x0007f6ff -> 0x0007f700
On node 0 totalpages: 521751
  DMA zone: 2072 pages, LIFO batch:0
  DMA32 zone: 506625 pages, LIFO batch:31
</snip>

Note that totalpages is the same and that for 2.6.26 the sum of pages for 
all listed zones is equal to totalpages. Seems we've lost useful info 
here.

I also seem to have "lost" 600 LIFO batch pages for DMA and 4000 for DMA32 
between the kernel versions although that could be due to config changes 
(I enabled some extra debugging options). Harder to tell though without 
the info where they've gone...

Cheers,
FJP

P.S. As a user I really don't find the hex values easier to read/use than 
the decimal values. Except maybe for the "Zone PFN ranges" where things 
seem to be nicely aligned.
