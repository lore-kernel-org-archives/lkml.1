Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab0CCCaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 21:30:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753044Ab0CCCaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 21:30:00 -0500
Date: Tue, 2 Mar 2010 18:29:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH -mm 7/7] pci: move pci_set_dma_mask and
 pci_set_consistent_dma_mask to pci-dma-compat.h
Message-Id: <20100302182927.0099eb68.akpm@linux-foundation.org>
In-Reply-To: <1265967212-9126-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1265967212-9126-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1265967212-9126-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010 18:33:32 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> We can use pci-dma-compat.h to implement pci_set_dma_mask and
> pci_set_consistent_dma_mask as we do with the other PCI DMA API.
> 
> We can remove HAVE_ARCH_PCI_SET_DMA_MASK too.

i386 allnoconfig:

include/asm-generic/pci-dma-compat.h:105: error: redefinition of 'pci_set_dma_mask'
include/linux/pci.h:1092: error: previous definition of 'pci_set_dma_mask' was here
include/asm-generic/pci-dma-compat.h:110: error: redefinition of 'pci_set_consistent_dma_mask'
include/linux/pci.h:1097: error: previous definition of 'pci_set_consistent_dma_mask' was here

In fact the whole of include/asm-generic/pci-dma-compat.h seems a bit
fishy when CONFIG_PCI=n.  Shouldn't all those functions be
EIO-returning stubs?


