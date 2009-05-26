Return-Path: <linux-kernel-owner+w=401wt.eu-S1761495AbZE0AA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761495AbZE0AA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 20:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbZEZXzC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:55:02 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38621 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289AbZEZXyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:54:54 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org
Cc: Huang Ying <ying.huang@intel.com>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 26/31] x86: MCE: Export MCE severities coverage via debugfs
Date: Wed, 27 May 2009 01:54:28 +0200
Message-Id: <b464e1eb871500ad8f4f6e5e5f6d394aec97e037.1243381848.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <650bd32edc1814f1f792a07de9c5efebefc9c0b3.1243381848.git.ak@linux.intel.com>
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org>
 <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
 <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com>
 <6c6d1f8bbbd2312884dca5a5c75aa5f5a87dae4b.1243381848.git.ak@linux.intel.com>
 <1623cd9a1c77d35fc2044d72c4bfa1246e67a1c0.1243381848.git.ak@linux.intel.com>
 <723b3fe4e35063b123cee9658c24267287eeac07.1243381848.git.ak@linux.intel.com>
 <0301db6d6dabb8bcfaffe76a907a5036646c207d.1243381848.git.ak@linux.intel.com>
 <abf61c300dec40b8e93bb5ae7154a0633c682799.1243381848.git.ak@linux.intel.com>
 <23417423c34ad949f53ebc947af8d18672a79a40.1243381848.git.ak@linux.intel.com>
 <347567c2ace55b336b1a43a67323ff8b86b80243.1243381848.git.ak@linux.intel.com>
 <3e29698799ad2c02429613323897a6e61a0a7d01.1243381848.git.ak@linux.intel.com>
 <34082fc262bae2f910f1a940622173445aea72cd.1243381848.git.ak@linux.intel.com>
 <c3a768c37edad55939c6f9391001fb95e658ffe6.1243381848.git.ak@linux.intel.com>
 <37501061dc5d5581fefcaff92c2606e39cc61913.1243381848.git.ak@linux.intel.com>
 <10e478c24139e29e7e74529edd694858ec2fb7ea.1243381848.git.ak@linux.intel.com>
 <a541b2bc620d04dd777acd27a37f564ec757fe8b.1243381848.git.ak@linux.intel.com>
 <abfc8311c5aff38314860d82db449c6c62e9e34d.1243381848.git.ak@linux.intel.com>
 <b55d8c3d2842ee10f4b06f17cc2658f81b4f7b4e.1243381848.git.ak@linux.intel.com>
 <7efad2e5492abb8f94577a81c2ca397a968064d7.1243381848.git.ak@linux.intel.com>
 <0f7e10122c48b7988b1676be5e7fc75f2c561215.1243381848.git.ak@linux.intel.com>
 <314f7c278aaaa41854bf4f0837a4ca6126160fc8.1243381848.git.ak@linux.intel.com>
 <ecbed09ba385129558d6341f6a48c64edaa164b4.1243381848.git.ak@linux.intel.com>
 <d9664a5ed1cdbfcd7888c7c7114619494114d4ab.1243381848.git.ak@linux.intel.com>
 <172ffa34ba8bc6a493e26f7e97fb7239f906b4e8.1243381848.git.ak@linux.intel.com>
 <e224e71ae8e2b578d4b4a0a079eea963445eaf91.1243381848.git.ak@linux.intel.com>
 <650bd32edc1814f1f792a07de9c5efebefc9c0b3.1243381848.git.ak@linux.intel.com>
In-Reply-To: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
References: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

The MCE severity judgement code is data-driven, so code coverage tools such as
gcov can not be used for measuring coverage. Instead a dedicated coverage
mechanism is implemented.  The kernel keeps track of rules executed
and reports them in debugfs.

This is useful for increasing coverage of the mce-test testsuite.

Right now it's unconditionally enabled because it's very little code.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce-severity.c |   83 +++++++++++++++++++++++++++++
 1 files changed, 83 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index 4f4d2ca..ff0807f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -10,6 +10,9 @@
  * Author: Andi Kleen
  */
 #include <linux/kernel.h>
+#include <linux/seq_file.h>
+#include <linux/init.h>
+#include <linux/debugfs.h>
 #include <asm/mce.h>
 
 #include "mce-internal.h"
@@ -37,6 +40,7 @@ static struct severity {
 	unsigned char mcgres;
 	unsigned char ser;
 	unsigned char context;
+	unsigned char covered;
 	char *msg;
 } severities[] = {
 #define KERNEL .context = IN_KERNEL
@@ -126,6 +130,7 @@ int mce_severity(struct mce *a, int tolerant, char **msg)
 			continue;
 		if (msg)
 			*msg = s->msg;
+		s->covered = 1;
 		if (s->sev >= MCE_UC_SEVERITY && ctx == IN_KERNEL) {
 			if (panic_on_oops || tolerant < 1)
 				return MCE_PANIC_SEVERITY;
@@ -133,3 +138,81 @@ int mce_severity(struct mce *a, int tolerant, char **msg)
 		return s->sev;
 	}
 }
+
+static void *s_start(struct seq_file *f, loff_t *pos)
+{
+	if (*pos >= ARRAY_SIZE(severities))
+		return NULL;
+	return &severities[*pos];
+}
+
+static void *s_next(struct seq_file *f, void *data, loff_t *pos)
+{
+	if (++(*pos) >= ARRAY_SIZE(severities))
+		return NULL;
+	return &severities[*pos];
+}
+
+static void s_stop(struct seq_file *f, void *data)
+{
+}
+
+static int s_show(struct seq_file *f, void *data)
+{
+	struct severity *ser = data;
+	seq_printf(f, "%d\t%s\n", ser->covered, ser->msg);
+	return 0;
+}
+
+static const struct seq_operations severities_seq_ops = {
+	.start	= s_start,
+	.next	= s_next,
+	.stop	= s_stop,
+	.show	= s_show,
+};
+
+static int severities_coverage_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &severities_seq_ops);
+}
+
+static ssize_t severities_coverage_write(struct file *file,
+					 const char __user *ubuf,
+					 size_t count, loff_t *ppos)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(severities); i++)
+		severities[i].covered = 0;
+	return count;
+}
+
+static const struct file_operations severities_coverage_fops = {
+	.open		= severities_coverage_open,
+	.release	= seq_release,
+	.read		= seq_read,
+	.write		= severities_coverage_write,
+};
+
+static int __init severities_debugfs_init(void)
+{
+	struct dentry *dmce = NULL, *fseverities_coverage = NULL;
+
+	dmce = debugfs_create_dir("mce", NULL);
+	if (dmce == NULL)
+		goto err_out;
+	fseverities_coverage = debugfs_create_file("severities-coverage",
+						   0444, dmce, NULL,
+						   &severities_coverage_fops);
+	if (fseverities_coverage == NULL)
+		goto err_out;
+
+	return 0;
+
+err_out:
+	if (fseverities_coverage)
+		debugfs_remove(fseverities_coverage);
+	if (dmce)
+		debugfs_remove(dmce);
+	return -ENOMEM;
+}
+late_initcall(severities_debugfs_init);
-- 
1.6.0.2

