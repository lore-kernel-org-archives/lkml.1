Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbYE1TQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbYE1TQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 15:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbYE1TQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 15:16:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752064AbYE1TQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 15:16:37 -0400
Date: Wed, 28 May 2008 12:15:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Specify the minimum slab/kmalloc alignment
Message-Id: <20080528121535.bf766e95.akpm@linux-foundation.org>
In-Reply-To: <25268.1211989741@redhat.com>
References: <20080528143634.29463.2720.stgit@warthog.procyon.org.uk>
	<25268.1211989741@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008 16:49:01 +0100
David Howells <dhowells@redhat.com> wrote:

> David Howells <dhowells@redhat.com> wrote:
> 
> > +#define	ARCH_KMALLOC_MINALIGN		(sizeof(long) * 2)
> > +#define	ARCH_SLAB_MINALIGN		(sizeof(long) * 2)
> 
> This doesn't work if SLAB is selected and slab debugging is enabled as these
> are passed to the preprocessor.
> 

So.. like this?

From: David Howells <dhowells@redhat.com>

Specify the minimum slab/kmalloc alignment to be 8 bytes.  This fixes a
crash when SLOB is selected as the memory allocator.  The FRV arch needs
this so that it can use the load- and store-double instructions without
faulting.  By default SLOB sets the minimum to be 4 bytes.

We need to use literal constants here as slab evaluates these within cpp.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-frv/mem-layout.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN include/asm-frv/mem-layout.h~frv-specify-the-minimum-slab-kmalloc-alignment include/asm-frv/mem-layout.h
--- a/include/asm-frv/mem-layout.h~frv-specify-the-minimum-slab-kmalloc-alignment
+++ a/include/asm-frv/mem-layout.h
@@ -31,6 +31,13 @@
 
 #define PAGE_MASK			(~(PAGE_SIZE-1))
 
+/*
+ * the slab must be aligned such that load- and store-double instructions don't
+ * fault if used
+ */
+#define	ARCH_KMALLOC_MINALIGN		8 /* (sizeof(long) * 2) */
+#define	ARCH_SLAB_MINALIGN		8 /* (sizeof(long) * 2) */
+
 /*****************************************************************************/
 /*
  * virtual memory layout from kernel's point of view
_

