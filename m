Return-Path: <linux-kernel-owner+w=401wt.eu-S934994AbXEWQ2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934994AbXEWQ2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 12:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757968AbXEWQ2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 12:28:42 -0400
Received: from holomorphy.com ([66.93.40.71]:52568 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757931AbXEWQ2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 12:28:41 -0400
Date: Wed, 23 May 2007 09:29:38 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1
Message-ID: <20070523162938.GW19966@holomorphy.com>
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
WARNING: arch/i386/kernel/built-in.o(.text+0xdba6): Section mismatch: reference to .init.data:cpu_llc_id (between 'set_cpu_sibling_map' and 'initialize_secondary')
Marking set_cpu_sibling_map() as __cpuinit resolves the section conflict
with the __cpuinitdata cpu_llc_id[] variable.

Signed-off-by: William Irwin <bill.irwin@oracle.com>

Index: mm-2.6.22-rc2/arch/i386/kernel/smpboot.c
===================================================================
--- mm-2.6.22-rc2.orig/arch/i386/kernel/smpboot.c	2007-05-23 09:15:29.377950632 -0700
+++ mm-2.6.22-rc2/arch/i386/kernel/smpboot.c	2007-05-23 09:16:27.089239410 -0700
@@ -308,7 +308,7 @@
 /* representing cpus for which sibling maps can be computed */
 static cpumask_t cpu_sibling_setup_map;
 
-void set_cpu_sibling_map(int cpu)
+void __cpuinit set_cpu_sibling_map(int cpu)
 {
 	int i;
 	struct cpuinfo_x86 *c = cpu_data;
