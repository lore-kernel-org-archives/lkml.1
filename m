Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbZKJMfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbZKJMfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 07:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbZKJMfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 07:35:50 -0500
Received: from sh.osrg.net ([192.16.179.4]:49426 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbZKJMfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 07:35:50 -0500
Date: Tue, 10 Nov 2009 21:35:17 +0900
To: mingo@elte.hu
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, dwmw2@infradead.org, joerg.roedel@amd.com,
       muli@il.ibm.com
Subject: Re: [PATCH v2 0/9] x86: handle HW IOMMU initialization failure
 gracefully
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091110115555.GA29383@elte.hu>
References: <1257849980-22640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20091110111919.GA20353@elte.hu>
	<20091110115555.GA29383@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091110213459P.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 10 Nov 2009 21:35:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Nov 2009 12:55:55 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> hm, one of the swiotlb patches caused this bootup crash:

Sorry about that. I totally forgot about x86_32.

the following patch fixes this? Sorry that I'm away from the workplace
and can't test it.

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index a234e63..63eebee 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -129,6 +129,8 @@ void __init pci_iommu_alloc(void)
 #ifdef CONFIG_X86_64
 	/* free the range so iommu could get some range less than 4G */
 	dma32_free_bootmem();
+#else
+	dma_ops = &nommu_dma_ops;
 #endif
 	pci_swiotlb_init();
 	if (use_swiotlb)
