Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbYCMJDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbYCMJDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 05:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbYCMJC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 05:02:57 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:26115
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751139AbYCMJC5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 05:02:57 -0400
Message-Id: <47D8FC00.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 Beta 
Date: Thu, 13 Mar 2008 09:03:44 +0000
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

--- linux-2.6.25-rc5/include/linux/module.h	2008-03-10 13:24:33.000000000 +0100
+++ 2.6.25-rc5-private-module-sect-attrs/include/linux/module.h	2008-03-04 11:25:28.000000000 +0100
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
--- linux-2.6.25-rc5/kernel/module.c	2008-03-10 13:24:35.000000000 +0100
+++ 2.6.25-rc5-private-module-sect-attrs/kernel/module.c	2008-03-04 11:26:10.000000000 +0100
@@ -992,6 +992,20 @@ static unsigned long resolve_symbol(Elf_
  * J. Corbet <corbet@lwn.net>
  */
 #if defined(CONFIG_KALLSYMS) && defined(CONFIG_SYSFS)
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
@@ -1002,7 +1016,7 @@ static ssize_t module_sect_show(struct m
 
 static void free_sect_attrs(struct module_sect_attrs *sect_attrs)
 {
-	int section;
+	unsigned int section;
 
 	for (section = 0; section < sect_attrs->nsections; section++)
 		kfree(sect_attrs->attrs[section].name);



