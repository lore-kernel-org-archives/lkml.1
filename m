Return-Path: <linux-kernel-owner+w=401wt.eu-S1753561AbZI2R3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbZI2R3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 13:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbZI2R3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 13:29:16 -0400
Received: from iksaif.net ([88.191.73.63]:39136 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819AbZI2R3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 13:29:15 -0400
From: Corentin Chary <corentincj@iksaif.net>
To: dedekind1@gmail.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 2/2] UBIFS: Use ubi_open_volume_path() in open_ubi()
Date: Tue, 29 Sep 2009 19:29:47 +0200
Message-Id: <1254245387-14629-2-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <1254245387-14629-1-git-send-email-corentincj@iksaif.net>
References: <1254234457.3778.84.camel@localhost>
 <1254245387-14629-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed to use $ mount /dev/ubi0_0 /mnt/nand
You'll also need a recent libblkid with UBI and UBIFS
support.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 fs/ubifs/super.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 7e2b3d4..146289b 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1847,6 +1847,7 @@ const struct super_operations ubifs_super_operations = {
  * o ubiY      - UBI device number 0, volume Y;
  * o ubiX:NAME - mount UBI device X, volume with name NAME;
  * o ubi:NAME  - mount UBI device 0, volume with name NAME.
+ * o PATH      - For example /dev/ubi0_0
  *
  * Alternative '!' separator may be used instead of ':' (because some shells
  * like busybox may interpret ':' as an NFS host name separator). This function
@@ -1855,9 +1856,15 @@ const struct super_operations ubifs_super_operations = {
  */
 static struct ubi_volume_desc *open_ubi(const char *name, int mode)
 {
+	struct ubi_volume_desc *ubi;
 	int dev, vol;
 	char *endptr;
 
+	/* path method */
+	ubi = ubi_open_volume_path(name, mode);
+	if (!IS_ERR(ubi))
+		return ubi;
+
 	if (name[0] != 'u' || name[1] != 'b' || name[2] != 'i')
 		return ERR_PTR(-EINVAL);
 
-- 
1.6.5.rc1

