Return-Path: <linux-kernel-owner+w=401wt.eu-S1765383AbXEWR02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765383AbXEWR02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 13:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758225AbXEWR0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 13:26:20 -0400
Received: from holomorphy.com ([66.93.40.71]:42677 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757813AbXEWR0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 13:26:20 -0400
Date: Wed, 23 May 2007 10:27:17 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1
Message-ID: <20070523172717.GX19966@holomorphy.com>
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

This patch silences the following warning:
WARNING: drivers/built-in.o(.text+0x500fd): Section mismatch: reference to .init.data: (between 'pxm_to_node' and 'node_to_pxm')
WARNING: drivers/built-in.o(.text+0x50112): Section mismatch: reference to .init.data: (between 'node_to_pxm' and 'acpi_get_pxm')
pxm_to_node() and node_to_pxm() reference node_to_pxm_map[] and
pxm_to_node_map[], which are __cpuinitdata. This patch marks pxm_to_node()
and node_to_pxm() __cpuinit accordingly.

Signed-off-by: William Irwin <bill.irwin@oracle.com>

Index: mm-2.6.22-rc2/drivers/acpi/numa.c
===================================================================
--- mm-2.6.22-rc2.orig/drivers/acpi/numa.c	2007-05-23 09:35:02.932827713 -0700
+++ mm-2.6.22-rc2/drivers/acpi/numa.c	2007-05-23 09:35:48.919448341 -0700
@@ -43,14 +43,14 @@
 static int __cpuinitdata node_to_pxm_map[MAX_NUMNODES]
 				= { [0 ... MAX_NUMNODES - 1] = PXM_INVAL };
 
-int pxm_to_node(int pxm)
+int __cpuinit pxm_to_node(int pxm)
 {
 	if (pxm < 0)
 		return NID_INVAL;
 	return pxm_to_node_map[pxm];
 }
 
-int node_to_pxm(int node)
+int __cpuinit node_to_pxm(int node)
 {
 	if (node < 0)
 		return PXM_INVAL;
