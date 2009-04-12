Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbZDLRzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbZDLRzH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 13:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbZDLRyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 13:54:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:39247 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbZDLRyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 13:54:51 -0400
Subject: [PATCH -tip] x86: pci-swiotlb.c swiotlb_dma_ops should be static
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 12 Apr 2009 23:24:21 +0530
Message-Id: <1239558861.3938.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: reduce kernel size a bit, address sparse warning

Addresses the problem pointed out by this sparse warning:
  arch/x86/kernel/pci-swiotlb.c:53:20: warning: symbol 'swiotlb_dma_ops' was not declared. Should it be static?

For x86: swiotlb_dma_ops can be static, because it's not used outside pci-swiotlb.c

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/pci-swiotlb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index 887388a..a1712f2 100644
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
-- 
1.6.0.6


