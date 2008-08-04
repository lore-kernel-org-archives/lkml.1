Return-Path: <linux-kernel-owner+w=401wt.eu-S1762206AbYHDHCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762206AbYHDHCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 03:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760996AbYHDHC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 03:02:26 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:50398 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759161AbYHDHC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 03:02:26 -0400
Message-ID: <45482.166.70.238.45.1217832120.squirrel@webmail.wolfmountaingroup.com>
Date: Mon, 4 Aug 2008 00:42:00 -0600 (MDT)
Subject: [PATCH 2.6.27-rc1 23/25] mdb:  Merkey's Kernel Debugger 2.6.27-rc1
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netware style debugger for Linux written by Jeffrey Vernon Merkey

--- a/kernel/module.c	2008-08-03 16:10:19.000000000 -0600
+++ b/kernel/module.c	2008-08-03 16:15:00.000000000 -0600
@@ -2503,6 +2503,38 @@
 	return 0;
 }

+#ifdef CONFIG_MDB
+int mdb_modules(char *str, int (*print)(char *s, ...))
+{
+	struct module *mod;
+	struct module_use *use;
+
+        if (!print)
+           return 0;
+
+	list_for_each_entry(mod, &modules, list)
+        {
+           if (str && *str && !strstr(mod->name, str))
+              continue;
+
+	   print(" 0x%08p ", mod->module_core);
+	   print("%s", mod->name);
+	   print(" %lu %02u ", mod->init_size + mod->core_size,
+                 module_refcount(mod));
+	   list_for_each_entry(use, &mod->modules_which_use_me, list)
+		print("%s,", use->module_which_uses->name);
+  	   if (mod->init != NULL && mod->exit == NULL)
+	      print("[permanent],");
+	   print(" %s ", mod->state == MODULE_STATE_GOING ? "Unloading":
+	                mod->state == MODULE_STATE_COMING ? "Loading":
+		        "Live");
+	   if (print("\n"))
+              return 1;
+	}
+        return 0;
+}
+#endif
+
 /* Look for this name: can be of form module:name. */
 unsigned long module_kallsyms_lookup_name(const char *name)
 {


By making a contribution to this project, I certify that
the contribution was created in whole or in part by me and I
have the right to submit it under the open source license
indicated in the file.

Jeffrey Vernon Merkey



