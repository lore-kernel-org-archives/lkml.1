Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbYA2Vgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbYA2Vgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 16:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755153AbYA2Vgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 16:36:41 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:53319 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777AbYA2Vgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 16:36:40 -0500
Date: Tue, 29 Jan 2008 13:43:20 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: fix nodemap_size according to nodeid bits
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Travis <travis@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org
Message-id: <200801291343.21239.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: fix nodemap_size according to nodeid bits

memnode.map is s16 array because of nodeid is 16 bit now.

so need to increase the nodemap_size according to that bits.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index f0e5cab..dc3b1f7 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -92,7 +92,7 @@ static int __init allocate_cachealigned_memnodemap(void)
 
 	pad = L1_CACHE_BYTES - 1;
 	pad_addr = 0x8000;
-	nodemap_size = pad + memnodemapsize;
+	nodemap_size = pad + sizeof(s16) * memnodemapsize;
 	nodemap_addr = find_e820_area(pad_addr, end_pfn<<PAGE_SHIFT,
 				      nodemap_size);
 	if (nodemap_addr == -1UL) {
