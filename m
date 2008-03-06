Return-Path: <linux-kernel-owner+w=401wt.eu-S935068AbYCFQ7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935068AbYCFQ7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 11:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764487AbYCFQ7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 11:59:10 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:57092 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762632AbYCFQ7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 11:59:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=B6JSi2TEBoRbvHqaKSX/zvUKHHCuaKV+cYPH2sqq6bapByo+5ApvginyvTfAf05BXLqf/r3dVG6wW6B1guEq+7FC+no6AVVHVAZjmxZC6FlOKdGVl6P0sOoKhQsXzL1uE8zFtK4kIGlO0pnxh8jjMLIgogwLcKWdF8D+oPWSSAY=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology, Karnataka
To: gregkh@suse.de
Subject: [PATCH] Mark kobjects as unitialized
Date: Thu, 6 Mar 2008 22:23:18 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803062223.18857.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi greg,

When I remove only the kvm-intel module without removing the kvm module itself, I get an error saying that a kobject is 
trying to be reinitialized. Its because of the fact that kvm reuses a kobject in kvm_init when calling sysdev_register.

This patch fixes kobject_cleanup by marking the kobject as uninitialized when we cleanup to allow kobjects to be reused.

Signed-off-by: Balaji Rao <balajirrao@gmail.com>

diff --git a/lib/kobject.c b/lib/kobject.c
index 0d03252..fbdefb8 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -577,6 +577,9 @@ static void kobject_cleanup(struct kobject *kobj)
 		pr_debug("kobject: '%s': free name\n", name);
 		kfree(name);
 	}
+
+	/* Set the state to uninitialized */
+	kobj->state_initialized = 0;
 }
 
 static void kobject_release(struct kref *kref)

-- 
regards,
balaji rao
3rd year, Dept. of Mechanical Engineering,
National Institute of Technology, Karnataka
