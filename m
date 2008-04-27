Return-Path: <linux-kernel-owner+w=401wt.eu-S1762561AbYD0Wee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762561AbYD0Wee (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 18:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbYD0WeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 18:34:25 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37184 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751999AbYD0WeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 18:34:25 -0400
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20080427214837.GA11631@elte.hu>
References: <1209329485.3801.46.camel@localhost.localdomain>
	 <20080427214837.GA11631@elte.hu>
Content-Type: text/plain
Date: Sun, 27 Apr 2008 18:34:20 -0400
Message-Id: <1209335660.3801.79.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's another piece of the x86 API that's designed to be cached.  The
dma_declare_coherent_memory() usually represents behind bridge memory
that's fully participatory in the coherence model.

Making it uncached damages the utility of this memory because doing
cacheline sized burst cycles when needed to it is far faster than
individual byte/word/quad writes.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 388b113..df83ffd 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -214,7 +214,7 @@ int dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
 
 	/* FIXME: this routine just ignores DMA_MEMORY_INCLUDES_CHILDREN */
 
-	mem_base = ioremap(bus_addr, size);
+	mem_base = ioremap_cache(bus_addr, size);
 	if (!mem_base)
 		goto out;
 


