Return-Path: <linux-kernel-owner+w=401wt.eu-S969630AbXG3WOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969630AbXG3WOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969000AbXG3WLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:11:04 -0400
Received: from ns.suse.de ([195.135.220.2]:40421 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S969365AbXG3WLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:11:01 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/11] modules: better error messages when modules fail to load due to a sysfs problem.
Date: Mon, 30 Jul 2007 15:09:33 -0700
Message-Id: <1185833416410-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11858334123619-git-send-email-gregkh@suse.de>
References: <20070730220829.GB5263@kroah.com>
 <1185833373286-git-send-email-gregkh@suse.de>
 <11858333772499-git-send-email-gregkh@suse.de>
 <11858333823900-git-send-email-gregkh@suse.de>
 <11858333853388-git-send-email-gregkh@suse.de>
 <11858333892232-git-send-email-gregkh@suse.de>
 <11858333931362-git-send-email-gregkh@suse.de>
 <11858334013561-git-send-email-gregkh@suse.de>
 <11858334042248-git-send-email-gregkh@suse.de>
 <1185833408744-git-send-email-gregkh@suse.de>
 <11858334123619-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This helps people when debugging problems like the ones that were in the
recent -mm releases.


Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/params.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index effbaae..4e57732 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -567,7 +567,12 @@ static void __init kernel_param_sysfs_setup(const char *name,
 	kobject_set_name(&mk->kobj, name);
 	kobject_init(&mk->kobj);
 	ret = kobject_add(&mk->kobj);
-	BUG_ON(ret < 0);
+	if (ret) {
+		printk(KERN_ERR "Module '%s' failed to be added to sysfs, "
+		      "error number %d\n", name, ret);
+		printk(KERN_ERR	"The system will be unstable now.\n");
+		return;
+	}
 	param_sysfs_setup(mk, kparam, num_params, name_skip);
 	kobject_uevent(&mk->kobj, KOBJ_ADD);
 }
-- 
1.5.2.2

