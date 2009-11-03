Return-Path: <linux-kernel-owner+w=401wt.eu-S1753161AbZKCL5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbZKCL5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 06:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbZKCL5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 06:57:23 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:40749 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbZKCL5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 06:57:18 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 05/13] sysfs: Simplify iattr time assignments
Date: Tue,  3 Nov 2009 03:57:01 -0800
Message-Id: <1257249429-12384-5-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m13a4vbz8r.fsf@fess.ebiederm.org>
References: <m13a4vbz8r.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

The granularity of sysfs time when we keep it is 1 ns.  Which
when passed to timestamp_trunc results in a nop.  So remove
the unnecessary function call making sysfs_setattr slightly
easier to read.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/inode.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 8a08250..fed7a74 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -103,14 +103,11 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
 		if (ia_valid & ATTR_GID)
 			iattrs->ia_gid = iattr->ia_gid;
 		if (ia_valid & ATTR_ATIME)
-			iattrs->ia_atime = timespec_trunc(iattr->ia_atime,
-					inode->i_sb->s_time_gran);
+			iattrs->ia_atime = iattr->ia_atime;
 		if (ia_valid & ATTR_MTIME)
-			iattrs->ia_mtime = timespec_trunc(iattr->ia_mtime,
-					inode->i_sb->s_time_gran);
+			iattrs->ia_mtime = iattr->ia_mtime;
 		if (ia_valid & ATTR_CTIME)
-			iattrs->ia_ctime = timespec_trunc(iattr->ia_ctime,
-					inode->i_sb->s_time_gran);
+			iattrs->ia_ctime = iattr->ia_ctime;
 		if (ia_valid & ATTR_MODE) {
 			umode_t mode = iattr->ia_mode;
 
-- 
1.6.5.2.143.g8cc62

