Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbYKMXi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbYKMXi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 18:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbYKMXiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 18:38:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45166 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbYKMXiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 18:38:19 -0500
Subject: [PATCH] capabilities: define get_vfs_caps_from_disk when file caps
 are not enabled
From: Eric Paris <eparis@redhat.com>
To: jmorris@namei.org
Cc: linux-kernel@vger.kernel.org, serue@us.ibm.com, morgan@kernel.org
Content-Type: text/plain
Date: Thu, 13 Nov 2008 18:37:25 -0500
Message-Id: <1226619445.3353.71.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_SECURITY_FILE_CAPABILITIES is not set the audit system may
try to call into the capabilities function vfs_cap_from_file.  This
patch defines that function so kernels can build and work.

Signed-off-by: Eric Paris <eparis@redhat.com>

---

 security/commoncap.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index 0b88160..574a70b 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -337,6 +337,12 @@ int cap_inode_killpriv(struct dentry *dentry)
 	return 0;
 }
 
+int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data *cpu_caps)
+{
+	memset(cpu_caps, 0, sizeof(struct cpu_vfs_cap_data));
+	return -ENODATA;
+}
+
 static inline int get_file_caps(struct linux_binprm *bprm)
 {
 	bprm_clear_caps(bprm);


