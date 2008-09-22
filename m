Return-Path: <linux-kernel-owner+w=401wt.eu-S1754281AbYIVVIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbYIVVIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 17:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbYIVVIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 17:08:30 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39619 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753013AbYIVVI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 17:08:29 -0400
Date: Mon, 22 Sep 2008 16:08:29 -0500
From: Russ Anderson <rja@sgi.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: [PATCH 1/4] x86: Add UV EFI table entry
Message-ID: <20080922210829.GD222374@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/4] Add UV EFI table entry

Look for a SAL entry in the EFI tables.

Signed-off-by: Russ Anderson <rja@sgi.com>
Signed-off-by: Paul Jackson <pj@sgi.com>

---
 arch/x86/kernel/efi.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/arch/x86/kernel/efi.c
===================================================================
--- linux.orig/arch/x86/kernel/efi.c	2008-09-22 16:01:00.000000000 -0500
+++ linux/arch/x86/kernel/efi.c	2008-09-22 16:01:07.000000000 -0500
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
