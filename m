Return-Path: <linux-kernel-owner+w=401wt.eu-S1752942AbYE1Oh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbYE1Oh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 10:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbYE1OhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 10:37:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbYE1OhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 10:37:12 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Specify the minimum slab/kmalloc alignment
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: penberg@cs.helsinki.fi, dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 28 May 2008 15:36:34 +0100
Message-ID: <20080528143634.29463.2720.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Specify the minimum slab/kmalloc alignment to be 8 bytes.  This fixes a crash
when SLOB is selected as the memory allocator.  The FRV arch needs this so
that it can use the load- and store-double instructions without faulting.  By
default SLOB sets the minimum to be 4 bytes.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/asm-frv/mem-layout.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)


diff --git a/include/asm-frv/mem-layout.h b/include/asm-frv/mem-layout.h
index 734a1d0..8a15c90 100644
--- a/include/asm-frv/mem-layout.h
+++ b/include/asm-frv/mem-layout.h
@@ -31,6 +31,13 @@
 
 #define PAGE_MASK			(~(PAGE_SIZE-1))
 
+/*
+ * the slab must be aligned such that load- and store-double instructions don't
+ * fault if used
+ */
+#define	ARCH_KMALLOC_MINALIGN		(sizeof(long) * 2)
+#define	ARCH_SLAB_MINALIGN		(sizeof(long) * 2)
+
 /*****************************************************************************/
 /*
  * virtual memory layout from kernel's point of view

