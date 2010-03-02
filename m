Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab0CBXd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:33:26 -0500
Received: from kroah.org ([198.145.64.141]:38684 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324Ab0CBX3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:43 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 47/62] sysfs: Use sysfs_attr_init and sysfs_bin_attr_init on module dynamic attributes
Date: Tue,  2 Mar 2010 15:28:46 -0800
Message-Id: <1267572541-410-47-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

A little more whack-a-mole annotating the dynamic sysfs attributes.  I
had everything built into my earlier test kernel, and so I missed
these.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/module.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index f82386b..5ec6b47 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1083,6 +1083,7 @@ static void add_sect_attrs(struct module *mod, unsigned int nsect,
 		if (sattr->name == NULL)
 			goto out;
 		sect_attrs->nsections++;
+		sysfs_attr_init(&sattr->mattr.attr);
 		sattr->mattr.show = module_sect_show;
 		sattr->mattr.store = NULL;
 		sattr->mattr.attr.name = sattr->name;
@@ -1178,6 +1179,7 @@ static void add_notes_attrs(struct module *mod, unsigned int nsect,
 		if (sect_empty(&sechdrs[i]))
 			continue;
 		if (sechdrs[i].sh_type == SHT_NOTE) {
+			sysfs_bin_attr_init(nattr);
 			nattr->attr.name = mod->sect_attrs->attrs[loaded].name;
 			nattr->attr.mode = S_IRUGO;
 			nattr->size = sechdrs[i].sh_size;
@@ -1250,6 +1252,7 @@ int module_add_modinfo_attrs(struct module *mod)
 		if (!attr->test ||
 		    (attr->test && attr->test(mod))) {
 			memcpy(temp_attr, attr, sizeof(*temp_attr));
+			sysfs_attr_init(&temp_attr->attr);
 			error = sysfs_create_file(&mod->mkobj.kobj,&temp_attr->attr);
 			++temp_attr;
 		}
-- 
1.7.0.1

