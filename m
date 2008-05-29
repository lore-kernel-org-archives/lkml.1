Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbYE2NKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbYE2NKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbYE2NKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:10:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577AbYE2NKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:10:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <8bd0f97a0805281335q7a26be97ie83feef6e7da2276@mail.gmail.com>
References: <8bd0f97a0805281335q7a26be97ie83feef6e7da2276@mail.gmail.com> <2874.1211980355@redhat.com> <Pine.LNX.4.64.0805221907250.4056@sbz-30.cs.Helsinki.FI> <24762.1211983758@redhat.com> <Pine.LNX.4.64.0805281026210.22589@schroedinger.engr.sgi.com> <7613.1211996335@redhat.com>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: dhowells@redhat.com, "Christoph Lameter" <clameter@sgi.com>,
       "Pekka J Enberg" <penberg@cs.helsinki.fi>, mpm@selenic.com,
       lethal@linux-sh.org, linux-kernel@vger.kernel.org,
       "Bryan Wu" <cooloney@kernel.org>
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 29 May 2008 14:03:28 +0100
Message-ID: <29553.1212066208@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier.adi@gmail.com> wrote:

> > I fixed it by setting ARCH_KMALLOC_MINALIGN and ARCH_SLAB_MINALIGN.
> 
> what was the change exactly ?

The attached patch.

David
---
[PATCH] FRV: Specify the minimum slab/kmalloc alignment

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
index 734a1d0..2947764 100644
--- a/include/asm-frv/mem-layout.h
+++ b/include/asm-frv/mem-layout.h
@@ -31,6 +31,13 @@
 
 #define PAGE_MASK			(~(PAGE_SIZE-1))
 
+/*
+ * the slab must be aligned such that load- and store-double instructions don't
+ * fault if used
+ */
+#define	ARCH_KMALLOC_MINALIGN		8
+#define	ARCH_SLAB_MINALIGN		8
+
 /*****************************************************************************/
 /*
  * virtual memory layout from kernel's point of view
