Return-Path: <linux-kernel-owner+w=401wt.eu-S1759030AbYHFNc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759030AbYHFNc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756444AbYHFNbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:31:18 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:57752 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757688AbYHFNbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:31:16 -0400
X-BigFish: VPS2(zz1442Jzz10d3izzz32i6bh43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0K56LJM-02-PBT-01
Date: Wed, 6 Aug 2008 15:30:16 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: x86:  compile pat debugfs interface only if CONFIG_X86_PAT is set
Message-ID: <20080806133016.GH5427@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 06 Aug 2008 13:30:20.0909 (UTC) FILETIME=[92D631D0:01C8F7C8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/mm/pat.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

Recently I've run a kernel w/o PAT support and wondered why there was
a file "x86/pat_memtype_list" in debugfs. Of course it's empty if PAT
is disabled ... so just get rid of this interface if PAT is disabled.

Please apply. (patch against v2.6.27-rc2)


Andreas

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 2fe3091..647b1c4 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -492,7 +492,7 @@ void unmap_devmem(unsigned long pfn, unsigned long size, pgprot_t vma_prot)
 	free_memtype(addr, addr + size);
 }
 
-#if defined(CONFIG_DEBUG_FS)
+#if defined(CONFIG_DEBUG_FS) && defined(CONFIG_X86_PAT)
 
 /* get Nth element of the linked list */
 static struct memtype *memtype_get_idx(loff_t pos)
@@ -576,4 +576,4 @@ static int __init pat_memtype_list_init(void)
 
 late_initcall(pat_memtype_list_init);
 
-#endif /* CONFIG_DEBUG_FS */
+#endif /* CONFIG_DEBUG_FS && CONFIG_X86_PAT */
-- 
1.5.6.4



