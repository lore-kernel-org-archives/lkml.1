Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbZDUOhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbZDUOhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 10:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbZDUOhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 10:37:21 -0400
Received: from relay3.sgi.com ([192.48.156.57]:32895 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752553AbZDUOhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 10:37:20 -0400
Date: Tue, 21 Apr 2009 09:23:13 -0500
From: Russ Anderson <rja@sgi.com>
To: linux-next@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Cc: Russ Anderson <rja@sgi.com>
Subject: [patch] x86: UV: Pass PAGE_OFFSET to bios for runtime access to chipset registers.
Message-ID: <20090421142313.GA32733@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass PAGE_OFFSET to bios for runtime access to chipset registers.

Signed-off-by: Russ Anderson <rja@sgi.com>

---
 arch/x86/kernel/bios_uv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86/kernel/bios_uv.c
===================================================================
--- linux.orig/arch/x86/kernel/bios_uv.c	2009-04-20 14:38:47.000000000 -0500
+++ linux/arch/x86/kernel/bios_uv.c	2009-04-20 14:41:01.000000000 -0500
@@ -84,7 +84,7 @@ s64 uv_bios_get_sn_info(int fc, int *uvt
 	union partition_info_u part;
 
 	ret = uv_bios_call_irqsave(UV_BIOS_GET_SN_INFO, fc,
-				(u64)(&v0), (u64)(&v1), 0, 0);
+				(u64)(&v0), (u64)(&v1), (u64)PAGE_OFFSET, 0);
 	if (ret != BIOS_STATUS_SUCCESS)
 		return ret;
 
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
