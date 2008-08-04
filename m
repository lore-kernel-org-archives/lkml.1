Return-Path: <linux-kernel-owner+w=401wt.eu-S1761922AbYHDCiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761922AbYHDCiU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 22:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761277AbYHDCeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 22:34:50 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:44589 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760898AbYHDCeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 22:34:50 -0400
Message-ID: <57595.166.70.238.45.1217816067.squirrel@webmail.wolfmountaingroup.com>
Date: Sun, 3 Aug 2008 20:14:27 -0600 (MDT)
Subject: [PATCH 2.6.26 23/25] mdb: Merkey's Kernel Debugger
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
References: 
In-Reply-To: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netware Style Debugger for Linux written by Jeffrey Vernon Merkey

--- linux-2.6.26/kernel/module.c	2008-07-13 15:51:29.000000000 -0600 +++
linux-2.6.26-mdb/kernel/module.c	2008-08-03 12:49:01.000000000 -0600 @@
-2435,6 +2435,38 @@
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
+	   print(" %s ", mod->state == MODULE_STATE_GOING ? "Unloading": +	     
          mod->state == MODULE_STATE_COMING ? "Loading":
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


By making a contribution to this project, I certify that the contribution
was created in whole or in part by me and I have the right to submit it
under the open source license indicated in the file

Jeffrey Vernon Merkey





