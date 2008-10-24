Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbYJXSs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbYJXSs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 14:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbYJXSss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 14:48:48 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41585 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511AbYJXSsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 14:48:47 -0400
Subject: [Cbe-oss-dev] [PATCH] Cell OProfile: Incorrect local array size in
	activate spu profiling function
From: Carl Love <cel@us.ibm.com>
To: oprofile-list@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       cel@linux.vnet.ibm.com, cbe-oss-dev@ozlabs.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 24 Oct 2008 11:47:29 -0700
Message-Id: <1224874049.20229.5.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The size of the pm_signal_local array should be equal to the
number of SPUs being configured in the call.  Currently, the
array is of size 4 (NR_PHYS_CTRS) but being indexed by a for 
loop from 0 to 7 (NUM_SPUS_PER_NODE).  

Signed-off-by: Carl Love <carll@us.ibm.com>


Index: Cell_kernel_10_24_2008/arch/powerpc/oprofile/op_model_cell.c
===================================================================
--- Cell_kernel_10_24_2008.orig/arch/powerpc/oprofile/op_model_cell.c
+++ Cell_kernel_10_24_2008/arch/powerpc/oprofile/op_model_cell.c
@@ -830,7 +830,7 @@ static int calculate_lfsr(int n)
 static int pm_rtas_activate_spu_profiling(u32 node)
 {
 	int ret, i;
-	struct pm_signal pm_signal_local[NR_PHYS_CTRS];
+	struct pm_signal pm_signal_local[NUM_SPUS_PER_NODE];
 
 	/*
 	 * Set up the rtas call to configure the debug bus to


