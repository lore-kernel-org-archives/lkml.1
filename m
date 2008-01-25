Return-Path: <linux-kernel-owner+w=401wt.eu-S1763440AbYAYHyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763440AbYAYHyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761747AbYAYHgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:36:32 -0500
Received: from mx1.suse.de ([195.135.220.2]:55345 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761985AbYAYHgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:36:31 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Mike Halcrow <mhalcrow@us.ibm.com>,
       Phillip Hellewell <phillip@hellewell.homeip.net>
Subject: [PATCH 099/196] kobject: convert ecryptfs to use kobject_create
Date: Thu, 24 Jan 2008 23:32:08 -0800
Message-Id: <1201246425-5058-20-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using a kset for this trivial directory is an overkill.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Mike Halcrow <mhalcrow@us.ibm.com>
Cc: Phillip Hellewell <phillip@hellewell.homeip.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ecryptfs/main.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index d984eac..4f13321 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -734,7 +734,7 @@ static int ecryptfs_init_kmem_caches(void)
 	return 0;
 }
 
-static struct kset *ecryptfs_kset;
+static struct kobject *ecryptfs_kobj;
 
 static ssize_t version_show(struct kobject *kobj,
 			    struct kobj_attribute *attr, char *buff)
@@ -757,17 +757,17 @@ static int do_sysfs_registration(void)
 {
 	int rc;
 
-	ecryptfs_kset = kset_create_and_add("ecryptfs", NULL, fs_kobj);
-	if (!ecryptfs_kset) {
+	ecryptfs_kobj = kobject_create_and_add("ecryptfs", fs_kobj);
+	if (!ecryptfs_kobj) {
 		printk(KERN_ERR "Unable to create ecryptfs kset\n");
 		rc = -ENOMEM;
 		goto out;
 	}
-	rc = sysfs_create_group(&ecryptfs_kset->kobj, &attr_group);
+	rc = sysfs_create_group(ecryptfs_kobj, &attr_group);
 	if (rc) {
 		printk(KERN_ERR
 		       "Unable to create ecryptfs version attributes\n");
-		kset_unregister(ecryptfs_kset);
+		kobject_unregister(ecryptfs_kobj);
 	}
 out:
 	return rc;
@@ -775,8 +775,8 @@ out:
 
 static void do_sysfs_unregistration(void)
 {
-	sysfs_remove_group(&ecryptfs_kset->kobj, &attr_group);
-	kset_unregister(ecryptfs_kset);
+	sysfs_remove_group(ecryptfs_kobj, &attr_group);
+	kobject_unregister(ecryptfs_kobj);
 }
 
 static int __init ecryptfs_init(void)
-- 
1.5.3.8

