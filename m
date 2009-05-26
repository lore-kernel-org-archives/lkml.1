Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbZEZIg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbZEZIg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 04:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbZEZIgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 04:36:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51165 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814AbZEZIgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 04:36:21 -0400
Date: Tue, 26 May 2009 04:35:39 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, jdike@addtoit.com,
       mingo@elte.hu, Amerigo Wang <amwang@redhat.com>
Message-Id: <20090526083751.5050.60959.sendpatchset@localhost.localdomain>
In-Reply-To: <20090526083717.5050.32719.sendpatchset@localhost.localdomain>
References: <20090526083717.5050.32719.sendpatchset@localhost.localdomain>
Subject: [Patch 4/4] module: trim exception table in module_free()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just as the comment said, trim the exception table entries when
module_free() mod->module_init.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>

---
Index: linux-2.6/arch/x86/kernel/module.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/module.c
+++ linux-2.6/arch/x86/kernel/module.c
@@ -64,8 +64,8 @@ void *module_alloc(unsigned long size)
 void module_free(struct module *mod, void *module_region)
 {
 	vfree(module_region);
-	/* FIXME: If module_region == mod->init_region, trim exception
-	   table entries. */
+	if (module_region == mod->module_init)
+		mod->num_exentries = 0;
 }
 
 /* We don't need anything special. */
