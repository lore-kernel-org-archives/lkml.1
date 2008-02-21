Return-Path: <linux-kernel-owner+w=401wt.eu-S935343AbYBUXyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935343AbYBUXyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935915AbYBUXs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:48:56 -0500
Received: from mx1.suse.de ([195.135.220.2]:45077 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760992AbYBUXsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:48:54 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Alexey Dobriyan <adobriyan@sw.ru>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/11] modules: do not try to add sysfs attributes if !CONFIG_SYSFS
Date: Thu, 21 Feb 2008 15:48:07 -0800
Message-Id: <1203637687-7273-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <20080221234649.GB7128@kroah.com>
References: <20080221234649.GB7128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Thanks to Alexey for the testing and the fix of the fix.

Cc: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/module.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 92595ba..901cd6a 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -987,12 +987,11 @@ static unsigned long resolve_symbol(Elf_Shdr *sechdrs,
 	return ret;
 }
 
-
 /*
  * /sys/module/foo/sections stuff
  * J. Corbet <corbet@lwn.net>
  */
-#ifdef CONFIG_KALLSYMS
+#if defined(CONFIG_KALLSYMS) && defined(CONFIG_SYSFS)
 static ssize_t module_sect_show(struct module_attribute *mattr,
 				struct module *mod, char *buf)
 {
@@ -1188,7 +1187,7 @@ static inline void add_notes_attrs(struct module *mod, unsigned int nsect,
 static inline void remove_notes_attrs(struct module *mod)
 {
 }
-#endif /* CONFIG_KALLSYMS */
+#endif
 
 #ifdef CONFIG_SYSFS
 int module_add_modinfo_attrs(struct module *mod)
@@ -1231,9 +1230,7 @@ void module_remove_modinfo_attrs(struct module *mod)
 	}
 	kfree(mod->modinfo_attrs);
 }
-#endif
 
-#ifdef CONFIG_SYSFS
 int mod_sysfs_init(struct module *mod)
 {
 	int err;
-- 
1.5.4

