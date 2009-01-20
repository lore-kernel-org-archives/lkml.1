Return-Path: <linux-kernel-owner+w=401wt.eu-S1761254AbZATBd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761254AbZATBd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 20:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbZATBdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 20:33:08 -0500
Received: from relay2.sgi.com ([192.48.179.30]:42108 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752577AbZATBdH (ORCPT
	<rfc822;@relay.corp.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 20:33:07 -0500
Message-Id: <20090120013258.215204000@sgi.com>
References: <20090120012930.020621000@sgi.com>
User-Agent: quilt/0.44-16.4
Date: Tue, 20 Jan 2009 12:29:31 +1100
From: Greg Banks <gnb@sgi.com>
To: Linux Kernel ML <linux-kernel@vger.kernel.org>
Cc: Linux NFS ML <linux-nfs@vger.kernel.org>,
       Linux NFSv4 ML <nfsv4@linux-nfs.org>,
       SystemTAP ML <systemtap@sources.redhat.com>
Subject: [patch 1/5] Move definitions of struct module_sect_attr back into module.h.
Content-Disposition: inline; filename=gnb-move-module_sect_attr-into-module-h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new dprintk module needs to use module_sect_attr.

Signed-off-by: Greg Banks <gnb@sgi.com>
---

 include/linux/module.h |   15 +++++++++++++++
 kernel/module.c        |   13 -------------
 2 files changed, 15 insertions(+), 13 deletions(-)

Index: bfields/kernel/module.c
===================================================================
--- bfields.orig/kernel/module.c
+++ bfields/kernel/module.c
@@ -1088,19 +1101,6 @@ static unsigned long resolve_symbol(Elf_
  * J. Corbet <corbet@lwn.net>
  */
 #if defined(CONFIG_KALLSYMS) && defined(CONFIG_SYSFS)
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
-	unsigned int nsections;
-	struct module_sect_attr attrs[0];
-};
 
 static ssize_t module_sect_show(struct module_attribute *mattr,
 				struct module *mod, char *buf)
Index: bfields/include/linux/module.h
===================================================================
--- bfields.orig/include/linux/module.h
+++ bfields/include/linux/module.h
@@ -231,6 +231,21 @@ enum module_state
 	MODULE_STATE_GOING,
 };
 
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
+
 struct module
 {
 	enum module_state state;

--
-- 
Greg Banks, P.Engineer, SGI Australian Software Group.
the brightly coloured sporks of revolution.
I don't speak for SGI.
