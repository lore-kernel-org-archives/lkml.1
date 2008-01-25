Return-Path: <linux-kernel-owner+w=401wt.eu-S1762545AbYAYHlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762545AbYAYHlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758192AbYAYHTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:19:06 -0500
Received: from ns.suse.de ([195.135.220.2]:52998 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759284AbYAYHTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:19:04 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Mike Halcrow <mhalcrow@us.ibm.com>,
       Phillip Hellewell <phillip@hellewell.homeip.net>
Subject: [PATCH 076/196] ecryptfs: remove version_str file from sysfs
Date: Thu, 24 Jan 2008 23:10:14 -0800
Message-Id: <1201245134-4876-76-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file violates the one-value-per-file sysfs rule.

If you all want it added back, please do something like a per-feature
file to show what is present and what isn't.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Mike Halcrow <mhalcrow@us.ibm.com>
Cc: Phillip Hellewell <phillip@hellewell.homeip.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ecryptfs/main.c |   43 -------------------------------------------
 1 files changed, 0 insertions(+), 43 deletions(-)

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 6ded37b..d984eac 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -744,51 +744,8 @@ static ssize_t version_show(struct kobject *kobj,
 
 static struct kobj_attribute version_attr = __ATTR_RO(version);
 
-static struct ecryptfs_version_str_map_elem {
-	u32 flag;
-	char *str;
-} ecryptfs_version_str_map[] = {
-	{ECRYPTFS_VERSIONING_PASSPHRASE, "passphrase"},
-	{ECRYPTFS_VERSIONING_PUBKEY, "pubkey"},
-	{ECRYPTFS_VERSIONING_PLAINTEXT_PASSTHROUGH, "plaintext passthrough"},
-	{ECRYPTFS_VERSIONING_POLICY, "policy"},
-	{ECRYPTFS_VERSIONING_XATTR, "metadata in extended attribute"},
-	{ECRYPTFS_VERSIONING_MULTKEY, "multiple keys per file"}
-};
-
-static ssize_t version_str_show(struct kobject *kobj,
-				struct kobj_attribute *attr, char *buff)
-{
-	int i;
-	int remaining = PAGE_SIZE;
-	int total_written = 0;
-
-	buff[0] = '\0';
-	for (i = 0; i < ARRAY_SIZE(ecryptfs_version_str_map); i++) {
-		int entry_size;
-
-		if (!(ECRYPTFS_VERSIONING_MASK
-		      & ecryptfs_version_str_map[i].flag))
-			continue;
-		entry_size = strlen(ecryptfs_version_str_map[i].str);
-		if ((entry_size + 2) > remaining)
-			goto out;
-		memcpy(buff, ecryptfs_version_str_map[i].str, entry_size);
-		buff[entry_size++] = '\n';
-		buff[entry_size] = '\0';
-		buff += entry_size;
-		total_written += entry_size;
-		remaining -= entry_size;
-	}
-out:
-	return total_written;
-}
-
-static struct kobj_attribute version_attr_str = __ATTR_RO(version_str);
-
 static struct attribute *attributes[] = {
 	&version_attr.attr,
-	&version_attr_str.attr,
 	NULL,
 };
 
-- 
1.5.3.8

