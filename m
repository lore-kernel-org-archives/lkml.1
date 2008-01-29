Return-Path: <linux-kernel-owner+w=401wt.eu-S1762293AbYA2Fuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762293AbYA2Fuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 00:50:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756875AbYA2FuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 00:50:07 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:43659 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179AbYA2FuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 00:50:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=NdUSOum/RP8pMt45bJ9rd9c6gi7IHF6S8+iwlQaJZc6GiJH7y6Cr7lIt1zmXeOzsZNF+KTCfbYI5uhX2fb1KBfKjlhyckz3mEsjr5g7GhuMCz4QEuvOi/kUMmt2HZhft/As9+18nWFDM8wCTJYEBukZjEgwF1EtRc7/uua9ZLNk=
From: Denis Cheng <crquan@gmail.com>
To: Patrick Caulfield <pcaulfie@redhat.com>,
       David Teigland <teigland@redhat.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] dlm/user.c: static initialization improvements
Date: Tue, 29 Jan 2008 13:50:16 +0800
Message-Id: <1201585816-1736-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

also change name_prefix from char pointer to char array.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 fs/dlm/user.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index 4f74154..2cc5415 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -24,8 +24,7 @@
 #include "lvb_table.h"
 #include "user.h"
 
-static const char *name_prefix="dlm";
-static struct miscdevice ctl_device;
+static const char name_prefix[] = "dlm";
 static const struct file_operations device_fops;
 
 #ifdef CONFIG_COMPAT
@@ -896,14 +895,16 @@ static const struct file_operations ctl_device_fops = {
 	.owner   = THIS_MODULE,
 };
 
+static struct miscdevice ctl_device = {
+	.name  = "dlm-control",
+	.fops  = &ctl_device_fops,
+	.minor = MISC_DYNAMIC_MINOR,
+};
+
 int dlm_user_init(void)
 {
 	int error;
 
-	ctl_device.name = "dlm-control";
-	ctl_device.fops = &ctl_device_fops;
-	ctl_device.minor = MISC_DYNAMIC_MINOR;
-
 	error = misc_register(&ctl_device);
 	if (error)
 		log_print("misc_register failed for control device");
-- 
1.5.3.8

