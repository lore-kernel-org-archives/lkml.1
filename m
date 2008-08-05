Return-Path: <linux-kernel-owner+w=401wt.eu-S1760635AbYHEHJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760635AbYHEHJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 03:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758798AbYHEGry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 02:47:54 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:46582 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbYHEGr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 02:47:28 -0400
Date: Tue, 5 Aug 2008 00:26:36 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808050626.m756QaZj003782@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc1-git5 22/26] mdb:  add main.c fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Centralized external definitions into include files and corrected 
the file to conform to Linux coding practices.  fixed word wrap
problems with patches.

using an embadded extern for void f(void) function seems pretty safe since 
its called from init and has no parms.

Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/init/main.c	2008-08-04 15:53:53.000000000 -0600
+++ b/init/main.c	2008-08-04 15:49:51.000000000 -0600
@@ -660,6 +660,12 @@
 	pgtable_cache_init();
 	prio_tree_init();
 	anon_vma_init();
+#ifdef CONFIG_MDB
+        {
+           extern int mdb_init(void);
+	    mdb_init();
+        }
+#endif
 #ifdef CONFIG_X86
 	if (efi_enabled)
 		efi_enter_virtual_mode();
