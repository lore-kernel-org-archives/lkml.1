Return-Path: <linux-kernel-owner+w=401wt.eu-S1759329AbYAJQfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329AbYAJQfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 11:35:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbYAJQe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 11:34:58 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:54934
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752432AbYAJQe5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 11:34:57 -0500
Message-Id: <47865755.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 10 Jan 2008 16:35:17 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] make module_sect_attrs private to kernel/module.c
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No-one else is using these afaics.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
---

 include/linux/module.h |   17 -----------------
 kernel/module.c        |   16 +++++++++++++++-
 2 files changed, 15 insertions(+), 18 deletions(-)

--- linux-2.6.24-rc7/include/linux/module.h	2008-01-10 16:50:52.000000000 +0100
+++ 2.6.24-rc7-private-module-sect-attrs/include/linux/module.h	2008-01-08 09:15:49.000000000 +0100
@@ -229,23 +229,6 @@ enum module_state
 	MODULE_STATE_GOING,
 };
 
-/* Similar stuff for section attributes. */
-struct module_sect_attr
-{
-	struct module_attribute mattr;
-	char *name;
-	unsigned long address;
-};
-
-struct module_sect_attrs
-{
-	struct attribute_group grp;
-	int nsections;
-	struct module_sect_attr attrs[0];
-};
-
-struct module_param_attrs;
-
 struct module
 {
 	enum module_state state;
--- linux-2.6.24-rc7/kernel/module.c	2008-01-10 16:50:54.000000000 +0100
+++ 2.6.24-rc7-private-module-sect-attrs/kernel/module.c	2008-01-08 10:12:12.000000000 +0100
@@ -968,6 +968,20 @@ static unsigned long resolve_symbol(Elf_
  * J. Corbet <corbet@lwn.net>
  */
 #ifdef CONFIG_KALLSYMS
+struct module_sect_attr
+{
+	struct module_attribute mattr;
+	char *name;
+	unsigned long address;
+};
+
+struct module_sect_attrs
+{
+	struct attribute_group grp;
+	unsigned int nsections;
+	struct module_sect_attr attrs[0];
+};
+
 static ssize_t module_sect_show(struct module_attribute *mattr,
 				struct module *mod, char *buf)
 {
@@ -978,7 +992,7 @@ static ssize_t module_sect_show(struct m
 
 static void free_sect_attrs(struct module_sect_attrs *sect_attrs)
 {
-	int section;
+	unsigned int section;
 
 	for (section = 0; section < sect_attrs->nsections; section++)
 		kfree(sect_attrs->attrs[section].name);



