Return-Path: <linux-kernel-owner+w=401wt.eu-S1757243AbXJ2MuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbXJ2MuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 08:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756537AbXJ2Mtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 08:49:39 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:41593 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756477AbXJ2Mti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 08:49:38 -0400
Date: Mon, 29 Oct 2007 13:49:47 +0100
From: Adrian Bunk <bunk@kernel.org>
To: tony.luck@intel.com
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] ia64/mm/init.c: fix section mismatches
Message-ID: <20071029124947.GM7227@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatches:

<--  snip  -->

...
WARNING: vmlinux.o(.text+0x5b5c2): Section mismatch: reference to .init.text:memmap_init_zone (between 'memmap_init' and 'virtual_memmap_init')
WARNING: vmlinux.o(.text+0x5b842): Section mismatch: reference to .init.text:memmap_init_zone (between 'virtual_memmap_init' and 'ia64_mmu_init')
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/ia64/mm/init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

45c99ede63b0f76fe3dcc906ae550193a4d41626 
diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index c6c19bf..25aef62 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -472,7 +472,7 @@ struct memmap_init_callback_data {
 	unsigned long zone;
 };
 
-static int
+static int __meminit
 virtual_memmap_init (u64 start, u64 end, void *arg)
 {
 	struct memmap_init_callback_data *args;
@@ -503,7 +503,7 @@ virtual_memmap_init (u64 start, u64 end, void *arg)
 	return 0;
 }
 
-void
+void __meminit
 memmap_init (unsigned long size, int nid, unsigned long zone,
 	     unsigned long start_pfn)
 {

