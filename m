Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbZCRKAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbZCRKAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 06:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118AbZCRKAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 06:00:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:34931 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009AbZCRKAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 06:00:42 -0400
Date: Wed, 18 Mar 2009 10:00:00 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       joerg.roedel@amd.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joerg.roedel@amd.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090317120112.GP6159@amd.com>
References: <20090317120112.GP6159@amd.com>
Subject: [tip:core/iommu] dma-debug: fix dma_debug_add_bus() definition for !CONFIG_DMA_API_DEBUG
Message-ID: <tip-84be58d4601c86306cd939ebf58a9b90989883a4@git.kernel.org>
Git-Commit-ID: 84be58d4601c86306cd939ebf58a9b90989883a4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 18 Mar 2009 10:00:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  84be58d4601c86306cd939ebf58a9b90989883a4
Gitweb:     http://git.kernel.org/tip/84be58d4601c86306cd939ebf58a9b90989883a4
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 18 Mar 2009 11:50:29 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 18 Mar 2009 11:53:48 +0100

dma-debug: fix dma_debug_add_bus() definition for !CONFIG_DMA_API_DEBUG

Impact: build fix

Fix:

 arch/x86/kvm/x86.o: In function `dma_debug_add_bus':
 (.text+0x0): multiple definition of `dma_debug_add_bus'

dma_debug_add_bus() should be a static inline function.

Cc: Joerg Roedel <joerg.roedel@amd.com>
LKML-Reference: <20090317120112.GP6159@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/dma-debug.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/dma-debug.h b/include/linux/dma-debug.h
index e851d23..28d53cb 100644
--- a/include/linux/dma-debug.h
+++ b/include/linux/dma-debug.h
@@ -83,7 +83,7 @@ extern void debug_dma_dump_mappings(struct device *dev);
 
 #else /* CONFIG_DMA_API_DEBUG */
 
-void dma_debug_add_bus(struct bus_type *bus)
+static inline void dma_debug_add_bus(struct bus_type *bus)
 {
 }
 
