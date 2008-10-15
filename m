Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbYJOUM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbYJOUM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 16:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbYJOUMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 16:12:48 -0400
Received: from relay2.sgi.com ([192.48.171.30]:43262 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753166AbYJOUMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 16:12:47 -0400
Date: Wed, 15 Oct 2008 15:12:46 -0500
From: Russ Anderson <rja@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Cc: Russ Anderson <rja@sgi.com>, Huang Ying <ying.huang@intel.com>,
       Jack Steiner <steiner@sgi.com>
Subject: [PATCH 1/7] x86: Add UV EFI table entry
Message-ID: <20081015201246.GB197213@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/7] x86: Add UV EFI table entry

Add an EFI table entry for SGI UV system.
Look for the entry in the EFI tables.

Signed-off-by: Russ Anderson <rja@sgi.com>
Signed-off-by: Paul Jackson <pj@sgi.com>

---
 arch/x86/kernel/efi.c |    4 ++++
 include/linux/efi.h   |    4 ++++
 2 files changed, 8 insertions(+)

Index: linux/arch/x86/kernel/efi.c
===================================================================
--- linux.orig/arch/x86/kernel/efi.c	2008-10-15 09:56:13.000000000 -0500
+++ linux/arch/x86/kernel/efi.c	2008-10-15 09:56:23.000000000 -0500
@@ -367,6 +367,10 @@ void __init efi_init(void)
 			efi.smbios = config_tables[i].table;
 			printk(" SMBIOS=0x%lx ", config_tables[i].table);
 		} else if (!efi_guidcmp(config_tables[i].guid,
+					UV_SYSTEM_TABLE_GUID)) {
+			efi.uv_systab = config_tables[i].table;
+			printk(" UVsystab=0x%lx ", config_tables[i].table);
+		} else if (!efi_guidcmp(config_tables[i].guid,
 					HCDP_TABLE_GUID)) {
 			efi.hcdp = config_tables[i].table;
 			printk(" HCDP=0x%lx ", config_tables[i].table);
Index: linux/include/linux/efi.h
===================================================================
--- linux.orig/include/linux/efi.h	2008-10-15 09:56:13.000000000 -0500
+++ linux/include/linux/efi.h	2008-10-15 09:56:23.000000000 -0500
@@ -208,6 +208,9 @@ typedef efi_status_t efi_set_virtual_add
 #define EFI_GLOBAL_VARIABLE_GUID \
     EFI_GUID(  0x8be4df61, 0x93ca, 0x11d2, 0xaa, 0x0d, 0x00, 0xe0, 0x98, 0x03, 0x2b, 0x8c )
 
+#define UV_SYSTEM_TABLE_GUID \
+    EFI_GUID(  0x3b13a7d4, 0x633e, 0x11dd, 0x93, 0xec, 0xda, 0x25, 0x56, 0xd8, 0x95, 0x93 )
+
 typedef struct {
 	efi_guid_t guid;
 	unsigned long table;
@@ -255,6 +258,7 @@ extern struct efi {
 	unsigned long boot_info;	/* boot info table */
 	unsigned long hcdp;		/* HCDP table */
 	unsigned long uga;		/* UGA table */
+	unsigned long uv_systab;	/* UV system table */
 	efi_get_time_t *get_time;
 	efi_set_time_t *set_time;
 	efi_get_wakeup_time_t *get_wakeup_time;
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
