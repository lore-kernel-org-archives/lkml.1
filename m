Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbYDXFBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbYDXFBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 01:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbYDXFBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 01:01:24 -0400
Received: from ozlabs.org ([203.10.76.45]:37180 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbYDXFBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 01:01:23 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 24 Apr 2008 00:01:12 -0500
Subject: [PATCH 1/6] make module_sect_attrs private to kernel/module.c
Cc: Jan Beulich <jbeulich@novell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804241501.12339.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No-one else is using these afaics.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/module.h |   17 -----------------
 kernel/module.c        |   16 +++++++++++++++-
 2 files changed, 15 insertions(+), 18 deletions(-)

diff -u
--- linux-2.6.25-rc5/include/linux/module.h	2008-03-10 13:24:33.000000000 
+0100
+++ 2.6.25-rc5-private-module-sect-attrs/include/linux/module.h	2008-03-04 
11:25:28.000000000 +0100
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
+++ 2.6.25-rc5-private-module-sect-attrs/kernel/module.c	2008-03-04 
11:26:10.000000000 +0100
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


