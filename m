Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab0CDBXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 20:23:12 -0500
Received: from sh.osrg.net ([192.16.179.4]:34902 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770Ab0CDBXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 20:23:06 -0500
Date: Thu, 4 Mar 2010 10:22:54 +0900
To: randy.dunlap@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: mmotm 2010-03-02-18-38 uploaded (dma unmapping)
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4B8EEEBA.70001@oracle.com>
References: <4B8EB65F.9060800@oracle.com>
	<20100304080822V.fujita.tomonori@lab.ntt.co.jp>
	<4B8EEEBA.70001@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100304102217B.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 04 Mar 2010 10:22:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Mar 2010 15:20:26 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> >> drivers/net/chelsio/sge.c:164: error: expected specifier-qualifier-list before 'DECLARE_DMA_UNMAP_ADDR'
> >> drivers/net/chelsio/sge.c:170: error: expected specifier-qualifier-list before 'DECLARE_DMA_UNMAP_ADDR'
> >>
> >> drivers/infiniband/hw/amso1100/c2_mq.h:74: error: expected specifier-qualifier-list before 'DECLARE_DMA_UNMAP_ADDR'
> >> drivers/infiniband/hw/amso1100/c2_provider.h:53: error: expected specifier-qualifier-list before 'DECLARE_DMA_U
> >> NMAP_ADDR'
> >>
> >> drivers/net/cxgb3/sge.c:120: error: expected specifier-qualifier-list before 'DECLARE_DMA_UNMAP_ADDR'
> >> drivers/net/cxgb3/sge.c:210: error: expected specifier-qualifier-list before 'DECLARE_DMA_UNMAP_ADDR'
> > 
> > Sorry. I can't reproduce this here. Can you send .config?
> 
> 
> Sure (attached), but there is a different config file for each driver case above.
> 
> chelsio == config-r8176
> 
> amso1100 == config-r8179
> 
> cxgb3 == config=r8186
> 
> All are ARCH=i386 builds.

Ah, somehow I put my silly typo... really sorry about that.

The following patch can be applied to mm after applying another
dma_unmap fix:

http://marc.info/?l=linux-kernel&m=126759183815898&w=2


Andrew, can you apply the following patch. This should be fold into
dma-mappingh-add-the-dma_unmap-state-api.patch after
dma-mappingh-add-the-dma_unmap-state-api-fix.patch.


=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] fix DECLARE_DMA_UNMAP_ADD_ADDR typo with CONFIG_NEED_DMA_MAP_STATE disabled

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/linux/dma-mapping.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index e00c5c9..ca32ed7 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -248,7 +248,7 @@ struct dma_attrs;
 #define dma_unmap_len(PTR, LEN_NAME)             ((PTR)->LEN_NAME)
 #define dma_unmap_len_set(PTR, LEN_NAME, VAL)    (((PTR)->LEN_NAME) = (VAL))
 #else
-#define DEFINE_DMA_MAP_ADDR(ADDR_NAME)
+#define DEFINE_DMA_UNMAP_ADDR(ADDR_NAME)
 #define DEFINE_DMA_UNMAP_LEN(LEN_NAME)
 #define dma_unmap_addr(PTR, ADDR_NAME)           (0)
 #define dma_unmap_addr_set(PTR, ADDR_NAME, VAL)  do { } while (0)
-- 
1.6.5



