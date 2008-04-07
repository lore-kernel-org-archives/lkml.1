Return-Path: <linux-kernel-owner+w=401wt.eu-S1756992AbYDGW1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992AbYDGW1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 18:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbYDGW06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 18:26:58 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:52064 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbYDGW05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 18:26:57 -0400
Message-ID: <47FA9FA6.8090201@tiscali.nl>
Date: Tue, 08 Apr 2008 00:26:46 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: jwboyer@linux.vnet.ibm.com
CC: linuxppc-dev@ozlabs.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1 resend][PPC] replace logical by bitand in pci_process_ISA_OF_ranges(),
 arch/powerpc/kernel/isa-bridge.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in arch/powerpc/kernel/isa-bridge.c:
41:#define ISA_SPACE_MASK 0x1
42:#define ISA_SPACE_IO 0x1
...

83:    if ((range->isa_addr.a_hi && ISA_SPACE_MASK) != ISA_SPACE_IO) {
...
89:    if ((range->isa_addr.a_hi && ISA_SPACE_MASK) != ISA_SPACE_IO)

I think these should be single &'s, I can't test it (no hardware)
please consider the patch below.
--
replace logical by bit and for ISA_SPACE_MASK

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/powerpc/kernel/isa-bridge.c b/arch/powerpc/kernel/isa-bridge.c
index f0f49d1..406a9e6 100644
--- a/arch/powerpc/kernel/isa-bridge.c
+++ b/arch/powerpc/kernel/isa-bridge.c
@@ -80,13 +80,13 @@ static void __devinit pci_process_ISA_OF_ranges(struct device_node *isa_node,
 	 *			(size depending on dev->n_addr_cells)
 	 *   cell 5:		the size of the range
 	 */
-	if ((range->isa_addr.a_hi && ISA_SPACE_MASK) != ISA_SPACE_IO) {
+	if ((range->isa_addr.a_hi & ISA_SPACE_MASK) != ISA_SPACE_IO) {
 		range++;
 		rlen -= sizeof(struct isa_range);
 		if (rlen < sizeof(struct isa_range))
 			goto inval_range;
 	}
-	if ((range->isa_addr.a_hi && ISA_SPACE_MASK) != ISA_SPACE_IO)
+	if ((range->isa_addr.a_hi & ISA_SPACE_MASK) != ISA_SPACE_IO)
 		goto inval_range;
 
 	isa_addr = range->isa_addr.a_lo;

