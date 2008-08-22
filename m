Return-Path: <linux-kernel-owner+w=401wt.eu-S1759221AbYHVVve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759221AbYHVVve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 17:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486AbYHVVvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 17:51:25 -0400
Received: from relay1.sgi.com ([192.48.171.29]:35829 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754672AbYHVVvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 17:51:25 -0400
Date: Fri, 22 Aug 2008 16:51:24 -0500
From: Russ Anderson <rja@sgi.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Cc: Russ Anderson <rja@sgi.com>, Jack Steiner <steiner@sgi.com>
Subject: [PATCH 1/4] x86: Add UV EFI table entry
Message-ID: <20080822215124.GB143104@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/4] x86: Add UV EFI table entry

Look for a SAL entry in the EFI tables.

Signed-off-by: Russ Anderson <rja@sgi.com>
Signed-off-by: Paul Jackson <pj@sgi.com>

---
 arch/x86/kernel/efi.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/arch/x86/kernel/efi.c
===================================================================
--- linux.orig/arch/x86/kernel/efi.c	2008-08-22 14:49:44.000000000 -0500
+++ linux/arch/x86/kernel/efi.c	2008-08-22 14:50:10.000000000 -0500
@@ -367,6 +367,10 @@ void __init efi_init(void)
 			efi.smbios = config_tables[i].table;
 			printk(" SMBIOS=0x%lx ", config_tables[i].table);
 		} else if (!efi_guidcmp(config_tables[i].guid,
+					SAL_SYSTEM_TABLE_GUID)) {
+			efi.sal_systab = config_tables[i].table;
+			printk(" SALsystab=0x%lx ", config_tables[i].table);
+		} else if (!efi_guidcmp(config_tables[i].guid,
 					HCDP_TABLE_GUID)) {
 			efi.hcdp = config_tables[i].table;
 			printk(" HCDP=0x%lx ", config_tables[i].table);
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
