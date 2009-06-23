Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbZFWHP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbZFWHP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758252AbZFWHOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:14:39 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:62729 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757312AbZFWHOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:14:12 -0400
From: Len Brown <lenb@kernel.org>
To: sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 5/8] SFI: Hook e820 memory map initialization
Date: Tue, 23 Jun 2009 03:14:03 -0400
Message-id: <d3bcd312f3ebabd86c79fbd53983021e4cd7b56a.1245740912.git.len.brown@intel.com>
X-Mailer: git-send-email 1.6.3.3.334.g916e1
In-reply-to: <1245741246-6503-1-git-send-email-lenb@kernel.org>
References: <1245741246-6503-1-git-send-email-lenb@kernel.org>
In-reply-to: <7425334c8329b15bec7cb4ecd0b17af042e97465.1245740912.git.len.brown@intel.com>
References: <7425334c8329b15bec7cb4ecd0b17af042e97465.1245740912.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/kernel/e820.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 0062813..f5f5ff2 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -20,6 +20,7 @@
 #include <linux/pfn.h>
 #include <linux/suspend.h>
 #include <linux/firmware-map.h>
+#include <linux/sfi.h>
 
 #include <asm/pgtable.h>
 #include <asm/page.h>
@@ -1403,6 +1404,10 @@ char *__init default_machine_specific_memory_setup(void)
 	  < 0) {
 		u64 mem_size;
 
+		/* if SFI mmap table exists, use SFI to setup e820 mmap */
+		if (!sfi_init_memory_map())
+			return "SFI";
+
 		/* compare results from other methods and take the greater */
 		if (boot_params.alt_mem_k
 		    < boot_params.screen_info.ext_mem_k) {
-- 
1.6.0.6

