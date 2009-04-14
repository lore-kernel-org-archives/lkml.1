Return-Path: <linux-kernel-owner+w=401wt.eu-S1754988AbZDNAzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbZDNAzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 20:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbZDNAzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 20:55:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:49790 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbZDNAzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 20:55:31 -0400
Date: Tue, 14 Apr 2009 00:54:36 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, jaswinder@kernel.org,
       jaswinderrajput@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, fujita.tomonori@lab.ntt.co.jp,
       jaswinderrajput@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1239558861.3938.2.camel@localhost.localdomain>
References: <1239558861.3938.2.camel@localhost.localdomain>
Subject: [tip:x86/urgent] x86: pci-swiotlb.c swiotlb_dma_ops should be static
Message-ID: <tip-ff6c6fed3a8ab9b0a7b02574e095e905e89421d9@git.kernel.org>
Git-Commit-ID: ff6c6fed3a8ab9b0a7b02574e095e905e89421d9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 00:54:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ff6c6fed3a8ab9b0a7b02574e095e905e89421d9
Gitweb:     http://git.kernel.org/tip/ff6c6fed3a8ab9b0a7b02574e095e905e89421d9
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Sun, 12 Apr 2009 23:24:21 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 14 Apr 2009 02:51:04 +0200

x86: pci-swiotlb.c swiotlb_dma_ops should be static

Impact: reduce kernel size a bit, address sparse warning

Addresses the problem pointed out by this sparse warning:

  arch/x86/kernel/pci-swiotlb.c:53:20: warning: symbol 'swiotlb_dma_ops' was not declared. Should it be static?

For x86: swiotlb_dma_ops can be static, because it's not used outside
of pci-swiotlb.c

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
LKML-Reference: <1239558861.3938.2.camel@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/pci-swiotlb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index 34f12e9..221a385 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -50,7 +50,7 @@ static void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	return swiotlb_alloc_coherent(hwdev, size, dma_handle, flags);
 }
 
-struct dma_map_ops swiotlb_dma_ops = {
+static struct dma_map_ops swiotlb_dma_ops = {
 	.mapping_error = swiotlb_dma_mapping_error,
 	.alloc_coherent = x86_swiotlb_alloc_coherent,
 	.free_coherent = swiotlb_free_coherent,
