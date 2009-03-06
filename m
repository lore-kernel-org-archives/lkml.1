Return-Path: <linux-kernel-owner+w=401wt.eu-S1757516AbZCFATn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516AbZCFATn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 19:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbZCFATe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 19:19:34 -0500
Received: from relay2.sgi.com ([192.48.179.30]:43559 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753963AbZCFATd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 19:19:33 -0500
Date: Thu, 5 Mar 2009 18:19:30 -0600
From: Russ Anderson <rja@sgi.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH BUGFIX] x86: Prevent /sys/firmware/sgi_uv from being created on non-uv systems
Message-ID: <20090306001930.GA5881@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/sys/firmware/sgi_uv should only be created on uv systems.

Signed-off-by: Russ Anderson <rja@sgi.com>

---
 arch/x86/kernel/uv_sysfs.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/arch/x86/kernel/uv_sysfs.c
===================================================================
--- linux.orig/arch/x86/kernel/uv_sysfs.c	2009-03-05 14:22:40.000000000 -0600
+++ linux/arch/x86/kernel/uv_sysfs.c	2009-03-05 14:59:16.000000000 -0600
@@ -21,6 +21,7 @@
 
 #include <linux/sysdev.h>
 #include <asm/uv/bios.h>
+#include <asm/genapic.h>
 
 struct kobject *sgi_uv_kobj;
 
@@ -46,6 +47,9 @@ static struct kobj_attribute coherence_i
 static int __init sgi_uv_sysfs_init(void)
 {
 	unsigned long ret;
+
+	if (!is_uv_system())
+		return -ENODEV;
 
 	if (!sgi_uv_kobj)
 		sgi_uv_kobj = kobject_create_and_add("sgi_uv", firmware_kobj);
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
