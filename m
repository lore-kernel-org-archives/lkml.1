Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795AbZEUTqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbZEUTqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 15:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbZEUTqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 15:46:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41059 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613AbZEUTqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 15:46:06 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH] IMA: Add __init notation to ima functions
To: linux-kernel@vger.kernel.org
Cc: jmorris@namei.org, zohar@linux.vnet.ibm.com, safford@watson.ibm.com,
       eparis@redhat.com
Date: Thu, 21 May 2009 15:43:32 -0400
Message-ID: <20090521194332.4971.4854.stgit@dhcp231-142.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A number of IMA functions only used during init are not marked with __init.
Add those notations so they are freed automatically.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 security/integrity/ima/ima_crypto.c |    4 ++--
 security/integrity/ima/ima_fs.c     |    2 +-
 security/integrity/ima/ima_iint.c   |    2 +-
 security/integrity/ima/ima_init.c   |    4 ++--
 security/integrity/ima/ima_policy.c |    2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 50d572b..63003a6 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -103,7 +103,7 @@ int ima_calc_template_hash(int template_len, void *template, char *digest)
 	return rc;
 }
 
-static void ima_pcrread(int idx, u8 *pcr)
+static void __init ima_pcrread(int idx, u8 *pcr)
 {
 	if (!ima_used_chip)
 		return;
@@ -115,7 +115,7 @@ static void ima_pcrread(int idx, u8 *pcr)
 /*
  * Calculate the boot aggregate hash
  */
-int ima_calc_boot_aggregate(char *digest)
+int __init ima_calc_boot_aggregate(char *digest)
 {
 	struct hash_desc desc;
 	struct scatterlist sg;
diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index 2a829da..6bfc7ea 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -319,7 +319,7 @@ static struct file_operations ima_measure_policy_ops = {
 	.release = ima_release_policy
 };
 
-int ima_fs_init(void)
+int __init ima_fs_init(void)
 {
 	ima_dir = securityfs_create_dir("ima", NULL);
 	if (IS_ERR(ima_dir))
diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
index ec79f1e..b8dd693 100644
--- a/security/integrity/ima/ima_iint.c
+++ b/security/integrity/ima/ima_iint.c
@@ -196,7 +196,7 @@ static void init_once(void *foo)
 	kref_set(&iint->refcount, 1);
 }
 
-void ima_iintcache_init(void)
+void __init ima_iintcache_init(void)
 {
 	iint_cache =
 	    kmem_cache_create("iint_cache", sizeof(struct ima_iint_cache), 0,
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
index 0b0bb8c..a40da7a 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -38,7 +38,7 @@ int ima_used_chip;
  * a different value.) Violations add a zero entry to the measurement
  * list and extend the aggregate PCR value with ff...ff's.
  */
-static void ima_add_boot_aggregate(void)
+static void __init ima_add_boot_aggregate(void)
 {
 	struct ima_template_entry *entry;
 	const char *op = "add_boot_aggregate";
@@ -71,7 +71,7 @@ err_out:
 			    audit_cause, result, 0);
 }
 
-int ima_init(void)
+int __init ima_init(void)
 {
 	u8 pcr_i[IMA_DIGEST_SIZE];
 	int rc;
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 31d677f..fd72d77 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -160,7 +160,7 @@ int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask)
  * ima_measure points to either the measure_default_rules or the
  * the new measure_policy_rules.
  */
-void ima_init_policy(void)
+void __init ima_init_policy(void)
 {
 	int i;
 

