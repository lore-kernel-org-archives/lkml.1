Return-Path: <linux-kernel-owner+w=401wt.eu-S1765879AbYAYIXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765879AbYAYIXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758329AbYAYIBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:00 -0500
Received: from ns2.suse.de ([195.135.220.15]:53681 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764084AbYAYH7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:51 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 133/196] Kobject: convert kernel/params.c to use kobject_init/add_ng()
Date: Thu, 24 Jan 2008 23:32:42 -0800
Message-Id: <1201246425-5058-54-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the code to use the new kobject functions, cleaning up the
logic in doing so.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/params.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index 97e0923..1078b14 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -561,11 +561,9 @@ static void __init kernel_param_sysfs_setup(const char *name,
 
 	mk->mod = THIS_MODULE;
 	mk->kobj.kset = module_kset;
-	mk->kobj.ktype = &module_ktype;
-	kobject_set_name(&mk->kobj, name);
-	kobject_init(&mk->kobj);
-	ret = kobject_add(&mk->kobj);
+	ret = kobject_init_and_add(&mk->kobj, &module_ktype, NULL, "%s", name);
 	if (ret) {
+		kobject_put(&mk->kobj);
 		printk(KERN_ERR "Module '%s' failed to be added to sysfs, "
 		      "error number %d\n", name, ret);
 		printk(KERN_ERR	"The system will be unstable now.\n");
-- 
1.5.3.8

