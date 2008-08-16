Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbYHPD44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbYHPD44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 23:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbYHPD4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 23:56:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59287 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbYHPD4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 23:56:46 -0400
Date: Fri, 15 Aug 2008 23:56:44 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
cc: Kumar Gala <galak@kernel.crashing.org>, paulus@samba.org,
       benh@kernel.crashing.org
Subject: [PATCH] powerpc: remove dead module_find_bug code.
Message-ID: <alpine.DEB.1.10.0808152354150.4450@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Doing some various "make randconfig" and came across an error when CONFIG_BUG
was not set. Looking further in this, I found that module_find_bug, defined
in powerpc arch code, is not called anywhere.

There is a static module_find_bug in lib/bug.c but that is a separate issue.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/powerpc/kernel/module.c |   15 ---------------
 1 file changed, 15 deletions(-)

Index: linux-tip.git/arch/powerpc/kernel/module.c
===================================================================
--- linux-tip.git.orig/arch/powerpc/kernel/module.c	2008-08-15 20:18:52.000000000 -0700
+++ linux-tip.git/arch/powerpc/kernel/module.c	2008-08-15 20:18:58.000000000 -0700
@@ -99,18 +99,3 @@ void module_arch_cleanup(struct module *
 {
 	module_bug_cleanup(mod);
 }
-
-struct bug_entry *module_find_bug(unsigned long bugaddr)
-{
-	struct mod_arch_specific *mod;
-	unsigned int i;
-	struct bug_entry *bug;
-
-	list_for_each_entry(mod, &module_bug_list, bug_list) {
-		bug = mod->bug_table;
-		for (i = 0; i < mod->num_bugs; ++i, ++bug)
-			if (bugaddr == bug->bug_addr)
-				return bug;
-	}
-	return NULL;
-}

