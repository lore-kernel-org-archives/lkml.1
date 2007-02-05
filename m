Return-Path: <linux-kernel-owner+w=401wt.eu-S932937AbXBEOgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937AbXBEOgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932929AbXBEOgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:36:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932937AbXBEOgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:36:46 -0500
Subject: [GFS2/DLM] use sysfs
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:44:48 +0000
Message-Id: <1170686688.11001.365.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2383862e70905f612bde464c441c717a01d2f0e8 Mon Sep 17 00:00:00 2001
From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Thu, 25 Jan 2007 18:42:39 -0800
Subject: [PATCH] [GFS2/DLM] use sysfs

With CONFIG_DLM=m, CONFIG_PROC_FS=n, and CONFIG_SYSFS=n, kernel build
fails with:

WARNING: "kernel_subsys" [fs/gfs2/locking/dlm/lock_dlm.ko] undefined!
WARNING: "kernel_subsys" [fs/dlm/dlm.ko] undefined!
WARNING: "kernel_subsys" [fs/configfs/configfs.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Since fs/dlm/lockspace.c and fs/gfs2/locking/dlm/sysfs.c use
kernel_subsys, they should either DEPEND on it or SELECT it.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/Kconfig b/fs/dlm/Kconfig
index b5654a2..d1359b9 100644
--- a/fs/dlm/Kconfig
+++ b/fs/dlm/Kconfig
@@ -5,6 +5,7 @@ config DLM
 	tristate "Distributed Lock Manager (DLM)"
 	depends on IPV6 || IPV6=n
 	select CONFIGFS_FS
+	select SYSFS
 	select IP_SCTP if DLM_SCTP
 	help
 	A general purpose distributed lock manager for kernel or userspace
diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
index 6a2ffa2..2c184a9 100644
--- a/fs/gfs2/Kconfig
+++ b/fs/gfs2/Kconfig
@@ -38,6 +38,7 @@ config GFS2_FS_LOCKING_DLM
 	select IP_SCTP if DLM_SCTP
 	select CONFIGFS_FS
 	select DLM
+	select SYSFS
 	help
 	Multiple node locking module for GFS2
 
-- 
1.4.4.2



