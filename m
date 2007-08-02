Return-Path: <linux-kernel-owner+w=401wt.eu-S1759138AbXHBRXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138AbXHBRXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 13:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757248AbXHBRXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 13:23:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41732 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756376AbXHBRXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 13:23:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc1-mm2: Fix crash in sysfs_hash_and_remove
Date: Thu, 2 Aug 2007 19:31:57 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       Greg KH <greg@kroah.com>
References: <20070731230932.a9459617.akpm@linux-foundation.org>
In-Reply-To: <20070731230932.a9459617.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708021931.58123.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

My test box crashes during suspend, while the nonboot CPUs are being disabled,
because sysfs_hash_and_remove() doesn't check if dir_sd passed to it is not
NULL.  Fix it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 fs/sysfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.23-rc1-mm2/fs/sysfs/inode.c
===================================================================
--- linux-2.6.23-rc1-mm2.orig/fs/sysfs/inode.c
+++ linux-2.6.23-rc1-mm2/fs/sysfs/inode.c
@@ -191,6 +191,8 @@ int sysfs_hash_and_remove(struct kobject
 	struct sysfs_addrm_cxt acxt;
 	struct sysfs_dirent **pos, *sd;
 
+	if (!dir_sd)
+		return -ENOENT;
 	sysfs_addrm_start(&acxt, dir_sd);
 	if (!sysfs_resolve_for_remove(kobj, &acxt.parent_sd))
 		goto addrm_finish;
