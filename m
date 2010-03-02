Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164Ab0CBXyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:54:43 -0500
Received: from kroah.org ([198.145.64.141]:38560 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262Ab0CBX31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:27 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 26/62] sysdev: fix up the probe/release attributes
Date: Tue,  2 Mar 2010 15:28:25 -0800
Message-Id: <1267572541-410-26-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These should be sysdev attributes, not class attributes.  This patch
should resolve the problem.

Thanks to Stephen Rothwell for pointing out the problem.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/cpu.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 9121c77..7036e8e 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -79,24 +79,24 @@ void unregister_cpu(struct cpu *cpu)
 }
 
 #ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
-static ssize_t cpu_probe_store(struct class *class,
-				struct class_attribute *attr,
+static ssize_t cpu_probe_store(struct sys_device *dev,
+				struct sysdev_attribute *attr,
 				const char *buf,
 			       size_t count)
 {
 	return arch_cpu_probe(buf, count);
 }
 
-static ssize_t cpu_release_store(struct class *class,
-				struct class_attribute *attr,
+static ssize_t cpu_release_store(struct sys_device *dev,
+				struct sysdev_attribute *attr,
 				const char *buf,
 				 size_t count)
 {
 	return arch_cpu_release(buf, count);
 }
 
-static CLASS_ATTR(probe, S_IWUSR, NULL, cpu_probe_store);
-static CLASS_ATTR(release, S_IWUSR, NULL, cpu_release_store);
+static SYSDEV_ATTR(probe, S_IWUSR, NULL, cpu_probe_store);
+static SYSDEV_ATTR(release, S_IWUSR, NULL, cpu_release_store);
 #endif /* CONFIG_ARCH_CPU_PROBE_RELEASE */
 
 #else /* ... !CONFIG_HOTPLUG_CPU */
@@ -261,8 +261,8 @@ int __init cpu_dev_init(void)
 
 static struct sysdev_class_attribute *cpu_sysdev_class_attrs[] = {
 #ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
-	&class_attr_probe.attr,
-	&class_attr_release.attr,
+	&attr_probe,
+	&attr_release,
 #endif
 	&cpu_attrs[0].attr,
 	&cpu_attrs[1].attr,
-- 
1.7.0.1

