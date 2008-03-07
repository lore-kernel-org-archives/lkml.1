Return-Path: <linux-kernel-owner+w=401wt.eu-S932123AbYCGS04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123AbYCGS04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 13:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762610AbYCGS0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 13:26:05 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:52027 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758079AbYCGS0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 13:26:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=a/xulGC3fFD0czqp/oKxQHX6gfXrxbYPycWrKKC44qcX6JRLPgrSRuWw+MCVyjve1DHPQNQZ79w+ZNdP5PTK3LOaurbO0KrD1hqQTz8lGxQQ2VEjdbiVSITEew8NcM2hBQaS9AGlEfyog0G1eISdcpVh7gMguPV4gEn8XkmVcTY=
Date: Fri, 7 Mar 2008 19:25:54 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] x86: coding style fixes to arch/x86/kernel/setup_32.c
Message-ID: <20080307192554.1f5475f0@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch fixes 4 errors, no changes in the generated binary file:

paolo@paolo-desktop:/tmp/a$ size setup_32.o*
   text    data     bss     dec     hex filename
   3526    7406     885   11817    2e29 setup_32.o
   3526    7406     885   11817    2e29 setup_32.o.after

paolo@paolo-desktop:/tmp/a$ md5sum setup_32.o*
d238f977facb3b4e4ee6a18390678376  setup_32.o
d238f977facb3b4e4ee6a18390678376  setup_32.o.after


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/kernel/setup_32.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index f595d7b..b120a1c 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -372,7 +372,7 @@ unsigned long __init find_max_low_pfn(void)
 			highmem_pages = 0;
 		}
 		if (highmem_pages) {
-			if (max_low_pfn-highmem_pages < 64*1024*1024/PAGE_SIZE){
+			if (max_low_pfn-highmem_pages < 64*1024*1024/PAGE_SIZE) {
 				printk(KERN_ERR "highmem size %uMB results in smaller than 64MB lowmem, ignoring it.\n", pages_to_mb(highmem_pages));
 				highmem_pages = 0;
 			}
@@ -454,9 +454,8 @@ static unsigned long __init setup_memory(void)
 
 #ifdef CONFIG_HIGHMEM
 	highstart_pfn = highend_pfn = max_pfn;
-	if (max_pfn > max_low_pfn) {
+	if (max_pfn > max_low_pfn)
 		highstart_pfn = max_low_pfn;
-	}
 	printk(KERN_NOTICE "%ldMB HIGHMEM available.\n",
 		pages_to_mb(highend_pfn - highstart_pfn));
 	num_physpages = highend_pfn;
@@ -752,7 +751,7 @@ void __init setup_arch(char **cmdline_p)
 	apm_info.bios = boot_params.apm_bios_info;
 	ist_info = boot_params.ist_info;
 	saved_videomode = boot_params.hdr.vid_mode;
-	if( boot_params.sys_desc_table.length != 0 ) {
+	if (boot_params.sys_desc_table.length != 0) {
 		set_mca_bus(boot_params.sys_desc_table.table[3] & 0x2);
 		machine_id = boot_params.sys_desc_table.table[0];
 		machine_submodel_id = boot_params.sys_desc_table.table[1];
-- 
1.5.4.2.316.gf7a7

