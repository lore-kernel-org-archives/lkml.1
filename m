Return-Path: <linux-kernel-owner+w=401wt.eu-S933660AbXEFLeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933660AbXEFLeO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 07:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933646AbXEFLeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 07:34:14 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:30434 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933622AbXEFLeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 07:34:12 -0400
Subject: Please pull git390 'for-linus' branch
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain
Organization: IBM Corporation
Date: Sun, 06 May 2007 13:34:34 +0200
Message-Id: <1178451274.9375.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from 'for-linus' branch of

	git://git390.osdl.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

 arch/s390/hypfs/inode.c |    2 +-
 arch/s390/kernel/ipl.c  |   26 +++++++++++++-------------
 2 files changed, 14 insertions(+), 14 deletions(-)

Cornelia Huck (1):
      [S390] fix subsystem removal fallout

diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index ba5d316..8e1ea1c 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -477,7 +477,7 @@ static int __init hypfs_init(void)
 			goto fail_diag;
 		}
 	}
-	kset_set_kset_s(&s390_subsys, hypervisor_subsys);
+	kobj_set_kset_s(&s390_subsys, hypervisor_subsys);
 	rc = subsystem_register(&s390_subsys);
 	if (rc)
 		goto fail_sysfs;
diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index 0ea048d..367caf9 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -816,23 +816,23 @@ static int __init ipl_register_fcp_files(void)
 {
 	int rc;
 
-	rc = sysfs_create_group(&ipl_subsys.kset.kobj,
+	rc = sysfs_create_group(&ipl_subsys.kobj,
 				&ipl_fcp_attr_group);
 	if (rc)
 		goto out;
-	rc = sysfs_create_bin_file(&ipl_subsys.kset.kobj,
+	rc = sysfs_create_bin_file(&ipl_subsys.kobj,
 				   &ipl_parameter_attr);
 	if (rc)
 		goto out_ipl_parm;
-	rc = sysfs_create_bin_file(&ipl_subsys.kset.kobj,
+	rc = sysfs_create_bin_file(&ipl_subsys.kobj,
 				   &ipl_scp_data_attr);
 	if (!rc)
 		goto out;
 
-	sysfs_remove_bin_file(&ipl_subsys.kset.kobj, &ipl_parameter_attr);
+	sysfs_remove_bin_file(&ipl_subsys.kobj, &ipl_parameter_attr);
 
 out_ipl_parm:
-	sysfs_remove_group(&ipl_subsys.kset.kobj, &ipl_fcp_attr_group);
+	sysfs_remove_group(&ipl_subsys.kobj, &ipl_fcp_attr_group);
 out:
 	return rc;
 }
@@ -846,7 +846,7 @@ static int __init ipl_init(void)
 		return rc;
 	switch (ipl_info.type) {
 	case IPL_TYPE_CCW:
-		rc = sysfs_create_group(&ipl_subsys.kset.kobj,
+		rc = sysfs_create_group(&ipl_subsys.kobj,
 					&ipl_ccw_attr_group);
 		break;
 	case IPL_TYPE_FCP:
@@ -854,11 +854,11 @@ static int __init ipl_init(void)
 		rc = ipl_register_fcp_files();
 		break;
 	case IPL_TYPE_NSS:
-		rc = sysfs_create_group(&ipl_subsys.kset.kobj,
+		rc = sysfs_create_group(&ipl_subsys.kobj,
 					&ipl_nss_attr_group);
 		break;
 	default:
-		rc = sysfs_create_group(&ipl_subsys.kset.kobj,
+		rc = sysfs_create_group(&ipl_subsys.kobj,
 					&ipl_unknown_attr_group);
 		break;
 	}
@@ -885,7 +885,7 @@ static int __init reipl_nss_init(void)
 
 	if (!MACHINE_IS_VM)
 		return 0;
-	rc = sysfs_create_group(&reipl_subsys.kset.kobj, &reipl_nss_attr_group);
+	rc = sysfs_create_group(&reipl_subsys.kobj, &reipl_nss_attr_group);
 	if (rc)
 		return rc;
 	strncpy(reipl_nss_name, kernel_nss_name, NSS_NAME_SIZE + 1);
@@ -900,7 +900,7 @@ static int __init reipl_ccw_init(void)
 	reipl_block_ccw = (void *) get_zeroed_page(GFP_KERNEL);
 	if (!reipl_block_ccw)
 		return -ENOMEM;
-	rc = sysfs_create_group(&reipl_subsys.kset.kobj, &reipl_ccw_attr_group);
+	rc = sysfs_create_group(&reipl_subsys.kobj, &reipl_ccw_attr_group);
 	if (rc) {
 		free_page((unsigned long)reipl_block_ccw);
 		return rc;
@@ -938,7 +938,7 @@ static int __init reipl_fcp_init(void)
 	reipl_block_fcp = (void *) get_zeroed_page(GFP_KERNEL);
 	if (!reipl_block_fcp)
 		return -ENOMEM;
-	rc = sysfs_create_group(&reipl_subsys.kset.kobj, &reipl_fcp_attr_group);
+	rc = sysfs_create_group(&reipl_subsys.kobj, &reipl_fcp_attr_group);
 	if (rc) {
 		free_page((unsigned long)reipl_block_fcp);
 		return rc;
@@ -990,7 +990,7 @@ static int __init dump_ccw_init(void)
 	dump_block_ccw = (void *) get_zeroed_page(GFP_KERNEL);
 	if (!dump_block_ccw)
 		return -ENOMEM;
-	rc = sysfs_create_group(&dump_subsys.kset.kobj, &dump_ccw_attr_group);
+	rc = sysfs_create_group(&dump_subsys.kobj, &dump_ccw_attr_group);
 	if (rc) {
 		free_page((unsigned long)dump_block_ccw);
 		return rc;
@@ -1014,7 +1014,7 @@ static int __init dump_fcp_init(void)
 	dump_block_fcp = (void *) get_zeroed_page(GFP_KERNEL);
 	if (!dump_block_fcp)
 		return -ENOMEM;
-	rc = sysfs_create_group(&dump_subsys.kset.kobj, &dump_fcp_attr_group);
+	rc = sysfs_create_group(&dump_subsys.kobj, &dump_fcp_attr_group);
 	if (rc) {
 		free_page((unsigned long)dump_block_fcp);
 		return rc;


