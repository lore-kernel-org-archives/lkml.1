Return-Path: <linux-kernel-owner+w=401wt.eu-S1761795AbYG3Krw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761795AbYG3Krw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 06:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759781AbYG3Krf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 06:47:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:31370 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758275AbYG3Krd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 06:47:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b/mZM/ZGEclb0ebEX7Snu2eqY2+44eauxzZXyAo43qcxUF/i/JqUzC7oPz2UDI8Pd7
         Cgi8RClVPFCM1eCY2d9CXNzDs0GrSDFo9Qoo4J0riMKnVzMgeM16V8X6BbFWgQFzm7eC
         k3DF4dhiw/+csYzv5h/1H4dtX43THtXZ3/MXw=
Date: Wed, 30 Jul 2008 14:46:50 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, mingo@elte.hu
Subject: Re: dma-coherent: add documentation to new interfaces
Message-ID: <20080730104650.GA16416@doriath.ww600.siemens.net>
References: <200807290301.m6T317GG021226@hera.kernel.org> <20080729131757.16e721c5.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729131757.16e721c5.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 01:17:57PM -0700, Randy Dunlap wrote:
> On Tue, 29 Jul 2008 03:01:07 GMT Linux Kernel Mailing List wrote:
> 
> > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b6d4f7e3ef25beb8c658c97867d98883e69dc544
> > Commit:     b6d4f7e3ef25beb8c658c97867d98883e69dc544
> > Parent:     8fa8b9fbab90c74139e8e868fe5b30b6a9f6be65
> > Author:     Dmitry Baryshkov <dbaryshkov@gmail.com>
> > AuthorDate: Sun Jul 20 15:01:10 2008 +0400
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Sun Jul 20 21:22:00 2008 +0200
> > 
> >     dma-coherent: add documentation to new interfaces
> 
> Hi,
> Please fix these to be proper kernel-doc notation, as described in
> Documentation/kernel-doc-nano-HOWTO.txt ...

Please consider this patch:

>From 766159161001e2e118cc840e7aca4b8d500b1ebf Mon Sep 17 00:00:00 2001
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
Date: Wed, 30 Jul 2008 01:41:58 +0400
Subject: [PATCH] dma-coherent: fix kernel-doc comments

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 kernel/dma-coherent.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/dma-coherent.c b/kernel/dma-coherent.c
index 7517115..9ef28a0 100644
--- a/kernel/dma-coherent.c
+++ b/kernel/dma-coherent.c
@@ -93,7 +93,7 @@ void *dma_mark_declared_memory_occupied(struct device *dev,
 EXPORT_SYMBOL(dma_mark_declared_memory_occupied);
 
 /**
- * Try to allocate memory from the per-device coherent area.
+ * dma_alloc_from_coherent() - try to allocate memory from the per-device coherent area
  *
  * @dev:	device from which we allocate memory
  * @size:	size of requested memory area
@@ -101,11 +101,11 @@ EXPORT_SYMBOL(dma_mark_declared_memory_occupied);
  * @ret:	This pointer will be filled with the virtual address
  * 		to allocated area.
  *
- * This function should be only called from per-arch %dma_alloc_coherent()
+ * This function should be only called from per-arch dma_alloc_coherent()
  * to support allocation from per-device coherent memory pools.
  *
  * Returns 0 if dma_alloc_coherent should continue with allocating from
- * generic memory areas, or !0 if dma_alloc_coherent should return %ret.
+ * generic memory areas, or !0 if dma_alloc_coherent should return @ret.
  */
 int dma_alloc_from_coherent(struct device *dev, ssize_t size,
 				       dma_addr_t *dma_handle, void **ret)
@@ -127,7 +127,7 @@ int dma_alloc_from_coherent(struct device *dev, ssize_t size,
 }
 
 /**
- * Try to free the memory allocated from per-device coherent memory pool.
+ * dma_release_from_coherent() - try to free the memory allocated from per-device coherent memory pool
  * @dev:	device from which the memory was allocated
  * @order:	the order of pages allocated
  * @vaddr:	virtual address of allocated pages
@@ -136,7 +136,7 @@ int dma_alloc_from_coherent(struct device *dev, ssize_t size,
  * coherent memory pool and if so, releases that memory.
  *
  * Returns 1 if we correctly released the memory, or 0 if
- * %dma_release_coherent() should proceed with releasing memory from
+ * dma_release_coherent() should proceed with releasing memory from
  * generic pools.
  */
 int dma_release_from_coherent(struct device *dev, int order, void *vaddr)
-- 
1.5.6.3

-- 
With best wishes
Dmitry

