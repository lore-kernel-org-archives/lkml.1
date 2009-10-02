Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbZJBBgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbZJBBgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932151AbZJBBgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:36:36 -0400
Received: from kroah.org ([198.145.64.141]:33605 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932126AbZJBBeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:34:25 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:27 2009
Message-Id: <20091002012427.563771141@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kashyap Desai <kashyap.desai@lsi.com>,
       James Bottomley <James.Bottomley@suse.de>,
       Jan Beulich <JBeulich@novell.com>
Subject: [130/136] [SCSI] mptsas : PAE Kernel more than 4 GB kernel panic
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=mptsas-pae-kernel-more-than-4-gb-kernel-panic.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Kashyap, Desai <kashyap.desai@lsi.com>

commit c55b89fba9872ebcd5ac15cdfdad29ffb89329f0 upstream.

This patch is solving problem for PAE kernel DMA operation.
On PAE system dma_addr and unsigned long will have different
values.
Now dma_addr is not type casted using unsigned long.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Cc: Jan Beulich <JBeulich@novell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/message/fusion/mptbase.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1015,9 +1015,9 @@ mpt_add_sge_64bit(void *pAddr, u32 flags
 {
 	SGESimple64_t *pSge = (SGESimple64_t *) pAddr;
 	pSge->Address.Low = cpu_to_le32
-			(lower_32_bits((unsigned long)(dma_addr)));
+			(lower_32_bits(dma_addr));
 	pSge->Address.High = cpu_to_le32
-			(upper_32_bits((unsigned long)dma_addr));
+			(upper_32_bits(dma_addr));
 	pSge->FlagsLength = cpu_to_le32
 			((flagslength | MPT_SGE_FLAGS_64_BIT_ADDRESSING));
 }
@@ -1038,8 +1038,8 @@ mpt_add_sge_64bit_1078(void *pAddr, u32 
 	u32 tmp;
 
 	pSge->Address.Low = cpu_to_le32
-			(lower_32_bits((unsigned long)(dma_addr)));
-	tmp = (u32)(upper_32_bits((unsigned long)dma_addr));
+			(lower_32_bits(dma_addr));
+	tmp = (u32)(upper_32_bits(dma_addr));
 
 	/*
 	 * 1078 errata workaround for the 36GB limitation
@@ -1101,7 +1101,7 @@ mpt_add_chain_64bit(void *pAddr, u8 next
 		pChain->NextChainOffset = next;
 
 		pChain->Address.Low = cpu_to_le32(tmp);
-		tmp = (u32)(upper_32_bits((unsigned long)dma_addr));
+		tmp = (u32)(upper_32_bits(dma_addr));
 		pChain->Address.High = cpu_to_le32(tmp);
 }
 


