Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbYBYBtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbYBYBtt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 20:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753506AbYBYBtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 20:49:41 -0500
Received: from el-out-1112.google.com ([209.85.162.183]:27360 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbYBYBtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 20:49:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=e+WS8eNLW53op7ZgoZop5zovOLSENS5EnuTAG8WPV4m/fAjnPENXpcJ+lHdDubT5PWOjRMVXT8P9EwyseiP1cwaCX5fx3WWeiYeVJcTzuVmRCArJnsHbPl/hR9TRe8wIdmzmOu5MYg5RBUlxHUCwD4VRPVWKzbUEECQweztyyNQ=
Subject: [PATCH] md: fix integer as NULL pointer warnings in md.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 24 Feb 2008 17:49:44 -0800
Message-Id: <1203904184.1767.16.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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



