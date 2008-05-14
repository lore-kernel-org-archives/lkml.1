Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbYENPPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbYENPPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758772AbYENPPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:15:14 -0400
Received: from relay1.sgi.com ([192.48.171.29]:48152 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758494AbYENPPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:15:12 -0400
From: Paul Jackson <pj@sgi.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Jack Steiner" <steiner@sgi.com>,
       "Mike Travis" <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>,
       Paul Jackson <pj@sgi.com>
Date: Wed, 14 May 2008 08:15:10 -0700
Message-Id: <20080514151510.148486.51487.sendpatchset@jackhammer.engr.sgi.com>
In-Reply-To: <20080514151504.148486.32236.sendpatchset@jackhammer.engr.sgi.com>
References: <20080514151504.148486.32236.sendpatchset@jackhammer.engr.sgi.com>
Subject: [PATCH 2/10] x86 boot: remove some unused extern function declarations
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com

Remove three extern declarations for routines
that don't exist.  Fix a typo in a comment.

Signed-off-by: Paul Jackson <pj@sgi.com>

---
 arch/x86/mm/numa_64.c |    2 +-
 include/linux/efi.h   |    4 ----
 2 files changed, 1 insertion(+), 5 deletions(-)

--- 2.6.26-rc2-mm1.orig/include/linux/efi.h	2008-05-14 03:07:03.231239814 -0700
+++ 2.6.26-rc2-mm1/include/linux/efi.h	2008-05-14 03:07:07.039302049 -0700
@@ -287,7 +287,6 @@ efi_guid_unparse(efi_guid_t *guid, char 
 extern void efi_init (void);
 extern void *efi_get_pal_addr (void);
 extern void efi_map_pal_code (void);
-extern void efi_map_memmap(void);
 extern void efi_memmap_walk (efi_freemem_callback_t callback, void *arg);
 extern void efi_gettimeofday (struct timespec *ts);
 extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if possible */
@@ -295,14 +294,11 @@ extern u64 efi_get_iobase (void);
 extern u32 efi_mem_type (unsigned long phys_addr);
 extern u64 efi_mem_attributes (unsigned long phys_addr);
 extern u64 efi_mem_attribute (unsigned long phys_addr, unsigned long size);
-extern int efi_mem_attribute_range (unsigned long phys_addr, unsigned long size,
-				    u64 attr);
 extern int __init efi_uart_console_only (void);
 extern void efi_initialize_iomem_resources(struct resource *code_resource,
 		struct resource *data_resource, struct resource *bss_resource);
 extern unsigned long efi_get_time(void);
 extern int efi_set_rtc_mmss(unsigned long nowtime);
-extern int is_available_memory(efi_memory_desc_t * md);
 extern struct efi_memory_map memmap;
 
 /**
--- 2.6.26-rc2-mm1.orig/arch/x86/mm/numa_64.c	2008-05-14 03:07:03.231239814 -0700
+++ 2.6.26-rc2-mm1/arch/x86/mm/numa_64.c	2008-05-14 03:07:07.047302180 -0700
@@ -231,7 +231,7 @@ void __init setup_node_bootmem(int nodei
 	else
 		bootmap_start = round_up(start, PAGE_SIZE);
 	/*
-	 * SMP_CAHCE_BYTES could be enough, but init_bootmem_node like
+	 * SMP_CACHE_BYTES could be enough, but init_bootmem_node like
 	 * to use that to align to PAGE_SIZE
 	 */
 	bootmap = early_node_mem(nodeid, bootmap_start, end,

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
