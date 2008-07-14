Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbYGNRR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbYGNRR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 13:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbYGNRRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 13:17:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:64522 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbYGNRRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 13:17:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=SM9URsiNNPCBSwvK5MZw7Pk29O1pIheSvBQl/ZsY94GJ1kGwurTsqfeW9oTNUquLzm
         xOZunuFJgUhuXq88mAWnJIlZoqXviBDkimjJBFRBM79F4kJmEhmF8M9/bnx6tO282bZ1
         4Kd+84fmpDHW6V+McGPgBDlQEXUo3V/XtsXAc=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Greg KH <greg@kroah.com>, stable@kernel.org, Joe Jin <joe.jin@oracle.com>
Subject: [PATCH] x86_64: reserve crashkernel bootmem before reserve dma32 bootmem
Date: Mon, 14 Jul 2008 10:16:40 -0700
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, "Greg Kroah-Hartman" <gregkh@suse.de>,
       greg.marsden@oracle.com, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, tao.ma@oracle.com
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807141016.40572.yhlu.kernel@gmail.com>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Jin <joe.jin@oracle.com>

Before reserve_crashkernel, dma32_reserve_bootmem would reserve 128M memory.
this cuased crashkernel end address must less than 64M or start address must
more than 192M except crashkernel memory reserved before dma32 memory reserved.

Signed-off-by: Joe Jin <joe.jin@oracle.com>
Acked-by: Yinghai Lu <yhlu.kernel@gmail.com>
Acked-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/setup_64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -444,8 +444,6 @@ void __init setup_arch(char **cmdline_p)
 	contig_initmem_init(0, end_pfn);
 #endif
 
-	dma32_reserve_bootmem();
-
 #ifdef CONFIG_ACPI_SLEEP
 	/*
 	 * Reserve low memory region for sleep support.
@@ -486,6 +484,8 @@ void __init setup_arch(char **cmdline_p)
 #endif
 	reserve_crashkernel();
 
+	dma32_reserve_bootmem();
+
 	reserve_ibft_region();
 
 	paging_init();
