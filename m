Return-Path: <linux-kernel-owner+w=401wt.eu-S1756968AbZBKU0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968AbZBKU0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 15:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756309AbZBKU0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 15:26:05 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:42684 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214AbZBKU0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 15:26:04 -0500
Date: Wed, 11 Feb 2009 13:26:01 -0700
From: Alex Chiang <achiang@hp.com>
To: gregkh@suse.de
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] sysfs: sysfs_add_one tells you _where_ the duplicate file
	is
Message-ID: <20090211202601.GC3402@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, gregkh@suse.de,
	linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Give a better clue about where we might be creating duplicate
files by displaying the parent's name as well.

Signed-off-by: Alex Chiang <achiang@hp.com>
---
It would be nice to get a full path, but simply printing out the
parent is cheap and more useful than what we have now.

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 82d3b79..5828d1d 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -459,7 +459,8 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 
 	ret = __sysfs_add_one(acxt, sd);
 	WARN(ret == -EEXIST, KERN_WARNING "sysfs: duplicate filename '%s' "
-		       "can not be created\n", sd->s_name);
+		       "can not be created in %s\n",
+		       sd->s_name, acxt->parent_sd->s_name);
 	return ret;
 }
 
