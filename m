Return-Path: <linux-kernel-owner+w=401wt.eu-S936400AbYBUXxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936400AbYBUXxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935901AbYBUXsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:48:51 -0500
Received: from ns.suse.de ([195.135.220.2]:45066 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935897AbYBUXsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:48:50 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Paul Mackerras <paulus@au.ibm.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/11] POWERPC: fix typo in pseries/power.c
Date: Thu, 21 Feb 2008 15:48:06 -0800
Message-Id: <1203637687-7273-10-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <20080221234649.GB7128@kroah.com>
References: <20080221234649.GB7128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

Introduced by commit 79393fc46ede43451a500a132e5de9856f5a4c83 ("kobject:
convert pseries/power.c to kobj_attr interface").

sys_create_file takes a "struct attrbute *" not a "struct kobj_addribute *".

arch/powerpc/platforms/pseries/power.c: In function 'apo_pm_init':
arch/powerpc/platforms/pseries/power.c:78: warning: passing argument 2 of 'sysfs_create_file' from incompatible pointer type

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Mackerras <paulus@au.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/powerpc/platforms/pseries/power.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/power.c b/arch/powerpc/platforms/pseries/power.c
index e95fc15..6d62662 100644
--- a/arch/powerpc/platforms/pseries/power.c
+++ b/arch/powerpc/platforms/pseries/power.c
@@ -75,7 +75,7 @@ core_initcall(pm_init);
 #else
 static int __init apo_pm_init(void)
 {
-	return (sysfs_create_file(power_kobj, &auto_poweron_attr));
+	return (sysfs_create_file(power_kobj, &auto_poweron_attr.attr));
 }
 __initcall(apo_pm_init);
 #endif
-- 
1.5.4

