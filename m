Return-Path: <linux-kernel-owner+w=401wt.eu-S1757831AbYBYBra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831AbYBYBra (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 20:47:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbYBYBrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 20:47:19 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:10566 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbYBYBrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 20:47:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SLGkgPqj6IuQNWJ1+XLL/ggz9JyvFc/2O0q9/ruiaXFjh10RQ1B+TPsPaZ+PBu1VGV6kVtwYbx5db2hSmsDmCxtfvdLS+w6l0Cn8zWpLkTSfUfZGoGDx8+ynRiYhG/9PiZZmMtoZLnnB1QknbXRMuqMEEf51B6wSRpvR4DP1TIg=
Subject: [PATCH] smack: fix integer as NULL pointer warning in smack_lsm.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 24 Feb 2008 17:47:23 -0800
Message-Id: <1203904043.1767.14.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

security/smack/smack_lsm.c:1257:16: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 security/smack/smack_lsm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 770eb06..40010fa 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1254,7 +1254,7 @@ static void smack_set_catset(char *catset, struct netlbl_lsm_secattr *sap)
 	int rc;
 	int byte;
 
-	if (catset == 0)
+	if (!catset)
 		return;
 
 	sap->flags |= NETLBL_SECATTR_MLS_CAT;
-- 
1.5.4.2.200.g99e75


>From 8c1fd96327f5c99c68b44da78ae8a5ac650f78f2 Mon Sep 17 00:00:00 2001
From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Sun, 24 Feb 2008 17:27:20 -0800
Subject: [PATCH] md: fix integer as NULL pointer warnings in md.c

drivers/md/md.c:734:16: warning: Using plain integer as NULL pointer
drivers/md/md.c:1115:16: warning: Using plain integer as NULL pointer

Add some braces to match the else-block as well.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/md/md.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7da6ec2..2879f60 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -731,9 +731,9 @@ static int super_90_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version
 	else
 		rdev->desc_nr = sb->this_disk.number;
 
-	if (refdev == 0)
+	if (!refdev) {
 		ret = 1;
-	else {
+	} else {
 		__u64 ev1, ev2;
 		mdp_super_t *refsb = (mdp_super_t*)page_address(refdev->sb_page);
 		if (!uuid_equal(refsb, sb)) {
@@ -1112,9 +1112,9 @@ static int super_1_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version)
 	else
 		rdev->desc_nr = le32_to_cpu(sb->dev_number);
 
-	if (refdev == 0)
+	if (!refdev) {
 		ret = 1;
-	else {
+	} else {
 		__u64 ev1, ev2;
 		struct mdp_superblock_1 *refsb = 
 			(struct mdp_superblock_1*)page_address(refdev->sb_page);
-- 
1.5.4.2.200.g99e75



