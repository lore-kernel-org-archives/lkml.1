Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbYG2BhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbYG2BhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 21:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbYG2Bgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 21:36:52 -0400
Received: from relay2.sgi.com ([192.48.171.30]:39035 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751783AbYG2Bgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 21:36:51 -0400
Date: Mon, 28 Jul 2008 20:36:50 -0500
From: Robin Holt <holt@sgi.com>
To: tony.luck@intel.com
Cc: bhutchings@solarflare.com, jgarzik@redhat.com,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       netdev@vger.kernel.org
Subject: [Patch] fix ia64 build failure when CONFIG_SFC=m
Message-ID: <20080729013650.GH9663@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_SFC=m uses topology_core_siblings() which, for ia64, expects
cpu_core_map to be exported.  It is not.  This patch exports the needed
symbol.

Signed-off-by: Robin Holt <holt@sgi.com>

Index: contention_unroll/arch/ia64/kernel/smpboot.c
===================================================================
--- contention_unroll.orig/arch/ia64/kernel/smpboot.c	2008-07-28 18:19:56.000000000 -0500
+++ contention_unroll/arch/ia64/kernel/smpboot.c	2008-07-28 20:25:54.240198328 -0500
@@ -138,6 +138,7 @@ cpumask_t cpu_possible_map = CPU_MASK_NO
 EXPORT_SYMBOL(cpu_possible_map);
 
 cpumask_t cpu_core_map[NR_CPUS] __cacheline_aligned;
+EXPORT_SYMBOL(cpu_core_map);
 DEFINE_PER_CPU_SHARED_ALIGNED(cpumask_t, cpu_sibling_map);
 EXPORT_PER_CPU_SYMBOL(cpu_sibling_map);
 
