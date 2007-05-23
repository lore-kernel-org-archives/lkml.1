Return-Path: <linux-kernel-owner+w=401wt.eu-S934560AbXEWP2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934560AbXEWP2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 11:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759368AbXEWP14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 11:27:56 -0400
Received: from holomorphy.com ([66.93.40.71]:56840 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758169AbXEWP1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 11:27:55 -0400
Date: Wed, 23 May 2007 08:28:51 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1
Message-ID: <20070523152851.GU19966@holomorphy.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 12:42:33AM -0700, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc2/2.6.22-rc2-mm1/
> - A new readahead patch series.  This needs serious review and performance
>   testing please.
> - Added Ingo's CFS CPU scheduler
> - Xen dom-U support is now in the x86 tree.

CONFIG_SPARSEMEM sans CONFIG_MEMORY_HOTPLUG trips the following warning:
mm/sparse.c:254: warning: '__kmalloc_section_usemap' defined but not used
The following patch silences it.

Signed-off-by: William Irwin <bill.irwin@oracle.com>

Index: mm-2.6.22-rc2/mm/sparse.c
===================================================================
--- mm-2.6.22-rc2.orig/mm/sparse.c	2007-05-23 08:11:48.788227631 -0700
+++ mm-2.6.22-rc2/mm/sparse.c	2007-05-23 08:12:29.274534814 -0700
@@ -250,10 +250,12 @@
 	return size_bytes;
 }
 
+#ifdef CONFIG_MEMORY_HOTPLUG
 static unsigned long *__kmalloc_section_usemap(void)
 {
 	return kmalloc(usemap_size(), GFP_KERNEL);
 }
+#endif /* CONFIG_MEMORY_HOTPLUG */
 
 static unsigned long *sparse_early_usemap_alloc(unsigned long pnum)
 {
